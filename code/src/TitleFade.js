window.fadeApp = function () {
    document.getElementById("title").classList.toggle("fade");
    window.URIsaver.save();
}

window.fadeAndLoad = function () {
    document.getElementById("title").classList.toggle("fade");
    window.URIloader.load();
}

window.initTitleButtons = function () {

    const url = new URL(window.location.href);
    const query = url.searchParams;
    const data = query.get("data") ? query.get("data") : "";
    var load_possible  = (data.length > 0 && data != "3YCAgIKAgICAgICAgIADf3t_f0CAgIA" && data != "eNoDAAAAAAE") // data is present

    var newButton = document.createElement("button");
    newButton.id = "newbutton";
    newButton.addEventListener("click", window.fadeApp);
    newButton.innerText = "Dream Anew";
    newButton.style.opacity = "0";

    var loadButton = document.createElement("button");
    loadButton.id = "loadbutton";
    loadButton.addEventListener("click", window.fadeAndLoad);
    loadButton.innerHTML = load_possible ? "Load Selected Soundscape" : "<del>Load Selected Soundscape</del>";
    loadButton.disabled = load_possible ? false : true;
    loadButton.title = load_possible ? "Load Selected Soundscape from URL" : "No saved soundscape included in this link!";
    loadButton.style.opacity = "0";

    if(load_possible) // if loading is possible, put the load button first
    {
        document.getElementById("title").insertAdjacentElement("beforeend", loadButton);
        document.getElementById("title").insertAdjacentElement("beforeend", newButton);
    }
    else // if loading is not possible, put the load button second
    {
        document.getElementById("title").insertAdjacentElement("beforeend", newButton);
        document.getElementById("title").insertAdjacentElement("beforeend", loadButton);
    }

    setTimeout(() => { // fade the buttons in after load
        document.getElementById("newbutton").style.opacity = "1";;
        document.getElementById("loadbutton").style.opacity = "1";;
    }, 100);
}

window.addEventListener("DOMContentLoaded", () => window.initTitleButtons());