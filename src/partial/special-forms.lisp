;;;; special-forms.lisp
;;;;
;;;; Copyright 2017 Alexander Gutev
;;;;
;;;; Permission is hereby granted, free of charge, to any person
;;;; obtaining a copy of this software and associated documentation
;;;; files (the "Software"), to deal in the Software without
;;;; restriction, including without limitation the rights to use,
;;;; copy, modify, merge, publish, distribute, sublicense, and/or sell
;;;; copies of the Software, and to permit persons to whom the
;;;; Software is furnished to do so, subject to the following
;;;; conditions:
;;;;
;;;; The above copyright notice and this permission notice shall be
;;;; included in all copies or substantial portions of the Software.
;;;;
;;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;;;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
;;;; OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;;;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
;;;; HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
;;;; WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
;;;; FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
;;;; OTHER DEALINGS IN THE SOFTWARE.

(in-package :cl-environments)


;;; FUNCTION

(defwalker cl:function (args)
  "If the body of the FUNCTION form is a lambda expression, it is
   walked as a function definition. Otherwise the form arguments are
   returned as is."

  (match args
    ((list (list* 'cl:lambda expr))
     (list (cons 'cl:lambda (walk-fn-def expr (get-environment *env*)))))
    
    (_ args)))


;;; LOCALLY

(defwalker cl:locally (args)
  "Encloses the body of the LOCALLY form in an environment, augmented
   with the declaration information."
  
  (walk-body args))


;;; CCL specific special forms

#+ccl
(defwalker ccl::nfunction (args)
  (match-form (name ('cl:lambda . _)) args
    (list name (second (walk-list-form 'function (cdr args))))))

#+ccl
(defwalker ccl::compiler-let (args)
  (match-form (bindings . body) args
    (cons bindings (enclose-forms body))))
