# Saved the puzzle input as puzzle-input.txt

let depth_measurements = (
  open puzzle-input.txt |
  lines |
  str trim |
  into int
)

let compare_depth_change = {
  if $in.0 < $in.1 {
    "increased"
  } else if $in.0 > $in.1 {
    "decreased"
  } else {
    "no change"
  }
}

# Part One: comparing the previous depth measurement to the next, how many increased?

let compare_to_previous = (
  $depth_measurements |
  window 2 |
  each $compare_depth_change |
  wrap depth |
  where depth == increased |
  length
)

# Part Two: considering a three-measurement sliding window, how many increased?

let compare_by_threes = (
  $depth_measurements |
  window 3 --stride 1 |
  each { math sum } |
  window 2 |
  each $compare_depth_change |
  wrap depth |
  where depth == increased |
  length
)
