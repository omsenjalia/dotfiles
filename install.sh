#!/usr/bin/env bash
# =============================================================================
# install.sh — Automated Dotfiles Installer (stow method)
# =============================================================================
# Repository : omsenjalia/dotfiles (upstream: Matt-FTW/dotfiles)
# Docs       : https://dotfiles-docs.vercel.app/getting-started/installation.html
#
# Usage      : bash install.sh
# Re-runnable: Yes — idempotent (--needed skips already-installed packages)
# =============================================================================

set -euo pipefail

# --------------- Colours & helpers -------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

info()    { echo -e "${CYAN}[INFO]${NC}  $*"; }
success() { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERR]${NC}   $*"; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_FILE="${SCRIPT_DIR}/packages.txt"
DOTFILES_REPO="https://github.com/omsenjalia/dotfiles.git"
DOTFILES_DIR="${HOME}/dotfiles"
ICON_URL="https://github.com/ljmill/catppuccin-icons/releases/download/v0.2.0/Catppuccin-SE.tar.bz2"

# --------------- Trap: print helpful message on unexpected exit ---------------

trap 'echo -e "\n${RED}${BOLD}[ERR]${NC} Script failed at line ${LINENO}. Check the output above for details." >&2' ERR

# --------------- Pre-flight checks -------------------------------------------

if [[ ! -f /etc/arch-release ]]; then
    error "This script only supports Arch Linux. Aborting."
fi

if [[ $EUID -eq 0 ]]; then
    error "Do not run this script as root. It will prompt for sudo when needed."
fi

if [[ ! -f "$PACKAGES_FILE" ]]; then
    error "packages.txt not found at ${PACKAGES_FILE}. Clone the repo first."
fi

info "Starting dotfiles installation…"

# --------------- 1. Install yay (AUR helper) ---------------------------------

if command -v yay &>/dev/null; then
    success "yay is already installed."
else
    info "Installing yay from AUR…"
    sudo pacman -S --noconfirm --needed base-devel git
    TMPDIR_YAY="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay.git "$TMPDIR_YAY/yay"
    (cd "$TMPDIR_YAY/yay" && makepkg -si --noconfirm)
    rm -rf "$TMPDIR_YAY"
    success "yay installed."
fi

# --------------- 2. Full system upgrade (avoids partial-upgrade issues) ------
#
# On Arch, running `yay -Sy` without `-u` is a "partial upgrade" which can
# break installed packages. Always do a full -Syu before installing anything.

echo ""
read -rp "$(echo -e "${YELLOW}[WARN]${NC}  Run full system upgrade first? (recommended on Arch) [Y/n]: ")" DO_UPGRADE
DO_UPGRADE="${DO_UPGRADE:-Y}"
if [[ "${DO_UPGRADE^^}" == "Y" ]]; then
    info "Running full system upgrade…"
    yay -Syu --noconfirm
    success "System upgraded."
else
    warn "Skipping system upgrade — ensure your system is up to date to avoid conflicts."
fi

# --------------- 3. Install stow ---------------------------------------------

if command -v stow &>/dev/null; then
    success "stow is already installed."
else
    info "Installing GNU stow…"
    yay -S --noconfirm --needed stow
    success "stow installed."
fi

# --------------- 4. Install all packages from packages.txt -------------------

info "Installing packages from packages.txt…"
# Read packages, strip comments and blank lines
mapfile -t PACKAGES < <(grep -vE '^\s*(#|$)' "$PACKAGES_FILE")

if [[ ${#PACKAGES[@]} -eq 0 ]]; then
    error "No packages found in packages.txt."
fi

info "  → ${#PACKAGES[@]} packages to install (already-installed will be skipped)."
yay -S --noconfirm --needed "${PACKAGES[@]}"
success "All packages installed."

# --------------- 5. GPU drivers (interactive choice) -------------------------

echo ""
echo -e "${BOLD}GPU Driver Installation${NC}"
echo "  1) AMD    (open-source)"
echo "  2) Nvidia (proprietary)"
echo "  3) Intel  (open-source)"
echo "  4) Skip   (drivers already installed)"
echo ""
read -rp "Select GPU driver [1-4]: " GPU_CHOICE

case "${GPU_CHOICE}" in
    1)
        info "Installing AMD drivers…"
        yay -S --noconfirm --needed \
            xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon vulkan-tools \
            opencl-clover-mesa lib32-opencl-clover-mesa mesa lib32-mesa \
            vdpauinfo clinfo
        success "AMD drivers installed."
        ;;
    2)
        info "Installing Nvidia drivers…"
        yay -S --noconfirm --needed \
            nvidia nvidia-utils nvidia-settings opencl-nvidia lib32-nvidia-utils \
            lib32-opencl-nvidia cuda vdpauinfo clinfo
        success "Nvidia drivers installed."
        ;;
    3)
        info "Installing Intel drivers…"
        yay -S --noconfirm --needed \
            xf86-video-intel vulkan-intel lib32-vulkan-intel vulkan-tools \
            libva-intel-driver lib32-libva-intel-driver mesa lib32-mesa \
            mesa-vdpau lib32-mesa-vdpau
        success "Intel drivers installed."
        ;;
    4|*)
        warn "Skipping GPU driver installation."
        ;;
esac

# --------------- 6. Icon theme (Catppuccin-SE) -------------------------------

ICON_DIR="${HOME}/.local/share/icons"
if [[ -d "${ICON_DIR}/Catppuccin-SE" ]]; then
    success "Catppuccin-SE icon theme already installed."
