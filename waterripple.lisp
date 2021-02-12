;;;; waterripple.lisp

(in-package #:waterripple)

(defparameter *width* 600)
(defparameter *height* 600)
(defparameter *scale-factor* 6)
(defparameter *s-width* (floor *width* *scale-factor*))
(defparameter *s-height* (floor *height* *scale-factor*))

(defparameter *current* (make-array (list
				*s-width*
				*s-height*) :initial-element 0))
(defparameter *previous* (make-array (list
				*s-width*
				*s-height*) :initial-element 0))
(defparameter *dampening* 0.75)

(defvar *cursor-position* (gamekit:vec2 0 0))

(gamekit:defgame waterripple ()
  ((game-state))
  (:viewport-width *width*)
  (:viewport-height *height*)
  (:viewport-title "Water Ripples"))

(defun start-game ()
  (gamekit:start 'waterripple))

(defmethod gamekit:post-initialize ((this waterripple))
  (gamekit:bind-cursor (lambda (x y)
                       (setf (gamekit:x *cursor-position*) x
                             (gamekit:y *cursor-position*) y)))
  (gamekit:bind-button :mouse-left :pressed
                     (lambda ()
                       (setf (aref *previous*
				   (floor (gamekit:x *cursor-position*) *scale-factor*)
				   (floor (gamekit:y *cursor-position*) *scale-factor*))
			     1.0))))

(defmethod gamekit:act ((this waterripple))
  (loop for y from 1 upto (- (array-dimension *current* 0) 2) do
    (loop for x from 1 upto (- (array-dimension *current* 1) 2) do
      (setf (aref *current* x y)
	    (*
	     (/
	      (+
	       (aref *previous* (1+ x) y)
	       (aref *previous* (1- x) y)
	       (aref *previous* x (1+ y))
	       (aref *previous* x (1- y)))
	      (- 2 (aref *current* x y)))
	     *dampening*)))))

(defmethod gamekit:draw ((this waterripple))
  (loop for y from 1 upto (- (array-dimension *current* 0) 2) do
    (loop for x from 1 upto (- (array-dimension *current* 1) 2) do
      (let ((xn (* x *scale-factor*))
	    (yn (* y *scale-factor*)))
	(gamekit:draw-rect (gamekit:vec2 xn yn) *scale-factor* *scale-factor*
			   :fill-paint (gamekit:vec4
					(aref *current* x y)
					(aref *current* x y)
					(aref *current* x y)
					1.0)))))
  (let ((aux *previous*))
    (setf *previous* *current*)
    (setf *current* aux)))
