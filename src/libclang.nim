from times import Time

{.deadCodeElim:on.}
when defined(windows):
  const
    libclang* = "libclang.dll"
elif defined(macosx):
  const 
    libclang* = "libclang.dylib"
else:
  const
    libclang* = "libclang(|-6.0).so(|.1)"

type
  CXErrorCode* {.size: sizeof(cint).} = enum
    Success = 0, Failure = 1, Crashed = 2, InvalidArguments = 3, ASTReadError = 4


const
  CINDEX_VERSION_MAJOR* = 0
  CINDEX_VERSION_MINOR* = 37

template CINDEX_VERSION_ENCODE*(major, minor: untyped): untyped =
  (((major) * 10000) + ((minor) * 1))

const
  CINDEX_VERSION* = CINDEX_VERSION_ENCODE(CINDEX_VERSION_MAJOR,
                                        CINDEX_VERSION_MINOR)


type
  CXString* = object
    data*: pointer
    private_flags*: cuint

  CXStringSet* = object
    Strings*: ptr CXString
    Count*: cuint


type
  CXIndex* = pointer


type
  CXTranslationUnit* = pointer


type
  CXClientData* = pointer


type
  CXUnsavedFile* = object
    Filename*: cstring
    Contents*: cstring
    Length*: culong



type
  CXAvailabilityKind* {.size: sizeof(cint).} = enum
    Available, Deprecated, NotAvailable, NotAccessible



type
  CXVersion* = object
    Major*: cint
    Minor*: cint
    Subminor*: cint



proc createIndex*(excludeDeclarationsFromPCH: cint; displayDiagnostics: cint): CXIndex {.
    cdecl, importc: "clang_createIndex", dynlib: libclang.}

proc disposeIndex*(index: CXIndex) {.cdecl, importc: "clang_disposeIndex",
                                  dynlib: libclang.}
type
  CXGlobalOptFlags* {.size: sizeof(cint).} = enum
    None = 0x00000000, ThreadBackgroundPriorityForIndexing = 0x00000001,
    ThreadBackgroundPriorityForEditing = 0x00000002,
    ThreadBackgroundPriorityForAll =
      ThreadBackgroundPriorityForIndexing.int or
      ThreadBackgroundPriorityForEditing.int



proc CXIndex_setGlobalOptions*(a2: CXIndex; options: cuint) {.cdecl,
    importc: "clang_CXIndex_setGlobalOptions", dynlib: libclang.}

proc CXIndex_getGlobalOptions*(a2: CXIndex): cuint {.cdecl,
    importc: "clang_CXIndex_getGlobalOptions", dynlib: libclang.}

type
  CXFile* = pointer



proc getFileTime*(SFile: CXFile): Time {.cdecl, importc: "clang_getFileTime",
                                       dynlib: libclang.}

type
  CXFileUniqueID* = object
    data*: array[3, culonglong]



proc getFileUniqueID*(file: CXFile; outID: ptr CXFileUniqueID): cint {.cdecl,
    importc: "clang_getFileUniqueID", dynlib: libclang.}

proc isFileMultipleIncludeGuarded*(tu: CXTranslationUnit; file: CXFile): cuint {.
    cdecl, importc: "clang_isFileMultipleIncludeGuarded", dynlib: libclang.}

proc getFile*(tu: CXTranslationUnit; file_name: cstring): CXFile {.cdecl,
    importc: "clang_getFile", dynlib: libclang.}

proc File_isEqual*(file1: CXFile; file2: CXFile): cint {.cdecl,
    importc: "clang_File_isEqual", dynlib: libclang.}

type
  CXSourceLocation* = object
    ptr_data*: array[2, pointer]
    int_data*: cuint



type
  CXSourceRange* = object
    ptr_data*: array[2, pointer]
    begin_int_data*: cuint
    end_int_data*: cuint



proc getNullLocation*(): CXSourceLocation {.cdecl, importc: "clang_getNullLocation",
    dynlib: libclang.}

proc equalLocations*(loc1: CXSourceLocation; loc2: CXSourceLocation): cuint {.cdecl,
    importc: "clang_equalLocations", dynlib: libclang.}

proc getLocation*(tu: CXTranslationUnit; file: CXFile; line: cuint; column: cuint): CXSourceLocation {.
    cdecl, importc: "clang_getLocation", dynlib: libclang.}

proc getLocationForOffset*(tu: CXTranslationUnit; file: CXFile; offset: cuint): CXSourceLocation {.
    cdecl, importc: "clang_getLocationForOffset", dynlib: libclang.}

proc isInSystemHeader*(location: CXSourceLocation): cint {.cdecl,
    importc: "clang_Location_isInSystemHeader", dynlib: libclang.}

proc isFromMainFile*(location: CXSourceLocation): cint {.cdecl,
    importc: "clang_Location_isFromMainFile", dynlib: libclang.}

proc getNullRange*(): CXSourceRange {.cdecl, importc: "clang_getNullRange",
                                   dynlib: libclang.}

proc getRange*(begin: CXSourceLocation; `end`: CXSourceLocation): CXSourceRange {.
    cdecl, importc: "clang_getRange", dynlib: libclang.}

proc equalRanges*(range1: CXSourceRange; range2: CXSourceRange): cuint {.cdecl,
    importc: "clang_equalRanges", dynlib: libclang.}

proc Range_isNull*(range: CXSourceRange): cint {.cdecl,
    importc: "clang_Range_isNull", dynlib: libclang.}

proc getExpansionLocation*(location: CXSourceLocation; file: ptr CXFile;
                          line: ptr cuint; column: ptr cuint; offset: ptr cuint) {.cdecl,
    importc: "clang_getExpansionLocation", dynlib: libclang.}

proc getInstantiationLocation*(location: CXSourceLocation; file: ptr CXFile;
                              line: ptr cuint; column: ptr cuint; offset: ptr cuint) {.
    cdecl, importc: "clang_getInstantiationLocation", dynlib: libclang.}

proc getSpellingLocation*(location: CXSourceLocation; file: ptr CXFile;
                         line: ptr cuint; column: ptr cuint; offset: ptr cuint) {.cdecl,
    importc: "clang_getSpellingLocation", dynlib: libclang.}

proc getFileLocation*(location: CXSourceLocation; file: ptr CXFile; line: ptr cuint;
                     column: ptr cuint; offset: ptr cuint) {.cdecl,
    importc: "clang_getFileLocation", dynlib: libclang.}

proc getRangeStart*(range: CXSourceRange): CXSourceLocation {.cdecl,
    importc: "clang_getRangeStart", dynlib: libclang.}

proc getRangeEnd*(range: CXSourceRange): CXSourceLocation {.cdecl,
    importc: "clang_getRangeEnd", dynlib: libclang.}

type
  CXSourceRangeList* = object
    count*: cuint
    ranges*: ptr CXSourceRange



proc getSkippedRanges*(tu: CXTranslationUnit; file: CXFile): ptr CXSourceRangeList {.
    cdecl, importc: "clang_getSkippedRanges", dynlib: libclang.}

proc getAllSkippedRanges*(tu: CXTranslationUnit): ptr CXSourceRangeList {.cdecl,
    importc: "clang_getAllSkippedRanges", dynlib: libclang.}

proc disposeSourceRangeList*(ranges: ptr CXSourceRangeList) {.cdecl,
    importc: "clang_disposeSourceRangeList", dynlib: libclang.}

type
  CXDiagnosticSeverity* {.size: sizeof(cint), pure.} = enum
    Ignored = 0, Note = 1, Warning = 2, Error = 3, Fatal = 4



type
  CXDiagnostic* = pointer


type
  CXDiagnosticSet* = pointer


proc getNumDiagnosticsInSet*(Diags: CXDiagnosticSet): cuint {.cdecl,
    importc: "clang_getNumDiagnosticsInSet", dynlib: libclang.}

proc getDiagnosticInSet*(Diags: CXDiagnosticSet; Index: cuint): CXDiagnostic {.cdecl,
    importc: "clang_getDiagnosticInSet", dynlib: libclang.}

type
  Error* {.size: sizeof(cint), pure.} = enum
    None = 0, Unknown = 1, CannotLoad = 2, InvalidFile = 3



proc loadDiagnostics*(file: cstring; error: ptr Error; errorString: ptr CXString): CXDiagnosticSet {.
    cdecl, importc: "clang_loadDiagnostics", dynlib: libclang.}

proc disposeDiagnosticSet*(Diags: CXDiagnosticSet) {.cdecl,
    importc: "clang_disposeDiagnosticSet", dynlib: libclang.}

proc getChildDiagnostics*(D: CXDiagnostic): CXDiagnosticSet {.cdecl,
    importc: "clang_getChildDiagnostics", dynlib: libclang.}

proc getNumDiagnostics*(Unit: CXTranslationUnit): cuint {.cdecl,
    importc: "clang_getNumDiagnostics", dynlib: libclang.}

proc getDiagnostic*(Unit: CXTranslationUnit; Index: cuint): CXDiagnostic {.cdecl,
    importc: "clang_getDiagnostic", dynlib: libclang.}

proc getDiagnosticSetFromTU*(Unit: CXTranslationUnit): CXDiagnosticSet {.cdecl,
    importc: "clang_getDiagnosticSetFromTU", dynlib: libclang.}

proc disposeDiagnostic*(Diagnostic: CXDiagnostic) {.cdecl,
    importc: "clang_disposeDiagnostic", dynlib: libclang.}

type
  CXDiagnosticDisplayOptions* {.size: sizeof(cint).} = enum
    DisplaySourceLocation = 0x00000001, DisplayColumn = 0x00000002,
    DisplaySourceRanges = 0x00000004, DisplayOption = 0x00000008,
    DisplayCategoryId = 0x00000010, DisplayCategoryName = 0x00000020



proc formatDiagnostic*(Diagnostic: CXDiagnostic; Options: cuint): CXString {.cdecl,
    importc: "clang_formatDiagnostic", dynlib: libclang.}

proc defaultDiagnosticDisplayOptions*(): cuint {.cdecl,
    importc: "clang_defaultDiagnosticDisplayOptions", dynlib: libclang.}

