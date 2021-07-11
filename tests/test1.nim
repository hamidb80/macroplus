import unittest, macros
import macroplus

import macroplus

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