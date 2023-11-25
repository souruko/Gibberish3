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

        Trigger[ Trigger.Types.EffectSelf ].EffectAdded( effect )
        Trigger[ Trigger.Types.EffectGroup ].EffectAdded( effect, LocalPlayer )

    end

    -- remove 
    function effects.EffectRemoved(sender, args)

        Trigger[ Trigger.Types.EffectSelf ].EffectRemoved( args.Effect )

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
    
        Trigger[ Trigger.Types.EffectSelf ].EffectAdded( effect )
        Trigger[ Trigger.Types.EffectGroup ].EffectAdded( effect, LocalPlayer )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check if added effect is tracked
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectSelf ].EffectAdded = function ( effect )

    local name = effect:GetName()
    local icon = effect:GetIcon()

    -- all groups
    for windowIndex, windowData in ipairs(Data.window) do                                      

        -- check if group is enabled
        if windowData.enabled == true then                                                   

            -- all timer of the group
            for timerIndex, timerData in ipairs(windowData.timerList) do                     

                -- check if timer is enabled
                if timerData.enabled == true then                                           
                
                    -- all effect self of the timer
                    for triggerIndex, triggerData in ipairs(timerData[Trigger.Types.EffectSelf]) do 

                        -- check if trigger is enabled
                        if triggerData.enabled == true then                                 

                            -- fix token
                            local token = Trigger.ReplacePlaceholder(triggerData.token)       

                            if triggerData.useRegex == true then

                                local pos1 = string.find( name, token )

                                if pos1 ~= nil then

                                    Trigger.ProcessEffectTrigger(   
                                                                    effect,
                                                                    LocalPlayer,
                                                                    windowIndex,
                                                                    timerIndex,
                                                                    triggerData,
                                                                    (pos1 - 1)
                                                                )

                                end

                            else

                                if name == token then

                                    Trigger.ProcessEffectTrigger(       
                                                                    effect,
                                                                    LocalPlayer,
                                                                    windowIndex,
                                                                    timerIndex,
                                                                    triggerData,
                                                                    0
                                                                )
                                    
                                end
                                   
                               
                            end

                        end

                    end
                    
                end

            end

        end
        
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check if removed effect is tracked
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectSelf ].EffectRemoved = function ( effect )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- process effect trigger
---------------------------------------------------------------------------------------------------
Trigger.ProcessEffectTrigger = function ( effect, player, windowIndex, timerIndex, triggerData, posAdjustment )

    -- declarations
    local windowData = Data.window[windowIndex]
    local timerData = windowData.timerList[timerIndex]
    local name = effect:GetName()
    
    local startTime = effect:GetStartTime()
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
    if timerData.unique == false then

        key = effect:GetID()
        
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
    if triggerData.action == Actions.Add then

        Windows[windowIndex]:Add( windowData, timerData, timerIndex, startTime, duration, icon, text, entity, key )
    
    elseif triggerData.action == Actions.Remove then

        Windows[windowIndex]:Remove(windowData, timerData, timerIndex, startTime, icon, text, entity, key)

    elseif triggerData.action == Actions.Reset then

        Windows[windowIndex]:ResetAction(windowData, timerData, timerIndex, startTime, icon, text, entity, key)

    end

end
---------------------------------------------------------------------------------------------------
