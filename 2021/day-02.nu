# This one I copy-pasted from the terminal and tried to refactor into a discernable
# script, but I had my fun figuring out mutable variables (which are a new feature)
# and now I don't feel like cleaning this up for now. It doesn't work as written.

# TODO: get back to this maybe, but really, two of these a day was a bit much

let instructions = (
  open $env.PUZZLE_FILE |
  lines |
  split column (char space) command amount |
  update amount { $in.amount | into int }
)

# Part One: naively sum each instruction and multiply the result

def commands [] { [forward up down] }

def command_total [command: string@commands] {
  ( $in | where command == $command | get amount | math sum )
}

def sum_position_and_depth [] {
  let horizontal = ($instructions | command_total forward)
  let up = ($instructions | command_total up)
  let down = ($instructions | command_total down)
  let depth = ($down - $up | if $in < 0 { 0 } else { $in })

  { horizontal: $horizontal depth: $depth }
}

let before_reading_the_manual = (
  sum_position_and_depth |
  $in.horizontal * $in.depth |
  if $in < 0 { 0 } else { $in }
)

$before_reading_the_manual

# Part Two: after properly reading the submarine manual!

 let tbl = ($data | lines | split column ' ' cmd amt)

def record_step [line, inrec] {
  mut rec = {hor: $inrec.hor depth: $inrec.depth aim: $inrec.aim}
  if $line.cmd == forward {
    $rec.hor = $rec.hor + $line.amt
    $rec.depth = $rec.depth + $rec.aim * $line.amt
  } else if $line.cmd == up {
    $rec.aim = $rec.aim - $line.amt
  } else if $line.cmd == down {
    $rec.aim = $rec.aim + $line.amt
  }
  $rec
}

def sum_position_and_depth [table] {
  mut rec = {hor: 0 depth: 0 aim: 0}
  mut list = []
  for $line in $table {
    let r = (record_step $line $rec)
    $rec = $r
    $list = ($list|append $r)
  }
  $list | merge $table
}

let after_reading_the_manual = (
  proc $instructions |
)
