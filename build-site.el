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

(use-package org-publish-rss
  :vc (:url "https://git.sr.ht/~taingram/org-publish-rss"
       :rev :newest))

;; Macro and function sourced from https://taingram.org/blog/org-mode-blog.html
(setq org-export-global-macros
            '(("timestamp" . "@@html:<span class=\"timestamp\">[$1]</span>@@")))

(defun my/org-sitemap-date-entry-format (entry style project)
  "Format ENTRY in org-publish PROJECT Sitemap format ENTRY ENTRY STYLE format that includes date."
  (let ((filename (org-publish-find-title entry project)))
    (if (= (length filename) 0)
        (format "*%s*" entry)
      (format "{{{timestamp(%s)}}} [[file:%s][%s]]"
              (format-time-string "%Y-%m-%d"
                                  (org-publish-find-date entry project))
              entry
              filename))))

;; Imports the preamble html from preamble.html
(defvar preamble
  (with-temp-buffer
    (insert-file-contents "./files/html-template/preamble.html")
    (buffer-string))
  "Contents of preamble.html.")

(setq org-html-postamble preamble)

;; Imports the postamble html from postamble.html
(defvar postamble
  (with-temp-buffer
    (insert-file-contents "./files/html-template/postamble.html")
    (buffer-string))
  "Contents of postamble.html.")

(setq org-html-postamble postamble)

;; Import the head from head.html
(defvar head
  (with-temp-buffer
    (insert-file-contents "./files/html-template/head.html")
    (buffer-string))
  "Contents of head.html.")

(setq org-html-head head)

(setq org-html-home/up-format "")

(setq org-html-divs '((preamble "header" "top")
                      (content "main" "content")
                      (postamble "footer" "postamble")))

;; Define the publishing project
(setq org-publish-project-alist
      (list
       (list "blog"
	     :base-directory "./files/blog"
	     :publishing-function 'org-html-publish-to-html
	     :publishing-directory "./public/blog"
	     :exclude "index.org"
	     :with-title t
	     :with-author t
	     :with-creator t
	     :with-date t
	     :with-toc nil
	     :section-numbers nil
	     :html-validation-link nil
	     :html-doctype "html5"
	     :html-html5-fancy t
	     :html-head-include-scripts nil
	     :html-head-include-default-style nil
	     :time-stamp-file nil
	     :html-head head
	     :html-preamble preamble
	     :html-postamble postamble
	     
	     :auto-sitemap t
	     :sitemap-format-entry 'my/org-sitemap-date-entry-format
	     :sitemap-title "Blog Posts"
	     :sitemap-filename "sitemap.org"
	     :sitemap-sort-files 'anti-chronologically
	     
	     :auto-rss t
	     :rss-file "blog.xml"
	     :rss-title "Jacob Moujalli's Blog Posts"
	     :rss-description "Blog posts on various topics."
	     :html-link-home "https://moujal.li/blog/"
	     :rss-with-content 'all
	     :completion-function 'org-publish-rss)

       (list "blog-index"
	     :base-directory "./files/blog"
	     :publishing-function 'org-html-publish-to-html
	     :publishing-directory "./public/blog"
	     :include '("index.org")
	     :exclude ".*"
	     :with-title nil
	     :with-author t
	     :with-creator t
	     :with-date t
	     :with-toc nil
	     :section-numbers nil
	     :html-validation-link nil
	     :html-doctype "html5"
	     :html-html5-fancy t
	     :html-head-include-scripts nil
	     :html-head-include-default-style nil
	     :time-stamp-file nil
	     :html-head head
	     :html-preamble preamble
	     :html-postamble postamble)

       (list "main"
	     :base-directory "./files"
	     :publishing-function 'org-html-publish-to-html
	     :publishing-directory "./public"
	     :with-title nil
	     :with-author nil
	     :with-creator nil
	     :with-toc nil
	     :section-numbers nil
	     :html-validation-link nil
	     :html-doctype "html5"
	     :html-html5-fancy t
	     :html-head-include-scripts nil
	     :html-head-include-default-style nil
	     :time-stamp-file nil
	     :html-head head
	     :html-link-home "https://moujal.li"
	     :html-preamble preamble
	     :html-postamble postamble)

       (list "rss"
	     :recursive t
	     :base-directory "./files"
	     :base-extension "xml"
	     :publishing-function 'org-publish-attachment
	     :publishing-directory "./public/")

       (list "css"
	     :recursive t
	     :base-directory "./files"
	     :base-extension "css"
	     :publishing-function 'org-publish-attachment
	     :publishing-directory "./public/")

       (list "assets"
	     :recursive t
	     :base-directory "./files/assets/"
	     :base-extension 'any'
	     :publishing-function 'org-publish-attachment
	     :publishing-directory "./public/assets/")))

;; Generate the site output
(org-publish-all t)

(message "Build complete!")
