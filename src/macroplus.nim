import macros

const
  ForBody* = ^1
  ForRange* = ^2
  ForIdents* = 0..^3

  CommandIdent* = 0
  CommandBody* = 1

  InfixIdent* = 0
  InfixOperator* = 0
  InfixLeftSide* = 1
  InfixRightSide* = 2
  InfixOperands* = 1..^1

  DefaultIndent* = 4

  IdentDefName* = 0
  IdentDefType* = 1
  IdentDefDefaultVal* = 2

  # see Routines in `macros` module
  RoutineName* = 0
  RoutineFormalParams* = 3
  RoutineBody* = ^1
  
  FormalParamsReturnType* = 0
  FormalParamsArguments* = 1..^1

template RoutineReturnType*(routine: untyped): untyped=
  routine[RoutineFormalParams][FormalParamsReturnType]

# TODO add test cases for compile-time

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

func simplify*(node: NimNode): NimNode=
  result = node

  while result.kind == nnkPar:
    result = result[0]

func flattenDeepInfixImpl(childNode: NimNode, infixIdent: string, result: var NimNode)=
  if childNode.kind == nnkInfix and childNode[InfixIdent].repr == infixIdent:
    flattenDeepInfixImpl simplify childNode[InfixLeftSide], infixIdent, result
    flattenDeepInfixImpl simplify childNode[InfixRightSide], infixIdent, result
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
