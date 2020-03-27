(defun c:GV(/ OLDCE SSET CNT OBJ OBJENT OBJLAX PATH FILE NAME PTHFLE DES STR)

(vl-load-com)
(setq OLDCE (getvar "cmdecho"))
(setvar "cmdecho" 0)

;PATH WHERE CSV WILL BE STORED (SAME AS DWG DRAWING LOCATION) AND TITLE NAME (SAME AS DWG DRAWING NAME):
(setq PATH (getvar "dwgprefix"))
(setq NAME (vl-filename-base (getvar "dwgname")))
(setq FILE (strcat NAME ".csv"))
(setq PTHFLE (strcat PATH FILE))
	(setq DES (open PTHFLE "w"))  	
	(write-line "ENTITY, LAYER, HANDLE, LENGHT, VOLUME, POSITION X, POSITION Y, POSITION Z, NAME" DES)
	(close DES)

;-------------------------------------------------------------------------------------------------------

;OBJECT SELECTION 1 - LINEAR OBJECTS:
(setq SSET (ssget "_X" '((0 . "LINE,*POLYLINE")) ))

(cond (SSET
(setq CNT -1)

;LOOP
	(while (setq OBJ (ssname SSET (setq CNT (1+ CNT))))
		(setq OBJLAX (vlax-ename->vla-object OBJ))
		(setq OBJENT (entget OBJ))

	;TYPE STRING
	(setq STR (strcat (cdr (assoc 0 OBJENT)) ", " (cdr (assoc 8 OBJENT)) ", " (vla-get-handle OBJLAX) ", " (rtos(vla-get-length OBJLAX)) ))
	(setq DES (open PTHFLE "a"))  	
	(write-line STR DES)
	(close DES)
)
) ;cond
)
;-------------------------------------------------------------------------------------------------------

;OBJECT SELECTION 2 - VOLUMETRIC OBJECTS:
(setq SSET (ssget "_X" '((0 . "3DSOLID")) ))

(cond (SSET
(setq CNT -1)

;LOOP
	(while (setq OBJ (ssname SSET (setq CNT (1+ CNT))))
		(setq OBJLAX (vlax-ename->vla-object OBJ))
		(setq OBJENT (entget OBJ))

	;TYPE STRING
	(setq STR (strcat (cdr (assoc 0 OBJENT)) ", " (cdr (assoc 8 OBJENT)) ", " (vla-get-handle OBJLAX) ", " "" ", " (rtos(vla-get-volume OBJLAX)) ))
	(setq DES (open PTHFLE "a"))  	
	(write-line STR DES)
	(close DES)
)
) ;cond
)
;-------------------------------------------------------------------------------------------------------

;OBJECT SELECTION 3 - BLOCKS:
(setq SSET (ssget "_X" '((0 . "INSERT")) ))

(cond (SSET
(setq CNT -1)

;LOOP
	(while (setq OBJ (ssname SSET (setq CNT (1+ CNT))))
		(setq OBJLAX (vlax-ename->vla-object OBJ))
		(setq OBJENT (entget OBJ))

	;TYPE STRING
	(setq STR (strcat (cdr (assoc 0 OBJENT)) ", " (cdr (assoc 8 OBJENT)) ", " (vla-get-handle OBJLAX) ", " "" ", " "" ", " (rtos(nth 1 (assoc 10 OBJENT))) ", " (rtos(nth 2 (assoc 10 OBJENT))) ", " (rtos(nth 3 (assoc 10 OBJENT))) ", " (cdr (assoc 2 OBJENT)) ))
	(setq DES (open PTHFLE "a"))  	
	(write-line STR DES)
	(close DES)
)
) ;cond
)
;-------------------------------------------------------------------------------------------------------

(setvar "cmdecho" OLDCE)
(alert "The process has been completed successfully")
(princ)
)