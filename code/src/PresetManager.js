export class Loader
{
    constructor()
    {
        this.activeList = new Array();
        this.compressor = new URIManager();
    }

    async load()
    {
        this.activeList = this.compressor.pull().split(",");
        document.getElementById("printout_loadparams").innerHTML = this.activeList.join("\n");
        var nodes = window.audioNodes;
        for ( var node of nodes )
        {
            if(this.activeList.some(item => item.startsWith(node.src)))
            {
                await node.play();
                var relevant = this.activeList.find(item => item.startsWith(node.src));
                await node.adjustVolume(relevant.split(";")[1]);
                for(var element of node.elements)
                {
                    element.querySelectorAll(".SLIDER")[0].value = (Math.cbrt(parseFloat(relevant.split(";")[1])/2))*100;
                }
            }
        }
    }
}

export class Saver
{
    constructor()
    {
        this.activeList = new Array();
        this.compressor = new URIManager();
        this.oldDigest = "";
    }

    async save()
    {
        this.activeList = new Array();
        var nodes = window.audioNodes;
        for ( var node of nodes )
        {
            if(node.playing)
            {
                this.activeList.push(node.src + ";" + node.volume);
            }
        }
        var payload = this.activeList.join(",");

        const encoder = new TextEncoder();
        var newDigest = await crypto.subtle.digest("SHA-256",  encoder.encode(payload));
        if(newDigest != this.oldDigest)
        {
            this.compressor.push(payload);
            this.oldDigest = newDigest;
            console.debug(this);
        }
    }
}

export class URIManager
{
    constructor()
    {
        this.maxURILength = 8192;
        this.defaultCompression = "LZMA2";
        this.defaultEncoding = "URI-B64";
        this.lastAlert = new Date(0); // start as never
    }

    alertNoSpam()
    {
        if(new Date().getTime() - this.lastAlert >= 30000)
        {
            alert("Maxium URL Length Reached!\n\nShorten your document or prepare to save the raw text content!");
        }
        this.lastAlert = new Date().getTime();
    }

    pull(URL) //turn URL into data
    {
        var URI = this.getURL(URL);
        var data = URI.data;
        if(window.location.href.endsWith("program.html.php") || window.location.href.endsWith("program.html"))
        {
            return "";
        }
        if(data == "")
        {
            return "Error\n\tNo data parameter provided";
        }
        var compression = URI.compressor;
        var encoding = URI.encoding;

        try
        {
            data = this.decode(data, encoding);

            data = this.decompress(data, compression);

            const decoder = new TextDecoder("utf-8");
            var data = decoder.decode(data);
        }
        catch(error)
        {
            data = error.stack;
            data = data.replace(/[\t ]{4,}/g, "\t");
        }

        if(data == "" || data == null)
        {
            data = "Couldn't decode the provided link.\nCould not parse Data Parameter.";
        }

        data = data.replace(/\s+$/gm, ""); //trim trailing 

        return data;
    }

    push(string) //turn data into URL
    {
        const encoder = new TextEncoder();
        var data = encoder.encode(string);

        data = this.compress(data, this.defaultCompression);

        data = this.encode(data, this.defaultEncoding);

        this.setURL(data, this.defaultCompression, this.defaultEncoding);

        return null;
    }

    setURL(encodedData, compressionType, encoding) //set the url given the 3 URI params
    {
        var baseURL = window.location.href.split("?")[0];
        var URL = baseURL + "?enc=" + encoding + "&cmpr=" + compressionType + "&data=" + encodedData;
        window.link_full = URL;

        if(URL.length + 512 > this.maxURILength)
        {
            URL = baseURL + "?enc=" + encoding + "&cmpr=" + compressionType + "&data=" + "MAXIMUM-LINK-LENGTH-EXCEEDED";
            this.alertNoSpam();
        }

        history.replaceState({}, "", URL);
    }

