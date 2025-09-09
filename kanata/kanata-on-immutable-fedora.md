# Kanata on Immutable Fedora: Containerized Setup with Distrobox/Podman

This guide provides an enhanced security approach to running Kanata keyboard remapper on Immutable Fedora using container isolation (Distrobox/Podman) combined with a hardened systemd service and dedicated user.

## Table of Contents
- [Kanata on Immutable Fedora: Containerized Setup with Distrobox/Podman](#kanata-on-immutable-fedora-containerized-setup-with-distroboxpodman)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
    - [Why Container + Service User?](#why-container--service-user)
    - [Benefits Over Non-Containerized Approach](#benefits-over-non-containerized-approach)
  - [Architecture Overview](#architecture-overview)
  - [Prerequisites](#prerequisites)
  - [Step 1: Create Security Infrastructure](#step-1-create-security-infrastructure)
    - [Create Groups and Service User](#create-groups-and-service-user)
    - [Create udev Rules](#create-udev-rules)
    - [Create Configuration Directory](#create-configuration-directory)
  - [Step 2: Create Custom Distrobox Container](#step-2-create-custom-distrobox-container)
    - [Option A: Using Distrobox (Recommended for Beginners)](#option-a-using-distrobox-recommended-for-beginners)
    - [Option B: Direct Podman Container (Advanced)](#option-b-direct-podman-container-advanced)
  - [Step 3: Install and Configure Kanata in Container](#step-3-install-and-configure-kanata-in-container)
    - [For Distrobox Container](#for-distrobox-container)
    - [Create Kanata Configuration](#create-kanata-configuration)
  - [Step 4: Create Container Management Script](#step-4-create-container-management-script)
  - [Step 5: Create Hardened Systemd Service](#step-5-create-hardened-systemd-service)
  - [Step 6: Enable and Start Service](#step-6-enable-and-start-service)
  - [Alternative: Direct Podman Approach](#alternative-direct-podman-approach)
    - [Create Podman Quadlet Service](#create-podman-quadlet-service)
  - [Verification and Testing](#verification-and-testing)
    - [Check Container Status](#check-container-status)
    - [Test Key Remapping](#test-key-remapping)
    - [Security Verification](#security-verification)
  - [Troubleshooting](#troubleshooting)
    - [Container Won't Start](#container-wont-start)
    - [Device Access Issues](#device-access-issues)
    - [Permission Denied Errors](#permission-denied-errors)
    - [Configuration Issues](#configuration-issues)
  - [Security Analysis](#security-analysis)
    - [Defense Layers](#defense-layers)
    - [Attack Surface Analysis](#attack-surface-analysis)
    - [Security Best Practices](#security-best-practices)
  - [Maintenance](#maintenance)
    - [Updating Kanata](#updating-kanata)
    - [Modifying Configuration](#modifying-configuration)
    - [Backup and Restore](#backup-and-restore)
    - [Complete Removal](#complete-removal)
  - [Summary](#summary)

## Overview

### Why Container + Service User?

This approach provides **defense-in-depth** security through multiple isolation layers:

1. **Container Isolation**: Namespace separation, filesystem isolation
2. **Dedicated User**: Minimal privileges, no shell access
3. **Systemd Hardening**: Service-level restrictions
4. **SELinux**: Mandatory access controls (on Immutable Fedora)
5. **Device Access Control**: Only specified input devices

### Benefits Over Non-Containerized Approach

- **Additional Isolation Layer**: Even if Kanata is compromised, it must escape the container first
- **Package Management**: Can use dnf/apt inside container without affecting host
- **Easy Updates**: Update container packages without touching host system
- **Rollback Capability**: Can revert to previous container state if needed
- **Resource Limits**: Container-level CPU/memory restrictions

## Architecture Overview

```
┌─────────────────────────────────────────┐
│         Your User Session               │
│     (Completely isolated)               │
└─────────────────────────────────────────┘
                    ↑
         [Security Boundary #1]
                    ↓
┌─────────────────────────────────────────┐
│      Dedicated 'kanata-svc' User        │
│   • No shell (/bin/false)               │
│   • No home directory                    │
│   • Only input/uinput groups            │
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
│   • Separate filesystem                 │
│   • Limited device access               │
│   • No network (optional)               │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│          Kanata Process                 │
│   • Reads from /dev/input/*             │
│   • Writes to /dev/uinput               │
│   • Completely isolated from host       │
└─────────────────────────────────────────┘
```

## Prerequisites

- Fedora-based immutable system (like Bazzite)
- Distrobox installed (pre-installed on Bazzite)
- Podman installed (pre-installed on Bazzite)
- sudo access for initial setup

## Step 1: Create Security Infrastructure

### Create Groups and Service User

```bash
# Create uinput group for device access
sudo groupadd -f uinput

# Create dedicated service user
sudo useradd \
  --system \
  --no-create-home \
  --groups input,uinput \
  --shell /bin/false \
  --comment "Kanata container service" \
  kanata-svc

# Verify user creation
id kanata-svc
```

### Create udev Rules

```bash
# Create udev rules for device permissions
sudo tee /etc/udev/rules.d/50-kanata.rules << 'EOF'
# Allow uinput group to access the uinput device
KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"

# Ensure input devices are accessible by the input group
SUBSYSTEM=="input", MODE="0660", GROUP="input"
EOF

# Reload udev rules
sudo udevadm control --reload-rules
sudo udevadm trigger

# Verify permissions
ls -la /dev/uinput
ls -la /dev/input/event*
```

### Create Configuration Directory

```bash
# Create config directory on host
sudo mkdir -p /etc/kanata
sudo chown root:kanata-svc /etc/kanata
sudo chmod 750 /etc/kanata
```

## Step 2: Create Custom Distrobox Container

### Option A: Using Distrobox (Recommended for Beginners)

```bash
# Switch to service user context for container creation
# We'll use sudo to run commands as kanata-svc

# Create a custom Fedora container for Kanata
sudo -u kanata-svc distrobox create \
  --name kanata-container \
  --image fedora:42 \
  --volume /etc/kanata:/etc/kanata:ro \
  --volume /dev/input:/dev/input:rw \
  --volume /dev/uinput:/dev/uinput:rw \
  --additional-flags "--group-add keep-groups --device-cgroup-rule='c 13:* rmw' --device-cgroup-rule='c 10:223 rmw'"

# Note: The additional flags ensure proper device access
```

**What these options do:**

- `--name kanata-container`: Names the container for easy reference
- `--image fedora:42`: Uses Fedora 42 as base (matches Bazzite's base)
- `--volume /etc/kanata:/etc/kanata:ro`: Mounts config as read-only
- `--volume /dev/input:/dev/input:rw`: Provides input device access
- `--volume /dev/uinput:/dev/uinput:rw`: Provides uinput device access
- `--group-add keep-groups`: Preserves host group memberships
- `--device-cgroup-rule`: Allows character device access for input devices

### Option B: Direct Podman Container (Advanced)

```bash
# Create a Containerfile for a minimal Kanata container
sudo tee /etc/kanata/Containerfile << 'EOF'
FROM fedora:42

# Install necessary packages
RUN dnf update -y && \
    dnf install -y \
    kanata \
    && dnf clean all \
    && rm -rf /var/cache/dnf

# Create non-root user inside container
RUN useradd -m -s /bin/bash kanata-user

# Set up directories
RUN mkdir -p /etc/kanata && \
    chown kanata-user:kanata-user /etc/kanata

USER kanata-user
WORKDIR /home/kanata-user

# Default command
CMD ["/usr/bin/kanata", "--cfg", "/etc/kanata/config.kbd"]
EOF

# Build the container image
sudo podman build -t localhost/kanata-secure:latest -f /etc/kanata/Containerfile /etc/kanata/
```

## Step 3: Install and Configure Kanata in Container

### For Distrobox Container

```bash
# Enter the container as service user
sudo -u kanata-svc distrobox enter kanata-container

# Inside the container, install Kanata
# Option 1: If available in repos (check first)
sudo dnf search kanata
sudo dnf install -y kanata

# Option 2: If not in repos, install from GitHub
# (Run these commands inside the container)
sudo dnf install -y wget tar
cd /tmp
KANATA_VERSION="v1.7.0"  # Update to latest
wget https://github.com/jtroo/kanata/releases/download/${KANATA_VERSION}/kanata-bin-x86_64-unknown-linux-gnu.tar.gz
tar -xzf kanata-bin-x86_64-unknown-linux-gnu.tar.gz
sudo mv kanata /usr/local/bin/
sudo chmod 755 /usr/local/bin/kanata

# Test that Kanata works
kanata --version

# Exit the container
exit
```

### Create Kanata Configuration

```bash
# Create your Kanata configuration on the host
sudo tee /etc/kanata/config.kbd << 'EOF'
;; Kanata configuration for containerized setup
(defcfg
  ;; Process all keys for complete control
  process-unmapped-keys yes
  
  ;; Linux-specific options
  linux-dev-names-include ("AT Translated Set 2 keyboard")
  
  ;; Safety feature: allow escape hatch
  danger-enable-cmd no
)

;; Define source layout (US QWERTY example)
(defsrc
  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
  grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
  tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
  caps a    s    d    f    g    h    j    k    l    ;    '    ret
  lsft z    x    c    v    b    n    m    ,    .    /    rsft
  lctl lmet lalt           spc            ralt rmet rctl
)

;; Base layer with improvements
(deflayer base
  esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
  grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
  tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
  @cap a    s    d    f    g    h    j    k    l    ;    '    ret
  lsft z    x    c    v    b    n    m    ,    .    /    rsft
  lctl lmet lalt           spc            ralt rmet rctl
)

;; Aliases for advanced mappings
(defalias
  ;; Caps Lock becomes Escape on tap, Ctrl on hold
  cap (tap-hold 200 200 esc lctl)
)
EOF

# Set proper permissions
sudo chown root:kanata-svc /etc/kanata/config.kbd
sudo chmod 640 /etc/kanata/config.kbd
```

## Step 4: Create Container Management Script

Create a wrapper script to handle container startup with proper options:

```bash
sudo tee /usr/local/bin/kanata-container-run << 'EOF'
#!/bin/bash
# Kanata Container Runner Script

set -e

CONFIG_FILE="/etc/kanata/config.kbd"
CONTAINER_NAME="kanata-container"

# Check if running as kanata-svc user
if [ "$(whoami)" != "kanata-svc" ]; then
    echo "Error: This script must be run as kanata-svc user"
    exit 1
fi

# Check if config exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file not found at $CONFIG_FILE"
    exit 1
fi

# Function to run Kanata in Distrobox
run_distrobox() {
    distrobox enter "$CONTAINER_NAME" -- \
        /usr/local/bin/kanata --cfg "$CONFIG_FILE"
}

# Function to run Kanata in raw Podman
run_podman() {
    podman run \
        --rm \
        --name kanata-service \
        --group-add keep-groups \
        --security-opt no-new-privileges \
        --cap-drop ALL \
        --device /dev/uinput \
        --device /dev/input \
        --volume /etc/kanata:/etc/kanata:ro \
        --volume /dev/input:/dev/input \
        --volume /dev/uinput:/dev/uinput \
        --cgroup-parent=kanata.slice \
        --memory=256m \
        --cpu-quota=50000 \
        localhost/kanata-secure:latest
}

# Detect which method to use
if command -v distrobox >/dev/null 2>&1 && \
   distrobox list | grep -q "$CONTAINER_NAME"; then
    echo "Starting Kanata via Distrobox..."
    run_distrobox
else
    echo "Starting Kanata via Podman..."
    run_podman
fi
EOF

# Make script executable
sudo chmod 755 /usr/local/bin/kanata-container-run
sudo chown root:kanata-svc /usr/local/bin/kanata-container-run
```

## Step 5: Create Hardened Systemd Service

Create the systemd service that manages the containerized Kanata:

```bash
sudo tee /etc/systemd/system/kanata-container.service << 'EOF'
[Unit]
Description=Containerized Kanata keyboard remapper
Documentation=https://github.com/jtroo/kanata
After=multi-user.target
Wants=systemd-udev-settle.service
After=systemd-udev-settle.service

[Service]
Type=simple
User=kanata-svc
Group=kanata-svc

# Primary execution
ExecStartPre=/usr/bin/sleep 2
ExecStart=/usr/local/bin/kanata-container-run

# Restart configuration
Restart=always
RestartSec=5
TimeoutStopSec=10

# Environment
Environment="HOME=/tmp"
Environment="XDG_RUNTIME_DIR=/tmp"

# Security Hardening - Host Level
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

# Allow necessary system calls for container operation
SystemCallFilter=@system-service @process @basic-io
SystemCallErrorNumber=EPERM

# Device Access (container needs these)
DeviceAllow=/dev/uinput rw
DeviceAllow=char-input rw
DevicePolicy=strict
PrivateDevices=false

# Resource Limits
CPUQuota=50%
MemoryMax=512M
TasksMax=50

# Logging
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF
```

**Security Features Explained:**

- **Container Level**: Namespace isolation, separate filesystem
- **User Level**: Non-privileged service user with minimal groups
- **Systemd Level**: 
  - `NoNewPrivileges`: Prevents privilege escalation
  - `ProtectHome`: Blocks all home directory access
  - `ProtectSystem=strict`: Read-only filesystem except specified paths
  - `RestrictNamespaces`: Prevents creating new namespaces
  - `SystemCallFilter`: Limits available system calls
  - `DevicePolicy=strict`: Only explicitly allowed devices
- **Resource Limits**: CPU and memory constraints

## Step 6: Enable and Start Service

```bash
# Reload systemd configuration
sudo systemctl daemon-reload

# Enable service for automatic startup
sudo systemctl enable kanata-container.service

# Start the service
sudo systemctl start kanata-container.service

# Check service status
sudo systemctl status kanata-container.service

# View logs
sudo journalctl -u kanata-container.service -f
```

## Alternative: Direct Podman Approach

For advanced users who prefer direct Podman without Distrobox:

### Create Podman Quadlet Service

```bash
# Create quadlet directory
sudo mkdir -p /etc/containers/systemd

# Create quadlet file
sudo tee /etc/containers/systemd/kanata.container << 'EOF'
[Unit]
Description=Kanata Keyboard Remapper Container
After=multi-user.target

[Container]
Image=localhost/kanata-secure:latest
ContainerName=kanata-service
User=kanata-svc

# Volumes
Volume=/etc/kanata:/etc/kanata:ro
Volume=/dev/input:/dev/input
Volume=/dev/uinput:/dev/uinput

# Device access
AddDevice=/dev/uinput
AddDevice=/dev/input

# Security
SecurityLabelDisable=false
NoNewPrivileges=true
DropCapability=ALL

# Groups
GroupAdd=keep-groups

# Resources
Memory=256M
CPUQuota=50%

# Restart policy
Restart=always

[Service]
Type=simple
TimeoutStopSec=10

[Install]
WantedBy=multi-user.target
EOF

# Generate and enable systemd service from quadlet
sudo systemctl daemon-reload
sudo systemctl enable kanata.service
```

## Verification and Testing

### Check Container Status

```bash
# For Distrobox
sudo -u kanata-svc distrobox list

# For Podman
sudo -u kanata-svc podman ps -a

# Check if service is running
sudo systemctl status kanata-container.service
```

### Test Key Remapping

```bash
# Monitor input events (in another terminal)
sudo evtest

# Test your remapped keys
# For example, if you remapped Caps Lock to Escape, test it
```

### Security Verification

```bash
# Check security score (lower is better)
systemd-analyze security kanata-container.service

# Verify container isolation
sudo -u kanata-svc podman exec kanata-service ps aux
sudo -u kanata-svc podman exec kanata-service ls -la /home

# Check resource usage
systemd-cgtop
```

## Troubleshooting

### Container Won't Start

```bash
# Check container logs
sudo -u kanata-svc podman logs kanata-service

# For Distrobox
sudo -u kanata-svc distrobox enter kanata-container -- journalctl

# Check service logs
sudo journalctl -u kanata-container.service -n 100
```

### Device Access Issues

```bash
# Verify device permissions inside container
sudo -u kanata-svc podman exec kanata-service ls -la /dev/input/
sudo -u kanata-svc podman exec kanata-service ls -la /dev/uinput

# Check if groups are preserved
sudo -u kanata-svc podman exec kanata-service id

# Test device access
sudo -u kanata-svc podman exec kanata-service cat /dev/input/event0
```

### Permission Denied Errors

```bash
# Check SELinux context (if enabled)
ls -Z /dev/uinput
ls -Z /dev/input/

# Temporarily set permissive mode for testing (Fedora/Bazzite)
sudo setenforce 0
# Test if it works
# Re-enable SELinux
sudo setenforce 1

# If SELinux is the issue, create proper context
sudo semanage fcontext -a -t container_file_t "/dev/uinput"
sudo restorecon -v /dev/uinput
```

### Configuration Issues

```bash
# Test configuration inside container
sudo -u kanata-svc podman exec kanata-service \
    /usr/local/bin/kanata --cfg /etc/kanata/config.kbd --check

# View configuration from inside container
sudo -u kanata-svc podman exec kanata-service \
    cat /etc/kanata/config.kbd
```

## Security Analysis

### Defense Layers

1. **Container Isolation**
   - Separate namespaces (PID, mount, network)
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

4. **SELinux/AppArmor** (if enabled)
   - Mandatory access controls
   - Additional process confinement

### Attack Surface Analysis

**What's Protected:**
- User data and home directories (completely inaccessible)
- System files (read-only access)
- Network access (can be completely disabled)
- Other processes (namespace isolation)
- Privilege escalation (multiple prevention mechanisms)

**Remaining Risks:**
- Keylogging capability (inherent to functionality)
- Input device access (required for operation)
- Container escape vulnerabilities (mitigated by updates)
- Supply chain attacks (verify source integrity)

### Security Best Practices

1. **Regular Updates**
   ```bash
   # Update container packages
   sudo -u kanata-svc distrobox upgrade kanata-container
   
   # Or rebuild Podman image
   sudo podman build --no-cache -t localhost/kanata-secure:latest \
       -f /etc/kanata/Containerfile /etc/kanata/
   ```

2. **Audit Logs**
   ```bash
   # Check for unusual activity
   sudo journalctl -u kanata-container.service --since="24 hours ago" \
       | grep -E "ERROR|WARNING|Failed"
   ```

3. **Monitor Resources**
   ```bash
   # Check container resource usage
   sudo -u kanata-svc podman stats --no-stream
   ```

## Maintenance

### Updating Kanata

```bash
# For Distrobox
sudo -u kanata-svc distrobox enter kanata-container
sudo dnf update kanata
# Or manually update binary as shown earlier
exit

# For Podman image
# Edit Containerfile with new version, then:
sudo podman build --no-cache -t localhost/kanata-secure:latest \
    -f /etc/kanata/Containerfile /etc/kanata/

# Restart service
sudo systemctl restart kanata-container.service
```

### Modifying Configuration

```bash
# Edit configuration
sudo nano /etc/kanata/config.kbd

# Test new configuration
sudo -u kanata-svc distrobox enter kanata-container -- \
    kanata --cfg /etc/kanata/config.kbd --check

# Restart service to apply
sudo systemctl restart kanata-container.service
```

### Backup and Restore

```bash
# Backup configuration
sudo cp -a /etc/kanata /etc/kanata.backup.$(date +%Y%m%d)

# Backup container (Distrobox)
sudo -u kanata-svc distrobox export kanata-container \
    --output kanata-container-backup.tar

# Restore container
sudo -u kanata-svc distrobox import kanata-container-backup.tar
```

### Complete Removal

```bash
# Stop and disable service
sudo systemctl stop kanata-container.service
sudo systemctl disable kanata-container.service

# Remove service files
sudo rm /etc/systemd/system/kanata-container.service
sudo rm /usr/local/bin/kanata-container-run

# Remove container (Distrobox)
sudo -u kanata-svc distrobox rm kanata-container --force

# Remove container (Podman)
sudo -u kanata-svc podman rm -f kanata-service
sudo podman rmi localhost/kanata-secure:latest

# Remove configuration
sudo rm -rf /etc/kanata

# Remove udev rules
sudo rm /etc/udev/rules.d/50-kanata.rules

# Remove service user
sudo userdel kanata-svc

# Remove group
sudo groupdel uinput

# Reload systemd and udev
sudo systemctl daemon-reload
sudo udevadm control --reload-rules
```

## Summary

This containerized approach provides maximum security for running Kanata on an Immutable Fedora install (like Kinoite or Bazzite) through:

- **Multiple isolation layers**: Container + service user + systemd hardening
- **Minimal attack surface**: Only necessary devices and files accessible
- **Easy maintenance**: Container updates don't affect host system
- **Rollback capability**: Can revert container to previous state
- **Resource control**: Hard limits on CPU and memory usage

The trade-off is slightly increased complexity compared to the direct installation method, but the security benefits are substantial. This setup ensures that even if Kanata were compromised, it would need to escape multiple security boundaries to access your personal data or system resources.

For most users, this represents the optimal balance between security and usability when running a keyboard remapper that necessarily has access to all keystrokes.
