--===================================================================================
--             Name:    TRIGGER EFFECTS Self
-------------------------------------------------------------------------------------
--      Description:    check every Effect on the LocalPlayer for a trigger
--===================================================================================





-------------------------------------------------------------------------------------
--      Description:   initialise the effects added callback on LocalPlayer
-------------------------------------------------------------------------------------
--        Parameter:   
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
Trigger.Init[Trigger.Types.EFFECT_SELF] = function ()

-------------------------------------------------------------------------------------
-- remove 
    local effects = LocalPlayer:GetEffects()

    function effects.EffectRemoved(sender, args)

        Trigger.EFFECT_SELF.EffectRemoved( args.Effect )

    end

-------------------------------------------------------------------------------------
-- add
    function effects.EffectAdded(sender, args)

        local effect = effects:Get(args.Index)

        Trigger.EFFECT_SELF.EffectAdded( effect )
        Trigger.EFFECT_GROUP.EffectAdded( effect, LocalPlayer )

    end

-------------------------------------------------------------------------------------
-- init active effects
    Trigger.EFFECT_SELF.InitActivEffect()

end



-------------------------------------------------------------------------------------
--      Description:   LocalPlayer effect removed event
-------------------------------------------------------------------------------------
--        Parameter:   effect
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
function Trigger.EFFECT_SELF.EffectRemoved( effect )

end



-------------------------------------------------------------------------------------
--      Description:   LocalPlayer effect added event
-------------------------------------------------------------------------------------
--        Parameter:   effect
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
function Trigger.EFFECT_SELF.EffectAdded( effect )

    local name = effect:GetName()
    local icon = effect:GetIcon()

    for groupIndex, groupData in ipairs(Data.group) do                                      -- all groups

        if groupData.enabled == true then                                                   -- check if group is enabled

            for timerIndex, timerData in ipairs(groupData.timerList) do                     -- all timer of the group

                if timerData.enabled == true then                                           -- check if timer is enabled
                
                    for triggerIndex, triggerData in ipairs(timerData.effectSelfTrigger) do -- all effect self of the timer

                        if triggerData.enabled == true then                                 -- check if trigger is enabled

                            local token = Utils.ReplacePlaceholder(triggerData.token)       -- fix token

                            if triggerData.useRegex == true then

                                local pos1 = string.find( name, token )

                                if pos1 ~= nil then

                                    Trigger.ProcessEffectTrigger(       effect,
                                                                        LocalPlayer,
                                                                        groupIndex,
                                                                        timerIndex,
                                                                        triggerData,
                                                                        (pos1 - 1) )

                                end

                            else

                                if name == token then

                                    if timerData.icon == nil or timerData.icon == icon then

                                        Trigger.ProcessEffectTrigger(       effect,
                                                                            LocalPlayer,
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
--      Description:   Init all active effects on the LocalPlayer
-------------------------------------------------------------------------------------
--        Parameter:   
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
function Trigger.EFFECT_SELF.InitActivEffect()

    local effects = LocalPlayer:GetEffects()

    for index = 1, effects:GetCount(), 1 do
        
        local effect = effects:Get(index)
    
        Trigger.EFFECT_SELF.EffectAdded( effect )
        Trigger.EFFECT_GROUP.EffectAdded( effect, LocalPlayer )

    end

end
