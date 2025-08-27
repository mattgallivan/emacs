;;; early-init.el - Emacs Early Initialization -*- lexical-binding: t; -*-
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
;; This early-init.el file is loaded early on in initialization. It (mostly)
;; contains configuration that affects performance and the user interface.
;;
;;; Code:

;; Disable garbage collection.
(setq
 gc-cons-threshold most-positive-fixnum
 gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 16777216   ; ~16MB
                  gc-cons-percentage 0.1)))

;; Disable expensive file handlers.
(defvar early--file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(add-hook 'after-init-hook
          (lambda ()
            (setq file-name-handler-alist
                  (delete-dups (append file-name-handler-alist
                                       early--file-name-handler-alist)))))

;; Improve performance.
(setq
 frame-inhibit-implied-resize t
 frame-resize-pixelwise t
 inhibit-compacting-font-caches t
 ;; Increase LSP and subprocess throughput.
 read-process-output-max (* 4 1024 1024)
 ;; Skip system site initializtion.
 site-run-file nil)

;; Set up the UI.
(setq default-frame-alist
        (append
         `((font . "JetBrains Mono-12")
           (fullscreen . maximized)
           (menu-bar-lines . 0)
           (tool-bar-lines . 0)
           (vertical-scroll-bars . nil)
           (internal-border-width . 10)
           (left-fringe . 0) (right-fringe . 0)
           ;; macOS
           (ns-appearance . dark)
           (ns-transparent-titlebar . t))
         default-frame-alist))

(setq inhibit-startup-screen t
      initial-scratch-message nil
      use-dialog-box nil
      use-file-dialog nil)

;; Force the initial frame to come to front
(add-hook 'window-setup-hook
          (lambda ()
            (when (display-graphic-p)
              (select-frame-set-input-focus (selected-frame)))))

(provide 'early-init)
;;; early-init.el ends here
