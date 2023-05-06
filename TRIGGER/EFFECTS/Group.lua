--===================================================================================
--             Name:    TRIGGER EFFECTS Group
-------------------------------------------------------------------------------------
--      Description:    check every Effect on the the Group for a trigger
--===================================================================================





-------------------------------------------------------------------------------------
--      Description:   initialise the effects added callback on the Group
-------------------------------------------------------------------------------------
--        Parameter:   
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
Trigger.Init[Trigger.Types.EffectGroup] = function ()

    if  Data.trackGroupEffects == true then                     -- track group

        local party = LocalPlayer:GetParty()

        if party ~= nil then                                    -- party exists
         
            local localPlayerName = LocalPlayer:GetName()

            for i = 1, party:GetMemberCount(), 1 do             -- iterate member

                local player = party:GetMember(i)

                if player:GetName() ~= localPlayerName then     -- if member ~= lp

                    local effects = player:GetEffects()

-------------------------------------------------------------------------------------
-- add

                    function effects.EffectAdded(sender, args)

                        local effect = effects:Get(args.Index)

                        Trigger.EffectGroup.EffectAdded( effect, player )

                    end


-------------------------------------------------------------------------------------
-- init active effects

                    Trigger.EffectGroup.InitActivEffect()

                end

            end

        end

    end

end



-------------------------------------------------------------------------------------
--      Description:   Group effect added event
-------------------------------------------------------------------------------------
--        Parameter:   effect
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
function Trigger.EffectGroup.EffectAdded( effect, player)

    local name = effect:GetName()
    local icon = effect:GetIcon()

    for groupIndex, groupData in ipairs(Data.group) do                                                      -- all groups

        if groupData.enabled == true then                                                                   -- check if group is enabled

            for timerIndex, timerData in ipairs(groupData.timerList) do                                     -- all timer of the group

                if timerData.enabled == true then                                                           -- check if timer is enabled
                
                    for triggerIndex, triggerData in ipairs(timerData[Trigger.EffectGroup]) do                 -- all effect self of the timer

                        if triggerData.enabled == true then                                                 -- check if trigger is enabled

                            if Utils.CheckListForName( player:GetName(), triggerData.listOfTargets ) then   -- check listOfTargets

                                local token = Utils.ReplacePlaceholder(triggerData.token)                   -- fix token

                                if triggerData.useRegex == true then   

                                    local pos1 = string.find( name, token )

                                    if pos1 ~= nil then

                                        Trigger.ProcessEffectTrigger(           effect,
                                                                                player,
                                                                                groupIndex,
                                                                                timerIndex,
                                                                                triggerData,
                                                                                (pos1 - 1) )

                                    end

                                else

                                    if name == token then

                                        Trigger.ProcessEffectTrigger(           effect,
                                                                                player,
                                                                                groupIndex,
                                                                                timerIndex,
                                                                                triggerData,
                                                                                0 )
                                        
                                    end
                                    
                                end
                               
                            end

                        end

                    end
                    
                end

            end

        end
        
    end

end



-------------------------------------------------------------------------------------
--      Description:   Init all active effects on the the Group
-------------------------------------------------------------------------------------
--        Parameter:   
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
function Trigger.EffectGroup.InitActivEffect()

    local party = LocalPlayer:GetParty()

    if party ~= nil then                                        -- if party exists
     
        local localPlayerName = LocalPlayer:GetName()

        for i = 1, party:GetMemberCount(), 1 do                 -- iterate member

            local player = party:GetMember(i)

            if player:GetName() ~= localPlayerName then         -- member ~= lp

                local effects = player:GetEffects()

                for j = 1, effects:GetCount(), 1 do             -- iterate effects

                    local effect = effects:Get(j)

                    Trigger.EffectGroup.EffectAdded( effect, player )

                end

            end

        end

    end

end