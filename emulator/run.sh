

TMPDIR=$(mktemp -d)
cp $DRIVE/tsdash.img "$TMPDIR"
chmod -R 777 "$TMPDIR"

qemu-system-arm -kernel ${KERNEL} \
    -cpu arm1176 -M versatilepb \
    -dtb ${DTB} \
    -serial stdio -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" \
    -drive "file=${TMPDIR}/tsdash.img,index=0,media=disk,format=raw" \
    -net user,hostfwd=tcp::5022-:22 -net nic \
