const rl = require('readline').createInterface({
    input: require('fs').createReadStream('input.txt'),
    crlfDelay: Infinity
});

async function find() {
    let valid = 0;
    for await (const l of rl) {
        let [numbers, letter, password] = l.split(' ');
        let [p1, p2] = numbers.split("-");
        letter = letter[0];
        
        if (password[p1 - 1] == letter && password[p2 - 1] != letter) {
            console.log({ numbers, letter, password });
            valid++;
        }
        
        if (password[p2 - 1] == letter && password[p1 - 1] != letter) {
            console.log({ numbers, letter, password });
            valid++;
        }
    }
    return valid;
}


find().then(console.log);
