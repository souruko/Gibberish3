--===================================================================================
--             Name:    TIMER Functions
-------------------------------------------------------------------------------------
--      Description:    Collection of TIMER Functions
--===================================================================================





-------------------------------------------------------------------------------------
--      Description:    create a timer with type and data then return the timer
-------------------------------------------------------------------------------------
--        Parameter:    timer type
--                      timer data
-------------------------------------------------------------------------------------
--           Return:    the created timer element
-------------------------------------------------------------------------------------
function Timer.Create(type, groupData, timerData, timerIndex, startTime, duration, icon, text, entity, key)

    if type == Timer.Types.BAR then

        return BAR.BarElement( groupData, timerData, timerIndex, startTime, duration, icon, text, entity, key )
    
    else

        -- ERROR case
    
    end

end