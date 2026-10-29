#!/usr/bin/env bash
source "$(dirname "$0")/00-common.sh"

log "repository di terze parti"
$SUDO dnf -y install dnf-plugins-core curl

FEDORA="$(rpm -E %fedora)"

write_repo() {
    $SUDO tee "/etc/yum.repos.d/$1.repo" >/dev/null
    $SUDO chmod 644 "/etc/yum.repos.d/$1.repo"
}

if ! rpm -q rpmfusion-free-release >/dev/null 2>&1; then
    $SUDO dnf -y install \
        "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA}.noarch.rpm" \
        "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA}.noarch.rpm"
fi

$SUDO rpm --import https://packages.microsoft.com/keys/microsoft.asc || true
write_repo vscode <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
autorefresh=1
type=rpm-md
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

$SUDO rpm --import https://dl.google.com/linux/linux_signing_key.pub || true
write_repo google-chrome <<'EOF'
[google-chrome]
name=google-chrome
baseurl=https://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl.google.com/linux/linux_signing_key.pub
EOF

write_repo tailscale <<'EOF'
[tailscale-stable]
name=Tailscale stable
baseurl=https://pkgs.tailscale.com/stable/fedora/$basearch
enabled=1
type=rpm-md
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://pkgs.tailscale.com/stable/fedora/repo.gpg
EOF

write_repo mise <<'EOF'
[mise]
name=mise
baseurl=https://mise.jdx.dev/rpm
enabled=1
gpgcheck=1
gpgkey=https://mise.jdx.dev/gpg-key.pub
EOF

$SUDO rpm --import https://packages.adoptium.net/artifactory/api/gpg/key/public || true
write_repo adoptium-temurin-java-repository <<'EOF'
[adoptium-temurin-java-repository]
name=Adoptium
baseurl=https://packages.adoptium.net/artifactory/rpm/fedora/$releasever/$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.adoptium.net/artifactory/api/gpg/key/public
EOF

write_repo antigravity <<'EOF'
[antigravity-rpm]
name=Antigravity RPM Repository
baseurl=https://us-central1-yum.pkg.dev/projects/antigravity-auto-updater-dev/antigravity-rpm
enabled=1
gpgcheck=0
EOF

$SUDO dnf -y copr enable atim/lazygit phracek/PyCharm || warn "COPR non abilitati"
$SUDO dnf -y makecache || true
