var fs = require('fs');

var dirname = './games/';
var output = {};

function matchRe(regexp, string) {
    var isMatching = string.match(regexp);
    if (isMatching) {
        return isMatching[1].trim();
    }
    return '';
}

function getGameInfo(gamepath, mainFile, gamename) {
    var gameinfo = {
        name: gamename,
        author: '',
        version: '',
        info: ''
    };
    var game = fs.readFileSync(gamepath + '/' + mainFile, 'utf-8');
    gameinfo.name = matchRe(/\$Name\(ru\)\s*:\s*([^\$\n]+)/, game);
    if (gameinfo.name === '') {
        gameinfo.name = matchRe(/\$Name\s*:\s*([^\$\n]+)/, game);
        if (gameinfo.name === '') {
            gameinfo.name = gamename;
        }
    }
    gameinfo.author = matchRe(/\$Author\s*:\s*([^\$\n]+)/, game);
    gameinfo.version = matchRe(/\$Version\s*:\s*([^\$\n]+)/, game);
    gameinfo.info = matchRe(/\$Info\s*:\s*([^\$\n]+)/, game);
    return gameinfo;
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
        var gameInfo = {};
        var images;
        var hasTheme = false;
        var stead = null;
        var mainFile;
        if (fs.lstatSync(gamepath).isDirectory()) {
            if (fs.existsSync(gamepath + '/main.lua')) {
                stead = 2; // stead 2.x
                mainFile = 'main.lua';
            }
            if (fs.existsSync(gamepath + '/main3.lua')) {
                stead = 3; // stead 3.x
                mainFile = 'main3.lua';
            }
            if (stead) {
                gameInfo = getGameInfo(gamepath, mainFile, filename);
                images = walkSync(gamepath, [], gamepath);
                if (fs.existsSync(gamepath + '/theme.ini')) {
                    hasTheme = true;
                }
                output[filename] = {
                    name: gameInfo.name,
                    details: {
                        version: gameInfo.version,
                        author: gameInfo.author,
                        info: gameInfo.info
                    },
                    stead: stead,
                    theme: hasTheme,
                    preload: images
                };
            }
        }
    });
    fs.writeFile(dirname + 'games_list.json',  JSON.stringify(output), {flag: 'w'});
});
