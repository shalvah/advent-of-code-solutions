/**
--- Part Two ---
Time to check the rest of the slopes - you need to minimize the probability of a sudden arboreal stop, after all.

Determine the number of trees you would encounter if, for each of the following slopes, you start at the top-left corner and traverse the map all the way to the bottom:

Right 1, down 1.
Right 3, down 1. (This is the slope you already checked.)
Right 5, down 1.
Right 7, down 1.
Right 1, down 2.
In the above example, these slopes would find 2, 7, 3, 4, and 2 tree(s) respectively; multiplied together, these produce the answer 336.

What do you get if you multiply together the number of trees encountered on each of the listed slopes?
*/


let input = require('fs').readFileSync('input.txt', 'utf8');
const grid = input.split(/[^.#]+/); // Don't split by just \n; won't work on Windows
const modulus = grid[1].length;

const deltas = [
    { x: 1, y: 1 },
    { x: 3, y: 1 },
    { x: 5, y: 1 },
    { x: 7, y: 1 },
    { x: 1, y: 2 },
];
let product = 1;

async function find() {
    for (let delta of deltas) {
        let xPosition = 0;
        let yPosition = 0;
        let trees = 0;

        do {
            if (grid[yPosition][xPosition % modulus] === '#') {
                trees++;
            }

            xPosition += delta.x;
            yPosition += delta.y;
        } while (yPosition < grid.length)

        product *= trees;
    }
    
    return product;
}

find().then(console.log);
