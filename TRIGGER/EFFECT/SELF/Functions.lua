--=================================================================================================
--= Effect Self          
--= ===============================================================================================
--= trigger from effect self events
--=================================================================================================



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

        Trigger.AddToEffectCollection( effect, "Self" )

        -- the effect is the same for every trigger this event visits, and every
        -- read of it is a call into the game, so read it once here and hand the
        -- same values to all of them
        local effectView = Trigger.NewEffectView( effect )

        -- all groups
        for windowIndex, windowData in ipairs(Data.window) do

            Trigger[ Trigger.Types.EffectSelf ].CheckWindows( effectView, windowIndex, windowData )
            Trigger[ Trigger.Types.EffectGroup ].CheckWindows( effectView, LocalPlayer, windowIndex, windowData, LpData.name )

        end

        for folderIndex, folderData in ipairs(Data.folder) do

            Trigger[ Trigger.Types.EffectSelf ].CheckFolder( effectView, folderIndex, folderData )
            Trigger[ Trigger.Types.EffectGroup ].CheckFolder( effectView, LocalPlayer, folderIndex, folderData, LpData.name )

        end

    end

    -- remove 
    function effects.EffectRemoved(sender, args)

        -- read the effect once for the whole event instead of once per trigger
        local effectView = Trigger.NewEffectView( args.Effect )

        -- all groups
        for windowIndex, windowData in ipairs(Data.window) do

            Trigger[ Trigger.Types.EffectRemoveSelf ].CheckWindows( effectView, windowIndex, windowData )
        
        end

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

        -- all groups
        for windowIndex, windowData in ipairs(Data.window) do

            Trigger[ Trigger.Types.EffectSelf ].CheckWindows( effectView, windowIndex, windowData )
            Trigger[ Trigger.Types.EffectGroup ].CheckWindows( effectView, LocalPlayer, windowIndex, windowData, LpData.name )

        end

        for folderIndex, folderData in ipairs(Data.folder) do

            Trigger[ Trigger.Types.EffectSelf ].CheckFolder( effectView, folderIndex, folderData )
            Trigger[ Trigger.Types.EffectGroup ].CheckFolder( effectView, LocalPlayer, folderIndex, folderData, LpData.name )

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check folder
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectSelf ].CheckFolder = function(effectView, folderIndex, folderData)

    -- check window triggers
    for triggerIndex, triggerData in ipairs(folderData[ Trigger.Types.EffectSelf ]) do

        local posAdjustment = Trigger[ Trigger.Types.EffectSelf ].CheckTrigger(effectView, triggerData)

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
Trigger[ Trigger.Types.EffectSelf ].CheckWindows = function ( effectView, windowIndex, windowData )

    -- check window triggers
    for triggerIndex, triggerData in ipairs(windowData[ Trigger.Types.EffectSelf ]) do

        local posAdjustment = Trigger[ Trigger.Types.EffectSelf ].CheckTrigger(effectView, triggerData)

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
        Trigger[ Trigger.Types.EffectSelf ].CheckTimer(effectView, windowIndex, timerIndex, timerData)

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check timer
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectSelf ].CheckTimer = function ( effectView, windowIndex, timerIndex, timerData )

    -- only check for enabled timers
    if timerData.enabled == false then
        return
    end

    if Condition.HasAny( timerData ) then
        Condition.CheckAll( timerData, Trigger.Types.EffectSelf, function(t)
            return Trigger[ Trigger.Types.EffectSelf ].CheckTrigger(effectView, t)
        end, nil, effectView.effect)
    end

    -- check timer triggers
    for triggerIndex, triggerData in ipairs(timerData[ Trigger.Types.EffectSelf ]) do

        local posAdjustment = Trigger[ Trigger.Types.EffectSelf ].CheckTrigger(effectView, triggerData)

        if posAdjustment ~= nil then
            -- fix posAdjustment
            posAdjustment = posAdjustment - 1
            Trigger.ProcessEffectTrigger( effectView.effect, LocalPlayer, posAdjustment, windowIndex, timerIndex, triggerData, nil, LpData.name )

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
-- check window
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectRemoveSelf ].CheckWindows = function ( effectView, windowIndex, windowData  )
  
      -- only check for enabled windows
      if windowData.enabled == false then
        return
    end

    -- check window triggers
    for triggerIndex, triggerData in ipairs(windowData[ Trigger.Types.EffectRemoveSelf ]) do

        local posAdjustment = Trigger[ Trigger.Types.EffectRemoveSelf ].CheckTrigger(effectView, triggerData)

        if posAdjustment ~= nil then
            Windows.WindowAction( windowIndex, windowData, triggerData )

        end

    end


    -- check the timers of the window
    for timerIndex, timerData in ipairs( windowData.timerList ) do
        Trigger[ Trigger.Types.EffectRemoveSelf ].CheckTimer(effectView, windowIndex, timerIndex, timerData)

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check timer
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectRemoveSelf ].CheckTimer = function ( effectView, windowIndex, timerIndex, timerData  )

    -- only check for enabled timers
    if timerData.enabled == false then
        return
    end

    if Condition.HasAny( timerData ) then
        Condition.CheckAll( timerData, Trigger.Types.EffectRemoveSelf, function(t)
            return Trigger[ Trigger.Types.EffectRemoveSelf ].CheckTrigger(effectView, t)
        end)
    end

    -- check timer triggers
    for triggerIndex, triggerData in ipairs(timerData[ Trigger.Types.EffectRemoveSelf ]) do

        local posAdjustment = Trigger[ Trigger.Types.EffectRemoveSelf ].CheckTrigger(effectView, triggerData)

        if posAdjustment ~= nil then
            -- fix posAdjustment
            posAdjustment = posAdjustment - 1
            Trigger.ProcessEffectTrigger( effectView.effect, LocalPlayer, posAdjustment, windowIndex, timerIndex, triggerData, true, LpData.name )

        end

    end
    
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
Trigger.ProcessEffectTrigger = function ( effect, player, posAdjustment, windowIndex, timerIndex, triggerData, remove, playerName )

    -- declarations
    local windowData = Data.window[windowIndex]
    local timerData = windowData.timerList[timerIndex]
    local name = effect:GetName()

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

        key = player:GetName()

    end

    -- icon
    if icon == nil then
        icon = effect:GetIcon()
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
