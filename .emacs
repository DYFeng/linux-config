;
;; author:
;; DY.Feng
;;
;; e-mail:
;; yyfeng88625@gmail.com

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;添加~/.emacs.d/el-get下所有非隐藏目录到load-path
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(mapcar '(lambda (name)
	   (if (file-directory-p name)
	       (add-to-list 'load-path name) nil))
	(directory-files "~/.emacs.d/el-get" t "^[a-zA-z0-9]+"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; el-get安装
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(unless (require 'el-get nil t)
  (url-retrieve
   "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
   (lambda (s)
     (goto-char (point-max))
     (eval-print-last-sexp))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;auctex
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d/el-get/auctex/preview")
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(mapc (lambda (mode)
        (add-hook 'LaTeX-mode-hook mode))
      (list 'auto-fill-mode
	    'LaTeX-math-mode
	    'turn-on-reftex
	    'linum-mode))
(add-hook 'LaTeX-mode-hook
	  (lambda ()
	    (setq TeX-auto-untabify t     ; remove all tabs before saving
		  TeX-engine 'xetex       ; use xelatex default
		  TeX-show-compilation t) ; display compilation windows
	    (TeX-global-PDF-mode t)       ; PDF mode enable, not plain


	    (setq TeX-save-query nil)
	    (imenu-add-menubar-index)
	    (define-key LaTeX-mode-map (kbd "<f6>") '(TeX-run-compile "LaTex" "LaTex" (TeX-master-file)))
	    (define-key LaTeX-mode-map (kbd "TAB") 'TeX-complete-symbol)))

(setq-default TeX-master "main.tex")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;weibo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'weibo)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;linum+
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'linum+)
(setq linum-format ["%%%dd "])


          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; cedet
          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load-file "~/.emacs.d/cedet/common/cedet.el")



(require 'cedet)
(require 'cc-mode)
;; 开启EDE
(global-ede-mode t)

(require 'semantic-ia)
(require 'semantic-gcc)
(semantic-load-enable-excessive-code-helpers)


(setq qt4-base-dir "/usr/include/qt4")
(semantic-add-system-include qt4-base-dir 'c++-mode)
(add-to-list 'auto-mode-alist (cons qt4-base-dir 'c++-mode))
(add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qconfig.h"))
(add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qconfig-dist.h"))
(add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qglobal.h"))


;; h/cpp切换
(require 'eassist nil 'noerror)
(define-key c-mode-base-map (kbd "<f4>") 'eassist-switch-h-cpp)
(setq eassist-header-switches
      '(("h" . ("cpp" "cxx" "c++" "CC" "cc" "C" "c" "mm" "m"))
	("hh" . ("cc" "CC" "cpp" "cxx" "c++" "C"))
	("hpp" . ("cpp" "cxx" "c++" "cc" "CC" "C"))
	("hxx" . ("cxx" "cpp" "c++" "cc" "CC" "C"))
	("h++" . ("c++" "cpp" "cxx" "cc" "CC" "C"))
	("H" . ("C" "CC" "cc" "cpp" "cxx" "c++" "mm" "m"))
	("HH" . ("CC" "cc" "C" "cpp" "cxx" "c++"))
	("cpp" . ("hpp" "hxx" "h++" "HH" "hh" "H" "h"))
	("cxx" . ("hxx" "hpp" "h++" "HH" "hh" "H" "h"))
	("c++" . ("h++" "hpp" "hxx" "HH" "hh" "H" "h"))
	("CC" . ("HH" "hh" "hpp" "hxx" "h++" "H" "h"))
	("cc" . ("hh" "HH" "hpp" "hxx" "h++" "H" "h"))
	("C" . ("hpp" "hxx" "h++" "HH" "hh" "H" "h"))
	("c" . ("h"))
	("m" . ("h"))
	("mm" . ("h"))))

(defun semantic-ia-fast-jump-back ()
  (interactive)
  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
      (error "Semantic Bookmark ring is currently empty"))
  (let* ((ring (oref semantic-mru-bookmark-ring ring))
	 (alist (semantic-mrub-ring-to-assoc-list ring))
	 (first (cdr (car alist))))
    (if (semantic-equivalent-tag-p (oref first tag) (semantic-current-tag))
	(setq first (cdr (car (cdr alist)))))
    (semantic-mrub-switch-tags first)))

(defun semantic-ia-fast-jump-or-back (&optional back)
  (interactive "P")
  (if back
      (semantic-ia-fast-jump-back)
    (semantic-ia-fast-jump (point))))

(defun dyfeng/semantic-jump ()
  (interactive)
  (buffer-substring (point-at-bol) (point-at-eol))
  )



;;跳转到声明
(define-key c-mode-base-map (kbd "<f3>") 'semantic-ia-fast-jump) 

;;跳转到实现
(define-key c-mode-base-map (kbd "<S-f3>") 'semantic-analyze-proto-impl-toggle)

;;进入头文件
(define-key semantic-decoration-on-include-map (kbd "<f3>") 'semantic-decoration-include-visit)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;ecb
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load-file "~/.emacs.d/el-get/ecb/ecb.el")
(require 'ecb)





                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; color-theme
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;cmake配合EDE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;(require 'ede-generic)

;; (require 'ede-cmake)			
;; 
;; ;; Example only
;; (defvar my-project-root-build-directories
;;   '(("None" . "build")
;;     ("Debug" . "debug")
;;     ("Release" . "release"))
;;   "Alist of build directories in the project root"
;;  )
;; 
;; (defun my-project-root-build-locator (config root-dir)
;;   "Locates a build directory in the project root, uses
;; project-root-build-directories to look up the name."
;;   (cdr (assoc config my-project-root-build-directories)))
;; 
;; (defun my-load-project (dir)
;;   "Load a project of type `ede-cmake-cpp-project' for the directory DIR.
;;      Return nil if there isn't one."
;;   (ede-cmake-cpp-project 
;;    (file-name-nondirectory (directory-file-name dir))
;;    :directory dir
;;    :locate-build-directory 'my-project-root-build-locator
;;    :build-tool (cmake-make-build-tool "Make" :additional-parameters " -kr")
;;    :include-path '( "/" )
;;    :system-include-path (list (expand-file-name "external" dir) )
;;    ))
;; 
;; (defun ede-cmake-cpp-project-load (dir)
;;   "Return an CMake project object if there is one.
;; Return nil if there isn't one.
;; Argument DIR is the directory it is created for.
;; ROOTPROJ is nil, sinc there is only one project for a directory tree."
;;   (let* ((root (ede-cmake-cpp-project-root dir))
;; 	 (proj (and root (ede-directory-get-open-project root)))
;; 	 )
;;     (if proj
;; 	proj
;; 
;;       (when root
;; 	;; Create a new project here.
;; 	(let* ((name (file-name-nondirectory (directory-file-name root))))
;; 	  (setq proj (ede-cmake-cpp-project
;; 		      name
;; 		      :name name
;; 		      :directory (file-name-as-directory dir)
;; 		      :locate-build-directory 'my-project-root-build-locator
;; 		      :build-tool (cmake-make-build-tool "Make" :additional-parameters " -kr")
;; 		      :include-path '( "/" )		      
;; 		      :file "CMakeLists.txt"
;; 		      :targets nil)))
;; 	(ede-add-project-to-global-list proj)
;; 	))))
;; 
;;   ;; (ede-generic-new-autoloader "generic-cmake" "CMake"
;;   ;; 			      "CMakeLists.txt" 'ede-cmake-cpp-project)
;; 
;; 
;; (ede-add-project-autoload
;;  (ede-project-autoload "CMake"
;; 		       :name "generic-cmake"
;;                        :file 'ede-cmake
;;                        :proj-file "CMakeLists.txt"
;;                        :proj-root 'ede-cmake-cpp-project-root
;;                        :proj-root-dirmatch ""
;;                        :load-type 'ede-cmake-cpp-project-load
;;                        :class-sym 'ede-cmake-cpp-project)
;;  'unique)





;;不再确认编译命令,直接编译
(setq compilation-read-command nil)

(define-key c-mode-base-map (kbd "<f12>") 'compile)





;; ;; my functions for EDE
;; (defun dyfeng/ede-get-local-var (fname var)
;;   "fetch given variable var from :local-variables of project of file fname"
;;   (let* ((current-dir (file-name-directory fname))
;;          (prj (ede-current-project current-dir)))
;;     (when prj
;;       (let* ((ov (eval (oref prj local-variables)))
;; 	     (lst (assoc var ov)))
;;         (when lst
;;           (cdr lst))))))
;; 
;; 
;; 
;; (defun dyfeng/join-list(lst s)
;;   (let*  ((str s))
;;     (while lst
;;       (setq str (concat  str (car lst) s))
;;       (setq lst (cdr lst)))
;;     str )
;;   )
;; 
;; (defun dyfeng/ede-find-project-file (dir)
;;   (catch 'break
;;     (let* (
;; 	   (dir_list (split-string dir "/" t))
;; 	   (dir_length (length dir_list))       
;; 	   (las dir_list)
;; 	   )
;;       (while las
;; 	(setq dir (dyfeng/join-list dir_list "/"))
;; 	(when 
;; 	    (and (file-directory-p dir) (directory-files dir t "^Project.ede$"))
;; 	  (setq default-directory dir)
;; 	  (throw 'break dir)
;; 	  )
;; 	(setq las  (nbutlast dir_list 1))
;; 	)))
;;   )
;; 
;; ;; setup compile package
;; (require 'compile)
;; (setq compilation-disable-input nil)
;; (setq compilation-scroll-output t)
;; (setq mode-compile-always-save-buffer-p t)
;; 
;; 
;; 
;; (defun dyfeng/compile ()
;;   "Saves all unsaved buffers, and runs 'compile'."
;;   (interactive)
;;   (save-some-buffers t)
;; ;;  (setq default-directory (dyfeng/ede-find-project-file)) 
;;   (let* ((r (dyfeng/ede-get-local-var
;;              ;;(or (buffer-file-name (current-buffer)) default-directory)
;;              (dyfeng/ede-find-project-file (buffer-file-name (current-buffer)))
;; 'compile-command))
;;          (cmd (if (functionp r) (funcall r) r)))
;;     (set (make-local-variable 'compile-command) (or cmd compile-command))
;;     (compile compile-command)))
;; 
;; 
;; 
;; (global-set-key (kbd "<f12>") 'dyfeng/compile)
;; 
;; (defun dyfeng/gen-std-compile-string ()
;;   "Generates compile string for compiling CMake project in debug mode"
;;   (let* ((current-dir (file-name-directory
;;                        (or (buffer-file-name (current-buffer)) default-directory)))
;;          (prj (ede-current-project current-dir))
;;          (root-dir (ede-project-root-directory prj)))
;;     (concat "cd " root-dir "; make -j2")))
;; 
;; 
;; (defun dyfeng/gen-cmake-debug-compile-string ()
;;   "Generates compile string for compiling CMake project in debug mode"
;;   (let* ((current-dir (file-name-directory
;;                        (or (buffer-file-name (current-buffer)) default-directory)))
;;          (prj (ede-current-project current-dir))
;;          (root-dir (ede-project-root-directory prj))
;;          (subdir "")
;;          )
;;     (when (string-match root-dir current-dir)
;;       (setf subdir (substring current-dir (match-end 0))))
;;     (concat "cd " root-dir "debug/" "; make")))
;; 
;; 
;; (defun dyfeng/gen-cmake-release-compile-string ()
;;   "Generates compile string for compiling CMake project in debug & release modes"
;;   (let* ((current-dir (file-name-directory
;;                        (or (buffer-file-name (current-buffer)) default-directory)))
;;          (prj (ede-current-project current-dir))
;;          (root-dir (ede-project-root-directory prj))
;;          (subdir "")
;;          )
;;     (when (string-match root-dir current-dir)
;;       (setf subdir (substring current-dir (match-end 0))))
;;     (concat "cd "  root-dir "release/ && make -j2" )))
;; 
;; 
;; ;; Projects
;; 
;; ;; cpp-tests project definition
;; (when (file-exists-p "~/projects/lang-exp/cpp/CMakeLists.txt")
;;   (setq cpp-tests-project
;; 	(ede-cpp-root-project "cpp-tests"
;; 			      :file "~/projects/lang-exp/cpp/CMakeLists.txt"
;; 			      :system-include-path '("/home/ott/exp/include"
;; 						     boost-base-directory)
;; 			      :local-variables (list
;; 						(cons 'compile-command 'dyfeng/gen-cmake-debug-compile-string)
;; 						)
;; 			      )))
;; 
;; (when (file-exists-p "~/projects/squid-gsb/README")
;;   (setq squid-gsb-project
;; 	(ede-cpp-root-project "squid-gsb"
;; 			      :file "~/projects/squid-gsb/README"
;; 			      :system-include-path '("/home/ott/exp/include"
;; 						     boost-base-directory)
;; 			      :local-variables (list
;; 						(cons 'compile-command 'dyfeng/gen-cmake-debug-compile-string)
;; 						)
;; 			      )))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; yasnippet
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'yasnippet)
(setq yas/snippet-dirs '(
"~/.emacs.d/el-get/yasnippet/snippets" 
;;"~/.emacs.d/el-get/yasnippet/yasnippet-snippets" 
"~/.emacs.d/el-get/yasnippet/extras/imported"
))
(yas/initialize)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto-complete
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'pos-tip)
;; (setq popup-tip-max-width 20000)
(require 'auto-complete)
(require 'auto-complete-config)
;;(add-to-list 'ac-dictionary-directories "~/.emacs.d/el-get/auto-complete/dict")
(setq ac-show-menu-immediately-on-auto-complete t)
(ac-config-default)
(setq ac-auto-start 2)
(global-auto-complete-mode t)
(setq ac-use-fuzzy t)
;; dirty fix for having AC everywhere
(define-globalized-minor-mode real-global-auto-complete-mode
  auto-complete-mode (lambda ()
                       (if (not (minibufferp (current-buffer)))
                         (auto-complete-mode 1))
                       ))
(real-global-auto-complete-mode t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto-complete-clang
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'auto-complete-clang)
;; 添加c-mode和c++-mode的hook，开启auto-complete的clang扩展
(defun ac-cc-mode-setup ()
  (make-local-variable 'ac-auto-start)
  (setq ac-auto-start nil)   ; auto complete using clang is CPU sensitive
  (setq ac-sources (append '(ac-source-clang ac-source-semantic) ac-sources)))


(setq ac-sources (append '(ac-source-abbrev ac-source-yasnippet ac-source-dictionary ac-source-words-in-same-mode-buffers ac-source-filename) ac-sources))
(setq ac-clang-flags (list
		      "/usr/include/c++/4.6"
		      "/usr/include/c++/4.6/x86_64-linux-gnu/."
		      "/usr/include/c++/4.6/backward"
		      "/usr/lib/gcc/x86_64-linux-gnu/4.6/include"
		      "/usr/lib/gcc/x86_64-linux-gnu/4.6/include-fixed"
		      "/usr/include/x86_64-linux-gnu"
		      "/usr/include"
		      "/usr/local/include"
		      ))
(add-hook 'c-mode-common-hook 'ac-cc-mode-setup)
;; (add-hook 'c++-mode-hook 'ac-cc-mode-setup)
(add-hook 'css-mode-hook 'ac-css-mode-setup)
(add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)

(define-key c-mode-base-map (kbd "TAB") 'auto-complete)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;markdown-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'markdown-mode)
(setq auto-mode-alist
      (cons '("\\.markdown" . markdown-mode) auto-mode-alist))

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;注释
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun dyfeng/comment (&optional arg)
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg))
  )
(global-set-key (kbd "C-S-d") 'dyfeng/comment)
(setq comment-empty-lines t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto-pair+
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'autopair)
(require 'auto-pair+)
(setq autopair-autowrap t)
(setq autopair-goto-char-after-region-wrap 3)
(setq autopair-goto-char-after-region-wrap-comments 3)

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; doxymacs
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'doxymacs)
(add-hook 'c-mode-common-hook 'doxymacs-mode)
;; (setq doxymacs-doxygen-style "C++")




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;杂项
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;不显示欢迎画面
(setq inhibit-startup-message t)

;;用y/n代替yes/no				
(fset 'yes-or-no-p 'y-or-n-p)

(add-hook 'find-file-hooks  'dyfeng/misc-mode-hook)
(defun dyfeng/misc-mode-hook ()
  (interactive)
  (show-paren-mode t) ;括号匹配
  (linum-mode)  ;linum-mode
  (autopair-mode) ;开启自动补全括号模式
  )

(setq default-major-mode 'text-mode)
(put 'upcase-region 'disabled nil)

;; 将.h文件作为C++ mode打开
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))


(setq user-mail-address "yyfeng88625@gmail.com")

;;把本地文件刷新到buffer
(global-set-key (kbd "<M-f5>") 'revert-buffer)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 代码整理
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun dyfeng/astyle-code-formatter ()
  (interactive)
  (point-to-register ?1)
  (shell-command-on-region
   (point-min)
   (point-max)
   "astyle" ;; add options here...
   (current-buffer)
   ;; replace?
   t
   (get-buffer-create "*Astyle Errors*") t)
  (register-to-point ?1)
  )


(define-key c-mode-base-map (kbd "M-F") 'dyfeng/astyle-code-formatter)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;在窗体间移动光标
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
( global-set-key [ S-left ] 'windmove-left ) ; move to left windnow
( global-set-key [ S-right ] 'windmove-right ) ; move to right window
( global-set-key [ S-up ] 'windmove-up ) ; move to upper window
( global-set-key [ S-down ] 'windmove-down ) ; move to downer window

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;录制宏快捷键，f4用作头源文件切换
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "<M-f3>") 'kmacro-start-macro-or-insert-counter)
(global-set-key (kbd "<M-f4>") 'kmacro-end-or-call-macro)

(global-set-key (kbd "<M-left>") 'next-buffer)
(global-set-key (kbd "<M-right>") 'previous-buffer)





(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40")
 '(ede-project-directories (quote ("/home/feng/fun/afrodevices-read-only/baseflight" "/home/feng/fun/lab" "/home/feng/fun/AirRobotControler"))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
