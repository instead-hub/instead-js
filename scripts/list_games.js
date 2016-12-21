var fs = require('fs');

var dirname = './games/';
var output = {};

function getGameName(path) {
    var game = fs.readFileSync(path + '/main.lua', 'utf-8');
    var name = game.match(/\$Name:(.+)\$/);
    if (name) {
        return name[1].trim();
    }
    return null;
}

fs.readdir(dirname, function readFn(err, filenames) {
    if (err) {
        return;
    }
    filenames.forEach(function processFn(filename) {
        var path = dirname + filename;
        var gameName;
        if (fs.lstatSync(path).isDirectory()) {
            gameName = getGameName(path);
            if (gameName) {
                output[filename] = gameName;
            }
        }
    });
    fs.writeFile(dirname + 'games_list.json',  JSON.stringify(output), {flag: 'w'});
});
