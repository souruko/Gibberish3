--===================================================================================
--             Name:    TRIGGER Skill
-------------------------------------------------------------------------------------
--      Description:    check every Skill event for a trigger
--===================================================================================




-------------------------------------------------------------------------------------
--      Description:   initialse the skill Event
-------------------------------------------------------------------------------------
--        Parameter:   
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
Trigger.Init[Trigger.Types.SKILL] = function ()

    local listOfSkills = LocalPlayer:GetTrainedSkills()

    for i = 1, listOfSkills:GetCount(), 1 do

        local skill = listOfSkills:GetItem(i)

        if Trigger.SKILL.IsSkillUsed( skill:GetSkillInfo():GetName() ) then

            function skill:ResetTimeChanged( sender, args )

                Trigger.SKILL.SkillUsed( skill )
                
            end

            if skill:GetResetTime() > 0 then

                Trigger.SKILL.SkillUsed( skill )

            end
            
        end
        
    end

end



-------------------------------------------------------------------------------------
--      Description:   check if skill is used by any group
-------------------------------------------------------------------------------------
--        Parameter:   skillname
-------------------------------------------------------------------------------------
--           Return:   used / not used
-------------------------------------------------------------------------------------
function Trigger.SKILL.IsSkillUsed( skillName )

    for groupIndex, groupData in ipairs(Data.group) do                                      -- all groups

        if groupData.enabled == true then                                                   -- check if group is enabled

            for timerIndex, timerData in ipairs(groupData.timerList) do                     -- all timer of the group

                if timerData.enabled == true then                                           -- check if timer is enabled
                
                    for triggerIndex, triggerData in ipairs(timerData.skillTrigger) do      -- all skill of the timer

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



-------------------------------------------------------------------------------------
--      Description:   skill used event
-------------------------------------------------------------------------------------
--        Parameter:   skill
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
function Trigger.SKILL.SkillUsed( skill )

    local name = skill:GetSkillInfo():GetName()

    
    for groupIndex, groupData in ipairs(Data.group) do                                      -- all groups

        if groupData.enabled == true then                                                   -- check if group is enabled

            for timerIndex, timerData in ipairs(groupData.timerList) do                     -- all timer of the group

                if timerData.enabled == true then                                           -- check if timer is enabled
                
                    for triggerIndex, triggerData in ipairs(timerData.skillTrigger) do -- all effect self of the timer

                        if triggerData.enabled == true then                                 -- check if trigger is enabled

                            if name == triggerData.token then

                                Trigger.SKILL.ProcessSkillTrigger( skill, groupIndex, timerIndex, triggerIndex )
                                
                            end
                               
                        end

                    end

                end
                
            end

        end

    end

end




-------------------------------------------------------------------------------------
--      Description:   process skill trigger
-------------------------------------------------------------------------------------
--        Parameter:   skill
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
function Trigger.SKILL.ProcessSkillTrigger( skill, groupIndex, timerIndex, triggerIndex )

------------------------------------------
-- declarations

    local groupData = Data.group[groupIndex]
    local timerData = groupData.timerList[timerIndex]
    local triggerData = timerData.skillTrigger[triggerIndex]
    local name = skill:GetSkillInfo():GetName()

    local startTime = skill:GetResetTime() - skill:GetCooldown()
    local text      = ""
    local duration  = 10
    local icon      = timerData.icon
    local entity    = nil
    local key       = nil


    local token = triggerData.token

---------------------------------------------
-- key

    if timerData.unique == false then

        key = startTime
        
    end


---------------------------------------------
-- icon

    if icon == nil then
        icon = skill:GetSkillInfo():GetIconImageID()
    end

----------------------------------------------
-- text   

    if  timerData.textOption == TimerTextOptions.Token then

        text = name

    elseif timerData.textOption == TimerTextOptions.CustomText then

        text = timerData.textValue

    end

---------------------------------------------
-- duration  

    if timerData.useCustomTimer == true then
         
        duration = timerData.timerValue

    else

        duration = skill:GetResetTime() - startTime

    end

---------------------------------------------
-- group call   

    if triggerData.action == Action.Add then

        Group[groupIndex]:Add(  groupData,
                                timerData,
                                timerIndex,
                                startTime,
                                duration,
                                icon,
                                text,
                                entity,
                                key )

    else

        Group[groupIndex]:Remove(timerIndex, key)

    end


end