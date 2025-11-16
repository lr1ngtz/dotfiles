(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(gruvbox-dark-medium))
 '(custom-safe-themes
   '("5a0ddbd75929d24f5ef34944d78789c6c3421aa943c15218bac791c199fc897d"
     "51fa6edfd6c8a4defc2681e4c438caf24908854c12ea12a1fbfd4d055a9647a3"
     "" default))
 '(package-selected-packages
   '(consult dumb-jump go-mode gruvbox-theme magit marginalia orderless
             pbcopy vertico)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq scroll-margin 5)
;; indenting
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq c-basic-offset 4)

;;highlight trailing whitespace
(global-whitespace-mode 1)
(setq whitespace-style '(face trailing))
(set-face-background 'whitespace-trailing "#cc0000") ; red background
(set-face-foreground 'whitespace-trailing nil)

;; enable c-x c-l to downcase selected region
(put 'downcase-region 'disabled nil)
;; enable c-x c-u to upcase selected region
(put 'upcase-region 'disabled nil)

;; don't show the splash screen
(setq inhibit-startup-message t)
(menu-bar-mode -1)

;; makes sure the contents of the buffer is refreshed automatically when the file is changed outside of emacs
(global-auto-revert-mode t)
;; select scope
(global-set-key (kbd "C-c s") 'mark-sexp)
(global-set-key (kbd "C-x ;") 'comment-line)

;; melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; comment/uncomment this line to enable melpa stable if desired.  see `package-archive-priorities`
;; and `package-pinned-packages`. most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;;; load lisp
;; custom lisp directory to load path
(add-to-list 'load-path(expand-file-name "~/.emacs.d/lisp"))

;; odin syntax highlighting
;; (load "odin-mode")
(use-package odin-mode
  :load-path "~/.emacs.d/lisp"
  :mode "\\.odin\\'"
  :defer t)

;; display line numbers in every buffer
;; (global-display-line-numbers-mode)

;; create backup directory if it doesn't exist
(make-directory "~/.emacs.d/backup" t)
;; use a better backup naming scheme
(setq
 backup-by-copying t      ; don't clobber symlinks
 backup-directory-alist
 '(("." . "~/.emacs.d/backup"))
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)       ; use versioned backups
;; transform file names
(setq backup-transform-file-name-function
      (lambda (filename)
        (concat "~/.emacs.d/backup/"
                (file-name-nondirectory filename))))

;; enable pbcopy (macos)
(use-package pbcopy
  :init
  (turn-on-pbcopy)  ; integrate with system clipboard
  (setq select-enable-clipboard t)
  :defer t)


;; config  project.el to ignore __pycache__
(setq project-vc-ignores '("*/__pycache__/*"))

;;; compile
(global-set-key (kbd "C-c c") 'compile)

;;; consult group ################################################################
(use-package vertico
  :init
  (vertico-mode 1))

(use-package consult
  :bind (("M-g g" . consult-goto-line)
         ("C-c f" . consult-find)
         ("C-c p s" . consult-ripgrep)

         ("C-r" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-g m" . consult-imenu)
         ("M-g M-m" . consult-imenu-multi)
         ("C-c M" . consult-man)
         ("C-c k" . consult-keep-lines)
         ("C-c K" . consult-focus-lines)))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode 1))
;;; consult group ################################################################


;;; dumb jump
;;; create .dumbjup file in order to search for symbols
;;; for instance
;;; .dumbjump content
;;;# Odin global libraries
;;;+ ${HOME}/Odin/core
;;;+ ${HOME}/Odin/base
;;;+ ${HOME}/Odin/vendor
(use-package dumb-jump
  :ensure t
  :custom
  (dumb-jump-force-searcher 'rg)
  (dumb-jump-prefer-searcher 'rg)

  (dumb-jump-selector 'consult)
  (xref-show-xrefs-function #'consult-xref)
  (xref-show-definitions-function #'consult-xref)

  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

(global-set-key (kbd "M-.") 'xref-find-definitions)
(global-set-key (kbd "M-?") 'xref-find-references)
(global-set-key (kbd "M-,") 'xref-pop-marker-stack)
;;; dumb jump
