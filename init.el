;; Create By: Michael Spellecacy <mspellecacy@frakle.com>
;; Last Edit: 2011-12-29
;; Desc: My personal .emacs, some mine and a lot stolen.

;; Load up our personal emacs extras
(let ((default-directory  "~/.emacs.d/extras/"))
      (normal-top-level-add-subdirs-to-load-path))

;; Stop spamming my folders with backups, put them somewhere specific.
(if (file-accessible-directory-p (expand-file-name "~/.emacs.d/.trash"))
    (add-to-list 'backup-directory-alist
                 (cons "." (expand-file-name "~/.trash/emacs-backups/"))))

;; Screw it just dont use them...
(setq backup-inhibited t)
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Make things pretty
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-subtle-hacker)))

;; Because fuck MacOSX thats why.
;; This ONLY exists to return proper home/end key behavior.
;; GRR!
(define-key global-map [M-home] 'beginning-of-buffer)
(define-key global-map [C-home] 'beginning-of-buffer)
(define-key global-map [home] 'beginning-of-line)
(define-key global-map [M-end] 'end-of-buffer)
(define-key global-map [C-end] 'end-of-buffer)
(define-key global-map [end] 'end-of-line)

;; Line by Line scrolling (so smoooth)
(setq scroll-step 1)

;; Mouse wheel scrolling
(mouse-wheel-mode t)

;; Load up autocomplete
(require 'auto-complete)
(add-to-list 'ac-dictionary-directories "~/emacs/extras/auto-complete/dict")
(require 'auto-complete-config)
(ac-config-default)

;; Syntax Highlight everything we can
(global-font-lock-mode 1)

;; show line wraps
(global-visual-line-mode t)

;; just load lua now..
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)

;; add a bunch of supported modes to autoload on open.
(setq auto-mode-alist (append 
		       '(("\\.html$" . html-mode)
			 ("\\.htm$" . html-mode)
			 ("\\.cfm$" . html-mode)
			 ("\\.asp$" . html-mode)
			 ("\\.ltt$" . html-mode)
			 ("\\.py$" . python-mode)
			 ("\\.lua$" . lua-mode)
			 ("\\.asm$" . asm-mode)
			 ("\\.sql$" . sql-mode)
			 ("\\.jsp$" . java-mode))
		       auto-mode-alist))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))

;; Buffer Quick Switch
; Great for moving around buffers quickly
(require 'pc-bufsw)   
(pc-bufsw::bind-keys [(control tab)] [ (control shift tab) ])

;; no start-up banner
(setq inhibit-startup-message t)

;; turn delete-selection-mode on at startup
(delete-selection-mode)

;; kill the graphical toolbar 
(tool-bar-mode 0)

;; just-one-line a function I wrote to 
;; compliment just-one-space. 
(defun just-one-line (point mark)
"Removes all \n's from region."
(interactive "*r")
(when (> (point) (mark))
  (exchange-point-and-mark))
(while (< (point) (mark))
  (when (eolp)
	 (when (not (= (point) (mark)))
		(delete-char)
		(just-one-space)))
  (forward-char)))

;;; Define the kill-whole-line Function
;; Wrote this before I knew it was an option :)
;; this is my simple take ...
(defun kill-whole-line ()
  "Kills the entire line."
  (interactive)
  (move-to-left-margin) (kill-line))

;; [Re]Bind CTRL+k to 'my' "kill-whole-line' function
(global-set-key (kbd "C-k") 'kill-whole-line)


;; Bind CTRL+q to, essentially, 'copy'.
(global-set-key (kbd "C-q") 'copy-region-as-kill)

;; Kill current buffer without confirmation unless its modified.
(global-set-key [(control x) (k)] 'kill-this-buffer)

;; yay speedbar
(require 'speedbar)
(speedbar-change-initial-expansion-list "buffers")
(global-set-key  [f8] 'speedbar-get-focus)
; Bind F9 to load speedbar
(global-set-key [f9] 'speedbar)

;; Display column numbers only in code.
(column-number-mode t)

;; Display line numbers on the buffer
;; (global-linum-mode t)

;; Setup flyspell 
(flyspell-prog-mode)

;; Highlight matching parenthesis (and other bracket likes)
(show-paren-mode t)

;; Setup hippie-expand (we're going to have to make an eval-after-load          
;; section later)
(defun hippie-expand-case-sensitive (arg)
  "Do case sensitive searching so we deal with gtk_xxx and GTK_YYY."
  (interactive "P")
  (let ((case-fold-search nil))
    (hippie-expand arg)))

(global-set-key "`" 'hippie-expand-case-sensitive)
(global-set-key (kbd "M-SPC") 'hippie-expand-case-sensitive)
(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-all-abbrevs
        try-expand-list
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill))

;; M-<delete> kills word forward
;; Since M-DEL (backspace) kills word ,,backwards it only makes sense.
(global-set-key [M-delete] 'kill-word)

;; recently opened files...
(recentf-mode t)
