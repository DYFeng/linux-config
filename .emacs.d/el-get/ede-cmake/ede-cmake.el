;; ede-cmake.el --- EDE Project class for CMake-based C/C++ projects

;; Base on https://code.launchpad.net/~arankine/+junk/ede-cmake
;; Author: DY.Fneg <yyfeng88625@gmail.com>

(require 'ede)


(defclass ede-cmake-target (ede-target)
()
)

(defclass ede-cmake-project (ede-project)
((locate-build-directory
    :initarg :locate-build-directory
    :type function
    :documentation "Function to call to find the build directory
for a given configuration. Takes two arguments, the config and
the project root directory")
 (configurations
  :initarg :configurations
  :initform ("None" "Debug" "Release" "RelWithDebInfo" "MinSizeRel")
  :type list
  :custom (repeat string)
  :label "Configuration Options"
  :group (settings)
  :documentation "List of available configuration types.
Individual target/project types can form associations between a
configuration, and target specific elements such as build
variables.")
 (configuration-default
  :initarg :configuration-default
;;no default, will be selected from first valid build directory
  :initform "None"
  :custom string
  :label "Current Configuration"
  :group (settings)
  :documentation "The default configuration.")
 (configuration-build-directories
  :initarg :configuration-build-directories
  :type list
  :documentation "Per-configuration build directory")
 (build-directory
  :initarg :build-directory
  :custom string
  :label "Current Build Directory - takes precedence over
    per-configuration build directory if set")
 (build-tool
    :initarg :build-tool
    :type ede-cmake-build-tool)
 (build-tool-additional-parameters
  :initarg :build-tool-additional-parameters
  :type string
  :documentation "Additional parameters to build tool")

 ;; Stolen from ede-cpp-root
 (locate-fcn
  :initarg :locate-fcn
  :initform nil
  :type (or null function)
  :documentation
  "The locate function can be used in place of
`ede-expand-filename' so you can quickly customize your custom target
to use specialized local routines instead of the EDE routines.
The function symbol must take two arguments:
  NAME - The name of the file to find.
  DIR - The directory root for this cpp-root project.

It should return the fully qualified file name passed in from NAME.  If that file does not
exist, it should return nil.")
 )
"EDE CMake C/C++ project.")

(defmethod initialize-instance ((this ede-cmake-project)
				&rest fields)
  (call-next-method)

 
  ;; ;; TODO is this needed?
  ;; ;; (ede-project-directory-remove-hash (oref this directory))
  ;; ;; (ede-add-project-to-global-list this)
  ;; 
  ;; ;; Call the locate build directory function to populate the configuration-build-directories slot.
  ;; (when (and (not (slot-boundp this 'configuration-build-directories))
  ;;            (slot-boundp this 'locate-build-directory))
  ;;   (let ((locatefn (oref this locate-build-directory))
  ;;         (dir-root (oref this directory)))
  ;;     (oset this configuration-build-directories
  ;;           (mapcar (lambda (c) (cons c (let ((d (funcall locatefn c dir-root)))
  ;;                                         (when d
  ;;                                           (if (file-name-absolute-p d) d
  ;;                                             (concat (file-name-as-directory dir-root) d))))))
  ;;                   (oref this configurations)))
  ;;     ))
  ;; 
  ;; (if (slot-boundp this 'build-directory)
  ;;     (oset this configuration-default "None")
  ;; 
  ;;   ;; Does the configuration-default have a valid build directory?
  ;;   (let ((config-default-build (assoc (oref this configuration-default)
  ;;                                      (oref this configuration-build-directories))))
  ;;     (if (cmake-build-directory-valid-p (cdr config-default-build))
  ;;         ;; Yes, just use it:
  ;;         (oset this configuration-default (car config-default-build))
  ;;       
  ;;       ;; No, set the first configuration that has a valid build directory
  ;;       (let ((first-valid-config-build-dir (car (delq nil (mapcar (lambda (c) (if (cmake-build-directory-valid-p (cdr c)) c nil))
  ;; 								   (oref this configuration-build-directories))))))
  ;;         (if first-valid-config-build-dir
  ;;             (oset this configuration-default (car first-valid-config-build-dir))
  ;;           
  ;;           ;; Fallback of last resort - use the project root, but only if it has been used as a
  ;;           ;; build directory before (ie it has a "CMakeFiles" directory)
  ;;           (let ((cmakefiles (concat (file-name-as-directory (oref this directory)) "CMakeFiles")))
  ;;             (when (and (file-exists-p cmakefiles) (file-directory-p cmakefiles))
  ;;               (oset this configuration-build-directories (list (cons "None" (oref this directory))))
  ;;               (oset this configuration-default "None")
  ;;               ))
  ;;           ))
  ;;       ))
  ;;   )
  ;; 
  ;; ;; Set up the build tool
  ;; (unless (slot-boundp this 'build-tool)
  ;;   ;; Take a guess as to what the build tool will be based on the system type. Need a better way to
  ;;   ;; do this, but is there a way to get the information out of CMake?
  ;;   (oset this build-tool (if (eq system-type 'windows-nt)
  ;;                             (cmake-visual-studio-build-tool "Visual Studio")
  ;;                           (cmake-make-build-tool "GNU Make Tool")))
  ;;   )
)




(defun ede-cmake-root (&optional dir)
  "Gets the root directory for DIR."
  ;; Naive algorithm which just looks up in the directory heirarchy for until it doesn't find a
  ;; CMakeLists.txt file, and the last one is assumed to be the project root.
  ;; TODO: parse the CMakeLists.txt files and looking for PROJECT(..) commands.
  (if (file-exists-p (concat (file-name-as-directory dir) "CMakeLists.txt"))
      (let ((updir (ede-up-directory dir)))
        (or (and updir (ede-cmake-root updir))
            dir))
    nil))

(defvar ede-cmake-build-directories
  '(("None" . "build")
    ("Debug" . "build.dbg")
    ("Release" . "build.rel"))
  "Alist of build directories in the project root"
 )

(defun ede-cmake-build-locator (config root-dir)
  "Locates a build directory in the project root, uses
project-root-build-directories to look up the name."
  (cdr (assoc config ede-cmake-build-directories)))



(defun ede-cmake-load (dir)
  "Create a project of type `ede-cmake-project' for the directory DIR.
     Return nil if there isn't one."
  (let* ((root (ede-cmake-root dir))
	 (name (file-name-nondirectory (directory-file-name dir))))
    (ede-cmake-project 
     name
     :name name
     :directory (file-name-as-directory dir)
     :locate-build-directory 'ede-cmake-build-locator
     :targets nil
     :file (expand-file-name "CMakeLists.txt" root)
     ;;   :build-tool (cmake-make-build-tool "Make" :additional-parameters "-j4 -kr")
     ;;   :include-path '( "/" )
     ;;   :system-include-path (list (expand-file-name "lib" dir) )
     ))
)

(ede-add-project-autoload     
 (ede-project-autoload "cmake"
		       :name "CMAKE PROJECT"
                       :file 'ede-cmake
                       :proj-file "CMakeLists.txt"
		       :proj-root 'ede-cmake-root 
                       :proj-root-dirmatch ""
		       :load-type 'ede-cmake-load
                       :class-sym 'ede-cmake-project)
 'generic)


(provide 'ede-cmake)
