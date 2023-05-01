--===================================================================================
--             Name:    TRIGGER TIMER Start
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================




-------------------------------------------------------------------------------------
--      Description:   
-------------------------------------------------------------------------------------
--        Parameter:   
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
function Trigger.TIMER_START.Event( timerID )

    for groupIndex, groupData in ipairs(Data.group) do                                      -- all groups

        if groupData.enabled == true then                                                   -- check if group is enabled

            for timerIndex, timerData in ipairs(groupData.timerList) do                     -- all timer of the group

                if timerData.enabled == true then                                           -- check if timer is enabled
                
                    for triggerIndex, triggerData in ipairs(timerData.timerStartTrigger) do -- all effect self of the timer

                        if triggerData.enabled == true then                                 -- check if trigger is enabled

                            if triggerData.token == timerID then

                                Timer.ProcessTimerTrigger(
                                    groupIndex,
                                    timerIndex,
                                    triggerData
                                )
                                
                            end
                                        
                        end
                               
                    end

                end

            end
            
        end

    end

end