// Supported game versions.
state("Erasers", "v1.05") {
    int GameState : "Erasers.exe", 0x3E00A8;
    int GameStateFallback : "Erasers.exe", 0x607110;
    string1 Credits : "mss32.dll", 0x816BB;
    string64 Map : "Erasers.exe", 0x4101B0;
    string64 Dialog : "Erasers.exe", 0x50ACA8;
}
state("Erasers", "v1.06") {
    int GameState : "Erasers.exe", 0x598258;
    int GameStateFallback : "LifeStudioHeadAPI.dll", 0x5C2C4;
    string1 Credits : "mss32.dll", 0x816BB;
    string64 Map : "Erasers.exe", 0x5C9030;
    string64 Dialog : "Erasers.exe", 0x6E3148;
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
    if (current.Map.Equals("academ_academ.ers")
        || current.Map.Equals("mildrop_mildrop.ers")
        || current.Map.StartsWith("fight")
        || current.Map.StartsWith("monster")) {
        return current.GameStateFallback == 0;
    } else {
        return current.GameState == 0;
    }
}

// Reset completion variables on start.
onStart {
    vars.FinishedSpaceshipCave = false;
}

// Automatically split at certain points.
split {
    string FromCredits = old.Credits;
    string ToCredits = current.Credits;
    if (!FromCredits.Equals(ToCredits)) {
        // End Credits
        if (ToCredits.Equals("1")) {
            return true;
        }
    }
    string FromDialog = old.Dialog;
    string ToDialog = current.Dialog;
    if (!FromDialog.Equals(ToDialog)) {
        // Recruitment
        if (ToDialog.Equals("sullen") && FromDialog.Equals("mirza")) {
            // +Sullen
            return true;
        } else if (ToDialog.Equals("kruger") && current.Map.Equals("norcity_mar_car.ers")) {
            // +Kruger
            return true;
        } else if (ToDialog.Equals("demon") && current.Map.Equals("aryantown_aryannor.ers")) {
            // +Demon
            return true;
        }
    }
    string FromMap = old.Map;
    string ToMap = current.Map;
    if (!FromMap.Equals(ToMap)) {
        // Common Story
        if (FromMap.Equals("crashsite_crashsite.ers") && ToMap.Equals("prodzone_fact_ent.ers")) {
            // Crash Site
            return true;
        } else if (FromMap.Equals("trainstop_trainstop.ers") && ToMap.Equals("norcity_rubbish.ers")) {
            // Escape Prodzone
            return true;
        } else if (FromMap.Equals("mildrop_mildrop.ers")) {
            // Military Drop
            return true;
        }
        // Aryan Story
        if (FromMap.Equals("academ_academ.ers") && ToMap.Equals("settlem_settlem.ers")) {
            // Niagara Drug
            return true;
        } else if (FromMap.Equals("polcamp_polcamp.ers") && ToMap.Equals("aryantown_aryancent.ers")) {
            // Police Camp
            return true;
        } else if (FromMap.Equals("cannibals_can_vill.ers") && ToMap.Equals("shipcave_maze.ers")) {
            // Cannibal Village
            return true;
        } else if (FromMap.Equals("shipcave_consgrou.ers") && ToMap.Equals("norcity_mar_car.ers")) {
            // Spaceship Cave
            return true;
        }
        // Cannibal Story
        if (FromMap.Equals("norcity_ungan.ers") && ToMap.Equals("cannibals_can_entr.ers")) {
            // Ungan Jackson
            return true;
        } else if (FromMap.Equals("aryantown_aryandock.ers") && ToMap.Equals("norcity_mar_car.ers")) {
            // Aryan Prodzone
            return true;
        } else if (FromMap.Equals("highland_kishlak.ers") && ToMap.Equals("aryantown_aryandock.ers")) {
            // Highlander Camp
            return true;
        } else if (FromMap.StartsWith("1") && ToMap.Equals("shipcave_consgrou.ers")) {
            // Island Base
            return true;
        } else if (FromMap.Equals("shipcave_maze.ers") && ToMap.Equals("cannibals_can_vill.ers")) {
            // Spaceship Cave
            vars.FinishedSpaceshipCave = true;
            return true;
        } else if (vars.FinishedSpaceshipCave && FromMap.Equals("cannibals_can_entr.ers") && ToMap.Equals("norcity_mar_car.ers")) {
            // Cannibal Village
            return true;
        }
        // Fights/Monsters
        else if (FromMap.StartsWith("fight") || FromMap.StartsWith("monster")) {
            return true;
        }
    }
}
