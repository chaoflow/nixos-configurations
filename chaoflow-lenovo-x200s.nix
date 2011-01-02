# Edit this configuration file which defines what would be installed on the
# system.  To Help while choosing option value, you can watch at the manual
# page of configuration.nix or at the last chapter of the manual available
# on the virtual console 8 (Alt+F8).

{config, pkgs, modulesPath, ...}:

{
  require = [
    # from hardware-configuration
    "${modulesPath}/profiles/base.nix"
    #XXX: should be turned into a networking enable option (see 3945.nix)?
    "${modulesPath}/hardware/network/intel-5000.nix"
#   "${modulesPath}/services/networking/wicd.nix"
  ];

  boot = {
    initrd = {
      kernelModules = [
        # root fs
        "ahci"
        "ext4"
        # proper console asap
        "fbcon"
        "i915"
	# needed here? came from nixos-option generated hardware-configurations
        #"ehci_hcd"
        #"uhci_hcd"
        #"usb_storage"
        # enable setting ondemand governor in next stage (postBootCommands)
        "acpi-cpufreq"
        "cpufreq-ondemand"
      ];
    };
    kernelPackages = pkgs.linuxPackages_2_6_36;
    kernelModules = [
      "kvm-intel"
    ];
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };
    postBootCommands = ''
      echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
      echo ondemand > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
    '';
    resumeDevice = "254:0";
    vesa = false;
  };

  environment = {
    systemPackages = [
      pkgs.acpitool
      pkgs.cpufrequtils
      pkgs.ddrescue
      pkgs.gcc
      pkgs.gitFull
      pkgs.gnumake
#      pkgs.gnupg_1_4_11
      pkgs.htop
      pkgs.ipython
      pkgs.keychain
      pkgs.links2
      pkgs.mailutils
      pkgs.mercurial
      pkgs.mutt
      pkgs.offlineimap
      pkgs.powertop
      pkgs.python24
      pkgs.python26Full
      pkgs.python27Full
      pkgs.remind
      pkgs.vim_configurable
      pkgs.wget
      pkgs.yacc
      pkgs.zsh
    ];
    x11Packages = [
      pkgs.firefox36Wrapper
      pkgs.awesome
      pkgs.rxvt_unicode
      pkgs.vlc
      pkgs.xlibs.xinput
      pkgs.xlibs.xmessage
      pkgs.xlibs.xmodmap
      pkgs.xpdf
    ];
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
    { mountPoint = "/mnt/ubuntu";
      label = "ubuntu";
      options = "noauto";
    }
  ];

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    extraFonts = [
       pkgs.terminus_font
    ];
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  installer = {
    repos = {
      # this needs gitsvn support, currently only in my branch:
      # https://github.com/chaoflow/nixos
      nixos = [
        { type = "gitsvn";
          update = "git checkout official && git svn fetch && git svn rebase -l && git checkout master && git merge official";
        }
      ];
      nixpkgs = [
        { type = "gitsvn";
          update = "git checkout official && git svn fetch && git svn rebase -l && git checkout master && git merge official";
        }
      ];
    };
  };

  networking = {
    domain = "chaoflow.net";
    enableWLAN = true;
    # hardcode domain name
    extraHosts = "127.0.0.1 eve.chaoflow.net eve";
    firewall = {
      enable = true;
    };
    hostName = "eve";
    interfaceMonitor.enable = false; # Watch for plugged cable.
  };

  nix.maxJobs = 2;
  nixpkgs.config = {
    xkeyboard_config = { extraLayoutPath = "./xkb-layout/chaoflow"; };
  };

  powerManagement.enable = true;

#  security.sudo.configFile = ''
## Don't edit this file. Set nixos option security.sudo.configFile instead
#
#Defaults env_reset
#Defaults env_keep=LOCALE_ARCHIVE
#
## "root" is allowed to do anything.
#root ALL=(ALL) SETENV: ALL
#
## Users in the "wheel" group can do anything.
#%wheel ALL=(ALL) SETENV: ALL
#  '';
  services = {
    acpid.enable = true;
    locate.enable = true;
    # Add the NixOS Manual on virtual console 8
    nixosManual.showManual = true;
    openssh.enable = true;
    printing.enable = true;

    postfix = {
      destination = [ "localhost" "eve.chaoflow.net" ];
      enable = true;
      # this needs extraConfig support, currently only in my branch:
      # https://github.com/chaoflow/nixos
      extraConfig = ''
        # ATTENTION! Will log passwords
        #debug_peer_level = 4
        #debug_peer_list = tesla.chaoflow.net
        inet_interfaces = loopback-only
        relayhost = [tesla.chaoflow.net]:submission
        #XXX: needs server certificate checking
        #smtp_enforce_tls = yes
        smtp_generic_maps = hash:/etc/nixos/postfix_generic_map
        smtp_sasl_auth_enable = yes
        smtp_sasl_mechanism_filter = plain, login
        smtp_sasl_password_maps = hash:/etc/nixos/private/postfix_sasl_passwd
        smtp_sasl_security_options = noanonymous
        smtp_sasl_tls_security_options = $smtp_sasl_security_options
        smtp_use_tls = yes
      '';
      hostname = "eve.chaoflow.net";
      origin = "eve.chaoflow.net";
      postmasterAlias = "root";
      rootAlias = "cfl";
    };

    ttyBackgrounds.enable = false;
    #wicd.enable = true;

    xserver = {
      autorun = true;
      # no desktop manager, no window manager configured here. This
      # results in only one session *custom* for slim which executes
      # ~/.xsession. See:
      # https://github.com/chaoflow/chaoflow.skel.home/blob/master/.xsession
      desktopManager.xterm.enable = false;
      displayManager = {
	slim = {
	  defaultUser = "cfl";
	  hideCursor = true;
	};
      };
      enable = true;
      exportConfiguration = true;
      # XXX: extend xserver.nix to support full path to keymap (layoutPath)
      #      copy to /etc/static/X11/xkb/symbols and set basename as layout
      layout = "chaoflow";
      videoDrivers = [ "intel" ];
      xkbModel = "thinkpad60";
    };
  };

  swapDevices = [
    # List swap partitions that are mounted at boot time.
    { label = "swap"; }
  ];

  time.timeZone = "Europe/Berlin";
}

