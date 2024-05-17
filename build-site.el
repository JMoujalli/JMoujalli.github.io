;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)

;; Load the publishing system
(require 'ox-publish)

;; Define the date format.
(defvar this-date-format "%b %d, %Y")

;; Imports the preamble html from preamble.html
(defun preamble (plist)
  ;; "PLIST: An entry."
  ;; (if (org-export-get-date plist this-date-format)
  ;;     (plist-put plist
  ;;                :subtitle (format "Published on %s by %s."
  ;;                                  (org-export-get-date plist this-date-format)
  ;;                                  (car (plist-get plist :author)))))
  ;; ;; Preamble
  (with-temp-buffer
    (insert-file-contents "../html-template/preamble.html") (buffer-string)))

;; Imports the postamble html from postamble.html
(defun postamble (plist)
  ;; "PLIST: An entry."
  ;; (if (org-export-get-date plist this-date-format)
  ;;     (plist-put plist
  ;;                :subtitle (format "Published on %s by %s."
  ;;                                  (org-export-get-date plist this-date-format)
  ;;                                  (car (plist-get plist :author)))))
  ;; ;; Postamble
  (with-temp-buffer
    (insert-file-contents "../html-template/postamble.html") (buffer-string)))


;; Define the publishing project
(setq org-publish-project-alist
      (list
       (list "main"
	     :recursive t
	     :base-directory "./main"
	     :publishing-function 'org-html-publish-to-html
	     :publishing-directory "./public"
	     :with-author nil
	     :with-creator nil
	     :with-toc nil
	     :section-numbers nil
	     :html-validation-link nil
	     :html-head-include-scripts nil
	     :html-head-include-default-style nil
	     :time-stamp-file nil
	     :html-head "<link rel=\"stylesheet\" href=\"./css/simple.css\" />"
	     :html-preamble 'preamble
	     :html-postamble 'postamble)
       (list "posts"
	     :recursive t
	     :base-directory "./posts"
	     :publishing-function 'org-html-publish-to-html
	     :publishing-directory "./public/posts"
	     :with-author nil
	     :with-creator nil
	     :with-toc nil
	     :section-numbers nil
	     :html-validation-link nil
	     :html-head-include-scripts nil
	     :html-head-include-default-style nil
	     :time-stamp-file nil
	     :html-head "<link rel=\"stylesheet\" href=\"../css/simple.css\" />"
	     :html-preamble 'preamble
	     :html-postamble 'postamble)
       (list "css"
	     :recursive t
	     :base-directory "./css"
	     :base-extension "css"
	     :publishing-function 'org-publish-attachment
	     :publishing-directory "./public/css/")
       (list "attachment"
	     :recursive t
	     :base-directory "./attachment"
	     :base-extension '("webm")
	     :publishing-function 'org-publish-attachment
	     :publishing-directory "./public/attachment/")))

;; Generate the site output
(org-publish-all t)

(message "Build complete!")
