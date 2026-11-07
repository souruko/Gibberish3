--=================================================================================================
--= Group Setup
--= ===============================================================================================
--= writes the group's names, classes and trait lines for Prime Group Parse
--=================================================================================================
--=
--= Rolo's Prime Group Parse needs the name, class and trait line of everyone in the group, and
--= the only thing that produced that was his own UI plugin. Both plugins tracking group effects
--= at once is wasteful, so Gibberish3 can write the same file instead, letting Prime Group Parse
--= run without any Prime UI.
--=
--= The savefile is Prime's, not ours:
--=
--=     return { ["Group"] = "Name|Class|Line;Name|Class|Line" }
--=
--= local player first, then the other members in party order. See GroupSetup.Write.
--=
--= Switched on by the player with Data.exportGroupSetup, and needs group effect tracking, since
--= that is what reads the other members' effects. GroupSetup.Enabled answers both at once.
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- class names
---------------------------------------------------------------------------------------------------
-- The names Prime writes, ported from _G.ClassObjectToNameLUT in
-- PrimePlugins/PrimeCore/GlobalVariables/ClassName.lua.
--
-- These are not the names shown to the player: Prime writes "LoreMaster", not "Lore-master", and
-- the same string whatever the client language. So this is deliberately not L[...].class, which
-- holds the localised, hyphenated display name and would produce a file Prime cannot read.
GroupSetup.ClassNames = {
    [ Turbine.Gameplay.Class.Burglar ]    = "Burglar",
    [ Turbine.Gameplay.Class.Captain ]    = "Captain",
    [ Turbine.Gameplay.Class.Champion ]   = "Champion",
    [ Turbine.Gameplay.Class.Mariner ]    = "Mariner",
    [ Turbine.Gameplay.Class.Guardian ]   = "Guardian",
    [ Turbine.Gameplay.Class.Hunter ]     = "Hunter",
    [ Turbine.Gameplay.Class.LoreMaster ] = "LoreMaster",
    [ Turbine.Gameplay.Class.Minstrel ]   = "Minstrel",
    [ Turbine.Gameplay.Class.RuneKeeper ] = "RuneKeeper",
    [ Turbine.Gameplay.Class.Warden ]     = "Warden",
    [ Turbine.Gameplay.Class.Beorning ]   = "Beorning",
    [ Turbine.Gameplay.Class.Brawler ]    = "Brawler",
    [ Turbine.Gameplay.Class.BlackArrow ] = "BlackArrow",
    [ Turbine.Gameplay.Class.Defiler ]    = "Defiler",
    [ Turbine.Gameplay.Class.Reaver ]     = "Reaver",
    [ Turbine.Gameplay.Class.Stalker ]    = "Stalker",
    [ Turbine.Gameplay.Class.WarLeader ]  = "WarLeader",
    [ Turbine.Gameplay.Class.Weaver ]     = "Weaver",
    [ Turbine.Gameplay.Class.Chicken ]    = "Chicken",
    [ Turbine.Gameplay.Class.Troll ]      = "Troll",
    [ Turbine.Gameplay.Class.Ranger ]     = "Ranger",
    [ Turbine.Gameplay.Class.Sorceress ]  = "Sorceress",
}
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- state
---------------------------------------------------------------------------------------------------
-- the value Prime writes for a line it does not know
GroupSetup.Undefined = "Undefined"

-- the savefile key. Prime's name, so both plugins write the same file
GroupSetup.SaveKey = "PrimeGroupParseGroupSetup"

-- the other members of the group, by name:
--   { className = "Burglar", line = "Undefined" }
-- filled in by Trigger[ Trigger.Types.EffectGroup ].Sync, which already has the player object in
-- hand, and emptied there again when somebody leaves
GroupSetup.roster = {}

-- our own line, worked out once from the trained skills. nil means "not worked out yet"
GroupSetup.ownLine = nil

-- a line changed while we were in combat, so the next time we leave it is worth a save. Writing on
-- the effect itself would mean writing in the middle of a fight, over and over. Out of combat the
-- write is not put off at all, see GroupSetup.CheckEffect
GroupSetup.dirty = false

-- a write is already coming, so a line worked out right now must not write on its own. True while
-- the active effects of the whole group are being swept, which works out several lines in a row
-- and would otherwise save the file once per member: at start up, where StartUp writes at the end
-- of it, and when either tracking setting is switched, where Options.TrackGroupChanged and the
-- settings panel do. Starts true for the sweep that runs before StartUp.
GroupSetup.holdWrite = true
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- is the export running
---------------------------------------------------------------------------------------------------
-- The one place that decides, so the hot path, the writer and the options panel can never
-- disagree about it. Group effect tracking is what reads everyone else's effects, so without it
-- there is nothing to report but our own line.
function GroupSetup.Enabled()

    return Data.exportGroupSetup == true and Data.trackGroupEffects == true

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- our own trait line, from the trained skills
---------------------------------------------------------------------------------------------------
-- A line's own skills are only trained while that line is specced, so the skill list tells us
-- which one it is without waiting for an effect to show up. That is why our own line is right
-- straight away and everyone else's is not.
function GroupSetup.DetectOwnLine()

    if GroupSetup.ownLine ~= nil then
        return GroupSetup.ownLine
    end

    GroupSetup.ownLine = GroupSetup.Undefined

    local byClass = GroupSetup.OwnLineSkills[ LocalPlayer:GetClass() ]

    -- no data for this class, or none for this client language
    if byClass == nil then
        return GroupSetup.ownLine
    end

    local listOfSkills = LocalPlayer:GetTrainedSkills()

    -- The last match wins rather than the first, because that is what Prime does: it tests every
    -- line against every skill and keeps assigning, so the end of the skill list has the final
    -- say. Returning early instead would answer differently for anyone whose trained skills match
    -- two lines, and the point of this file is to agree with Prime.
    for i = 1, listOfSkills:GetCount(), 1 do

        local skillName = listOfSkills:GetItem(i):GetSkillInfo():GetName()

        for _, entry in ipairs( byClass ) do

            for _, pattern in ipairs( entry.names ) do

                -- patterns, not plain names: a few of them escape a hyphen
                if string.find( skillName, pattern ) ~= nil then

                    GroupSetup.ownLine = entry.line
                    break

                end

            end

        end

    end

    return GroupSetup.ownLine

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- our own line changed
---------------------------------------------------------------------------------------------------
-- called when the game announces a trait line swap, see TRIGGER/SKILL/Functions.lua
function GroupSetup.OwnLineChanged()

    GroupSetup.ownLine = nil

    if GroupSetup.Enabled() == false then
        return
    end

    -- a line swap happens out of combat, so there is nothing to wait for
    GroupSetup.Write()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check one effect of one group member
