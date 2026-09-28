--=================================================================================================
--= Skill         
--= ===============================================================================================
--= trigger from skill reset time changed
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- skill event processing start up
---------------------------------------------------------------------------------------------------
Trigger[Trigger.Types.Skill].Init = function ()

    local listOfSkills = LocalPlayer:GetTrainedSkills()

    -- every trained skill used to be answered by walking every window, timer,
    -- condition and folder. The set of tokens is the same for all of them, so it
    -- is collected once and each skill is then a single lookup.
    local usedSkills = Trigger[ Trigger.Types.Skill ].CollectUsedSkills()

    for i = 1, listOfSkills:GetCount(), 1 do

        local skill = listOfSkills:GetItem(i)

        if usedSkills[ skill:GetSkillInfo():GetName() ] == true then

            function skill.ResetTimeChanged( sender, args )

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
-- return the set of skill names any trigger watches
---------------------------------------------------------------------------------------------------
-- same walk as IsSkillUsed below, gathering the tokens instead of answering for
-- one name at a time
Trigger[Trigger.Types.Skill].CollectUsedSkills = function ()

    local used = {}

    local function collect( list )

        if list == nil then
            return
        end

        for _, triggerData in ipairs(list) do

            if triggerData.enabled == true and triggerData.token ~= nil then
                used[ triggerData.token ] = true
            end

        end

    end

    -- all groups
    for windowIndex, windowData in ipairs(Data.window) do

        -- check if group is enabled
        if windowData.enabled == true then

            -- all timer of the group
            for timerIndex, timerData in ipairs(windowData.timerList) do

                -- check if timer is enabled
                if timerData.enabled == true then

                    collect( timerData[Trigger.Types.Skill] )

                    -- condition triggers
                    for _, condition in ipairs(timerData.conditionList or {}) do
                        if condition.enabled == true then
                            collect( condition[Trigger.Types.Skill] )
                        end
                    end

                end

            end

        end

        -- check window triggers
        collect( windowData[ Trigger.Types.Skill ] )

    end

    for folderIndex, folderData in ipairs(Data.folder) do

        collect( folderData[Trigger.Types.Skill] )

    end

    return used

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- return if skill is used by any trigger
---------------------------------------------------------------------------------------------------
Trigger[Trigger.Types.Skill].IsSkillUsed = function (skillName)

    -- all groups
    for windowIndex, windowData in ipairs(Data.window) do                                      
                 
        -- check if group is enabled
        if windowData.enabled == true then                                                   

            -- all timer of the group
            for timerIndex, timerData in ipairs(windowData.timerList) do    

                -- check if timer is enabled
                if timerData.enabled == true then

                    -- all skill of the timer
                    for triggerIndex, triggerData in ipairs(timerData[Trigger.Types.Skill]) do

                        -- check if trigger is enabled
                        if triggerData.enabled == true then

                            if triggerData.token == skillName then

                                return true

                            end

                        end

                    end

                    -- condition triggers
                    for _, condition in ipairs(timerData.conditionList or {}) do
                        if condition.enabled == true then
                            for _, t in ipairs(condition[Trigger.Types.Skill] or {}) do
                                if t.enabled == true and t.token == skillName then
                                    return true
                                end
                            end
                        end
                    end

                end

            end

        end

        -- check window triggers
        for triggerIndex, triggerData in ipairs(windowData[ Trigger.Types.Skill ]) do

            -- check if trigger is enabled
            if triggerData.enabled == true then                                 
                                
                if triggerData.token == skillName then

                    return true
                    
                end

            end

        end
        
    end

    
    for folderIndex, folderData in ipairs(Data.folder) do
           
        for triggerIndex, triggerData in ipairs(folderData[Trigger.Types.Skill]) do

            -- check if trigger is enabled
            if triggerData.enabled == true then                                 

                if triggerData.token == skillName then

                    return true

                end

            end

        end

    end

    return false

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- skill is used event
---------------------------------------------------------------------------------------------------
Trigger[Trigger.Types.Skill].SkillUsed = function (skill)

    local name = skill:GetSkillInfo():GetName()

    -- all groups
    for windowIndex, windowData in ipairs(Data.window) do                                      

        -- check if group is enabled
        if windowData.enabled == true then                                                   

            -- all timer of the group
            for timerIndex, timerData in ipairs(windowData.timerList) do                     

                -- check if timer is enabled
                if timerData.enabled == true then

                    if Condition.HasAny( timerData ) then
                        Condition.CheckAll( timerData, Trigger.Types.Skill, function(t)
                            if t.enabled == true and t.token == name then return 1 end
                            return nil
                        end)
                    end

                    -- all effect self of the timer
                    for triggerIndex, triggerData in ipairs(timerData[Trigger.Types.Skill]) do 

                        -- check if trigger is enabled
                        if triggerData.enabled == true then                                 

                            if name == triggerData.token then

                                Trigger[ Trigger.Types.Skill ].ProcessTrigger( skill, windowIndex, timerIndex, triggerIndex )
                                
                            end
                               
                        end

                    end

                end
                
            end

        end

        -- check window triggers
        for triggerIndex, triggerData in ipairs(windowData[ Trigger.Types.Skill ]) do

            -- check if trigger is enabled
            if triggerData.enabled == true then                                 
                                
                if triggerData.token == name then

                    Windows.WindowAction( windowIndex, windowData, triggerData )
                                    
                end

            end

        end

    end

    for folderIndex, folderData in ipairs(Data.folder) do
           
        for triggerIndex, triggerData in ipairs(folderData[Trigger.Types.Skill]) do

            -- check if trigger is enabled
            if triggerData.enabled == true then                                 

                if triggerData.token == name then

                    Window.FolderAction( folderIndex, folderData, triggerData )
                            
                end

            end

        end

    end



