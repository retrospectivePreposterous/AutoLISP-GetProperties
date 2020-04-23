(defun c:PC (/ OBJ OBJENT OBJLAX PATH FILE NAME PTHFLE DES)
(prompt "\n***PropertyConsole is an application developed by ALEJANDRO BURGUENO DIAZ***\n")

(defun SLEEP (secs / endt)
(setq endt (+ (getvar "DATE") (/ secs 86400.0)))
(while (< (getvar "DATE") endt) T))

(vl-load-com)

;PATH WHERE .BAT WILL BE STORED (SAME AS DWG DRAWING LOCATION) AND TITLE NAME (SAME AS DWG DRAWING NAME):

;;(setq PATH (getvar "dwgprefix"))
(setq PATH "C:\\Windows\\Temp\\")
;;(setq NAME (vl-filename-base (getvar "dwgname")))
(setq NAME "console")
(setq FILE (strcat NAME ".bat"))
(setq PTHFLE (strcat PATH FILE))

;-------------------------------------------------------------------------------------------------------

;OBJECT SELECTION AND TRANSFORMATION TO VLA AND TO ENT:

(setq OBJ (car(entsel "\n Select an object .. " )))

(setq OBJLAX (vlax-ename->vla-object OBJ))
(setq OBJENT (entget OBJ))

;-------------------------------------------------------------------------------------------------------

;GET DATA STRINGS:

(setq S01 (strcat "echo Entity: " (cdr (assoc 0 OBJENT)) ) )
(setq S02 (strcat "echo Layer:  " (cdr (assoc 8 OBJENT)) ) )
(setq S03 (strcat "echo Handle: " (vla-get-handle OBJLAX) ) )

(if  (= (vlax-property-available-p OBJLAX 'Length) nil)
(setq S04 "echo Lenght: ---" )
(setq S04 (strcat "echo Lenght: " (rtos(vla-get-length OBJLAX)) ) )
)

(if  (= (vlax-property-available-p OBJLAX 'Area) nil)
(setq S05 "echo Area:   ---" )
(setq S05 (strcat "echo Area:   " (rtos(vla-get-area OBJLAX)) ) )
)

(if  (= (vlax-property-available-p OBJLAX 'Volume) nil)
(setq S06 "echo Volume: ---" )
(setq S06 (strcat "echo Volume: " (rtos(vla-get-volume OBJLAX)) ) )
)

(if  (= (vlax-property-available-p OBJLAX 'Effectivename) nil)
(setq S07 "echo Name:   ---" )
(setq S07 (strcat "echo Name:   " (vla-get-effectivename OBJLAX) ) )
)

(if  (or (eq (cdr (assoc 0 OBJENT)) "INSERT") (or (eq (cdr (assoc 0 OBJENT)) "CIRCLE") (eq (cdr (assoc 0 OBJENT)) "POINT") ) ) ;Only in blocks, points and circles.
(progn
(setq S08 (strcat "echo CoordX: " (rtos(nth 1 (assoc 10 OBJENT))) ) )
(setq S09 (strcat "echo CoordY: " (rtos(nth 2 (assoc 10 OBJENT))) ) )
(setq S10 (strcat "echo CoordZ: " (rtos(nth 3 (assoc 10 OBJENT))) ) )
)
(progn
(setq S08 "echo CoordX: ---" )
(setq S09 "echo CoordY: ---" )
(setq S10 "echo CoordZ: ---" )
)
)

;-------------------------------------------------------------------------------------------------------

;TYPE HEADER AND DATA STRINGS, THEN RUN, THEN DELETE FILE:

(setq DES (open PTHFLE "w")) 
(write-line
"@ echo off
Title PropertyConsole
echo OBJECT PROPERTIES:
echo."
DES) (close DES)

(setq DES (open PTHFLE "a")) (write-line "echo ________________________________________" DES) (close DES)
(setq DES (open PTHFLE "a")) (write-line "echo IDENTIFICATION" DES) (close DES)
(setq DES (open PTHFLE "a")) (write-line S01 DES) (close DES)
(setq DES (open PTHFLE "a")) (write-line S02 DES) (close DES)
(setq DES (open PTHFLE "a")) (write-line S03 DES) (close DES)
(setq DES (open PTHFLE "a")) (write-line "echo ________________________________________" DES) (close DES)
(setq DES (open PTHFLE "a")) (write-line "echo DIMENSIONS" DES) (close DES)
(setq DES (open PTHFLE "a")) (write-line S04 DES) (close DES)
(setq DES (open PTHFLE "a")) (write-line S05 DES) (close DES)
(setq DES (open PTHFLE "a")) (write-line S06 DES) (close DES)
(setq DES (open PTHFLE "a")) (write-line "echo ________________________________________" DES) (close DES)
(setq DES (open PTHFLE "a")) (write-line "echo LOCATION" DES) (close DES)
(setq DES (open PTHFLE "a")) (write-line S07 DES) (close DES)
(setq DES (open PTHFLE "a")) (write-line S08 DES) (close DES)
(setq DES (open PTHFLE "a")) (write-line S09 DES) (close DES)
(setq DES (open PTHFLE "a")) (write-line S10 DES) (close DES)

(setq DES (open PTHFLE "a")) (write-line "pause >nul" DES) (close DES)

(startapp PTHFLE)

(SLEEP 3)

(vl-file-delete PTHFLE)
)