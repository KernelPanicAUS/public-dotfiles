;; Thomas K emacs config
(setq inhibit-startup-message t )

(scroll-bar-mode -1)   ; Disable visible scrollbar
(tool-bar-mode -1)     ; Disable the toolbar
(tooltip-mode 01)      ; Disable the tooltips
(set-fringe-mode 10)   ; Give some breathing room

(menu-bar-mode -1)     ; Disable the menu bar
;; Set up the visible bell
(setq visible-bell t)

(set-face-attribute 'default nil :font "Berkeley Mono" :height 200) ;; set font

(load-theme 'doom-wilmersdorf t) ;; set theme

(setq vc-follow-symlinks t
      coding-system-for-read 'utf-8
      coding-system-for-write 'utf-8
      sentence-end-double-space nil
      custom-file null-device
      byte-compile-debug t)

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
(let ((ssh-auth-sock (shell-command-to-string "/opt/homebrew/bin/gpgconf --list-dirs agent-ssh-socket")))
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

(use-package command-log-mode)

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
  :defer t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 45)))

;; All the icons!
(use-package all-the-icons)

;; Doom Themes
(use-package doom-themes)

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
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (rune/leader-keys
    "t" '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

;; Evil
(defun rune/evil-hook ()
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
;;  :hook (evil-mode . rune/evil-hook)
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
(rune/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale-text"))

;; Projectile
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
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

;; forge -- create Github PRs and issues from emacs
(use-package forge)


;; company
(use-package company)
(company-mode)
(add-hook 'after-init-hook 'global-company-mode)


;; terraform
(use-package company-terraform)
(company-terraform-init)

;; org -- org for emacs
(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil))

(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▼"
	org-hide-emphasis-markers t))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
	visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :after org
  :hook (org-mode . efs/org-mode-visual-fill))

;; all-the-icons
(use-package all-the-icons
  :if (display-graphic-p))

;; treemacs - file navigator
(use-package treemacs)
(use-package treemacs-evil
  :after (treemacs evil))
(use-package treemacs-projectile
  :after (treemacs projectile))
(use-package treemacs-all-the-icons
  :after (treemacs all-the-icons))
(use-package treemacs-magit
  :after (treemacs magit))
(use-package treemacs-icons-dired
  :after (treemacs dired)
  :hook (dired-mode . treemacs-icons-dired-enable-once))
(use-package dashboard
  :if (display-graphic-p)
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-banner-logo-title "( E M A C S )")
  (setq dashboard-init-info "")
  (setq dashboard-items nil)
  (setq dashboard-set-footer t)
  (setq dashboard-footer-icon "")
  (setq dashboard-footer-messages '("😈 Happy hacking!   "))
  (define-key dashboard-mode-map (kbd "<f5>") #'(lambda ()
                                                  (interactive)
                                                  (dashboard-refresh-buffer)
                                                  (message "Refreshing Dashboard...done"))))

(use-package vterm
   :load-path "/Users/tkhalil/emacs-libvterm/"
   :config
   (setq vterm-shell "/opt/homebrew/bin/bash"))

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
