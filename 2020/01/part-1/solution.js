const rl = require('readline').createInterface({
    input: require('fs').createReadStream('input.txt'),
    crlfDelay: Infinity
});
const s = new Set;

async function find() {
    for await (let n of rl) {
        if (n = n.trim()) {
            s.add(n);
            const complement = 2020 - parseInt(n);
            if (s.has(complement.toString())) {
                console.log({ n, complement });
                return n * complement;
            }
        }
    }
}


find().then(console.log);
