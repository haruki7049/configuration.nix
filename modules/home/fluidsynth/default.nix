{ pkgs, ... }:

{
  services.fluidsynth.enable = true;
  services.fluidsynth.soundFont = "${pkgs.soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2";
  services.fluidsynth.soundService = "pipewire-pulse";
}
