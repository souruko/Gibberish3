
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
function Timer.GetStruct(type)

    local timer = {}

    -- general
    timer.id                    = Turbine.Engine.GetGameTime()
    timer.enabled               = true
    timer.type                  = type
    timer.description           = Timer.Defaults[type].description
    timer.permanent             = Timer.Defaults[type].permanent

    -- stuff
    timer.unique                = Timer.Defaults[type].unique
    timer.removable             = Timer.Defaults[type].removable
    timer.loop                  = Timer.Defaults[type].loop
    timer.reset                 = Timer.Defaults[type].reset

    -- timer
    timer.useCustomTimer        = Timer.Defaults[type].useCustomTimer
    timer.timerValue            = Timer.Defaults[type].timerValue
    timer.direction             = Timer.Defaults[type].direction
    
    -- text / icon
    timer.icon                  = Timer.Defaults[type].icon
    timer.textValue             = Timer.Defaults[type].textValue
    timer.textOption            = Timer.Defaults[type].textOption

    -- animation
    timer.thresholdValue        = Timer.Defaults[type].thresholdValue
    timer.useThreshold          = Timer.Defaults[type].useThreshold
    timer.useAnimation          = Timer.Defaults[type].useAnimation
    timer.animationSpeed        = Timer.Defaults[type].animationSpeed
    timer.animationType         = Timer.Defaults[type].animationType
    timer.useShadow             = Timer.Defaults[type].useShadow

    timer[Trigger.EffectSelf]     = {}
    timer[Trigger.EffectGroup]    = {}
    timer[Trigger.EffectTarget]   = {}
    timer[Trigger.Skill]          = {}
    timer[Trigger.Chat]           = {}
    timer[Trigger.TimerEnd]       = {}
    timer[Trigger.TimerStart]     = {}
    timer[Trigger.TimerThreshold] = {}

    return timer

end


-------------------------------------------------------------------------------------
--      Description:     
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Timer.New(type)

    return Timer.GetStruct(type)

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