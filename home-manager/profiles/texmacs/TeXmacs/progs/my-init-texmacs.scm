(load "vi-mode/default.scm")
(load "math/math-kbd.scm")
(load "generic/generic-kbd.scm")

(tm-define (tree-left)
  (tree-go-to
    (tree-ref (cursor-tree) :previous)
    :start
  )
)

(tm-define (tree-right)
  (tree-go-to
    (tree-ref (cursor-tree) :next)
    :end
  )
)


