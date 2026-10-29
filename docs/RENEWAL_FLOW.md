# v1.1 续保导入方案（Renewal Flow）

> 状态：设计稿，等待 1.0 审核通过后实施。
> 目标版本：v1.1（build 在 1.0 基础上递增）。

## 1. 要解决的问题

现在用户续保时有三个断点：

1. 保单详情页的 **Upload File** 只保存附件，不解析、不更新字段。
2. 新建保单时的 **Import from policy file** 只预填当前年度，不会生成"去年"快照。
3. 去年 vs 今年只能手动录入，续保一次要点很多字段。

目标：用户上传新的续保通知后，自动生成本年度数据，并把原数据保存为"上一年"，
整个流程在设备上完成，不需要服务器。

## 2. 用户流程

### 2.1 入口

保单详情页新增次要按钮 **Renew policy**（放在 Upload File 旁边或操作菜单中）。
原来的 Upload File 保留，语义改为"仅添加文档"。

### 2.2 五步流程

1. **选择文件**：复用现有 file picker，支持 PDF / JPG / PNG。
2. **本机解析**：显示 "Reading on your device…"，不阻塞整个界面。
3. **核对页**：并排展示 Current policy / Renewal notice，逐项显示差异。
4. **确认**：用户可修正任何识别错误的字段，然后点 Apply。
5. **完成**：更新保单、写入 last-year 快照、附上新文件、重排提醒。

### 2.3 核对页字段

| 字段 | 行为 |
|---|---|
| Insurer | 显示；不一致时警告 |
| Policy number | 显示；不一致时询问是"新保单"还是"更新当前保单" |
| Annual premium | 自动填，显示变化金额和百分比 |
| Excess | 自动填 |
| Sum insured | 自动填 |
| Building insured | 房屋/房东险自动填 |
| Contents insured | 房屋/房东险自动填 |
| Roadside assistance | 车险自动填（能识别时） |
| Windscreen cover | 车险自动填（能识别时） |
| Replacement value | 车险自动填（能识别时） |
| Expiry date | 自动填；验证必须是未来日期 |

未识别字段显示 **Not found**，并保留当前值，不写入 0。

## 3. 核心规则

- **绝不静默覆盖**：解析结果必须经过用户确认才写入数据库。
- **缺失不等于零**：`null` 字段保持原值；只有用户明确填写 0 才写入 0。
- **续保与中途变更分开**：
  - 新到期日约等于当前到期日 + 11–13 个月 → 默认为续保，生成 last-year 快照。
  - 其他日期（例如中途调整保额）→ 提示 "This looks like a mid-term change"，
    默认只更新当前值，不生成快照。
- **保单号不同**：默认建议"创建新保单"，由用户确认后才更新现有记录。
- **重复文件**：同文件名+同大小（或文件哈希）已存在时提示，避免重复归档。
- **失败可回退**：OCR 失败或用户取消时不修改任何数据。

## 4. 数据变化

### 4.1 已有字段（直接复用）

当前年度：

- `premiumCents`
- `excessCents`
- `sumInsuredCents`
- `roadsideAssist`
- `windscreenCover`
- `replacementValueCents`
- `buildingInsuredCents`
- `contentsInsuredCents`
- `additionalInsuredJson`
- `startDate` / `endDate`

上一年度：

- `lastYearPremiumCents`
- `lastYearRoadsideAssist`
- `lastYearWindscreenCover`
- `lastYearReplacementValueCents`
- `lastYearBuildingInsuredCents`
- `lastYearContentsInsuredCents`
- `lastYearAdditionalInsuredJson`

### 4.2 需要迁移的新字段

```text
Policies.lastYearExcessCents      INTEGER NOT NULL DEFAULT 0
Policies.lastYearSumInsuredCents  INTEGER NOT NULL DEFAULT 0
```

用于完整的逐年对比。需要提高 Drift schemaVersion 并提供 migration。

可选（v1.1 后期）：

```text
Documents.fileHash  TEXT NULL   -- 重复文件检测
```

## 5. 解析器改动

`ExtractedPolicyData` 增加：

```dart
final int? buildingInsuredCents;
final int? contentsInsuredCents;
final bool? roadsideAssist;
final bool? windscreenCover;
final int? replacementValueCents;
final DateTime? startDate;
final Map<String, String> warnings; // 字段级提示
```

规则：

- 将 `building insured` 与 `contents insured` 分开提取，不再共用一个 sum-insured 结果。
- 车险识别 `roadside`、`windscreen`、`market value` / `agreed value`。
- 优先使用 "policy period / cover from ... to ..." 的结束日期。
- 每个金额字段做合理范围检查（例如 premium > 0 且 < $100,000），
  异常值不自动采用，只在核对页提示。

## 6. 保存流程（事务）

`PolicyDao.renewPolicy(...)` 在一个事务中：

1. 将当前年度字段复制到 lastYear 字段。
2. 写入用户确认后的新年度字段。
3. 更新 startDate / endDate。
4. 更新 `updatedAt`。
5. 添加 Document（kind = `renewal`）。

事务成功后再调用通知服务重排提醒；通知失败不回滚数据，只记录提示。

## 7. 页面与文案

新增页面：`RenewalReviewScreen`

标题：`Review renewal`

按钮：

- `Apply renewal`
- `Cancel`

关键提示：

- `We read this on your device. Check the figures before saving.`
- `Different policy number — create a new policy?`
- `This might be a mid-term change rather than a renewal.`
- `Could not read some fields. They will keep their current values.`

## 8. 测试清单

### 单元测试

- building / contents 分别提取
- roadside / windscreen 识别
- 日期范围取结束日期
- snapshot 映射：current → lastYear 正确
- 缺失字段不覆盖
- 续保 vs 中途变更的日期判断

### 集成 / 手动测试

- Youi 车险续保通知
- CommBank 房屋险续保通知
- 扫描版 PDF（OCR）
- 旋转/模糊图片
- 上传错误保单
- 保单号变化
- 重复上传同一文件
- 确认后提醒时间使用新到期日
- 取消后数据库无变化

## 9. 实施顺序与工作量

| 阶段 | 内容 | 预计 |
|---|---|---|
| 1 | 解析器新字段 + 单元测试 | 1 天 |
| 2 | 数据库迁移 + renewPolicy 事务 | 0.5–1 天 |
| 3 | RenewalReviewScreen + 差异展示 | 1–1.5 天 |
| 4 | 边界情况与真机回归 | 1 天 |

总计约 **3–4.5 个工作日**。

## 10. 不在 v1.1 范围

- 云端 OCR 或服务端解析
- 多年历史（超过一年的快照）
- 自动识别所有保险公司的专有字段
- 自动提交报价或与比价平台对接

以上保留为后续版本。
