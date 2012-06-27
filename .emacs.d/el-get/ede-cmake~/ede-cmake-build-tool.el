;; EDE CMake Build Tool -- Support for build tool-specific behaviour in ede-cmake

;; Author: Alastair Rankine <alastair@girtby.net>

(defclass ede-cmake-build-tool ()
  ((generator-string
    :type string
    :initarg :generator-string
    :documentation "Which CMake generator to use for build files")
   (additional-parameters
    :initarg :additional-parameters
    :initform ""
    :type string
    :documentation "Additional parameters to build tool")
   )
)

(defclass cmake-make-build-tool (ede-cmake-build-tool)
  ((generator-string
    :type string
    :initarg :generator-string
    :initform "Unix Makefiles")
   )
  )

(defclass cmake-visual-studio-build-tool (ede-cmake-build-tool)
  ()
  )

(defmethod get-target-directory ((this cmake-make-build-tool) project target)
  (let ((builddir (cmake-build-directory project))
        (path (oref target path)))
    (concat (file-name-as-directory builddir) (file-name-as-directory path))))

(defmethod invoke-make ((this cmake-make-build-tool) dir targetname)
  "Invokes make in DIR for TARGETNAME"
  (let* ((args (if (slot-boundp this 'additional-parameters) (oref this additional-parameters) ""))
         (cmd (format "(cd %s ; make %s %s )" dir args targetname)))
    (compile cmd)))

(defmethod target-build-dir ((this cmake-make-build-tool) target)
  "Returns the path to the build directory for target"
  (concat (file-name-as-directory (cmake-build-directory (ede-target-parent target)))
          (file-name-as-directory (oref target path))))

(defmethod target-binary ((this cmake-make-build-tool) target)
  "Returns the path to the binary for target"
  (concat (target-build-dir this target) (oref target name)))

(defmethod compile-target-file ((this cmake-make-build-tool) target file)
  "Compiles FILE in BUILD-DIR in TARGET"
  (let* ((dir (target-build-dir this target))
         (doto (concat(file-name-sans-extension (file-name-nondirectory file)) ".o")))
    (invoke-make this dir doto)
    ))

(defmethod debug-target ((this cmake-make-build-tool) target)
  "Invokes gdb to debug TARGET in BUILD-DIR"
  (let* ((exe (target-binary this target))
         (cmd (concat "gdb --annotate=3 " exe)))
    (gdb cmd)))

(provide 'ede-cmake-build-tool)
