;; UI

(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Packaging

(require 'package)

;; Set a list of packages to install
(setq package-list '(
		     ;; evil and friends
		     evil evil-tabs
		     ;; paredit
		     paredit evil-paredit
		     ;; editing niceness
		     rainbow-delimiters yaml-mode
		     ;; programming tools
		     ack
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

;; Package setups

;; Evil: enabled everywhere, all the time, no exceptions.
(evil-mode 1)
;; make escape quit all the things
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
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

;; Custom functions

;; better shell popup. bound in evil mode keymap, as well as globally
(defun my/shell ()
  "Does a 'popup' shell whenever eshell is called."
  (interactive)
  (split-window)
  (other-window 1)
  (eshell)
  (other-window 1))

;; Keymap modifications

;; bind my/shell to c-backtick
(define-key global-map (kbd "C-`") 'my/shell)

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
