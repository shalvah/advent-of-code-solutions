=begin
--- Part Two ---
As you look over the list of messages, you realize your matching rules aren't quite right. To fix them, completely replace rules 8: 42 and 11: 42 31 with the following:

8: 42 | 42 8
11: 42 31 | 42 11 31
This small change has a big impact: now, the rules do contain loops, and the list of messages they could hypothetically match is infinite. You'll need to determine how these changes affect which messages are valid.

Fortunately, many of the rules are unaffected by this change; it might help to start by looking at which rules always match the same set of values and how those rules (especially rules 42 and 31) are used by the new versions of rules 8 and 11.

(Remember, you only need to handle the rules you have; building a solution that could handle any hypothetical combination of rules would be significantly more difficult.)

For example:

42: 9 14 | 10 1
9: 14 27 | 1 26
10: 23 14 | 28 1
1: "a"
11: 42 31
5: 1 14 | 15 1
19: 14 1 | 14 14
12: 24 14 | 19 1
16: 15 1 | 14 14
31: 14 17 | 1 13
6: 14 14 | 1 14
2: 1 24 | 14 4
0: 8 11
13: 14 3 | 1 12
15: 1 | 14
17: 14 2 | 1 7
23: 25 1 | 22 14
28: 16 1
4: 1 1
20: 14 14 | 1 15
3: 5 14 | 16 1
27: 1 6 | 14 18
14: "b"
21: 14 1 | 1 14
25: 1 1 | 1 14
22: 14 14
8: 42
26: 14 22 | 1 20
18: 15 15
7: 14 5 | 1 21
24: 14 1

abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
bbabbbbaabaabba
babbbbaabbbbbabbbbbbaabaaabaaa
aaabbbbbbaaaabaababaabababbabaaabbababababaaa
bbbbbbbaaaabbbbaaabbabaaa
bbbababbbbaaaaaaaabbababaaababaabab
ababaaaaaabaaab
ababaaaaabbbaba
baabbaaaabbaaaababbaababb
abbbbabbbbaaaababbbbbbaaaababb
aaaaabbaabaaaaababaa
aaaabbaaaabbaaa
aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
babaaabbbaaabaababbaabababaaab
aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
Without updating rules 8 and 11, these rules only match three messages: bbabbbbaabaabba, ababaaaaaabaaab, and ababaaaaabbbaba.

However, after updating rules 8 and 11, a total of 12 messages match:

bbabbbbaabaabba
babbbbaabbbbbabbbbbbaabaaabaaa
aaabbbbbbaaaabaababaabababbabaaabbababababaaa
bbbbbbbaaaabbbbaaabbabaaa
bbbababbbbaaaaaaaabbababaaababaabab
ababaaaaaabaaab
ababaaaaabbbaba
baabbaaaabbaaaababbaababb
abbbbabbbbaaaababbbbbbaaaababb
aaaaabbaabaaaaababaa
aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
After updating rules 8 and 11, how many messages completely match rule 0?
=end

require 'set'

# We'll evaluate the requested rule and generate all valid matches
# Then check if each message is within the list

def parse_rule(rule)
  parsed = {}
  if (match = rule.match(/^"(?<char>\w)"$/))
    parsed[:match] = match[:char]
  elsif rule.include?("|")
    parsed[:or] = rule.split("|").map(&:split)
  else
    parsed[:and] = rule.split
  end
  parsed
end

def generate_matches(rules, rule_number)
  rule_to_evaluate = rules[rule_number]
  parsed = parse_rule(rule_to_evaluate)

  if parsed[:match]
    return [parsed[:match]]
  elsif parsed[:and]
    matches = []
    parsed[:and].each do |dependent_rule|
      dependent_matches = generate_matches(rules, dependent_rule)
      if matches.empty?
        matches = dependent_matches
      else
        gen = []
        matches.each do |match|
          dependent_matches.each do |dm|
            gen << (match + dm)
          end
        end
        matches = gen
      end
    end
    matches
  elsif parsed[:or]
    matches = parsed[:or].flat_map do |dependent_ruleset|
      sub_matches = []
      dependent_ruleset.each do |dependent_rule|
        dependent_matches = generate_matches(rules, dependent_rule)
        if sub_matches.empty?
          sub_matches = dependent_matches
        else
          gen = []
          sub_matches.each do |match|
            dependent_matches.each do |dm|
              gen << (match + dm)
            end
          end
          sub_matches = gen
        end
      end
      sub_matches
    end
  end
end


rules, messages = File.read("input.txt").split("\n\n")
rules = rules.lines.map { |line| line.chomp.split(": ") }.to_h
matches = Set.new generate_matches(rules, "0")
messages = messages.split("\n")
matching_messages = messages.select { |message| matches.include?(message) }
original_matching = matching_messages.count
messages -= matching_messages

# Changing:
# Rule "8" = "42 | 42 8"
# Rule "11" = "42 31 | 42 11 31"
# Rule 8 translates to X, or XX, or XXX, or XXXX... = itself n times, where X is any match(42)
# Rule 11 translates to XY or XXYY or XXXYYY...= X k times, Y k times, where X is any match(42) and Y is any match(31)

matches_42 = generate_matches(rules, "42")
length_of_42_match = matches_42[0].size # All 42-matches have the same length (by inspection)
matches_42 = Set.new(matches_42)
matches_31 = generate_matches(rules, "31")
length_of_31_match = matches_31[0].size # All 31-matches have the same length (by inspection)
matches_31 = Set.new(matches_31)

# Then Rule 0 is "8 11", which means both must match.
# XnWkYk where X and W are matches of 42 (they don't have to be the same match)

rule_42_regex = "((\\w{#{length_of_42_match}}){2,})" # X must appear at least twice
rule_31_regex = "(\\w{#{length_of_31_match}})+"
rule_0_regex = Regexp.new("^#{rule_42_regex}#{rule_31_regex}$")

matching = messages.select do |message|
  is_valid = false
  if message.match(rule_0_regex)
    all_matches = message.scan(Regexp.new(".{#{length_of_42_match}}"))

    checking_31 = false
    matches_for_42 = []
    matches_for_31 = []
    has_matches = all_matches.each_with_index do |match, index|
      # Last item must always be checked against 31
      if index == all_matches.size - 1
        if (matches_31.include?(match))
          matches_for_31 << match
          break true
        else
          break false
        end
      end
      if checking_31
        if matches_31.include?(match)
          matches_for_31 << match
        else
          break false
        end
      else
        # We're checking 42
        if matches_42.include?(match)
          matches_for_42 << match
        else
          # Once we reach the first non-42, we switch to checking for 31
          if matches_31.include?(match)
            matches_for_31 << match
            checking_31 = true
          else
            break false
          end
        end
      end
    end

    if has_matches == true
      is_valid = matches_for_42.size > matches_for_31.size
    else
      is_valid = false
    end
  end
  is_valid == false ? false : true
end

p original_matching
p original_matching + matching.size
