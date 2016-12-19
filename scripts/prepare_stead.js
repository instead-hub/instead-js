var fs = require('fs');

var dirname = './instead/git/instead/stead/';
var output = {};

function loadFile(dir, filename) {
    if (filename.indexOf('\.lua') !== -1) {
        output[filename] = fs.readFileSync(dir + filename, 'utf-8');
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
