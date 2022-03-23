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


### e.g. 1
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


## Features
### Intuitive Indexing
assume `node` is type of `NimNode`
```nim
node[callArgs][0] # expensive and bad
node[callArgs[0]] # cheap and good
node[callArgs[^1]] # yes even backwards indexes
```

## Change Logs
### `0.2.0` -> `0.2.1`
* add `rchildren` iterator

### `0.1.x` -> `0.2.0`
* add intuitive indexing

## Comparision to `macroutils`
[macroutils](https://github.com/PMunch/macroutils) has more features along with enhancing readability, like *"pattern matching"*/*"traversing AST"*/*"advanced code quoting"*/*"typed NimNodes"* which can be really helpful.

when dealing with AST, most of the times I found myself writing specific functionalities for my edge cases which `macroutils` cannot cover. so I made this library that contains just small and tiny utilities.