(use-package dracula-theme
  :init
  (load-theme 'dracula t))

(use-package eglot
  :requires
  (rust-mode zig-mode nix-mode)
  :init
  ((with-eval-after-load 'eglot
     (add-to-list 'eglot-server-programs
                  '(typst-mode . ("tinymist"))
                  '(nix-mode . ("nil"))
                  '(zig-mode . ("zls"))
                  '(rust-mode . ("rust-analyzer"))))))

(use-package typst-mode
  ;;:straight (:type git :host github :repo "Ziqi-Yang/typst-mode.el")
  :config
  (setq typst-indent-offset 2)
  :init
  (add-to-list 'auto-mode-alist '("\\.typ\\'" . typst-mode)))

(use-package rust-mode)

(use-package zig-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.zig\\'" . zig-mode)))

(use-package nix-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode)))

(use-package envrc
  :init
  (add-hook 'after-init-hook 'envrc-global-mode))

(use-package ddskk
  :init
  (global-set-key "\C-x\C-j" 'skk-mode))

(use-package vertico
  :init
  (vertico-mode))

;; Indentation
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

;; FONT SETTING
(set-face-attribute 'default nil
                    :family "UDEV Gothic NF" ;;This point has a font dependency
                    :height 140)

;; Save history of mini-buffer and etc
(savehist-mode 1)

;; Backup files
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Delete menu bar
(menu-bar-mode -1)

;; Display line number
(global-display-line-numbers-mode t)

;; Delete tool bar
(tool-bar-mode -1)

;; Delete welcome message
(setq inhibit-startup-message t)

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
