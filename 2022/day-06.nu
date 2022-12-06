let elf_datastream = ( open $env.PUZZLE_FILE )

def find_first_sequence_of_length [length: int] {
  let max_occurrences_per_char = ( $in | split chars | window $length --stride 1 |
    each { uniq -c | select count | math max } )
  let occurrence_list_length = ( $max_occurrences_per_char | length )
  let first_marker = ( $max_occurrences_per_char
    | merge ( seq 0 ( $occurrence_list_length - 1 ) | wrap idx ) | where count == 1 |
    first 1 | get idx.0 | $in + $length )
  $first_marker
}

let start_of_packet = ( $elf_datastream | find_first_sequence_of_length 4 )
print $start_of_packet

let start_of_message = ( $elf_datastream | find_first_sequence_of_length 14 )
print $start_of_message
