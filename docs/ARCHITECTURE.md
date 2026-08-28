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
  premium_cents, excess_cents, sum_insured_cents,
  renewal_date, start_date, end_date,
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
