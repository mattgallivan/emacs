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
;; C-c g		(consult-goto-line)	Jump to a line.
;; C-c w		(avy-goto-char)		Jump to a visible character.
;; C-c l		(avy-goto-line))	Jump to a visible line.
;; C-s			(consult-line)		Search lines.
;;
;; = Help & Documentation =
;; C-h m		(describe-mode)		Describe the current modes.
;; C-h b		(describe-bindings)	Describe the current bindings.
;; C-h v		(describe-variable)	Describe a variable.
;;
;;; Code:

;; - - - - -
;; settings
;; - - - - -

;; Disable the bell.
(setq ring-bell-function 'ignore)

;; Ignore custom changes.
(setq custom-file (make-temp-file "emacs-custom"))

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

(use-package esup
  ;; Benchmark startup time.
  :defer t
  :custom
  (esup-depth 0))

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

(use-package vertico
  ;; Vertical completion in the minibuffer.
  :init
  (vertico-mode))

(provide 'init)
;;; init.el ends here
