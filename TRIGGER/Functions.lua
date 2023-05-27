--===================================================================================
--             Name:    TRIGGER Functions
-------------------------------------------------------------------------------------
--      Description:    collection of trigger related functions
--===================================================================================





-------------------------------------------------------------------------------------
--      Description:   init all Triggers
-------------------------------------------------------------------------------------
--        Parameter:   
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
function Trigger.InitAll()
  
    for index, InitFunction in ipairs(Trigger.Init) do

        InitFunction()
        
    end

end







-------------------------------------------------------------------------------------
--      Description:   process found effect trigger
-------------------------------------------------------------------------------------
--        Parameter:   
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
function Trigger.ProcessEffectTrigger(      effect,
                                            player,
                                            groupIndex,
                                            timerIndex,
                                            triggerData,
                                            posAdjustment )

------------------------------------------
-- declarations

    local groupData = Data.group[groupIndex]
    local timerData = groupData.timerList[timerIndex]
    local name = effect:GetName()
    
    local startTime = effect:GetStartTime()
    local text      = ""
    local target    = player:GetName()
    local duration  = 10
    local icon      = timerData.icon
    local entity    = player
    local key       = nil


    local token = triggerData.token
    local placeholder = Utils.GetPlaceholder(token, effect:GetName(), posAdjustment)

--------------------------------------------
-- target list

    if Utils.CheckListForName(target, triggerData.listOfTargets) == false then
        return
    end

---------------------------------------------
-- key

    if timerData.unique == false then

        key = effect:GetID()
        
    end

---------------------------------------------
-- icon

if icon == nil then
    icon = effect:GetIcon()
end

----------------------------------------------
-- text   

    if timerData.textOption == TimerTextOptions.Target then

        text = Utils.TextTargetParse(name, target)
        
    elseif  timerData.textOption == TimerTextOptions.Token then

        text = name

    elseif timerData.textOption == TimerTextOptions.CustomText then

        text = timerData.textValue

        for index, value in pairs(placeholder) do

            text = string.gsub ( text, index, value)

        end

    end

---------------------------------------------
-- duration  

    if timerData.useCustomTimer == true then
            
        duration = timerData.timerValue

        for index, value in pairs(placeholder) do

            duration = string.gsub ( duration, index, value)

        end

        duration = tonumber( duration )

    else

        duration = effect:GetDuration()

    end

---------------------------------------------
-- group call   

    if triggerData.action == Actions.Add then

        Group[groupIndex]:Add(  groupData,
                                timerData,
                                timerIndex,
                                startTime,
                                duration,
                                icon,
                                text,
                                entity,
                                key )
    
    elseif triggerData.action == Actions.Remove then

        Group[groupIndex]:Remove(groupData, timerData, timerIndex, startTime, counter, icon, text, entity, key)

    elseif triggerData.action == Actions.Reset then

        Group[groupIndex]:ResetAction(groupData, timerData, timerIndex, startTime, counter, icon, text, entity, key)

    end

end




-------------------------------------------------------------------------------------
--      Description:   process found effect trigger
-------------------------------------------------------------------------------------
--        Parameter:   
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
function Timer.ProcessTimerTrigger( groupIndex,
                                    timerIndex,
                                    triggerData )

    local groupData = Data.group[groupIndex]
    local timerData = groupData.timerList[timerIndex]

    local startTime = Turbine.Engine.GetGameTime()
    local text      = timerData.textValue
    local duration  = 10
    local icon      = timerData.icon
    local entity    = nil
    local key       = nil

---------------------------------------------
-- key

    if timerData.unique == false then

        key = startTime
        
    end

---------------------------------------------
-- duration  

    if timerData.useCustomTimer == true then
            
        duration = timerData.timerValue

    end

---------------------------------------------
-- group call   

    if triggerData.action == Actions.Add then

        Group[groupIndex]:Add(  groupData,
                                timerData,
                                timerIndex,
                                startTime,
                                duration,
                                icon,
                                text,
                                entity,
                                key )

    elseif triggerData.action == Actions.Remove then

        Group[groupIndex]:Remove(groupData, timerData, timerIndex, startTime, counter, icon, text, entity, key)

    elseif triggerData.action == Actions.Reset then

        Group[groupIndex]:ResetAction(groupData, timerData, timerIndex, startTime, counter, icon, text, entity, key)
                        
    end

end                          