import libclang

iterator children*(cursor: CXCursor): CXCursor =
  var nodes: ref seq[CXCursor]
  new nodes
  nodes[] = @[]

  proc visitor(cursor: CXCursor, parent: CXCursor,
               clientData: CXClientData): CXChildVisitResult {.cdecl.} =
    var nodes = cast[ref seq[CXCursor]](clientData)[]
    nodes.add(cursor)
    cast[ref seq[CXCursor]](clientData)[] = nodes
    return Continue

  doAssert visitChildren(cursor, visitor, cast[pointer](nodes)) == 0

  for n in nodes[]:
    yield n

proc loc*(cursor: CXCursor): tuple[filename: string, line, column, offset: uint] =
  ## Returns the location information of the cursor.
  let location = cursor.getCursorLocation()
  var file: CXFile
  var line, column, offset: cuint

  location.getFileLocation(addr file, addr line, addr column, addr offset)
  return ($getCString(file.getFilename()), line.uint, column.uint, offset.uint)