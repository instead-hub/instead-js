var fs = require('fs');

var dirname = './games/';
var output = {};

function getGameName(gamepath) {
    var game = fs.readFileSync(gamepath + '/main.lua', 'utf-8');
    var name = game.match(/\$Name:(.+)\$/);
    if (name) {
        return name[1].trim();
    }
    return null;
}

function walkSync(dir, filelist) {
    var files = filelist;
    fs.readdirSync(dir).forEach(function readDir(file) {
        if (fs.statSync(dir + '/' + file).isDirectory()) {
            files = walkSync(dir + '/' + file, files);
        } else if (file.match(/(jpg|jpeg|png|gif|bmp|tiff|tif)$/i)) {
            files.push(dir + '/' + file);
        }
    });
    return files;
}


fs.readdir(dirname, function readFn(err, filenames) {
    if (err) {
        return;
    }
    filenames.forEach(function processFn(filename) {
        var gamepath = dirname + filename;
        var gameName;
        var images;
        if (fs.lstatSync(gamepath).isDirectory()) {
            gameName = getGameName(gamepath);
            images = walkSync(gamepath, []);
            if (gameName) {
                output[filename] = {
                    name: gameName,
                    preload: images
                };
            }
        }
    });
    fs.writeFile(dirname + 'games_list.json',  JSON.stringify(output), {flag: 'w'});
});
