var fs = require('fs');

var lua = fs.readFileSync('./instead/git/weblua/src/lua.vm.js', 'utf-8');
var outputFileContent = '(function(w){var Lua={ga:{}};var z={i:function(){' + lua + '}};z.i();' +
    'Lua=z.Lua;Lua.ga.items={};Lua.ga.clear=function(a){delete Lua.ga.items[a]};' +
    'w.Lua=Lua;})(window);';
fs.writeFile('./instead/lua.vm.js', outputFileContent, {flag: 'w'});
