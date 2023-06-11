--===================================================================================
--             Name:    TRIGGER Chat
-------------------------------------------------------------------------------------
--      Description:    check every Chat event for a trigger
--===================================================================================




-------------------------------------------------------------------------------------
--      Description:   initialse the chat Message Received Event
-------------------------------------------------------------------------------------
--        Parameter:   
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
Trigger.Init[Trigger.Types.Chat] = function ()

    function Turbine.Chat.Received(sender, args)

        -- filter unwanted stuff
        if  (args.ChatType == Turbine.ChatType.Tell) or
            (args.ChatType == Turbine.ChatType.FellowLoot) or
            (args.ChatType == Turbine.ChatType.SelfLoot) or
            (args.ChatType == Turbine.ChatType.World) or
            (args.ChatType == Turbine.ChatType.Trade) or
            (args.ChatType == Turbine.ChatType.Standard) or
            (args.ChatType == Turbine.ChatType.Unfiltered) or
            (args.ChatType == Turbine.ChatType.LFF) or
            (args.Message  == nil) then

            return

        end

        Trigger.Chat.CheckChat(args.Message, args.ChatType)

    end

end

-------------------------------------------------------------------------------------
--      Description:   check for triggers from the message
-------------------------------------------------------------------------------------
--        Parameter:   message
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
function Trigger.Chat.CheckChat(message, chatType)

    for groupIndex, groupData in ipairs(Data.group) do                                      -- all groups

        if groupData.enabled == true then                                                   -- check if group is enabled

            for timerIndex, timerData in ipairs(groupData.timerList) do                     -- all timer of the group

                if timerData.enabled == true then                                           -- check if timer is enabled
                
                    for triggerIndex, triggerData in ipairs(timerData[Trigger.Types.Chat]) do       -- all chatTrigger of the timer

                        if triggerData.enabled == true then                                 -- check if trigger is enabled

                            local token = Utils.ReplacePlaceholder(triggerData.token)     -- fix token

                            if triggerData.useRegex == true then                            -- useRegex

                                local pos1 = string.find( message, token )

                                if pos1 ~= nil then

                                    Trigger.Chat.ProcessTrigger(
                                                                message,
                                                                chatType,
                                                                groupIndex,
                                                                timerIndex,
                                                                triggerIndex,
                                                                (pos1 - 1) )

                                end

                            else

                                if message == token then

                                    Trigger.Chat.ProcessTrigger(
                                                                message,
                                                                chatType,
                                                                groupIndex,
                                                                timerIndex,
                                                                triggerIndex,
                                                                0
                                                            )
                                end

                            end

                        end

                    end
                    
                end

            end

        end

        for triggerIndex, triggerData in ipairs(groupData[Trigger.Types.Chat]) do       -- all chatTrigger for enable/disable

            Group.Enable(groupIndex, triggerData.action)

        end
        
    end

    -- for triggerIndex, triggerData in ipairs(folderData[Trigger.Types.Chat]) do       -- all chatTrigger for enable/disable



    -- end
    
end



-------------------------------------------------------------------------------------
--      Description:    process a trigger after it is confirmed     
-------------------------------------------------------------------------------------
--        Parameter:    message
--                      chatType
--                      groupIndex
--                      timerIndex
--                      triggerIndex
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
function Trigger.Chat.ProcessTrigger(
                                    message,
                                    chatType,
                                    groupIndex,
                                    timerIndex,
                                    triggerIndex,
                                    posAdjustment
                                   )


-------------------------------------------------------------------------------------
-- declarations
                                     
    local groupData = Data.group[groupIndex]
    local timerData = groupData.timerList[timerIndex]
    local triggerData = timerData[Trigger.Types.Chat][triggerIndex]
   
    local startTime = Turbine.Engine.GetGameTime()
    local text      = ""
    local target    = ""
    local duration  = 10
    local icon      = timerData.icon
    local entity    = nil
    local key       = nil


    local token = triggerData.token
    local placeholder = Utils.GetPlaceholder(token, message, posAdjustment)

-------------------------------------------------------------------------------------
-- key

    if timerData.unique == false then

        key              = ChatTriggerID
        ChatTriggerID    = ChatTriggerID + 1
        
    end

-------------------------------------------------------------------------------------
-- text   

    if timerData.textOption == TimerTextOptions.Target and
     ( chatType             == Turbine.ChatType.PlayerCombat or
       chatType             == Turbine.ChatType.EnemyCombat ) then

        text, target = Utils.GetTargetNameFromCombatChat(message, chatType)

        if Utils.CheckListForName(target, triggerData.listOfTargets) == false  then
            return
        end

        if text == "" then

            text = target

        else

            text = text .. " - " .. target

        end


    elseif timerData.textOption == TimerTextOptions.Token then

        text = message


    elseif timerData.textOption == TimerTextOptions.CustomText then

        text = timerData.textValue

        for index, value in pairs(placeholder) do

            text = string.gsub ( text, index, value)

        end

    end


-------------------------------------------------------------------------------------
-- duration   

    if timerData.useCustomTimer == true then
        
        duration = timerData.timerValue

        for index, value in pairs(placeholder) do

            duration = string.gsub ( duration, index, value)

        end

        duration = tonumber( duration )

    end


-------------------------------------------------------------------------------------
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


ChatTriggerID = 1
