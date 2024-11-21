(define-public vi-mode? #f)

(tm-define (enter-vi-mode)
  (set! vi-mode? #t)
)

(tm-define (exit-vi-mode)
  (set! vi-mode? #f)
)

(delayed
  (lazy-keyboard-force)
  (kbd-map
    (:require (not vi-mode?))
    ("escape" (enter-vi-mode))
  )
  (kbd-map
    (:require vi-mode?)
    ("i" (exit-vi-mode))
    ("I" (kbd-start-line) (exit-vi-mode))
    ("a" (kbd-right))
    ("A" (kbd-end-line) (exit-vi-mode))
    ("j" (kbd-down))
    ("k" (kbd-up))
    ("h" (kbd-left))
    ("l" (kbd-right))
    ("C-h" (kbd-start-line))
    ("C-l" (kbd-end-line))
    ("S-h" (tree-left))
    ("S-l" (tree-right))
    ("p" (kbd-paste))
  )
)
