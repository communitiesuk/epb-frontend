const decomment = require('decomment');
const fs = require('node:fs');

const [inFile, outFile] = process.argv.slice(2);

fs.writeFileSync(outFile, decomment(fs.readFileSync(inFile).toString()));
