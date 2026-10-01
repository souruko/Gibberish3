--=================================================================================================
--= Effect Group          
--= ===============================================================================================
--= trigger from effect group events
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- effect group event processing start up
---------------------------------------------------------------------------------------------------
-- members of the party that currently have a callback registered, by name
Trigger[ Trigger.Types.EffectGroup ].tracked = {}
Trigger[ Trigger.Types.EffectGroup ].party   = nil

-- the trigger types an effect of a party member is checked against
local GROUP_TYPES = { Trigger.Types.EffectGroup }

Trigger[Trigger.Types.EffectGroup].Init = function ()

    -- only the first GetParty works, so it is read once here and kept. A party
    -- change reloads the plugin, by way of the auto reload on the party messages
    -- in chat, and that runs this again with a fresh one.
    Trigger[ Trigger.Types.EffectGroup ].party = LocalPlayer:GetParty()

    Trigger[ Trigger.Types.EffectGroup ].Sync()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- bring the registered callbacks in line with the current party
---------------------------------------------------------------------------------------------------
-- called at start up and whenever group tracking is switched on or off, so that
-- switching it on registers the callbacks instead of leaving them until the next
-- reload. Works off the party read at start up: it never asks the game again.
Trigger[ Trigger.Types.EffectGroup ].Sync = function ()

    local tracked = Trigger[ Trigger.Types.EffectGroup ].tracked
    local present = {}

    -- track group
    if  Data.trackGroupEffects == true then

        local party = Trigger[ Trigger.Types.EffectGroup ].party

        -- party exists
        if party ~= nil then

            local localPlayerName = LpData.name

            -- iterate member
            for i = 1, party:GetMemberCount(), 1 do

                local player     = party:GetMember(i)
                local playerName = player:GetName()

                -- if member ~= lp
                if playerName ~= localPlayerName then

                    present[ playerName ] = true

                    -- only members that are not tracked yet are registered and
                    -- swept, so one member joining does not check the active
                    -- effects of everyone already in the party a second time
                    if tracked[ playerName ] == nil then

                        tracked[ playerName ] = Trigger[ Trigger.Types.EffectGroup ].Register( player, playerName )

                        Trigger[ Trigger.Types.EffectGroup ].CheckMemberEffects( player, playerName, tracked[ playerName ] )

                    end

                end

            end

        end

    end

    -- everyone who left, and everyone at all once tracking is switched off
    for playerName, record in pairs( tracked ) do

        if present[ playerName ] ~= true then

            record.active = false
            Trigger.RemoveCallback( record.effects, "EffectAdded", record.callback )
            tracked[ playerName ] = nil

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- count group effects whose id was already seen for that member ( /gibdebug group )
---------------------------------------------------------------------------------------------------
-- Measures whether lotro sends EffectAdded again for effects a member already
-- has, the way it does for a new target. Only runs while switched on.
-- The ids are kept per member and dropped once there are too many: a repeat
-- arrives shortly after the first one, and the list must not grow for a whole
-- session.
local MAX_SEEN_IDS = 500

local function note_effect_id( record, effect, isEvent )

    local id   = effect:GetID()
    local seen = record.seenIDs

    if isEvent == true then
        DebugStats.groupEffects = DebugStats.groupEffects + 1
    end

    if seen[ id ] == true then

        if isEvent == true then
            DebugStats.groupDuplicates = DebugStats.groupDuplicates + 1
        end

        return

    end

    if record.seenCount >= MAX_SEEN_IDS then
        seen             = {}
        record.seenIDs   = seen
        record.seenCount = 0
    end

    seen[ id ]       = true
    record.seenCount = record.seenCount + 1

end

-- switches the count on or off; switching it on starts from zero, with the
-- effects every tracked member has right now counted as already seen
Trigger[ Trigger.Types.EffectGroup ].SetDuplicateCounting = function ( enabled )

    DebugStats.groupCounting   = enabled
    DebugStats.groupEffects    = 0
    DebugStats.groupDuplicates = 0

    for playerName, record in pairs( Trigger[ Trigger.Types.EffectGroup ].tracked ) do

        record.seenIDs   = {}
        record.seenCount = 0

        if enabled == true then

            for j = 1, record.effects:GetCount(), 1 do
                note_effect_id( record, record.effects:Get(j), false )
            end

        end

    end

end

