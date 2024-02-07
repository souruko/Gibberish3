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

        function LocalPlayer.TargetChanged( sender1, args1 )

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

                                                            Trigger.AddToEffectCollection( effect )
                                                            
                                                            -- all groups
                                                            for windowIndex, windowData in ipairs(Data.window) do
                                    
                                                                Trigger[ Trigger.Types.EffectTarget ].CheckWindows( effect, target, windowIndex, windowData )

                                                            end

                                                            -- all folder
                                                            for folderIndex, folderData in ipairs(Data.folder) do
                                                
                                                                Trigger[ Trigger.Types.EffectTarget ].CheckFolder( effect, target, folderIndex, folderData )
                                                
                                                            end

                                                        end )

                Trigger[ Trigger.Types.EffectTarget ].CheckAllActivEffects()

                -- reset on target changed
                for windowIndex, windowData in ipairs(Data.window) do
                    if windowData.resetOnTargetChanged == true
                       and Windows[ windowIndex ] ~= nil then
                 
                        Windows[ windowIndex ]:Reset()

                    end
                end
            
            end

        end

        Trigger[ Trigger.Types.EffectTarget ].CheckAllActivEffects()

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check all activ effects
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectTarget ].CheckAllActivEffects = function()
    
    local target = LocalPlayer:GetTarget()

    if target ~= nil and target.GetEffects ~= nil then

        local effects = target:GetEffects()
        
        for i = 1, effects:GetCount(), 1 do

            local effect = effects:Get(i)
     
            -- all windows
            for windowIndex, windowData in ipairs(Data.window) do

                Trigger[ Trigger.Types.EffectTarget ].CheckWindows( effect, target, windowIndex, windowData )

            end


            -- all folder
            for folderIndex, folderData in ipairs(Data.folder) do

                Trigger[ Trigger.Types.EffectTarget ].CheckFolder( effect, target, folderIndex, folderData )

            end

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check folder
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectTarget ].CheckFolder = function(effect, target, folderIndex, folderData)

    -- check window triggers
    for triggerIndex, triggerData in ipairs(folderData[ Trigger.Types.EffectTarget ]) do
        
        local posAdjustment = Trigger[ Trigger.Types.EffectTarget ].CheckTrigger(effect, target, triggerData)

        if posAdjustment ~= nil then
            -- fix posAdjustment
            posAdjustment = posAdjustment - 1
            Windows.FolderAction( folderIndex, folderData, triggerData )

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check if added effect is tracked
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectTarget ].CheckWindows = function ( effect, target, windowIndex, windowData )

    -- check window triggers
    for triggerIndex, triggerData in ipairs(windowData[ Trigger.Types.EffectTarget ]) do
        local posAdjustment = Trigger[ Trigger.Types.EffectTarget ].CheckTrigger(effect, target, triggerData)

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
        Trigger[ Trigger.Types.EffectTarget ].CheckTimer(effect, target, windowIndex, timerIndex, timerData)

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check if added effect is tracked
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectTarget ].CheckTimer = function ( effect, target, windowIndex, timerIndex, timerData )

    -- only check for enabled timers
    if timerData.enabled == false then
        return
    end

    -- check timer triggers
    for triggerIndex, triggerData in ipairs(timerData[ Trigger.Types.EffectTarget ]) do

        local posAdjustment = Trigger[ Trigger.Types.EffectTarget ].CheckTrigger(effect, target, triggerData)

        if posAdjustment ~= nil then
            -- fix posAdjustment
            posAdjustment = posAdjustment - 1
            Trigger.ProcessEffectTrigger( effect, target, posAdjustment, windowIndex, timerIndex, triggerData )

        end

    end
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check if added effect is tracked
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectTarget ].CheckTrigger = function ( effect, target, triggerData )

    -- only check for enabled trigger
    if triggerData.enabled == false then
        return nil
    end

    -- icon
    if triggerData.icon ~= nil and triggerData.icon ~= effect:GetIcon() then
        return nil
    end

    -- check listOfTargets
    if Trigger.CheckListForName( target:GetName(), triggerData.listOfTargets ) == false then
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
