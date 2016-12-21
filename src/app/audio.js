var HTMLAudio = {
    track: null,
    audio: null,
    isMuted: false,
    playMusic: function play(track, loop) {
        if (track !== this.track && this.audio) {
            // stop previous music
            this.audio.pause();
            this.audio = null;
        }
        if (track !== this.track) {
            // start new track
            this.audio = new Audio(track);
            this.track = track;
            this.audio.autoplay = true;
            this.audio.muted = this.isMuted;
            this.play(this.audio, loop);
        }
    },
    stopMusic: function stop() {
        if (this.audio) {
            this.audio.pause();
            this.audio = null;
        }
    },
    playSound: function playSound(track, loop) {
        var audio = new Audio(track);
        this.play(audio, loop);
    },
    play: function play(audio, loop) {
        if (loop === 0) {
            // audio.loop = true;
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
