const rl1 = require('readline').createInterface({
    input: require('fs').createReadStream('test.txt'),
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