else
    info "Installing Catppuccin-SE icon theme…"
    mkdir -p "$ICON_DIR"
    TMPDIR_ICON="$(mktemp -d)"
    curl -Lf -o "${TMPDIR_ICON}/Catppuccin-SE.tar.bz2" "$ICON_URL"
    tar -xf "${TMPDIR_ICON}/Catppuccin-SE.tar.bz2" -C "$TMPDIR_ICON"
    mv "${TMPDIR_ICON}/Catppuccin-SE" "$ICON_DIR/"
    rm -rf "$TMPDIR_ICON"
    success "Catppuccin-SE icon theme installed."
fi

# --------------- 7. Refresh font cache ---------------------------------------

info "Refreshing font cache…"
fc-cache -fv >/dev/null 2>&1
success "Font cache refreshed."

# --------------- 8. Enable audio services ------------------------------------

info "Enabling Pipewire & WirePlumber…"
systemctl --user enable --now pipewire.service   2>/dev/null || true
systemctl --user enable --now wireplumber.service 2>/dev/null || true
success "Audio services enabled."

# --------------- 9. Clone dotfiles -------------------------------------------

if [[ -d "$DOTFILES_DIR/.git" ]]; then
    warn "Dotfiles repo already exists at ${DOTFILES_DIR}. Pulling latest changes…"
    git -C "$DOTFILES_DIR" pull --ff-only || warn "git pull had conflicts — resolve manually."
else
    info "Cloning dotfiles to ${DOTFILES_DIR}…"
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    success "Dotfiles cloned."
fi

# --------------- 10. Backup conflicting files before stow --------------------
#
# stow refuses to overwrite real files (non-symlinks). We scan for conflicts
# and move them to a timestamped backup directory so stow can proceed cleanly.

BACKUP_DIR="${HOME}/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
CONFLICT_COUNT=0

info "Scanning for conflicting files in ${HOME}…"
while IFS= read -r -d '' src; do
    rel="${src#"$DOTFILES_DIR"/}"
    dest="${HOME}/${rel}"
    # Skip if destination doesn't exist OR is already a symlink (already stow-managed)
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        if [[ $CONFLICT_COUNT -eq 0 ]]; then
            mkdir -p "$BACKUP_DIR"
            warn "Conflicts found — backing up to ${BACKUP_DIR}"
        fi
        dest_parent="$(dirname "${BACKUP_DIR}/${rel}")"
        mkdir -p "$dest_parent"
        mv "$dest" "${BACKUP_DIR}/${rel}"
        warn "  Backed up: ~/${rel}"
        (( CONFLICT_COUNT++ )) || true
    fi
done < <(find "$DOTFILES_DIR" \
    -mindepth 1 \
    -not -path '*/.git/*' \
    -not -name '.git' \
    -not -name 'install.sh' \
    -not -name 'packages.txt' \
    -not -name 'README*' \
    -not -name 'LICENSE*' \
    -not -name '.gitignore' \
    -not -name '.gitmodules' \
    -type f \
    -print0)

if [[ $CONFLICT_COUNT -gt 0 ]]; then
    success "${CONFLICT_COUNT} file(s) backed up. Restore anytime from ${BACKUP_DIR}"
else
    success "No conflicts found."
fi

# --------------- 11. Apply dotfiles via stow ---------------------------------
#
# --restow      re-links already-stowed packages (safe on re-runs)
# --no-folding  never collapses a directory into a single symlink — prevents
#               entire dirs like ~/.config being replaced with one link
# --ignore      skip repo meta-files that should not land in $HOME

info "Applying dotfiles with stow…"
cd "$DOTFILES_DIR"
stow \
    --target="$HOME" \
    --restow \
    --no-folding \
    --ignore='\.git' \
    --ignore='install\.sh' \
    --ignore='packages\.txt' \
    --ignore='README.*' \
    --ignore='LICENSE.*' \
    --ignore='\.gitignore' \
    --ignore='\.gitmodules' \
    --verbose=1 \
    . && success "Dotfiles symlinked into ${HOME}." \
      || error "stow reported errors above — fix conflicts and re-run."

# --------------- 12. Run detect-monitors -------------------------------------

DETECT_SCRIPT="${HOME}/.local/bin/detect-monitors"
if [[ -x "$DETECT_SCRIPT" ]]; then
    info "Running detect-monitors…"
    "$DETECT_SCRIPT"
    success "Monitor configuration generated."
else
    warn "detect-monitors script not found or not executable."
    warn "After logging into Hyprland, run:  detect-monitors"
fi

# --------------- 13. Set fish as default shell (optional) --------------------

FISH_PATH="$(command -v fish 2>/dev/null || true)"
if [[ -n "$FISH_PATH" ]] && [[ "$SHELL" != "$FISH_PATH" ]]; then
    info "Setting fish as default shell…"
    if ! grep -qxF "$FISH_PATH" /etc/shells; then
        echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
    fi
    chsh -s "$FISH_PATH"
    success "Default shell set to fish."
else
    success "Fish is already the default shell (or not installed)."
fi

# --------------- Done --------------------------------------------------------

echo ""
echo -e "${GREEN}${BOLD}══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}  ✅  Installation complete!${NC}"
echo -e "${GREEN}${BOLD}══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "  ${CYAN}Next steps:${NC}"
echo -e "    1. Log out of your current session."
echo -e "    2. Select ${BOLD}Hyprland${NC} from your display manager."
echo -e "    3. Log in and enjoy! 🎉"
echo ""
echo -e "  ${YELLOW}Tip:${NC} If monitors aren't detected correctly, run:"
echo -e "       ${BOLD}detect-monitors${NC}"
echo ""
echo -e "  ${YELLOW}Tip:${NC} To remove all stow symlinks later, run:"
echo -e "       ${BOLD}cd ~/dotfiles && stow --delete --target=\$HOME .${NC}"
echo ""
