
qemu-system-arm -kernel ${KERNEL} \
    -cpu arm1176 -M versatilepb \
    -dtb ${DTB} \
    -serial stdio -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" \
    -drive "file=${DRIVE},index=0,media=disk,format=raw" \
    -net user,hostfwd=tcp::5022-:22 -net nic \
