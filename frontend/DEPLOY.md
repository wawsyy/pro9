# Vercel 部署指南

## ✅ 部署前检查清单

根据控制台日志，项目已经可以部署：

### 功能状态
- ✅ FHEVM SDK 成功加载和初始化
- ✅ 钱包签名功能正常
- ✅ 解密签名保存成功
- ✅ 所有核心功能运行正常

### 警告说明（非致命）
- ⚠️ Image 尺寸警告：Next.js 图片优化提示，不影响功能
- ⚠️ Lit dev mode：开发模式提示，生产环境会自动优化
- ⚠️ Cross-Origin headers：已配置 `unsafe-none` 以保持兼容性，FHEVM 正常工作
- ⚠️ RelayerSDKLoader：正常的 SDK 加载过程日志

## 🚀 部署步骤

### 1. 准备环境变量

在 Vercel 项目设置中添加以下环境变量：

```
NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID=your_walletconnect_project_id
```

**获取 WalletConnect Project ID：**
1. 访问 [cloud.walletconnect.com](https://cloud.walletconnect.com/)
2. 创建免费账户
3. 创建新项目
4. 复制 Project ID

**注意：** 如果不设置，代码会使用默认值 `"encrypted-mood-demo"`，但建议使用真实的 Project ID。

### 2. 部署到 Vercel

#### 方法 A：通过 Vercel CLI
```bash
cd pro9/frontend
npm install -g vercel
vercel
```

#### 方法 B：通过 Vercel Dashboard
1. 访问 [vercel.com](https://vercel.com)
2. 点击 "New Project"
3. 导入你的 Git 仓库
4. 设置项目：
   - **Framework Preset**: Next.js
   - **Root Directory**: `pro9/frontend`
   - **Build Command**: `npm run build`
   - **Output Directory**: `.next`
5. 添加环境变量（见步骤 1）
6. 点击 "Deploy"

### 3. 验证部署

部署完成后，检查：
- ✅ 网站可以正常访问
- ✅ 钱包连接功能正常
- ✅ FHEVM SDK 加载成功（查看浏览器控制台）
- ✅ 可以提交心情分数
- ✅ 可以请求和解密趋势

## 📝 重要配置说明

### next.config.ts
已配置 Cross-Origin headers 以支持 FHEVM：
```typescript
Cross-Origin-Opener-Policy: unsafe-none
Cross-Origin-Embedder-Policy: unsafe-none
```

### 合约地址
确保 `pro9/frontend/abi/EncryptedMoodDiaryAddresses.ts` 中的 Sepolia 合约地址已更新为：
```typescript
"11155111": { 
  address: "0xf7B6A78531eA4e1a9726D39f56997884db1C0486", 
  chainId: 11155111, 
  chainName: "sepolia" 
}
```

## 🔧 故障排除

### 问题：FHEVM SDK 无法加载
- 检查网络连接
- 确认 Cross-Origin headers 配置正确
- 查看浏览器控制台错误信息

### 问题：钱包无法连接
- 确认 `NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID` 已正确设置
- 检查 Vercel 环境变量是否生效（需要重新部署）

### 问题：合约交互失败
- 确认合约地址正确
- 确认用户已切换到 Sepolia 测试网
- 检查钱包是否有足够的 Sepolia ETH

## 📚 相关链接

- [Vercel 文档](https://vercel.com/docs)
- [Next.js 部署指南](https://nextjs.org/docs/deployment)
- [WalletConnect Cloud](https://cloud.walletconnect.com/)
- [FHEVM 文档](https://docs.zama.ai/fhevm)

