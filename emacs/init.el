;; Thomas K emacs config
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
;; Set up the visible bell
(setq visible-bell t)
(setq make-backup-files nil)
(set-face-attribute
 'default nil
 :font "BerkeleyMono Nerd Font Mono Plus Font Awesome Plus Font Awesome Extension Plus Octicons Plus Power Symbols Plus Codicons Plus Pomicons Plus Font Logos Plus Material Design Icons Plus Weather Icons"
 :height 200) ;; set font

(global-auto-revert-mode) ;; emacs will reload buffer from changed file on disk.

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
  :config
  (setq fancy-battery-mode 1)
  (setq doom-modeline-battery t)
  (setq doom-modeline-icon t)
  (setq doom-modeline-project-detection 'auto)
  (setq doom-modeline-height 45)
  (setq doom-modeline-bar-width 6)
  (setq doom-modeline-project-detection 'project)
  (setq doom-modeline-project-detection 'ffip)
  (setq doom-modeline-major-mode-color-icon t))

;; All the icons!
(use-package all-the-icons)

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
    "tt" '(counsel-load-theme :which-key "choose theme")))

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

;; Pinentry
(use-package pinentry
  :defer nil
  :config (pinentry-start))

;; company
(use-package company
  :bind (("C-c ." . company-complete)
         ("C-c C-." . company-complete)
         ("C-c s s" . company-yasnippet)
         :map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous)
         ("C-d" . company-show-doc-buffer)
         ("M-." . company-show-location))
  :init
  (add-hook 'c-mode-common-hook 'company-mode)
  (add-hook 'sgml-mode-hook 'company-mode)
  (add-hook 'emacs-lisp-mode-hook 'company-mode)
  (add-hook 'text-mode-hook 'company-mode)
  (add-hook 'lisp-mode-hook 'company-mode)
  :config
  (eval-after-load 'c-mode
    '(define-key c-mode-map (kbd "[tab]") 'company-complete))

  (setq company-tooltip-limit 20)
  (setq company-show-numbers t)
  (setq company-dabbrev-downcase nil)
  (setq company-idle-delay 0)
  (setq company-echo-delay 0)

  (setq company-backends '(company-capf
                           company-keywords
                           company-semantic
                           company-files
                           company-etags
                           company-elisp
                           ;;company-clang
                           company-irony-c-headers
                           company-irony
                           company-jedi
                           ;;company-cmake
                           company-terraform
                           company-yasnippet))

  (global-company-mode))

(use-package company-quickhelp
  :after company
  :config
  (setq company-quickhelp-idle-delay 0.1)
  (company-quickhelp-mode 1))

(use-package company-irony
  :after (company irony)
  :commands (company-irony)
  :config
  (add-hook 'irony-mode-hook 'company-irony-setup-begin-commands))

(use-package company-irony-c-headers
  :commands (company-irony-c-headers)
  :after company-irony)

(use-package company-jedi
  :commands (company-jedi)
  :after (company python-mode))

(use-package company-statistics
  :after company
  :config
  (company-statistics-mode))

;; terraform
(use-package company-terraform
  :after company
  :init (company-terraform-init))

;; org -- org for emacs
(defun bitshifta/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil))

(use-package org
  :hook (org-mode . bitshifta/org-mode-setup)
  :config
  (setq org-ellipsis " ▼"
	org-hide-emphasis-markers t
	org-todo-keywords (quote ((sequenece "TODO(t)" "DOING(g)" "|" "DONE(d)")))))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(setq org-agenda-files (directory-files "~/Documents/org/" "\\.org$"))

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

;; all-the-icons
(use-package all-the-icons
  ;;:if (display-graphic-p))
  )
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
  (dashboard-banner-logo-title "( E M A C S )")
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
  :load-path "/Users/tkhalil/emacs-libvterm/"
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
  (defun tirimia/typescript-setup ()
    "Setup for writing TS"
    (interactive)
    (setq-local devdocs-current-docs '("typescript" "node~18_lts"))
    (lsp-deferred))
  (defun tirimia/tsx-font-lock-fix ()
    "TSX TS parser is taking waaay too much memory. Gonna make fontification not happen as often."
    (setq-local jit-lock-defer-time 0.5))
  :mode (("\\.ts\\'" . typescript-ts-mode) ("\\.tsx\\'" . tsx-ts-mode))
  :hook (((tsx-ts-mode typescript-ts-mode) . tirimia/typescript-setup)
         (tsx-ts-mode . tirimia/tsx-font-lock-fix)))

(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (terraform-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
;; if you are ivy user
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
(use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; optional if you want which-key integration
(use-package which-key
    :config
    (which-key-mode))