---------------------------------------------------------------------------------------------------
-- Called for every effect that lands on every member of the group, so it stays cheap: two table
-- lookups and no calls into the game of its own. The name comes off the effect view, which has
-- read it at most once for the whole event, see Trigger.NewEffectView.
function GroupSetup.CheckEffect( effectView, playerName )

    local record = GroupSetup.roster[ playerName ]

    if record == nil then
        return
    end

    local byClass = GroupSetup.LineEffects[ record.className ]

    if byClass == nil then
        return
    end

    local line = byClass[ Trigger.EffectName( effectView ) ]

    -- not one of the effects that gives a line away
    if line == nil or line == record.line then
        return
    end

    record.line      = line
    GroupSetup.dirty = true

    -- A trait line swap is done out of combat, so waiting for combat to end would mean waiting for
    -- a fight that may never come and leaving the file on the old line the whole time. Out of
    -- combat the save happens now; in combat it is left to GroupSetup.WriteIfDirty, which is the
    -- point of the dirty flag. IsInCombat is a call into the game, but this only runs when a line
    -- actually changed, not for every effect.
    if GroupSetup.holdWrite == false and LocalPlayer:IsInCombat() == false then
        GroupSetup.Write()
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- remember one group member
---------------------------------------------------------------------------------------------------
function GroupSetup.AddMember( player, playerName )

    GroupSetup.roster[ playerName ] = {
        className = GroupSetup.ClassNames[ player:GetClass() ],
        line      = GroupSetup.Undefined,
    }

    GroupSetup.dirty = true

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- forget one group member
---------------------------------------------------------------------------------------------------
function GroupSetup.RemoveMember( playerName )

    if GroupSetup.roster[ playerName ] == nil then
        return
    end

    GroupSetup.roster[ playerName ] = nil
    GroupSetup.dirty                = true

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- write the savefile
---------------------------------------------------------------------------------------------------
function GroupSetup.Write()

    if GroupSetup.Enabled() == false then
        return
    end

    local party = Trigger[ Trigger.Types.EffectGroup ].party

    -- Alone, so there is no group to report. Prime writes nothing here either, which leaves the
    -- last group standing in the file: there is no "empty" value Prime would understand, and
    -- writing ourselves as a group of one would read as a real one.
    if party == nil then
        return
    end

    -- us first, the way Prime writes it. Our class can be missing from the table if the game ever
    -- adds a class, and a nil would land in the file as the text "nil", so it falls back instead
    local groupString = string.format( "%s|%s|%s",
        LpData.name,
        GroupSetup.ClassNames[ LocalPlayer:GetClass() ] or GroupSetup.Undefined,
        GroupSetup.DetectOwnLine() )

    -- then everyone else, in party order
    for i = 1, party:GetMemberCount(), 1 do

        local playerName = party:GetMember(i):GetName()

        if playerName ~= LpData.name then

            local record = GroupSetup.roster[ playerName ]

            groupString = string.format( "%s;%s|%s|%s",
                groupString,
                playerName,
                ( record ~= nil and record.className ) or GroupSetup.Undefined,
                ( record ~= nil and record.line ) or GroupSetup.Undefined )

        end

    end

    -- Prime's key and Prime's shape, so this is the one save in the plugin that does not get the
    -- language suffix every other key has, and does not go through Options.ConvertToEuro. Both
    -- would produce a file Prime cannot read, and there is nothing to convert anyway: every value
    -- here is a string already
    Turbine.PluginData.Save( Turbine.DataScope.Account, GroupSetup.SaveKey, { Group = groupString }, nil )

    GroupSetup.dirty = false

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- write the savefile if a line changed
---------------------------------------------------------------------------------------------------
-- hooked to leaving combat, so a fight in which somebody's line was worked out is saved once at
-- the end of it rather than on every effect
function GroupSetup.WriteIfDirty()

    if GroupSetup.dirty == false then
        return
    end

    GroupSetup.Write()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- start up
---------------------------------------------------------------------------------------------------
-- Must run after Trigger.InitAll: the party is read there, and TRIGGER/COMBAT writes
-- LocalPlayer.InCombatChanged straight into the slot instead of adding to it, so a callback
-- registered before it would be dropped on the floor.
function GroupSetup.StartUp()

    Trigger.AddCallback( LocalPlayer, "InCombatChanged", function ( sender, args )

        if GroupSetup.Enabled() == false then
            return
        end

        if LocalPlayer:IsInCombat() == false then
            GroupSetup.WriteIfDirty()
        end

    end )

    GroupSetup.Write()

    -- the start up sweep is over, so from here a line change writes on its own
    GroupSetup.holdWrite = false

end
---------------------------------------------------------------------------------------------------