proc getDiagnosticSeverity*(a2: CXDiagnostic): CXDiagnosticSeverity {.cdecl,
    importc: "clang_getDiagnosticSeverity", dynlib: libclang.}

proc getDiagnosticLocation*(a2: CXDiagnostic): CXSourceLocation {.cdecl,
    importc: "clang_getDiagnosticLocation", dynlib: libclang.}

proc getDiagnosticSpelling*(a2: CXDiagnostic): CXString {.cdecl,
    importc: "clang_getDiagnosticSpelling", dynlib: libclang.}

proc getDiagnosticOption*(Diag: CXDiagnostic; Disable: ptr CXString): CXString {.cdecl,
    importc: "clang_getDiagnosticOption", dynlib: libclang.}

proc getDiagnosticCategory*(a2: CXDiagnostic): cuint {.cdecl,
    importc: "clang_getDiagnosticCategory", dynlib: libclang.}

proc getDiagnosticCategoryName*(Category: cuint): CXString {.cdecl,
    importc: "clang_getDiagnosticCategoryName", dynlib: libclang.}

proc getDiagnosticCategoryText*(a2: CXDiagnostic): CXString {.cdecl,
    importc: "clang_getDiagnosticCategoryText", dynlib: libclang.}

proc getDiagnosticNumRanges*(a2: CXDiagnostic): cuint {.cdecl,
    importc: "clang_getDiagnosticNumRanges", dynlib: libclang.}

proc getDiagnosticRange*(Diagnostic: CXDiagnostic; Range: cuint): CXSourceRange {.
    cdecl, importc: "clang_getDiagnosticRange", dynlib: libclang.}

proc getDiagnosticNumFixIts*(Diagnostic: CXDiagnostic): cuint {.cdecl,
    importc: "clang_getDiagnosticNumFixIts", dynlib: libclang.}

proc getDiagnosticFixIt*(Diagnostic: CXDiagnostic; FixIt: cuint;
                        ReplacementRange: ptr CXSourceRange): CXString {.cdecl,
    importc: "clang_getDiagnosticFixIt", dynlib: libclang.}

proc getTranslationUnitSpelling*(CTUnit: CXTranslationUnit): CXString {.cdecl,
    importc: "clang_getTranslationUnitSpelling", dynlib: libclang.}

proc createTranslationUnitFromSourceFile*(CIdx: CXIndex; source_filename: cstring;
    num_clang_command_line_args: cint; command_line_args: cstringArray;
    num_unsaved_files: cuint; unsaved_files: ptr CXUnsavedFile): CXTranslationUnit {.
    cdecl, importc: "clang_createTranslationUnitFromSourceFile", dynlib: libclang.}

proc createTranslationUnit*(CIdx: CXIndex; ast_filename: cstring): CXTranslationUnit {.
    cdecl, importc: "clang_createTranslationUnit", dynlib: libclang.}

proc createTranslationUnit2*(CIdx: CXIndex; ast_filename: cstring;
                            out_TU: ptr CXTranslationUnit): CXErrorCode {.cdecl,
    importc: "clang_createTranslationUnit2", dynlib: libclang.}

type
  CXTranslationUnit_Flags* {.size: sizeof(cint).} = enum
    CXTranslationUnit_None = 0x00000000,
    CXTranslationUnit_DetailedPreprocessingRecord = 0x00000001,
    CXTranslationUnit_Incomplete = 0x00000002,
    CXTranslationUnit_PrecompiledPreamble = 0x00000004,
    CXTranslationUnit_CacheCompletionResults = 0x00000008,
    CXTranslationUnit_ForSerialization = 0x00000010,
    CXTranslationUnit_CXXChainedPCH = 0x00000020,
    CXTranslationUnit_SkipFunctionBodies = 0x00000040,
    CXTranslationUnit_IncludeBriefCommentsInCodeCompletion = 0x00000080,
    CXTranslationUnit_CreatePreambleOnFirstParse = 0x00000100,
    CXTranslationUnit_KeepGoing = 0x00000200



proc defaultEditingTranslationUnitOptions*(): cuint {.cdecl,
    importc: "clang_defaultEditingTranslationUnitOptions", dynlib: libclang.}

proc parseTranslationUnit*(CIdx: CXIndex; source_filename: cstring;
                          command_line_args: cstringArray;
                          num_command_line_args: cint;
                          unsaved_files: ptr CXUnsavedFile;
                          num_unsaved_files: cuint; options: cuint): CXTranslationUnit {.
    cdecl, importc: "clang_parseTranslationUnit", dynlib: libclang.}

proc parseTranslationUnit2*(CIdx: CXIndex; source_filename: cstring;
                           command_line_args: cstringArray;
                           num_command_line_args: cint;
                           unsaved_files: ptr CXUnsavedFile;
                           num_unsaved_files: cuint; options: cuint;
                           out_TU: ptr CXTranslationUnit): CXErrorCode {.cdecl,
    importc: "clang_parseTranslationUnit2", dynlib: libclang.}

proc parseTranslationUnit2FullArgv*(CIdx: CXIndex; source_filename: cstring;
                                   command_line_args: cstringArray;
                                   num_command_line_args: cint;
                                   unsaved_files: ptr CXUnsavedFile;
                                   num_unsaved_files: cuint; options: cuint;
                                   out_TU: ptr CXTranslationUnit): CXErrorCode {.
    cdecl, importc: "clang_parseTranslationUnit2FullArgv", dynlib: libclang.}

type
  CXSaveTranslationUnit_Flags* {.size: sizeof(cint).} = enum
    CXSaveTranslationUnit_None = 0x00000000



proc defaultSaveOptions*(TU: CXTranslationUnit): cuint {.cdecl,
    importc: "clang_defaultSaveOptions", dynlib: libclang.}

type
  CXSaveError* {.size: sizeof(cint), pure.} = enum
    None = 0, Unknown = 1, TranslationErrors = 2, InvalidTU = 3



proc saveTranslationUnit*(TU: CXTranslationUnit; FileName: cstring; options: cuint): cint {.
    cdecl, importc: "clang_saveTranslationUnit", dynlib: libclang.}

proc disposeTranslationUnit*(a2: CXTranslationUnit) {.cdecl,
    importc: "clang_disposeTranslationUnit", dynlib: libclang.}

type
  CXReparse_Flags* {.size: sizeof(cint).} = enum
    CXReparse_None = 0x00000000



proc defaultReparseOptions*(TU: CXTranslationUnit): cuint {.cdecl,
    importc: "clang_defaultReparseOptions", dynlib: libclang.}

proc reparseTranslationUnit*(TU: CXTranslationUnit; num_unsaved_files: cuint;
                            unsaved_files: ptr CXUnsavedFile; options: cuint): cint {.
    cdecl, importc: "clang_reparseTranslationUnit", dynlib: libclang.}

type
  CXTUResourceUsageKind* {.size: sizeof(cint).} = enum
    CXTUResourceUsage_AST = 1, CXTUResourceUsage_Identifiers = 2,
    CXTUResourceUsage_Selectors = 3, CXTUResourceUsage_GlobalCompletionResults = 4,
    CXTUResourceUsage_SourceManagerContentCache = 5,
    CXTUResourceUsage_AST_SideTables = 6,
    CXTUResourceUsage_SourceManager_Membuffer_Malloc = 7,
    CXTUResourceUsage_SourceManager_Membuffer_MMap = 8,
    CXTUResourceUsage_ExternalASTSource_Membuffer_Malloc = 9,
    CXTUResourceUsage_ExternalASTSource_Membuffer_MMap = 10,
    CXTUResourceUsage_Preprocessor = 11,
    CXTUResourceUsage_PreprocessingRecord = 12,
    CXTUResourceUsage_SourceManager_DataStructures = 13,
    CXTUResourceUsage_Preprocessor_HeaderSearch = 14

const
  CXTUResourceUsage_MEMORY_IN_BYTES_BEGIN = CXTUResourceUsage_AST
  CXTUResourceUsage_MEMORY_IN_BYTES_END = CXTUResourceUsage_Preprocessor_HeaderSearch
  CXTUResourceUsage_First = CXTUResourceUsage_AST
  CXTUResourceUsage_Last = CXTUResourceUsage_Preprocessor_HeaderSearch


proc getTUResourceUsageName*(kind: CXTUResourceUsageKind): cstring {.cdecl,
    importc: "clang_getTUResourceUsageName", dynlib: libclang.}
type
  CXTUResourceUsageEntry* = object
    kind*: CXTUResourceUsageKind
    amount*: culong



type
  CXTUResourceUsage* = object
    data*: pointer
    numEntries*: cuint
    entries*: ptr CXTUResourceUsageEntry



proc getCXTUResourceUsage*(TU: CXTranslationUnit): CXTUResourceUsage {.cdecl,
    importc: "clang_getCXTUResourceUsage", dynlib: libclang.}
proc disposeCXTUResourceUsage*(usage: CXTUResourceUsage) {.cdecl,
    importc: "clang_disposeCXTUResourceUsage", dynlib: libclang.}

