var vfs = window.localStorage;

var Storage = {
    get: function getSaves(key) {
        var n = vfs.length;
        var saves = [];
        var k;
        for (var i = 0; i < n; i++) {
            k = vfs.key(i);
            if (key) {
                if (k.indexOf(key + '-save-') === 0) {
                    saves.push(k);
                }
            } else {
                saves.push(k);
            }
        }
        return saves;
    },
    save: function save(name, value) {
        vfs.setItem(name, value);
    },
    load: function load(name) {
        var content = vfs.getItem(name);
        return content;
    },
    exists: function exists(name) {
        return !!vfs.getItem(name);
    },
    clear: function clear() {
        vfs.clear();
    }
};

module.exports = Storage;
