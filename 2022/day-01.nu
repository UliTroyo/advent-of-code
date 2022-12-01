# (This code is extra verbose so newcomers to Nushell can understand.)

# Saved the puzzle input as puzzle-input.txt

let total_calories_per_elf = (  # Multi-line pipes are contained with ()
  open puzzle-input.txt |       # - open the puzzle input as text
  lines |                       # - split the lines into a list we can iterate on
  split list "" |               # - split list along lines containing only "" to get a
                                #   list containing [[cal1 cal2 cal3] [cal4 cal5] ...etc.]
  each { into int | math sum }  # - add up all the calories for a list
                                #   containing [elf_1_total elf_2_total ...etc.]
)

# Part One: how many calories is the elf with the most calories carrying?

let the_most_calories = (
  $total_calories_per_elf |  # - our list from before
  math max                   # - find the highest value in our list
)

# Part Two: how many calories are the top three elves carrying in total?

let top_three_calories = (
  $total_calories_per_elf |  # - our list from before
  sort -r |                  # - we sort the value in reverse (descending) order
  first 3 |                  # - get a list containing the top 3 values
  math sum                   # - and add them up to see how much the top 3 elves carry total
)