type
  CXCursorKind* {.size: sizeof(cint).} = enum
    Empty = 0,
      ## Added to allow this enum to be used in an object variant. Also
      ## using this node kind for non-existant nodes in place of `nil`.
    UnexposedDecl = 1, StructDecl = 2, UnionDecl = 3, ClassDecl = 4, EnumDecl = 5,
    FieldDecl = 6, EnumConstantDecl = 7, FunctionDecl = 8, VarDecl = 9, ParmDecl = 10,
    ObjCInterfaceDecl = 11, ObjCCategoryDecl = 12, ObjCProtocolDecl = 13,
    ObjCPropertyDecl = 14, ObjCIvarDecl = 15, ObjCInstanceMethodDecl = 16,
    ObjCClassMethodDecl = 17, ObjCImplementationDecl = 18, ObjCCategoryImplDecl = 19,
    TypedefDecl = 20, CXXMethod = 21, Namespace = 22, LinkageSpec = 23, Constructor = 24,
    Destructor = 25, ConversionFunction = 26, TemplateTypeParameter = 27,
    NonTypeTemplateParameter = 28, TemplateTemplateParameter = 29,
    FunctionTemplate = 30, ClassTemplate = 31,
    ClassTemplatePartialSpecialization = 32, NamespaceAlias = 33, UsingDirective = 34,
    UsingDeclaration = 35, TypeAliasDecl = 36, ObjCSynthesizeDecl = 37,
    ObjCDynamicDecl = 38, CXXAccessSpecifier = 39, FirstRef = 40, ObjCProtocolRef = 41,
    ObjCClassRef = 42, TypeRef = 43, CXXBaseSpecifier = 44, TemplateRef = 45,
    NamespaceRef = 46, MemberRef = 47, LabelRef = 48, OverloadedDeclRef = 49,
    VariableRef = 50, FirstInvalid = 70, NoDeclFound = 71, NotImplemented = 72,
    InvalidCode = 73, FirstExpr = 100, DeclRefExpr = 101, MemberRefExpr = 102,
    CallExpr = 103, ObjCMessageExpr = 104, BlockExpr = 105, IntegerLiteral = 106,
    FloatingLiteral = 107, ImaginaryLiteral = 108, StringLiteral = 109,
    CharacterLiteral = 110, ParenExpr = 111, UnaryOperator = 112,
    ArraySubscriptExpr = 113, BinaryOperator = 114, CompoundAssignOperator = 115,
    ConditionalOperator = 116, CStyleCastExpr = 117, CompoundLiteralExpr = 118,
    InitListExpr = 119, AddrLabelExpr = 120, StmtExpr = 121, GenericSelectionExpr = 122,
    GNUNullExpr = 123, CXXStaticCastExpr = 124, CXXDynamicCastExpr = 125,
    CXXReinterpretCastExpr = 126, CXXConstCastExpr = 127, CXXFunctionalCastExpr = 128,
    CXXTypeidExpr = 129, CXXBoolLiteralExpr = 130, CXXNullPtrLiteralExpr = 131,
    CXXThisExpr = 132, CXXThrowExpr = 133, CXXNewExpr = 134, CXXDeleteExpr = 135,
    UnaryExpr = 136, ObjCStringLiteral = 137, ObjCEncodeExpr = 138,
    ObjCSelectorExpr = 139, ObjCProtocolExpr = 140, ObjCBridgedCastExpr = 141,
    PackExpansionExpr = 142, SizeOfPackExpr = 143, LambdaExpr = 144,
    ObjCBoolLiteralExpr = 145, ObjCSelfExpr = 146, OMPArraySectionExpr = 147,
    ObjCAvailabilityCheckExpr = 148, FirstStmt = 200, LabelStmt = 201,
    CompoundStmt = 202, CaseStmt = 203, DefaultStmt = 204, IfStmt = 205, SwitchStmt = 206,
    WhileStmt = 207, DoStmt = 208, ForStmt = 209, GotoStmt = 210, IndirectGotoStmt = 211,
    ContinueStmt = 212, BreakStmt = 213, ReturnStmt = 214, GCCAsmStmt = 215,
    ObjCAtTryStmt = 216, ObjCAtCatchStmt = 217, ObjCAtFinallyStmt = 218,
    ObjCAtThrowStmt = 219, ObjCAtSynchronizedStmt = 220,
    ObjCAutoreleasePoolStmt = 221, ObjCForCollectionStmt = 222, CXXCatchStmt = 223,
    CXXTryStmt = 224, CXXForRangeStmt = 225, SEHTryStmt = 226, SEHExceptStmt = 227,
    SEHFinallyStmt = 228, MSAsmStmt = 229, NullStmt = 230, DeclStmt = 231,
    OMPParallelDirective = 232, OMPSimdDirective = 233, OMPForDirective = 234,
    OMPSectionsDirective = 235, OMPSectionDirective = 236, OMPSingleDirective = 237,
    OMPParallelForDirective = 238, OMPParallelSectionsDirective = 239,
    OMPTaskDirective = 240, OMPMasterDirective = 241, OMPCriticalDirective = 242,
    OMPTaskyieldDirective = 243, OMPBarrierDirective = 244,
    OMPTaskwaitDirective = 245, OMPFlushDirective = 246, SEHLeaveStmt = 247,
    OMPOrderedDirective = 248, OMPAtomicDirective = 249, OMPForSimdDirective = 250,
    OMPParallelForSimdDirective = 251, OMPTargetDirective = 252,
    OMPTeamsDirective = 253, OMPTaskgroupDirective = 254,
    OMPCancellationPointDirective = 255, OMPCancelDirective = 256,
    OMPTargetDataDirective = 257, OMPTaskLoopDirective = 258,
    OMPTaskLoopSimdDirective = 259, OMPDistributeDirective = 260,
    OMPTargetEnterDataDirective = 261, OMPTargetExitDataDirective = 262,
    OMPTargetParallelDirective = 263, OMPTargetParallelForDirective = 264,
    OMPTargetUpdateDirective = 265, OMPDistributeParallelForDirective = 266,
    OMPDistributeParallelForSimdDirective = 267, OMPDistributeSimdDirective = 268,
    OMPTargetParallelForSimdDirective = 269, OMPTargetSimdDirective = 270,
    OMPTeamsDistributeDirective = 271, OMPTeamsDistributeSimdDirective = 272,
    OMPTeamsDistributeParallelForSimdDirective = 273,
    OMPTeamsDistributeParallelForDirective = 274, OMPTargetTeamsDirective = 275,
    OMPTargetTeamsDistributeDirective = 276,
    OMPTargetTeamsDistributeParallelForDirective = 277,
    OMPTargetTeamsDistributeParallelForSimdDirective = 278,
    OMPTargetTeamsDistributeSimdDirective = 279, TranslationUnit = 300,
    FirstAttr = 400, IBActionAttr = 401, IBOutletAttr = 402,
    IBOutletCollectionAttr = 403, CXXFinalAttr = 404, CXXOverrideAttr = 405,
    AnnotateAttr = 406, AsmLabelAttr = 407, PackedAttr = 408, PureAttr = 409,
    ConstAttr = 410, NoDuplicateAttr = 411, CUDAConstantAttr = 412, CUDADeviceAttr = 413,
    CUDAGlobalAttr = 414, CUDAHostAttr = 415, CUDASharedAttr = 416, VisibilityAttr = 417,
    DLLExport = 418, DLLImport = 419, PreprocessingDirective = 500,
    MacroDefinition = 501, MacroExpansion = 502, InclusionDirective = 503,
    ModuleImportDecl = 600, TypeAliasTemplateDecl = 601, StaticAssert = 602,
    FriendDecl = 603, OverloadCandidate = 700

const
  FirstDecl = UnexposedDecl
  LastDecl = CXXAccessSpecifier
  ObjCSuperClassRef = FirstRef
  LastRef = VariableRef
  InvalidFile = FirstInvalid
  LastInvalid = InvalidCode
  UnexposedExpr = FirstExpr
  LastExpr = ObjCAvailabilityCheckExpr
  UnexposedStmt = FirstStmt
  AsmStmt = GCCAsmStmt
  LastStmt = OMPTargetTeamsDistributeSimdDirective
  UnexposedAttr = FirstAttr
  LastAttr = DLLImport
  MacroInstantiation = MacroExpansion
  FirstPreprocessing = PreprocessingDirective
  LastPreprocessing = InclusionDirective
  FirstExtraDecl = ModuleImportDecl
  LastExtraDecl = FriendDecl


type
  CXCursor* {.pure, bycopy.} = object
    kind*: CXCursorKind
    xdata*: cint
    data*: array[3, pointer]



proc getNullCursor*(): CXCursor {.cdecl, importc: "clang_getNullCursor",
                               dynlib: libclang.}

proc getTranslationUnitCursor*(a2: CXTranslationUnit): CXCursor {.cdecl,
    importc: "clang_getTranslationUnitCursor", dynlib: libclang.}

proc equalCursors*(a2: CXCursor; a3: CXCursor): cuint {.cdecl,
    importc: "clang_equalCursors", dynlib: libclang.}

proc isNull*(cursor: CXCursor): cint {.cdecl, importc: "clang_Cursor_isNull",
                                   dynlib: libclang.}

proc hashCursor*(a2: CXCursor): cuint {.cdecl, importc: "clang_hashCursor",
                                    dynlib: libclang.}

proc getCursorKind*(a2: CXCursor): CXCursorKind {.cdecl,
    importc: "clang_getCursorKind", dynlib: libclang.}

proc isDeclaration*(a2: CXCursorKind): cuint {.cdecl, importc: "clang_isDeclaration",
    dynlib: libclang.}

proc isReference*(a2: CXCursorKind): cuint {.cdecl, importc: "clang_isReference",
    dynlib: libclang.}

proc isExpression*(a2: CXCursorKind): cuint {.cdecl, importc: "clang_isExpression",
    dynlib: libclang.}

proc isStatement*(a2: CXCursorKind): cuint {.cdecl, importc: "clang_isStatement",
    dynlib: libclang.}

proc isAttribute*(a2: CXCursorKind): cuint {.cdecl, importc: "clang_isAttribute",
    dynlib: libclang.}

proc hasAttrs*(C: CXCursor): cuint {.cdecl, importc: "clang_Cursor_hasAttrs",
                                 dynlib: libclang.}

proc isInvalid*(a2: CXCursorKind): cuint {.cdecl, importc: "clang_isInvalid",
                                       dynlib: libclang.}

proc isTranslationUnit*(a2: CXCursorKind): cuint {.cdecl,
    importc: "clang_isTranslationUnit", dynlib: libclang.}

proc isPreprocessing*(a2: CXCursorKind): cuint {.cdecl,
    importc: "clang_isPreprocessing", dynlib: libclang.}

proc isUnexposed*(a2: CXCursorKind): cuint {.cdecl, importc: "clang_isUnexposed",
    dynlib: libclang.}

type
  CXLinkageKind* {.size: sizeof(cint).} = enum
    Invalid, NoLinkage, Internal, UniqueExternal, External



proc getCursorLinkage*(cursor: CXCursor): CXLinkageKind {.cdecl,
    importc: "clang_getCursorLinkage", dynlib: libclang.}
type
  CXVisibilityKind* {.size: sizeof(cint), pure.} = enum
    Invalid, Hidden, Protected, Default



