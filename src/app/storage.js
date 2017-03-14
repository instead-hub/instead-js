var mfs = window.localStorage;

var Storage = {
    get: function getSaves(key) {
        var n = mfs.length;
        var saves = [];
        var k;
        var item;
        for (var i = 0; i < n; i++) {
            k = mfs.key(i);
            try {
                item = JSON.parse(mfs.getItem(k));
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
        mfs.setItem(name, JSON.stringify({
            timestamp: Date.now(),
            data: value
        }));
    },
    load: function load(name) {
        var content = JSON.parse(mfs.getItem(name));
        if (content) {
            return content.data;
        }
        return '';
    },
    exists: function exists(name) {
        if (!name) {
            return false;
        }
        return !!mfs.getItem(name);
    },
    clear: function clear() {
        mfs.clear();
    }
};

module.exports = Storage;
