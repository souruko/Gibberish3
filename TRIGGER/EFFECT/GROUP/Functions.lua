--=================================================================================================
--= Effect Group          
--= ===============================================================================================
--= trigger from effect group events
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- skill event processing start up
---------------------------------------------------------------------------------------------------
Trigger[Trigger.Types.EffectGroup].Init = function ()

    -- track group
    if  Data.trackGroupEffects == true then                     

        local party = LocalPlayer:GetParty()

        -- party exists
        if party ~= nil then                                    
         
            local localPlayerName = LocalPlayer:GetName()

            -- iterate member
            for i = 1, party:GetMemberCount(), 1 do             

                local player = party:GetMember(i)

                -- if member ~= lp
                if player:GetName() ~= localPlayerName then     

                    local effects = player:GetEffects()

                    -- add
                    function effects.EffectAdded(sender, args)

                        local effect = effects:Get(args.Index)

                        Trigger.AddToEffectCollection( effect )

                        -- all groups
                        for windowIndex, windowData in ipairs(Data.window) do
                            Trigger[ Trigger.Types.EffectGroup ].CheckWindows( effect, player, windowIndex, windowData )

                        end

                        for folderIndex, folderData in ipairs(Data.folder) do
                            Trigger[ Trigger.Types.EffectGroup ].CheckFolder( effect, player, folderIndex, folderData )
    
                        end
    
                    end

                    -- check all activ effects
                    Trigger[ Trigger.Types.EffectGroup ].CheckAllActivEffects()

                end

            end

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check all activ effects
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectGroup ].CheckAllActivEffects = function ()

    local party = LocalPlayer:GetParty()

    -- if party exists
    if party ~= nil then                                        
     
        local localPlayerName = LocalPlayer:GetName()

        -- iterate member
        for i = 1, party:GetMemberCount(), 1 do                 

            local player = party:GetMember(i)

            -- member ~= lp
            if player:GetName() ~= localPlayerName then         

                local effects = player:GetEffects()

                -- iterate effects
                for j = 1, effects:GetCount(), 1 do             

                    local effect = effects:Get(j)

                    -- all groups
                    for windowIndex, windowData in ipairs(Data.window) do

                        Trigger[ Trigger.Types.EffectGroup ].CheckWindows( effect, player, windowIndex, windowData )

                    end

                    for folderIndex, folderData in ipairs(Data.folder) do

                        Trigger[ Trigger.Types.EffectGroup ].CheckFolder( effect, player, folderIndex, folderData )

                    end
                end

            end

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check folder
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectGroup ].CheckFolder = function(effect, player, folderIndex, folderData)

    -- check window triggers
    for triggerIndex, triggerData in ipairs(folderData[ Trigger.Types.EffectGroup ]) do
        
        local posAdjustment = Trigger[ Trigger.Types.EffectGroup ].CheckTrigger(effect, player, triggerData)

        if posAdjustment ~= nil then
            -- fix posAdjustment
            posAdjustment = posAdjustment - 1
            Windows.FolderAction( folderIndex, folderData, triggerData )

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check windows
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectGroup ].CheckWindows = function ( effect, player, windowIndex, windowData )

    -- check window triggers
    for triggerIndex, triggerData in ipairs(windowData[ Trigger.Types.EffectGroup ]) do
        local posAdjustment = Trigger[ Trigger.Types.EffectGroup ].CheckTrigger(effect, player, triggerData)

        if posAdjustment ~= nil then
            Windows.WindowAction( windowIndex, windowData, triggerData )

        end

    end

    -- only check for enabled windows
    if windowData.enabled == false then
        return
    end

    -- check the timers of the window
    for timerIndex, timerData in ipairs( windowData.timerList ) do
        Trigger[ Trigger.Types.EffectGroup ].CheckTimer(effect, player, windowIndex, timerIndex, timerData)

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check timer
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectGroup ].CheckTimer = function ( effect, player, windowIndex, timerIndex, timerData )

    -- only check for enabled timers
    if timerData.enabled == false then
        return
    end

    -- check timer triggers
    for triggerIndex, triggerData in ipairs(timerData[ Trigger.Types.EffectGroup ]) do

        local posAdjustment = Trigger[ Trigger.Types.EffectGroup ].CheckTrigger(effect, player, triggerData)

        if posAdjustment ~= nil then
            -- fix posAdjustment
            posAdjustment = posAdjustment - 1
            Trigger.ProcessEffectTrigger( effect, player, posAdjustment, windowIndex, timerIndex, triggerData )

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check trigger
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectGroup ].CheckTrigger = function ( effect, player, triggerData )

    -- only check for enabled trigger
    if triggerData.enabled == false then
        return nil
    end

    -- icon
    if triggerData.icon ~= nil and triggerData.icon ~= effect:GetIcon() then
        return nil
    end
    
    -- debuff / buff
    if triggerData.isDebuff ~= Source.Any
        and (effect:IsDebuff() ~= (triggerData.isDebuff == Source.Debuff)) then
        return nil
    end

    -- dispellable
    if triggerData.isDispellable ~= Source.Any 
        and (effect:IsCurable() ~= (triggerData.isDispellable == Source.Dispellable)) then
        return nil
    end

    -- category
    if triggerData.category ~= Source.Any 
        and (effect:GetCategory() ~= triggerData.category) then
        return nil
    end

    -- check listOfTargets
    if Trigger.CheckListForName( player:GetName(), triggerData.listOfTargets ) == false then
        return nil
    end

    -- check token
    if triggerData.useRegex == true then

        return string.find( effect:GetName(), Trigger.ReplacePlaceholder(triggerData.token) )

    else

        if effect:GetName() == triggerData.token then

            return 1

        end

    end

    return nil

end
---------------------------------------------------------------------------------------------------