proc getCursorVisibility*(cursor: CXCursor): CXVisibilityKind {.cdecl,
    importc: "clang_getCursorVisibility", dynlib: libclang.}

proc getCursorAvailability*(cursor: CXCursor): CXAvailabilityKind {.cdecl,
    importc: "clang_getCursorAvailability", dynlib: libclang.}

type
  CXPlatformAvailability* = object
    Platform*: CXString
    Introduced*: CXVersion
    Deprecated*: CXVersion
    Obsoleted*: CXVersion
    Unavailable*: cint
    Message*: CXString



proc getCursorPlatformAvailability*(cursor: CXCursor; always_deprecated: ptr cint;
                                   deprecated_message: ptr CXString;
                                   always_unavailable: ptr cint;
                                   unavailable_message: ptr CXString;
                                   availability: ptr CXPlatformAvailability;
                                   availability_size: cint): cint {.cdecl,
    importc: "clang_getCursorPlatformAvailability", dynlib: libclang.}

proc disposeCXPlatformAvailability*(availability: ptr CXPlatformAvailability) {.
    cdecl, importc: "clang_disposeCXPlatformAvailability", dynlib: libclang.}

type
  CXLanguageKind* {.size: sizeof(cint), pure.} = enum
    Invalid = 0, C, ObjC, CPlusPlus



proc getCursorLanguage*(cursor: CXCursor): CXLanguageKind {.cdecl,
    importc: "clang_getCursorLanguage", dynlib: libclang.}

proc getTranslationUnit*(a2: CXCursor): CXTranslationUnit {.cdecl,
    importc: "clang_Cursor_getTranslationUnit", dynlib: libclang.}

type
  CXCursorSet* = pointer


proc createCXCursorSet*(): CXCursorSet {.cdecl, importc: "clang_createCXCursorSet",
                                      dynlib: libclang.}

proc disposeCXCursorSet*(cset: CXCursorSet) {.cdecl,
    importc: "clang_disposeCXCursorSet", dynlib: libclang.}

proc CXCursorSet_contains*(cset: CXCursorSet; cursor: CXCursor): cuint {.cdecl,
    importc: "clang_CXCursorSet_contains", dynlib: libclang.}

proc CXCursorSet_insert*(cset: CXCursorSet; cursor: CXCursor): cuint {.cdecl,
    importc: "clang_CXCursorSet_insert", dynlib: libclang.}

proc getCursorSemanticParent*(cursor: CXCursor): CXCursor {.cdecl,
    importc: "clang_getCursorSemanticParent", dynlib: libclang.}

proc getCursorLexicalParent*(cursor: CXCursor): CXCursor {.cdecl,
    importc: "clang_getCursorLexicalParent", dynlib: libclang.}

proc getOverriddenCursors*(cursor: CXCursor; overridden: ptr ptr CXCursor;
                          num_overridden: ptr cuint) {.cdecl,
    importc: "clang_getOverriddenCursors", dynlib: libclang.}

proc disposeOverriddenCursors*(overridden: ptr CXCursor) {.cdecl,
    importc: "clang_disposeOverriddenCursors", dynlib: libclang.}

proc getIncludedFile*(cursor: CXCursor): CXFile {.cdecl,
    importc: "clang_getIncludedFile", dynlib: libclang.}

proc getCursor*(a2: CXTranslationUnit; a3: CXSourceLocation): CXCursor {.cdecl,
    importc: "clang_getCursor", dynlib: libclang.}

proc getCursorLocation*(a2: CXCursor): CXSourceLocation {.cdecl,
    importc: "clang_getCursorLocation", dynlib: libclang.}

proc getCursorExtent*(a2: CXCursor): CXSourceRange {.cdecl,
    importc: "clang_getCursorExtent", dynlib: libclang.}

type
  CXTypeKind* {.size: sizeof(cint), pure.} = enum
    Invalid = 0, Unexposed = 1, Void = 2, Bool = 3, Char_U = 4, UChar = 5, Char16 = 6, Char32 = 7,
    UShort = 8, UInt = 9, ULong = 10, ULongLong = 11, UInt128 = 12, Char_S = 13, SChar = 14,
    WChar = 15, Short = 16, Int = 17, Long = 18, LongLong = 19, Int128 = 20, Float = 21, Double = 22,
    LongDouble = 23, NullPtr = 24, Overload = 25, Dependent = 26, ObjCId = 27, ObjCClass = 28,
    ObjCSel = 29, Float128 = 30, Complex = 100, Pointer = 101, BlockPointer = 102,
    LValueReference = 103, RValueReference = 104, Record = 105, Enum = 106, Typedef = 107,
    ObjCInterface = 108, ObjCObjectPointer = 109, FunctionNoProto = 110,
    FunctionProto = 111, ConstantArray = 112, Vector = 113, IncompleteArray = 114,
    VariableArray = 115, DependentSizedArray = 116, MemberPointer = 117, Auto = 118,
    Elaborated = 119

const
  FirstBuiltin = Void
  LastBuiltin = ObjCSel


type
  CXCallingConv* {.size: sizeof(cint), pure.} = enum
    Default = 0, C = 1, X86StdCall = 2, X86FastCall = 3, X86ThisCall = 4, X86Pascal = 5,
    AAPCS = 6, AAPCS_VFP = 7, X86RegCall = 8, IntelOclBicc = 9, X86_64Win64 = 10,
    X86_64SysV = 11, X86VectorCall = 12, Swift = 13, PreserveMost = 14, PreserveAll = 15,
    Invalid = 100, Unexposed = 200



type
  CXType* = object
    kind*: CXTypeKind
    data*: array[2, pointer]



proc getCursorType*(C: CXCursor): CXType {.cdecl, importc: "clang_getCursorType",
                                       dynlib: libclang.}

proc getTypeSpelling*(CT: CXType): CXString {.cdecl,
    importc: "clang_getTypeSpelling", dynlib: libclang.}

proc getTypedefDeclUnderlyingType*(C: CXCursor): CXType {.cdecl,
    importc: "clang_getTypedefDeclUnderlyingType", dynlib: libclang.}

proc getEnumDeclIntegerType*(C: CXCursor): CXType {.cdecl,
    importc: "clang_getEnumDeclIntegerType", dynlib: libclang.}

proc getEnumConstantDeclValue*(C: CXCursor): clonglong {.cdecl,
    importc: "clang_getEnumConstantDeclValue", dynlib: libclang.}

proc getEnumConstantDeclUnsignedValue*(C: CXCursor): culonglong {.cdecl,
    importc: "clang_getEnumConstantDeclUnsignedValue", dynlib: libclang.}

proc getFieldDeclBitWidth*(C: CXCursor): cint {.cdecl,
    importc: "clang_getFieldDeclBitWidth", dynlib: libclang.}

proc getNumArguments*(C: CXCursor): cint {.cdecl,
                                       importc: "clang_Cursor_getNumArguments",
                                       dynlib: libclang.}

proc getArgument*(C: CXCursor; i: cuint): CXCursor {.cdecl,
    importc: "clang_Cursor_getArgument", dynlib: libclang.}

type
  CXTemplateArgumentKind* {.size: sizeof(cint), pure.} = enum
    Null, Type, Declaration, NullPtr, Integral, Template, TemplateExpansion,
    Expression, Pack, Invalid



proc getNumTemplateArguments*(C: CXCursor): cint {.cdecl,
    importc: "clang_Cursor_getNumTemplateArguments", dynlib: libclang.}

proc getTemplateArgumentKind*(C: CXCursor; I: cuint): CXTemplateArgumentKind {.cdecl,
    importc: "clang_Cursor_getTemplateArgumentKind", dynlib: libclang.}

proc getTemplateArgumentType*(C: CXCursor; I: cuint): CXType {.cdecl,
    importc: "clang_Cursor_getTemplateArgumentType", dynlib: libclang.}

proc getTemplateArgumentValue*(C: CXCursor; I: cuint): clonglong {.cdecl,
    importc: "clang_Cursor_getTemplateArgumentValue", dynlib: libclang.}

proc getTemplateArgumentUnsignedValue*(C: CXCursor; I: cuint): culonglong {.cdecl,
    importc: "clang_Cursor_getTemplateArgumentUnsignedValue", dynlib: libclang.}

proc equalTypes*(A: CXType; B: CXType): cuint {.cdecl, importc: "clang_equalTypes",
    dynlib: libclang.}

proc getCanonicalType*(T: CXType): CXType {.cdecl, importc: "clang_getCanonicalType",
                                        dynlib: libclang.}

proc isConstQualifiedType*(T: CXType): cuint {.cdecl,
    importc: "clang_isConstQualifiedType", dynlib: libclang.}

proc isMacroFunctionLike*(C: CXCursor): cuint {.cdecl,
    importc: "clang_Cursor_isMacroFunctionLike", dynlib: libclang.}

proc isMacroBuiltin*(C: CXCursor): cuint {.cdecl,
                                       importc: "clang_Cursor_isMacroBuiltin",
                                       dynlib: libclang.}

proc isFunctionInlined*(C: CXCursor): cuint {.cdecl,
    importc: "clang_Cursor_isFunctionInlined", dynlib: libclang.}

proc isVolatileQualifiedType*(T: CXType): cuint {.cdecl,
    importc: "clang_isVolatileQualifiedType", dynlib: libclang.}

proc isRestrictQualifiedType*(T: CXType): cuint {.cdecl,
    importc: "clang_isRestrictQualifiedType", dynlib: libclang.}

proc getPointeeType*(T: CXType): CXType {.cdecl, importc: "clang_getPointeeType",
                                      dynlib: libclang.}

proc getTypeDeclaration*(T: CXType): CXCursor {.cdecl,
    importc: "clang_getTypeDeclaration", dynlib: libclang.}

proc getDeclObjCTypeEncoding*(C: CXCursor): CXString {.cdecl,
    importc: "clang_getDeclObjCTypeEncoding", dynlib: libclang.}

proc getObjCEncoding*(`type`: CXType): CXString {.cdecl,
    importc: "clang_Type_getObjCEncoding", dynlib: libclang.}

proc getTypeKindSpelling*(K: CXTypeKind): CXString {.cdecl,
    importc: "clang_getTypeKindSpelling", dynlib: libclang.}