    getURL() //extract URI components
    {
        var data = /(?:data=)([^\&\=\?]*)/gm;
        var compressor = /(?:cmpr=)([^\&\=\?]*)/gm;
        var encoding = /(?:enc=)([^\&\=\?]*)/gm;

        var uriData = data.exec(window.location.href);
        if(uriData == null || uriData[1] == "")
        {
            uriData = "";
        }
        else
        {
            uriData = uriData[1];
        }

        var uriCompressor = compressor.exec(window.location.href);
        if(uriCompressor == null || uriCompressor[1] == "")
        {
            uriCompressor = "ZLIB"; //fallback to old
        }
        else
        {
            uriCompressor = uriCompressor[1];
        }

        var uriEncoding = encoding.exec(window.location.href);
        if(uriEncoding == null || uriEncoding[1] == "")
        {
            uriEncoding = "URI-B64"; //fallback to old
        }
        else
        {
            uriEncoding = uriEncoding[1];
        }
        
        var URI = ({});
        URI.encoding = uriEncoding;
        URI.compressor = uriCompressor;
        URI.data = uriData;
        return URI;
    }

    encode(compressedData, encodingType) //encode the given uint8 array as a string with the given compresison type
    {
        switch (encodingType)
        {
            case "URI-B64":
                return URIB64(compressedData);
            default:
                console.warn("unrecognized encoding argument: " + encodingType);
                return null;
        }

        function URIB64(data)
        {
            var utf8str = "";
            for(var item of data)
            {
                utf8str += String.fromCodePoint(item);
            }
            var payload = btoa(utf8str);
            payload = payload.replace(/\+/g, '-').replace(/\//g, '_').replace(/\=/g, "");
            return payload;
        }
    }

    decode(encodedData, encodingType) //decode the given string with the given encoding type
    {
        switch (encodingType)
        {
            case "URI-B64":
                return URIB64(encodedData);
            default:
                console.warn("unrecognized encoding argument: " + encodingType);
                return null;
        }

        function URIB64(data)
        {
            data = data.replace(/\-/g, '+').replace(/\_/g, '/');
            var utf8str = atob(data);
            var u8 = new Array();
            for(var char of utf8str)
            {
                u8.push(char.charCodeAt(0));
            }
            u8 = new Uint8Array(u8);
            return u8;
        }
    }

    decompress(uint8_compressed, compressionType) //turn compression type and compressed unit8array into decompressed uint8array
    {
        switch (compressionType)
        {
            case "ZLIB":
                return zlib(uint8_compressed);
            case "LZMA2":
                return lzma2(uint8_compressed);
            default:
                console.warn("unrecognized decompression argument: " + compressionType);
                return null;
        }

        function zlib(data)
        {
            try
            {
                data = pako.inflate(data);
            }
            catch (error)
            {
                data = "There was a problem decoding the data in the link.\nAre you sure it was produced by this program?\nError has been printed to console.";
                console.error(error);
            }
            return data;
        }

        function lzma2(data)
        {
            var s8 = new Array();
            for(var val of data)
            {
                s8.push(val-128);
            }
            var data = LZMA.decompress(s8);
            var u8 = new Array();
            for(var val of data)
            {
                u8.push(val+128);
            }
            u8 = new Uint8Array(u8);
            console.debug(u8);
            return u8;
        }
    }

    compress(uint8_raw, compressionType)
    {
        switch(compressionType)
        {
            case "ZLIB":
                return zlib(uint8_raw);
            case "LZMA2":
                return lzma2(uint8_raw);
            default:
                console.warn("unrecognized compression argument: " + compressionType);
                return null;
        }

        function zlib(data)
        {
            data = pako.deflate(data, { level: 9});
            return data;
        }

        function lzma2(data)
        {
            var s8 = new Array();
            for(var val of data)
            {
                s8.push(val-128);
            }
            data = LZMA.compress(s8, 9);
            var u8 = new Array();
            for(var val of data)
            {
                u8.push(val+128);
            }
            u8 = new Uint8Array(u8);
            return u8;
        }
    }
}
