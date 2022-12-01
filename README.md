# Uli's Advent of Code 2022

I've never done an advent of code, but this seems fun. I still don't know what it will involve, so I don't know if I'll stick with [Nushell](https://www.nushell.sh/) or if I'll switch to something else. I've been playing around with [V lang](https://vlang.io/) lately, so we'll see.

## Daily Log

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

Conclusion: Nushell is so nice! Solving little ditties flows at the speed of thought, and when you're done, you save it as a script and you never have to do it again.