-- number of members with a registered callback ( used by /gibdebug )
Trigger[ Trigger.Types.EffectGroup ].TrackedCount = function ()

    local count = 0

    for playerName, record in pairs( Trigger[ Trigger.Types.EffectGroup ].tracked ) do
        count = count + 1
    end

    return count

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- register the effect callback of one party member
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectGroup ].Register = function ( player, playerName )

    local effects = player:GetEffects()
    local record  = { effects = effects, active = true, seenIDs = {}, seenCount = 0 }

    -- add
    record.callback = Trigger.AddCallback( effects, "EffectAdded", function ( sender, args )

        -- a callback can outlive the member it was registered for, and tracking
        -- can be switched off without the plugin being reloaded
        if record.active ~= true or Data.trackGroupEffects ~= true then
            return
        end

        local index    = Trigger.EffectIndex.Get( Trigger.Types.EffectGroup )
        local counting = DebugStats.groupCounting == true

        -- without a single group trigger there is nothing to check, so the
        -- effect is not even read unless it is being collected or counted
        if index.empty == true and Options.CollectEffects == false and counting == false then
            return
        end

        local effect = effects:Get(args.Index)

        if counting == true then
            note_effect_id( record, effect, true )
        end

        -- read the effect once for the whole event instead of once per trigger
        local effectView = Trigger.NewEffectView( effect )

        Trigger.AddToEffectCollection( effect, "Group", effectView )

        if index.empty ~= true then
            Trigger.EffectIndex.Check( GROUP_TYPES, effectView, player, playerName )
        end

    end )

    return record

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check the active effects of one party member
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectGroup ].CheckMemberEffects = function ( player, playerName, record )

    local index    = Trigger.EffectIndex.Get( Trigger.Types.EffectGroup )
    local counting = DebugStats.groupCounting == true and record ~= nil

    if index.empty == true and counting == false then
        return
    end

    local effects = player:GetEffects()

    -- iterate effects
    for j = 1, effects:GetCount(), 1 do

        local effect = effects:Get(j)

        -- the effects a member already has, so that EffectAdded for one of
        -- them again counts as a repeat
        if counting == true then
            note_effect_id( record, effect, false )
        end

        if index.empty ~= true then
            Trigger.EffectIndex.Check( GROUP_TYPES, Trigger.NewEffectView( effect ), player, playerName )
        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- trigger index
---------------------------------------------------------------------------------------------------
-- how the group triggers are found for an effect, see TRIGGER/EffectIndex.lua
Trigger.EffectIndex.Register( Trigger.Types.EffectGroup, {
    check = function ( effectView, player, triggerData, playerName )
        return Trigger[ Trigger.Types.EffectGroup ].CheckTrigger( effectView, player, triggerData, playerName )
    end,
    folders           = true,
    conditionDuration = true,
} )
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check trigger
---------------------------------------------------------------------------------------------------
-- the checks are ordered by what they cost: everything that can be answered from
-- the trigger itself, or from a value already read, runs before the first call
-- into the game
Trigger[ Trigger.Types.EffectGroup ].CheckTrigger = function ( effectView, player, triggerData, playerName )

    -- only check for enabled trigger
    if triggerData.enabled == false then
        return nil
    end

    local effectName = Trigger.EffectName( effectView )
    local match      = 1

    -- check token
    if triggerData.useRegex == true then

        if triggerData._cachedPattern == nil then
            triggerData._cachedPattern = Trigger.ReplacePlaceholder(triggerData.token)
        end

        match = string.find( effectName, triggerData._cachedPattern )

        if match == nil then
            return nil
        end

    elseif effectName ~= triggerData.token then

        return nil

    end

    -- exclude self
    if triggerData.excludeSelf == true and player == LocalPlayer then
        return nil
    end

    -- listOfTargets
    -- reading the name is a call into the game, so only ask for it when there is
    -- a list to check it against
    local listOfTargets = triggerData.listOfTargets

    if listOfTargets ~= nil and #listOfTargets > 0 then

        if playerName == nil then
            playerName = player:GetName()
        end

        if Trigger.CheckListForName( playerName, listOfTargets ) == false then
            return nil
        end

    end

    -- icon
    if triggerData.icon ~= nil and triggerData.icon ~= Trigger.EffectIcon( effectView ) then
        return nil
    end

    -- debuff / buff
    if triggerData.isDebuff ~= Source.Any
        and (Trigger.EffectIsDebuff( effectView ) ~= (triggerData.isDebuff == Source.Debuff)) then
        return nil
    end

    -- dispellable
    if triggerData.isDispellable ~= Source.Any
        and (Trigger.EffectIsCurable( effectView ) ~= (triggerData.isDispellable == Source.Dispellable)) then
        return nil
    end

    -- category
    if triggerData.category ~= Source.Any
        and (Trigger.EffectCategory( effectView ) ~= triggerData.category) then
        return nil
    end

    return match

end
---------------------------------------------------------------------------------------------------
