--=================================================================================================
--= Effect target          
--= ===============================================================================================
--= trigger from effect target events
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- effect ids of the tracked target that were already processed
---------------------------------------------------------------------------------------------------
local seenEffectIDs = {}

-- lotro fires EffectAdded again for effects that were already checked ( e.g. while filling the
-- effect list of a new target ), every effect id is only processed once per target
local function IsNewEffect( effect )

    local id = effect:GetID()

    if seenEffectIDs[ id ] == true then
        DebugStats.effectsSkipped = DebugStats.effectsSkipped + 1
        return false
    end

    seenEffectIDs[ id ] = true
    return true

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- effect target event processing start up
---------------------------------------------------------------------------------------------------
-- the effect callback registered for the current target
Trigger[ Trigger.Types.EffectTarget ].tracked = nil

-- the trigger types an effect of the target is checked against
local TARGET_TYPES = { Trigger.Types.EffectTarget }

Trigger[Trigger.Types.EffectTarget].Init = function ()

    -- the target is watched even while tracking is switched off, so that
    -- switching it on takes effect without a reload
    function LocalPlayer.TargetChanged( sender1, args1 )

        if Data.trackTargetEffects == true then
            DebugStats.targetChanges = DebugStats.targetChanges + 1
        end

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
        Trigger.RemoveCallback( tracked.effects, "EffectAdded", tracked.callback )
        Trigger[ Trigger.Types.EffectTarget ].tracked = nil

    end

    seenEffectIDs = {}

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

    -- reset on target changed ( before checking the new target, otherwise its timers get reset too )
    if targetChanged == true then

        for windowIndex, windowData in ipairs(Data.window) do

            if windowData.resetOnTargetChanged == true
               and Windows[ windowIndex ] ~= nil then

                Windows[ windowIndex ]:Reset()

            end

        end

    end

    Trigger[ Trigger.Types.EffectTarget ].CheckAllActivEffects( target, targetName )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- returns if a target is currently tracked ( used by /gibdebug )
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectTarget ].IsTracking = function ()

    return Trigger[ Trigger.Types.EffectTarget ].tracked ~= nil

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- register the effect callback of the current target
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectTarget ].Register = function ( target, targetName )

    local effects = target:GetEffects()
    local record  = { effects = effects, active = true }

    record.callback = Trigger.AddCallback( effects, "EffectAdded", function ( sender, args )

        -- a callback can outlive the target it was registered for, and tracking
        -- can be switched off without the plugin being reloaded
        if record.active ~= true or Data.trackTargetEffects ~= true then
            return
        end

        local effect = effects:Get( args.Index )

        if IsNewEffect( effect ) == false then
            return
        end

        -- read the effect once for the whole event instead of once per trigger
        local effectView = Trigger.NewEffectView( effect )

        Trigger.AddToEffectCollection( effect, "Target", effectView )

        Trigger.EffectIndex.Check( TARGET_TYPES, effectView, target, targetName )

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

            local effect = effects:Get(i)

            if IsNewEffect( effect ) == true then

                Trigger.EffectIndex.Check( TARGET_TYPES, Trigger.NewEffectView( effect ), target, targetName )

            end

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- trigger index
---------------------------------------------------------------------------------------------------
-- how the target triggers are found for an effect, see TRIGGER/EffectIndex.lua
Trigger.EffectIndex.Register( Trigger.Types.EffectTarget, {
    check = function ( effectView, target, triggerData, targetName )
        return Trigger[ Trigger.Types.EffectTarget ].CheckTrigger( effectView, target, triggerData, targetName )
    end,
    folders           = true,
    conditionDuration = true,
} )
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
