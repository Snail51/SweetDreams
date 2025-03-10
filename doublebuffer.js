export class DoubleBufferedAudio {
    constructor(playerEID, srcURL)
    {
        // capture variables
        this.src = srcURL;
        this.offset = 0.1;

        // setup players and derive duplicates
        this.playerA = document.getElementById(playerEID);
        this.playerB = this.playerA.outerHTML;
        this.playerA.id=`${playerEID}A`;
        this.playerA.insertAdjacentHTML('afterend', this.playerB);
        this.playerB = document.getElementById(playerEID);
        this.playerB.id=`${playerEID}B`;

        // add debug element
        this.playerB.insertAdjacentHTML("afterend", "<p id='debugB'>BBBBB</p>");
        this.playerB.insertAdjacentHTML("afterend", "<p id='debugA'>AAAAA</p>");
        
        
        // ensure <audio> configuration
        this.playerA.src = this.src;
        this.playerB.src = this.src;
        this.playerA.preload = "auto";
        this.playerB.preload = "auto";
        this.playerA.controls = true;
        this.playerB.controls = true;

        // setup "active" system
        this.playerActive = this.playerA;
        this.playerInactive = this.playerB;

        // attach event listeners
        this.playerA.addEventListener("timeupdate", () => this.monitor());
        this.playerB.addEventListener("timeupdate", () => this.monitor());
    }

    switchActive()
    {
        // do the actual switch
        [this.playerActive, this.playerInactive] = [this.playerInactive, this.playerActive];
        this.playerActive.play();
    }

    monitor()
    {
        console.log(this);

        if (this.playerActive.currentTime > this.playerActive.duration - this.offset)
        {
            this.switchActive();
        }

        document.getElementById("debugA").innerHTML = `${this.playerA.currentTime} / ${this.playerA.duration}`;
        document.getElementById("debugB").innerHTML = `${this.playerB.currentTime} / ${this.playerB.duration}`;
    }
}

export class OLDDoubleBufferedAudio {
    constructor(audioUrl) {
        this.players = [];
        this.currentIndex = 0;
        
        // Create two audio elements
        for (let i = 0; i < 2; i++) {
            const player = new Audio(audioUrl);
            //player.loop = true;
            this.players.push(player);
        }
        
        // Monitor the active player
        this.activePlayer = this.players[0];
        this.inactivePlayer = this.players[1];
        
        this.setupMonitoring();
    }
    
    setupMonitoring() {
        if (this.activePlayer.currentTime > this.activePlayer.duration - 1)
        {
            this.switchPlayers();
        }

        var label = document.getElementById('audio1time');
        label.innerHTML = this.activePlayer.currentTime + "/" + this.activePlayer.duration;

        var next = this.activePlayer.duration - this.activePlayer.currentTime;
        window.requestAnimationFrame(next);
    }
    
    switchPlayers() {
        [this.activePlayer, this.inactivePlayer] = 
            [this.inactivePlayer, this.activePlayer];
        this.inactivePlayer.play();
    }
    
    play() {
        this.players[0].play();
    }
    
    stop() {
        this.players.forEach(p => p.pause());
    }
}