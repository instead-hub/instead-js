var fs = require('fs');

var dirname = './instead/stead/';
var outputDir = './instead/';
var output = {};
var outputFileContent = '';


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
    loadFile('./src/lua/', 'instead_js.lua');

    outputFileContent = 'var stead = ' + JSON.stringify(output) + ';\n' +
                      'module.exports = stead;\n';
    fs.writeFile(outputDir + 'stead.js', outputFileContent, {flag: 'w'});
});
