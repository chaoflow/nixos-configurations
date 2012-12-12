{ ... }:

{
  # no beeping, thx Jonas!
  boot.blacklistedKernelModules = [ "snd_pcsp" "pcspkr" ];
}
