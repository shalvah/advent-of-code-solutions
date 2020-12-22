=begin
--- Part Two ---
Now that you've isolated the inert ingredients, you should have enough information to figure out which ingredient contains which allergen.

In the above example:

mxmxvkd contains dairy.
sqjhc contains fish.
fvjkl contains soy.
Arrange the ingredients alphabetically by their allergen and separate them by commas to produce your canonical dangerous ingredient list. (There should not be any spaces in your canonical dangerous ingredient list.) In the above example, this would be mxmxvkd,sqjhc,fvjkl.

Time to stock your raft with supplies. What is your canonical dangerous ingredient list?
=end

require 'set'

def parse_equations(input)
  input.each_line.map do |line|
    ingredients, allergens = line.match(/(.+)\s\(contains (.+)\)/).captures
    ingredients = ingredients.split
    allergens = allergens.split(", ")
    [ingredients, allergens]
  end.to_h
end

def parse_allergen_possibilities(input)
  possibilities = {}
  input.each_line.each do |line|
    ingredients, allergens = line.match(/(.+)\s\(contains (.+)\)/).captures
    ingredients = ingredients.split
    allergens = allergens.split(", ")
    allergens.each do |allergen|
      possibilities[allergen] ||= []
      possibilities[allergen] << ingredients
    end
  end
  possibilities
end

def find(allergen_possibilities)
  solved_ingredients = {}
  unsolved = []

  while allergen_possibilities.size > 0 do
    updated_possibilities = allergen_possibilities.clone
    allergen_possibilities.each do |allergen, ingredient_sets|
      common_ingredients = ingredient_sets[0].intersection(*ingredient_sets.slice(1...ingredient_sets.size))
      if common_ingredients.size == 1
        solved_ingredients[common_ingredients[0]] = allergen
        updated_ingredient_sets = ingredient_sets.map do |ingredients|
          ingredients.delete(common_ingredients[0])
          ingredients
        end

        if updated_ingredient_sets.size > 0
          updated_ingredient_sets.each do |ingredients|
            unsolved.append(*ingredients)
          end
        end

        updated_possibilities.delete(allergen)
      end

      allergen_possibilities = updated_possibilities.clone.map do |allergen, ingredient_sets|
        ingredient_sets = ingredient_sets.map do |ingredients|
          solved = ingredients.select { |item| solved_ingredients.include?(item) }
          solved.each { |item| ingredients.delete(item) }
          ingredients
        end
        [allergen, ingredient_sets]
      end.to_h

    end
  end
  unsolved = Set.new(unsolved.select { |ingredient| !solved_ingredients.include?(ingredient) })

  [solved_ingredients, unsolved]
end

input = File.read("input2.txt")
equations = parse_equations(input)
solved_ingredients, unsolved = find(parse_allergen_possibilities(input))
unsolved_ingredients = unsolved.map do |ingredient|
  equations.select { |ingredients, allergens| ingredients.include?(ingredient) }.count
end

list = solved_ingredients.sort_by { |ingr, allr| allr }.map { |(ingr, allr)| ingr}.join(",")

p list
