;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Dan Goje" user-mail-address "gojedan98@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Hack"
                           :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/my-life/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(after! org
  ;; My TODOs workflow
  (setq org-todo-keywords '((sequence "RESEARCH" "TODO" "BLOCKED" "|" "DONE" "WONTFIX")))
  ;; Keybinding to copy/paste links to org files/headlines
  (global-set-key (kbd "C-c l") 'org-store-link)
  (global-set-key (kbd "C-c C-l") 'org-insert-link)
  ;; Sets of agenda files that I use for different purposes
  (setq agenda-personal '("~/my-life/org" "~/my-life/org/hackasoton") agenda-work '("~/my-life/org/projects/cc") agenda-focuses
                                                                                      '("~/my-life/org/focuses"))
  ;; Views for the different types of TODOs I store
  (setq org-agenda-custom-commands '(("p" "Personal todos" ((agenda "")
                                                            (todo "TODO|RESEARCH"
                                                                  ((org-agenda-skip-function
                                                                    '(org-agenda-skip-entry-if
                                                                      'timestamp))))
                                                            (todo "BLOCKED"))
                                      ((org-agenda-files agenda-personal)))
                                     ("w" "Work related todos" ((agenda "")
                                                                (todo "TODO|RESEARCH"
                                                                      ((org-agenda-skip-function
                                                                        '(org-agenda-skip-entry-if
                                                                          'timestamp))))
                                                                (todo "BLOCKED"))
                                      ((org-agenda-files agenda-work)))
                                     ("f" "Todos in focuses directory" ((alltodo ""))
                                      ((org-agenda-files agenda-focuses)))))
  ;; Org capture templates to help me capture my thoughts  efficiently
  (setq org-capture-templates `(("a" "Action" entry (file+headline "~/my-life/org/inbox.org"
                                                                   "Actions")
                                 "** TODO %^{Task Description}\n"
                                 :prepend t)
                                ("t" "Thought" entry (file+headline "~/my-life/org/inbox.org"
                                                                    "Thoughts")
                                 "** TODO %^{Task Description}\n"
                                 :prepend t))))
;; Set ledger-mode extension
(add-to-list 'auto-mode-alist '("\\.dat\\'" . ledger-mode))
;; Format elisp code on save
(add-hook 'before-save-hook (lambda ()
                              (when (eq major-mode 'emacs-lisp-mode)
                                (elisp-format-buffer))))
;; Format python code after save, requires black (python code formatter) to be installed on the system
(add-hook 'after-save-hook (lambda ()
                             (when (eq major-mode 'python-mode)
                               (shell-command (concat "black " buffer-file-name)))))
