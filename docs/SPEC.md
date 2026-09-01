# Insurance Profile App — 产品规格

版本：v0.2（2026-08-27） · 基于 ChatGPT 对话共识修订

## 1. 一句话定义

一个澳洲个人保险钱包：记住你的保险档案，跟踪续保日期，解释保单变化，并在续保时帮你用最少操作完成报价对比和决策。

## 2. 支持范围（v0.2 新增）

| 险种 | 支持多保单？ | 保单关联对象 |
|---|---|---|
| Car Insurance 车险 | ✅ 多份 | 多辆车（每车一份） |
| Home Insurance 房屋险 | ✅ 多份 | 多套房产 |
| Landlord Insurance 房东险 | ✅ 多份 | 多套出租房产 |
| Health Insurance 健康险 | ❌ 每用户 1 份有效 | 用户本人 |
| Pet Insurance 宠物险 | ✅ 多份 | 多只宠物 |

> 健康险限制为单份有效保单，历史保单可保留记录。该限制在数据层（DAO）强制校验，UI 同步提示。

## 3. 用户价值与核心流程

### 首次使用（Onboarding）

1. 创建本地档案（姓名/出生日期等，可选填）。
2. 选择要录入的险种。
3. 录入保单主体（车/房产/宠物）和当前保单信息。
4. 设定 Policy Expiry Date（到期日），开启到期前提醒。

### 每年续保流程

1. **到期前 30 / 15 / 7 / 3 天**：共 4 次本地通知提醒（保险公司通常提前
   30 天发送 renewal email；更新/续保新保单后自动按新到期日重排提醒）。
2. 确认信息是否有变化（车、地址、里程、驾驶员）。
3. **续保前 60–45 天**：上传本年度 renewal notice 与去年保单。
4. AI 提取关键字段（保费、excess、保额、保障变化）。
5. 展示"去年 vs 今年"变化摘要。
6. 上传/录入 1–3 份外部报价，做 apples-to-apples 对比。
7. 展示：**最便宜 / excess 最低 / 保障价值最好 / 当前保单**。
8. 用户决策（续、谈价、换保），记录结果供明年对比。

## 4. 数据模型概要

```text
Profile（本地档案）
  └── Assets（保险主体：car / property / pet）
  └── Policies（保单：5 险种，除 health 外可多份）
        ├── Quotes（报价，mock 或用户录入）
        └── Documents（保单文件，本地存储）
              └── Extracted JSON（AI 提取的结构化字段 + 审计）
```

## 5. 保单字段

- 保险公司、保单号、险种类型、保额类型（agreed/market value）
- **保险公司从内置目录选择**（CBA、Allianz、RSPCA、AAMI、Medibank、Bupa 等 18 家），
  也可选择「其他 / 自定义」手动输入。
- 保费、excess、保额（金额一律以**分**存储，避免浮点误差）
- renewal date、起止日期、状态（active/cancelled/expired）
- 可选保障项、主要除外责任、备注

## 5.1 Make a Claim

- 每张保单详情页提供 **Make a Claim** 按钮，直接跳转到该保险公司的在线理赔页面。
- 理赔链接按险种区分（如 CBA 车险与房屋险页面不同），无专属页面时回退到该公司默认理赔页。
- 自定义保险公司未配置链接时按钮禁用并提示。
- 链接来自官方保险公司网站，2026-08 核实；目录文件为
  `app/lib/core/models/insurer_catalog.dart`，可随时增改。

## 5.2 保单文件导入与自动填写

- 保单表单顶部提供「从保单文件自动填写」：选择 PDF / 图片（jpg、png），文件**保存在本机**。
- 数字版 PDF：设备端直接提取文字（无需 OCR）。
- 图片：设备端 OCR（ML Kit / iOS Vision）识别文字。
- 规则引擎（`PolicyDataExtractor`）从文字中提取：保险公司、保单号、保费、excess、
  保额、到期日，并**自动预填表单**，用户核对确认后保存。
- 扫描版 PDF 暂不支持自动识别（提示手动填写）；云端 AI 提取按
  `ai_service` 接口预留，后续可插拔（逐份授权、用完即删）。
- 提取/识别全部在设备端完成，无网络、无费用、无云端上传。

## 6. 报价对比 UX

> ⚠️ **合规提示（2026-08-29）**：澳洲《公司法》下，任何「排序（最便宜/最优）、评分、
> 推荐」都构成**金融产品建议（financial product advice）**；即使是 **general advice**
> 也需要持有 AFSL 或作为持牌保险公司的授权代表（authorised representative）才能提供，
> 并须附一般建议警告（s 949A）与 FSG 披露。结合用户档案做推荐更可能构成 **personal advice**
> （义务更重）。因此本 App 当前**只做信息展示，不做排名、评分或推荐**；是否加入排序/评分
> 功能，必须先完成保险合规律师评审并确定持牌/授权结构。

- 不按价格单一排序。
- 信息展示维度（无意见表达）：Current Policy + 用户自己录入/上传的报价，并排展示事实字段。
- 明确展示保额、excess、主要保障项、可选附加、主要除外责任差异。
- **所有 mock 报价必须标注"示例数据，非真实报价"**。

> 原设计的 Cheapest / Lowest Excess / Best Cover-Value 排序与「Best Cover/Value」评分，
> **暂停开发**，待合规评审后另行决定（见 ROADMAP 决策记录）。

## 6.1 去年 vs 今年对比（年度续保场景）

保单详情页提供「Last year vs this year」对比卡：

| 险种 | 对比字段 |
|---|---|
| 全部 | **Annual premium**（去年 → 今年，显示涨跌金额 + 百分比） |
| Car | Roadside assistance、Windscreen replacement、Replacement value |
| Home / Landlord | Building insured、Contents insured、额外保额（多条「名称 + 金额」） |

- 去年数据为可选填写（保单表单「Last year's policy」区），后续可由 AI 从
  去年 renewal 文档自动提取。
- 保费上涨红色、下降绿色；保障项显示「No → Yes」或金额变化。

## 7. AI 职责（MVP 边界）

✅ 读取并提取 renewal notice / 保单 / 报价文档字段
✅ 检测缺失信息
✅ 检测新旧保单变化
✅ 用通俗语言解释条款（不构成保险建议）
✅ 生成用户可发给保险公司的提问清单

❌ 不虚构/估算真实保费
❌ 不替用户选择保单
❌ 不提供个性化保险建议（除非建立持牌合规结构）
❌ 不自动取消/购买保单
❌ 不未经用户明确授权发送任何通信

## 8. 合规红线

- 定位为 **Information + document analysis + comparison**，不碰 personalized advice。
- 上线任何"推荐/导流"功能前，必须咨询澳洲保险合规律师（AFSL / general advice / referral 佣金边界）。
- 健康险数据属《隐私法》sensitive information，任何云能力上线前必须单独评审。
- 产品原则：不卖数据、最小化收集、透明披露。
