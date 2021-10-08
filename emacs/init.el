;;; Global options

; Do not use backup files (not sure if it will bite later)
(setq make-backup-files nil)

; Avoid writing annoying configuration automatically
(setq custom-file null-device)

; Visual options
(setq inhibit-startup-screen t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)

(add-to-list 'default-frame-alist '(internal-border-width . 20))

; Useful built-in modes
(global-auto-revert-mode t)
(electric-pair-mode 1)
(global-display-line-numbers-mode)
(show-paren-mode 1)

;;; Packages
(package-initialize)
(require 'package)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package night-owl-theme
  :config
  (load-theme 'night-owl t))

(use-package evil
  :init
  (setq
    evil-search-module 'evil-search
    evil-auto-balance-windows nil
    evil-undo-system 'undo-tree
    evil-want-C-u-delete t
    evil-want-C-u-scroll t
    evil-want-Y-yank-to-eol t)
  :config
  (evil-mode 1)
  (evil-global-set-key 'normal (kbd "ñn") 'evil-ex-nohighlight))

(use-package undo-tree
  :config
  (global-undo-tree-mode))

(use-package evil-surround
  :config
  (global-evil-surround-mode t))

(use-package evil-commentary
  :config
  (evil-commentary-mode))

(use-package evil-easymotion
  :config
  (evil-global-set-key 'normal (kbd "J") nil)
  (evilem-define (kbd "J") 'evil-next-line-first-non-blank)
  (evilem-define (kbd "K") 'evil-previous-line-first-non-blank))

(use-package rainbow-delimiters)

(use-package git-gutter
  :config
  (global-git-gutter-mode 1))

; Custom modes
(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))

; Night-owl theme specific options
(custom-set-faces
 '(default ((t (:family "Fira Mono" :height 110 :weight regular))))

 ; Custom agda highlight theme
 '(agda2-highlight-coverage-problem-face ((t nil)))
 '(agda2-highlight-datatype-face ((t (:foreground "#C792EA"))))
 '(agda2-highlight-error-face ((t (:foreground "#ef5350" :underline t))))
 '(agda2-highlight-field-face ((t (:foreground "#82AAFF"))))
 '(agda2-highlight-function-face ((t (:foreground "#82AAFF"))))
 '(agda2-highlight-inductive-constructor-face ((t (:foreground "#82AAFF"))))
 '(agda2-highlight-keyword-face ((t (:foreground "#C792EA"))))
 '(agda2-highlight-module-face ((t (:foreground "#D6DEEB"))))
 '(agda2-highlight-number-face ((t (:foreground "#F78C6C"))))
 '(agda2-highlight-postulate-face ((t (:foreground "#EF5350"))))
 '(agda2-highlight-primitive-face ((t (:foreground "#7FDBCA"))))
 '(agda2-highlight-primitive-type-face ((t (:foreground "#C792EA"))))
 '(agda2-highlight-record-face ((t (:foreground "#C792EA"))))
 '(agda2-highlight-symbol-face ((t (:foreground "#7FDBCA"))))

 ; Easy-motion
 '(avy-lead-face ((t (:foreground "#ff007c" :underline t))))
 '(avy-lead-face-0 ((t (:foreground "#ff007c"))))
 '(avy-lead-face-1 ((t (:foreground "#ff007c"))))

 ; evil-mode
 '(evil-ex-lazy-highlight ((t (:background "#213b5d"))))
 '(evil-ex-search ((t (:background "#5476b3" :weight bold))))

 ; git-gutter
 '(git-gutter:added ((t (:background "#9ccc65"))))
 '(git-gutter:deleted ((t (:background "#ef5350"))))
 '(git-gutter:modified ((t (:background "#e2b93d")))))

; Variables
(custom-set-variables
 '(avy-keys
   '(102 97 115 106 117 105 114 119 122 109 107 104 100 111 101))
 '(git-gutter:added-sign " ")
 '(git-gutter:deleted-sign " ")
 '(git-gutter:modified-sign " ")
 '(git-gutter:update-interval 0.5))

