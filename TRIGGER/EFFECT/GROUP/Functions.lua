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

                        Trigger[ Trigger.Types.EffectGroup ].EffectAdded( effect, player )

                    end


                    -- check all activ effects
                    Trigger[ Trigger.Types.EffectGroup ].InitActivEffect()

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

                    Trigger[ Trigger.Types.EffectGroup ].EffectAdded( effect, player )

                end

            end

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check all activ effects
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectGroup ].EffectAdded = function ( effect, player )

    local name = effect:GetName()
    local icon = effect:GetIcon()

    -- all groups
    for windowIndex, windowData in ipairs(Data.window) do                                                     

        -- check if group is enabled
        if windowData.enabled == true then                                                                   

            -- all timer of the group
            for timerIndex, timerData in ipairs(windowData.timerList) do                                     

                -- check if timer is enabled
                if timerData.enabled == true then                                                           
                
                    -- all effect self of the timer
                    for triggerIndex, triggerData in ipairs(timerData[Trigger.Types.EffectGroup]) do                 

                        -- check if trigger is enabled
                        if triggerData.enabled == true then                                                 

                            -- check listOfTargets
                            if Trigger.CheckListForName( player:GetName(), triggerData.listOfTargets ) then

                                if triggerData.useRegex == true then   

                                    -- fix token
                                    local token = Trigger.ReplacePlaceholder(triggerData.token)          
                                    local pos1 = string.find( name, token )

                                    if pos1 ~= nil then

                                        Trigger.ProcessEffectTrigger(           
                                                                        effect,
                                                                        player,
                                                                        windowIndex,
                                                                        timerIndex,
                                                                        triggerData,
                                                                        (pos1 - 1) 
                                                                    )

                                    end

                                else

                                    if name == triggerData.token then

                                        Trigger.ProcessEffectTrigger(           
                                                                        effect,
                                                                        player,
                                                                        windowIndex,
                                                                        timerIndex,
                                                                        triggerData,
                                                                        0 
                                                                    )
                                        
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
---------------------------------------------------------------------------------------------------
