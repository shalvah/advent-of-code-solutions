=begin
--- Day 18: Operation Order ---
As you look out the window and notice a heavily-forested continent slowly appear over the horizon, you are interrupted by the child sitting next to you. They're curious if you could help them with their math homework.

Unfortunately, it seems like this "math" follows different rules than you remember.

The homework (your puzzle input) consists of a series of expressions that consist of addition (+), multiplication (*), and parentheses ((...)). Just like normal math, parentheses indicate that the expression inside must be evaluated before it can be used by the surrounding expression. Addition still finds the sum of the numbers on both sides of the operator, and multiplication still finds the product.

However, the rules of operator precedence have changed. Rather than evaluating multiplication before addition, the operators have the same precedence, and are evaluated left-to-right regardless of the order in which they appear.

For example, the steps to evaluate the expression 1 + 2 * 3 + 4 * 5 + 6 are as follows:

1 + 2 * 3 + 4 * 5 + 6
  3   * 3 + 4 * 5 + 6
      9   + 4 * 5 + 6
         13   * 5 + 6
             65   + 6
                 71
Parentheses can override this order; for example, here is what happens if parentheses are added to form 1 + (2 * 3) + (4 * (5 + 6)):

1 + (2 * 3) + (4 * (5 + 6))
1 +    6    + (4 * (5 + 6))
     7      + (4 * (5 + 6))
     7      + (4 *   11   )
     7      +     44
            51
Here are a few more examples:

2 * 3 + (4 * 5) becomes 26.
5 + (8 * 3 + 9 + 3 * 4 * 3) becomes 437.
5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4)) becomes 12240.
((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2 becomes 13632.
Before you can help with the homework, you need to understand it yourself. Evaluate the expression on each line of the homework; what is the sum of the resulting values?
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
        literals_stack << result
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
          literals_stack << token
      else
        sub_expression << token
      end
    end
  end

  # Evaluate left to right
  while literals_stack.size > 1
      op = operator_stack.shift
      l1 = literals_stack.shift
      l2 = literals_stack.shift
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
