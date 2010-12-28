# Edit this configuration file which defines what would be installed on the
# system.  To Help while choosing option value, you can watch at the manual
# page of configuration.nix or at the last chapter of the manual available
# on the virtual console 8 (Alt+F8).

{config, pkgs, ...}:

{
  require = [
    # Include the configuration for part of your system which have been
    # detected automatically.  In addition, it includes the same
    # configuration as the installation device that you used.
    ./hardware-configuration.nix
    #XXX: should be turned into a networking enable option see 3945.nix
    ./nixos/modules/hardware/network/intel-5000.nix
#    ./nixos/modules/services/networking/wicd.nix
  ];

  boot = {
    initrd = {
      kernelModules = [
        "ext4" "ahci" "fbcon" "i915"
      ];
    };
    kernelPackages = pkgs.linuxPackages_2_6_36;
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };
    resumeDevice = "254:0";
    vesa = false;
  };

  environment = {
    systemPackages = [
      pkgs.git
      pkgs.gnupg
      pkgs.htop
      pkgs.keychain
      pkgs.links2
      pkgs.mutt
      pkgs.offlineimap
      pkgs.powertop
      pkgs.remind
      pkgs.vim_configurable
    ];
  };

  networking = {
    defaultMailServer = {
      directDelivery = true;
      domain = "chaoflow.net";
      hostName = "tesla.chaoflow.net";
      useSTARTTLS = true;
    };
    enableWLAN = true;  # Enables Wireless.
    firewall = {
      enable = true;
    };
    hostName = "eve"; # Define your hostname.
    interfaceMonitor.enable = true; # Watch for plugged cable.
  };

  # Add file system entries for each partition that you want to see mounted
  # at boot time.  You can add filesystems which are not mounted at boot by
  # adding the noauto option.
  fileSystems = [
    # Mount the root file system
    #
    { mountPoint = "/";
      label = "nixos";
    }

    # Copy & Paste & Uncomment & Modify to add any other file system.
    #
    # { mountPoint = "/data"; # where you want to mount the device
    #   device = "/dev/sdb"; # the device or the label of the device
    #   # label = "data";
    #   fsType = "ext3";      # the type of the partition.
    #   options = "data=journal";
    # }
    { mountPoint = "/home";
      label = "home";
    }
#    { mountPoint = "/mnt/ubuntu";
#      label = "ubuntu";
#    }
  ];

  swapDevices = [
    # List swap partitions that are mounted at boot time.
    { label = "swap"; }
  ];

  # Select internationalisation properties.
  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  powerManagement.enable = true;

  services.acpid.enable = true;
  services.locate.enable = true;
  services.openssh.enable = true;
  services.printing.enable = true;
  services.ttyBackgrounds.enable = false;
  #services.wicd.enable = true;

  # Add XServer (default if you have used a graphical iso)
  services.xserver = {
    autorun = false;
    displayManager.slim = {
      defaultUser = "cfl";
      hideCursor = true;
    };
    enable = true;
    exportConfiguration = true;
    layout = "us";
    # XXX: hack to get it before the automagically added vesa screen
    serverLayoutSection = ''
      Screen "Screen-intel[0]"
    '';
    videoDrivers = [ "intel" ];
    windowManager.awesome.enable = true;
    xkbOptions = "eurosign:e terminate:ctrl_alt_bksp";
  };

  # Add the NixOS Manual on virtual console 8
  services.nixosManual.showManual = true;

  time.timeZone = "Europe/Berlin";
}

