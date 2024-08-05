{ pkgs }:

pkgs.emacs-gtk.overrideAttrs (oldAttrs: {
  withX = true;
  withPgtk = true;
  withGTK3 = true;
  withXwidgets = true;
  withAlsaLib = true;
})
