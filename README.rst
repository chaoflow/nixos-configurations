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
- more fonts
- zsh
- get rid of all sytem profiles except the current
- understand the difference between a packag, derivation and attribute. How does nix-env -i <foo> relate to pkgs.fooBar?
- ipython for each python version

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


nix store optimise reports far less savings than achieved::
  [root@eve:~]# df -h            
  Filesystem            Size  Used Avail Use% Mounted on
  /dev/mapper/eve-nixos
			7.9G  5.0G  2.6G  67% /
  none                  3.9G  2.0M  3.9G   1% /dev
  tmpfs                 3.9G     0  3.9G   0% /dev/shm
  none                  3.9G  720K  3.9G   1% /var/run
  /dev/mapper/eve-home  119G  100G   14G  89% /home

  [root@eve:~]# nix-store --optimise
  skipping suspicious writable file `/nix/store/h531fraz114nyf7bh15aqfdk9nif6j8q-linux-2.6.36.2/lib/modules/2.6.36.2/modules.ccwmap'
  skipping suspicious writable file `/nix/store/h531fraz114nyf7bh15aqfdk9nif6j8q-linux-2.6.36.2/lib/modules/2.6.36.2/modules.ofmap'
  skipping suspicious writable file `/nix/store/h531fraz114nyf7bh15aqfdk9nif6j8q-linux-2.6.36.2/lib/modules/2.6.36.2/modules.pcimap'
  skipping suspicious writable file `/nix/store/h531fraz114nyf7bh15aqfdk9nif6j8q-linux-2.6.36.2/lib/modules/2.6.36.2/modules.seriomap'
  skipping suspicious writable file `/nix/store/h531fraz114nyf7bh15aqfdk9nif6j8q-linux-2.6.36.2/lib/modules/2.6.36.2/modules.symbols'
  skipping suspicious writable file `/nix/store/h531fraz114nyf7bh15aqfdk9nif6j8q-linux-2.6.36.2/lib/modules/2.6.36.2/modules.ieee1394map'
  skipping suspicious writable file `/nix/store/h531fraz114nyf7bh15aqfdk9nif6j8q-linux-2.6.36.2/lib/modules/2.6.36.2/modules.isapnpmap'
  skipping suspicious writable file `/nix/store/h531fraz114nyf7bh15aqfdk9nif6j8q-linux-2.6.36.2/lib/modules/2.6.36.2/modules.alias'
  skipping suspicious writable file `/nix/store/h531fraz114nyf7bh15aqfdk9nif6j8q-linux-2.6.36.2/lib/modules/2.6.36.2/modules.inputmap'
  skipping suspicious writable file `/nix/store/h531fraz114nyf7bh15aqfdk9nif6j8q-linux-2.6.36.2/lib/modules/2.6.36.2/modules.dep'
  skipping suspicious writable file `/nix/store/h531fraz114nyf7bh15aqfdk9nif6j8q-linux-2.6.36.2/lib/modules/2.6.36.2/modules.usbmap'
  816411305 bytes (778.59 MiB, 3690712 blocks) freed by hard-linking 308398 files; there are 308398 files with equal contents out of 404000 files in total

  [root@eve:~]# df -h
  Filesystem            Size  Used Avail Use% Mounted on
  /dev/mapper/eve-nixos
			7.9G  3.2G  4.3G  43% /
  none                  3.9G  2.0M  3.9G   1% /dev
  tmpfs                 3.9G     0  3.9G   0% /dev/shm
  none                  3.9G  720K  3.9G   1% /var/run
  /dev/mapper/eve-home  119G  100G   14G  89% /home

