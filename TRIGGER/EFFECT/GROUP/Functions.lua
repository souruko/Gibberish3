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

                        Trigger[ Trigger.Types.EffectGroup ].CheckMemberEffects( player, playerName )

                    end

                end

            end

        end

    end

    -- everyone who left, and everyone at all once tracking is switched off
    for playerName, record in pairs( tracked ) do

        if present[ playerName ] ~= true then

            record.active = false
            RemoveCallback( record.effects, "EffectAdded", record.callback )
            tracked[ playerName ] = nil

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- register the effect callback of one party member
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectGroup ].Register = function ( player, playerName )

    local effects = player:GetEffects()
    local record  = { effects = effects, active = true }

    -- add
    record.callback = AddCallback( effects, "EffectAdded", function ( sender, args )

        -- a callback can outlive the member it was registered for, and tracking
        -- can be switched off without the plugin being reloaded
        if record.active ~= true or Data.trackGroupEffects ~= true then
            return
        end

        local effect = effects:Get(args.Index)

        Trigger.AddToEffectCollection( effect, "Group" )

        -- read the effect once for the whole event instead of once per trigger
        local effectView = Trigger.NewEffectView( effect )

        -- all groups
        for windowIndex, windowData in ipairs(Data.window) do
            Trigger[ Trigger.Types.EffectGroup ].CheckWindows( effectView, player, windowIndex, windowData, playerName )

        end

        for folderIndex, folderData in ipairs(Data.folder) do
            Trigger[ Trigger.Types.EffectGroup ].CheckFolder( effectView, player, folderIndex, folderData, playerName )

        end

    end )

    return record

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check the active effects of one party member
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectGroup ].CheckMemberEffects = function ( player, playerName )

    local effects = player:GetEffects()

    -- iterate effects
    for j = 1, effects:GetCount(), 1 do

        local effectView = Trigger.NewEffectView( effects:Get(j) )

        -- all groups
        for windowIndex, windowData in ipairs(Data.window) do

            Trigger[ Trigger.Types.EffectGroup ].CheckWindows( effectView, player, windowIndex, windowData, playerName )

        end

        for folderIndex, folderData in ipairs(Data.folder) do

            Trigger[ Trigger.Types.EffectGroup ].CheckFolder( effectView, player, folderIndex, folderData, playerName )

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check folder
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectGroup ].CheckFolder = function(effectView, player, folderIndex, folderData, playerName)

    -- check window triggers
    for triggerIndex, triggerData in ipairs(folderData[ Trigger.Types.EffectGroup ]) do
        
        local posAdjustment = Trigger[ Trigger.Types.EffectGroup ].CheckTrigger(effectView, player, triggerData, playerName)

        if posAdjustment ~= nil then
            -- fix posAdjustment
            posAdjustment = posAdjustment - 1
            Windows.FolderAction( folderIndex, folderData, triggerData )

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check windows
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectGroup ].CheckWindows = function ( effectView, player, windowIndex, windowData, playerName )

    -- check window triggers
    for triggerIndex, triggerData in ipairs(windowData[ Trigger.Types.EffectGroup ]) do
        local posAdjustment = Trigger[ Trigger.Types.EffectGroup ].CheckTrigger(effectView, player, triggerData, playerName)

        if posAdjustment ~= nil then
            Windows.WindowAction( windowIndex, windowData, triggerData )

        end

    end

    -- only check for enabled windows
    if windowData.enabled == false then
        return
    end

    -- check the timers of the window
    for timerIndex, timerData in ipairs( windowData.timerList ) do
        Trigger[ Trigger.Types.EffectGroup ].CheckTimer(effectView, player, windowIndex, timerIndex, timerData, playerName)

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check timer
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectGroup ].CheckTimer = function ( effectView, player, windowIndex, timerIndex, timerData, playerName )

    -- only check for enabled timers
    if timerData.enabled == false then
        return
    end

    if Condition.HasAny( timerData ) then
        Condition.CheckAll( timerData, Trigger.Types.EffectGroup, function(t)
            return Trigger[ Trigger.Types.EffectGroup ].CheckTrigger(effectView, player, t, playerName)
        end, nil, effectView.effect)
    end

    -- check timer triggers
    for triggerIndex, triggerData in ipairs(timerData[ Trigger.Types.EffectGroup ]) do

        local posAdjustment = Trigger[ Trigger.Types.EffectGroup ].CheckTrigger(effectView, player, triggerData, playerName)

        if posAdjustment ~= nil then
            -- fix posAdjustment
            posAdjustment = posAdjustment - 1
            Trigger.ProcessEffectTrigger( effectView.effect, player, posAdjustment, windowIndex, timerIndex, triggerData )

        end

    end

end
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
