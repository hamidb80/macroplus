import std/[unittest, sequtils]
import macroplus {.all.}

suite "intuitive indexing":
  const r = c 3..^1

  test "formal":
    check:
      r[0] == 3
      r[1] == 4

  test "backward":
    check:
      r[^1] is BackwardsIndex
      r[^1].int == 1
      r[^2].int == 2

  test "slice":
    check:
      toseq(1..10)[r] == @[4, 5, 6, 7, 8, 9, 10]
