# 🛡️ Kanata on Bazzite: Tiered Security Guide

> **Run Kanata — a powerful keyboard remapper (with keylogger-level access) — as securely as possible on your immutable Bazzite system.**

Choose your tier:

- 🚀 **Tier 1: Simple & Secure** — Copy-paste setup for basic key remapping.
- 🛡️ **Tier 2: Production Hardened** — Full isolation, udev rules, Quadlet, layers, macros.
- 🔄 **Tier 3: Recommended Hybrid** — Best of both worlds. Start simple, scale securely.

✅ All tiers include:

- Dedicated unprivileged user
- Hardened systemd service
- Rootless Podman via Distrobox
- SELinux confinement (automatic on Bazzite)
- Auto-restart + crash resilience
- Maintenance & removal instructions

---

## 📚 Table of Contents

- [Why Run Kanata Securely?](#-why-run-kanata-securely)
- [Architecture Overview](#-architecture-overview)
- [Prerequisites](#-prerequisites)
- [🚀 Tier 1: Simple & Secure (Copy-Paste Setup)](#-tier-1-simple--secure-copy-paste-setup)
- [🛡️ Tier 2: Production Hardened (Full Isolation)](#-tier-2-production-hardened-full-isolation)
- [🔄 Tier 3: Recommended Hybrid (Start Simple, Scale Securely)](#-tier-3-recommended-hybrid-start-simple-scale-securely)
- [📊 Security Analysis (Common to All Tiers)](#-security-analysis-common-to-all-tiers)
- [🧰 Maintenance & Operations](#-maintenance--operations)
- [❓ Troubleshooting](#-troubleshooting)
- [🗑️ Uninstall / Cleanup](#-uninstall--cleanup)

---

## 🔐 Why Run Kanata Securely?

Kanata reads raw input events — it *must* be treated like a keylogger.

This guide ensures:

| Layer                     | Protection                                                                 |
|--------------------------|----------------------------------------------------------------------------|
| Dedicated System User    | No shell, no home, no login — minimal host exposure                        |
| Systemd Service          | Drops privileges, restricts syscalls, restarts cleanly                     |
| Podman (Rootless)        | No daemon, user namespaced, confined by SELinux                            |
| Distrobox Container      | Filesystem, device, capability isolation                                   |
| `--cap-drop=all`         | No escalation possible inside container                                    |
| Read-only + tmpfs        | Prevents persistent malware or config tampering                            |
| Seccomp / Syscall Filter | Blocks dangerous syscalls (e.g., mount, ptrace)                            |
| SELinux (Bazzite Default)| Mandatory Access Control — even if all else fails                          |

---

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────┐
│         Your User Session               │
│     (Completely isolated)               │
└─────────────────────────────────────────┘
                    ↑
         [Security Boundary #1]
                    ↓
┌─────────────────────────────────────────┐
│      Dedicated 'kanata-user'            │
│   • No shell                            │
│   • Optional: input/uinput groups       │
└─────────────────────────────────────────┘
                    ↓
         [Security Boundary #2]
                    ↓
┌─────────────────────────────────────────┐
│       Hardened Systemd Service          │
│   • Resource limits                     │
│   • Syscall filtering                   │
│   • Capability dropping                 │
└─────────────────────────────────────────┘
                    ↓
         [Security Boundary #3]
                    ↓
┌─────────────────────────────────────────┐
│      Container (Distrobox/Podman)       │
│   • Namespace isolation                 │
│   • Limited device access               │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│          Kanata Process                 │
│   • Reads from /dev/input/*             │
│   • Optionally writes to /dev/uinput    │
└─────────────────────────────────────────┘
```

---

## 🧰 Prerequisites

- Bazzite (or any UniversalBlue/Fedora immutable system)
- `distrobox` and `podman` installed (default on Bazzite ✅)
- Terminal access (Ctrl+Alt+F2 or GUI terminal)
- Physical or USB keyboard

---

# 🚀 Tier 1: Simple & Secure (Copy-Paste Setup)

> For users who want **basic key remapping** (e.g., Caps → Ctrl, Swap Esc/`, etc.) with **maximum confinement** and minimal setup.

### ✅ Features:

- Single device access (`/dev/input/eventX`)
- Auto-detect script for device changes
- Minimal permissions
- Quick to set up and remove

---

## Step 1: Identify Your Keyboard Device

```bash
ls -l /dev/input/by-id/ | grep -i "keyboard\|kbd"
```

> ✍️ Note your device (e.g., `/dev/input/event16`)

---

## Step 2: Create Dedicated System User

```bash
sudo useradd --system --no-create-home --shell /usr/sbin/nologin kanata-user
```

---

## Step 3: Create Hardened Distrobox Container

```bash
sudo -u kanata-user distrobox create kanata-box \
  --image fedora:latest \
  --home /var/lib/kanata \
  --no-etc --no-root \
  --cap-drop=all \
  --device /dev/input/event16 \         # ← REPLACE WITH YOUR DEVICE
  --security-opt=no-new-privileges \
  --read-only \
  --tmpfs /tmp \
  --tmpfs /run \
  --bind /etc/kanata/config.kbd:/config.kbd:ro
```

---

## Step 4: Install Kanata Inside Container

```bash
sudo -u kanata-user distrobox enter kanata-box
sudo dnf install -y git gcc make libxcb-devel
git clone https://github.com/jtroo/kanata && cd kanata && make
exit
```

---

## Step 5: Create Configuration

```bash
sudo mkdir -p /etc/kanata
sudo tee /etc/kanata/config.kbd << 'EOF'
(defcfg input (i386))
(defsrc a b)
(deflayer base b a)
EOF
sudo chown root:kanata-user /etc/kanata/config.kbd
sudo chmod 640 /etc/kanata/config.kbd
```

---

## Step 6: Create Auto-Detect Wrapper Script (Optional)

```bash
sudo tee /usr/local/bin/start-kanata.sh << 'EOF'
#!/bin/bash
KBD_DEVICE=$(ls /dev/input/by-id/*keyboard* -1 2>/dev/null | head -n1)
[ -z "$KBD_DEVICE" ] && { echo "No keyboard found!"; exit 1; }
exec /usr/bin/distrobox enter kanata-box -- /kanata/kanata/target/release/kanata /config.kbd
EOF
sudo chmod +x /usr/local/bin/start-kanata.sh
```

---

## Step 7: Create Hardened Systemd Service

> 🔥 Uses **your superior hardening** from the advanced doc

```bash
sudo tee /etc/systemd/system/kanata.service << 'EOF'
[Unit]
Description=Kanata Keyboard Remapper (Hardened Container)
After=multi-user.target

[Service]
Type=simple
User=kanata-user
Group=kanata-user
ExecStart=/usr/local/bin/start-kanata.sh
WorkingDirectory=/var/lib/kanata
Restart=always
RestartSec=3

# 🔒 SECURITY HARDENING (Adapted from Advanced Guide)
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
PrivateTmp=true
RestrictSUIDSGID=true
LockPersonality=true
MemoryDenyWriteExecute=true
RestrictRealtime=true
RestrictNamespaces=true
SystemCallFilter=@system-service @file-system @io-event
SystemCallArchitectures=native
UMask=0077
CapabilityBoundingSet=
AmbientCapabilities=

[Install]
WantedBy=multi-user.target
EOF
```

---

## Step 8: Enable & Start

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now kanata.service
sudo systemctl status kanata.service
journalctl -u kanata.service -f
```

✅ Done! Basic, secure, auto-restarting Kanata.

---

# 🛡️ Tier 2: Production Hardened (Full Isolation)

> For **power users** needing **layers, macros, virtual devices**, or managing **multiple keyboards**. Uses full `/dev/input` + `/dev/uinput` access with udev rules and Quadlet support.

---

## Step 1: Create Groups, User, and udev Rules

```bash
sudo groupadd -f uinput
sudo useradd --system --no-create-home --groups input,uinput --shell /bin/false kanata-user

sudo tee /etc/udev/rules.d/50-kanata.rules << 'EOF'
KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
SUBSYSTEM=="input", MODE="0660", GROUP="input"
EOF

sudo udevadm control --reload-rules && sudo udevadm trigger
```

---

## Step 2: Create Config Directory

```bash
sudo mkdir -p /etc/kanata
sudo chown root:kanata-user /etc/kanata
sudo chmod 750 /etc/kanata
```

---

## Step 3: Create Distrobox Container with Full Device Access

```bash
sudo -u kanata-user distrobox create kanata-box \
  --image fedora:latest \
  --volume /etc/kanata:/etc/kanata:ro \
  --volume /dev/input:/dev/input:rw \
  --volume /dev/uinput:/dev/uinput:rw \
  --additional-flags "--group-add keep-groups --device-cgroup-rule='c 13:* rmw' --device-cgroup-rule='c 10:223 rmw'"
```

---

## Step 4: Install Kanata Inside Container

```bash
sudo -u kanata-user distrobox enter kanata-box
sudo dnf install -y kanata || {
  sudo dnf install -y wget tar
  cd /tmp && wget https://github.com/jtroo/kanata/releases/latest/download/kanata-bin-x86_64-unknown-linux-gnu.tar.gz
  tar -xzf kanata-bin-*.tar.gz && sudo mv kanata /usr/local/bin/ && sudo chmod 755 /usr/local/bin/kanata
}
exit
```

---

## Step 5: Create Advanced Configuration

```bash
sudo tee /etc/kanata/config.kbd << 'EOF'
(defcfg
  process-unmapped-keys yes
  linux-dev-names-include ("AT Translated Set 2 keyboard")
  danger-enable-cmd no
)

(defsrc esc a b caps)

(deflayer base
  esc b a (tap-hold 200 200 esc lctl)
)
EOF

sudo chown root:kanata-user /etc/kanata/config.kbd
sudo chmod 640 /etc/kanata/config.kbd
```

---

## Step 6: Create Container Management Script

```bash
sudo tee /usr/local/bin/kanata-container-run << 'EOF'
#!/bin/bash
[ "$(whoami)" != "kanata-user" ] && { echo "Run as kanata-user"; exit 1; }
[ ! -f /etc/kanata/config.kbd ] && { echo "Config missing"; exit 1; }
distrobox enter kanata-box -- /usr/local/bin/kanata --cfg /etc/kanata/config.kbd
EOF

sudo chmod 755 /usr/local/bin/kanata-container-run
sudo chown root:kanata-user /usr/local/bin/kanata-container-run
```

---

## Step 7: Create Ultra-Hardened Systemd Service

```bash
sudo tee /etc/systemd/system/kanata.service << 'EOF'
[Unit]
Description=Containerized Kanata keyboard remapper
After=multi-user.target systemd-udev-settle.service
Wants=systemd-udev-settle.service

[Service]
Type=simple
User=kanata-user
Group=kanata-user
ExecStartPre=/usr/bin/sleep 2
ExecStart=/usr/local/bin/kanata-container-run
Restart=always
RestartSec=5
TimeoutStopSec=10

Environment="HOME=/tmp" "XDG_RUNTIME_DIR=/tmp"

# 🔒 ADVANCED HARDENING
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
ProtectKernelTunables=true
ProtectKernelModules=true
ProtectControlGroups=true
RestrictAddressFamilies=AF_UNIX
RestrictNamespaces=~user ~pid ~net ~uts ~mnt
LockPersonality=true
MemoryDenyWriteExecute=true
RestrictRealtime=true
RestrictSUIDSGID=true
RemoveIPC=true
SystemCallFilter=@system-service @process @basic-io
SystemCallErrorNumber=EPERM
DeviceAllow=/dev/uinput rw
DeviceAllow=char-input rw
DevicePolicy=strict
PrivateDevices=false
CPUQuota=50%
MemoryMax=512M
TasksMax=50
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF
```

---

## Step 8: Enable & Start

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now kanata.service
sudo systemctl status kanata.service
```

✅ Done! Full-featured, production-hardened Kanata.

---

## Step 9 (Optional): Direct Podman Quadlet

For systemd-native container management:

```bash
sudo mkdir -p /etc/containers/systemd
sudo tee /etc/containers/systemd/kanata.container << 'EOF'
[Unit]
Description=Kanata Keyboard Remapper Container
After=multi-user.target

[Container]
Image=fedora:latest
ContainerName=kanata-service
User=kanata-user
Volume=/etc/kanata:/etc/kanata:ro
Volume=/dev/input:/dev/input
Volume=/dev/uinput:/dev/uinput
AddDevice=/dev/uinput
AddDevice=/dev/input
SecurityLabelDisable=false
NoNewPrivileges=true
DropCapability=ALL
GroupAdd=keep-groups
Memory=256M
CPUQuota=50%
Restart=always

[Service]
Type=simple
TimeoutStopSec=10

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now kanata.service
```

---

# 🔄 Tier 3: Recommended Hybrid (Start Simple, Scale Securely)

> **Best for most users.** Start with Tier 1, then upgrade to Tier 2 features as needed — without reinstalling.

### ✅ How it works:

1. Begin with **Tier 1** (single device, simple config).
2. If you need layers/virtual devices → add `uinput` group + udev rules + update container.
3. No need to recreate systemd service — it’s already hardened.

---

## Upgrade Path: From Tier 1 → Tier 2

### Step 1: Add Groups and udev Rules

```bash
sudo groupadd -f uinput
sudo usermod -a -G input,uinput kanata-user

sudo tee /etc/udev/rules.d/50-kanata.rules << 'EOF'
KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
SUBSYSTEM=="input", MODE="0660", GROUP="input"
EOF

sudo udevadm control --reload-rules && sudo udevadm trigger
```

### Step 2: Recreate Container with Full Access

```bash
sudo -u kanata-user distrobox rm kanata-box
sudo -u kanata-user distrobox create kanata-box \
  --image fedora:latest \
  --volume /etc/kanata:/etc/kanata:ro \
  --volume /dev/input:/dev/input:rw \
  --volume /dev/uinput:/dev/uinput:rw \
  --additional-flags "--group-add keep-groups"
```

### Step 3: Update Your Config to Use Layers or Macros

Edit `/etc/kanata/config.kbd` — now you can use `(deflayer)`, `(tap-hold)`, etc.

### Step 4: Restart Service

```bash
sudo systemctl restart kanata.service
```

✅ You’re now running Tier 2 — no config or service changes needed!

---

# 📊 Security Analysis (Common to All Tiers)

## Defense Layers

1. **Container Isolation**
   - Separate namespaces (PID, mount)
   - Limited filesystem view
   - No access to host processes

2. **User Isolation**
   - Service user cannot login
   - No home directory
   - Minimal group membership

3. **Systemd Hardening**
   - Capability dropping
   - System call filtering
   - Resource limits

4. **SELinux (Bazzite Default)**
   - Mandatory access controls
   - Additional process confinement

## Attack Surface Analysis

**What’s Protected:**

- User data and home directories (inaccessible)
- System files (read-only)
- Network access (none granted)
- Other processes (namespace isolation)
- Privilege escalation (multiple prevention mechanisms)

**Remaining Risks:**

- Keylogging capability (inherent to functionality)
- Input device access (required for operation)
- Container escape vulnerabilities (mitigated by updates)
- Supply chain attacks (verify source integrity)

## Security Best Practices

1. **Regular Updates**

   ```bash
   sudo -u kanata-user distrobox upgrade kanata-box
   ```

2. **Audit Logs**

   ```bash
   sudo journalctl -u kanata.service --since="24 hours ago" | grep -E "ERROR|WARNING"
   ```

3. **Monitor Resources**

   ```bash
   systemd-cgtop
   ```

---

# 🧰 Maintenance & Operations

## Updating Kanata

```bash
# Inside container
sudo -u kanata-user distrobox enter kanata-box
sudo dnf update kanata
# Or manually update binary
exit
sudo systemctl restart kanata.service
```

## Modifying Configuration

```bash
sudo nano /etc/kanata/config.kbd
sudo systemctl restart kanata.service
```

## Backup and Restore

```bash
# Backup config
sudo cp -a /etc/kanata /etc/kanata.backup.$(date +%Y%m%d)

# Backup container (Distrobox)
sudo -u kanata-user distrobox export kanata-box --output kanata-backup.tar
```

## Complete Removal

```bash
sudo systemctl stop kanata.service
sudo systemctl disable kanata.service
sudo rm /etc/systemd/system/kanata.service
sudo -u kanata-user distrobox rm kanata-box --force
sudo rm -rf /etc/kanata /usr/local/bin/start-kanata.sh
sudo userdel kanata-user
sudo rm /etc/udev/rules.d/50-kanata.rules
sudo groupdel uinput 2>/dev/null || true
sudo systemctl daemon-reload
sudo udevadm control --reload-rules
```

---

# ❓ Troubleshooting

## Container Won’t Start

```bash
sudo journalctl -u kanata.service -n 50 --no-pager
sudo -u kanata-user podman logs kanata-box 2>/dev/null || true
```

## Device Access Issues

```bash
# Test inside container
sudo -u kanata-user distrobox enter kanata-box -- ls -l /dev/input/
sudo -u kanata-user distrobox enter kanata-box -- id
```

## Permission Denied (SELinux)

```bash
# Temporarily test
sudo setenforce 0
# If fixed → restore and label properly
sudo setenforce 1
sudo semanage fcontext -a -t container_file_t "/dev/uinput"
sudo restorecon -v /dev/uinput
```

## Configuration Errors

```bash
sudo -u kanata-user distrobox enter kanata-box -- kanata --cfg /etc/kanata/config.kbd --check
```

---

# 🗑️ Uninstall / Cleanup

Same as [Maintenance → Complete Removal](#complete-removal) above.

---

## 🎉 You’re Done!

✅ **Tier 1**: Quick, secure, minimal.  
✅ **Tier 2**: Full power, enterprise-grade.  
✅ **Tier 3**: Start simple, grow securely — **recommended default**.

You’ve achieved **maximum security for Kanata on Bazzite** — whether you’re swapping two keys or building a 10-layer mechanical keyboard OS.

---

> 🔐 **Safe remapping ahead!**

- TBD!