proc getFunctionTypeCallingConv*(T: CXType): CXCallingConv {.cdecl,
    importc: "clang_getFunctionTypeCallingConv", dynlib: libclang.}

proc getResultType*(T: CXType): CXType {.cdecl, importc: "clang_getResultType",
                                     dynlib: libclang.}

proc getNumArgTypes*(T: CXType): cint {.cdecl, importc: "clang_getNumArgTypes",
                                    dynlib: libclang.}

proc getArgType*(T: CXType; i: cuint): CXType {.cdecl, importc: "clang_getArgType",
    dynlib: libclang.}

proc isFunctionTypeVariadic*(T: CXType): cuint {.cdecl,
    importc: "clang_isFunctionTypeVariadic", dynlib: libclang.}

proc getCursorResultType*(C: CXCursor): CXType {.cdecl,
    importc: "clang_getCursorResultType", dynlib: libclang.}

proc isPODType*(T: CXType): cuint {.cdecl, importc: "clang_isPODType", dynlib: libclang.}

proc getElementType*(T: CXType): CXType {.cdecl, importc: "clang_getElementType",
                                      dynlib: libclang.}

proc getNumElements*(T: CXType): clonglong {.cdecl, importc: "clang_getNumElements",
    dynlib: libclang.}

proc getArrayElementType*(T: CXType): CXType {.cdecl,
    importc: "clang_getArrayElementType", dynlib: libclang.}

proc getArraySize*(T: CXType): clonglong {.cdecl, importc: "clang_getArraySize",
                                       dynlib: libclang.}

proc getNamedType*(T: CXType): CXType {.cdecl, importc: "clang_Type_getNamedType",
                                    dynlib: libclang.}

type
  CXTypeLayoutError* {.size: sizeof(cint), pure.} = enum
    InvalidFieldName = - 5, NotConstantSize = - 4, Dependent = - 3, Incomplete = - 2,
    Invalid = - 1



proc getAlignOf*(T: CXType): clonglong {.cdecl, importc: "clang_Type_getAlignOf",
                                     dynlib: libclang.}

proc getClassType*(T: CXType): CXType {.cdecl, importc: "clang_Type_getClassType",
                                    dynlib: libclang.}

proc getSizeOf*(T: CXType): clonglong {.cdecl, importc: "clang_Type_getSizeOf",
                                    dynlib: libclang.}

proc getOffsetOf*(T: CXType; S: cstring): clonglong {.cdecl,
    importc: "clang_Type_getOffsetOf", dynlib: libclang.}

proc getOffsetOfField*(C: CXCursor): clonglong {.cdecl,
    importc: "clang_Cursor_getOffsetOfField", dynlib: libclang.}

proc isAnonymous*(C: CXCursor): cuint {.cdecl, importc: "clang_Cursor_isAnonymous",
                                    dynlib: libclang.}
type
  CXRefQualifierKind* {.size: sizeof(cint), pure.} = enum
    None = 0, LValue, RValue



proc getNumTemplateArguments*(T: CXType): cint {.cdecl,
    importc: "clang_Type_getNumTemplateArguments", dynlib: libclang.}

proc getTemplateArgumentAsType*(T: CXType; i: cuint): CXType {.cdecl,
    importc: "clang_Type_getTemplateArgumentAsType", dynlib: libclang.}

proc getCXXRefQualifier*(T: CXType): CXRefQualifierKind {.cdecl,
    importc: "clang_Type_getCXXRefQualifier", dynlib: libclang.}

proc isBitField*(C: CXCursor): cuint {.cdecl, importc: "clang_Cursor_isBitField",
                                   dynlib: libclang.}

proc isVirtualBase*(a2: CXCursor): cuint {.cdecl, importc: "clang_isVirtualBase",
                                       dynlib: libclang.}

type
  CX_CXXAccessSpecifier* {.size: sizeof(cint).} = enum
    CX_CXXInvalidAccessSpecifier, CX_CXXPublic, CX_CXXProtected, CX_CXXPrivate



proc getCXXAccessSpecifier*(a2: CXCursor): CX_CXXAccessSpecifier {.cdecl,
    importc: "clang_getCXXAccessSpecifier", dynlib: libclang.}

type
  CX_StorageClass* {.size: sizeof(cint).} = enum
    CX_SC_Invalid, CX_SC_None, CX_SC_Extern, CX_SC_Static, CX_SC_PrivateExtern,
    CX_SC_OpenCLWorkGroupLocal, CX_SC_Auto, CX_SC_Register



proc getStorageClass*(a2: CXCursor): CX_StorageClass {.cdecl,
    importc: "clang_Cursor_getStorageClass", dynlib: libclang.}

proc getNumOverloadedDecls*(cursor: CXCursor): cuint {.cdecl,
    importc: "clang_getNumOverloadedDecls", dynlib: libclang.}

proc getOverloadedDecl*(cursor: CXCursor; index: cuint): CXCursor {.cdecl,
    importc: "clang_getOverloadedDecl", dynlib: libclang.}

proc getIBOutletCollectionType*(a2: CXCursor): CXType {.cdecl,
    importc: "clang_getIBOutletCollectionType", dynlib: libclang.}

type
  CXChildVisitResult* {.size: sizeof(cint).} = enum
    Break, Continue, Recurse



type
  CXCursorVisitor* = proc (cursor: CXCursor; parent: CXCursor;
                        client_data: CXClientData): CXChildVisitResult {.cdecl.}



proc visitChildren*(parent: CXCursor; visitor: CXCursorVisitor;
                   client_data: CXClientData): cuint {.cdecl,
    importc: "clang_visitChildren", dynlib: libclang.}

proc getCursorUSR*(a2: CXCursor): CXString {.cdecl, importc: "clang_getCursorUSR",
    dynlib: libclang.}

proc constructUSR_ObjCClass*(class_name: cstring): CXString {.cdecl,
    importc: "clang_constructUSR_ObjCClass", dynlib: libclang.}

proc constructUSR_ObjCCategory*(class_name: cstring; category_name: cstring): CXString {.
    cdecl, importc: "clang_constructUSR_ObjCCategory", dynlib: libclang.}

proc constructUSR_ObjCProtocol*(protocol_name: cstring): CXString {.cdecl,
    importc: "clang_constructUSR_ObjCProtocol", dynlib: libclang.}

proc constructUSR_ObjCIvar*(name: cstring; classUSR: CXString): CXString {.cdecl,
    importc: "clang_constructUSR_ObjCIvar", dynlib: libclang.}

proc constructUSR_ObjCMethod*(name: cstring; isInstanceMethod: cuint;
                             classUSR: CXString): CXString {.cdecl,
    importc: "clang_constructUSR_ObjCMethod", dynlib: libclang.}

proc constructUSR_ObjCProperty*(property: cstring; classUSR: CXString): CXString {.
    cdecl, importc: "clang_constructUSR_ObjCProperty", dynlib: libclang.}

proc getCursorSpelling*(a2: CXCursor): CXString {.cdecl,
    importc: "clang_getCursorSpelling", dynlib: libclang.}

proc getSpellingNameRange*(a2: CXCursor; pieceIndex: cuint; options: cuint): CXSourceRange {.
    cdecl, importc: "clang_Cursor_getSpellingNameRange", dynlib: libclang.}

proc getCursorDisplayName*(a2: CXCursor): CXString {.cdecl,
    importc: "clang_getCursorDisplayName", dynlib: libclang.}

proc getCursorReferenced*(a2: CXCursor): CXCursor {.cdecl,
    importc: "clang_getCursorReferenced", dynlib: libclang.}

proc getCursorDefinition*(a2: CXCursor): CXCursor {.cdecl,
    importc: "clang_getCursorDefinition", dynlib: libclang.}

proc isCursorDefinition*(a2: CXCursor): cuint {.cdecl,
    importc: "clang_isCursorDefinition", dynlib: libclang.}

proc getCanonicalCursor*(a2: CXCursor): CXCursor {.cdecl,
    importc: "clang_getCanonicalCursor", dynlib: libclang.}

proc getObjCSelectorIndex*(a2: CXCursor): cint {.cdecl,
    importc: "clang_Cursor_getObjCSelectorIndex", dynlib: libclang.}

proc isDynamicCall*(C: CXCursor): cint {.cdecl,
                                     importc: "clang_Cursor_isDynamicCall",
                                     dynlib: libclang.}

proc getReceiverType*(C: CXCursor): CXType {.cdecl,
    importc: "clang_Cursor_getReceiverType", dynlib: libclang.}

type
  CXObjCPropertyAttrKind* {.size: sizeof(cint).} = enum
    noattr = 0x00000000, readonly = 0x00000001, getter = 0x00000002, assign = 0x00000004,
    readwrite = 0x00000008, retain = 0x00000010, copy = 0x00000020,
    nonatomic = 0x00000040, setter = 0x00000080, `atomic` = 0x00000100,
    weak = 0x00000200, strong = 0x00000400, unsafe_unretained = 0x00000800,
    class = 0x00001000



proc getObjCPropertyAttributes*(C: CXCursor; reserved: cuint): cuint {.cdecl,
    importc: "clang_Cursor_getObjCPropertyAttributes", dynlib: libclang.}

type
  CXObjCDeclQualifierKind* {.size: sizeof(cint), pure.} = enum
    None = 0x00000000, In = 0x00000001, Inout = 0x00000002, Out = 0x00000004,
    Bycopy = 0x00000008, Byref = 0x00000010, Oneway = 0x00000020



proc getObjCDeclQualifiers*(C: CXCursor): cuint {.cdecl,
    importc: "clang_Cursor_getObjCDeclQualifiers", dynlib: libclang.}

proc isObjCOptional*(C: CXCursor): cuint {.cdecl,
                                       importc: "clang_Cursor_isObjCOptional",
                                       dynlib: libclang.}

proc isVariadic*(C: CXCursor): bool {.cdecl, importc: "clang_Cursor_isVariadic",
                                   dynlib: libclang.}

proc getCommentRange*(C: CXCursor): CXSourceRange {.cdecl,
    importc: "clang_Cursor_getCommentRange", dynlib: libclang.}

proc getRawCommentText*(C: CXCursor): CXString {.cdecl,
    importc: "clang_Cursor_getRawCommentText", dynlib: libclang.}

