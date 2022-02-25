import macros

const
  ForBody* = ^1
  ForRange* = ^2
  ForIdents* = 0..^3

  CommandIdent* = 0
  CommandIdents* = 0..^2
  CommandBody* = ^1

  InfixIdent* = 0
  InfixOperator* = 0
  InfixLeftSide* = 1
  InfixRightSide* = 2
  InfixOperands* = 1..^1

  ColonExprLeftSide* = 0
  ColonExprrightSide* = 1

  IdentDefName* = 0
  IdentDefNames* = 0..^3 # used in proc(a,b,c = 1)
  IdentDefType* = ^2
  IdentDefDefaultVal* = ^1

  BracketExprIdent* = 0
  BracketExprParams* = 1..^1

  # see Routines in `macros` module
  RoutineName* = 0
  RoutineGenericParams* = 2
  RoutineFormalParams* = 3
  RoutinePragmas* = 4
  RoutineBody* = ^1

  FormalParamsReturnType* = 0
  FormalParamsArguments* = 1..^1

  TypeDefIdent* = 0
  TypeDefGenericParams* = 1
  TypeDefBody* = 2

  CaseIdent* = 0
  CaseBranches* = 1..^1
  CaseBranchIdent* = 0
  CaseBranchIdents* = 0 .. ^2
  CaseBranchBody* = ^1

  ElifBranchCond* = 0
  ElifBranchBody* = 1
  ElseBranchBody* = 0

  CallIdent* = 0
  CallArgs* = 1..^1

  ObjConstrIdent* = 0
  ObjConstrFields* = 1 .. ^1


template RoutineReturnType*(routine: untyped): untyped =
  routine[RoutineFormalParams][FormalParamsReturnType]

template RoutineArguments*(routine: untyped): untyped =
  routine[RoutineFormalParams][FormalParamsArguments]


func removeUselessPar*(node: NimNode): NimNode =
  result = node

  while result.kind == nnkPar:
    result = result[0]

func add*(father: NimNode, nodes: seq[NimNode]): NimNode {.discardable.} =
  for n in nodes:
    father.add n

  father

func toTupleNode*(sn: varargs[NimNode]): NimNode =
  newTree(nnkTupleConstr, sn)

func exported*(identNode: NimNode): NimNode =
  postfix(identnode, "*")

func isExportedIdent*(node: NimNode): bool =
  node.kind == nnkPostfix and node[0].strVal == "*"

func genFormalParams*(returnType: NimNode, args: openArray[NimNode]): NimNode =
  newTree(nnkFormalParams, returnType).add args

func toStmtlist*(sn: seq[NimNode]): NimNode =
  newStmtList().add sn

template inlineQuote*(body): untyped =
  ## to use quote macro in inline mode
  ## inlineQuote( mycode )
  quote:
    body
