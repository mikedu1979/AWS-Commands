let fs = require('fs');
let source = process.argv[2], destination = process.argv[3], creating = process.argv[4];
if(!creating || !fs.existsSync(destination)){
    let data = fs.readFileSync(source, 'utf-8');
    fs.writeFileSync(destination, data);
}