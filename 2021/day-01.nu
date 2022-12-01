# (This code is extra verbose so newcomers to Nushell can understand.)

# Saved the puzzle input as puzzle-input.txt

let depth_measurements = ( # Multi-line pipes are contained with ()
  open puzzle-input.txt |  # - open the puzzle input as text
  lines |                  # - split the lines into a list we can iterate on
  str trim |               # - the list might contain whitespace that prevents int conversion maybe?
  into int                 # - yay, numbers!
)

let compare_depth_change = { # This is a closure, to be used with an `each` command later.
  if $in.0 < $in.1 {         # Anything piped into a closure is captured by $in, in this case
    "increased"              # a list containing two values: a depth and the next depth.
  } else if $in.0 > $in.1 {
    "decreased"              # In Nushell, values within blocks are echoed so we can continue
  } else {                   # the pipe. In this case, the strings "increased",
    "no change"              # "decreased", and "no change" will be the values
  }                          # of the resulting list.
}

# Part One: comparing the previous depth measurement to the next, how many increased?

let compare_to_previous = (
  $depth_measurements |        # - the list of depths
  window 2 |                   # - now we have a list of [[prev next]...[prev next]]
  each $compare_depth_change | # - now it's a list of strings ("increased", etc.)
  wrap depth |                 # - let's be fancy and turn the list into a column...
  where depth == increased |   # - so we can descriptively get a list of only "increased" values
  length                       # - which we can count, for the answer.
)

# Part Two: considering a three-measurement sliding window, how many increased?

let compare_by_threes = (
  $depth_measurements |
  window 3 --stride 1 |        # - for a list of [[one two three] [two three four] ...etc.]
  each { math sum } |          # - for a list of [one+two+three, two+three+four, ...etc.]
  window 2 |                   # - for a list of [[total1 total2] [total2 total3] ...etc.]
  each $compare_depth_change | # - for a list of ["increased" "decreased" ...etc.]
  wrap depth |
  where depth == increased |   # - I like tables, they make code readable
  length                       # - total rows containing "increased"
)
