#!/bin/bash

err="\033[0;31m[ERROR]"
r0="\033[0m"
suc="\033[0;32m[SUCCESS]"
nte="\033[0;33m[NOTE]"
echo -e "$nte Building rootfs directories and files $r0"
if [[ -z "${ROOT}" ]]; then
	echo -e "[Error] Environment variable ROOT not set. Set this to dirpath of your target drive/partition.";
	exit 1
fi


rm -rf "$ROOT/*"
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



cp ./include/toybox $ROOT/usr/bin/
cp ./include/vmlinuz* $ROOT/boot/
cp ./include/initrd* $ROOT/boot/
echo -e "\n$nte You need to manually add following menuentry to /boot/grub/grub.cfg: $r0
-------------------------------
menuentry 'Alhamd Linux (on /dev/partition_number)' {
        set root=(hd0,partition_scheme)
        linux /boot/vmlinuz-5.10.0-4-amd64 root=/dev/partition_number rw
        initrd /boot/initrd.img-5.10.0-4-amd64
}
-------------------------------
$nte You need to replace \"partition_number\" and \"partition_scheme\" $r0


"




echo -e "\n$suc Alhamd Linux is ready to boot. $r0
To execute commands in the newly booted system:
$ toybox ls -lah /
$ toybox du -sh --exclude "/proc" /
"
