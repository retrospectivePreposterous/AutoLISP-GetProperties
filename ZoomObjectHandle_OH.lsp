;;;;;; Zoom Object by its Handle value

(prompt "\nType OH to run ZoomObjectHandle...\n")

(defun c:OH ( / HND LD RL )
(prompt "\n***ZoomObjectHandle is an application developed by ALEJANDRO BURGUENO DIAZ***\n")

  (vl-load-com)
  (setq HND (getstring "\nEnter Handle value: "))
  (if (handent HND)
    (progn
      (vla-getboundingbox (vlax-ename->vla-object (handent HND)) 'LD 'RL)
      (vla-zoomwindow (vlax-get-acad-object) LD RL)
      (sssetfirst nil (ssadd (handent HND)))
    )
    (princ "\nHandle value does not exist in the drawing")
  )
  (princ)
)
 