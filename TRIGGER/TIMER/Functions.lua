--=================================================================================================
--= Timer Events          
--= ===============================================================================================
--= trigger from timer events
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- timer event processing start up
---------------------------------------------------------------------------------------------------
Trigger.TimerEvent = function ( timerID, event )

    -- all groups
    for windowIndex, windowData in ipairs(Data.window) do                                      

         -- check if group is enabled
        if windowData.enabled == true then                                                  

            -- all timer of the group
            for timerIndex, timerData in ipairs(windowData.timerList) do                     

                -- check if timer is enabled
                if timerData.enabled == true then                                           
                
                    -- all effect self of the timer
                    for triggerIndex, triggerData in ipairs(timerData[ event ]) do 

                         -- check if trigger is enabled
                        if triggerData.enabled == true then                                

                            if triggerData.token == timerID then

                                Trigger.ProcessTimerTrigger( windowIndex, timerIndex, triggerData )
                                
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
-- timer event processing start up
---------------------------------------------------------------------------------------------------
Trigger.ProcessTimerTrigger = function ( windowIndex, timerIndex, triggerData )

    -- declaration
    local windowData = Data.window[windowIndex]
    local timerData = windowData.timerList[timerIndex]

    local startTime = Turbine.Engine.GetGameTime()
    local text      = timerData.textValue
    local duration  = 10
    local icon      = timerData.icon
    local entity    = nil
    local key       = nil

    -- key
    if timerData.unique == false then

        key = startTime
        
    end

    -- duration  
    if timerData.useCustomTimer == true then
            
        duration = timerData.timerValue

    end

    -- window call  
    Windows[ windowIndex ]:Action(  windowData, timerData, timerIndex, startTime, triggerData.action, duration, icon, text, entity, key )

end