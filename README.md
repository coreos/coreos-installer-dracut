# coreos-installer-dracut

Depends on `coreos-installer`.

Partitions should have labels on partitions defined as:

- `root` for the root partition
- `crypt_root` for the encrypted rootfs containing the `root` partition
- `boot` for the boot partition