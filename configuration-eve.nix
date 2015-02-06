# Edit this configuration file which defines what would be installed on the
# system.  To Help while choosing option value, you can watch at the manual
# page of configuration.nix or at the last chapter of the manual available
# on the virtual console 8 (Alt+F8).

{ pkgs, ... }:

{
  require = [
    ./hardware.nix
    ./intel-xts-luksroot-sda.nix
    ./filesystems-boot-root-tmptmpfs.nix
    ./nobeep.nix
  ];

  boot = {
    extraModprobeConfig = ''
      options thinkpad_acpi fan_control=1
    '';
    initrd.luks.devices = [ { name = "luksroot"; device = "/dev/sda3";
                              allowDiscards = true; } ];
    # powertop needs msr and so far it does not load when needed
    kernelModules = [ "msr" ];
    kernelPackages = pkgs.linuxPackages_3_16;
    # major:minor number of my swap device, fully lvm-based system
    #resumeDevice = "254:1";
  };

  environment = {
    #nix = pkgs.nixUnstable;

    # To also get the header files in the system environment. You only need
    # this if you want compile non-nixos stuff against the system environment.
    # You would only want that as a part of temporary solution to continue on
    # whatever you were working before christmas. However, there are better
    # ways. See https://github.com/chaoflow/nixos-configurations for more on
    # that.
    #pathsToLink = ["include"];

    # shellInit = ''
    #   export GEM_PATH=/var/run/current-system/sw/${pkgs.ruby.gemPath}
    #   export RUBYLIB=/var/run/current-system/sw/lib
    #   export RUBYOPT=rubygems
    # '';

    systemPackages = with pkgs; [
      acpitool
      alsaLib
      alsaPlugins
      alsaUtils
      cpufrequtils
      cryptsetup
      ddrescue
      dmenu
      file
      hdparm
      htop
      keychain
      sdparm
      zsh
          ant
          autoconf
          automake
          bazaar
          bazaarTools
          bc
          beret
          cmake
          colordiff
          cvs
          cvsps
          gcc
          gdb
          geeqie
          ghostscript
          gimp
          gitAndTools.gitFull
          gitAndTools.svn2git
          gitAndTools.tig
          gnupg
          gnupg1
          gnumake
          gperf
          graphviz
          guile
          imagemagick
          io
          irssi
          jscoverage
          jwhois
          links2
          lsof
          lua5
          lxdvdrip
          lynx
          man
          mdbtools
          mercurial
          ncftp
          netcat
          nmap
          openvpn
          p7zip
          parted
          pdfjam
          pinentry
          powertop
          pwgen
          qrencode
          rtorrent
          ruby
          screen
          stdmanpages
          subversion
          tcpdump
          telnet
          (let myTexLive = 
            pkgs.texLiveAggregationFun {
              paths =
                [ pkgs.texLive
                  pkgs.texLiveCMSuper
                  pkgs.texLiveExtra
                  pkgs.texLiveBeamer ];
            };
           in myTexLive)
          units
          unzip
          vim
          vlc
          w3m
          wget
          zip
          gv
          glxinfo
          mplayer
          rxvt_unicode
          qemu_kvm
          scrot
          unetbootin
          xlockmore
          xorg.xkill
          xpdf

      haskellPackages.xmonad
      haskellPackages.xmonadContrib
      haskellPackages.xmonadExtras
      stalonetray
      wpa_supplicant_gui
      xfontsel
      xlibs.xev
      xlibs.xinput
      xlibs.xmessage
      xlibs.xmodmap
    ];
  };

  # XXX: add more fonts!
  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = false;

    # terminus I use for rxvt-unicode
    # see https://github.com/chaoflow/chaoflow.skel.home/blob/master/.Xdefaults
    fonts = [
       #pkgs.cantarell_fonts
       #pkgs.dejavu_fonts
       #pkgs.dosemu_fonts
       #pkgs.freefont_ttf
       #pkgs.liberation_ttf
       pkgs.terminus_font
       #pkgs.ubuntu_font_family
       #pkgs.ucsFonts
       #pkgs.unifont
       #pkgs.vistafonts
       #pkgs.xlibs.fontadobe100dpi
       #pkgs.xlibs.fontadobe75dpi
       #pkgs.xlibs.fontadobeutopia100dpi
       #pkgs.xlibs.fontadobeutopia75dpi
       #pkgs.xlibs.fontadobeutopiatype1
       #pkgs.xlibs.fontarabicmisc
       pkgs.xlibs.fontbh100dpi
       pkgs.xlibs.fontbh75dpi
       pkgs.xlibs.fontbhlucidatypewriter100dpi
       pkgs.xlibs.fontbhlucidatypewriter75dpi
       pkgs.xlibs.fontbhttf
       pkgs.xlibs.fontbhtype1
       pkgs.xlibs.fontbitstream100dpi
       pkgs.xlibs.fontbitstream75dpi
       pkgs.xlibs.fontbitstreamtype1
       #pkgs.xlibs.fontcronyxcyrillic
       pkgs.xlibs.fontcursormisc
       pkgs.xlibs.fontdaewoomisc
       pkgs.xlibs.fontdecmisc
       pkgs.xlibs.fontibmtype1
       pkgs.xlibs.fontisasmisc
       pkgs.xlibs.fontjismisc
       pkgs.xlibs.fontmicromisc
       pkgs.xlibs.fontmisccyrillic
       pkgs.xlibs.fontmiscethiopic
       pkgs.xlibs.fontmiscmeltho
       pkgs.xlibs.fontmiscmisc
       pkgs.xlibs.fontmuttmisc
       pkgs.xlibs.fontschumachermisc
       pkgs.xlibs.fontscreencyrillic
       pkgs.xlibs.fontsonymisc
       pkgs.xlibs.fontsunmisc
       pkgs.xlibs.fontwinitzkicyrillic
       pkgs.xlibs.fontxfree86type1
    ];
  };

  hardware.pulseaudio.enable = true;
  # per user is broken (for me?)
  hardware.pulseaudio.systemWide = true;
  hardware.trackpoint.enable = true;
  hardware.trackpoint.sensitivity = 255;
  #hardware.trackpoint.speed = 255;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  networking = {
    domain = "chaoflow.net";
    # hardcode domain name
    # extraHosts = ''
    #   127.0.0.1 eve.chaoflow.net eve
    # '';
    firewall = {
      allowedTCPPorts = [ 80 ];
      enable = true;
    };
    hostName = "eve";
    interfaceMonitor.enable = false; # Watch for plugged cable.
    # host network for qemu-kvm
    localCommands = ''
      ip addr add 10.0.0.1/24 dev lo
      ${pkgs.procps}/sbin/sysctl -w net.ipv4.ip_forward=1
    '';
    networkmanager.enable = false;
    wireless.enable = true;
    wireless.driver = "nl80211";
    wireless.interfaces = [ "wlp2s0" ];
    wireless.userControlled.enable = true;
  };

  nix.extraOptions = ''
    auto-optimise-store = true
    env-keep-derivations = true
    gc-keep-outputs = true
    gc-keep-derivations = true
  '';
  nix.useChroot = true;

  nixpkgs.config = {
    # XXX: unused so far
    xkeyboard_config = { extraLayoutPath = "./xkb-layout/chaoflow"; };
  };

  powerManagement.cpuFreqGovernor = "ondemand";
  powerManagement.enable = true;
  #powerManagement.aggressive = true;

  users.defaultUserShell = "/var/run/current-system/sw/bin/zsh";

  security.pam.loginLimits = [
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
  ];

  services.atd.enable = false;
  services.dovecot2.enable = true;
  services.dovecot2.enablePop3 = false;
  services.dovecot2.mailLocation = "maildir:~/.mail";
  services.dovecot2.extraConfig = ''
    listen = 127.0.0.1
    namespace {
      separator = /
      inbox = yes
    }
  '';
  services.httpd = {
    adminAddr = "flo@chaoflow.net";
    enable = true;
    enableUserDir = true;
  };
  services.locate.enable = true;
  services.nixosManual.showManual = false;
  services.openssh.enable = false;
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.foomatic_filters ];
  services.postfix = {
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
      relayhost = [0x2c.org]:submission
      #relayhost = [127.0.0.1]:1587
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
    rootAlias = "cfl";
  };
  services.thinkfan.enable = true;
  services.xserver = {
    autorun = true;
    # no desktop manager, no window manager configured here. This
    # results in only one session *custom* for slim which executes
    # ~/.xsession. See:
    # https://github.com/chaoflow/chaoflow.skel.home/blob/master/.xsession
    desktopManager.xterm.enable = false;
    displayManager.slim = {
      defaultUser = "cfl";
      #hideCursor = true;
    };
    enable = true;
    exportConfiguration = true;
    # custom is set in ./bin/init_keyboard.sh via .xsession with the
    # advantage of not breaking X in case the layout did not make it into the
    # newest profile generation
    layout = "us";
  };

  # List swap partitions that are mounted at boot time.
  #swapDevices = [{ label = "swap"; }];

  #time.timeZone = "Asia/Hong_Kong";
  time.timeZone = "Europe/Berlin";
  #time.timeZone = "US/Eastern";
  #time.timeZone = "US/Pacific";
}
