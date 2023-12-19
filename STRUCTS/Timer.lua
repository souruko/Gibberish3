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
    timer.stacking                = Timer[type].Defaults.stacking
    timer.loop                  = Timer[type].Defaults.loop
    timer.reset                 = Timer[type].Defaults.reset
    timer.useCustomTimer        = Timer[type].Defaults.useCustomTimer
    timer.timerValue            = Timer[type].Defaults.timerValue
    timer.direction             = Timer[type].Defaults.direction
    timer.counterEND            = Timer[type].Defaults.counterEND
    timer.counterSTART          = Timer[type].Defaults.counterSTART
    
    -- text / icon
    timer.icon                  = Timer[type].Defaults.icon
    timer.showIcon              = Timer[type].Defaults.showIcon
    timer.textOption            = Timer[type].Defaults.textOption
    timer.textValue             = Timer[type].Defaults.textValue

    -- animation
    timer.thresholdValue        = Timer[type].Defaults.thresholdValue
    timer.useThreshold          = Timer[type].Defaults.useThreshold
    timer.useAnimation          = Timer[type].Defaults.useAnimation
    timer.animationSpeed        = Timer[type].Defaults.animationSpeed
    timer.animationType         = Timer[type].Defaults.animationType
    timer.useShadow             = Timer[type].Defaults.useShadow

    for index, triggerType in pairs( Trigger.Types ) do

        timer[triggerType] = {}
    
    end

    return timer

end
---------------------------------------------------------------------------------------------------
