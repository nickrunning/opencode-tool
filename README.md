# oc — OpenCode 配置命令行工具

[English](README_EN.md)

快速切换 OpenCode 配置项的 CLI 工具。直接操作 JSONC 配置文件，完整保留注释、缩进和 trailing commas。

## 为什么需要 `omo` 命令？

[oh-my-openagent](https://github.com/code-yeongyu/oh-my-openagent)（omo）插件为 OpenCode 提供了强大的增强能力，但代价是显著增加系统提示词的体积。在 `build` 和 `plan` 等轻量模式下，过大的系统提示词会拖慢响应、浪费 token，体验不佳。

`omo` 命令让你在终端一键切换：需要完整能力时 `omo on`，切到轻量模式前 `omo off`，无需手动编辑配置文件。

```bash
omo off                         # 关闭 omo → 轻量模式，适合 build/plan
omo on                          # 开启 omo → 完整增强模式
omo                             # 查看当前插件状态
```

## 安装

一键安装（克隆后本地执行）：

```bash
git clone https://github.com/nickrunning/opencode-tool.git
cd opencode-tool
bash install.sh
```

或远程安装：

```bash
curl -fsSL https://raw.githubusercontent.com/nickrunning/opencode-tool/master/install.sh | bash
```

安装脚本会自动：
- 创建 `~/.local/bin/oc`（本地为软链接，远程为下载）
- 在 `~/.bashrc` 和 `~/.zshrc` 中添加 `omo` 快捷函数

## 用法

### 插件管理

```bash
oc plugin list                  # 列出所有插件及启用/禁用状态
oc plugin toggle <name>         # 切换插件（注释 ↔ 取消注释）
oc plugin enable <name>         # 启用指定插件
oc plugin disable <name>        # 禁用指定插件
```

### Provider 管理

```bash
oc provider list                # 列出所有 provider 及状态
oc provider toggle <name>       # 在 disabled_providers 中添加/移除
oc provider enable <name>       # 启用（从 disabled_providers 移除）
oc provider disable <name>      # 禁用（添加到 disabled_providers）
```

### 模型切换

```bash
oc model                        # 查看当前模型
oc model list                   # 列出所有可用模型
oc model set <model_id>         # 切换主模型
oc model set-small <model_id>   # 切换小模型
oc model <model_id>             # 快速切换主模型（简写）
```

## 设计

- **行级文本操作**：所有写入操作直接编辑文本行，不做 parse → dump，因此注释、空行、缩进风格原样保留
- **JSONC 感知解析**：只读操作使用状态机式 strip（正确跳过字符串内的 `//`，如 URL），再交给标准 `json.loads`
- **插件 toggle**：通过注释/取消注释 `"plugin"` 数组中的对应行实现
- **Provider toggle**：通过在 `"disabled_providers"` 数组中增删条目实现
- **零依赖**：纯 Python 3 标准库，无需 pip install
