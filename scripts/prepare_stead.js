var fs = require('fs');

var dirname = './instead/git/instead/stead';
var output = {};

function loadFile(dir, filename, steaddir) {
    var fc;
    var realdir = (dir.replace(steaddir, '') + '/').replace(/^\//, '');
    if (filename.indexOf('\.lua') !== -1) {
        fc = fs.readFileSync(dir + '/' + filename, 'utf-8');
        fc = fc.replace(/(\t+)/g, '');
        fc = fc.replace(/(\n+)/g, '\n');
        output[realdir + filename] = fc;
    }
}

function walkSync(steaddir, dir, filelist) {
    var files = filelist;
    fs.readdirSync(dir).forEach(function readDir(file) {
        var fullpath = dir + '/' + file;
        if (fs.statSync(fullpath).isDirectory()) {
            files = walkSync(steaddir, fullpath, files);
        } else if (file.match(/(lua)$/i)) {
            loadFile(dir, file, steaddir);
        }
    });
    return files;
}

fs.readdir(dirname, function readFn(err, filenames) {
    if (err) {
        return;
    }
    if (fs.existsSync(dirname + '/stead3')) {
        // stead 3
        walkSync(dirname + '/stead2', dirname + '/stead2');
        fs.writeFileSync('./instead/stead2.json',  JSON.stringify(output), {flag: 'w'});
        output = {};
        walkSync(dirname + '/stead3', dirname + '/stead3');
        fs.writeFileSync('./instead/stead3.json',  JSON.stringify(output), {flag: 'w'});
    } else {
        filenames.forEach( function processFn(filename) {
            loadFile(dirname, filename, dirname);
        });
        fs.writeFileSync('./instead/stead_lua.json',  JSON.stringify(output), {flag: 'w'});
    }
});
