--=================================================================================================
--= Effect target          
--= ===============================================================================================
--= trigger from effect target events
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- effect target event processing start up
---------------------------------------------------------------------------------------------------
Trigger[Trigger.Types.EffectTarget].Init = function ()

    -- track target
    if  Data.trackTargetEffects == true then                     

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
                                                            Trigger[ Trigger.Types.EffectTarget ].EffectAdded(effect, target)

                                                        end )

                Trigger[ Trigger.Types.EffectTarget ].CheckAllActivEffects()
            
            end

        end

        Trigger[ Trigger.Types.EffectTarget ].CheckAllActivEffects()

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check all activ effects
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectTarget ].CheckAllActivEffects = function ()
    
    local target = LocalPlayer:GetTarget()

    if target ~= nil and target.GetEffects ~= nil then

        local effects = target:GetEffects()
        
        for i = 1, effects:GetCount(), 1 do

            local effect = effects:Get(i)

            Trigger[ Trigger.Types.EffectTarget ].EffectAdded(effect, target)

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check if added effect is tracked
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectTarget ].EffectAdded = function ( effect, target )

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
                    for triggerIndex, triggerData in ipairs(timerData[Trigger.Types.EffectTarget]) do                 

                        -- check if trigger is enabled
                        if triggerData.enabled == true then                                                 

                            -- check listOfTargets
                            if Trigger.CheckListForName( target:GetName(), triggerData.listOfTargets ) then   

                                -- fix token
                                local token = Trigger.ReplacePlaceholder(triggerData.token)                   

                                if triggerData.useRegex == true then   

                                    local pos1 = string.find( name, token )

                                    if pos1 ~= nil then

                                        Trigger.ProcessEffectTrigger(           effect,
                                                                                target,
                                                                                windowIndex,
                                                                                timerIndex,
                                                                                triggerData,
                                                                                (pos1 - 1) )

                                    end

                                else

                                    if name == token then

                                        Trigger.ProcessEffectTrigger(           effect,
                                                                                target,
                                                                                windowIndex,
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
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- callbacks
---------------------------------------------------------------------------------------------------
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
---------------------------------------------------------------------------------------------------
