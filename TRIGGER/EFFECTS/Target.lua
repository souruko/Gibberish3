--===================================================================================
--             Name:    TRIGGER EFFECTS Target
-------------------------------------------------------------------------------------
--      Description:    check every Effect on the  the Target for a trigger
--===================================================================================





-------------------------------------------------------------------------------------
--      Description:   initialise the effects added callback on  the Target
-------------------------------------------------------------------------------------
--        Parameter:   
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
Trigger.Init[Trigger.Types.EffectTarget] = function ()

    if  Data.trackTargetEffects == true then                     -- track group

        TackingCallbacks = {}

        function LocalPlayer.TargetChanged( sender, args )

            local target = LocalPlayer:GetTarget()

            if  target ~= nil and
                not(target:IsLocalPlayer()) and
                target.GetEffects ~= nil then

                for key, value in pairs(TackingCallbacks) do
                    RemoveCallback(key, "EffectAdded", value)
                end

                local effects = target:GetEffects()

                TackingCallbacks[effects] = AddCallback( effects,
                                                        "EffectAdded",
                                                        function( sender, args )

                                                            local effect = effects:Get( args.Index )
                                                            Trigger.EffectTarget.EffectAdded(effect, target)

                                                        end )

                Trigger.EffectTarget.InitActivEffect()
            
            end

        end

        Trigger.EffectTarget.InitActivEffect()

    end

end




-------------------------------------------------------------------------------------
--      Description:    the Target effect added event
-------------------------------------------------------------------------------------
--        Parameter:   effect
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
function Trigger.EffectTarget.EffectAdded( effect, target )


    local name = effect:GetName()
    local icon = effect:GetIcon()

    for groupIndex, groupData in ipairs(Data.group) do                                                      -- all groups

        if groupData.enabled == true then                                                                   -- check if group is enabled

            for timerIndex, timerData in ipairs(groupData.timerList) do                                     -- all timer of the group

                if timerData.enabled == true then                                                           -- check if timer is enabled
                
                    for triggerIndex, triggerData in ipairs(timerData[Trigger.EffectTarget]) do                 -- all effect self of the timer

                        if triggerData.enabled == true then                                                 -- check if trigger is enabled

                            if Utils.CheckListForName( target:GetName(), triggerData.listOfTargets ) then   -- check listOfTargets

                                local token = Utils.ReplacePlaceholder(triggerData.token)                   -- fix token

                                if triggerData.useRegex == true then   

                                    local pos1 = string.find( name, token )

                                    if pos1 ~= nil then

                                        Trigger.ProcessEffectTrigger(           effect,
                                                                                target,
                                                                                groupIndex,
                                                                                timerIndex,
                                                                                triggerData,
                                                                                (pos1 - 1) )

                                    end

                                else

                                    if name == token then

                                        Trigger.ProcessEffectTrigger(           effect,
                                                                                target,
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
--      Description:   Init all active effects on the  the Target
-------------------------------------------------------------------------------------
--        Parameter:   
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
function Trigger.EffectTarget.InitActivEffect()

    local target = LocalPlayer:GetTarget()

    if target ~= nil and target.GetEffects ~= nil then

        local effects = target:GetEffects()
        
        for i = 1, effects:GetCount(), 1 do

            local effect = effects:Get(i)

            Trigger.EffectTarget.EffectAdded(effect, target)

        end

    end

end







function AddCallback(object, event, callback)
    if (object[event] == nil) then
        object[event] = callback;
    else
        if (type(object[event]) == "table") then
            table.insert(object[event], callback);
        else
            object[event] = {object[event], callback};
        end
    end
    return callback;
end

function RemoveCallback(object, event, callback)
    if (object[event] == callback) then
        object[event] = nil;
    else
        if (type(object[event]) == "table") then
            local size = table.getn(object[event]);
            for i = 1, size do
                if (object[event][i] == callback) then
                    table.remove(object[event], i);
                    break;
                end
            end
        end
    end
end
