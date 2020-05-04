upCounter rst enable = s
  where
    s = register 0 $ mux rst 0 next
    next = mux enable (s + 1) s

