# This is a generated file.  Do not modify!
# Make changes to /etc/nixos/configuration.nix instead.
{ config, pkgs, modulesPath, ... }:

{
  require = [
    "${modulesPath}/profiles/base.nix"
    "${modulesPath}/installer/scan/not-detected.nix"
  ];

  boot.initrd.kernelModules = [  "uhci_hcd" "ehci_hcd" "ahci" "usb_storage" ];
  boot.kernelModules = [  "acpi-cpufreq" "kvm-intel" ];
  boot.extraModulePackages = [  ];

  nix.maxJobs = 2;

  services.xserver.videoDriver = "vesa";
  
  
}
