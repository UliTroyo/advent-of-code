let rucksacks = ( open $env.PUZZLE_FILE | lines | str trim )

def determine_priority [] {
  let item = $in
  let types = ( seq char a z | prepend 0 | append ( seq char A Z) | str join )
  let priority = ( $types | str index-of $item )
  $priority
}

# Part One: find the type of item that is in both compartments of each rucksack

def split_into_compartments [] {
  let items = $in
  let end = ( $items | str length )
  let middle = ( $end / 2 | math floor )
  let first = ( $items | str substring [0 $middle] )
  let second = ( $items | str substring [$middle $end] )
  [$first $second]
}
def find_duplicated_items [] {
  let rucksacks = ( $in | each { split_into_compartments } )
  let duplicated_items = ( $rucksacks | each {|rucksack|
    each {|compartment| split chars | uniq | str join } |
    str join | split chars | uniq -d } )
  $duplicated_items
}
let sum_of_errors = (
  $rucksacks | find_duplicated_items | flatten | each { determine_priority } | math sum
)

$sum_of_errors

# Part Two: find the elves' badges

def find_badges [] {
  let rucksacks = $in
  let elf_groups = ( $rucksacks | window 3 --stride 3 )
  let badges = ( $elf_groups | each {|group| each {|rucksack| split chars | uniq | str join } |
    str join | split chars | uniq -c | where count == 3 | get value } )
  $badges
}
let sum_of_badges = (
  $rucksacks | find_badges | flatten | each { determine_priority } | math sum
)

$sum_of_badges
