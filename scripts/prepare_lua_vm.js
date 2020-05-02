var fs = require('fs');

var lua = fs.readFileSync('./instead/git/weblua/src/lua.vm.js', 'utf-8');
var outputFileContent = '(function(){' + lua + '})();';
fs.writeFileSync('./instead/lua.vm.js', outputFileContent, {flag: 'w'});
