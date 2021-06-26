import strutils, sequtils, macros

const
  ForBody* = ^1
  ForRange* = ^2
  ForIdents* = 0..^3

  CommandIdent* = 0
  CommandBody* = 1

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

func flattenDeepInfix*(nestedInfix: NimNode, infixIdent: string): NimNode =
  ## return a statement list of idents
  doAssert nestedInfix.kind == nnkInfix
  result = newStmtList()

  var currentNode = nestedInfix
  while true:
    result.add currentNode[2]

    let body = currentNode[1]
    if body.kind != nnkInfix:
      if body.repr != infixIdent:
        result.insert 0, body
      break

    currentNode = body

static:
  let a = quote:
    hamid and ali and mahdi and reza

  echo a.treeRepr
  echo a.flattenDeepInfix("and").treeRepr