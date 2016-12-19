var fs = require('fs');

var stead = fs.readFileSync('./instead/stead_lua.json', 'utf-8');
var loader = fs.readFileSync('./src/lua/instead_js.lua', 'utf-8');
var outputFileContent = 'var stead=' + stead + ';' +
    'stead["instead_js.lua"]=' + JSON.stringify(loader) + ';' +
    'module.exports=stead;';

fs.writeFile('./instead/stead.js', outputFileContent, {flag: 'w'});
