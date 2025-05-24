window.addEventListener("beforeunload", (event) => {
    if(window.audioNodes ? window.audioNodes.some(node => node.playing === true) : false)
    {
        event.preventDefault();
        return;
    }
    else
    {
        return;
    }
});