# 架构设计

## 1. 总览

**纯本地优先（local-first）**：所有用户数据存于手机本地 SQLite，无后端服务器，无账号体系（MVP）。

```text
┌────────────────────────────┐
│  Flutter App（iOS / Android）│
│                            │
│  UI 层（features/*）        │
│  ├─ Wallet 钱包首页         │
│  ├─ Policy 保单录入/详情    │
│  ├─ Comparison 报价对比     │
│  └─ Settings 设置/锁屏      │
│                            │
│  数据层（core/db）          │
│  └─ Drift + SQLite         │
│     （SQLCipher 加密为 P2） │
│                            │
│  服务层（core/services）     │
│  ├─ document_storage_service │ 文件保存到本机私有目录
│  └─ policy_extraction_service│ PDF 文本/图片 OCR + 规则提取
│  └─ notification_service     │ 到期前 37 天本地通知（flutter_local_notifications）
│  └─ app_lock_service         │ App 锁偏好持久化（shared_preferences）+ 生物识别/密码验证
│  └─ backup_service           │ 全量数据导出/导入 JSON（open_filex 打开文件、share_plus 分享）
│                            │
│  本地文件（path_provider）  │
│  └─ documents/ 保单文件     │
└────────────────────────────┘
```

## 2. 为什么本地优先

- 数据不出设备，服务器攻破/数据贩卖风险从架构上消除。
- 续保提醒用本地通知，核心流程完全离线可用。
- 隐私是产品差异化卖点（区别于 Canstar/Finder 等云端比较站）。
- MVP 成本最低：无服务器、无运维。

代价与对策：

| 代价 | 对策 |
|---|---|
| 换机/丢失数据 | Phase 2 增加端到端加密备份（可选，1Password 模式） |
| 云端 AI 不可默认使用 | 默认本地 OCR；云端 AI 逐份授权、用完即删 |
| 订阅/多设备账号 | 商业模式确认后再引入最小后端 |
| 真实报价集成 | Phase 3 调研 aggregator/insurer API 后，仅做代理转发，不存明文 |

## 3. 数据库设计（Drift 表）

```text
profiles
  id, display_name, created_at

assets
  id, profile_id FK, type (car/property/pet), name,
  details_json, created_at, updated_at

policies
  id, profile_id FK, asset_id FK (nullable),
  insurance_type (car/home/landlord/health/pet),
  insurer, policy_number, policy_type,
  insurer_key (nullable，指向保险公司目录，null 表示自定义),
  premium_cents, excess_cents, sum_insured_cents,
  roadside_assist / windscreen_cover / replacement_value_cents (车险),
  building_insured_cents / contents_insured_cents / additional_insured_json (房屋/房东险),
  last_year_* 系列字段（去年保单快照，用于年度对比）,
  start_date, end_date (policy expiry date),
  renewal_date (legacy，界面已不再使用),
  status (active/cancelled/expired), notes,
  created_at, updated_at

quotes
  id, policy_id FK, insurer,
  premium_cents, excess_cents, sum_insured_cents,
  cover_summary, is_mock, source_file,
  created_at

documents
  id, policy_id FK, kind (renewal/previous/quote/other),
  file_name, local_path, extracted_json,
  created_at
```

业务约束：

- `insurance_type == health` 时，每用户最多 1 份 `status == active` 的保单（DAO 层强制）。
- 金额一律 `_cents` 整数列。
- `asset_id` 允许为空（健康险、或主体未填写的情况）。
- `insurer_key` 关联 `InsurerCatalog`（静态目录）；自定义保险公司为 null。

## 4.6 保单文件导入

- 依赖：`file_picker`（选文件）、`pdf_text`（数字 PDF 文本提取）、
  `google_mlkit_text_recognition`（图片 OCR）。
- `DocumentStorageService`：把选中的文件复制到
  `<应用文档目录>/policy_documents/`，并在 `documents` 表记录路径。
