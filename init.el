(require 'package)

;Set a list of packages to install
(setq package-list '(evil paredit evil-paredit rainbow-delimiters))

; Setting up the package archives
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

; initialize packages
(package-initialize)

; If we don't have a package cache, refresh it
(package-refresh-contents)

; make sure all packages are installed properly
(mapc
 (lambda (package)
   (or (package-installed-p package)
       (package-install package)))
 package-list)

; now time to set up all the things!
(evil-mode 1)
(paredit-mode 1)

