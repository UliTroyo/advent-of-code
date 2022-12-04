let assignments = ( open $env.PUZZLE_FILE | lines | each { str replace -a '[,|-]' '#' |
  split column '#' e1_start e1_end e2_start e2_end } | flatten |
  into int e1_start e1_end e2_start e2_end )

# Part One: the elves are being assigned duplicate work!

def contained [pair] {
  let sections = [(seq $pair.e1_start $pair.e1_end) (seq $pair.e2_start $pair.e2_end)]
  let lengths = [($sections.0 | length) ($sections.1 | length)]
  let contains = ($sections.0 | append $sections.1 | uniq -d | length)
  if $lengths.0 == $contains or $lengths.1 == $contains { echo "contained" }
}

$assignments | each {|pair| contained $pair } | length

# Part Two: the elves should quiet-quit their shitty job

def overlap [pair] {
  let sections = [(seq $pair.e1_start $pair.e1_end) (seq $pair.e2_start $pair.e2_end)]
  let overlaps = ($sections.0 | append $sections.1 | uniq -d | length)
  if $overlaps > 0 { echo "overlap" }
}

$assignments | each {|pair| overlap $pair } | length