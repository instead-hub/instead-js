var Logger = require('./log');
var HTMLAudio = {
    track: null,
    audio: null,
    isMuted: false,
    playMusic: function play(track, loop, onEndCallback) {
        if (!track.match(/(mp3|ogg|wav)$/) && !track.match(/^blob:/)) {
            console.log('Unsupported music format:' + track); // eslint-disable-line no-console
            Logger.log('{warning} Unsupported music format:' + track); // eslint-disable-line no-console
            return;
        }
        if (track !== this.track) {
            // stop previous music
            this.stopMusic();
            // start new track
            this.audio = new Audio(track);
            this.track = track;
            this.audio.autoplay = true;
            this.audio.muted = this.isMuted;
            this.play(this.audio, loop);
            this.audio.addEventListener('ended', function cb() {
                onEndCallback(track);
            });
        }
    },
    stopMusic: function stop() {
        if (this.audio) {
            this.audio.pause();
            this.audio = null;
            this.track = null;
        }
    },
    playSound: function playSound(track, loop, cache) {
        var audio = new Audio(track);
        audio.muted = this.isMuted;
        if (cache) {
            audio.muted = true;
        }
        this.play(audio, loop);
    },
    play: function play(audio, loop) {
        if (loop === 0) {
            audio.addEventListener('ended', function restartAudio() {
                this.currentTime = 0;
                this.play();
            }, false);
            audio.play();
        } else if (loop > 0) {
            for (var i = 0; i < loop; i++) {
                audio.play();
            }
        } else {
            audio.play();
        }
    },
    mute: function muteAudio(m) {
        if (this.audio) {
            this.audio.muted = m;
        }
        this.isMuted = m;
    }
};

module.exports = HTMLAudio;
