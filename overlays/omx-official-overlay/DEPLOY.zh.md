# 部署 OMX 官方兼容 Overlay

本文档说明如何在**官方安装的 Codex + oh-my-codex** 之上，叠加应用 `overlays/omx-official-overlay/` 这套脱敏后的 overlay。

## 作用范围

这套 overlay 的定位是：

- **叠加在官方安装之上**
- **不替代官方安装**
- **不内置官方包源码副本**

它主要提供：
- WSL 代理 / shell 启动片段
- 脱敏后的 Codex / OMX prompt 与 hook 定制
- 固定版本的 MCP 工具链清单
- 浏览器 MCP wrapper 脚本
- 筛选后的 OMX memory / wiki 知识沉淀

它**不包含**：
- 真实 PAT / secret env
- `auth.json`
- 本机日志、sqlite、history 等运行态文件
- 官方 `oh-my-codex` 的打包源码副本

## 前置条件

在应用 overlay 之前，请先完成：

1. 正常安装 Codex
2. 正常安装官方 `oh-my-codex`
3. 确认 Node / npm 可用
4. 如果在 WSL 中使用，确认你本机的代理入口确实可达（overlay 中默认使用 `127.0.0.1:6984`）

建议的官方基线安装：

```bash
npm install -g @openai/codex oh-my-codex
omx setup
omx doctor
```

## 必须本地创建的文件

你需要在本机创建真实的 GitHub PAT 文件，并且**不要提交到仓库**：

```bash
mkdir -p ~/.codex/secrets
cp overlay/.codex/secrets/github-mcp.env.example ~/.codex/secrets/github-mcp.env
chmod 600 ~/.codex/secrets/github-mcp.env
```

然后编辑：

```bash
~/.codex/secrets/github-mcp.env
```

把占位符替换成你真实的 token。

如果你使用自定义 OpenAI-compatible provider，还需要在以下文件里补上正确的 provider base URL：

```bash
overlay/.codex/config.toml
```

你也可以在 overlay 应用完成后，再到本机的：

```bash
~/.codex/config.toml
```

里修改。

## 应用 overlay

如果这个 overlay 位于更大的仓库中，请先进入该 overlay 目录：

```bash
cd overlays/omx-official-overlay
```

然后执行：

```bash
scripts/apply-overlay.sh
```

这个脚本会：
- 将 overlay 文件复制到你的 `$HOME`
- 把 `__HOME__` 占位符替换为你当前真实的 `$HOME`
- 修复 wrapper / self-heal 脚本的可执行权限
- 在 `~/.local/share/codex-mcp-tools` 下安装固定版本 MCP 依赖
- 执行 `omx-self-heal`
- 刷新 Playwright 与 chrome-devtools 的独立浏览器副本（如果可用）

## WSL 专属步骤

如果你在 WSL 中使用，并且想启用 overlay 中约定的 mirrored networking / autoProxy 行为，请手动检查：

```bash
overlay/.wslconfig.example
```

然后把它复制到 Windows 用户目录下：

```text
C:\\Users\\<你的用户名>\\.wslconfig
```

接着在 Windows 中执行：

```powershell
wsl --shutdown
```

再重新打开一个新的 WSL 会话。

## 部署后的检查

打开一个新的 shell，让 `~/.profile` 重新生效，然后检查：

```bash
env | grep -iE '^(http|https|all|no)_proxy='
echo ${GITHUB_PAT_TOKEN:+GITHUB_PAT_TOKEN_OK}
codex mcp list
```

建议继续验证：

```bash
env DOCKER_MCP_IN_CONTAINER=1 docker mcp gateway run --dry-run | head
```

并在一个全新的 Codex 会话中确认这些 MCP 正常：
- GitHub MCP
- Docker MCP
- Playwright
- chrome-devtools

## 升级与维护建议

这套 overlay 的目标是：

- 保持官方 OMX 的主安装方式不变
- 只把本地兼容层和经验层单独叠加进去

如果官方 OMX 或固定版本 MCP 包发生变化，建议：

1. 重新执行：
   ```bash
   scripts/apply-overlay.sh
   ```
2. 让 `~/.local/bin/omx-self-heal` 刷新稳定 symlink
3. 检查 wrapper 的执行权限与 dedicated browser 副本是否仍正常

如果 GitHub / browser MCP 启动再次异常：
- 先开一个新 shell
- 再检查 proxy / token env
- 然后重新执行 overlay 安装脚本

## 安全说明

- 任何曾经出现在聊天、日志或截图里的 PAT，都应该视为已泄露并撤销。
- 不要把真实 secret 放入这个 overlay 树。
- `~/.codex/secrets/github-mcp.env` 必须只保留在本机。
