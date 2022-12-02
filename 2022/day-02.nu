# (This code is extra verbose so newcomers to Nushell can understand.)
# Feeding the saved puzzle input text file through $env.PUZZLE_FILE

let strategy_guide = (
  open $env.PUZZLE_FILE |
  lines |
  split column (char space) foe me |
  str trim
)

let values = [[    throw  foe    me  value ];
              [     rock   A     X     1   ]
              [    paper   B     Y     2   ] 
              [ scissors   C     Z     3   ]]

let scores = [[       me  rock  paper  scissors ];
              [     rock    3      0      6     ]
              [    paper    6      3      0     ]
              [ scissors    0      6      3     ]]

# Part One: assume the elf meant that [A Y] == [rock paper]

def assumed_strategy [this_round] {
  let foe_throw = ( $values | where foe == $this_round.foe | get throw | get 0 )
  let my_throw =  ( $values |  where me == $this_round.me  | get throw | get 0 )
  let play_value = ( $scores | where me == $my_throw | get $foe_throw  | get 0 )
  let throw_value = ( $values | where me == $this_round.me | get value | get 0 )
  $play_value + $throw_value
}

$strategy_guide | each {|round| assumed_strategy $round } | math sum 

# Part Two: after the elf clarifies that [X Y Z] == [lose draw win]

let round_strategy = [[ foe     X        Y          Z        ]; 
                      [  A   scissors   rock       paper     ] 
                      [  B   rock       paper      scissors  ] 
                      [  C   paper      scissors   rock      ]]

def elf_strategy [this_round] {
  let foe_throw = ( $values | where foe == $this_round.foe | get throw | get 0 )
  let my_throw = ( $round_strategy | where foe == $this_round.foe | get $this_round.me | get 0 )
  let play_value = ( $scores | where me == $my_throw | get $foe_throw | get 0 )
  let throw_value = ( $values | where throw == $my_throw | get value | get 0 )
  $play_value + $throw_value
}

$strategy_guide | each {|round| elf_strategy $round } | math sum
