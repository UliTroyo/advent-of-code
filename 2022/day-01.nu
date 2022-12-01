# Saved the puzzle input as puzzle-input.txt

let total_calories_per_elf = (
  open puzzle-input.txt |
  lines |
  split list "" |
  each { into int | math sum }
)

# Part One: how many calories is the elf with the most calories carrying?

let the_most_calories = (
  $total_calories_per_elf |
  math max
)

# Part Two: how many calories are the top three elves carrying in total?

let top_three_calories = (
  $total_calories_per_elf |
  sort -r |
  first 3 |
  math sum
)
