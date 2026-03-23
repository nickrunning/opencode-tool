#!/usr/bin/env bash
set -e

REPO_URL="https://raw.githubusercontent.com/nickrunning/opencode-tool/master/oc"
INSTALL_DIR="${HOME}/.local/bin"
INSTALL_PATH="${INSTALL_DIR}/oc"

echo "==> Installing oc to ${INSTALL_PATH}"

mkdir -p "${INSTALL_DIR}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd)"
if [ -f "${SCRIPT_DIR}/oc" ]; then
    ln -sf "${SCRIPT_DIR}/oc" "${INSTALL_PATH}"
    echo "    Symlinked: ${INSTALL_PATH} -> ${SCRIPT_DIR}/oc"
else
    curl -fsSL "${REPO_URL}" -o "${INSTALL_PATH}"
    chmod +x "${INSTALL_PATH}"
    echo "    Downloaded to: ${INSTALL_PATH}"
fi

if ! echo "${PATH}" | tr ':' '\n' | grep -qx "${INSTALL_DIR}"; then
    echo "    ⚠ ${INSTALL_DIR} is not in PATH. Add it manually:"
    echo "      export PATH=\"${INSTALL_DIR}:\$PATH\""
fi

OMO_FUNC='omo() { if [ "$1" = "on" ]; then oc plugin enable oh-my-opencode; elif [ "$1" = "off" ]; then oc plugin disable oh-my-opencode; else oc plugin list; fi; }'

add_omo() {
    local rc="$1"
    if [ ! -f "${rc}" ]; then
        return
    fi
    if grep -qF 'omo()' "${rc}" 2>/dev/null; then
        echo "    omo() already exists in ${rc}"
        return
    fi
    printf '\n# opencode\n%s\n' "${OMO_FUNC}" >> "${rc}"
    echo "    Added omo() to ${rc}"
}

add_omo "${HOME}/.bashrc"
add_omo "${HOME}/.zshrc"

echo "==> Done!"
echo ""
echo "  oc help         Show all commands"
echo "  omo on/off      Toggle oh-my-opencode plugin"
echo ""
echo "  Reload your shell or run: source ~/.bashrc  (or source ~/.zshrc)"
