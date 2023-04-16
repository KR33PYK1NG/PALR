// Supported game versions.
state("SP2", "v1.02") {
    int GameState : "SP2.exe", 0x7E4EB0;
    int GameStateFallback : "SP2.exe", 0x7E4EF0;
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

// When loading GameState(Fallback) is 0.
isLoading {
    if (current.MapOrDialog.Equals("trainstop.py") || vars.TrainStopCutscene) {
        return current.GameStateFallback == 0;
    } else {
        return current.GameState == 0;
    }
}

// Reset completion variables on start.
onStart {
    vars.EscapeSettlement = false;
    vars.FatherAlexander = false;
    vars.RatGrove = false;
    vars.TimeInstitute = false;
    vars.LostIsland = false;
    vars.NomadCamp = false;
    vars.AryanMeetingReady = false;
    vars.AryanMeeting = false;
    vars.UndergroundFortress = false;
    vars.FlamethrowerTank = false;
    vars.TrainStopCutscene = false;
    vars.TrainStop = false;
    vars.ProdzoneSweep = false;
    vars.PoliceSettlement = false;
    vars.PoliceBase = false;
}

// Initialize completion variables on startup.
startup {
    vars.EscapeSettlement = false;
    vars.FatherAlexander = false;
    vars.RatGrove = false;
    vars.TimeInstitute = false;
    vars.LostIsland = false;
    vars.NomadCamp = false;
    vars.AryanMeetingReady = false;
    vars.AryanMeeting = false;
    vars.UndergroundFortress = false;
    vars.FlamethrowerTank = false;
    vars.TrainStopCutscene = false;
    vars.TrainStop = false;
    vars.ProdzoneSweep = false;
    vars.PoliceSettlement = false;
    vars.PoliceBase = false;
}

// Automatically split at certain points.
split {
    bool MadeProgress = false;
    string From = old.MapOrDialog;
    string To = current.MapOrDialog;
    if (!String.IsNullOrEmpty(From) && !String.IsNullOrEmpty(To) && !From.Equals(To)) {
        if (!vars.EscapeSettlement && To.Equals("mar_car.py")) {
            // Escape Settlement
            MadeProgress = true;
            vars.EscapeSettlement = true;
        } else if (!vars.FatherAlexander && To.Equals("father_alexander.py")) {
            // Father Alexander
            MadeProgress = true;
            vars.FatherAlexander = true;
        } else if (!vars.RatGrove && From.Equals("monster01.py")) {
            // Rat Grove
            MadeProgress = true;
            vars.RatGrove = true;
        } else if (!vars.TimeInstitute && From.Equals("alice.py") && To.Equals("whitecenter.py")) {
            // Time Institute
            MadeProgress = true;
            vars.TimeInstitute = true;
        } else if (!vars.LostIsland && (From.Equals("cthulhu.py") || From.Equals("mcmurphy.py") || From.Equals("legba_junior.py") || From.Equals("seku.py") || From.Equals("johansen.py")) && To.Equals("sod_nor.py")) {
            // Lost Island
            MadeProgress = true;
            vars.LostIsland = true;
        } else if (!vars.NomadCamp && From.Equals("clausschultz.py") && To.Equals("aryancent.py")) {
            // Nomad Camp
            MadeProgress = true;
            vars.NomadCamp = true;
        } else if (!vars.AryanMeetingReady && To.Equals("pin.py")) {
            // Aryan Meeting Ready
            vars.AryanMeetingReady = true;
        } else if (!vars.AryanMeeting && vars.AryanMeetingReady && To.Equals("iceman.py")) {
            // Aryan Meeting
            MadeProgress = true;
            vars.AryanMeetingReady = false;
            vars.AryanMeeting = true;
        } else if (!vars.UndergroundFortress && From.Equals("highentr.py")) {
            // Underground Fortress
            MadeProgress = true;
            vars.UndergroundFortress = true;
        } else if (!vars.FlamethrowerTank && From.Equals("panzerfahrer.py") && To.Equals("aryancent.py")) {
            // Flamethrower Tank
            MadeProgress = true;
            vars.FlamethrowerTank = true;
        } else if (!vars.TrainStopCutscene && From.Equals("trainstop.py") && To.Equals("clausschultz.py")) {
            // Train Stop Cutscene
            vars.TrainStopCutscene = true;
        } else if (!vars.TrainStop && From.Equals("clausschultz.py") && To.Equals("entry.py")) {
            // Train Stop
            MadeProgress = true;
            vars.TrainStopCutscene = false;
            vars.TrainStop = true;
        } else if (!vars.ProdzoneSweep && From.Equals("entry.py") && !To.Equals("farm_mine.py")) {
            // Prodzone Sweep
            MadeProgress = true;
            vars.ProdzoneSweep = true;
        } else if (!vars.PoliceSettlement && From.Equals("pol_lake.py")) {
            // Police Settlement
            MadeProgress = true;
            vars.PoliceSettlement = true;
        }
    }
    int FromBase = old.GameState;
    int ToBase = current.GameState;
    if (!vars.PoliceBase && To.Equals("pol_cave.py") && FromBase != ToBase && ToBase == 0) {
        // Police Base
        MadeProgress = true;
        vars.PoliceBase = true;
    }
    return MadeProgress;
}
