--=================================================================================================
--= Timer Struct        
--= ===============================================================================================
--= timer struct construction and functions
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- create new timer struct and return it
---------------------------------------------------------------------------------------------------
function Timer.New(type)

    local timer = {}

    -- general
    timer.id                    = Turbine.Engine.GetGameTime()
    timer.nextTriggerSortIndex  = 1
    timer.enabled               = true
    timer.sortIndex             = 0
    timer.type                  = type
    timer.description           = Timer[type].Defaults.description
    timer.permanent             = Timer[type].Defaults.permanent

    -- timer
    timer.unique                = Timer[type].Defaults.unique
    timer.removable             = Timer[type].Defaults.removable
    timer.loop                  = Timer[type].Defaults.loop
    timer.reset                 = Timer[type].Defaults.reset
    timer.useCustomTimer        = Timer[type].Defaults.useCustomTimer
    timer.timerValue            = Timer[type].Defaults.timerValue
    timer.direction             = Timer[type].Defaults.direction
    
    -- text / icon
    timer.icon                  = Timer[type].Defaults.icon
    timer.textValue             = Timer[type].Defaults.textValue
    timer.textOption            = Timer[type].Defaults.textOption

    -- animation
    timer.thresholdValue        = Timer[type].Defaults.thresholdValue
    timer.useThreshold          = Timer[type].Defaults.useThreshold
    timer.useAnimation          = Timer[type].Defaults.useAnimation
    timer.animationSpeed        = Timer[type].Defaults.animationSpeed
    timer.animationType         = Timer[type].Defaults.animationType
    timer.useShadow             = Timer[type].Defaults.useShadow

    timer.counterValue          = Timer[type].Defaults.counterValue

    timer[Trigger.Types.EffectSelf]     = {}
    timer[Trigger.Types.EffectGroup]    = {}
    timer[Trigger.Types.EffectTarget]   = {}
    timer[Trigger.Types.Skill]          = {}
    timer[Trigger.Types.Chat]           = {}
    timer[Trigger.Types.TimerEnd]       = {}
    timer[Trigger.Types.TimerStart]     = {}
    timer[Trigger.Types.TimerThreshold] = {}

    return timer

end
---------------------------------------------------------------------------------------------------
