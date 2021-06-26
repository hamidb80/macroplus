import strutils, sequtils, macros

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

func applyIndent*(lines: openArray[string]): auto =
  lines.mapIt it.indent DefaultIndent

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

func flattenDeepInfix*(nestedInfix: NimNode): NimNode =
  ## return a statement list of idents
  doAssert nestedInfix.kind == nnkInfix
  
  let infixIdent = nestedInfix[InfixIdent]
  
  result = newNimNode(nnkInfix)
  result.add infixIdent

  var currentNode = nestedInfix
  while true:
    result.add currentNode[InfixRightSide]

    let body = currentNode[InfixLeftSide]
    if body.kind != nnkInfix:
      if body.repr != infixIdent.repr:
        result.insert 1, body
      break

    currentNode = body

static:
  let a = quote:
    hamid and ali and mahdi and reza

  echo a.treeRepr
  echo a.flattenDeepInfix.treeRepr