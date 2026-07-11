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

                    Condition.CheckAll( timerData, event, function(t)
                        if t.enabled == true and t.token == timerID then return 1 end
                        return nil
                    end)

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

        -- check window triggers
        for triggerIndex, triggerData in ipairs(windowData[ event ]) do

            -- check if trigger is enabled
            if triggerData.enabled == true then

                if triggerData.token == timerID then

                    Windows.WindowAction( windowIndex, windowData, triggerData )
                    
                end
                            
            end
                               
        end

    end

    for folderIndex, folderData in ipairs(Data.folder) do
        
        -- check window triggers
        for triggerIndex, triggerData in ipairs(folderData[ event ]) do

            -- check if trigger is enabled
            if triggerData.enabled == true then

                if triggerData.token == timerID then

                    Windows.FolderAction( folderIndex, folderData, triggerData )

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
    local placeholder = { ["&tag"] = tostring(triggerData.tag or "") }

    local startTime = Turbine.Engine.GetGameTime()
    local text      = timerData.textValue
    for k, v in pairs(placeholder) do text = string.gsub(text, k, v) end
    local duration  = 10
    local icon      = timerData.icon
    local entity    = nil
    local key       = nil

    -- key
    -- every trigger = new timer
    if timerData.permanent == false and
        timerData.stacking == Stacking.Multi then

        key = startTime

    end

    -- duration
    if timerData.useCustomTimer == true then

        duration = timerData.timerValue
        for k, v in pairs(placeholder) do duration = string.gsub(tostring(duration), k, v) end
        duration = tonumber(duration) or duration

    end

    -- window call  
    Windows[ windowIndex ]:TimerAction( triggerData, timerData, timerIndex, startTime, duration, icon, text, entity, key )

end