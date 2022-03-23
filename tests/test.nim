import std/[unittest]
import macroplus {.all.}

suite "intuitive indexing":
  const r = c 4..^1
  
  test "formal":
    check:
      r[0] == 4
      r[1] == 5

  test "backward":
    check:
      r[^1] is BackwardsIndex
      r[^1].int == 1
      r[^2].int == 2
