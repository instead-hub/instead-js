var fs = require('fs');

var dirname = './games/';
var output = {};

function getGameName(gamepath) {
    var game = fs.readFileSync(gamepath + '/main.lua', 'utf-8');
    var name = game.match(/\$Name\(ru\):(.+)\$/);
    if (name) {
        return name[1].trim();
    }
    name = game.match(/\$Name:(.+)\$/);
    if (name) {
        return name[1].trim();
    }
    return null;
}

function walkSync(dir, filelist, gamedir) {
    var files = filelist;
    fs.readdirSync(dir).forEach(function readDir(file) {
        var fullpath = dir + '/' + file;
        if (fs.statSync(fullpath).isDirectory()) {
            files = walkSync(fullpath, files, gamedir);
        } else if (file.match(/(jpg|jpeg|png|gif|bmp|tiff|tif)$/i)) {
            files.push(fullpath.replace(gamedir + '/', ''));
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
        var hasTheme = false;
        if (fs.lstatSync(gamepath).isDirectory()) {
            gameName = getGameName(gamepath);
            if (gameName) {
                images = walkSync(gamepath, [], gamepath);
                if (fs.existsSync(gamepath + '/theme.ini')) {
                    hasTheme = true;
                }
                output[filename] = {
                    name: gameName,
                    theme: hasTheme,
                    preload: images
                };
            }
        }
    });
    fs.writeFile(dirname + 'games_list.json',  JSON.stringify(output), {flag: 'w'});
});
