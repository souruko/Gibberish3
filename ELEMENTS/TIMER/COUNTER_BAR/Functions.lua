--===================================================================================
--             Name:    COUNTER_BAR Functions
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================







-------------------------------------------------------------------------------------
--      Description:    constructor array workaround
-------------------------------------------------------------------------------------
--        Parameter:    parent,
--                      groupData
--                      timerData
--                      timerIndex
--                      startTime
--                      duration
--                      icon
--                      text
--                      entity
--                      key
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
Timer.Constructor[Timer.Types.COUNTER_BAR] = function ( parent,
                                                groupData,
                                                timerData,
                                                timerIndex,
                                                startTime,
                                                duration,
                                                icon,
                                                text,
                                                entity,
                                                key,
                                                activ )

return COUNTER_BAR.CounterBarElement(  parent,
                        groupData,
                        timerData,
                        timerIndex,
                        startTime,
                        duration,
                        icon,
                        text,
                        entity,
                        key,
                        activ )

end
