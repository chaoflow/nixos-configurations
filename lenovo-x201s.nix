{ config, pkgs, modulesPath, ...}:

# % lspci 
# 00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 02)
# 00:02.0 VGA compatible controller: Intel Corporation Core Processor Integrated Graphics Controller (rev 02)
# 00:16.0 Communication controller: Intel Corporation 5 Series/3400 Series Chipset HECI Controller (rev 06)
# 00:19.0 Ethernet controller: Intel Corporation 82577LM Gigabit Network Connection (rev 06)
# 00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 06)
# 00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio (rev 06)
# 00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 (rev 06)
# 00:1c.4 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 5 (rev 06)
# 00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 06)
# 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a6)
# 00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC Interface Controller (rev 06)
# 00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 6 port SATA AHCI Controller (rev 06)
# 00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller (rev 06)
# 00:1f.6 Signal processing controller: Intel Corporation 5 Series/3400 Series Chipset Thermal Subsystem (rev 06)
# 02:00.0 Network controller: Intel Corporation Centrino Ultimate-N 6300 (rev 35)
# ff:00.0 Host bridge: Intel Corporation Core Processor QuickPath Architecture Generic Non-core Registers (rev 02)
# ff:00.1 Host bridge: Intel Corporation Core Processor QuickPath Architecture System Address Decoder (rev 02)
# ff:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 02)
# ff:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 02)
# ff:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
# ff:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 02)

{
  # You may have a different wifi card
  require = [
    "${modulesPath}/hardware/network/intel-6000.nix"
  ];
  boot.initrd.kernelModules = [
    # rootfs, hardware specific
    "ahci"
    "aesni-intel"
    # proper console asap
    "fbcon"
    "i915"
  ];

  # disabled for fbcon and i915 to kick in or to disable the kernelParams
  # XXX: investigate
  boot.vesa = false;
  nix.extraOptions = ''
    build-cores = 4
  '';
  nix.maxJobs = 4;
  services.xserver = {
    videoDrivers = [ "intel" ];
    xkbModel = "thinkpad60";
  };
}
