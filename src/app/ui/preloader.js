var $ = require('jquery');

var Preloader = {
    progress: 0,
    load: function load(imgArray, callbackProgress, callbackFinished) {
        var self = this;
        imgArray.forEach(function preloadImg(image) {
            $('<img>').attr('src', image).on('load', function complete() {
                self.progress = self.progress + 1;
            });
        });
        this.calcPercent = setInterval(function updatePercent() {
            callbackProgress(Math.floor(self.progress / imgArray.length * 100));
            if (self.progress === imgArray.length) {
                clearInterval(self.calcPercent);
                callbackFinished();
            }
        }, 10);
    },
    stop: function stop() {
        this.calcPercent = null;
    }
};

module.exports = Preloader;
