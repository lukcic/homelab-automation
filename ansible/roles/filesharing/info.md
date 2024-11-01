# Info

## LXC Container

Container template - filesystem of disribution, but without kernel files and modules.

LXC Container - namespace within a Proxmox system, partitioned off. No drivers. Has own networking, permissions.

`Unpriviledged container` - as the user in the container is also available in host, making container unproviledged maps
the user IDs in the container to be a very high numbers (root = 10000 on the host).

Root user in privileged container has access to everything the same as root on the host?

CPU - in VM it is an allocation, in containers there's a limit. COntainer knows how many cores the host has, but is
allowed to use only set amount of resources.

RAM - guideline in containers, hard allocation for VMs. With ballooning it's possible to get some memory back to the
host. In LXC it is a limit, similar to CPU.

WMs have rendered scree in Proxmox, LXC containers has sessions similar to SSH connection. 

## Adding backports repo

Backports repo is the repository with future versions of software that are available in next distribution version.

```sh
vim /etc/apt/sources/list

deb http://deb.debian.org/debian bookworm-backports main contrib

apt update && apt full-upgrade
```

## Installing cockpit

```sh
apt install -t bookworm-backports cockpit --no-install-recommends -y
# no install recommends will not installs packages for managing hostname and network settings distributed with cockpit
```
Access:

`[IP]:9090`

### Enabling root login

```sh
vim /etc/cockpit/disallowed-users
# comment out root user
```

## Cockpit modules

Latest releases - deb files.

```sh
apt --fix-broken install ./*.deb
```

### Cockpit file-sharing

<https://github.com/45Drives/cockpit-file-sharing>

Samba and NFS. Log in and fix Samba config in GUI.

### Navigator

<https://github.com/45Drives/cockpit-navigator>

Browser for filesystem.

### Cockpit identities

User management

<https://github.com/45Drives/cockpit-identities>

## Importing zpool

```sh
zpoll import
#will show all available pools
zpool import [POOL_NAME]
```

Add it as a storage in PVE.

## Adding the mountpoint

Add -> mountpoint.

```sh
pct set <id> --mpX /pool/share,mp=/mnt/media
```




https://forum.proxmox.com/threads/native-full-disk-encryption-with-zfs.140170/
https://gist.github.com/yvesh/ae77a68414484c8c79da03c4a4f6fd55