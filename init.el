;; UI
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Packaging
(require 'package)

;; Set a list of packages to install
(setq package-list '(evil paredit evil-paredit rainbow-delimiters))

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

;; Rainbow delimiters: enabled everywhere, all the time, no exceptions.
;; for some reason, this requires a prog-mode hook rather than just a
;; global declaration
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; Paredit: add a hook to elisp buffers
;; I would love to enable this globally, but it doesn't make sense in
;; certain contexts, which is really too bad.
(add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)

