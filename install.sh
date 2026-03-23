#!/usr/bin/env bash
set -e

REPO_URL="https://raw.githubusercontent.com/nickrunning/opencode-tool/master/oc"
INSTALL_DIR="${HOME}/.local/bin"
INSTALL_PATH="${INSTALL_DIR}/oc"

echo "==> 安装 oc 到 ${INSTALL_PATH}"

mkdir -p "${INSTALL_DIR}"

# 如果在 repo 目录下，用软链接；否则从远程下载
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd)"
if [ -f "${SCRIPT_DIR}/oc" ]; then
    ln -sf "${SCRIPT_DIR}/oc" "${INSTALL_PATH}"
    echo "    已创建软链接: ${INSTALL_PATH} -> ${SCRIPT_DIR}/oc"
else
    curl -fsSL "${REPO_URL}" -o "${INSTALL_PATH}"
    chmod +x "${INSTALL_PATH}"
    echo "    已下载到: ${INSTALL_PATH}"
fi

# 检查 PATH
if ! echo "${PATH}" | tr ':' '\n' | grep -qx "${INSTALL_DIR}"; then
    echo "    ⚠ ${INSTALL_DIR} 不在 PATH 中，请手动添加:"
    echo "      export PATH=\"${INSTALL_DIR}:\$PATH\""
fi

# 添加 omo 函数到 shell rc
OMO_FUNC='omo() { if [ "$1" = "on" ]; then oc plugin enable oh-my-opencode; elif [ "$1" = "off" ]; then oc plugin disable oh-my-opencode; else oc plugin list; fi; }'

add_omo() {
    local rc="$1"
    if [ ! -f "${rc}" ]; then
        return
    fi
    if grep -qF 'omo()' "${rc}" 2>/dev/null; then
        echo "    已存在 omo 函数: ${rc}"
        return
    fi
    printf '\n# opencode\n%s\n' "${OMO_FUNC}" >> "${rc}"
    echo "    已添加 omo 函数: ${rc}"
}

add_omo "${HOME}/.bashrc"
add_omo "${HOME}/.zshrc"

echo "==> 安装完成！"
echo ""
echo "  oc help         查看所有命令"
echo "  omo on/off      快速开关 oh-my-opencode"
echo ""
echo "  重新加载 shell 或执行: source ~/.bashrc  (或 source ~/.zshrc)"
