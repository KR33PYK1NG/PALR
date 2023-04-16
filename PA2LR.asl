// Supported game versions.
state("SP2", "v1.02") {
    int GameState : "SP2.exe", 0x7E4EB0;
    string64 MapOrDialog : "SP2.exe", 0x72BB28;
}

// Detect version on game init.
init {
    switch (modules.First().ModuleMemorySize) {
        case (21602304):
            version = "v1.02";
            break;
    }
}

// Pause timer on game exit.
exit {
    timer.IsGameTimePaused = true;
}

// Pause timer on shutdown.
shutdown {
    timer.IsGameTimePaused = true;
}

// Disable if unsupported version.
update {
    if (version == "") {
        return false;
    }
}

// When loading GameState is 0.
isLoading {
    return current.GameState == 0;
}

// Reset completion variables on start.
onStart {
    vars.RunStage = 0;
}

// Initialize completion variables on startup.
startup {
    vars.RunStage = 0;
}

// Automatically split at certain points.
split {
    int CurrentStage = vars.RunStage;
    bool MadeProgress = false;
    string From = old.MapOrDialog;
    string To = current.MapOrDialog;
    if (!String.IsNullOrEmpty(From) && !String.IsNullOrEmpty(To) && !From.Equals(To)) {
        switch (CurrentStage) {
            case 0: // Escape Settlement
                MadeProgress = To.Equals("mar_car.py");
                break;
            case 1: // Father Alexander
                MadeProgress = To.Equals("father_alexander.py");
                break;
            case 2: // Rat Grove
                MadeProgress = From.Equals("monster01.py");
                break;
            case 3: // Time Institute
                MadeProgress = From.Equals("alice.py") && To.Equals("whitecenter.py");
                break;
            case 4: // Lost Island
                MadeProgress = (From.Equals("cthulhu.py") || From.Equals("mcmurphy.py") || From.Equals("legba_junior.py") || From.Equals("seku.py") || From.Equals("johansen.py")) && To.Equals("sod_nor.py");
                break;
            case 5: // Nomad Camp
                MadeProgress = From.Equals("clausschultz.py") && To.Equals("aryancent.py");
                break;
            case 6: // Aryan Meeting Start
                MadeProgress = To.Equals("pin.py");
                break;
            case 7: // Aryan Meeting
                MadeProgress = To.Equals("iceman.py");
                break;
            case 8: // Underground Fortress
                MadeProgress = From.Equals("highentr.py");
                break;
            case 9: // Flamethrower Tank
                MadeProgress = From.Equals("panzerfahrer.py") && To.Equals("aryancent.py");
                break;
            case 10: // Train Stop
                MadeProgress = From.Equals("clausschultz.py") && To.Equals("entry.py");
                break;
            case 11: // Prodzone Sweep
                MadeProgress = (From.Equals("entry.py") || From.Equals("hood.py")) && !To.Equals("farm_mine.py");
                break;
            case 12: // Police Settlement
                MadeProgress = From.Equals("pol_lake.py");
                break;
        }
    }
    if (MadeProgress || (vars.RunStage == 13 && old.GameState != current.GameState && current.GameState == 0 && To.Equals("pol_hq.py"))) {
        vars.RunStage++;
        return true;
    }
}
