## Purpose
**you may worked with AST and:**
 - sometimes you forgot the order of child nodes
 - sometimes you found your simple macro so complex to maintain
 - sometimes you wish there was a simpler solution

well, that's the purpose of this repo
we provide some additional functionalities to work with AST simpler

## Examples
this examples may change your mind to use this library or may not
but I found them reasonable


### eg 1
imagine we have a AST representation of a a `proc` definition

code:
```nim
proc myProc(arg1: bool, arg2: int = 4): bool {.pragm1, pragma2.}=
  discard
```
AST repr:
```nim
ProcDef
  Ident "myProc"
  Empty
  Empty
  FormalParams
    Ident "bool"
    IdentDefs
      Ident "arg1"
      Ident "bool"
      Empty
    IdentDefs
      Ident "arg2"
      Ident "int"
      IntLit 4
  Pragma
    Ident "pragm1"
    Ident "pragma2"
  Empty
  StmtList
    DiscardStmt
      Empty
```

without having the corresponding AST representation you [may] forgot the postion of proc name, return type, argumnets, pragma ,... to write this:

```nim
macro myMacro(body: untyped): untyped=
  let returnType = body[3][0]

```

but with `macroplus` you don't need to remember such things:
```nim
let returnType = body.RoutineReturnType
```
here `RoutineReturnType` is just a template


or imagine you wanna get arguments
```nim
let args = body.RoutineArguments
```
and  you wanna iterate over them. instead of writing this:
```nim
for arg in args:
  if arg[0].strVal == "something":
    if arg[2].strval == ...:
      ...
```
you could write
```nim
for arg in args:
  if arg[IdentDefName].strVal == "something":
    if arg[IdentDefDefaultVal] == ...:
    ...
```

isn't it more readable and understandable?

## TODO
I plan to add this features in the future

TODOs:
- [ ] add a documention page 
- [ ] add tests
- [ ] add unittest support for macros [or maybe in separted repo] 