proc getBriefCommentText*(C: CXCursor): CXString {.cdecl,
    importc: "clang_Cursor_getBriefCommentText", dynlib: libclang.}

proc getMangling*(a2: CXCursor): CXString {.cdecl,
                                        importc: "clang_Cursor_getMangling",
                                        dynlib: libclang.}

proc getCXXManglings*(a2: CXCursor): ptr CXStringSet {.cdecl,
    importc: "clang_Cursor_getCXXManglings", dynlib: libclang.}

type
  CXModule* = pointer


proc getModule*(C: CXCursor): CXModule {.cdecl, importc: "clang_Cursor_getModule",
                                     dynlib: libclang.}

proc getModuleForFile*(a2: CXTranslationUnit; a3: CXFile): CXModule {.cdecl,
    importc: "clang_getModuleForFile", dynlib: libclang.}

proc getASTFile*(Module: CXModule): CXFile {.cdecl,
    importc: "clang_Module_getASTFile", dynlib: libclang.}

proc getParent*(Module: CXModule): CXModule {.cdecl,
    importc: "clang_Module_getParent", dynlib: libclang.}

proc getName*(Module: CXModule): CXString {.cdecl, importc: "clang_Module_getName",
                                        dynlib: libclang.}

proc getFullName*(Module: CXModule): CXString {.cdecl,
    importc: "clang_Module_getFullName", dynlib: libclang.}

proc isSystem*(Module: CXModule): cint {.cdecl, importc: "clang_Module_isSystem",
                                     dynlib: libclang.}

proc getNumTopLevelHeaders*(a2: CXTranslationUnit; Module: CXModule): cuint {.cdecl,
    importc: "clang_Module_getNumTopLevelHeaders", dynlib: libclang.}

proc getTopLevelHeader*(a2: CXTranslationUnit; Module: CXModule; Index: cuint): CXFile {.
    cdecl, importc: "clang_Module_getTopLevelHeader", dynlib: libclang.}

proc isConvertingConstructor*(C: CXCursor): cuint {.cdecl,
    importc: "clang_CXXConstructor_isConvertingConstructor", dynlib: libclang.}

proc isCopyConstructor*(C: CXCursor): cuint {.cdecl,
    importc: "clang_CXXConstructor_isCopyConstructor", dynlib: libclang.}

proc isDefaultConstructor*(C: CXCursor): cuint {.cdecl,
    importc: "clang_CXXConstructor_isDefaultConstructor", dynlib: libclang.}

proc isMoveConstructor*(C: CXCursor): cuint {.cdecl,
    importc: "clang_CXXConstructor_isMoveConstructor", dynlib: libclang.}

proc isMutable*(C: CXCursor): cuint {.cdecl, importc: "clang_CXXField_isMutable",
                                  dynlib: libclang.}

proc isDefaulted*(C: CXCursor): cuint {.cdecl,
                                    importc: "clang_CXXMethod_isDefaulted",
                                    dynlib: libclang.}

proc isPureVirtual*(C: CXCursor): cuint {.cdecl,
                                      importc: "clang_CXXMethod_isPureVirtual",
                                      dynlib: libclang.}

proc isStatic*(C: CXCursor): cuint {.cdecl, importc: "clang_CXXMethod_isStatic",
                                 dynlib: libclang.}

proc isVirtual*(C: CXCursor): cuint {.cdecl, importc: "clang_CXXMethod_isVirtual",
                                  dynlib: libclang.}

proc isConst*(C: CXCursor): cuint {.cdecl, importc: "clang_CXXMethod_isConst",
                                dynlib: libclang.}

proc getTemplateCursorKind*(C: CXCursor): CXCursorKind {.cdecl,
    importc: "clang_getTemplateCursorKind", dynlib: libclang.}

proc getSpecializedCursorTemplate*(C: CXCursor): CXCursor {.cdecl,
    importc: "clang_getSpecializedCursorTemplate", dynlib: libclang.}

proc getCursorReferenceNameRange*(C: CXCursor; NameFlags: cuint; PieceIndex: cuint): CXSourceRange {.
    cdecl, importc: "clang_getCursorReferenceNameRange", dynlib: libclang.}
type
  CXNameRefFlags* {.size: sizeof(cint).} = enum
    WantQualifier = 0x00000001, WantTemplateArgs = 0x00000002,
    WantSinglePiece = 0x00000004



type
  CXTokenKind* {.size: sizeof(cint).} = enum
    Punctuation, Keyword, Identifier, Literal, Comment



type
  CXToken* = object
    int_data*: array[4, cuint]
    ptr_data*: pointer



proc getTokenKind*(a2: CXToken): CXTokenKind {.cdecl, importc: "clang_getTokenKind",
    dynlib: libclang.}

proc getTokenSpelling*(a2: CXTranslationUnit; a3: CXToken): CXString {.cdecl,
    importc: "clang_getTokenSpelling", dynlib: libclang.}

proc getTokenLocation*(a2: CXTranslationUnit; a3: CXToken): CXSourceLocation {.cdecl,
    importc: "clang_getTokenLocation", dynlib: libclang.}

proc getTokenExtent*(a2: CXTranslationUnit; a3: CXToken): CXSourceRange {.cdecl,
    importc: "clang_getTokenExtent", dynlib: libclang.}

proc tokenize*(TU: CXTranslationUnit; Range: CXSourceRange; Tokens: ptr ptr CXToken;
              NumTokens: ptr cuint) {.cdecl, importc: "clang_tokenize",
                                   dynlib: libclang.}

proc annotateTokens*(TU: CXTranslationUnit; Tokens: ptr CXToken; NumTokens: cuint;
                    Cursors: ptr CXCursor) {.cdecl, importc: "clang_annotateTokens",
    dynlib: libclang.}

proc disposeTokens*(TU: CXTranslationUnit; Tokens: ptr CXToken; NumTokens: cuint) {.
    cdecl, importc: "clang_disposeTokens", dynlib: libclang.}

proc getCursorKindSpelling*(Kind: CXCursorKind): CXString {.cdecl,
    importc: "clang_getCursorKindSpelling", dynlib: libclang.}
proc getDefinitionSpellingAndExtent*(a2: CXCursor; startBuf: cstringArray;
                                    endBuf: cstringArray; startLine: ptr cuint;
                                    startColumn: ptr cuint; endLine: ptr cuint;
                                    endColumn: ptr cuint) {.cdecl,
    importc: "clang_getDefinitionSpellingAndExtent", dynlib: libclang.}
proc enableStackTraces*() {.cdecl, importc: "clang_enableStackTraces",
                          dynlib: libclang.}
proc executeOnThread*(fn: proc (a2: pointer) {.cdecl.}; user_data: pointer;
                     stack_size: cuint) {.cdecl, importc: "clang_executeOnThread",
                                        dynlib: libclang.}

type
  CXCompletionString* = pointer


type
  CXCompletionResult* = object
    CursorKind*: CXCursorKind
    CompletionString*: CXCompletionString



type
  CXCompletionChunkKind* {.size: sizeof(cint).} = enum
    Optional, TypedText, Text, Placeholder, Informative, CurrentParameter, LeftParen,
    RightParen, LeftBracket, RightBracket, LeftBrace, RightBrace, LeftAngle,
    RightAngle, Comma, ResultType, Colon, SemiColon, Equal, HorizontalSpace,
    VerticalSpace



proc getCompletionChunkKind*(completion_string: CXCompletionString;
                            chunk_number: cuint): CXCompletionChunkKind {.cdecl,
    importc: "clang_getCompletionChunkKind", dynlib: libclang.}

proc getCompletionChunkText*(completion_string: CXCompletionString;
                            chunk_number: cuint): CXString {.cdecl,
    importc: "clang_getCompletionChunkText", dynlib: libclang.}

proc getCompletionChunkCompletionString*(completion_string: CXCompletionString;
                                        chunk_number: cuint): CXCompletionString {.
    cdecl, importc: "clang_getCompletionChunkCompletionString", dynlib: libclang.}

proc getNumCompletionChunks*(completion_string: CXCompletionString): cuint {.cdecl,
    importc: "clang_getNumCompletionChunks", dynlib: libclang.}

proc getCompletionPriority*(completion_string: CXCompletionString): cuint {.cdecl,
    importc: "clang_getCompletionPriority", dynlib: libclang.}

proc getCompletionAvailability*(completion_string: CXCompletionString): CXAvailabilityKind {.
    cdecl, importc: "clang_getCompletionAvailability", dynlib: libclang.}

proc getCompletionNumAnnotations*(completion_string: CXCompletionString): cuint {.
    cdecl, importc: "clang_getCompletionNumAnnotations", dynlib: libclang.}

proc getCompletionAnnotation*(completion_string: CXCompletionString;
                             annotation_number: cuint): CXString {.cdecl,
    importc: "clang_getCompletionAnnotation", dynlib: libclang.}

proc getCompletionParent*(completion_string: CXCompletionString;
                         kind: ptr CXCursorKind): CXString {.cdecl,
    importc: "clang_getCompletionParent", dynlib: libclang.}

proc getCompletionBriefComment*(completion_string: CXCompletionString): CXString {.
    cdecl, importc: "clang_getCompletionBriefComment", dynlib: libclang.}

proc getCursorCompletionString*(cursor: CXCursor): CXCompletionString {.cdecl,
    importc: "clang_getCursorCompletionString", dynlib: libclang.}

type
  CXCodeCompleteResults* = object
    Results*: ptr CXCompletionResult
    NumResults*: cuint



type
  CXCodeComplete_Flags* {.size: sizeof(cint).} = enum
    CXCodeComplete_IncludeMacros = 0x00000001,
    CXCodeComplete_IncludeCodePatterns = 0x00000002,
    CXCodeComplete_IncludeBriefComments = 0x00000004



