{ config, lib, pkgs, ... }:
let
  emacsConfig = ''
    ;; FONT SETTING
    (set-face-attribute 'default nil
      :family "UDEV Gothic NF"
      :height 80)

    ;; Backup files
    (setq make-backup-files nil)
    (setq auto-save-default nil)

    ;; Delete menu bar
    (menu-bar-mode -1)

    ;; Display line number
    (global-display-line-numbers-mode t)

    ;; Delete tool bar
    (tool-bar-mode -1)

    ;; Delete scroll bar
    (scroll-bar-mode -1)

    ;; Delete welcome message
    (setq inhibit-startup-message t)

    ;; Custom theme
    (load-theme 'ef-maris-dark t)

    ;; Add News Feed to newsticker.el
    (setq newsticker-url-list
          '(("deno" "https://deno.com/feed")
      ("this week in rust" "https://this-week-in-rust.org/rss.xml")
      ("Rust-lang Main blog" "https://blog.rust-lang.org/feed.xml")
      ("Rust-lang 'Inside rust' blog" "https://blog.rust-lang.org/inside-rust/feed.xml")
      ("zenn.dev - webrtc" "https://zenn.dev/topics/webrtc/feed")
      ("zenn.dev - Rust" "https://zenn.dev/topics/rust/feed")
      ("zenn.dev - FreeBSD" "https://zenn.dev/topics/freebsd/feed")
      ("zenn.dev - TypeScript" "https://zenn.dev/topics/typescript/feed")
      ("zenn.dev - Deno" "https://zenn.dev/topics/deno/feed")
      ("zenn.dev - React" "https://zenn.dev/topics/react/feed")))

    ;; Language Mode's settings
    ;; for Rust-lang
    (add-hook 'rust-mode-hook
      (lambda ()
        (setq-local indent-tabs-mode nil)
        (setq-local tab-width 4)))
    (add-hook 'rust-mode-hook 'eglot-ensure)

    ;; for Common Lisp
    (setq inferior-lisp-program "sbcl")
  '';
  emacsExtraPackages = epkgs: with epkgs; [
    ef-themes
    magit
    rust-mode
    slime
    treemacs
  ];
in
{
  programs.emacs = {
    enable = true;
    extraConfig = emacsConfig;
    extraPackages = emacsExtraPackages;
    package = pkgs.emacs;
  };
  services.emacs = {
    enable = true;
    socketActivation.enable = true;
    defaultEditor = false;
    client.enable = true;
  };
}
