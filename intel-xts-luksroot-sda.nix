{ ... }:

{
  # ext4 root fs in aes-xts-plain64 encrypted lvm
  boot.initrd.kernelModules = [ "aesni-intel" "dm-crypt" "ext4" "xts" ];

  # grub version 2 on sda
  boot.loader.grub = {
    version = 2;
    device = "/dev/sda";
  };
}
