(use-package :sb-alien)

(define-alien-routine ("mount" linux-mount) int
  (source c-string)
  (target c-string)
  (filesystemtype c-string)
  (mountflags unsigned-long)
  (data (* t)))

(defun remount-root-rw ()
  (let ((MS_REMOUNT 32))
    (format t "Attempting to remount / as RW...~%")
    ;; Using sb-sys:int-sap 0 to provide a literal NULL pointer
    (let ((result (linux-mount "/dev/vda2" "/" "ext4" MS_REMOUNT (sb-sys:int-sap 0))))
      (if (= result 0)
          (format t "Success! / is now RW.~%")
          (format t "Failed! Errno: ~A~%" (sb-unix::get-errno))))))

;; Use unsigned-int to allow the large magic hex values
(define-alien-routine ("reboot" linux-reboot) int
  (magic1 unsigned-int)
  (magic2 unsigned-int)
  (cmd unsigned-int)
  (arg (* t)))

(defun system-reboot ()
  (let ((LINUX_REBOOT_MAGIC1 #xfee1dead)
        (LINUX_REBOOT_MAGIC2 #x28121969)
        (LINUX_REBOOT_CMD_RESTART #x01234567))
    (linux-reboot LINUX_REBOOT_MAGIC1 LINUX_REBOOT_MAGIC2 LINUX_REBOOT_CMD_RESTART (sb-sys:int-sap 0))))

(defun system-poweroff ()
  (let ((LINUX_REBOOT_MAGIC1 #xfee1dead)
        (LINUX_REBOOT_MAGIC2 #x28121969)
        (LINUX_REBOOT_CMD_POWER_OFF #x4321fedc))
    (linux-reboot LINUX_REBOOT_MAGIC1 LINUX_REBOOT_MAGIC2 LINUX_REBOOT_CMD_POWER_OFF (sb-sys:int-sap 0))))

(define-alien-routine ("sync" linux-sync) void)

(defun safe-poweroff ()
  (format t "Syncing filesystems...~%")
  (linux-sync)
  (format t "Powering off...~%")
  (system-poweroff))

(defun force-poweroff ()
  (format t "Syncing...~%")
  (finish-output)
  ;; Equivalent to 'echo o > /proc/sysrq-trigger'
  (with-open-file (s "/proc/sysrq-trigger" :direction :output :if-exists :overwrite)
    (write-char #\o s))
  (format t "If you see this, SysRq poweroff failed.~%"))

(defun lisp-os-repl ()
  (remount-root-rw)
  (loop
    (handler-case
        (sb-impl::toplevel-repl nil)
      (storage-condition (c) (format t "Out of memory: ~A~%" c))
      (error (c) (format t "Caught Error: ~A~%" c))
      (sb-sys:interactive-interrupt () (format t "Interrupted by user.~%")))))

(lisp-os-repl)