- `PolicyDataExtractor`（纯 Dart，可单测）：从文字提取字段的规则引擎。
- `LocalPolicyExtractionService`：PDF/图片 → 文字 → 结构化字段，全设备端。
- 后续云端 AI 提取实现同一接口，逐份授权后插拔。

## 4.7 到期提醒

- 保单保存时，若状态为 active 且填写了 Policy Expiry Date，则在**到期前
  30 / 15 / 7 / 3 天上午 9 点**各触发一条本地通知（4 条，通知 ID 按保单 × 序号生成）。
- 删除保单、将保单改为非 active、或更新到期日时，自动取消旧提醒并按新日期重排；
  App 启动时也会根据所有有效保单重排通知（`resyncAll`）。
- 通知完全在设备端调度（`flutter_local_notifications` + `timezone`），无服务器、无推送服务。

## 4.8 去年 vs 今年对比

- 每张保单在录入时可填写「去年的保单信息」（可选）：去年保费，以及按险种区分的
  保障细节（车险：roadside/windscreen/车 replacement value；房屋/房东险：
  building insured / contents insured / 额外保额列表）。
- 保单详情页展示对比卡：保费用红/绿标出涨跌金额与百分比；
  保障项显示「去年 → 今年」变化。
- 额外保额以 JSON 列表存储（`additional_insured_json`），支持多条「名称 + 金额」。
- 数据模型已为后续 AI 提取预留字段（去年保费等可直接由 renewal 文档自动填充）。

## 4.9 App 锁与免责声明

- `AppLockService` 用 shared_preferences 持久化开关；`AppLockGate` 在启动时
  检查开关，开启则先显示锁屏，验证生物识别或设备密码后才进入主界面。
- 设置页「Privacy & Disclaimers」打开独立页面：本地存储说明、非保险建议声明、
  mock 报价声明、健康信息敏感声明等（上架所需的隐私政策底稿）。

## 4.10 文档管理与本地备份

- 保单文件可点击打开（`open_filex`）、可删除（同时删除本地文件与数据库记录）。
- 「Export backup」导出全部结构化数据（profiles/assets/policies/quotes/documents）
  为 JSON 并通过系统分享保存；「Import backup」校验后整库替换恢复，恢复后自动重排到期提醒。
- 备份文件不含文档二进制本身（仅保留文件名/路径元数据），文件可重新上传；
  未来可升级为加密 ZIP 备份（端到端加密）。

## 4.5 保险公司目录与理赔跳转

- `core/models/insurer_catalog.dart`：18 家澳洲保险公司的名称 + 按险种区分的
  claim 页面链接（已核实），支持「其他 / 自定义」。
- 保单详情页 **Make a Claim** 按钮通过 `url_launcher` 打开系统浏览器跳转理赔页面。
- 目录是启动数据而非数据库表，方便发版更新；如需用户自建目录再迁移到数据库。

## 4. 模块划分（lib/）

```text
lib/
├── main.dart               # 入口：初始化数据库
├── app.dart                # MaterialApp + 主题
├── core/
│   ├── db/
│   │   ├── tables.dart     # Drift 表定义
│   │   ├── app_database.dart
│   │   └── policy_dao.dart # 业务读写 + 健康险单保单约束
│   ├── models/
│   │   └── insurance_type.dart  # 险种枚举/图标/文案
│   ├── theme/app_theme.dart
│   └── utils/formatters.dart    # 金额/日期格式化
└── features/
    ├── wallet/             # 钱包首页（5 险种分组）
    ├── policy/             # 保单列表/表单/详情
    ├── comparison/         # 报价对比（mock）
    └── settings/           # 设置与隐私说明
```

## 5. 未来演进（预留接口）

1. **加密备份**：`backup_service.dart` 接口，Phase 2 实现 E2EE 导出/恢复。
2. **云端 AI**：`ai_service.dart` 接口，默认本地实现；云端实现必须逐份授权。
3. **真实报价**：`quote_source.dart` 接口，mock 实现与未来 aggregator 实现可切换。
4. **通知**：`notification_service.dart` 接口，MVP 本地通知，未来可换远程推送。
