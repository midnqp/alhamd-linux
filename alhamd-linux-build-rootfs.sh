#!/bin/bash

echo -e "\033[0;32m--------BUILDING ROOTFS DIRECTORIES & FILES--------\n\033[0m"
ROOT=./alhamd_linux_rootfs
rm -rf "$ROOT"
mkdir -p "$ROOT"/{boot,etc,dev,media,proc,root,sys,tmp,usr/{bin,sbin,lib},var/{log,lib/dpkg/info}}
touch $ROOT/var/log/messages
touch $ROOT/var/lib/dpkg/status
chmod 1777 $ROOT/tmp

echo 'root:x:0:' > $ROOT/etc/group
echo 'root:x:0:0:root:/root:/bin/sh' > $ROOT/etc/passwd
echo 'root::10:0:0:0:::' > $ROOT/etc/shadow
echo 'alhamd-linux' > $ROOT/etc/hostname
echo "nameserver 8.8.8.8" > "$ROOT"/etc/resolv.conf || exit 1
echo "#!/bin/sh
export PATH=/sbin:/bin:/usr/sbin:/usr/bin
export HOME=/root" > $ROOT/etc/rc


cat > "$ROOT"/etc/inittab << 'EOF'
null::sysinit:/bin/mount -t proc proc /proc 
null::sysinit:/bin/mkdir -p /dev/pts 
null::sysinit:/bin/mount -a 
null::sysinit:/sbin/ifconfig lo 127.0.0.1 up 
::sysinit:/etc/rc 
tty1::respawn:/sbin/getty 38400 tty1 
null::sysinit:/bin/touch /var/log/messages 
::ctrlaltdel:/sbin/reboot 
null::shutdown:/usr/bin/killall klogd 
null::shutdown:/usr/bin/killall syslogd 
null::shutdown:/bin/umount -a -r"
EOF




echo -e "\033[0;32m--------DOWNLOADING LINUX KERNEL"




echo -e "====Filesystem for alhamd-linux built successfully===="
