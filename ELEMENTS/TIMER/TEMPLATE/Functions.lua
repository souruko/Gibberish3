--===================================================================================
--             Name:    TEMPLATE Functions
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
Timer.Constructor[Timer.Types.TEMPLATE] = function ( parent,
                                                groupData,
                                                timerData,
                                                timerIndex,
                                                startTime,
                                                duration,
                                                icon,
                                                text,
                                                entity,
                                                key )

return TEMPLATE.TemplateElement(  parent,
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
