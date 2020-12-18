=begin
--- Part Two ---
You manage to answer the child's questions and they finish part 1 of their homework, but get stuck when they reach the next section: advanced math.

Now, addition and multiplication have different precedence levels, but they're not the ones you're familiar with. Instead, addition is evaluated before multiplication.

For example, the steps to evaluate the expression 1 + 2 * 3 + 4 * 5 + 6 are now as follows:

1 + 2 * 3 + 4 * 5 + 6
  3   * 3 + 4 * 5 + 6
  3   *   7   * 5 + 6
  3   *   7   *  11
     21       *  11
         231
Here are the other examples from above:

1 + (2 * 3) + (4 * (5 + 6)) still becomes 51.
2 * 3 + (4 * 5) becomes 46.
5 + (8 * 3 + 9 + 3 * 4 * 3) becomes 1445.
5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4)) becomes 669060.
((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2 becomes 23340.
What do you get if you add up the results of evaluating the homework problems using these new rules?
=end

def parse_expression(expression)
  current_number = ""
  tokens = expression.each_char.reject { |c| c == " " }.reduce([]) do |parsed, char|
    case char
    when "(", ")", "+", "*"
      # Flush current number string
      if current_number != ""
        parsed << current_number.to_i
        current_number = ""
      end
      parsed << char
    else
      # A number
      current_number += char
    end
    parsed
  end

  tokens << current_number.to_i if current_number != ""
  tokens
end

def apply_operation(op, l1, l2)
  case op
  when "+"
    l1 + l2
  when "*"
    l1 * l2
  end
end

def solve_tokenized_expression(tokens)
  literals_stack = []
  operator_stack = []
  depth = 0

  sub_expression = []

  # Simplify sub-expressions (brackets)
  tokens.each do |token|
    case token
    when "("
      if depth > 0
        sub_expression << token
      end
      depth += 1
    when ")"
      depth -= 1
      if depth == 0
        result = solve_tokenized_expression(sub_expression)
        sub_expression = []

        # Evaluate addition greedily
        if literals_stack.size > 0 && operator_stack.last == "+"
          op = operator_stack.pop
          l1 = literals_stack.pop
          result = apply_operation(op, l1, result)
          literals_stack << result
        else
          literals_stack << result
        end
      else
        sub_expression << token
      end
    when "+", "*"
      if depth == 0
        operator_stack << token
      else
        sub_expression << token
      end
    else
      # A number literal
      if depth == 0
        # Evaluate addition greedily
        if literals_stack.size > 0 && operator_stack.last == "+"
          op = operator_stack.pop
          l1 = literals_stack.pop
          result = apply_operation(op, l1, token)
          literals_stack << result
        else
          literals_stack << token
        end
      else
        sub_expression << token
      end
    end
  end

  # We should have only multiplication left now
  while literals_stack.size > 1
    op = operator_stack.shift
    l1 = literals_stack.shift
    l2 = literals_stack.shift
    # p [op, l1, l2, apply_operation(op, l1, l2)]
    literals_stack.unshift(apply_operation(op, l1, l2))
  end

  literals_stack.pop
end

def solve_expression(expression)
  tokens = parse_expression(expression)
  solve_tokenized_expression(tokens)
end


solutions = File.readlines("input.txt").map { |line| solve_expression(line.chomp) }
p solutions.sum
