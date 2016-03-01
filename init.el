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

;; Packaging

(require 'package)

;; Set a list of packages to install
(setq package-list '(
		     ;; evil and friends
		     evil evil-tabs evil-leader
		     ;; paredit
		     paredit evil-paredit
		     ;; editing niceness
		     rainbow-delimiters yaml-mode
		     ;; programming tools
		     ack company neotree
		     ;; Flycheck and friends
		     flycheck
		     ;; org-mode
		     org evil-org
		     ;; pretties
		     solarized-theme
		     ))

;; Setting up the package archives
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

;; initialize packages
(package-initialize)

;; If we don't have a package cache, refresh it
(package-refresh-contents)

;; make sure all packages are installed properly
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
;; Basically, just run the thing I think
(add-hook 'after-init-hook #'global-flycheck-mode)

;; company-mode
;; add a hook for after global init, like flycheck
(add-hook 'after-init-hook 'global-company-mode)


;;; Custom functions

;; better shell popup. bound in evil mode keymap, as well as globally
;; TODO figure out a way to make it auto-close when I leave the buffer
;; or maybe even toggle like Spacemacs' spc-'
(defun my/shell ()
  "Does a 'popup' shell whenever eshell is called."
  (interactive)
  (split-window)
  (other-window 1)
  (eshell)
  (other-window 1))


;;; Keymap modifications

;; bind my/shell to c-backtick
(define-key global-map (kbd "C-`") 'my/shell)

;; evil-leader keymap mods
;; toggles
(evil-leader/set-key "tt" 'neotree-toggle)
(evil-leader/set-key "tu" 'undo-tree-visualize)
;; buffers
(evil-leader/set-key "bp" 'previous-buffer)
(evil-leader/set-key "bn" 'next-buffer)
(evil-leader/set-key "bt" 'switch-to-buffer)
;; windowing events
(evil-leader/set-key "wh" 'evil-window-left)
(evil-leader/set-key "wj" 'evil-window-down)
(evil-leader/set-key "wk" 'evil-window-up)
(evil-leader/set-key "wl" 'evil-window-right)
(evil-leader/set-key "wo" 'other-frame)
(evil-leader/set-key "wn" 'make-frame)

;; fix the keybindings inside neotree
(add-hook 'neotree-mode-hook
	  (lambda ()
	    (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
	    (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)
	    (define-key evil-normal-state-local-map (kbd "I") 'neotree-hidden-file-toggle)
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


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
