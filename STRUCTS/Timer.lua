
--===================================================================================
--             Name:    STRUCTS - Timer
-------------------------------------------------------------------------------------
--      Description:    Timer structure and functions
--===================================================================================





-------------------------------------------------------------------------------------
--      Description:     
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Timer.GetStruct()

    local timer = {}

    timer.id = Turbine.Engine.GetGameTime()
    timer.enabled = true


    timer.effectSelfTrigger = {}
    timer.effectGroupTrigger = {}
    timer.effectTargetTrigger = {}
    timer.skillTrigger = {}
    timer.chatTrigger = {}

    return timer

end


-------------------------------------------------------------------------------------
--      Description:     
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Timer.New()

    return Timer.GetStruct()

end


-------------------------------------------------------------------------------------
--      Description:     
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Timer.Delete()


end