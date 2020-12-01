const rl = require('readline').createInterface({
    input: require('fs').createReadStream('input.txt'), // same input as Part 1
    crlfDelay: Infinity
});
const s = new Set;

async function find() {
    for await (let n of rl) {
        if (n = n.trim()) {
            s.add(n);
            const complement1 = 2020 - parseInt(n);
            for (let m of s) {
                const complement2 = complement1 - parseInt(m);
                if (s.has(complement2.toString())) {
                    console.log({ n, m, complement2 });
                    return n * m * complement2;
                }
            }
        }
    }
}


find().then(console.log);
