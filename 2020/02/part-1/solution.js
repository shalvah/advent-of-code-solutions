const rl = require('readline').createInterface({
    input: require('fs').createReadStream('input.txt'),
    crlfDelay: Infinity
});

async function find() {
    let valid = 0;
    for await (const l of rl) {
        let [number, letter, password] = l.split(' ');
        let [lower, upper] = number.split("-");
        letter = letter[0];
        const occurrences = (password.match(new RegExp(letter, "g")) || []).length;
        if (lower <= occurrences && occurrences <= upper) {
            console.log({ number, letter, password });
            valid++;
        }
    }
    return valid;
}


find().then(console.log);
