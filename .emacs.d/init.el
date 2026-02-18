(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(sketch-black))
 '(custom-safe-themes
   '("fef1ae76cbc3d5fe957160406cf034e5a352037eb5a7ace339fcddc26ada5f9f"
     "0007e247ab8b2a2dcead2e06043649fdc34a97f1caa4a4167a5dc35ac7469fbf"
     "979525ee3cdbe0d4ceab63147ec710be4cbdac0e66aae9d280c05bcbff89b15d"
     "83a14237576924321c9b6855bd3e9b6f96d12446c0cec7b58b22775df6d4f3fe"
     "" default))
 '(package-selected-packages
   '(company consult dumb-jump flycheck go-mode gruvbox-theme magit
             marginalia markdown-mode multiple-cursors orderless
             pbcopy sketch-themes tmpl-mode typescript-mode vertico)))
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

;; surround selection with " … "
(global-set-key (kbd "C-c \"") (lambda () (interactive) (insert-pair 1 ?\" ?\")))
;; surround selection with [ … ]
(global-set-key (kbd "C-c [") (lambda () (interactive) (insert-pair 1 ?\[ ?\])))
;; surround selection with { … }
(global-set-key (kbd "C-c {") (lambda () (interactive) (insert-pair 1 ?{ ?})))

;; don't show the splash screen
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(scroll-bar-mode -1)
;;; fix bug with menu bar mode with terminal emacs
(menu-bar-mode -1)
(add-hook 'after-make-frame-functions (lambda (_) (menu-bar-mode -1)))

;; font size for GUI mode
(set-face-attribute 'default nil :height 160)

;; makes sure the contents of the buffer is refreshed automatically when the file is changed outside of emacs
(global-auto-revert-mode t)
;; select scope
;; (global-set-key (kbd "C-c s") 'mark-sexp)
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
;;; sketch-theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/lisp/themes")

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
(global-set-key (kbd "C-c r") 'recompile)


;;; consult group ################################################################
(use-package vertico
  :init
  (vertico-mode 1))

(use-package consult
  :bind (("M-g g" . consult-goto-line)
         ("C-c f" . consult-find)
         ("C-c p s" . consult-ripgrep)
         ("C-c o" . consult-flymake)
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
;;; create .dumbjump file in order to search for symbols
;;; for instance
;;; .dumbjump content
;;;# Odin global libraries
;;;+ ${HOME}/Odin/core
;;;+ ${HOME}/Odin/base
;;;+ ${HOME}/Odin/vendor
(use-package dumb-jump
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
(global-set-key (kbd "M-,") 'xref-go-back)
;;; dumb jump

(use-package magit)

;; (use-package gruvbox-theme
;;   :config
;;   (load-theme 'gruvbox-dark-medium t))


(use-package markdown-mode
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "pandoc")

  :config
  (setq markdown-fontify-code-blocks-natively t)
  (add-hook 'markdown-mode-hook #'visual-line-mode))

;;; golang
(use-package go-mode
  :hook (before-save . gofmt-before-save))

(use-package flycheck
  :hook (go-mode . flycheck-mode))
;;; golang

;;; multiple cursors
(use-package multiple-cursors
  :config
  (setq mc/always-run-for-all t)
  (if (eq system-type 'darwin)
      (progn
        (global-set-key (kbd "s-d") 'mc/mark-next-like-this)
        (global-set-key (kbd "s-D") 'mc/mark-previous-like-this)
        (global-set-key (kbd "s-l") 'mc/mark-all-like-this)
        (global-set-key (kbd "s-<return>") 'mc/edit-lines)
        (global-set-key (kbd "s-<mouse-1>") 'mc/add-cursor-on-click))
    (progn
      (global-set-key (kbd "C->") 'mc/mark-next-like-this)
      (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
      (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
      (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines))))
;;; multiple cursors


(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay nil
        company-minimum-prefix-length 1)
  :bind (("C-x j" . company-complete)))
