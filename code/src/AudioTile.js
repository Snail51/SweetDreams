import { AudioNode } from "./AudioNode.js";
window.audioCTX = new window.AudioContext();
window.audioNodes = new Array();

var AudioTileDOMs = document.querySelectorAll("AudioTile");
for( var node of AudioTileDOMs )
{
    // capture DOM element attributes
    const name = node.getAttribute("name");
    const src = node.getAttribute("src");
    const icon = node.getAttribute("icon");
    const metaLeft = node.getAttribute("metaLeft");
    const metaRight = node.getAttribute("metaRight");

    // create new div object to hold the button grid and slider
    var newDiv = document.createElement("div");
    newDiv.className = "audioContainer";

    // create new AudioNode object
    var alreadyExists = null;
    for ( var i = 0; i < window.audioNodes.length; i++ )
    {
        if(window.audioNodes[i].src == src)
        {
            alreadyExists = i;
        }
    }
    var nodeIndex = -1;
    if(alreadyExists == null) //only create if does'nt already exist
    {
        var newNode = new AudioNode(src, window.audioCTX, newDiv);
        window.audioNodes.push(newNode);
        nodeIndex = window.audioNodes.length-1;
    }
    else // if it does exist, just use it's index
    {
        nodeIndex = alreadyExists;
        window.audioNodes[nodeIndex].addPointer(newDiv);
    }
    const constIndex = nodeIndex;

    // create new button object
    var newButton = document.createElement("button");
    newButton.className = "audioButton";
    newButton.addEventListener("click", () => { window.audioNodes[constIndex].toggle(); });

    // create new <p> for LEFT metadata
    var newMetaLeft = document.createElement("div");
    newMetaLeft.className = "META-L";
    newMetaLeft.innerHTML = metaLeft;


    var newIcon = document.createElement("div");
    newIcon.className = "ICON";
    newIcon.innerHTML = `<i class="fa-solid ${icon}"></i>`

    // create new <input> of type `range`
    var newRange = document.createElement("input");
    newRange.type = "range";
    newRange.className = "SLIDER";
    newRange.addEventListener("input", () => window.audioNodes[constIndex].adjustVolume(2*((event.target.value/100)**3)));
    newRange.addEventListener("change", () => window.URIsaver.save());

    // create new <p> for RIGHT metadata
    var newMetaRight = document.createElement("div");
    newMetaRight.className = "META-R";
    newMetaRight.innerHTML = metaRight;

    // create new <p> for LABEL
    var newLabel = document.createElement("div");
    newLabel.className = "LABEL";
    newLabel.innerHTML = name;

    // insert the elements into the div
    newButton.appendChild(newMetaLeft);
    newButton.appendChild(newIcon);
    newButton.appendChild(newMetaRight);
    newButton.appendChild(newLabel);

    newDiv.appendChild(newButton);
    newDiv.appendChild(newRange);

    // place the new div structure onto the DOM
    node.insertAdjacentElement("afterend", newDiv);

    // remove placeholder node of type <AudioTile>
    node.remove();
}