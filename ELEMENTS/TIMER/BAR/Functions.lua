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
                                                key,
                                                activ )

return BAR.BarElement(  parent,
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



-------------------------------------------------------------------------------------
--      Description:    constructor array workaround
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
Timer.Options[ Timer.Types.BAR ] = function ()

    return TIMER.OPTIONS.BarOptions()

end
