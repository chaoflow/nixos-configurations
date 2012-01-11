NixOS Configuration
===================

Configuration and description of my nixos configuration. If you have some nice
ideas how to improve, feel free to fork and let me know about your changes.

Also if I am explaining something wrong, please let me know.

Enjoy NixOS!


Hardware
--------

Laptop, Lenovo x201s, Core i7 L640, WXGA+ screen

lspci::

  00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 02)
  00:02.0 VGA compatible controller: Intel Corporation Core Processor Integrated Graphics Controller (rev 02)
  00:16.0 Communication controller: Intel Corporation 5 Series/3400 Series Chipset HECI Controller (rev 06)
  00:19.0 Ethernet controller: Intel Corporation 82577LM Gigabit Network Connection (rev 06)
  00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 06)
  00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio (rev 06)
  00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 (rev 06)
  00:1c.4 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 5 (rev 06)
  00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 06)
  00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a6)
  00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC Interface Controller (rev 06)
  00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 6 port SATA AHCI Controller (rev 06)
  00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus Controller (rev 06)
  00:1f.6 Signal processing controller: Intel Corporation 5 Series/3400 Series Chipset Thermal Subsystem (rev 06)
  02:00.0 Network controller: Intel Corporation Centrino Ultimate-N 6300 (rev 35)
  ff:00.0 Host bridge: Intel Corporation Core Processor QuickPath Architecture Generic Non-core Registers (rev 02)
  ff:00.1 Host bridge: Intel Corporation Core Processor QuickPath Architecture System Address Decoder (rev 02)
  ff:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 02)
  ff:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 02)
  ff:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
  ff:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 02)


Software
--------

- display manager: slim
- window manager: xmonad
- mailing: postfix, offlineimap, notmuch, emacs
- calendar: emacs, orgmode
- browser: conkeror, firefox, chrome


Dealing with non-NixOS builds
-----------------------------

NixOS does not have ``/usr``, instead there are profiles.

You can define environments_, and use them to create profiles::

    $ nix-env -p $NIX_USER_PROFILE_DIR/py27 -i py27env

The same, but using a wrapper_::

    $ pnix-env py27 -i py27env

To use the environment, I use `another wrapper`_::

    $ py27env python bootstrap.py
    $ py27env python ./bin/buildout

It can also be sourced::

    $ source ~/bin/py27env

More on this you can find here_.

.. _environments: https://github.com/chaoflow/skel/blob/master/.nixpkgs/config.nix
.. _wrapper: https://github.com/chaoflow/skel/blob/master/bin/pnix-env
.. _`another wrapper`: https://github.com/chaoflow/skel/blob/master/bin/py27env
.. _here: http://wiki.nixos.org/wiki/Howto_keep_multiple_packages_up_to_date_at_once

Advantages
^^^^^^^^^^

- rollback in case something is broken
- possibility for having dedicated build environments
- Packages that search things in ``/usr`` still won't work, but you
  can use one such profile and link it to ``/usr``. However, better
  would be to patch the offending packages.

FAQ
---

Q: How can I get a shell in an nix build environment?
A: "exit 1" in the corresponding phase + nix-env -K

1. "exit 1" in the corresponding phase
2. nix-env -K <package> -> will print the temp dir that is left over

or:

nix-build -K -A emacs23Packages.org /etc/nixos/nixpkgs/default.nix



TODO
----

- create config dir in nixos svn and point to github, wait for github
  migration

- suspend and hibernate vie Fn-<key>, used to work via awesome
  mappings

- (semi-)automatic backup

- hibernate on very low battery

- modularize config so generic parts can be reused by others directly

- grub menu: indicate number of profile used as default, eg. in brackets

Issues
^^^^^^
- notmuch asks twice for passphrase, probably something about the
  gpg-agent

- sudo does not remember me after system restart

- sudo nixos-rebuild switch complains about locales

- rxvt-unicode terminfo not available when sudo

- anacron or is it somehow else ensured that commands are run, if
  powered off at given time

- collisions in system-environment, priorization?

- mail (from mailutils) expects /usr/bin/sendmail

- postfix issues several warnings

- postfix, received header (Local time zone must be set--see zic
  manual page)

- postfix, verify server certificate

- postfix, check whether it runs chrooted

- postconf: smtp_sasl_tls_security_options = $var_smtp_sasl_opts ?!
  manually overwritten


nice to have
^^^^^^^^^^^^
- get pm-suspend-hybrid to work, I think it does hibernate but then
  only suspends. Good if you forget that your laptop is in suspend for
  a couple of days. On the other hand, hibernate and resume from it is
  fast enough. so basically no need for suspend.

- pm-powersave true|false support?

- package qbittorrent

- how could profiles be tested? including then packaged vim plugins,
  zc.buildouts depending on them, ... Would be great to build a new
  profile and automatically test it

- can system profiles be labelled so they show up more meaningful in
  grub?

- replace rsyslog with something that buffers and only rarely writes
  to disk (old, from ubuntu)

- check sata link, host1 does not like min_power or something sets
  them to max_performance again (old, from ubuntu)

- console keymap (alt, ctrl on caps)

- mail rely should pretend mails coming via submission are locally
  generated to hide ip of the client sending it (server issue, not
  nixos related)


- nix store optimise reports far less savings than achieved::

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


Credits
-------

A big thank you for patient support via irc and mail:

- Cillian de Róiste
- Eelco Dolstra
- Evgeny Egorochkin
- Lluís Batlle i Rossell
- Marc Weber
- Micheal Raskin
- Nicolas Pierron
- Peter Simons
- Vladimír Čunát
