(delayed
  (lazy-keyboard-force)
  (kbd-map
    ("A-j" (kbd-down))
    ("A-k" (kbd-up))
    ("A-h" (kbd-left))
    ("A-l" (kbd-right))
    ("A-S-j" (do ((i 1 (1+ i)))
               ((> i 5))
               (kbd-up)))
    ("A-p" (kbd-paste))
    ("A-m" (insert (default-look-and-feel)))
    ("S-space" (kbd-right))
  )
)