end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- process skill trigger
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.Skill ].ProcessTrigger = function ( skill, windowIndex, timerIndex, triggerIndex )

    -- declarations
    local windowData = Data.window[windowIndex]
    local timerData = windowData.timerList[timerIndex]
    local triggerData = timerData[Trigger.Types.Skill][triggerIndex]
    local name = skill:GetSkillInfo():GetName()

    local startTime = skill:GetResetTime() - skill:GetCooldown()
    local text      = ""
    local duration  = 10
    local icon      = timerData.icon
    local entity    = nil
    local key       = nil

    local token = triggerData.token
    local placeholder = { ["&tag"] = tostring(triggerData.tag or "") }

    -- key
    -- every trigger = new timer
    if timerData.permanent == false and
        timerData.stacking == Stacking.Multi then

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
        for k, v in pairs(placeholder) do text = string.gsub(text, k, v) end

    end

    -- duration
    if timerData.useCustomTimer == true then

        duration = timerData.timerValue
        for k, v in pairs(placeholder) do duration = string.gsub(tostring(duration), k, v) end
        duration = tonumber(duration) or duration

    else

        duration = skill:GetResetTime() - startTime

    end

    -- window call
    Windows[ windowIndex ]:TimerAction( triggerData, timerData, timerIndex, startTime, duration, icon, text, entity, key )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
SkillTreeChanged = class( Turbine.UI.Control )

function SkillTreeChanged:Constructor(parent, data)
	Turbine.UI.Control.Constructor( self )
    self.sleepEnd = 0
end

function SkillTreeChanged:Go()
    self.sleepEnd = Turbine.Engine.GetGameTime() + 3
    self:SetWantsUpdates(true)
end

function SkillTreeChanged:Update()
    if Turbine.Engine.GetGameTime() > self.sleepEnd then
        self:SetWantsUpdates(false)
        -- Windows.SkillTreeChanged()
        Trigger[Trigger.Types.Skill].Init()
    end
end


Trigger.SkillTreeChanged_control = SkillTreeChanged()
---------------------------------------------------------------------------------------------------
