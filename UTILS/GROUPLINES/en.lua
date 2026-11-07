--=================================================================================================
--= Group Setup - English
--= ===============================================================================================
--= trait line detection data for the group setup export
--=================================================================================================
--=
--= Both tables are ports of Rolo's PrimePlugins, so that Gibberish3 writes the same answer his
--= own plugin would. Re-port them when he updates his, rather than editing them by hand:
--=
--=   LineEffects    <- lineDetectionEffects in PrimePlugins/RaidTools/Handlers/GroupEffectHandler.lua
--=   OwnLineSkills  <- RoleHandler:ParseTraits  in PrimePlugins/PrimeCore/Handlers/RoleHandler.lua
--=
--= Effect and skill names are the names the client shows, so this file is only correct on an
--= english client. de.lua and fr.lua hold the same tables, empty, until translations exist.
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- line detection by effect, for the other members of the group
---------------------------------------------------------------------------------------------------
-- keyed by the class name written to the savefile ( GroupSetup.ClassNames ), then by the exact
-- effect name. An effect only counts for its own class, so the same name under another class is
-- ignored.
--
-- Gaps carried over from Prime on purpose, do not invent entries for them: Brawler, Guardian,
-- Minstrel and Warden have no yellow effect, Mariner has no blue one, and the monster play
-- classes have none at all. Those members stay "Undefined" until Prime learns them.
GroupSetup.LineEffects = {

    [ "Beorning" ] = {
        [ "Guarded - Tier 1" ]                                  = "Blue",

        [ "Sharpened Claws" ]                                   = "Red",
        [ "Call To Wild" ]                                      = "Red",

        [ "Aid the Assault" ]                                   = "Yellow",
        [ "Honey Cleanse" ]                                     = "Yellow",
    },

    [ "Brawler" ] = {
        [ "Invite Mayhem" ]                                     = "Blue",
        [ "Mettle Shield" ]                                     = "Blue",
        [ "Innate Strength: Inner Resilience - Tier 1" ]         = "Blue",

        [ "Innate Strength: Raw Power - Tier 1" ]                = "Red",
    },

    [ "Burglar" ] = {
        [ "Even the Odds: Bleeding Wounds" ]                     = "Blue",
        [ "Even the Odds: Bad Luck Protection" ]                 = "Blue",
        [ "Even the Odds: Focused Attack" ]                      = "Blue",

        [ "Blades of Death" ]                                    = "Red",

        [ "Trickster" ]                                          = "Yellow",
    },

    [ "Captain" ] = {
        [ "Elendil's Favour" ]                                   = "Blue",

        [ "Elendil's Boon" ]                                     = "Red",

        [ "Elendil's Fortune" ]                                  = "Yellow",
        [ "Defensive Posture" ]                                  = "Yellow",
    },

    [ "Champion" ] = {
        [ "Sudden Defence" ]                                     = "Blue",

        [ "Devastating Attacks" ]                                = "Red",

        [ "Exchange of Blows" ]                                  = "Yellow",
        [ "Born for Combat 1" ]                                  = "Yellow",
    },

    [ "Guardian" ] = {
        [ "Fortification I" ]                                    = "Blue",

        [ "Protecting by the Sword" ]                            = "Red",
        [ "Brutal Charge" ]                                      = "Red",
        [ "Relentless Fury" ]                                    = "Red",
    },

    [ "Hunter" ] = {
        [ "Volley" ]                                             = "Blue",

        [ "Swift Mercy" ]                                        = "Red",

        [ "Strength of the Earth" ]                              = "Yellow",
    },

    [ "LoreMaster" ] = {
        [ "Feral - Bear" ]                                       = "Blue",
        [ "Feral - Bird" ]                                       = "Blue",
        [ "Feral - Bog-guardian" ]                               = "Blue",
        [ "Feral - Feline" ]                                     = "Blue",

        [ "Improved Staff-sweep" ]                               = "Red",

        [ "Stored Power - 1" ]                                   = "Yellow",
        [ "Insult to Injury: Lightning" ]                        = "Yellow",
    },

    [ "Mariner" ] = {
        [ "Swordplay: Check-step" ]                              = "Red",
        [ "Swordplay: Cut-over" ]                                = "Red",

        [ "Swordplay: Debilitating Strike" ]                     = "Yellow",
        [ "Balanced Traveller" ]                                 = "Yellow",
    },

    [ "Minstrel" ] = {
        [ "Personal Anthem - Resonance" ]                        = "Blue",

        [ "Personal Anthem - Dissonance" ]                       = "Red",
    },

    [ "RuneKeeper" ] = {
        [ "Master of Allusion" ]                                 = "Blue",

        [ "Master of Connotation - 1" ]                          = "Red",

        [ "Refutation" ]                                         = "Yellow",
    },

    [ "Warden" ] = {
        [ "Restorative Shield 5" ]                               = "Blue",
        [ "Desperate Combat 1" ]                                 = "Blue",

        [ "Reckless" ]                                           = "Red",
    },

    -- no detection, always "Undefined"
    [ "BlackArrow" ] = {},
    [ "Defiler" ]    = {},
    [ "Reaver" ]     = {},
    [ "Stalker" ]    = {},
    [ "WarLeader" ]  = {},
    [ "Weaver" ]     = {},
    [ "Chicken" ]    = {},
    [ "Troll" ]      = {},
    [ "Ranger" ]     = {},
    [ "Sorceress" ]  = {},

}
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- line detection by trained skill, for the local player only
---------------------------------------------------------------------------------------------------
-- The game tells a plugin nothing about another player's traits, but it does list our own trained
-- skills, and a line's own skills are only trained while that line is specced. That is why our own
-- line is right the moment the plugin loads while everyone else's has to be watched for.
--
-- The names are lua patterns, matched with string.find, because Prime escapes the hyphen in a few
-- of them. Keep them patterns.
GroupSetup.OwnLineSkills = {

    [ Turbine.Gameplay.Class.Beorning ] = {
        { line = "Blue",   names = { "The Hide", "Counterattack" } },
        { line = "Red",    names = { "The Claw", "Bash" } },
        { line = "Yellow", names = { "The Roar", "Mark of Grimbeorn" } },
    },

    [ Turbine.Gameplay.Class.Brawler ] = {
        { line = "Blue",   names = { "Fulcrum", "Come At Me" } },
        { line = "Red",    names = { "Maelstrom", "Shattering Fist" } },
    },

    [ Turbine.Gameplay.Class.Burglar ] = {
        { line = "Blue",   names = { "Gambler", "Lucky Strike" } },
        { line = "Red",    names = { "Quiet Knife", "Feint Attack" } },
        { line = "Yellow", names = { "Mischief%-maker", "Trick: Enrage" } },
    },

    [ Turbine.Gameplay.Class.Captain ] = {
        { line = "Blue",   names = { "Hands of Healing", "Valiant Strike", "Heilende Hände" } },
        { line = "Red",    names = { "Lead the Charge", "Shadow's Lament", "Den Angriff anführen" } },
        { line = "Yellow", names = { "Leader of Men", "Elendil's Roar", "Anführer der Menschen" } },
    },

    [ Turbine.Gameplay.Class.Champion ] = {
        { line = "Blue",   names = { "Martial Champion", "Sudden Defence", "Der Meister der Kampfkunst" } },
        { line = "Red",    names = { "The Berserker", "Remorseless Strike", "Der Berserker" } },
        { line = "Yellow", names = { "The Deadly Storm", "Blade Storm", "Der tödliche Sturm" } },
    },

    [ Turbine.Gameplay.Class.Guardian ] = {
        { line = "Blue",   names = { "Defender of the Free", "Litany of Defiance", "Der Verteidiger der Freien" } },
        { line = "Red",    names = { "Keen", "Overwhelm", "Die kühne Klinge" } },
    },

    [ Turbine.Gameplay.Class.Hunter ] = {
        { line = "Blue",   names = { "Huntsman", "Barrage" } },
        { line = "Red",    names = { "Bowmaster", "Long Shot" } },
        { line = "Yellow", names = { "The Trapper", "Kingsfoil Knowledge" } },
    },

    [ Turbine.Gameplay.Class.LoreMaster ] = {
        { line = "Blue",   names = { "Keeper of Animals", "Sign of the Wild: Rage" } },
        { line = "Red",    names = { "Master of Nature", "Staff Sweep" } },
        { line = "Yellow", names = { "Ancient Master", "Test of Will" } },
    },

    [ Turbine.Gameplay.Class.Mariner ] = {
        { line = "Blue",   names = { "Shanty%-caller", "Dramatic Flourish" } },
        { line = "Red",    names = { "Duellist", "Feint" } },
        { line = "Yellow", names = { "Rover", "Draining Strike" } },
    },

    [ Turbine.Gameplay.Class.Minstrel ] = {
        { line = "Blue",   names = { "Watcher of Resolve", "Soliloquy of Spirit" } },
        { line = "Red",    names = { "Warrior%-skald", "Call to Fate" } },
    },

    [ Turbine.Gameplay.Class.RuneKeeper ] = {
        { line = "Blue",   names = { "Benedictions of Peace", "Writ of Health", "Segnungen des Friedens" } },
        { line = "Red",    names = { "Cleansing Flame", "Writ of Fire", "Reinigende Flammen" } },
        { line = "Yellow", names = { "Thunder", "Writ of Lightning", "Einsamer Donner" } },
    },

    [ Turbine.Gameplay.Class.Warden ] = {
        { line = "Blue",   names = { "Determination", "Warning Shot" } },
        { line = "Red",    names = { "Recklessness", "Reckless" } },
    },

}
---------------------------------------------------------------------------------------------------
