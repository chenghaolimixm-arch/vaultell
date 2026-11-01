# App Review 2.1 回复材料

> 适用：2026-10-30 Guideline 2.1 — Information Needed。
> 无需重新构建 App；回复 Resolution Center 并把同样的内容填入
> App Review Information → Notes。

## 1. 可直接粘贴的英文回复

```text
Hello App Review Team,

Thank you for reviewing Vaultell. The requested information is below.

1. Screen recording
Attached is a screen recording captured on a physical iPhone running the latest
version of iOS. It begins by launching Vaultell from the Home Screen and shows
the typical user flow: adding a policy with the attached sample renewal notice,
viewing the policy details and expiry countdown, comparing this year with last
year, and opening the full privacy policy.

2. Purpose and target audience
Vaultell is a local-first personal insurance wallet for consumers in Australia.
It is for people who hold car, home, landlord or pet insurance and want one
private place to keep policy details, remember renewal dates, and understand
what changed between policy years.

The problem it solves: policy documents are scattered across emails and insurer
portals, renewal dates are easy to miss, and premium changes are difficult to
compare. Vaultell keeps this information on the user's device, sends local
reminders before expiry, and shows a clear year-over-year comparison. It does
not sell insurance, provide advice or recommendations, or connect to insurer
systems.

3. Setting up and accessing the main features
No account, login or purchase is required. All features are available
immediately.

- Launch the app and tap + on any coverage type (for example, Car Insurance).
- Enter details manually, or tap "Import from policy file (on-device)" and
  select the attached sample-renewal-notice.pdf (a scanned-style sample).
- Save the policy, then open it to see policy details, the expiry countdown,
  attached documents and the "Last year vs this year" comparison.
- Settings → Privacy & Disclaimers opens the full privacy statement and a link
  to the hosted privacy policy.

The attached sample-renewal-notice.pdf is fictional and may be used to test the
import flow. Manual entry works without it.

4. External services and tools
- Google ML Kit on-device text recognition: reads text from a document the user
  selects. Images and extracted text are processed on the device; documents are
  not sent to Google or to any server.
- Google Fonts: downloads the Nunito typeface on first launch for display only.
  No policy data is transmitted.
- Apple frameworks: local notifications, Face ID/passcode through Local
  Authentication, and Safari for opening an insurer's claim page.
- There is no backend, no analytics SDK, no advertising SDK, no account system,
  no payment processing, no AI API and no third-party data provider.

5. Regional differences
The app is offered on the Australian App Store only. It is designed for
Australian insurance (AUD, Australian insurers and local terminology). No
features differ by region.

6. Regulated industry
Vaultell is a record-keeping and information tool. It does not provide
financial or insurance advice, recommendations or ratings, does not act as a
broker or agent, and does not sell or connect to insurance products. No
credentials are required. The in-app Privacy & Disclaimers screen and the
hosted privacy policy state this clearly. Any quote figures in the app are
sample data and are labelled as examples.

Additional notes
- There is no account creation, login or account deletion flow.
- There is no public user-generated content, so no reporting or blocking tools
  are required.
- There are no paid features or in-app purchases.
- After the first launch, all core features work offline.

Thank you.
```

## 2. 录屏脚本（约 2–3 分钟，一镜到底）

要求：**物理 iPhone、最新 iOS、从点 App 图标开始、不要剪辑**。

| 时间 | 操作 | 说明 |
|---|---|---|
| 0:00 | 从主屏幕点 Vaultell 图标 | 必须从这里开始 |
| 0:05 | 展示 Insurance Wallet（4 类保险） | 证明 App 可正常启动 |
| 0:12 | 点 Car Insurance 的 + | 进入新增保单 |
| 0:20 | 点 Import from policy file (on-device) | 选择 `sample-renewal-notice.pdf` |
| 0:35 | 展示自动填写的字段 | 保单号、保费、excess、保额、到期日 |
| 0:50 | 选择 Insurer → Other，填写名称并保存 | 完成一笔真实可用的数据 |
| 1:05 | 打开保单详情 | 展示倒计时、文档、Make a Claim |
| 1:20 | 编辑并填写去年保费 | 例如 $1,600，保存 |
| 1:35 | 回到详情看 Last year vs this year | 展示 +$250 / 15.6% |
| 1:50 | 返回 Settings → Privacy & Disclaimers | 证明隐私说明可访问 |
| 2:00 | 点 Read the full privacy policy | 在 Safari 打开 GitHub Pages |
| 2:10 | 返回并结束录制 | 不要剪辑 |

可选加分项：在 0:10 打开飞行模式，完成导入后再关闭，证明核心功能完全离线。
如果飞行模式会影响隐私页链接，就先关掉再打开链接。

## 3. 示例文件

- 文件：[sample-renewal-notice.pdf](../store-assets/sample-renewal-notice.pdf)
- 内容为虚构的 Example Insurance Australia 续保通知，做成纯白底、高对比的扫描件，
  避免矢量 PDF 在部分设备上无法触发 OCR。
- 矢量原稿保留为 [sample-renewal-notice-vector.pdf](../store-assets/sample-renewal-notice-vector.pdf)，
  仅用于排查，不要用这次审核。
- 字段与 App 解析规则对应：policy number、premium、excess、building/contents insured、policy period。

## 4. 提交步骤

1. 用 iPhone 自带屏幕录制（控制中心 → 录屏）完成上述流程。
2. 把录屏和样例 PDF 传到电脑。
3. App Store Connect → 被拒的 1.0 版本 → **Reply to App Review**。
4. 粘贴上面第 1 节的英文回复。
5. 附加：
   - 录屏文件（MP4/MOV，建议 1080p，控制在 50 MB 内）
   - `sample-renewal-notice.pdf`
6. 把同一份说明粘贴到 **App Review Information → Notes**。
7. 发送回复。无需重新上传构建，除非你同时改了代码。

如果录屏超过附件大小限制，上传到 Google Drive（Anyone with the link）或
YouTube（Unlisted），把链接放进回复正文和 Notes。

## 5. 注意事项

- 不要填假账号密码；App 无登录。
- 不要只回复一句"App works"；必须覆盖 Apple 列出的六项。
- 录屏必须来自物理设备，模拟器录屏不合格。
- 如果之后改了 App 代码，需要重新构建并提交对应 build。
