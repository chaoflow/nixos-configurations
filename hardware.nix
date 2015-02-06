{ modulesPath, ... }:

### Lenovo x201s
#
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

### Lenovo x220
#
# % lspci
# 00:00.0 Host bridge: Intel Corporation Sandy Bridge DRAM Controller (rev 09)
# 00:02.0 VGA compatible controller: Intel Corporation Device 0126 (rev 09)
# 00:16.0 Communication controller: Intel Corporation Cougar Point HECI Controller #1 (rev 04)
# 00:19.0 Ethernet controller: Intel Corporation 82579LM Gigabit Network Connection (rev 04)
# 00:1a.0 USB Controller: Intel Corporation Cougar Point USB Enhanced Host Controller #2 (rev 04)
# 00:1b.0 Audio device: Intel Corporation Cougar Point High Definition Audio Controller (rev 04)
# 00:1c.0 PCI bridge: Intel Corporation Cougar Point PCI Express Root Port 1 (rev b4)
# 00:1c.1 PCI bridge: Intel Corporation Cougar Point PCI Express Root Port 2 (rev b4)
# 00:1c.4 PCI bridge: Intel Corporation Cougar Point PCI Express Root Port 5 (rev b4)
# 00:1d.0 USB Controller: Intel Corporation Cougar Point USB Enhanced Host Controller #1 (rev 04)
# 00:1f.0 ISA bridge: Intel Corporation Cougar Point LPC Controller (rev 04)
# 00:1f.2 SATA controller: Intel Corporation Cougar Point 6 port SATA AHCI Controller (rev 04)
# 00:1f.3 SMBus: Intel Corporation Cougar Point SMBus Controller (rev 04)
# 03:00.0 Network controller: Intel Corporation 6000 Series Gen2 (rev 34)
# 0d:00.0 System peripheral: Ricoh Co Ltd Device e823 (rev 04)

{
  # You may have a different wifi card
  # XXX: should these be turned into networking enable option (see 3945.nix)?
  require = [
    "${modulesPath}/hardware/network/intel-5000.nix"
    "${modulesPath}/hardware/network/intel-6000.nix"
    "${modulesPath}/hardware/network/intel-6000g2a.nix"
  ];
  boot.initrd.kernelModules = [
    # rootfs, hardware specific
    "ahci"
    # proper console asap
    "fbcon"
    "i915"
  ];

  # XXX: how can we load on-demand for qemu-kvm?
  boot.kernelModules = [ "kvm-intel" ];

  # disabled for fbcon and i915 to kick in or to disable the kernelParams
  # XXX: investigate
  boot.vesa = false;

  nix.extraOptions = ''
    build-cores = 4
  '';
  nix.maxJobs = 4;
  services.xserver.videoDrivers = [ "intel" ];
  services.xserver.xkbModel = "thinkpad60";
}
