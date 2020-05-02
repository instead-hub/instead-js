var fs = require('fs');

var insteadFs = fs.readFileSync('./src/lua/instead_fs.lua', 'utf-8');
var insteadJs = fs.readFileSync('./src/lua/instead_js.lua', 'utf-8');
var insteadInit = fs.readFileSync('./src/lua/instead_init.lua', 'utf-8');
var outputFileContent = 'var stead={};' +
    'stead["instead_js.lua"]=' + JSON.stringify(insteadJs) + ';' +
    'stead["instead_fs.lua"]=' + JSON.stringify(insteadFs) + ';' +
    'stead["instead_init.lua"]=' + JSON.stringify(insteadInit) + ';' +
    'module.exports=stead;';

fs.writeFileSync('./instead/stead.js', outputFileContent, {flag: 'w'});
