(setq custom-file "~/.emacs.d/emacs.custom.el")
(load custom-file)

(setq scroll-margin 5)
;; indenting
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default standard-indent 4)

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

;; ensure emacs can find executables installed by homebrew on intel macs
(add-to-list 'exec-path "/usr/local/bin")
(setenv "PATH" (concat "/usr/local/bin:" (getenv "PATH")))

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

;; enable pbcopy
(use-package pbcopy
  :init
  (turn-on-pbcopy)  ; integrate with system clipboard
  (setq select-enable-clipboard t)
  :defer t)


;;; enable vertico, consult, orderless, and marginalia
(use-package vertico
  :init
  (vertico-mode 1)
  :defer t)

(use-package consult
  :bind (("M-g g" . consult-goto-line)
         ("C-c f" . consult-fd)
         ("C-c r" . consult-ripgrep)
         ("C-c o" . odin-source-search))
  :config
  (defun odin-source-search (search-term) ;;; odin source code default ripgrep case-insensetive
    "Search for SEARCH-TERM in core, vendor, and base under ~/Odin using consult-ripgrep."
    (interactive "sSearch term: ")
    (let ((base-path (expand-file-name "~/Odin")))
      (unless (file-directory-p base-path)
        (error "Odin directory %s does not exist" base-path))
      (consult-ripgrep base-path (concat search-term " -- core vendor base -i"))))
  :defer t)

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion))))
  :defer t)

(use-package marginalia
  :init
  (marginalia-mode 1)
  :defer t)


;; config  project.el to ignore __pycache__
(setq project-vc-ignores '("*/__pycache__/*"))

;;; vc-diff
(global-set-key (kbd "C-c d") 'vc-diff)

;;; compile
(global-set-key (kbd "C-c c") 'compile)


;; requires build directory and project.el file in the root of the project
(defun run-odin-compile ()
  "Run 'odin run .'"
  (interactive)
  (let ((default-directory (if (project-current)
                               (project-root (project-current))
                             default-directory)))
    (compile "odin run . -out:build/main")))
(global-set-key (kbd "C-c l") 'run-odin-compile)

(defun run-odin-debug-compile ()
  "Run 'odin run . -debug'"
  (interactive)
  (let ((default-directory (if (project-current)
                               (project-root (project-current))
                             default-directory)))
    (compile "odin run . -debug -out:build/main")))
(global-set-key (kbd "C-c C-l") 'run-odin-debug-compile)

(defun build-odin-compile ()
  "Run 'odin build .'"
  (interactive)
  (let ((default-directory (if (project-current)
                               (project-root (project-current))
                             default-directory)))
    (compile "odin build . -out:build/main")))
(global-set-key (kbd "C-c b") 'build-odin-compile)

(defun build-odin-debug-compile ()
  "Run 'odin build . -debug'"
  (interactive)
  (let ((default-directory (if (project-current)
                               (project-root (project-current))
                             default-directory)))
    (compile "odin build . -debug -out:build/main")))
(global-set-key (kbd "C-c C-b") 'build-odin-debug-compile)


(defun my/switch-theme-by-time ()
  "switch emacs theme based on the current time."
  (let ((hour (string-to-number (format-time-string "%H"))))
    (if (or (>= hour 19) (< hour 7))
        ;; nighttime (7 pm to 7 am): load dark theme
        (load-theme 'gruvbox-dark-medium t)
      ;; daytime (7 am to 7 pm): load light theme
      (load-theme 'gruvbox-light-soft t))))

;; run the theme switcher when emacs starts
(add-hook 'emacs-startup-hook 'my/switch-theme-by-time)

;; Periodically check the time and switch theme if needed
(run-at-time "0 sec" 7200 'my/switch-theme-by-time)
