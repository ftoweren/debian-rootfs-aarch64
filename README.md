# Debian rootfs variant essential + apt (AARCH64)

_general info:_

- Debian rootfs built using mmdebstrap varian essential apt included (linux/aarch64)
- Expose http 80, https 443, ssh 22, dns 53
- Built and tested on ARM64 device (ZTE B860H v.2) with Armbian Community v25.11 running:
```
https://github.com/armbian/community/releases/download/25.11.0-trunk.472/Armbian_community_25.11.0-trunk.472_Aml-s9xx-box_trixie_current_6.12.57_minimal.img.xz
```
---

## Quick Start

### Pull Image
```bash
docker pull ftoweren/debian-rootfs-aarch64:latest
```

### Run Container (With Persistent Volume & Custom Ports)
```bash
docker run -itd -p 8822:22 -p 8880:80 -p 8843:443 -p 8853:53 --name debian-rootfs --restart always \
  ftoweren/debian-rootfs-aarch64:latest
```

### Post-Installation Management
Change Container Root Password (if needed):
```bash
docker exec -it debian-rootfs passwd
```
entrypoint.sh edit inside container after app(s) installed (for example):
```
#!/bin/sh
#to start installed ssh
/sbin/sshd
echo " * ssh........... [OK]"
sleep 3
#to start installed mariadb
/etc/init.d/mariadb start > /dev/null
echo " * mariadb....... [OK]"
exec "$@"
```
---

## Build from Source

### 1.  Generate Custom Minimal Debian Trixie RootFS
To build the exact base rootfs tarball used in this setup (build rootfs using mmdebstrap):
```
mmdebstrap --varian=essential --include=apt --include=passwd --include=openssl --include=ca-certificates \
  --include=procps --include=curl --include=wget --aptopt='Apt::Install-Recommends "false"' \
  --dpkgopt="path-exclude=/usr/share/doc/*" --dpkgopt="path-include=/usr/share/doc/*/copyright" \
  --dpkgopt="path-exclude=/usr/share/man/*" --dpkgopt="path-exclude=/usr/share/groff/*"  \
  --dpkgopt="path-exclude=/usr/share/info/*" --dpkgopt="path-exclude=/usr/share/lintian/*" \
  --dpkgopt="path-exclude=/usr/share/locale/*" --dpkgopt="path-exclude=/usr/share/i18n/*" \
  --dpkgopt="path-exclude=/usr/lib/debug/*" trixie debian-rootfs-essential-apt-trixie-aarch64.tar.gz
```

### 2.  Build Docker Image
```
docker build --no-cache -f path/Dockerfile -t debian-rootfs-aarch64 .
```
