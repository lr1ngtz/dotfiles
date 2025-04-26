(setq scroll-margin 5)
;; indenting
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
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

;;; load gruvbox-theme
(require 'gruvbox-theme)

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

;;; load lisp
;; custom lisp directory to load path
(add-to-list 'load-path(expand-file-name "~/.emacs.d/lisp"))

;; odin syntax highlighting
(load "odin-mode")

;; display line numbers in every buffer
(global-display-line-numbers-mode)

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
(require 'pbcopy)
(turn-on-pbcopy) ; integrate with system clipboard
(setq select-enable-clipboard t)

;;; enable vertico, consult, orderless, and marginalia
(require 'consult)
(vertico-mode 1)
(marginalia-mode 1)
(setq completion-styles '(orderless basic)
      completion-category-defaults nil
      completion-category-overrides '((file (styles partial-completion))))

;; config  project.el to ignore __pycache__
(setq project-vc-ignores '("*/__pycache__/*"))

(global-set-key (kbd "M-g g") 'consult-goto-line)
(global-set-key (kbd "C-c f") 'consult-fd)
(global-set-key (kbd "C-c r") 'consult-ripgrep)

;;; git-gutter
(require 'git-gutter)
(global-git-gutter-mode t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(gruvbox-dark-medium misterioso))
 '(custom-safe-themes
   '("5a0ddbd75929d24f5ef34944d78789c6c3421aa943c15218bac791c199fc897d"
     default))
 '(git-gutter:added-sign "++")
 '(git-gutter:deleted-sign "--")
 '(git-gutter:modified-sign "==")
 '(git-gutter:update-interval 2)
 '(package-selected-packages
   '(consult git-gutter-fringe gruvbox-theme marginalia orderless pbcopy
             vertico)))

(global-set-key (kbd "C-c g h") 'git-gutter:popup-hunk)
(global-set-key (kbd "C-c g n") 'git-gutter:next-hunk)
(global-set-key (kbd "C-c g p") 'git-gutter:previous-hunk)

;;; vc-diff
(global-set-key (kbd "C-c d") 'vc-diff)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(git-gutter:added ((t (:foreground "#b8bb26" :background "#32302f"))))
 '(git-gutter:deleted ((t (:foreground "#fb4934" :background "#32302f"))))
 '(git-gutter:modified ((t (:foreground "#fabd2f" :background "#32302f")))))


;;; odin source code default ripgrep case-insensetive
(require 'consult)

(defun odin-source-search (search-term)
  "Search for SEARCH-TERM in core, vendor, and base under ~/Odin using consult-ripgrep."
  (interactive "sSearch term: ")
  (let ((base-path (expand-file-name "~/Odin")))
    (unless (file-directory-p base-path)
      (error "Odin directory %s does not exist" base-path))
    (consult-ripgrep base-path (concat search-term " -- core vendor base -i"))))

;; bind to c-c o
(global-set-key (kbd "C-c o") #'odin-source-search)
