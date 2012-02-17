(defun lupin-title (title)
  (interactive "sタイトル: ")
  (let ((original-buffer (current-buffer))
        (original-font-height (face-attribute 'default :height))
        (original-fill-column fill-column)
        (font-height 600)
        (font (frame-parameter nil 'font))
        (lupin-buf (get-buffer-create "*Lupin*")))

    ;; set lupin screen
    (copy-face 'mode-line 'original-modeline-face)
    (copy-face 'mode-line-buffer-id 'original-modeline-buffer-id-face)
    (copy-face 'minibuffer-prompt 'original-minibuffer-face)
    (copy-face 'default 'original-default-face)

    ;; change parameters
    (switch-to-buffer lupin-buf)
    (set-face-attribute 'mode-line nil :foreground "black" :background "black" :box nil)
    (set-face-attribute 'mode-line-buffer-id nil :foreground "black" :background "black" :box nil)
    (set-face-attribute 'default (selected-frame) :foreground "white" :background "black" :height font-height)
    (set-face-attribute 'minibuffer-prompt nil :foreground "black")

    (modify-frame-parameters (selected-frame) `((cursor-type . nil)
                                                (vertical-scroll-bars . nil)))
    (setq fill-column (/ (display-pixel-width) (frame-char-width)))
    (delete-other-windows)
    (dolist (char (split-string title "" t))
      (lupin-title-insert-text-with-sound char (lupin-title-audio1)))
    (lupin-title-insert-text-with-sound title (lupin-title-audio2))
    (sit-for 4)
    (switch-to-buffer original-buffer)

    ;; revert
    (modify-frame-parameters (selected-frame) `((cursor-type . box)
                                                (vertical-scroll-bars . t)))
    (set-frame-font font)
    (setq fill-column original-fill-column)
    (set-face-attribute 'default nil :height original-font-height)
    (copy-face 'original-modeline-face 'mode-line)
    (copy-face 'original-modeline-buffer-id-face 'mode-line-buffer-id)
    (copy-face 'original-minibuffer-face 'minibuffer-prompt)
    (copy-face 'original-default-face 'default)))

(defun lupin-title-insert-text-with-sound (text sound)
  (lupin-title-insert-text text)
  (sit-for 0.2)
  (lupin-title-play-sound sound))

(defun lupin-title-dir ()
  (expand-file-name (file-name-directory (locate-library "lupin-title"))))

(defun lupin-title-audio1 ()
  (concat (lupin-title-dir) "lupin1.wav"))

(defun lupin-title-audio2 ()
  (concat (lupin-title-dir) "lupin2.wav"))

(defun lupin-title-play-sound (sound-file-path)
  (apply 'start-process `("mplayer" nil "mplayer" "-vc" "null" "-vo" "null" "-quiet" ,sound-file-path ">" "/dev/null")))

(defun lupin-title-insert-line ()
  (let ((line (/ (/ (display-pixel-height) 2) (frame-char-height))) value)
    (dotimes (number line value)
      (newline))))

(defun lupin-title-insert-text (text)
  (erase-buffer)
  (lupin-title-insert-line)
  (insert text)
  (center-line))

(provide 'lupin-title)
