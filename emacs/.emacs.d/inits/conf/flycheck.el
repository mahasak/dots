(require 'use-package)
(require 'general)

(use-package flycheck
  :general
  (my-map
    "c" '(:ignore t :which-key "check")
    "c l" 'flycheck-list-errors
    "c c" 'helm-flycheck)

  :init
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)
                flycheck-emacs-lisp-load-path 'inherit)

  (defun my-use-eslint-from-node-modules ()
    (let* ((root (locate-dominating-file
                  (or (buffer-file-name) default-directory)
                  "node_modules"))
           (eslint (and root
                        (expand-file-name "node_modules/eslint/bin/eslint.js"
                                          root))))
      (when (and eslint (file-executable-p eslint))
        (setq-local flycheck-javascript-eslint-executable eslint))))

  (add-hook 'flycheck-mode-hook #'my-use-eslint-from-node-modules)

  (add-hook 'after-init-hook 'global-flycheck-mode))

(use-package flycheck-pos-tip
  :init
  (add-hook 'global-flycheck-mode-hook 'flycheck-pos-tip-mode))

(use-package flycheck-irony
  :after irony

  :init
  (add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

(use-package flycheck-rust
  :after rust

  :init
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(use-package flycheck-google-cpplint
  :after irony

  :init
  (setq flycheck-c/c++-googlelint-executable "cpplint"
        flycheck-googlelint-filter "-legal")

  :config
  (flycheck-add-next-checker
   'irony
   '(warning . c/c++-googlelint)))

(provide 'conf/flycheck)
