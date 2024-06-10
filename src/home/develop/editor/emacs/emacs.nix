{ config, lib, pkgs, ... }:
let
  emacsConfig = ''
    ;; FONT SETTING
    (set-face-attribute 'default nil
      :family "UDEV Gothic NF" ;;This point has a font dependency
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

    ;; zig-mode
    (autoload 'zig-mode "zig-mode" "Major mode for editing Zig code" t)
    (add-to-list 'auto-mode-alist '("\\.zig\\'" . zig-mode))

    ;; nix-mode
    (autoload 'nix-mode "nix-mode" "Major mode for editing Nix code" t)
    (add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))

    ;; SLIME settings
    (slime-setup '(slime-repl slime-fancy slime-banner))
    (setq slime-lisp-implementations
      '((sbcl ("sbcl"))
        (ecl ("ecl"))
        (clisp ("clisp"))))

    ;; Eglot settings
    (with-eval-after-load 'eglot
      (add-to-list 'eglot-server-programs
        '(nix-mode . ("nixd"))))
    (with-eval-after-load 'eglot
      (add-to-list 'eglot-server-programs
        '(zig-mode . ("zls"))))
    (with-eval-after-load 'eglot
      (add-to-list 'eglot-server-programs
        '(rust-mode . ("rust-analyzer"))))

    (add-hook 'rust-mode-hook 'eglot-ensure)
    (add-hook 'zig-mode-hook 'eglot-ensure)
    (add-hook 'nix-mode-hook 'eglot-ensure)
  '';
  emacsExtraPackages = epkgs: with epkgs; [
    ef-themes
    eglot
    treemacs
    slime
    rust-mode
    zig-mode
    nix-mode
  ];
in
{
  programs.emacs = {
    enable = true;
    extraConfig = emacsConfig;
    extraPackages = emacsExtraPackages;
    package = pkgs.emacs;
  };
}
