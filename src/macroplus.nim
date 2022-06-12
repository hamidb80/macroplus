import macros

# ptypes --------------------------------------------

type
  Index = int or BackwardsIndex
  MPSlice[A: Index, B: int or BackwardsIndex] {.borrow: `.`.} = distinct HSlice[A, B]

func `[]`*[T](r: MPSlice[int, T], index: int): int =
  r.a + index

func `[]`*(r: MPSlice[int, int], index: BackwardsIndex): int =
  r.b - (index.int - 1)

func `[]`*(r: MPSlice[int, BackwardsIndex],
    index: BackwardsIndex): BackwardsIndex =
  BackwardsIndex(r.b.int + index.int - 1)

converter toHSlice*[A, B](mps: MPSlice[A, B]): HSlice[A, B] =
  HSlice[A, B](mps)

func c[A, B](r: HSlice[A, B]): MPSlice[A, B] =
  MPSlice[A, B](r)

# defs --------------------------------------------

const
  ForBody* = ^1
  ForRange* = ^2
  ForIdents* = c 0..^3

  CommandIdent* = 0
  CommandIdents* = c 0..^2
  CommandArgs* = c 1..^1
  CommandBody* = ^1

  InfixIdent* = 0
  InfixOperator* = 0
  InfixLeftSide* = 1
  InfixRightSide* = 2
  InfixSides* = InfixLeftSide..InfixRightSide
  InfixBody* = 3
  InfixOperands* = c 1..^1

  ColonExprLeftSide* = 0
  ColonExprrightSide* = 1

  IdentDefName* = 0
  IdentDefNames* = c 0..^3 # used in proc(a,b,c = 1)
  IdentDefType* = ^2
  IdentDefDefaultVal* = ^1

  BracketExprIdent* = 0
  BracketExprParams* = c 1..^1

  CurlyExprIdent* = 0
  CurlyExprParams* = c 1..^1

  # see Routines in `macros` module
  RoutineName* = 0
  RoutineGenericParams* = 2
  RoutineFormalParams* = 3
  RoutinePragmas* = 4
  RoutineBody* = ^1

  FormalParamsReturnType* = 0
  FormalParamsArguments* = c 1..^1

  TypeDefIdent* = 0
  TypeDefGenericParams* = 1
  TypeDefBody* = 2

  CaseIdent* = 0
  CaseBranches* = c 1..^1
  CaseBranchIdent* = 0
  CaseBranchIdents* = c 0..^2
  CaseBranchBody* = ^1

  ElifBranchCond* = 0
  ElifBranchBody* = 1
  ElseBranchBody* = 0

  CallIdent* = 0
  CallArgs* = c 1..^1

  ObjConstrIdent* = 0
  ObjConstrFields* = c 1..^1

# macros & AST --------------------------------------------

template RoutineReturnType*(routine: untyped): untyped =
  routine[RoutineFormalParams][FormalParamsReturnType]

template RoutineArguments*(routine: untyped): untyped =
  routine[RoutineFormalParams][FormalParamsArguments]


func removeUselessPars*(node: NimNode): NimNode =
  result = node

  while result.kind == nnkPar and result.len == 1:
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

func matchInfix*(n: NimNode, infixIdent: string): bool =
  if n.kind == nnkInfix:
    let i = n[InfixIdent]
    return `==` infixIdent:
      case i.kind:
      of nnkOpenSymChoice: i[0].strval 
      else: i.strVal


func genFormalParams*(returnType: NimNode, args: openArray[NimNode]): NimNode =
  newTree(nnkFormalParams, returnType).add args

func toStmtlist*(sn: seq[NimNode]): NimNode =
  newStmtList().add sn

template inlineQuote*(body): untyped =
  ## to use quote macro in inline mode
  ## inlineQuote( mycode )
  quote:
    body

# heplers -------------------------------------

iterator rchildren*(n: NimNode): NimNode =
  for i in countdown(n.len-1, 0):
    yield n[i]
