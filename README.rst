NixOS Configuration
===================


Hardware
--------

Laptop, Lenovo x200s, WXGA+ screen

lspci::

  00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
  00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
  00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
  00:03.0 Communication controller: Intel Corporation Mobile 4 Series Chipset MEI Controller (rev 07)
  00:03.2 IDE interface: Intel Corporation Mobile 4 Series Chipset PT IDER Controller (rev 07)
  00:03.3 Serial controller: Intel Corporation Mobile 4 Series Chipset AMT SOL Redirection (rev 07)
  00:19.0 Ethernet controller: Intel Corporation 82567LM Gigabit Network Connection (rev 03)
  00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
  00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03)
  00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03)
  00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03)
  00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
  00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
  00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 03)
  00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
  00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
  00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
  00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03)
  00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
  00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev 03)
  00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03)
  00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
  03:00.0 Network controller: Intel Corporation PRO/Wireless 5100 AGN [Shiloh] Network Connection


Software
--------

- display manager: slim
- window manager: awesome
- mailing: mutt, postfix, offlineimap
- calendar: remind, wyrd
- browser: firefox with vimperator


I'm aiming at getting my changes into the official nixos and nixpkgs repos. In
any case here are the versions of nixpkgs and nixos I am using:

- nixos: https://github.com/chaoflow/nixos
- nixpkgs: https://github.com/chaoflow/nixpkgs


TODO
----

- mutt + gnupg
- vim + plugins
- wyrd
- custom keymap or migrate to pure xmodmap
- more fonts
- zsh


Issues
^^^^^^

- awesome cannot set background but feh is in system-path
- sudo does not remember me after system restart
- sudo nixos-rebuild switch complains about locales
- rxvt-unicode terminfo not available (temp solution: link current derivation to ~/.terminfo)
- zsh paths are messed up, looks like /etc/bashrc and profile should be split
- anacron or is it somehow else ensured that commands are run, if powered off at given time
- collisions in system-environment, priorization?
- mutt expects /usr/bin/sendmail (bypassed via .muttrc, not how it is supposed to be)
- mail (from mailutils) expects /usr/bin/sendmail
- postfix issues several warnings
- postfix, received header (Local time zone must be set--see zic manual page)
- postfix, verify server certificate
- postfix, check whether it runs chrooted
- postconf: smtp_sasl_tls_security_options = $var_smtp_sasl_opts ?! manually overwritten
- rebasing of my branches collides with github: master (current branch) cannot
  be deleted and pushing with rewriting history is not supported. Maybe merging
  would be better.


nice to have
^^^^^^^^^^^^

- mutt colors
- wicd
- replace rsyslog with something that buffers and only rarely writes to disk
  (old, from ubuntu)
- check sata link, host1 does not like min_power or something sets them to
  max_performance again (old, from ubuntu)
- console keymap (alt, ctrl on caps)
- visual beep / no beep
- mail rely should pretend mails coming via submission are locally generated to
  hide ip of the client sending it (server issue, not nixos related)
