var fs = require('fs');

var insteadFs = fs.readFileSync('./src/lua/instead_fs.lua', 'utf-8');
var insteadJs = fs.readFileSync('./src/lua/instead_js.lua', 'utf-8');
var outputFileContent = 'var stead={};' +
    'stead["instead_js.lua"]=' + JSON.stringify(insteadJs) + ';' +
    'stead["instead_fs.lua"]=' + JSON.stringify(insteadFs) + ';' +
    'module.exports=stead;';

fs.writeFile('./instead/stead.js', outputFileContent, {flag: 'w'});
