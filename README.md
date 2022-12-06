# Uli's Advent of Code 2022

I've never done an advent of code, but this seems fun. I still don't know what it will involve, so I don't know if I'll stick with [Nushell](https://www.nushell.sh/) or if I'll switch to something else. I've been playing around with [V lang](https://vlang.io/) lately, so we'll see.

## Daily Log

| Sunday | Monday | Tuesday | Wednesday | Thursday | Friday | Saturday |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| --- | --- | --- | --- | [Day 1](https://github.com/UliTroyo/advent-of-code#day-1) |[Day 2](https://github.com/UliTroyo/advent-of-code#day-2) | [Day 3](https://github.com/UliTroyo/advent-of-code#day-3) |
| [Day 4](https://github.com/UliTroyo/advent-of-code#day-4) | [Day 5](https://github.com/UliTroyo/advent-of-code#day-5) | [Day 6](https://github.com/UliTroyo/advent-of-code#day-6) | Day 7 | Day 8 | Day 9 | Day 10 |
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

### Day 2

Thrown for a loop! I'll write it up tomorrow, but where yesterday's challenges were basically built for Nushell, today's had me reaching. For this year's challenge, I wound up using truth tables, mainly to show Nushell's  great visual aspect. For 2021's challenge though... I wound up using mutable variables, a feature that has existed in Nushell only since this week.

**EDIT:** Yeah, a day later I'm thinking doing two problems in one day was a bit much for a language in a programming paradigm I'm not familiar with. I had a lot of fun figuring out mutable variables for the 2021 problem, at least, realizing they were what I needed even though it's a brand-new feature.

This really is Nushell not being ideal for very imperative problems, because stuff gets very wordy. I do like my truth-table solution for the 2022 problem, though. I spent most of the time just making the source code look nice. I do love that nu/nuon can be so readable. I've been doing a lot of config stuff lately, and I've seen MANY config DSLs just this week: json, hjson, toml, lua, kdl, yaml... and nuon is still my favorite, so I wrote me up some nuon-style visual truth tables. I got to play around with Helix's column formatting keybinds, even. This is what it looks like:

```nu
# This looks like the output this code produces in Nushell, albeit less pretty.
let scores = [[       me  rock  paper  scissors ];
              [     rock    3      0      6     ]
              [    paper    6      3      0     ]
              [ scissors    0      6      3     ]]
```
Overall fun, and once again, on the terminal the code was one long one-liner, but very slow and unideal. At least it's easy to understand from the visual representation. But I'll be honest, I did miss my imperative languages for this day, especially for the 2021. Tomorrow, I'm sticking to a single problem a day.

- [Solution to day 2](https://github.com/UliTroyo/advent-of-code/blob/main/2022/day-02.nu) (this year)
- [Solution to day 2](https://github.com/UliTroyo/advent-of-code/blob/main/2021/day-02.nu) (2021)

### Day 3

It still takes me significant effort to not think of imperative solutions to these challenges. I had already done another mutable variable monstrosity for the first part, when I realized while working in the second part that instead of looping, I could just use `uniq` to break down each string to simply sift the duplicates out. My solutions are still very wordy, as I haven't figured out my style: how much description is too much? How much can I abstract away? Funnily, what I'm happiest about accomplishing today is adding a script that opens or creates that day's file, as my tab completion already has 4 other similarly-named files. My one-liner:

```nu
hx (date now | date format "%Y/day-%d.nu")
# => hx 2022/day-03.nu
```

Anyway, I hope this proves to be a good way to diminish my imperative habits when using Nushell. It _might_ be working--today I reached for `window` right away when closing over values:

```nu
# Use `window` to close over every 3 lines
def find_badges [] {
  let rucksacks = $in
  let elf_groups = ( $rucksacks | window 3 --stride 3 )
  let badges = ( $elf_groups | each {|group| each {|rucksack| split chars | uniq | str join } |
    str join | split chars | uniq -c | where count == 3 | get value } )
  $badges
}
```

My next project is to stop slackin' on dataframes. I almost reached for them here in order to use `contains` to compare the two substrings that represent the rucksack compartments. It's a waste to not know how to use one of Nushell's most powerful features, so I hope I get to tackle that very soon.

- [Solution to day 3](https://github.com/UliTroyo/advent-of-code/blob/main/2022/day-03.nu)

### Day 4

Today was an easy one! I think I _will_ put my pipes in a sequence after all. That better reflects how I work with the Nushell command line. I don't think I have the motivation to explain every part of every line like I did in the first day. Having done it for a single day is likely enough; Nushell is highly readable. In fact, that's what I like about Nushell over the arcanities of the Unix heritage: intelligible commands.

Y'know what, let's talk about it. We have tab completion in our shells. And Nushell supports spaces in commands as "subcommands", e.g. `git clone`, so my script modules are full of sentences like `edit nu config` and `sorted sensibly`. If I were a streaming man, the audience could read my pipes in legible English: `"open poop.txt | lines | each { turn into magic sprinkles } | save intelligibility.ftw"` . I think that's important.

Anyway, today I used `uniq` as the crux of my solution. What a handy construct... though I wish it was `unique`. And `sequence`. Alas. Anyway, imperative programming really is missing so much in the way of simple commands. No idea how you'd do this in C++ or Rust, but I bet they have something nasty like `std::seq(arg1, arg2)` or something equally excessive in the way of punctuation. But at least I trust they have something. What do I get with JavaScript? If I'm fancy, I get a decent generator function. If I'm not, I get a 1990's `for` loop. For all its esoterisms, Unix at least gives us such succinct and useful "programs that do one thing well" and really, there's nothing more declarative than just using sentences to do useful things. Now if only we could have decent keyboards with chords so we could feasibly use Unicode code points not in the ascii range.... you know what's better than `open my_file | do something`? How'bout `open my_file →  do something`.

Back in the real world, though, I keep discovering obvious useful functionality in Nushell. Before I wrote up my solution in this repo, my solution contained the ugliest imperative `split column | take 1 down | pass it around | each {|column| into int } | 99 columns of shit on the wall` and embarrassingly encapsulated it in a `def "turn each column into a sad list just to turn it back into a column after each-ing the lists into int and then merging the whole shebang back together" [] {}` until I realized: yes, of course Nushell already has the ability to `$take_this_table | into int column1 column2 etc` without needing to split my columns into lists. Of course it does. At this point, why don't I immediately assume so? Probably because I'm solving these things at 1 in the morning  and then not going to sleep until 4 because I'm typing entire blog posts that nobody will ever read about my adventures in programming in a language that a handful of people in the world even know about (FOR NOW!).

Which, incidentally, is still a silly amount of fun, even if in my delirium I wind up dreaming about helpless indentured Christmas elves who I can only save from capitalism with my little MacBook running Nushell on the terminal. Anyway, here's the line that yielded my `$table | into int` discovery:

```nu
# The poor elves are despairing with workplace bureaucracy
# while I fiddle with trying to eke ints out of string tables
let assignments = ( open $env.PUZZLE_FILE | lines | each { str replace -a '[,|-]' '#' |
  split column '#' column1 column2 column3 column4 } | flatten |
  into int column1 column2 column3 column4 )
```

But I save the day while prolonging their servitude to the invisible hand yet again!

- [Solution to day 4](https://github.com/UliTroyo/advent-of-code/blob/main/2022/day-04.nu)

### Day 5

What a difficult day! I'm writing this a day late, because I didn't finish until 5 minutes before the next day, after trying during the previous night and throughout the day. It's the ugliest problem by far, and I just kept being convinced there had to be a better way of solving it. I wound up giving up and brute-forcing it. I still haven't refactored it sensibly, and I can barely look at it. It uses mutable variables, which I know I said I consider a code smell, but maybe not. They seem to work here.

The rest of the problem though... atrocious. For my hall of shame:

```nu
# This is it. The ugliest line of code in all of Nushell history.
let shitty_extraction = ( $drawing.0 | drop | each {|line| $indices | each {|i| $line |
  str substring [$i ($i + 1)] } | wrap _ | transpose } | flatten | reverse )
# Another ugly solution. Turn to string just to turn back into list.
let column = {|number| $shitty_extraction | get $"column($number)" |
  str join (char newline) | lines --skip-empty }
```

I hope I learned a lesson with this one. No idea what it could be, though.

- [Solution to day 5](https://github.com/UliTroyo/advent-of-code/blob/main/2022/day-05.nu)

### Day 6

Today was a lot more fun! I solved this one right away, after about an hour of burning out on the previous challenge. Today the elves left me to tinker with a broken communicator, and I had to look for start-of-packet and start-of-message markers in a data stream. How useful `window` turned out to be! I just window'd their stream by chunks of the length of the markers (4 and 14 respectively), and counted the maximum of unique occurences of each character in each chunk. `uniq --count` gives me a table of values I can easily reference to find the first time every character in the chunk is unique, and BAM, solved.

There has to be a better way to extract the indexes of a list, though. That'll be homework. Today's solution:

```nu
def find_first_sequence_of_length [length: int] {
  let max_occurrences_per_char = ( $in | split chars | window $length --stride 1 |
    each { uniq -c | select count | math max } )
  let occurrence_list_length = ( $max_occurrences_per_char | length )
  let first_marker = ( $max_occurrences_per_char
    | merge ( seq 0 ( $occurrence_list_length - 1 ) | wrap idx ) | where count == 1 |
    first 1 | get idx.0 | $in + $length )
  $first_marker
}
```

Oh, I think I'm pretty solid on writing my pipes like this. It's how it looks in the terminal, and I think a simple indentation is enough to denote the continuation. I dig it. The Nushell book examples have commands returning a single variable, but that was before 0.72 gave us early returns. Should that be the new syntax? I think it's more clear, and I err on the side of clarity (which you can likely tell by the length of my variable names).

JT uploaded a Nushell update vid also! I love how they clarify intent, and I wish they'd upload more Nushell content. I still have to go back to the vid where they build that cool PNG script. That's coming up as a use case for me; I need to decode and build Corel Draw files, and they're grossly proprietary, so it'll be fun to reverse engineer with Nushell.

- [Solution to day 6](https://github.com/UliTroyo/advent-of-code/blob/main/2022/day-06.nu)
