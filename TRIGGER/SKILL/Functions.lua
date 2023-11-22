--=================================================================================================
--= Skill         
--= ===============================================================================================
--= trigger from skill reset time changed
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- skill event processing start up
Trigger[Trigger.Types.Skill].Init = function ()

    local listOfSkills = LocalPlayer:GetTrainedSkills()

    for i = 1, listOfSkills:GetCount(), 1 do

        local skill = listOfSkills:GetItem(i)

        if Trigger[ Trigger.Types.Skill ].IsSkillUsed( skill:GetSkillInfo():GetName() ) then

            function skill:ResetTimeChanged( sender, args )

                Trigger[ Trigger.Types.Skill ].SkillUsed( skill )
                
            end

            if skill:GetResetTime() > 0 then

                Trigger[ Trigger.Types.Skill ].SkillUsed( skill )

            end
            
        end
        
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check if skill is used and has to be tracked
Trigger[ Trigger.Types.Skill ].IsSkillUsed = function ( skillName )

    for groupIndex, groupData in ipairs(Data.group) do                                      -- all groups

        if groupData.enabled == true then                                                   -- check if group is enabled

            for timerIndex, timerData in ipairs(groupData.timerList) do                     -- all timer of the group

                if timerData.enabled == true then                                           -- check if timer is enabled
                
                    for triggerIndex, triggerData in ipairs(timerData[Trigger.Types.Skill]) do      -- all skill of the timer

                        if triggerData.enabled == true then                                 -- check if trigger is enabled
                       
                            if triggerData.token == skillName then

                                return true
                                
                            end
                       
                        end
                                    
                    end
                   
                end

            end

        end
        
    end

    return false

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check is skill is used and has to be processed
Trigger[ Trigger.Types.Skill ].SkillUsed = function ( skill )

    local name = skill:GetSkillInfo():GetName()

    
    for groupIndex, groupData in ipairs(Data.group) do                                      -- all groups

        if groupData.enabled == true then                                                   -- check if group is enabled

            for timerIndex, timerData in ipairs(groupData.timerList) do                     -- all timer of the group

                if timerData.enabled == true then                                           -- check if timer is enabled
                
                    for triggerIndex, triggerData in ipairs(timerData[Trigger.Types.Skill]) do -- all effect self of the timer

                        if triggerData.enabled == true then                                 -- check if trigger is enabled

                            if name == triggerData.token then

                                Trigger[ Trigger.Types.Skill ].ProcessSkillTrigger( skill, groupIndex, timerIndex, triggerIndex )
                                
                            end
                               
                        end

                    end

                end
                
            end

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- process skill trigger
Trigger[ Trigger.Types.Skill ].ProcessSkillTrigger = function ( skill, groupIndex, timerIndex, triggerIndex )

    -- declarations
    local groupData = Data.group[groupIndex]
    local timerData = groupData.timerList[timerIndex]
    local triggerData = timerData[Trigger.Types.Skill][triggerIndex]
    local name = skill:GetSkillInfo():GetName()

    local startTime = skill:GetResetTime() - skill:GetCooldown()
    local text      = ""
    local duration  = 10
    local icon      = timerData.icon
    local entity    = nil
    local key       = nil

    local token = triggerData.token

    -- key
    if timerData.unique == false then
        key = startTime
        
    end

    -- icon
    if icon == nil then
        icon = skill:GetSkillInfo():GetIconImageID()

    end
        
    -- text   
    if  timerData.textOption == TimerTextOptions.Token then
        text = name

    elseif timerData.textOption == TimerTextOptions.CustomText then
        text = timerData.textValue

    end

    -- duration  
    if timerData.useCustomTimer == true then
        duration = timerData.timerValue

    else
        duration = skill:GetResetTime() - startTime

    end

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