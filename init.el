;;; myinit-el -- My own personal init file
;;; Commentary:
;; This is my personal init.el.  If you really wanna steal it, go ahead.

;;; Code:
;;; UI

;; the UI is for looooosers
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
;; And the bell is annoying as hell
(setq ring-bell-function 'ignore)
;; Add a clock to the modeline since I usually go fullscreen
(display-time-mode 1)

;; Packaging

(require 'package)

;; Set a list of packages to install
(setq package-list '(
		     ;; evil and friends
		     evil evil-tabs evil-leader
		     ;; paredit
		     paredit evil-paredit
		     ;; editing niceness
		     rainbow-delimiters yaml-mode lua-mode
		     ;; programming tools
		     ack company neotree
		     ;; Flycheck and friends
		     flycheck
		     ;; org-mode
		     org evil-org
		     ;; helm and friends
		     helm helm-projectile helm-ag
		     ;;projectile
		     projectile
		     ;; pretties
		     solarized-theme
		     ;; an awesome reading tool
		     spray
		     ;; good for learning keybindings
		     which-key
		     ))

;; Setting up the package archives
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

;; initialize packages
(package-initialize)

;; If we don't have a package cache, refresh it
(package-refresh-contents)

;; make sure all packages are installed
(mapc
 (lambda (package)
   (or (package-installed-p package)
       (package-install package)))
 package-list)

;;; Package setups

;; Evil: enabled everywhere, all the time, no exceptions.
;; add leader support (this has to be done first for reasons)
(require 'evil-leader)
(global-evil-leader-mode)
(evil-leader/set-leader "<SPC>")
(evil-mode 1)
;; make escape quit all the things
(require 'delsel) ; makes minibuffer-keyboard-quit work??
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(require 'evil-org)

;; neotree
(require 'neotree)


;; fine-grain undo
(setq evil-want-fine-undo t)
;; add support for vim-style tabs
(global-evil-tabs-mode t)

;; Rainbow delimiters: enabled everywhere, all the time, no exceptions.
;; for some reason, this requires a prog-mode hook rather than just a
;; global declaration
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; Paredit: add a hook to elisp buffers
;; I would love to enable this globally, but it doesn't make sense in
;; certain contexts, which is really too bad.
(add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)

;; Flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

;; company-mode
;; add a hook for after global init, like flycheck
(add-hook 'after-init-hook 'global-company-mode)

;; spray
(require 'spray)
;; disable evil when using spray
(defadvice spray-mode (after toggle-evil activate)
  (evil-local-mode (if spray-mode -1 1)))

;; which-key
(require 'which-key)
(which-key-mode)
(setq which-key-idle-delay .5)
(which-key-declare-prefixes "<SPC>t" "toggles")
(which-key-declare-prefixes "<SPC>b" "buffer-mgmt")
(which-key-declare-prefixes "<SPC>w" "windowing")
(which-key-declare-prefixes "<SPC>r" "reading")
(which-key-declare-prefixes "<SPC>f" "files")
(which-key-declare-prefixes "<SPC>p" "projectile")
(which-key-declare-prefixes "<SPC>r" "org-clocks")

;; helm
(require 'helm)
(require 'helm-config)
;; we'll add the helm prefix to evil-leader for fun and profit
(global-unset-key (kbd "C-x c")) ;; because this is a stupid keybinding
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
(define-key helm-map (kbd "C-z") 'helm-select-action)
(define-key evil-normal-state-map (kbd "M-x") 'helm-M-x)
(define-key evil-normal-state-map (kbd "C-x C-f") 'helm-find-files)
(define-key evil-normal-state-map (kbd "C-x b") 'helm-mini)

;; helm-ag
(require 'helm-ag)

;; projectile
(require 'projectile)
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

;; org customization
(setq org-todo-keywords
      '((sequence "TODO(t)" "RESEARCH(r@)" "BLOCKED(b@)" "INPROGRESS(p!)" "|" "DONE(d!)" "DROPPED(x@)")))
(setq org-default-notes-file "~/org/todo.org")

;;; Custom functions

;; better shell popup. bound in evil mode keymap, as well as globally
;; TODO figure out a way to  make it auto-close when I leave the buffer
;; or maybe even toggle like Spacemacs' spc-'
(defun my/shell ()
  "Does a 'popup' shell whenever eshell is called."
  (interactive)
  (split-window)
  (other-window 1)
  (eshell)
  (other-window 1))

;; emacs custom set variables
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(helm-ag-base-command "ack --nocolor --nogroup"))

;; evil-leader keymap mods
;; toggles
(evil-leader/set-key "tt" 'neotree-toggle)
(evil-leader/set-key "tu" 'undo-tree-visualize)
(evil-leader/set-key "tl" 'toggle-truncate-lines)
;; buffers
(evil-leader/set-key "bp" 'previous-buffer)
(evil-leader/set-key "bn" 'next-buffer)
(evil-leader/set-key "bt" 'switch-to-buffer)
(evil-leader/set-key "bb" 'helm-mini)
(evil-leader/set-key "be" 'eval-buffer)
;; windowing events
(evil-leader/set-key "wh" 'evil-window-left)
(evil-leader/set-key "wj" 'evil-window-down)
(evil-leader/set-key "wk" 'evil-window-up)
(evil-leader/set-key "wl" 'evil-window-right)
(evil-leader/set-key "wo" 'other-frame)
(evil-leader/set-key "wn" 'make-frame)
(evil-leader/set-key "rs" 'spray-mode)
(evil-leader/set-key "'" 'my/shell)
;; helm stuff
(evil-leader/set-key "ff" 'helm-find-files)
(evil-leader/set-key "fa" 'helm-ag)
(evil-leader/set-key "fA" 'helm-ag-this-file)
;; projectile remaps
(evil-leader/set-key "pa" 'projectile-ag)
(evil-leader/set-key "pf" 'projectile-find-file)
;; org stuff
(evil-leader/set-key "rc" 'org-clock-in) 
(evil-leader/set-key "rC" 'org-clock-out) 
(evil-leader/set-key "rl" 'org-clock-in-last) 
(evil-leader/set-key "re" 'org-clock-modify-effort-estimate)
(evil-leader/set-key "rj" 'org-clock-timestamps-down)
(evil-leader/set-key "rk" 'org-clock-timestamps-up)
(evil-leader/set-key "rq" 'org-clock-cancel)
(evil-leader/set-key "rj" 'org-clock-goto)
(evil-leader/set-key "rd" 'org-clock-display)
;; org capture
(evil-leader/set-key "C" 'org-capture)

;; fix the keybindings inside neotree
(add-hook 'neotree-mode-hook
	  (lambda ()
	    (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
	    (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)
	    (define-key evil-normal-state-local-map (kbd "I") 'neotree-hidden-file-toggle)
	    (define-key evil-normal-state-local-map (kbd "r") 'neotree-change-root)
	    (define-key evil-normal-state-local-map (kbd "R") 'neotree-refresh)))


;; Other things

;; move all those backups to one place, and make emacs back up EVERYTHING
(setq backup-directory-alist '(("." . "~/.emacs.d/backup")))
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; enable file history
(setq savehist-file "~/.emacs.d/savehist")
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)

;; make sentences behave the vim (and everyone else) way
(setq sentence-end-double-space nil)

;; set up the theme
(require 'solarized-theme)
(load-theme 'solarized-dark t)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
