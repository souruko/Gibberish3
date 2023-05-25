
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
    timer.nextTriggerSortIndex  = 1
    timer.enabled               = true
    timer.sortIndex             = 0
    timer.type                  = type
    timer.description           = Timer.Defaults[type].description
    timer.permanent             = Timer.Defaults[type].permanent

    -- timer
    timer.unique                = Timer.Defaults[type].unique
    timer.removable             = Timer.Defaults[type].removable
    timer.loop                  = Timer.Defaults[type].loop
    timer.reset                 = Timer.Defaults[type].reset
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

    timer.counterValue          = Timer.Defaults[type].counterValue

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



-------------------------------------------------------------------------------------
--      Description:     
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Timer.AddTrigger(timer, type)

    local triggerIndex = #timer[type]+1

    timer[type][ triggerIndex ] = Trigger.New(type)
    timer[type][ triggerIndex ].sortIndex = timer.nextTriggerSortIndex

    timer.nextTriggerSortIndex = timer.nextTriggerSortIndex + 1
    
    return triggerIndex

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    fromData, toData
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Timer.SortTo(timerData, fromData, toData)

    local fromSortIndex = fromData.sortIndex
    local toSortIndex = toData.sortIndex

    if fromSortIndex > toSortIndex then

        for i, triggerList in ipairs(timerData) do

            for j, triggerData in ipairs(triggerList) do

                if triggerData.sortIndex >= toSortIndex and triggerData.sortIndex <= fromSortIndex then

                    triggerData.sortIndex = triggerData.sortIndex + 1

                end

            end
        
        end

    else

        for i, triggerList in ipairs(timerData) do

            for j, triggerData in ipairs(triggerList) do

                if triggerData.sortIndex <= toSortIndex and triggerData.sortIndex >= fromSortIndex then

                    triggerData.sortIndex = triggerData.sortIndex - 1

                end

            end
    
        end

      
    end

    fromData.sortIndex = toSortIndex

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    fromData, toData
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Timer.IsSelected(index)

    for i, v in ipairs(Data.selectedTimerIndex) do

        if v == index then
            return true
        end
        
    end

    return false

end