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
  RoutineFormalParams* = 3
  RoutineBody* = ^1

  FormalParamsReturnType* = 0
  FormalParamsArguments* = 1..^1

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

template RoutineReturnType*(routine: untyped): untyped=
  routine[RoutineFormalParams][FormalParamsReturnType]

template RoutineArguments*(routine: untyped): untyped =
  routine[RoutineFormalParams][FormalParamsArguments]


func removeUselessPar*(node: NimNode): NimNode =
  result = node

  while result.kind == nnkPar:
    result = result[0]

func flattenDeepCommands*(nestedCommand: NimNode): NimNode =
  doAssert nestedCommand.kind == nnkCommand
  ## return a statement list of idents
  result = newStmtList()

  var currentNode = nestedCommand
  while true:
    result.add currentNode[CommandIdent]

    let body = currentNode[CommandBody]
    if body.kind != nnkCommand:
      result.add body
      break

    currentNode = body

func flattenDeepInfixImpl(childNode: NimNode, infixIdent: string,
    result: var NimNode) =
  if childNode.kind == nnkInfix and childNode[InfixIdent].repr == infixIdent:
    flattenDeepInfixImpl removeUselessPar childNode[InfixLeftSide], infixIdent, result
    flattenDeepInfixImpl removeUselessPar childNode[InfixRightSide], infixIdent, result
  else:
    if childNode.repr != infixIdent:
      result.insert 1, childNode

func flattenDeepInfix*(nestedInfix: NimNode): NimNode =
  ## return a statement list of idents
  doAssert nestedInfix.kind == nnkInfix
  result = newNimNode(nnkInfix)

  let infixIdent = nestedInfix[InfixIdent]
  result.add infixIdent

  flattenDeepInfixImpl nestedInfix, infixIdent.repr, result
