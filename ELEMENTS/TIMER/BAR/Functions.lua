--===================================================================================
--             Name:    BAR Functions
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
Timer.Constructor[Timer.Types.BAR] = function ( parent,
                                                groupData,
                                                timerData,
                                                timerIndex,
                                                startTime,
                                                duration,
                                                icon,
                                                text,
                                                entity,
                                                key )

return BAR.BarElement(  parent,
                        groupData,
                        timerData,
                        timerIndex,
                        startTime,
                        duration,
                        icon,
                        text,
                        entity,
                        key )

end
