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

    timer.id                    = Turbine.Engine.GetGameTime()
    timer.nextTriggerSortIndex  = 1
    timer.enabled               = true
    timer.sortIndex             = 0
    timer.type                  = type
    

    -- general
    timer.description           = Timer[type].Defaults.description
    timer.permanent             = Timer[type].Defaults.permanent
    timer.stacking              = Timer[type].Defaults.stacking
    timer.loop                  = Timer[type].Defaults.loop
    timer.reset                 = Timer[type].Defaults.reset
    timer.useCustomTimer        = Timer[type].Defaults.useCustomTimer
    timer.timerValue            = Timer[type].Defaults.timerValue

    timer.counterEND            = Timer[type].Defaults.counterEND
    timer.counterSTART          = Timer[type].Defaults.counterSTART

    
    -- style
    timer.icon                  = Timer[type].Defaults.icon
    timer.showIcon              = Timer[type].Defaults.showIcon
    timer.textOption            = Timer[type].Defaults.textOption
    timer.textValue             = Timer[type].Defaults.textValue
    timer.direction             = Timer[type].Defaults.direction

    -- animation
    timer.useThreshold          = Timer[type].Defaults.useThreshold
    timer.thresholdValue        = Timer[type].Defaults.thresholdValue
    timer.useAnimation          = Timer[type].Defaults.useAnimation
    timer.animationSpeed        = Timer[type].Defaults.animationSpeed
    timer.animationType         = Timer[type].Defaults.animationType
    timer.useShadow             = Timer[type].Defaults.useShadow

    -- trigger
    for index, triggerType in pairs( Trigger.Types ) do

        timer[triggerType] = {}

    end

    return timer

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- copy timer struct and return it
---------------------------------------------------------------------------------------------------
function Timer.Copy( data )

    local timer = {}

    -- general
    timer.id                    = Turbine.Engine.GetGameTime()
    timer.nextTriggerSortIndex  = data.nextTriggerSortIndex
    timer.enabled               = data.enabled
    timer.sortIndex             = data.sortIndex
    timer.type                  = data.type
    timer.description           = data.description
    timer.permanent             = data.permanent

    -- timer
    timer.stacking              = data.stacking
    timer.loop                  = data.loop
    timer.reset                 = data.reset
    timer.useCustomTimer        = data.useCustomTimer
    timer.timerValue            = data.timerValue    
    timer.direction             = data.direction     
    timer.counterEND            = data.counterEND    
    timer.counterSTART          = data.counterSTART  
    
    -- text / icon
    timer.icon                  = data.icon      
    timer.showIcon              = data.showIcon  
    timer.textOption            = data.textOption
    timer.textValue             = data.textValue 

    -- animation
    timer.thresholdValue        = data.thresholdValue
    timer.useThreshold          = data.useThreshold  
    timer.useAnimation          = data.useAnimation  
    timer.animationSpeed        = data.animationSpeed
    timer.animationType         = data.animationType 
    timer.useShadow             = data.useShadow     

    for name, triggerType in pairs( Trigger.Types ) do

        timer[triggerType] = {}

        for i, triggerData in ipairs( data[ triggerType ] ) do
            timer[ triggerType ][ i ] = Trigger.Copy( triggerData )
        end
    
    end

    return timer

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- delete
---------------------------------------------------------------------------------------------------
function Timer.Delete( data, timerIndex )

    local maxIndex = #data.timerList

    for i = timerIndex, maxIndex-1 do

        data.timerList[ i ] = data.timerList[ i+1 ]

    end

    data.timerList[ maxIndex ] = nil

end
---------------------------------------------------------------------------------------------------
