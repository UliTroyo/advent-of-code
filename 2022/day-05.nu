let drawing = ( open $env.PUZZLE_FILE | lines | split list "" )

def cacs [drawing] {
  # Such a long pipe just to ascertain the number of stacks? Gross.
  let total_stacks = ( $drawing.0 | last 1 | str replace -a (char space) "" | split chars |
    sort -r | get 0 | into int )
  let stack_locations = ( $drawing.0 | last 1 )
  let indices = ( seq 1 $total_stacks | into string | each {|stack| $stack_locations |
    str index-of $stack } | flatten )
  # This is it. The ugliest line of code in all of Nushell history.
  let shitty_extraction = ( $drawing.0 | drop | each {|line| $indices | each {|i| $line |
    str substring [$i ($i + 1)] } | wrap _ | transpose } | flatten | reverse )
  # Another ugly solution. Turn to string just to turn back into list.
  let column = {|number| $shitty_extraction | get $"column($number)" |
    str join (char newline) | lines --skip-empty }
  let stacks = ( seq 1 $total_stacks | each $column )
  let instructions = ( $drawing.1 | parse "move {move} from {from} to {to}" |
    into int move from to )
  test2 $instructions $stacks
}

def test [instructions stacks] {
  mut caca = $stacks
  for $i in $instructions {
    for $move in (seq 1 $i.move) {
      $caca = ($caca | update ($i.to - 1) ($caca | get ($i.to - 1) | split chars |
        append ($caca | get ($i.from - 1) | split chars | reverse | get 0 ) | str join ) |
        update ($i.from - 1) ($caca | get ($i.from - 1) | split chars | drop | str join) )
    }
  }
  $caca
}

def test2 [instructions stacks] {
  mut caca = $stacks
  for $i in $instructions {
    $caca = ($caca | update ($i.to - 1) ($caca | get ($i.to - 1) | split chars |
      append ($caca | get ($i.from - 1) | split chars | reverse | first $i.move | reverse ) |
      str join ) | update ($i.from - 1) ($caca | get ($i.from - 1) | split chars |
      drop $i.move | str join ) )
  }
  $caca
}
cacs $drawing | each { split chars | reverse | get 0 | str join } | str join
