--=================================================================================================
--= Skill         
--= ===============================================================================================
--= trigger from skill reset time changed
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- skill event processing start up
---------------------------------------------------------------------------------------------------
Trigger[Trigger.Types.Combat].Init = function ()

    function LocalPlayer.InCombatChanged( sender, args)
        
        if LocalPlayer:IsInCombat() == true then

            Trigger.CheckCombat( Source.CombatStart )

        else

            Trigger.CheckCombat( Source.CombatEnd )

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- skill event processing start up
---------------------------------------------------------------------------------------------------
Trigger[Trigger.Types.Combat].Check = function ( combatState )

    -- all groups
    for windowIndex, windowData in ipairs(Data.window) do                                                     

        -- check if group is enabled
        if windowData.enabled == true then                                                                   

            -- all timer of the group
            for timerIndex, timerData in ipairs(windowData.timerList) do                                     

                -- check if timer is enabled
                if timerData.enabled == true then                                                           
                
                    -- all effect self of the timer
                    for triggerIndex, triggerData in ipairs(timerData[ Trigger.Types.Combat ]) do                 

                        -- check if trigger is enabled
                        if triggerData.enabled == true then

                            -- check if combatState matches
                            if triggerData.source == Source.Any
                            or triggerData.source == combatState then

                                Trigger[Trigger.Types.Combat].ProcessTrigger(
                                                                                combatState,
                                                                                windowIndex,
                                                                                timerIndex,
                                                                                triggerIndex
                                                                            )
                                
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
-- process skill trigger
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.Combat ].ProcessTrigger = function ( combatState, windowIndex, timerIndex, triggerIndex )

    -- declarations
    local windowData = Data.window[windowIndex]
    local timerData = windowData.timerList[timerIndex]
    local triggerData = timerData[Trigger.Types.Skill][triggerIndex]

    
    local startTime = Turbine.Engine.GetGameTime()
    local text      = ""
    local duration  = 10
    local icon      = timerData.icon
    local entity    = nil
    local key       = nil

    local token = triggerData.token

    -- key
    if timerData.unique == false then

        key              = CombatTriggerID
        CombatTriggerID  = CombatTriggerID + 1
        
    end

    -- text
    if timerData.textOption == TimerTextOptions.CustomText then

       text = timerData.textValue

    elseif timerData.textOption == TimerTextOptions.NoText then

        text      = ""

    else

        if combatState == Source.CombatStart then
            text = "Combat Start"
        else
            text = "Combat End"
        end

    end

    -- duration
    if timerData.useCustomTimer == true then

        duration = timerData.timerValue

    end

    -- window call
    Windows[ windowIndex ]:Action(  windowData, timerData, timerIndex, startTime, triggerData.action, duration, icon, text, entity, key )


end
---------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------
CombatTriggerID = 1
---------------------------------------------------------------------------------------------------