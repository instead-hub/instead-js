function ajaxGet(sQuery, callback, bSynchronous) {
    var bAsync = true;
    if (bSynchronous) {
        bAsync = false;
    }
    var client = new XMLHttpRequest();
    client.onreadystatechange = function callbackHandler() {
        if (this.readyState === this.DONE) {
            if (this.status === 200) {
                callback(this.responseText);
            } else {
                callback(null, this.status);
            }
        }
    };
    client.open('GET', sQuery, bAsync);
    client.send();
}

function ajaxGetSync(url) {
    var data;
    ajaxGet(url, function loadCallback(response) {
        data = response;
    }, true);
    return data;
}

module.exports = ajaxGetSync;
