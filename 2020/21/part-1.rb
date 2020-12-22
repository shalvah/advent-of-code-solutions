=begin
--- Day 21: Allergen Assessment ---
You reach the train's last stop and the closest you can get to your vacation island without getting wet. There aren't even any boats here, but nothing can stop you now: you build a raft. You just need a few days' worth of food for your journey.

You don't speak the local language, so you can't read any ingredients lists. However, sometimes, allergens are listed in a language you do understand. You should be able to use this information to determine which ingredient contains which allergen and work out which foods are safe to take with you on your trip.

You start by compiling a list of foods (your puzzle input), one food per line. Each line includes that food's ingredients list followed by some or all of the allergens the food contains.

Each allergen is found in exactly one ingredient. Each ingredient contains zero or one allergen. Allergens aren't always marked; when they're listed (as in (contains nuts, shellfish) after an ingredients list), the ingredient that contains each listed allergen will be somewhere in the corresponding ingredients list. However, even if an allergen isn't listed, the ingredient that contains that allergen could still be present: maybe they forgot to label it, or maybe it was labeled in a language you don't know.

For example, consider the following list of foods:

mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)
The first food in the list has four ingredients (written in a language you don't understand): mxmxvkd, kfcds, sqjhc, and nhms. While the food might contain other allergens, a few allergens the food definitely contains are listed afterward: dairy and fish.

The first step is to determine which ingredients can't possibly contain any of the allergens in any food in your list. In the above example, none of the ingredients kfcds, nhms, sbzzf, or trh can contain an allergen. Counting the number of times any of these ingredients appear in any ingredients list produces 5: they all appear once each except sbzzf, which appears twice.

Determine which ingredients cannot possibly contain any of the allergens in your list. How many times do any of those ingredients appear?
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
p unsolved_ingredients.sum
