export class AudioNode {
    constructor(srcURL, audioCtx, element)
    {
        this.audioCtx = audioCtx;
        this.elements = new Array();
        this.elements.push(element); // the first element that creates this node get the first slot, additional pointers are added via `this.addPointer`

        // Modifiable (public) vars
        this.playing = false;
        this.volume = 0.25;
        this.loaded = 0; // 0 = initial, 1 = loading started, 2 = data fetch complete, 3 = audio source node created, 4 = amplified audio node created, 5 = audio playback ready
        this.error = false;
    
        // Audio Source Data
        this.src = srcURL;
        this.data = new ArrayBuffer();

        // Audio Elements
        this.source; // the source audio element that emits the sound specified at the source
        this.noise; // intermediate GainNode to control volume, connects to the destination node to actually produce the sound

        // Event Listeners for initialization and shutdown
        window.addEventListener('beforeunload', () => this.shutdown());
    }

    async load()
    {
        // start loading, change the element color
        this.loaded = 1;
        for ( var element of this.elements )
        {
            element.style.backgroundColor = "#8800cc";
        }

        // Check the file exists and is readable
        async function checkFileExists(url) {
            try {
                const response = await fetch(url, { 
                method: 'HEAD', // only do a HEAD check to reduce bandwidth usage; we only want to know if it exists
                cache: 'no-store' // Prevent caching
            });

            return response.ok; // Returns true if file exists, false otherwise
            } catch (error) {
                console.error('Error checking file:', error);
                return false;
            }
        }
        var urlok = await checkFileExists(this.src);
        if(!urlok)
        {
            this.error = true;
            console.error(`Error loading ${this.src}`);
            for (var element of this.elements)
            {
                element.style.backgroundColor = "#ff0000";
            }
            return;
        }

        // once we know the file exists, do the request via xmlHTTP for progress monitoring
        var holdVolume = this.elements[0].querySelectorAll(".SLIDER")[0].value; // save the old volume level so we can return to it
        for(var element of this.elements)
        {
            element.querySelectorAll(".SLIDER")[0].classList.add("LOCKED"); // disable pointer events
        }
        var arrayBuffer;
        var xmlHTTP = new XMLHttpRequest();
        xmlHTTP.open('GET', this.src, true);
        xmlHTTP.responseType = 'arraybuffer';
        xmlHTTP.onload = function(e) {
            arrayBuffer = this.response;
        };
        xmlHTTP.onprogress = (pr) => {
            for(var element of this.elements)
            {
                element.querySelectorAll(".SLIDER")[0].value = (pr.loaded/pr.total)*100;
            }
        };
        xmlHTTP.onloadend = (e) => {
            console.debug('ArrayBuffer loaded successfully:', arrayBuffer);
        };
        xmlHTTP.send();

        // Wait for the request to complete
        await new Promise(resolve => { console.log(xmlHTTP);
            xmlHTTP.onloadend = () => resolve();
        });
        const raw = arrayBuffer;
        for(let element of this.elements)
        {
            element.querySelectorAll(".SLIDER")[0].value = holdVolume; // restore the old volume
            element.querySelectorAll(".SLIDER")[0].classList.remove("LOCKED"); // allow pointer events again
        }
        this.loaded = 2;

        // we now have fetched the file data as an array buffer, we need to parse it
        this.data = await this.audioCtx.decodeAudioData(raw);
        this.source = await this.audioCtx.createBufferSource();
        this.source.buffer = this.data;
        this.source.loop = true;
        this.loaded = 3;

        // create an intermediate node for controlling volume
        this.noise = await this.audioCtx.createGain();
        this.noise.gain.setValueAtTime(this.volume, this.audioCtx.currentTime);
        await this.source.connect(this.noise);
        await this.noise.connect(this.audioCtx.destination);
        this.loaded = 4;

        // start and immediately stop the node (make sure it is ready to go)
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
            for ( var element of this.elements )
            {
                element.style.backgroundColor = "#999999";
            }
            await this.noise.connect(window.amplifier);
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
            for ( var element of this.elements )
            {
                element.style.backgroundColor = "#555555";
            }
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

    async adjustVolume(newVolume, elementValue)
    {
        this.volume = newVolume;
        this.noise.gain.setValueAtTime(this.volume, this.audioCtx.currentTime);

        if(elementValue) //propagate to other pointers
        {
            for(var element of this.elements)
            {
                element.querySelectorAll(".SLIDER")[0].value = elementValue;
            }
        }
        else //fallback if 2nd parameter is not provided
        {
            for(var element of this.elements)
            {
                element.querySelectorAll(".SLIDER")[0].value = ((Math.cbrt(newVolume)))*100;
            }
            
        }
        
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

    async addPointer(element)
    {
        this.elements.push(element);
    }
}
