// Supported game versions.
state("Erasers", "v1.05") {
    int GameState : "Erasers.exe", 0x3E00A8;
    int GameStateFallback : "Erasers.exe", 0x607110;
    string5 MapPrefix : "Erasers.exe", 0x4101B0;
}
state("Erasers", "v1.06") {
    int GameState : "Erasers.exe", 0x598258;
    int GameStateFallback : "LifeStudioHeadAPI.dll", 0x5C2C4;
    string5 MapPrefix : "Erasers.exe", 0x5C9030;
}

// Detect version on game init.
init {
    switch (modules.First().ModuleMemorySize) {
        case (16445440):
            version = "v1.05";
            break;
        case (20865024):
            version = "v1.06";
            break;
    }
}

// Pause timer on game exit.
exit {
    timer.IsGameTimePaused = true;
}

// Disable if unsupported version.
update {
    if (version == "") {
        return false;
    }
}

// When loading GameState(Fallback) is 0.
isLoading {
    if (current.MapPrefix == "fight" || current.MapPrefix == "monst") {
        return current.GameStateFallback == 0;
    } else {
        return current.GameState == 0;
    }
}
