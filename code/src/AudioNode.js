export class AudioNode {
    constructor(srcURL, audioCtx, element)
    {
        this.audioCtx = audioCtx;
        this.element = element;

        // Modifiable (public) vars
        this.playing = false;
        this.volume = 0.25;
        this.loaded = 0; // 0 = initial, 1 = loading started, 2 = data fetch complete, 3 = audio source node created, 4 = amplified audio node created, 5 = audio playback ready
    
        // Audio Source Data
        this.src = srcURL;
        this.data = new ArrayBuffer();

        // Audio Elements
        this.source; // the source audio element that emits the sound specified at the source
        this.noise; // intermediate GainNode to control volume, connects to the destination node to actually produce the sound

        // Event Listeners for initialization and shutdown
        //document.addEventListener('DOMContentLoaded', () => this.load());
        window.addEventListener('beforeunload', () => this.shutdown());
    }

    async load()
    {
        this.loaded = 1;
        this.element.style.backgroundColor = "#8800cc";

        const response = await fetch(this.src);
        const raw = await response.arrayBuffer();
        this.loaded = 2;

        this.data = await this.audioCtx.decodeAudioData(raw);
        this.source = await this.audioCtx.createBufferSource();
        this.source.buffer = this.data;
        this.source.loop = true;
        this.loaded = 3;

        this.noise = await this.audioCtx.createGain();
        this.noise.gain.setValueAtTime(this.volume, this.audioCtx.currentTime);
        await this.source.connect(this.noise);
        await this.noise.connect(this.audioCtx.destination);
        this.loaded = 4;

        await this.source.start(); // playback cant start until user interaction
        await this.noise.disconnect();
        this.loaded = 5;

        console.debug(`${this.src} - Finished loading data for AudioNode`);
    }

    async play()
    {
        if(this.loaded == 0)
        {
            await this.load();
        }

        if(this.loaded == 5)
        {
            this.element.style.backgroundColor = "#999999";
            await this.noise.connect(this.audioCtx.destination);
            this.playing = true;
            console.debug(`${this.src} - Started Playback of AudioNode`);
        }
    }

    async stop()
    {
        if(this.loaded == 0)
        {
            await this.load();
        }

        if(this.loaded == 5)
        {
            this.element.style.backgroundColor = "#555555";
            this.noise.disconnect();
            this.playing = false;
            console.debug(`${this.src} - Halted Playback of AudioNode`);
        }
    }

    async toggle()
    {
        if(this.playing == false)
        {
            await this.play();
        }
        else
        {
            await this.stop();
        }
        window.URIsaver.save();
    }

    async adjustVolume(newVolume)
    {
        this.volume = newVolume;
        this.noise.gain.setValueAtTime(this.volume, this.audioCtx.currentTime);
        // execution of window.URIsaver.save(); done by a seperate "onchange" event listener
    }

    async shutdown()
    {
        if(this.loaded > 0)
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
                this.noise.disconnect();
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
}
