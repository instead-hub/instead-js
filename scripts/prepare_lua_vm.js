var fs = require('fs');

var lua = fs.readFileSync('./instead/git/weblua/src/lua.vm.js', 'utf-8');
var outputFileContent = '(function(w){var Lua={cache:{}};var z={i:function(){' + lua + '}};z.i();' +
    'Lua=z.Lua;Lua.cache.items={};Lua.cache.clear=function(a){delete Lua.cache.items[a]};' +
    'w.Lua=Lua;})(window);';
fs.writeFile('./instead/lua.vm.js', outputFileContent, {flag: 'w'});
