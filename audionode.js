export class AudioNode {
    constructor(srcURL, audioCtx)
    {
        this.audioCtx = audioCtx;

        // Modifiable (public) vars
        this.playing = false;
        this.volume = 0.5;
        this.loaded = 0; // 0 = initial, 1 = data fetch complete, 2 = audio source node created, 3 = amplified audio node created, 4 = audio playback ready
    
        // Audio Source Data
        this.src = srcURL;
        this.data = new ArrayBuffer();

        // Audio Elements
        this.source; // the source audio element that emits the sound specified at the source
        this.noise; // intermediate GainNode to control volume, connects to the destination node to actually produce the sound

        // Event Listeners for initialization and shutdown
        document.addEventListener('DOMContentLoaded', () => this.load());
        window.addEventListener('beforeunload', () => this.shutdown());
    }

    async load()
    {
        const response = await fetch(this.src);
        const raw = await response.arrayBuffer();
        console.log(raw);
        this.loaded = 1;

        this.data = await this.audioCtx.decodeAudioData(raw);
        this.source = await this.audioCtx.createBufferSource();
        this.source.buffer = this.data;
        this.source.loop = true;
        this.loaded = 2;

        this.noise = await this.audioCtx.createGain();
        this.noise.gain.setValueAtTime(this.volume, this.audioCtx.currentTime);
        await this.source.connect(this.noise);
        await this.noise.connect(this.audioCtx.destination);
        this.loaded = 3;

        console.debug(`${this.src} - Finished loading data for AudioNode`);
    }

    async play()
    {

        if(this.loaded == 3)
        {
            await this.source.start(); // playback cant start until user interaction
            await this.noise.disconnect();
            this.loaded = 4;
        }
        if(this.loaded == 4)
        {
            await this.noise.connect(this.audioCtx.destination);
            this.playing = true;
            console.debug(`${this.src} - Started Playback of AudioNode`);
        }
    }

    async stop()
    {
        this.noise.disconnect();
        this.playing = false;
        console.debug(`${this.src} - Halted Playback of AudioNode`);
    }


    async toggle()
    {
        if(!this.loaded)
        {
            return;
        }

        
        if(this.playing == false)
        {
            this.play();
        }
        else
        {
            this.stop();
        }
    }

    async adjustVolume(newVolume)
    {
        console.log(newVolume);
        this.volume = newVolume;
        this.noise.gain.setValueAtTime(this.volume, this.audioCtx.currentTime);
    }

    async shutdown()
    {
        try
        {
            this.source.stop();
        }
        catch(e)
        {
            console.error(e);
        }

        try
        {
            this.source.disconnect();
        }
        catch(e)
        {
            console.error(e);
        }

        console.debug(`${this.src} - Shutdown AudioNode`);
    }
}
