/**
--- Part Two ---
The Elves in accounting are thankful for your help; one of them even offers you a starfish coin they had left over from a past vacation. They offer you a second one if you can find three numbers in your expense report that meet the same criteria.

Using the above example again, the three entries that sum to 2020 are 979, 366, and 675. Multiplying them together produces the answer, 241861950.

In your expense report, what is the product of the three entries that sum to 2020?
*/

const rl1 = require('readline').createInterface({
    input: require('fs').createReadStream('input.txt'),
    crlfDelay: Infinity
});
const r = new Map;

async function find() {
    for await (let n of rl1) {
        if (n = n.trim()) {
            const complement1 = 2020 - parseInt(n);
            for (let m of r.keys()) {
                const complement2 = complement1 - parseInt(m);
                let occurrences = r.get(complement2.toString());
                if (
                    (complement2 == parseInt(n) && occurrences > 1)
                    || (complement2 == parseInt(m) && occurrences > 1)
                    || (!([m, n].includes(`${complement2}`)) && occurrences == 1)
                ) {
                    console.log({ n, m, complement2 });
                    return n * m * complement2;
                }
            }
            r.set(n, (r.get(n) || 0) + 1);
        }
    }
}


find().then(console.log);
