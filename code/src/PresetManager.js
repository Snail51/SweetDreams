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
                this.activeList.push(node.src + ";" + ((Math.round(node.volume*100))/100));
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
        this.defaultCompression = "BEST";
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
        // collect URI object from current URL
        var URI = this.getURL(URL);

        // decompress everything to a single string
        var data = window.URICompressor.pull(URI.data, URI.compressor, URI.encoding).data;

        // data validation
        if(data == "" || data == null)
        {
            console.error("Couldn't decode the provided link.\nCould not parse Data Parameter.");
        }

        // trim trailing
        data = data.replace(/\s+$/gm, "");

        return data;
    }

    push(string) //turn data into URL
    {
        // generate the compression object and do the compression operation
        var compressed = window.URICompressor.push(string, this.defaultCompression, this.defaultEncoding);
        
        // modify the page URL to reflect the operands of the the compression operation
        this.setURL(compressed.data, compressed.compression, compressed.encoding);

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
}
