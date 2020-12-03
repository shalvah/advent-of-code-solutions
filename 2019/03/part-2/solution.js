/**
-- Part Two ---
It turns out that this circuit is very timing-sensitive; you actually need to minimize the signal delay.

To do this, calculate the number of steps each wire takes to reach each intersection; choose the intersection where the sum of both wires' steps is lowest. If a wire visits a position on the grid multiple times, use the steps value from the first time it visits that position when calculating the total value of a specific intersection.

The number of steps a wire takes is the total number of grid squares the wire has entered to get to that location, including the intersection being considered. Again consider the example from above:

...........
.+-----+...
.|.....|...
.|..+--X-+.
.|..|..|.|.
.|.-X--+.|.
.|..|....|.
.|.......|.
.o-------+.
...........
In the above example, the intersection closest to the central port is reached after 8+5+5+2 = 20 steps by the first wire and 7+6+4+3 = 20 steps by the second wire for a total of 20+20 = 40 steps.

However, the top-right intersection is better: the first wire takes only 8+5+2 = 15 and the second wire takes only 7+6+2 = 15, a total of 15+15 = 30 steps.

Here are the best steps for the extra examples from above:

R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83 = 610 steps
R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
U98,R91,D20,R16,D67,R40,U7,R15,U6,R7 = 410 steps
What is the fewest combined steps the wires must take to reach an intersection?
*/



let input = require('fs').readFileSync('input.txt', 'utf8');
const [path1, path2] = input.split("\n");
const wire1Position = { x: 0, y: 0, steps: 0 };
const wire1Positions = new Map;
const wire2Position = { x: 0, y: 0, steps: 0 };

const intersections = [];

async function find() {
    for (let instruction of path1.split(',')) {
        const delta = parseInt(instruction.slice(1));
        switch (instruction[0]) {
            case 'R': {
                for (let i = 1; i <= delta; i++) {
                    wire1Position.x += 1;
                    wire1Position.steps += 1;
                    recordPosition(wire1Position);
                }
                break;
            }
            case 'U': {
                for (let i = 1; i <= delta; i++) {
                    wire1Position.y += 1;
                    wire1Position.steps += 1;
                    recordPosition(wire1Position);
                }
                break;
            }
            case 'L': {
                for (let i = 1; i <= delta; i++) {
                    wire1Position.x -= 1;
                    wire1Position.steps += 1;
                    recordPosition(wire1Position);
                }
                break;
            }
            case 'D': {
                for (let i = 1; i <= delta; i++) {
                    wire1Position.y -= 1;
                    wire1Position.steps += 1;
                    recordPosition(wire1Position);
                }
                break;
            }
        }
    }

    for (let instruction of path2.split(',')) {
        const delta = parseInt(instruction.slice(1));
        switch (instruction[0]) {
            case 'R': {
                for (let i = 1; i <= delta; i++) {
                    wire2Position.x += 1;
                    wire2Position.steps += 1;
                    recordIntersectionIfExists(wire2Position);
                }
                break;
            }
            case 'U': {
                for (let i = 1; i <= delta; i++) {
                    wire2Position.y += 1;
                    wire2Position.steps += 1;
                    recordIntersectionIfExists(wire2Position);
                }
                break;
            }
            case 'L': {
                for (let i = 1; i <= delta; i++) {
                    wire2Position.x -= 1;
                    wire2Position.steps += 1;
                    recordIntersectionIfExists(wire2Position);
                }
                break;
            }
            case 'D': {
                for (let i = 1; i <= delta; i++) {
                    wire2Position.y -= 1;
                    wire2Position.steps += 1;
                    recordIntersectionIfExists(wire2Position);
                }
                break;
            }
        }
    }

    return Math.min(...intersections);
}

function recordPosition({ x, y, steps }) {
    wire1Positions.set(x, (wire1Positions.get(x) || []).concat([{y, steps}]));
}

function recordIntersectionIfExists({ x, y, steps }) {
    const possibleYPositions = wire1Positions.get(x);
    if (possibleYPositions !== undefined) {
        for (let py of possibleYPositions) {
            if (py.y == y) {
                intersections.push(steps + py.steps);
            }
        }
    }
}

find().then(console.log);
