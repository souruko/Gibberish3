--=================================================================================================
--= Effect Self          
--= ===============================================================================================
--= trigger from effect self events
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- the trigger types an effect of the player is checked against
---------------------------------------------------------------------------------------------------
-- the player counts as a member of the group, so a group trigger also reacts to
-- the player's own effects. Within a window the self triggers run first.
local ADD_TYPES    = { Trigger.Types.EffectSelf, Trigger.Types.EffectGroup }
local REMOVE_TYPES = { Trigger.Types.EffectRemoveSelf }
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- effect self event processing start up
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectSelf ].Init = function ()

    local effects = LocalPlayer:GetEffects()

    -- check all activ effects
    Trigger[ Trigger.Types.EffectSelf ].CheckAllActivEffects()

    -- add
    function effects.EffectAdded(sender, args)

        local effect = effects:Get(args.Index)

        -- the effect is the same for every trigger this event visits, and every
        -- read of it is a call into the game, so read it once here and hand the
        -- same values to all of them
        local effectView = Trigger.NewEffectView( effect )

        Trigger.AddToEffectCollection( effect, "Self", effectView )

        Trigger[ Trigger.Types.EffectSelf ].CheckEffect( effectView )

    end

    -- remove 
    function effects.EffectRemoved(sender, args)

        -- read the effect once for the whole event instead of once per trigger
        local effectView = Trigger.NewEffectView( args.Effect )

        Trigger.EffectIndex.Check( REMOVE_TYPES, effectView, LocalPlayer, LpData.name )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check all activ effects
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectSelf ].CheckAllActivEffects = function ()
    
    local effects = LocalPlayer:GetEffects()

    for index = 1, effects:GetCount(), 1 do
        
        local effectView = Trigger.NewEffectView( effects:Get(index) )

        Trigger[ Trigger.Types.EffectSelf ].CheckEffect( effectView )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check one effect on the player against the self and the group triggers
---------------------------------------------------------------------------------------------------
-- both come from their trigger index, see TRIGGER/EffectIndex.lua, and run
-- window by window, the self triggers of a window before its group triggers,
-- the order the full walks always fired them in
Trigger[ Trigger.Types.EffectSelf ].CheckEffect = function ( effectView )

    Trigger.EffectIndex.Check( ADD_TYPES, effectView, LocalPlayer, LpData.name )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- trigger index
---------------------------------------------------------------------------------------------------
-- how the self triggers are found for an effect, see TRIGGER/EffectIndex.lua
Trigger.EffectIndex.Register( Trigger.Types.EffectSelf, {
    check = function ( effectView, player, triggerData, playerName )
        return Trigger[ Trigger.Types.EffectSelf ].CheckTrigger( effectView, triggerData )
    end,
    folders           = true,
    conditionDuration = true,
} )

-- a removed effect is only looked for in enabled windows, its window triggers
-- included, and never in folders; a condition it sets has no duration to take
Trigger.EffectIndex.Register( Trigger.Types.EffectRemoveSelf, {
    check = function ( effectView, player, triggerData, playerName )
        return Trigger[ Trigger.Types.EffectRemoveSelf ].CheckTrigger( effectView, triggerData )
    end,
    folders                         = false,
    windowTriggersNeedEnabledWindow = true,
    conditionDuration               = false,
    remove                          = true,
} )
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check trigger
---------------------------------------------------------------------------------------------------
-- the checks are ordered by what they cost: everything that can be answered from
-- the trigger itself, or from a value already read, runs before the first call
-- into the game
Trigger[ Trigger.Types.EffectSelf ].CheckTrigger = function ( effectView, triggerData )

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
-- check trigger
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectRemoveSelf ].CheckTrigger = function ( effectView, triggerData )
  
    -- only check for enabled trigger
    if triggerData.enabled == false then
        return nil
    end

    local effectName = Trigger.EffectName( effectView )

    -- check token
    if triggerData.useRegex == true then

        -- the pattern used to be rebuilt for every trigger on every effect that
        -- dropped off the player
        if triggerData._cachedPattern == nil then
            triggerData._cachedPattern = Trigger.ReplacePlaceholder(triggerData.token)
        end

        return string.find( effectName, triggerData._cachedPattern )

    elseif effectName == triggerData.token then

        return 1

    end

    return nil
  
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- process effect trigger
---------------------------------------------------------------------------------------------------
-- takes the effect view of the event: the name and icon were already read by the
-- trigger checks, and reading them again would be a call into the game each
Trigger.ProcessEffectTrigger = function ( effectView, player, posAdjustment, windowIndex, timerIndex, triggerData, remove, playerName )

    -- declarations
    local effect     = effectView.effect
    local windowData = Data.window[windowIndex]
    local timerData = windowData.timerList[timerIndex]
    local name = Trigger.EffectName( effectView )

    -- callers that already read it pass it in
    local target = playerName

    if target == nil then
        target = player:GetName()
    end

    -- target list, before anything is built for a trigger that is about to be
    -- dropped
    if Trigger.CheckListForName(target, triggerData.listOfTargets) == false then
        return
    end

    local startTime
    if remove == true then
        startTime= Turbine.Engine.GetGameTime()
    else
        startTime= effect:GetStartTime()
    end
    local text      = ""
    local duration  = 10
    local icon      = timerData.icon
    local entity    = player
    local key       = nil

    local token = triggerData.token

    -- placeholders cost a pattern build and a match, and only custom text and a
    -- custom duration ever read them, so they are built when one of those asks
    local placeholder = nil

    -- key
    if timerData.permanent == false and
        timerData.stacking == Stacking.Multi then
        
        key = effect:GetID()
    
    elseif timerData.permanent == false and
        timerData.stacking == Stacking.PerTarget then

        -- the name of player, read once above
        key = target

    end

    -- icon
    if icon == nil then
        icon = Trigger.EffectIcon( effectView )
    end

    -- text   
    if timerData.textOption == TimerTextOptions.Target then

        text = Trigger.TextTargetParse(name, target)
        
    elseif  timerData.textOption == TimerTextOptions.Token then

        text = name

    elseif timerData.textOption == TimerTextOptions.CustomText then

        text = timerData.textValue

        if placeholder == nil then
            placeholder = Trigger.GetPlaceholder(token, name, posAdjustment, target, triggerData)
        end

        for index, value in pairs(placeholder) do

            text = string.gsub ( text, index, value)

        end

    end

    -- duration
    if timerData.useCustomTimer == true then

        duration = timerData.timerValue

        if placeholder == nil then
            placeholder = Trigger.GetPlaceholder(token, name, posAdjustment, target, triggerData)
        end

        for index, value in pairs(placeholder) do

            duration = string.gsub( tostring(duration), index, value)

        end

        duration = tonumber( duration ) or duration

    else

        duration = effect:GetDuration()

    end

    -- group call  
    Windows[ windowIndex ]:TimerAction( triggerData, timerData, timerIndex, startTime, duration, icon, text, entity, key )

end
---------------------------------------------------------------------------------------------------
