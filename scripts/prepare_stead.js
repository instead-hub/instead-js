var fs = require('fs');

var dirname = './instead/git/instead/stead/';
var output = {};

function loadFile(dir, filename) {
    var fc;
    if (filename.indexOf('\.lua') !== -1) {
        fc = fs.readFileSync(dir + filename, 'utf-8');
        fc = fc.replace(/(\t+)/g, '');
        fc = fc.replace(/(\n+)/g, '\n');
        output[filename] = fc;
    }
}

fs.readdir(dirname, function readFn(err, filenames) {
    if (err) {
        return;
    }
    filenames.forEach( function processFn(filename) {
        loadFile(dirname, filename);
    });
    fs.writeFile('./instead/stead_lua.json',  JSON.stringify(output), {flag: 'w'});
});
