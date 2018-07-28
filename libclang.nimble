# Package

version = "0.1.0"
author  = "Dominik Picheta"
description = "libclang C wrapper"
license = "MIT"

srcDir = "src"

task gen, "Generate wrapper":
  # Location of Index.h found by running `mdfind -name Index.h | grep clang`
  # To get: /usr/local/Cellar/llvm/4.0.0/include/clang-c/Index.h
  assert defined(macosx)
  cpFile("/usr/local/Cellar/llvm/4.0.0/include/clang-c/Index.h",
         "src/Index.h")
  cpFile("/usr/local/Cellar/llvm/4.0.0/include/clang-c/CXString.h",
         "src/CXString.h")
  cpFile("/usr/local/Cellar/llvm/4.0.0/include/clang-c/CXErrorCode.h",
         "src/CXErrorCode.h")
  exec "patch src/Index.h src/Index.h.patch"
  exec "c2nim --out:src/libclang.nim --dynlib:libclang --cdecl --skipcomments --concat --prefix:clang_Module_ --prefix:clang_Location_ --prefix:CXAvailability_ --prefix:CXError_ --prefix:clang_CXXConstructor_ --prefix:clang_EvalResult_ --prefix:clang_remap_ --prefix:CXVisit_ --prefix:CXResult_ --prefix:CXIdxEntity_ --prefix:CXIdxEntityLang_ --prefix:CXIdxEntity_ --prefix:CXIdxAttr_ --prefix:CXIdxObjCContainer_ --prefix:CXIdxEntityRef_ --prefix:clang_index_ --prefix:CXIndexOpt_ --prefix:clang_indexLoc_ --prefix:clang_CXXField_ --prefix:clang_CXXMethod_ --prefix:clang_Type_ --prefix:clang_Cursor_ --prefix:clang_ --prefix:CXGlobalOpt_ --prefix:CXIndex_ --prefix:File_ --prefix:Location_ --prefix:Range_ --prefix:CXDiagnostic_ --prefix:CXLoadDiag_ --prefix:CXDiagnostic_  --prefix:CXSaveError_ --prefix:CXCursor_ --prefix:CXLinkage_ --prefix:CXVisibility_ --prefix:CXLanguage_ --prefix:CXCursorSet_ --prefix:CXType_ --prefix:CXCallingConv_  --prefix:CXTemplateArgumentKind_ --prefix:CXTypeLayoutError_ --prefix:CXRefQualifier_ --prefix:CXChildVisit_ --prefix:CXObjCPropertyAttr_ --prefix:CXObjCDeclQualifier_ --prefix:CXNameRange_ --prefix:CXToken_ --prefix:CXCompletionChunk_ --prefix:CXCompletionContext_ --prefix:CXEval_ src/CXErrorCode.h src/Index.h src/CXString.h"
  #cpFile("src/libclang.nim", "src/libclang.nim.orig")
  exec "patch src/libclang.nim src/libclang.nim.patch"
