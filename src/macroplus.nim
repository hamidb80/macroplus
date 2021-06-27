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

func flattenDeepInfix(childNode: NimNode, infixIdent: string, result: var NimNode)=
  if childNode.kind == nnkInfix and childNode[InfixIdent].repr == infixIdent:
    flattenDeepInfix simplify childNode[InfixLeftSide], infixIdent, result
    flattenDeepInfix simplify childNode[InfixRightSide], infixIdent, result
  else:
    if childNode.repr != infixIdent:
      result.insert 1, childNode

func flattenDeepInfix*(nestedInfix: NimNode): NimNode =
  ## return a statement list of idents
  doAssert nestedInfix.kind == nnkInfix
  result = newNimNode(nnkInfix)

  let infixIdent = nestedInfix[InfixIdent]
  result.add infixIdent
  
  flattenDeepInfix  nestedInfix, infixIdent.repr, result


# add macro test functionalities  

macro run=
  block nestedInfix:
    let a = quote:
      hamid and ali and mahdi and reza
      # (hamid) and (((ali and mahdi)) and reza)
      # hamid or ali and mahdi or reza

    # echo a.treeRepr
    # echo "res----------------------"
    echo a.flattenDeepInfix.treeRepr

  block nestedCommand:
    let a = quote:
      1 2 ident "string" [das, 3 , 4] 5
    
    echo a.flattenDeepCommands.treeRepr

run()