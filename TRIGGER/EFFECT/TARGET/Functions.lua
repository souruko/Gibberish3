--=================================================================================================
--= Effect target          
--= ===============================================================================================
--= trigger from effect target events
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- effect target event processing start up
---------------------------------------------------------------------------------------------------
-- the effect callback registered for the current target
Trigger[ Trigger.Types.EffectTarget ].tracked = nil

Trigger[Trigger.Types.EffectTarget].Init = function ()

    -- the target is watched even while tracking is switched off, so that
    -- switching it on takes effect without a reload
    function LocalPlayer.TargetChanged( sender1, args1 )

        Trigger[ Trigger.Types.EffectTarget ].Sync( true )

    end

    Trigger[ Trigger.Types.EffectTarget ].Sync( false )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- register the current target and drop the one before it
---------------------------------------------------------------------------------------------------
-- called on every target change, at start up and whenever target tracking is
-- switched on or off
Trigger[ Trigger.Types.EffectTarget ].Sync = function ( targetChanged )

    -- the previous target is always dropped first. It used to be left registered
    -- whenever the new target was the local player or nothing at all, and went on
    -- firing target triggers for something no longer targeted.
    local tracked = Trigger[ Trigger.Types.EffectTarget ].tracked

    if tracked ~= nil then

        tracked.active = false
        RemoveCallback( tracked.effects, "EffectAdded", tracked.callback )
        Trigger[ Trigger.Types.EffectTarget ].tracked = nil

    end

    -- track target
    if Data.trackTargetEffects ~= true then
        return
    end

    local target = LocalPlayer:GetTarget()

    if  target == nil or
        target:IsLocalPlayer() or
        target.GetEffects == nil then

        return

    end

    -- the name cannot change while this stays the target, so it is read once here
    -- rather than once per trigger checked
    local targetName = target:GetName()

    Trigger[ Trigger.Types.EffectTarget ].tracked = Trigger[ Trigger.Types.EffectTarget ].Register( target, targetName )

    Trigger[ Trigger.Types.EffectTarget ].CheckAllActivEffects( target, targetName )

    -- reset on target changed
    if targetChanged == true then

        for windowIndex, windowData in ipairs(Data.window) do

            if windowData.resetOnTargetChanged == true
               and Windows[ windowIndex ] ~= nil then

                Windows[ windowIndex ]:Reset()

            end

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- register the effect callback of the current target
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectTarget ].Register = function ( target, targetName )

    local effects = target:GetEffects()
    local record  = { effects = effects, active = true }

    record.callback = AddCallback( effects, "EffectAdded", function ( sender, args )

        -- a callback can outlive the target it was registered for, and tracking
        -- can be switched off without the plugin being reloaded
        if record.active ~= true or Data.trackTargetEffects ~= true then
            return
        end

        local effect = effects:Get( args.Index )

        Trigger.AddToEffectCollection( effect, "Target" )

        -- read the effect once for the whole event instead of once per trigger
        local effectView = Trigger.NewEffectView( effect )

        -- all groups
        for windowIndex, windowData in ipairs(Data.window) do

            Trigger[ Trigger.Types.EffectTarget ].CheckWindows( effectView, target, windowIndex, windowData, targetName )

        end

        -- all folder
        for folderIndex, folderData in ipairs(Data.folder) do

            Trigger[ Trigger.Types.EffectTarget ].CheckFolder( effectView, target, folderIndex, folderData, targetName )

        end

    end )

    return record

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check all activ effects
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectTarget ].CheckAllActivEffects = function( target, targetName )

    if target == nil then
        target = LocalPlayer:GetTarget()
    end

    if target ~= nil and target.GetEffects ~= nil then

        if targetName == nil then
            targetName = target:GetName()
        end

        local effects = target:GetEffects()
        
        for i = 1, effects:GetCount(), 1 do

            local effectView = Trigger.NewEffectView( effects:Get(i) )
     
            -- all windows
            for windowIndex, windowData in ipairs(Data.window) do

                Trigger[ Trigger.Types.EffectTarget ].CheckWindows( effectView, target, windowIndex, windowData, targetName )

            end


            -- all folder
            for folderIndex, folderData in ipairs(Data.folder) do

                Trigger[ Trigger.Types.EffectTarget ].CheckFolder( effectView, target, folderIndex, folderData, targetName )

            end

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check folder
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectTarget ].CheckFolder = function(effectView, target, folderIndex, folderData, targetName)

    -- check window triggers
    for triggerIndex, triggerData in ipairs(folderData[ Trigger.Types.EffectTarget ]) do
        
        local posAdjustment = Trigger[ Trigger.Types.EffectTarget ].CheckTrigger(effectView, target, triggerData, targetName)

        if posAdjustment ~= nil then
            -- fix posAdjustment
            posAdjustment = posAdjustment - 1
            Windows.FolderAction( folderIndex, folderData, triggerData )

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check if added effect is tracked
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectTarget ].CheckWindows = function ( effectView, target, windowIndex, windowData, targetName )

    -- check window triggers
    for triggerIndex, triggerData in ipairs(windowData[ Trigger.Types.EffectTarget ]) do
        local posAdjustment = Trigger[ Trigger.Types.EffectTarget ].CheckTrigger(effectView, target, triggerData, targetName)

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
        Trigger[ Trigger.Types.EffectTarget ].CheckTimer(effectView, target, windowIndex, timerIndex, timerData, targetName)

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check if added effect is tracked
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectTarget ].CheckTimer = function ( effectView, target, windowIndex, timerIndex, timerData, targetName )

    -- only check for enabled timers
    if timerData.enabled == false then
        return
    end

    if Condition.HasAny( timerData ) then
        Condition.CheckAll( timerData, Trigger.Types.EffectTarget, function(t)
            return Trigger[ Trigger.Types.EffectTarget ].CheckTrigger(effectView, target, t, targetName)
        end, nil, effectView.effect)
    end

    -- check timer triggers
    for triggerIndex, triggerData in ipairs(timerData[ Trigger.Types.EffectTarget ]) do

        local posAdjustment = Trigger[ Trigger.Types.EffectTarget ].CheckTrigger(effectView, target, triggerData, targetName)

        if posAdjustment ~= nil then
            -- fix posAdjustment
            posAdjustment = posAdjustment - 1
            Trigger.ProcessEffectTrigger( effectView.effect, target, posAdjustment, windowIndex, timerIndex, triggerData )

        end

    end
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check if added effect is tracked
---------------------------------------------------------------------------------------------------
-- the checks are ordered by what they cost: everything that can be answered from
-- the trigger itself, or from a value already read, runs before the first call
-- into the game
Trigger[ Trigger.Types.EffectTarget ].CheckTrigger = function ( effectView, target, triggerData, targetName )

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

    -- check listOfTargets
    -- reading the name is a call into the game, so only ask for it when there is
    -- a list to check it against
    local listOfTargets = triggerData.listOfTargets

    if listOfTargets ~= nil and #listOfTargets > 0 then

        if targetName == nil then
            targetName = target:GetName()
        end

        if Trigger.CheckListForName( targetName, listOfTargets ) == false then
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

---------------------------------------------------------------------------------------------------
-- callbacks
---------------------------------------------------------------------------------------------------
function AddCallback(object, event, callback)
    if (object[event] == nil) then
        object[event] = callback;
    else
        if (type(object[event]) == "table") then
            table.insert(object[event], callback);
        else
            object[event] = {object[event], callback};
        end
    end
    return callback;
end

function RemoveCallback(object, event, callback)
    if (object[event] == callback) then
        object[event] = nil;
    else
        if (type(object[event]) == "table") then
            local size = table.getn(object[event]);
            for i = 1, size do
                if (object[event][i] == callback) then
                    table.remove(object[event], i);
                    break;
                end
            end
        end
    end
end
---------------------------------------------------------------------------------------------------
