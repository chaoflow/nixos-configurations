# Edit this configuration file which defines what would be installed on the
# system.  To Help while choosing option value, you can watch at the manual
# page of configuration.nix or at the last chapter of the manual available
# on the virtual console 8 (Alt+F8).

{config, pkgs, modulesPath, ...}:

{
  require = [
    # from hardware-configuration
    #"${modulesPath}/profiles/base.nix"
    #XXX: should be turned into a networking enable option (see 3945.nix)?
    "${modulesPath}/hardware/network/intel-6000.nix"
  ];

  boot = {
    initrd = {
      kernelModules = [
        # root fs
        "ahci"
        "dm-crypt"
        "ext4"
        "fpu"
        "aesni-intel"
        "xts"
        "arc4"
        "ecb"
        "sha1"

        # proper console asap
        "fbcon"
        "i915"

        # needed for setting ondemand governor in next stage
        # (see postBootCommands)
        "acpi-cpufreq"
        "cpufreq-ondemand"
      ];
      luksRoot = "/dev/sda2";
    };
    kernelPackages = pkgs.linuxPackages_2_6_39;
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
      pkgs.alsaLib
      pkgs.alsaPlugins
      pkgs.alsaUtils
      pkgs.bc
      #pkgs.cpufrequtils
      pkgs.ddrescue
      pkgs.file
      pkgs.gitFull
      pkgs.gnupg
      pkgs.gnupg1
      pkgs.htop
      pkgs.keychain
      pkgs.links2
      pkgs.mailutils
      pkgs.mercurial
      pkgs.ncftp
      pkgs.p7zip
      pkgs.parted
      pkgs.pinentry
      pkgs.powertop
      pkgs.pwgen
      pkgs.screen
      pkgs.subversion
      pkgs.unrar
      pkgs.unzip
      pkgs.vim
      pkgs.wget
      pkgs.w3m
      pkgs.zsh
    ];
    x11Packages = [
      pkgs.rxvt_unicode
      pkgs.xfontsel
      pkgs.xlibs.xev
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
      device = "/dev/mapper/eve-nixos";
    } {
      mountPoint = "/boot";
      device = "/dev/sda1";
    }

    # Copy & Paste & Uncomment & Modify to add any other file system.
    #
    # { mountPoint = "/data"; # where you want to mount the device
    #   device = "/dev/sdb"; # the device or the label of the device
    #   # label = "data";
    #   fsType = "ext3";      # the type of the partition.
    #   options = "data=journal";
    # }
    { mountPoint = "/tmp";
      device = "tmpfs";
      fsType = "tmpfs";
      options = "nosuid,nodev,relatime";
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

  # installer = {
  #   repos = {
  #     nixos = [
  #       { type = "gitsvn";
  #         update = "git checkout master && git svn fetch && git svn rebase -l";
  #       }
  #     ];
  #     nixpkgs = [
  #       { type = "gitsvn";
  #         update = "git checkout master && git svn fetch && git svn rebase -l";
  #       }
  #     ];
  #   };
  # };

  networking = {
    domain = "chaoflow.net";
    # hardcode domain name
    extraHosts = "127.0.0.1 eve.chaoflow.net eve";
    firewall = {
      allowedTCPPorts = [ 80 ];
      enable = true;
    };
    hostName = "eve";
    interfaceMonitor.enable = false; # Watch for plugged cable.
    wicd.enable = true;
  };

  nix.maxJobs = 4;
  # XXX: unused so far
  nixpkgs.config = {
    xkeyboard_config = { extraLayoutPath = "./xkb-layout/chaoflow"; };
  };

  powerManagement.enable = true;

  security.pam.loginLimits = [
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
  ];

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
    httpd = {
      enable = false;
      enableUserDir = true;
    };
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
        # Take care, empty lines will mess up whitespace removal.  It would be
        # nice if empty lines would not be considered in minimal leading
        # whitespace analysis, but don't know about further implications.  Also
        # take care not to mix tabs and spaces. Should tabs be treated like 8
        # spaces?
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
        # The <relayhost> is exactly what you specified for relayHost, resp.
        # relayhost.
        smtp_sasl_password_maps = hash:/etc/nixos/cfg-private/postfix_passwd
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
      # custom is set in ./bin/init_keyboard.sh via .xsession with the
      # advantage of not breaking X in case the layout did not make it into the
      # newest profile generation
      layout = "us";
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
