;;; Thomas K emacs config --- Summary
;;; Commentary:
;;; Code:
(setq inhibit-startup-message t )
(if (display-graphic-p)
    (progn (tool-bar-mode -1)
	   (set-fringe-mode 10)
	   (scroll-bar-mode -1)))
(scroll-bar-mode -1)   ; Disable visible scrollbar
(tool-bar-mode -1)     ; Disable the toolbar
(tooltip-mode 01)      ; Disable the tooltips
(set-fringe-mode 10)   ; Give some breathing room
(battery)
(menu-bar-mode -1)     ; Disable the menu bar
(setq mac-option-modifier 'meta)
;; Set up the visible bell
(setq visible-bell t)
(setq make-backup-files nil)
(set-face-attribute
 'default nil
 :font "BerkeleyMono Nerd Font Mono Plus Font Awesome Plus Font Awesome Extension Plus Octicons Plus Power Symbols Plus Codicons Plus Pomicons Plus Font Logos Plus Material Design Icons Plus Weather Icons"
 :height 200) ;; set font
(set-fontset-font t nil "Symbols Nerd Font Mono" nil 'append)
(global-auto-revert-mode) ;; emacs will reload buffer from changed file on disk.

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;; Native-comp-pgtk
(when (featurep 'native-compile)
  (setq comp-deferred-compilation t
	comp-async-report-warnings-errors nil
	native-comp-speed 3
	native-comp-async-jobs-number 12
	byte-compile-warnings nil
        package-native-compile t))

(use-package exec-path-from-shell
  :commands exec-path-from-shell-initialize
  :config
  (when (or (memq window-system '(mac ns x)) (daemonp))
    (exec-path-from-shell-initialize)))
(use-package use-package-ensure-system-package)

(setq vc-follow-symlinks t
      coding-system-for-read 'utf-8
      coding-system-for-write 'utf-8
      sentence-end-double-space nil
      custom-file null-device
      byte-compile-debug t)

;;(setq display-battery-mode 1)
(setq-default visible-bell nil)
(setq ring-bell-function 'ignore
      initial-buffer-choice t
      initial-scratch-message nil)

;; Make ESC quit prompts
;;(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Make C-M-j launch counsel buffer switcher
;;(global-set-key (kbd "C-M-j") 'counsel-switch-buffer)

;; Init package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
	    		 ("org" . "https://orgmode.org/elpa")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Init use-package on on-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Initialise GPG SSH socket
;; without `SSH_AUTH_SOCK`, magit and pinentry won't work!
(let ((ssh-auth-sock (shell-command-to-string "~/.nix-profile/bin/gpgconf --list-dirs agent-ssh-socket")))
  (setenv "SSH_AUTH_SOCK" (string-trim ssh-auth-sock)))

;; Show line numbers on the left margin
(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0 ))))


(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package counsel
  :after (ivy)
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)) ;; Dont' start searches with ^

;; Doomline is the info bar at the bottom of the window
(use-package doom-modeline
  :init
  (doom-modeline-mode 1)
  ;;  (battery)
  :after (nerd-icons)
  :config
  (setq fancy-battery-mode 1)
  (setq doom-modeline-battery t)
  (setq doom-modeline-icon t)
  (setq doom-modeline-major-mode-icon-identifier 'nerd-icons)
  (setq doom-modeline-unicode-fallback t)
  (setq doom-modeline-project-detection 'auto)
  (setq doom-modeline-height 45)
  (setq doom-modeline-bar-width 6)
  (setq doom-modeline-project-detection 'project)
  (setq doom-modeline-project-detection 'ffip)
  (setq doom-modeline-major-mode-color-icon t))

;; All the icons!
(use-package all-the-icons
  :config
  (unless (find-font (font-spec :name "all-the-icons"))
    (all-the-icons-install-fonts t)))

(use-package nerd-icons
  :config
  (unless (find-font (font-spec :name "Symbols Nerd Font Mono"))
    (nerd-icons-install-fonts t)))

;; Doom Themes
(use-package doom-themes
  :config (load-theme 'doom-palenight t))

;; Rainbow-delmiters highlights matching parens
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Which-key provides a completeion list for key shortcuts
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config (setq which-key-idel-delay 0.3))

;; Ivy-rich provides completions for commands
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

;; Helpful
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; General - Configuration for key-bindings
(use-package general
  :config
  (general-create-definer bitshifta/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (bitshifta/leader-keys
    "t" '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")
    "ts" '(hydra-text-scale/body :which-key "scale-text")

    "p" '(:ignore t :which-key "project")
    "pp" '(projectile-switch-project :which-key "switch project")
    "pf" '(projectile-find-file :which-key "find project file")
    "pd" '(projectile-find-dir :which-key "find project dir (dired)")
    "ps" '(projectile-ag :which-key "search project (ag/rg)")
    "pb" '(projectile-switch-to-buffer :which-key "switch project buffer")

    "f" '(:ignore t :which-key "file")
    "ff" '(counsel-find-file :which-key "find file")
    "fr" '(counsel-recentf :which-key "find recent file")

    "b" '(:ignore t :which-key "buffer")
    "bb" '(counsel-switch-buffer :which-key "switch buffer")
    "bi" '(counsel-ibuffer :which-key "ibuffer")
    "bk" '(kill-current-buffer :which-key "kill current buffer")

    "g" '(:ignore t :which-key "git (magit)")
    "gg" '(magit-status :which-key "magit status")
    "gb" '(magit-blame :which-key "git blame")
    "gl" '(magit-log-current :which-key "git log current")
    "gf" '(magit-fetch :which-key "git fetch")
    "gp" '(magit-push :which-key "git push")

    "j" '(:ignore t :which-key "justl")
    "jj" '(justl-select-recipe-and-run :which-key "run recipe...")
    "jr" '(justl-run-default-target :which-key "run default recipe")
    "jl" '(justl :which-key "list recipes")
    "jh" '(justl-help-popup :which-key "help popup")
    "je" '(justl-exec-recipe :which-key "execute recipe")
    )
  )

;; Evil
(defun bitshifta/evil-hook ()
  (dolist (mode '(custom-mode
		  eshell-mode
		  git-rebase-mode
		  erc-mode
		  circe-server-mode
		  circe-chat-mode
		  circe-query-mode
		  sauron-mode
		  term-mode))
    (add-to-list 'evil-emacs-state-modes mode)))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  ;;  :hook (evil-mode . bitshifta/evil-hook)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; Hydra - temporary context specific key bindings
(use-package hydra)
(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))
(bitshifta/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale-text"))

;; Projectile
(use-package projectile
  :diminish projectile-mode
  :config
  (projectile-mode)
  (setq projectile-switch-project-action 'projectile-dired)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/work")
    (setq projectile-project-search-path '("~/work")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :after projectile
  :config (counsel-projectile-mode))

;; Magit -- git for emacs
(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))
;; blamer -- git blame plugin
(use-package blamer
  :straight (:host github :repo "artawower/blamer.el")
  :bind (("s-i" . blamer-show-commit-info))
  :custom
  (blamer-idle-time 0.3)
  (blamer-min-offset 70)
  :custom-face
  (blamer-face ((t :foreground "#7a88cf"
                    :background nil
                    :height 180
                    :italic t)))
  :config
  (global-blamer-mode 1))

;; Pinentry
(use-package pinentry
  :defer nil
  :config (pinentry-start))
;; org -- org for emacs
(defun bitshifta/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil))

(use-package org
  :hook (org-mode . bitshifta/org-mode-setup)
 :init
  (setq org-meetings-file "~/Documents/org/meetings.org")
  :custom
  (org-element-use-cache t)
  (org-ellipsis " ▼")
  (org-hide-emphasis-markers t)
  (org-todo-keywords '((sequence "TODO(t)" "DOING(g)" "|" "DONE(d)")))
  (org-meetings-file "~/Documents/org/meetings.org")
  (org-directory "~/Documents/org/")
  (org-default-notes-file "~/Documents/org/refile.org")
  (org-agenda-files (directory-files "~/Documents/org/" "\\.org$"))
  (org-capture-templates
  '(("m" "Work Meeting"
     entry (file+olp+datetree "~/Documents/org/meetings.org" "Day to Day Meetings")
     "* %^{What are we discussing?}
:PROPERTIES:
:ID: %(org-id-new)
:Attendees: %^{Attendees}
:END:
** When: %^{When is the meeting?}
** Prep/Links: %^{Notes}
** Notes:"
     :prepend t
     :clock-in t
     :clock-resume t
     :time-prompt t)))
  :general
  ;; Global org keybindings
  ("C-c a" 'org-agenda
   "C-c c" 'org-capture
   "C-c l" 'org-store-link))
(use-package org-modern
  :hook
  (org-mode . org-modern-mode))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;;(setq org-agenda-files (directory-files "~/Documents/org/" "\\.org$"))

(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/Documents/org")
  (org-roam-completion-everywhere t)
  (org-roam-dailies-capture-templates
   '(("d" "default" entry "* %<%I:%M %p>: %?"
      :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         :map org-mode-map
         ("C-M-i" . completion-at-point)
         :map org-roam-dailies-map
         ("Y" . org-roam-dailies-capture-yesterday)
         ("T" . org-roam-dailies-capture-tomorrow))
  :bind-keymap
  ("C-c n d" . org-roam-dailies-map)
  :config
  (require 'org-roam-dailies) ;; Ensure the keymap is available
  (org-roam-db-autosync-mode))

(defun bitshifta/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
	visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :after org
  :hook (org-mode . bitshifta/org-mode-visual-fill))

;; treemacs - file navigator
(use-package treemacs)
(use-package treemacs-evil
  :after (treemacs evil))
(use-package treemacs-projectile
  :after (treemacs projectile))
(use-package treemacs-all-the-icons
  :after (treemacs all-the-icons))
(use-package treemacs-nerd-icons
  :config
  (treemacs-load-theme "nerd-icons"))
(use-package treemacs-magit
  :after (treemacs magit))
(use-package treemacs-icons-dired
  :after (treemacs dired)
  :hook (dired-mode . treemacs-icons-dired-enable-once))

;; Emacs startup dashboard
(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  :custom
  (dashboard-startup-banner 'logo)
  (dashboard-banner-logo-title "( KernelPanicAUS 😎)")
  (dashboard-init-info "")
  ;;(setq dashboard-items nil)
  (dashboard-projects-backend 'projectile)
  (dashboard-items '((recents   . 5)
                          (bookmarks . 5)
                          (projects  . 5)
                          (agenda    . 5)
                          (registers . 5)))
  (dashboard-item-shortcuts '((recents   . "r")
                                 (bookmarks . "m")
                                 (projects  . "p")
                                 (agenda    . "a")
                                 (registers . "e")))
  (dashboard-week-agenda t)
  ;(setq dashboard-filter-agenda-entry 'dashboard-no-filter-agenda)
  (dashboard-footer-messages '("😈 Happy hacking!   "))
  (define-key dashboard-mode-map (kbd "<f5>") #'(lambda ()
                                                  (interactive)
                                                  (dashboard-refresh-buffer)
                                                  (message "Refreshing Dashboard...done")))
  (dashboard-set-footer t)
  (dashboard-display-icons-p t)     ; display icons on both GUI and terminal
  (dashboard-icon-type 'nerd-icons) ; use `nerd-icons' package
  (dashboard-footer-icon "")
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  :hook
  (after-init . dashboard-setup-startup-hook))


(use-package direnv
  :commands direnv-mode
  :config (direnv-mode))

(use-package savehist
  :config
  (savehist-mode))


(use-package vertico
  :straight (:host github :repo "minad/vertico" :files ("*.el" "extensions/*.el"))
  :after (savehist)
  :custom
  (read-buffer-completion-ignore-case t)
  (completion-ignore-case t)
  (completion-styles '(flex))
  :config (vertico-mode))


(use-package vterm
  :init (setq-default vterm-always-compile-module t)
  :config
  (setq vterm-shell "/Users/tkhalil/.nix-profile/bin/zsh"))

(use-package vterm-toggle
  :init (setq vterm-always-compile-module t)
  :bind ("C-c C-d" . vterm-toggle-cd)
  :config
  (setq vterm-toggle-fullscreen-p nil)
  (add-to-list 'display-buffer-alist '("^\\*vterm\\*$"
				       (display-buffer-in-side-window)
				       (window-height . 0.35)
				       (side . bottom)
				       (slot . -1))))

(add-hook 'vterm-exit-hook (lambda () ;; Close vterm window when exiting
                             (let* ((buffer (current-buffer))
                                    (window (get-buffer-window buffer)))
                               (when window
                                 (delete-window window))
                               (kill-buffer buffer))))
(use-package nix-mode
  :mode "\\.nix\\'")

(use-package go-mode)
(setq gofmt-command "goimports")
(add-hook 'go-mode-hook 'lsp-mode-setup)
;; Go - lsp-mode
;; Set up before-save hooks to format buffer and add/delete imports.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; Start LSP Mode and YASnippet mode
(add-hook 'go-mode-hook #'lsp-deferred)


(use-package typescript-ts-mode
  :straight (:type built-in)
  :custom
  (lsp-javascript-display-enum-member-value-hints t)
  (lsp-javascript-display-parameter-name-hints 'all)
  (lsp-javascript-display-parameter-type-hints t)
  (lsp-javascript-display-property-declaration-type-hints t)
  (lsp-javascript-display-return-type-hints t)
  (lsp-javascript-display-variable-type-hints t)
  (lsp-typescript-surveys-enabled nil)
  (typescript-ts-mode-indent-offset 4)
  :config
  (require 'dap-node)
  (dap-node-setup)
  (defun bitshifta/typescript-setup ()
    "Setup for writing TS"
    (interactive)
    (setq-local devdocs-current-docs '("typescript" "node~18_lts"))
    (lsp-deferred))
  (defun tirimia/tsx-font-lock-fix ()
    "TSX TS parser is taking waaay too much memory. Gonna make fontification not happen as often."
    (setq-local jit-lock-defer-time 0.5))
  :mode (("\\.ts\\'" . typescript-ts-mode) ("\\.tsx\\'" . tsx-ts-mode))
  :hook (((tsx-ts-mode typescript-ts-mode) . bitshifta/typescript-setup)
         (tsx-ts-mode . bitshifta/tsx-font-lock-fix)))

(use-package lsp-mode
  :commands (lsp lsp-deferred lsp-format-buffer lsp-organize-imports lsp-completion-at-point)
  :custom
  (lsp-completion-provider :none)
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-diagnostic-clean-after-change t)
  (lsp-modeline-diagnostics-enable nil)
  (lsp-diagnostics-provider :flycheck)
  (lsp-signature-render-documentation nil)
  (lsp-inlay-hint-enable t)
  (lsp-disabled-clients '())
  (lsp-semgrep-languages '() "Disable this stupid lsp"))

(use-package dap-mode)

(use-package lsp-ui
  :general
  (:states 'normal :keymaps 'lsp-mode-map
           "gd" '(lsp-ui-peek-find-definitions :which-key "Definitions")
           "gr" '(lsp-ui-peek-find-references :which-key "References")
           "K" '(lsp-describe-thing-at-point :which-key "Describe"))
  :config
  (setq-default lsp-ui-sideline-enable nil)
  (setq-default lsp-ui-sideline-show-diagnostics nil)
  (setq-default lsp-ui-doc-show-with-cursor nil)
  (setq-default lsp-ui-doc-show-with-mouse nil)
  (setq-default lsp-ui-doc-use-webkit t))


(use-package corfu
  :commands (global-corfu-mode)
  :straight (:host github :repo "minad/corfu" :files ("*.el" "extensions/*.el"))
  :general
  (corfu-map "TAB" 'corfu-complete)
  (corfu-map "RET" nil)
  :bind ("M-/" . completion-at-point)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 2)
  (corfu-quit-no-match 'separator)
  (corfu-on-exact-match nil "Sometimes gets in the way something fierce, needs to be disabled")
  (corfu-cycle t)
  (corfu-preselect 'first)
  :config
  (corfu-popupinfo-mode 1)
  (defun corfu-enable-in-minibuffer ()
    "Enable Corfu in the minibuffer if `completion-at-point' is bound."
    (when (where-is-internal #'completion-at-point (list (current-local-map)))
      ;; (setq-local corfu-auto nil) ;; Enable/disable auto completion
      (setq-local corfu-echo-delay nil ;; Disable automatic echo and popup
                  corfu-popupinfo-delay nil)
      (corfu-mode 1)))
  (add-hook 'minibuffer-setup-hook #'corfu-enable-in-minibuffer))
(when (fboundp 'global-corfu-mode) (global-corfu-mode)) ;; need to run it outside the use-package because otherwise it won't load, wrapped to stop warning
;; if inside the block it needs a restart
(use-package yasnippet
  :after (evil)
  :commands yas-global-mode
  :defines (yas-keymap)
  :config (yas-global-mode)
  :general
  (:states 'insert
           "C-p" 'yas-insert-snippet)
  (:keymaps 'yas-keymap
            "RET" 'yas-next-field
            "TAB" nil
            "<tab>" nil
                                        ; "C-g" 'corfu-quit
            ))
(use-package yasnippet-snippets
  :after yasnippet)
(use-package yasnippet-capf
  :commands (yasnippet-capf)
  :after yasnippet)

(use-package cape
  :straight (:host github :repo "minad/cape" :files ("*.el"))
  :commands (cape-dabbrev cape-keyword cape-file cape-capf-super cape-wrap-silent cape-wrap-noninterruptible)
  :config
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (defun setup-lsp-completion ()
    (setq-local completion-at-point-functions (list (cape-capf-super
                                                     #'lsp-completion-at-point
                                                     #'yasnippet-capf)
                                                    #'cape-file
                                                    #'cape-dabbrev)))
  (defun setup-elisp-completion ()
    (setq-local completion-at-point-functions (list (cape-capf-super #'elisp-completion-at-point
                                                                     #'yasnippet-capf)
                                                    #'cape-file
                                                    #'cape-dabbrev)))
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-silent)
  ;; Lsp is not playing nicely with corfu and leads to it hanging, this fixes it https://github.com/minad/corfu/issues/188#issuecomment-1148658471
  (advice-add #'lsp-completion-at-point :around #'cape-wrap-noninterruptible)
  :hook
  (emacs-lisp-mode     . setup-elisp-completion)
  (lsp-completion-mode . setup-lsp-completion))

(use-package flycheck
  :after general
  :commands (global-flycheck-mode)
  :custom
  (flycheck-display-erors-delay 0.15)
  (flycheck-emacs-lisp-load-path 'inherit)
  :general
  (:states '(normal visual)
           "g[" 'flycheck-next-error
           "g]" 'flycheck-previous-error)
  ("M-g n" '(flycheck-next-error :which-key "Next error")
   "M-g p" '(flycheck-previous-error :which-key "Previous error"))
  :config
  (global-flycheck-mode 1))
;;(use-package consult-flycheck)
(use-package flycheck-inline
  :hook (flycheck-mode . flycheck-inline-mode))
(use-package flycheck-actionlint
  :after flycheck
  :config (flycheck-actionlint-setup))
(use-package flycheck-relint
  :after flycheck
  :commands (flycheck-relint-setup)
  :config (flycheck-relint-setup))
(use-package flycheck-package
  :after (flycheck elisp-mode)
  :commands (flycheck-package-setup)
  :config (flycheck-package-setup))
(use-package flycheck-golangci-lint
  :after (flycheck go-ts-mode)
  :straight (:host github :repo "forgoty/flycheck-golangci-lint")
  :commands (flycheck-golangci-lint-setup)
  :config
  (flycheck-golangci-lint-setup))

(use-package lsp-biome
  :straight (:host github :repo "cxa/lsp-biome" :files ("lsp-biome.el"))
  :config
  (setq lsp-biome-organize-imports-on-save t)
  (setq lsp-biome-autofix-on-save t)
  (setq lsp-biome-format-on-save t)
  (setq lsp-biome-active-file-types (list (rx "." (or "tsx" "jsx"
                  "ts" "js"
                  "mts" "mjs"
                  "cts" "cjs"
                  "json" "jsonc")
          eos))))
;; optional if you want which-key integration
(use-package which-key
    :config
    (which-key-mode))

(use-package kubel
  :straight t
  :after (vterm)
  :config (kubel-vterm-setup))

;; This assumes you've installed the package via MELPA.
(use-package ligature
  :straight t
  :config
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia Code ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                       "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                       "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                       "\\\\" "://"))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))
;; Justl -- used for Justfiles
(use-package justl
  :ensure t
  :init
  (let ((just-path (executable-find "just")))
    (if just-path
        (setq justl-executable just-path)
      (warn "just executable not found in exec-path. justl might not work.")))
  )


(use-package outline-yaml
  :ensure t
  :straight (outline-yaml
             :type git
             :host github
             :repo "jamescherti/outline-yaml.el")
  :hook
  ((yaml-mode . outline-yaml-minor-mode)
   (yaml-ts-mode . outline-yaml-minor-mode)))

(use-package ready-player
  :ensure t
  :config
  (ready-player-mode +1))

(use-package forge
  :after magit
  :config
  (setq ghub-use-workaround-for-emacs-bug 'force)
  
  (defun bitshifta/ghub-token-from-gh (host username package &optional nocreate forge)
    (string-trim (shell-command-to-string "gh auth token")))
  

  (advice-add 'ghub--token :override #'bitshifta/ghub-token-from-gh))

;;; init.el ends here
