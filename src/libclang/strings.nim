import libclang
proc `$`*(s: CXString): string =
  $s.getCString()