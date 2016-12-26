var vfs = window.localStorage;

var Storage = {
    get: function getSaves(key) {
        var n = vfs.length;
        var saves = [];
        var k;
        var item;
        for (var i = 0; i < n; i++) {
            k = vfs.key(i);
            try {
                item = JSON.parse(vfs.getItem(k));
            } catch (e) {
                item = {timestamp: null};
            }
            item.id = k;
            if (key) {
                if (k.indexOf(key + '-save-') === 0) {
                    saves.push(item);
                }
            } else {
                saves.push(item);
            }
        }
        return saves;
    },
    save: function save(name, value) {
        vfs.setItem(name, JSON.stringify({
            timestamp: Date.now(),
            data: value
        }));
    },
    load: function load(name) {
        var content = JSON.parse(vfs.getItem(name));
        if (content) {
            return content.data;
        }
        return '';
    },
    exists: function exists(name) {
        return !!vfs.getItem(name);
    },
    clear: function clear() {
        vfs.clear();
    }
};

module.exports = Storage;