type
  CXCompletionContext* {.size: sizeof(cint), pure.} = enum
    Unexposed = 0, AnyType = 1 shl 0, AnyValue = 1 shl 1, ObjCObjectValue = 1 shl 2,
    ObjCSelectorValue = 1 shl 3, CXXClassTypeValue = 1 shl 4, DotMemberAccess = 1 shl 5,
    ArrowMemberAccess = 1 shl 6, ObjCPropertyAccess = 1 shl 7, EnumTag = 1 shl 8,
    UnionTag = 1 shl 9, StructTag = 1 shl 10, ClassTag = 1 shl 11, Namespace = 1 shl 12,
    NestedNameSpecifier = 1 shl 13, ObjCInterface = 1 shl 14, ObjCProtocol = 1 shl 15,
    ObjCCategory = 1 shl 16, ObjCInstanceMessage = 1 shl 17, ObjCClassMessage = 1 shl 18,
    ObjCSelectorName = 1 shl 19, MacroName = 1 shl 20, NaturalLanguage = 1 shl 21,
    Unknown = ((1 shl 22) - 1)



proc defaultCodeCompleteOptions*(): cuint {.cdecl,
    importc: "clang_defaultCodeCompleteOptions", dynlib: libclang.}

proc codeCompleteAt*(TU: CXTranslationUnit; complete_filename: cstring;
                    complete_line: cuint; complete_column: cuint;
                    unsaved_files: ptr CXUnsavedFile; num_unsaved_files: cuint;
                    options: cuint): ptr CXCodeCompleteResults {.cdecl,
    importc: "clang_codeCompleteAt", dynlib: libclang.}

proc sortCodeCompletionResults*(Results: ptr CXCompletionResult; NumResults: cuint) {.
    cdecl, importc: "clang_sortCodeCompletionResults", dynlib: libclang.}

proc disposeCodeCompleteResults*(Results: ptr CXCodeCompleteResults) {.cdecl,
    importc: "clang_disposeCodeCompleteResults", dynlib: libclang.}

proc codeCompleteGetNumDiagnostics*(Results: ptr CXCodeCompleteResults): cuint {.
    cdecl, importc: "clang_codeCompleteGetNumDiagnostics", dynlib: libclang.}

proc codeCompleteGetDiagnostic*(Results: ptr CXCodeCompleteResults; Index: cuint): CXDiagnostic {.
    cdecl, importc: "clang_codeCompleteGetDiagnostic", dynlib: libclang.}

proc codeCompleteGetContexts*(Results: ptr CXCodeCompleteResults): culonglong {.
    cdecl, importc: "clang_codeCompleteGetContexts", dynlib: libclang.}

proc codeCompleteGetContainerKind*(Results: ptr CXCodeCompleteResults;
                                  IsIncomplete: ptr cuint): CXCursorKind {.cdecl,
    importc: "clang_codeCompleteGetContainerKind", dynlib: libclang.}

proc codeCompleteGetContainerUSR*(Results: ptr CXCodeCompleteResults): CXString {.
    cdecl, importc: "clang_codeCompleteGetContainerUSR", dynlib: libclang.}

proc codeCompleteGetObjCSelector*(Results: ptr CXCodeCompleteResults): CXString {.
    cdecl, importc: "clang_codeCompleteGetObjCSelector", dynlib: libclang.}

proc getClangVersion*(): CXString {.cdecl, importc: "clang_getClangVersion",
                                 dynlib: libclang.}

proc toggleCrashRecovery*(isEnabled: cuint) {.cdecl,
    importc: "clang_toggleCrashRecovery", dynlib: libclang.}

type
  CXInclusionVisitor* = proc (included_file: CXFile;
                           inclusion_stack: ptr CXSourceLocation;
                           include_len: cuint; client_data: CXClientData) {.cdecl.}


proc getInclusions*(tu: CXTranslationUnit; visitor: CXInclusionVisitor;
                   client_data: CXClientData) {.cdecl,
    importc: "clang_getInclusions", dynlib: libclang.}
type
  CXEvalResultKind* {.size: sizeof(cint), pure.} = enum
    UnExposed = 0, Int = 1, Float = 2, ObjCStrLiteral = 3, StrLiteral = 4, CFStr = 5, Other = 6



type
  CXEvalResult* = pointer


proc Evaluate*(C: CXCursor): CXEvalResult {.cdecl, importc: "clang_Cursor_Evaluate",
                                        dynlib: libclang.}

proc getKind*(E: CXEvalResult): CXEvalResultKind {.cdecl,
    importc: "clang_EvalResult_getKind", dynlib: libclang.}

proc getAsInt*(E: CXEvalResult): cint {.cdecl, importc: "clang_EvalResult_getAsInt",
                                    dynlib: libclang.}

proc getAsLongLong*(E: CXEvalResult): clonglong {.cdecl,
    importc: "clang_EvalResult_getAsLongLong", dynlib: libclang.}

proc isUnsignedInt*(E: CXEvalResult): cuint {.cdecl,
    importc: "clang_EvalResult_isUnsignedInt", dynlib: libclang.}

proc getAsUnsigned*(E: CXEvalResult): culonglong {.cdecl,
    importc: "clang_EvalResult_getAsUnsigned", dynlib: libclang.}

proc getAsDouble*(E: CXEvalResult): cdouble {.cdecl,
    importc: "clang_EvalResult_getAsDouble", dynlib: libclang.}

proc getAsStr*(E: CXEvalResult): cstring {.cdecl,
                                       importc: "clang_EvalResult_getAsStr",
                                       dynlib: libclang.}

proc dispose*(E: CXEvalResult) {.cdecl, importc: "clang_EvalResult_dispose",
                              dynlib: libclang.}

type
  CXRemapping* = pointer


proc getRemappings*(path: cstring): CXRemapping {.cdecl,
    importc: "clang_getRemappings", dynlib: libclang.}

proc getRemappingsFromFileList*(filePaths: cstringArray; numFiles: cuint): CXRemapping {.
    cdecl, importc: "clang_getRemappingsFromFileList", dynlib: libclang.}

proc getNumFiles*(a2: CXRemapping): cuint {.cdecl,
                                        importc: "clang_remap_getNumFiles",
                                        dynlib: libclang.}

proc getFilenames*(a2: CXRemapping; index: cuint; original: ptr CXString;
                  transformed: ptr CXString) {.cdecl,
    importc: "clang_remap_getFilenames", dynlib: libclang.}

proc dispose*(a2: CXRemapping) {.cdecl, importc: "clang_remap_dispose",
                              dynlib: libclang.}

type
  CXVisitorResult* {.size: sizeof(cint), pure.} = enum
    Break, Continue


type
  CXCursorAndRangeVisitor* = object
    context*: pointer
    visit*: proc (context: pointer; a3: CXCursor; a4: CXSourceRange): CXVisitorResult {.
        cdecl.}

  CXResult* {.size: sizeof(cint), pure.} = enum
    Success = 0, Invalid = 1, VisitBreak = 2



proc findReferencesInFile*(cursor: CXCursor; file: CXFile;
                          visitor: CXCursorAndRangeVisitor): CXResult {.cdecl,
    importc: "clang_findReferencesInFile", dynlib: libclang.}

proc findIncludesInFile*(TU: CXTranslationUnit; file: CXFile;
                        visitor: CXCursorAndRangeVisitor): CXResult {.cdecl,
    importc: "clang_findIncludesInFile", dynlib: libclang.}

type
  CXIdxClientFile* = pointer


type
  CXIdxClientEntity* = pointer


type
  CXIdxClientContainer* = pointer


type
  CXIdxClientASTFile* = pointer


type
  CXIdxLoc* = object
    ptr_data*: array[2, pointer]
    int_data*: cuint



type
  CXIdxIncludedFileInfo* = object
    hashLoc*: CXIdxLoc
    filename*: cstring
    file*: CXFile
    isImport*: cint
    isAngled*: cint
    isModuleImport*: cint



type
  CXIdxImportedASTFileInfo* = object
    file*: CXFile
    module*: CXModule
    loc*: CXIdxLoc
    isImplicit*: cint

  CXIdxEntityKind* {.size: sizeof(cint), pure.} = enum
    Unexposed = 0, Typedef = 1, Function = 2, Variable = 3, Field = 4, EnumConstant = 5,
    ObjCClass = 6, ObjCProtocol = 7, ObjCCategory = 8, ObjCInstanceMethod = 9,
    ObjCClassMethod = 10, ObjCProperty = 11, ObjCIvar = 12, Enum = 13, Struct = 14, Union = 15,
    CXXClass = 16, CXXNamespace = 17, CXXNamespaceAlias = 18, CXXStaticVariable = 19,
    CXXStaticMethod = 20, CXXInstanceMethod = 21, CXXConstructor = 22,
    CXXDestructor = 23, CXXConversionFunction = 24, CXXTypeAlias = 25, CXXInterface = 26
  CXIdxEntityLanguage* {.size: sizeof(cint), pure.} = enum
    None = 0, C = 1, ObjC = 2, CXX = 3




