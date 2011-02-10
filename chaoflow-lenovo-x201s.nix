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
    "${modulesPath}/hardware/network/intel-6000.nix"
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

        # needed for setting ondemand governor in next stage (see postBootCommands)
        "acpi-cpufreq"
        "cpufreq-ondemand"
      ];
    };
    kernelPackages = pkgs.linuxPackages_2_6_37;
    kernelModules = [
      "kvm-intel"
    ];

    # grub 2 can boot from lvm, not sure whether version 2 is default
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };

    # Currently I'm aiming only at minimum power usage. Changing these settings
    # when on AC might be added later. min_power setting seems only to be
    # effective for hosts that are actually connected to something, in my case
    # only host0.
    postBootCommands = ''
      for x in /sys/devices/system/cpu/*/cpufreq/scaling_governor; do
        echo ondemand > $x
      done
      for x in /sys/class/scsi_host/*/link_power_management_policy; do
        echo min_power > $x
      done
    '';

    # major:minor number of my swap device, fully lvm-based system
    resumeDevice = "254:0";

    # disabled for fbcon and i915 to kick in (see kernelModules above)
    vesa = false;
  };

  environment = {
    # To also get the header files in the system environment. You only need
    # this if you want compile non-nixos stuff against the system environment.
    # You would only want that as a part of temporary solution to continue on
    # whatever you were working before christmas. However, there are better
    # ways. See https://github.com/chaoflow/nixos-configurations for more on
    # that.
    #pathsToLink = ["include"];

    # XXX: still not sure when it is better to put a package here and when to
    # use the default profile.
    systemPackages = [
      pkgs.acpitool
      pkgs.bc
      pkgs.cpufrequtils
      pkgs.ddrescue
      pkgs.file
      pkgs.gitFull
      pkgs.gnupg1orig
      pkgs.htop
      pkgs.ipython
      pkgs.keychain
      pkgs.links2
      pkgs.mailutils
      pkgs.mercurial
      pkgs.mutt
      pkgs.offlineimap
      pkgs.p7zip
      pkgs.powertop
      pkgs.pwgen
      pkgs.remind
      pkgs.vim_configurable
      pkgs.wget
      pkgs.zsh
    ];
    x11Packages = [
      pkgs.awesome
      pkgs.firefox36Wrapper
      pkgs.geeqie
      pkgs.rxvt_unicode
      pkgs.vlc
      pkgs.xlibs.xinput
      pkgs.xlibs.xmessage
      pkgs.xlibs.xmodmap
      # would prefer slock, but need to package it first
      pkgs.xlockmore
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

  # XXX: add more fonts!
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;

    # terminus I use for rxvt-unicode
    # see https://github.com/chaoflow/chaoflow.skel.home/blob/master/.Xdefaults
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
    # for some reason udev renames wlan0 to wlan1
    WLANInterface = "wlan1";
  };

  nix.maxJobs = 4;
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
      extraConfig = ''
        # For all options see ``man 5 postconf``
        # Take care, empty lines will mess up whitespace removal.
        # It would be nice if empty lines would not be considered in minimal
        # leading whitespace analysis, but don't know about further implications.
        # Also take care not to mix tabs and spaces. Should tabs be treated
        # like 8 spaces?
        #
        # ATTENTION! Will log passwords
        #debug_peer_level = 4
        #debug_peer_list = tesla.chaoflow.net
        inet_interfaces = loopback-only
        #
        # the nixos config option does not allow to specify a port, beware:
        # small 'h' in contrast to the config option with capital 'H'
        relayhost = [tesla.chaoflow.net]:submission
        #
        #XXX: needs server certificate checking
        #smtp_enforce_tls = yes
        #
        # postfix generic map example content:
        #   user@local.email user@public.email
        # Run ``# postmap hash:/etc/nixos/cfg-private/postfix_generic_map``
        # after changing it.
        smtp_generic_maps = hash:/etc/nixos/cfg-private/postfix_generic_map
        smtp_sasl_auth_enable = yes
        smtp_sasl_mechanism_filter = plain, login
        #
        # username and password for smtp auth, example content:
        #  <relayhost> <username>:<password>
        # The <relayhost> is exactly what you specified for relayHost, resp. relayhost.
        smtp_sasl_password_maps = hash:/etc/nixos/cfg-private/postfix_sasl_passwd
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

