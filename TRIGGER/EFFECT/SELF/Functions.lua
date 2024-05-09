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
        
        Trigger.AddToEffectCollection( effect )

        -- all groups
        for windowIndex, windowData in ipairs(Data.window) do

            Trigger[ Trigger.Types.EffectSelf ].CheckWindows( effect, windowIndex, windowData )
            Trigger[ Trigger.Types.EffectGroup ].CheckWindows( effect, LocalPlayer, windowIndex, windowData )

        end

        for folderIndex, folderData in ipairs(Data.folder) do

            Trigger[ Trigger.Types.EffectSelf ].CheckFolder( effect, folderIndex, folderData )
            Trigger[ Trigger.Types.EffectGroup ].CheckFolder( effect, LocalPlayer, folderIndex, folderData )

        end

    end

    -- remove 
    function effects.EffectRemoved(sender, args)

        -- all groups
        for windowIndex, windowData in ipairs(Data.window) do

            Trigger[ Trigger.Types.EffectRemoveSelf ].CheckWindows( args.Effect, windowIndex, windowData )
        
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
        
        local effect = effects:Get(index)

        -- all groups
        for windowIndex, windowData in ipairs(Data.window) do

            Trigger[ Trigger.Types.EffectSelf ].CheckWindows( effect, windowIndex, windowData )
            Trigger[ Trigger.Types.EffectGroup ].CheckWindows( effect, LocalPlayer, windowIndex, windowData )

        end

        for folderIndex, folderData in ipairs(Data.folder) do

            Trigger[ Trigger.Types.EffectSelf ].CheckFolder( effect, folderIndex, folderData )
            Trigger[ Trigger.Types.EffectGroup ].CheckFolder( effect, LocalPlayer, folderIndex, folderData )

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check folder
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectSelf ].CheckFolder = function(effect, folderIndex, folderData)

    -- check window triggers
    for triggerIndex, triggerData in ipairs(folderData[ Trigger.Types.EffectSelf ]) do
        
        local posAdjustment = Trigger[ Trigger.Types.EffectSelf ].CheckTrigger(effect, triggerData)

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
Trigger[ Trigger.Types.EffectSelf ].CheckWindows = function ( effect, windowIndex, windowData  )

    -- check window triggers
    for triggerIndex, triggerData in ipairs(windowData[ Trigger.Types.EffectSelf ]) do

        local posAdjustment = Trigger[ Trigger.Types.EffectSelf ].CheckTrigger(effect, triggerData)

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
        Trigger[ Trigger.Types.EffectSelf ].CheckTimer(effect, windowIndex, timerIndex, timerData)

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check timer
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectSelf ].CheckTimer = function ( effect, windowIndex, timerIndex, timerData )

    -- only check for enabled timers
    if timerData.enabled == false then
        return
    end

    -- check timer triggers
    for triggerIndex, triggerData in ipairs(timerData[ Trigger.Types.EffectSelf ]) do

        local posAdjustment = Trigger[ Trigger.Types.EffectSelf ].CheckTrigger(effect, triggerData)

        if posAdjustment ~= nil then
            -- fix posAdjustment
            posAdjustment = posAdjustment - 1
            Trigger.ProcessEffectTrigger( effect, LocalPlayer, posAdjustment, windowIndex, timerIndex, triggerData )

        end

    end
    
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check trigger
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectSelf ].CheckTrigger = function ( effect, triggerData )

    -- only check for enabled trigger
    if triggerData.enabled == false then
        return nil
    end

    -- icon
    if triggerData.icon ~= nil and triggerData.icon ~= effect:GetIcon() then
        return nil
    end

    -- debuff / buff
    if triggerData.isDebuff ~= Source.Any
        and (effect:IsDebuff() ~= (triggerData.isDebuff == Source.Debuff)) then
        return nil
    end

    -- dispellable
    if triggerData.isDispellable ~= Source.Any 
        and (effect:IsCurable() ~= (triggerData.isDispellable == Source.Dispellable)) then
        return nil
    end

    -- category
    if triggerData.category ~= Source.Any 
        and (effect:GetCategory() ~= triggerData.category) then
        return nil
    end

    -- check token
    if triggerData.useRegex == true then

        return string.find( effect:GetName(), Trigger.ReplacePlaceholder(triggerData.token) )

    else

        if effect:GetName() == triggerData.token then

            return 1

        end

    end

    return nil
  
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check window
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectRemoveSelf ].CheckWindows = function ( effect, windowIndex, windowData  )
  
      -- only check for enabled windows
      if windowData.enabled == false then
        return
    end

    -- check window triggers
    for triggerIndex, triggerData in ipairs(windowData[ Trigger.Types.EffectRemoveSelf ]) do

        local posAdjustment = Trigger[ Trigger.Types.EffectRemoveSelf ].CheckTrigger(effect, triggerData)

        if posAdjustment ~= nil then
            Windows.WindowAction( windowIndex, windowData, triggerData )

        end

    end


    -- check the timers of the window
    for timerIndex, timerData in ipairs( windowData.timerList ) do
        Trigger[ Trigger.Types.EffectRemoveSelf ].CheckTimer(effect, windowIndex, timerIndex, timerData)

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check timer
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectRemoveSelf ].CheckTimer = function ( effect, windowIndex, timerIndex, timerData  )
  
    -- only check for enabled timers
    if timerData.enabled == false then
        return
    end

    -- check timer triggers
    for triggerIndex, triggerData in ipairs(timerData[ Trigger.Types.EffectRemoveSelf ]) do

        local posAdjustment = Trigger[ Trigger.Types.EffectRemoveSelf ].CheckTrigger(effect, triggerData)

        if posAdjustment ~= nil then
            -- fix posAdjustment
            posAdjustment = posAdjustment - 1
            Trigger.ProcessEffectTrigger( effect, LocalPlayer, posAdjustment, windowIndex, timerIndex, triggerData, true )

        end

    end
    
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check trigger
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectRemoveSelf ].CheckTrigger = function ( effect, triggerData )
  
    -- only check for enabled trigger
    if triggerData.enabled == false then
        return nil
    end

    -- check token
    if triggerData.useRegex == true then

        return string.find( effect:GetName(), Trigger.ReplacePlaceholder(triggerData.token) )

    else

        if effect:GetName() == triggerData.token then

            return 1

        end

    end

    return nil
  
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- process effect trigger
---------------------------------------------------------------------------------------------------
Trigger.ProcessEffectTrigger = function ( effect, player, posAdjustment, windowIndex, timerIndex, triggerData, remove )

    -- declarations
    local windowData = Data.window[windowIndex]
    local timerData = windowData.timerList[timerIndex]
    local name = effect:GetName()
    
    local startTime
    if remove == true then
        startTime= Turbine.Engine.GetGameTime()
    else
        startTime= effect:GetStartTime()
    end
    local text      = ""
    local target    = player:GetName()
    local duration  = 10
    local icon      = timerData.icon
    local entity    = player
    local key       = nil

    local token = triggerData.token
    local placeholder = Trigger.GetPlaceholder(token, effect:GetName(), posAdjustment)

    -- target list
    if Trigger.CheckListForName(target, triggerData.listOfTargets) == false then
        return
    end

    -- key
    if timerData.stacking == Stacking.Multi then
        
        key = effect:GetID()
    
    elseif timerData.stacking == Stacking.PerTarget then

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

        for index, value in pairs(placeholder) do

            text = string.gsub ( text, index, value)

        end

    end

    -- duration  
    if timerData.useCustomTimer == true then
            
        duration = timerData.timerValue

        for index, value in pairs(placeholder) do

            duration = string.gsub ( duration, index, value)

        end

        duration = tonumber( duration )

    else

        duration = effect:GetDuration()

    end

    -- group call  
    Windows[ windowIndex ]:TimerAction( triggerData, timerData, timerIndex, startTime, duration, icon, text, entity, key )

end
---------------------------------------------------------------------------------------------------