type
  CXIdxEntityCXXTemplateKind* {.size: sizeof(cint), pure.} = enum
    NonTemplate = 0, Template = 1, TemplatePartialSpecialization = 2,
    TemplateSpecialization = 3
  CXIdxAttrKind* {.size: sizeof(cint), pure.} = enum
    Unexposed = 0, IBAction = 1, IBOutlet = 2, IBOutletCollection = 3
  CXIdxAttrInfo* = object
    kind*: CXIdxAttrKind
    cursor*: CXCursor
    loc*: CXIdxLoc

  CXIdxEntityInfo* = object
    kind*: CXIdxEntityKind
    templateKind*: CXIdxEntityCXXTemplateKind
    lang*: CXIdxEntityLanguage
    name*: cstring
    USR*: cstring
    cursor*: CXCursor
    attributes*: ptr ptr CXIdxAttrInfo
    numAttributes*: cuint

  CXIdxContainerInfo* = object
    cursor*: CXCursor

  CXIdxIBOutletCollectionAttrInfo* = object
    attrInfo*: ptr CXIdxAttrInfo
    objcClass*: ptr CXIdxEntityInfo
    classCursor*: CXCursor
    classLoc*: CXIdxLoc

  CXIdxDeclInfoFlags* {.size: sizeof(cint).} = enum
    CXIdxDeclFlag_Skipped = 0x00000001
  CXIdxDeclInfo* = object
    entityInfo*: ptr CXIdxEntityInfo
    cursor*: CXCursor
    loc*: CXIdxLoc
    semanticContainer*: ptr CXIdxContainerInfo
    lexicalContainer*: ptr CXIdxContainerInfo
    isRedeclaration*: cint
    isDefinition*: cint
    isContainer*: cint
    declAsContainer*: ptr CXIdxContainerInfo
    isImplicit*: cint
    attributes*: ptr ptr CXIdxAttrInfo
    numAttributes*: cuint
    flags*: cuint

  CXIdxObjCContainerKind* {.size: sizeof(cint).} = enum
    ForwardRef = 0, Interface = 1, Implementation = 2
  CXIdxObjCContainerDeclInfo* = object
    declInfo*: ptr CXIdxDeclInfo
    kind*: CXIdxObjCContainerKind

  CXIdxBaseClassInfo* = object
    base*: ptr CXIdxEntityInfo
    cursor*: CXCursor
    loc*: CXIdxLoc

  CXIdxObjCProtocolRefInfo* = object
    protocol*: ptr CXIdxEntityInfo
    cursor*: CXCursor
    loc*: CXIdxLoc

  CXIdxObjCProtocolRefListInfo* = object
    protocols*: ptr ptr CXIdxObjCProtocolRefInfo
    numProtocols*: cuint

  CXIdxObjCInterfaceDeclInfo* = object
    containerInfo*: ptr CXIdxObjCContainerDeclInfo
    superInfo*: ptr CXIdxBaseClassInfo
    protocols*: ptr CXIdxObjCProtocolRefListInfo

  CXIdxObjCCategoryDeclInfo* = object
    containerInfo*: ptr CXIdxObjCContainerDeclInfo
    objcClass*: ptr CXIdxEntityInfo
    classCursor*: CXCursor
    classLoc*: CXIdxLoc
    protocols*: ptr CXIdxObjCProtocolRefListInfo

  CXIdxObjCPropertyDeclInfo* = object
    declInfo*: ptr CXIdxDeclInfo
    getter*: ptr CXIdxEntityInfo
    setter*: ptr CXIdxEntityInfo

  CXIdxCXXClassDeclInfo* = object
    declInfo*: ptr CXIdxDeclInfo
    bases*: ptr ptr CXIdxBaseClassInfo
    numBases*: cuint







type
  CXIdxEntityRefKind* {.size: sizeof(cint).} = enum
    Direct = 1, Implicit = 2



type
  CXIdxEntityRefInfo* = object
    kind*: CXIdxEntityRefKind
    cursor*: CXCursor
    loc*: CXIdxLoc
    referencedEntity*: ptr CXIdxEntityInfo
    parentEntity*: ptr CXIdxEntityInfo
    container*: ptr CXIdxContainerInfo



type
  IndexerCallbacks* = object
    abortQuery*: proc (client_data: CXClientData; reserved: pointer): cint {.cdecl.}
    diagnostic*: proc (client_data: CXClientData; a3: CXDiagnosticSet;
                     reserved: pointer) {.cdecl.}
    enteredMainFile*: proc (client_data: CXClientData; mainFile: CXFile;
                          reserved: pointer): CXIdxClientFile {.cdecl.}
    ppIncludedFile*: proc (client_data: CXClientData; a3: ptr CXIdxIncludedFileInfo): CXIdxClientFile {.
        cdecl.}
    importedASTFile*: proc (client_data: CXClientData;
                          a3: ptr CXIdxImportedASTFileInfo): CXIdxClientASTFile {.
        cdecl.}
    startedTranslationUnit*: proc (client_data: CXClientData; reserved: pointer): CXIdxClientContainer {.
        cdecl.}
    indexDeclaration*: proc (client_data: CXClientData; a3: ptr CXIdxDeclInfo) {.cdecl.}
    indexEntityReference*: proc (client_data: CXClientData;
                               a3: ptr CXIdxEntityRefInfo) {.cdecl.}


proc isEntityObjCContainerKind*(a2: CXIdxEntityKind): cint {.cdecl,
    importc: "clang_index_isEntityObjCContainerKind", dynlib: libclang.}
proc getObjCContainerDeclInfo*(a2: ptr CXIdxDeclInfo): ptr CXIdxObjCContainerDeclInfo {.
    cdecl, importc: "clang_index_getObjCContainerDeclInfo", dynlib: libclang.}
proc getObjCInterfaceDeclInfo*(a2: ptr CXIdxDeclInfo): ptr CXIdxObjCInterfaceDeclInfo {.
    cdecl, importc: "clang_index_getObjCInterfaceDeclInfo", dynlib: libclang.}
proc getObjCCategoryDeclInfo*(a2: ptr CXIdxDeclInfo): ptr CXIdxObjCCategoryDeclInfo {.
    cdecl, importc: "clang_index_getObjCCategoryDeclInfo", dynlib: libclang.}
proc getObjCProtocolRefListInfo*(a2: ptr CXIdxDeclInfo): ptr CXIdxObjCProtocolRefListInfo {.
    cdecl, importc: "clang_index_getObjCProtocolRefListInfo", dynlib: libclang.}
proc getObjCPropertyDeclInfo*(a2: ptr CXIdxDeclInfo): ptr CXIdxObjCPropertyDeclInfo {.
    cdecl, importc: "clang_index_getObjCPropertyDeclInfo", dynlib: libclang.}
proc getIBOutletCollectionAttrInfo*(a2: ptr CXIdxAttrInfo): ptr CXIdxIBOutletCollectionAttrInfo {.
    cdecl, importc: "clang_index_getIBOutletCollectionAttrInfo", dynlib: libclang.}
proc getCXXClassDeclInfo*(a2: ptr CXIdxDeclInfo): ptr CXIdxCXXClassDeclInfo {.cdecl,
    importc: "clang_index_getCXXClassDeclInfo", dynlib: libclang.}

proc getClientContainer*(a2: ptr CXIdxContainerInfo): CXIdxClientContainer {.cdecl,
    importc: "clang_index_getClientContainer", dynlib: libclang.}

proc setClientContainer*(a2: ptr CXIdxContainerInfo; a3: CXIdxClientContainer) {.
    cdecl, importc: "clang_index_setClientContainer", dynlib: libclang.}

proc getClientEntity*(a2: ptr CXIdxEntityInfo): CXIdxClientEntity {.cdecl,
    importc: "clang_index_getClientEntity", dynlib: libclang.}

proc setClientEntity*(a2: ptr CXIdxEntityInfo; a3: CXIdxClientEntity) {.cdecl,
    importc: "clang_index_setClientEntity", dynlib: libclang.}

type
  CXIndexAction* = pointer


proc IndexAction_create*(CIdx: CXIndex): CXIndexAction {.cdecl,
    importc: "clang_IndexAction_create", dynlib: libclang.}

proc IndexAction_dispose*(a2: CXIndexAction) {.cdecl,
    importc: "clang_IndexAction_dispose", dynlib: libclang.}
type
  CXIndexOptFlags* {.size: sizeof(cint), pure.} = enum
    None = 0x00000000, SuppressRedundantRefs = 0x00000001,
    IndexFunctionLocalSymbols = 0x00000002,
    IndexImplicitTemplateInstantiations = 0x00000004,
    SuppressWarnings = 0x00000008, SkipParsedBodiesInSession = 0x00000010



proc indexSourceFile*(a2: CXIndexAction; client_data: CXClientData;
                     index_callbacks: ptr IndexerCallbacks;
                     index_callbacks_size: cuint; index_options: cuint;
                     source_filename: cstring; command_line_args: cstringArray;
                     num_command_line_args: cint;
                     unsaved_files: ptr CXUnsavedFile; num_unsaved_files: cuint;
                     out_TU: ptr CXTranslationUnit; TU_options: cuint): cint {.cdecl,
    importc: "clang_indexSourceFile", dynlib: libclang.}

proc indexSourceFileFullArgv*(a2: CXIndexAction; client_data: CXClientData;
                             index_callbacks: ptr IndexerCallbacks;
                             index_callbacks_size: cuint; index_options: cuint;
                             source_filename: cstring;
                             command_line_args: cstringArray;
                             num_command_line_args: cint;
                             unsaved_files: ptr CXUnsavedFile;
                             num_unsaved_files: cuint;
                             out_TU: ptr CXTranslationUnit; TU_options: cuint): cint {.
    cdecl, importc: "clang_indexSourceFileFullArgv", dynlib: libclang.}

proc indexTranslationUnit*(a2: CXIndexAction; client_data: CXClientData;
                          index_callbacks: ptr IndexerCallbacks;
                          index_callbacks_size: cuint; index_options: cuint;
                          a7: CXTranslationUnit): cint {.cdecl,
    importc: "clang_indexTranslationUnit", dynlib: libclang.}

proc getFileLocation*(loc: CXIdxLoc; indexFile: ptr CXIdxClientFile; file: ptr CXFile;
                     line: ptr cuint; column: ptr cuint; offset: ptr cuint) {.cdecl,
    importc: "clang_indexLoc_getFileLocation", dynlib: libclang.}

proc getCXSourceLocation*(loc: CXIdxLoc): CXSourceLocation {.cdecl,
    importc: "clang_indexLoc_getCXSourceLocation", dynlib: libclang.}

type
  CXFieldVisitor* = proc (C: CXCursor; client_data: CXClientData): CXVisitorResult {.
      cdecl.}



proc visitFields*(T: CXType; visitor: CXFieldVisitor; client_data: CXClientData): cuint {.
    cdecl, importc: "clang_Type_visitFields", dynlib: libclang.}




proc getCString*(string: CXString): cstring {.cdecl, importc: "clang_getCString",
    dynlib: libclang.}

proc disposeString*(string: CXString) {.cdecl, importc: "clang_disposeString",
                                     dynlib: libclang.}

proc disposeStringSet*(set: ptr CXStringSet) {.cdecl,
    importc: "clang_disposeStringSet", dynlib: libclang.}


proc getFileName*(SFile: CXFile): CXString {.cdecl, importc: "clang_getFileName",
    dynlib: libclang.}

proc getPresumedLocation*(location: CXSourceLocation; filename: ptr CXString;
                         line: ptr cuint; column: ptr cuint) {.cdecl,
    importc: "clang_getPresumedLocation", dynlib: libclang.}