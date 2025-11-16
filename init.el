;;; init.el - Emacs Configuration -*- lexical-binding: t; -*-
;;
;; Author: Matthew Gallivan
;;
;; This is free and unencumbered software released into the public domain.
;;
;; Anyone is free to copy, modify, publish, use, compile, sell, or
;; distribute this software, either in source code form or as a compiled
;; binary, for any purpose, commercial or non-commercial, and by any
;; means.
;;
;; In jurisdictions that recognize copyright laws, the author or authors
;; of this software dedicate any and all copyright interest in the
;; software to the public domain. We make this dedication for the benefit
;; of the public at large and to the detriment of our heirs and
;; successors. We intend this dedication to be an overt act of
;; relinquishment in perpetuity of all present and future rights to this
;; software under copyright law.
;;
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
;; IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
;; OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
;; ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
;; OTHER DEALINGS IN THE SOFTWARE.
;;
;; For more information, please refer to <https://unlicense.org>
;;
;;; Commentary:
;; This init.el file contains emacs packages and configurations.
;;
;; KEY BINDINGS
;;
;; = Navigation & Search =
;; C-c g		(consult-goto-line)		Jump to a line.
;; C-c w		(avy-goto-char)			Jump to a visible character.
;; C-c l		(avy-goto-line))		Jump to a visible line.
;; C-s			(consult-line)			Search lines.
;; S-<arrow>		(windmove-<arrow>)		Switch buffer.
;;
;; = Editing =
;; C-c f		(clang-format-buffer)		Format the buffer according to .clang-format.
;;
;; = Projects =
;; C-c p D		(projectile-dired)		Open dired for the project.
;; C-c p f		(projectile-find-file)		Find file in the project.
;; C-c p b		(projectile-switch-to-buffer)	Switch buffer in the project.
;;
;; = Git =
;; C-x g		(magit-status)			Open the magit status buffer.
;;
;; = Help & Documentation =
;; C-h m		(describe-mode)			Describe the current modes.
;; C-h b		(describe-bindings)		Describe the current bindings.
;; C-h v		(describe-variable)		Describe a variable.
;;
;;; Code:

;; - - - - -
;; settings
;; - - - - -

;; Disable temporary files.
(setq auto-save-default nil)
(setq make-backup-files nil)
(setq create-lockfiles nil)

;; Disable the bell.
(setq ring-bell-function 'ignore)

;; Ignore custom changes.
(setq custom-file (make-temp-file "emacs-custom"))

;; Move between buffers with Shift + arrows.
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; Accept completion on first enter (don't require hitting enter twice).
(setq completion-require-final-newline nil)

;; - - - - -
;; c++
;; - - - - -

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.ixx\\'" . c++-mode))

(add-hook 'c++-mode-hook #'clang-format+-mode)

;; - - - - -
;; theme
;; - - - - -

(load-theme 'wombat)

;; - - - - -
;; packages
;; - - - - -

;; package
(require 'package)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
	("melpa" . "https://melpa.org/packages/")))
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

;; use-package
(require 'use-package)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(setq use-package-always-ensure t)

;; packages

(use-package avy
  ;; Jump between lines and words.
  :bind
  (("C-c w" . avy-goto-char)
   ("C-c l" . avy-goto-line))
  :custom
  (avy-background t))

(use-package clang-format
  ;; Format C++ using .clang-format.
  :commands (clang-format-buffer clang-format-region)
  :bind
  ("C-c f" . clang-format-buffer))

(use-package consult
  ;; Search and navigation commands.
  :bind
  (("C-s" . consult-line)
   ("C-c g" . consult-goto-line)))

(use-package corfu
  ;; In-buffer completion with a popup.
  :init
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 1)
  (corfu-preview-current nil)
  (corfu-popupinfo-delay '(0 . 0)))

(use-package dashboard
  ;; Dashboard shown on start.
  :config
  (dashboard-setup-startup-hook)  
  :custom
  (dashboard-projects-backend 'projectile)
  (dashboard-startup-banner "~/.config/emacs/logo-ascii.txt")
  (dashboard-banner-logo-title nil)
  (dashboard-center-content t)
  (dashboard-items '((recents . 5)
		     (projects . 5)
		     (bookmarks . 5)
		     (agenda . 5)))
  (dashboard-footer-messages
   '("There are two kinds of creation myths: those where life arises out of the mud, and those where life falls from the sky. In this creation myth, computers arose from the mud, and code fell from the sky."
     "Nothing is so painful to the human mind as a great and sudden change."
     "Much of the engineering of computers takes place in silence, while engineers pace in hallways or sit alone and gaze at blank pages."
     "You can't let the little pricks generation gap you."
     "It's a universal principle operating throughout the universe; the entire universe is moving toward a final state of total, absolute kippleization."
     "Either this is madness or it is Hell. It is neither, calmly replied the voice of the Sphere, it is Knowledge; it is Three Dimensions: open your eye once again and try to look steadily."
     "For now, what is important is not finding the answer, but looking for it."
     "I knew who I was this morning, but I've changed a few times since then.")))

(use-package eglot
  ;; Client for Language Server Protocol.
  :ensure nil
  :custom
  (eglot-ignored-server-capabilities
   '(:documentFormattingProvider
     :documentOnTypeFormattingProvider
     :documentRangeFormattingProvider)))

(use-package esup
  ;; Benchmark startup time.
  :defer t
  :custom
  (esup-depth 0))

(use-package magit
  :defer t
  :bind (("C-x g" . magit-status)))

(use-package marginalia
  ;; Marks annotations in the minibuffer.
  :init
  (marginalia-mode))

(use-package orderless
  ;; Orderless minibuffer completion.
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package projectile
  ;; Project management.
  :config
  (projectile-mode +1)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :custom
  (projectile-indexing-method 'alien)
  (projectile-enable-caching 'persistent)
  (projectile-git-command
   "rg --files --hidden --follow -0 -g \"'*.c\" -g \"*.cc\" -g \"*.cxx\" -g \"*.cpp\" -g \"*.h\" -g \"*.hh\" -g \"*.hpp\" -g \"*.hxx\"")
  (projectile-generic-command
   "rg --files --hidden --follow -0 -g \"'*.c\" -g \"*.cc\" -g \"*.cxx\" -g \"*.cpp\" -g \"*.h\" -g \"*.hh\" -g \"*.hpp\" -g \"*.hxx\""))

(use-package vertico
  ;; Vertical completion in the minibuffer.
  :init
  (vertico-mode))

(provide 'init)
;;; init.el ends here
