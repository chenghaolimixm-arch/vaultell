# 上架发布指南

## 1. 开发者账号

| 平台 | 账号 | 费用 |
|---|---|---|
| Apple Developer Program | [developer.apple.com](https://developer.apple.com) | 约 A$149/年 |
| Google Play Console | [play.google.com/console](https://play.google.com/console) | 一次性 US$25 |

## 2. 朋友测试

### iOS（TestFlight）

1. 在 Xcode 中用开发者账号签名 App。
2. 上传到 App Store Connect → TestFlight。
3. 内部测试：最多 100 人，无需审核，加 Apple ID 即可。
4. 外部测试：需要 Beta 审核，可发公开链接。

### Android（封闭测试）

1. Google Play Console → 创建应用 → 设置 → 正式版/测试版。
2. 建立"封闭测试"轨道，添加测试者邮箱。
3. 上传 AAB 包，审核通过后测试者可安装。

## 3. 正式发布

- App Store 审核：需隐私政策、截图、App 图标。
- Google Play：需隐私政策、数据安全表单（MVP 填"不收集数据"）。
- 纯本地 App 无账号、无服务器，不触发额外权限说明（除本地通知/生物识别需说明用途）。

## 4. 注意事项

- Mock 报价必须全界面标注"示例数据，非真实保险公司报价"，避免误导用户（商店审核红线）。
- 未来加入云端 AI / 备份后，必须先更新隐私标签与用户授权流程，再发版。
- iOS 构建只能在 macOS 上完成；Android 在 Windows 上即可。

## 5. 个人身份上架（无 ABN）

没有 ABN 也可以上架：

- **Google Play**：注册时选 **Individual（个人）**；税务信息填「没有 ABN」即可。
- **Apple App Store**：注册时选 **Individual（个人）**，不要选 Sole Trader（部分情况下
  会要求 ABN）；公司身份才需要企业注册信息（D-U-N-S）。

影响：发布者显示为个人名字；App 免费/测试阶段无税务影响；隐私政策 ABN 一栏写 "N/A"。

## 6. 个人 → 公司转移（有收入后）

先用个人账号上架验证市场，注册公司后再把 App 转移给公司账号，是澳洲独立开发者
常见且合规的路径。评分、评论、下载量会随 App 一起转移。

### 6.1 转移前的准备

1. **注册公司**：注册 Pty Ltd（公司 + ABN），通常通过会计师或 ASIC 注册服务商办理。
2. **公司开发者账号**：
   - Apple：公司账号需要 D-U-N-S 编号（Apple 免费申请/核实）。
   - Google Play：公司账号同样一次性 US$25。
3. **签署 IP 转让文件**：把 App 代码、品牌、图标的无形资产从个人转让给公司的
   书面协议（IP assignment），由会计师或律师出具。
4. **确认转移条件**：两个账号状态正常、无未完成协议、App 无违规记录。

### 6.2 Apple App Store 转移步骤

1. 公司账号注册完成，并在 App Store Connect 接受所有协议。
2. 在旧账号 App Store Connect → 选择 App → General → App Information → Transfer App。
3. 填写接收账号的 Team ID，按提示确认并提交。
4. 等待 Apple 审核（通常几天到几周），通过后 App 归公司账号所有。

### 6.3 Google Play 转移步骤

1. 公司开发者账号注册完成，并填好税务/收款信息。
2. 旧账号 Play Console → Settings → App access → Transfer app to another developer account。
3. 输入接收账号邮箱并确认。
4. 接收账号在 7 天内确认接收，转移完成。

### 6.4 转移后的收尾

- 更新 [隐私政策](PRIVACY_POLICY.md) 的运营方名称、ABN、联系方式。
- 更新商店收款/税务信息为公司账号。
- 确认收入归属从转移日起算入公司；转移前的收入按个人报税（与会计确认节点）。
- 如需品牌保护，可另行通过 IP Australia 注册商标（与 App 转移相互独立）。

> 提示：转移在任何时候都可行，但用户和评论越少时转移越简单。上述步骤为一般流程，
> 具体条件以 Apple/Google 官方规则为准；涉及税务与知识产权文件时咨询会计师或律师。
