# Uli's Advent of Code 2022

I've never done an advent of code, but this seems fun. I still don't know what it will involve, so I don't know if I'll stick with [Nushell](https://www.nushell.sh/) or if I'll switch to something else. I've been playing around with [V lang](https://vlang.io/) lately, so we'll see.

## Daily Log

| Sunday | Monday | Tuesday | Wednesday | Thursday | Friday | Saturday |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| --- | --- | --- | --- | [Day 1](https://github.com/UliTroyo/advent-of-code#day-1) | Day 2 | Day 3 |
| Day 4 | Day 5 | Day 6 | Day 7 | Day 8 | Day 9 | Day 10 |
| Day 11 | Day 12 | Day 13 | Day 14 | Day 15 | Day 16 | Day 17 |
| Day 18 | Day 19 | Day 20 | Day 21 | Day 22 | Day 23 | Day 24 |
| Day 25 | Day 26 | Day 27 | Day 28 | Day 29 | Day 30 | Day 31 |

### Day 1

The wonderful thing about Nushell is how easy it makes iterative data manipulation, and this problem exemplifies it. I split my solution script into discernable bits, but on the terminal, each part was a (long-ish) one-liner. Less tersely:

```nu
let total_calories_per_elf = ( open puzzle-input.txt | lines | split list "" |
  each { into int | math sum } )

# Part One
$total_calories_per_elf | math max

# Part Two
$total_calories_per_elf | sort -r | first 3 | math sum
```

In fact, that was so fun and simple that I went and tried last year's Advent of Code day, and it was even more interesting, because it utilizes a Nushell feature I had discovered but didn't know how I'd ever use: [`window`](https://www.nushell.sh/book/commands/window.html).

What `window` does is: it takes a list of items, and creates a list where each item is a sublist containing the specified number of items in that list, starting from that index. Yeah, easier shown than told:

```nu
[my spoon is too big] | window 2
# => [[my spoon] [spoon is] [is too] [too big]]
```

I had this impression of "well, that's neat, but what is it for?" and it turns out it was for answering 2021's AoC challenge, because in it, you take a list of depths from an underwater radar, and have to find whether the depth increases or decreases from one value to the next. The second part then has you closing over three values, adding them up, and then determining whether the depth increased or decreased. I don't know how I'd have done this using regular programming, because I didn't even bother thinking through the problem. The solution in Nushell is simple:

```nu
# The setup:
let depth_measurements = (open puzzle_input.txt | lines | str trim | into int)
let compare_depth = { if $in.0 < $in.1 {"inc"} else if $in.0 > $in.1 {"dec"} else {"same"}}

# The actual work:
let compare_by_threes = ($depth_measurements | window 3 --stride 1 | each { math sum } |
  window 2 | each $compare_depth | wrap depth | where depth == inc | length )
```

**Conclusion:** Nushell is so nice! Solving little ditties flows at the speed of thought, and when you're done, you save it as a script and you never have to do it again.

- [Solution to day 1](https://github.com/UliTroyo/advent-of-code/blob/main/2022/day-01.nu) (this year)
- [Solution to day 1](https://github.com/UliTroyo/advent-of-code/blob/main/2021/day-01.nu) (2021)
