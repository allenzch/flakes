(delayed
  (lazy-keyboard-force)

  (kbd-map
    (:mode in-math?)
    ("math f" (make 'wrapfrac))
    ("math:greek c" "<gamma>")
    ("math:greek C" "<Gamma>")
    ("math:greek q" "<varphi>")
    ("math:greek q var" "<phi>")
    ("math:greek Q" "<Phi>")
    ("math:greek x" "<chi>")
    ("math:greek X" "<Chi>")

    (". ." "<cdots>")
    (". ." "<ldots>")
    ("* var" "<times>")
    ("* var. ." "<times><cdots><times>")
    ("* var var" "<cdot>")
    ("* var var. ." "<cdot><cdots><cdot>")
    ("* var var var" "<ast>")
    ("* var var var . ." "<ast><cdots><ast>")

    ("' var" (make-rprime "<asterisk>"))
    ("' var var" (make-rprime "<dag>"))
    ("' var var var" (make-rprime "T"))
  )

  (kbd-map
    (:mode in-math-not-hybrid?)
    ("c var" "<gamma>")
    ("C var" "<Gamma>")
    ("q var" "<varphi>")
    ("q var var" "<phi>")
    ("Q var" "<Phi>")
    ("x var" "<chi>")
    ("X var" "<Chi>")
  )
)
