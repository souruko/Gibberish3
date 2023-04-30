--===================================================================================
--             Name:    TRIGGER Chat
-------------------------------------------------------------------------------------
--      Description:    check every Chat event for a trigger
--===================================================================================




-------------------------------------------------------------------------------------
--      Description:   chat Message Received Event
-------------------------------------------------------------------------------------
--        Parameter:   ChatType
--                     Message
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
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

    Trigger.CheckChat(args.Message, args.ChatType)

end


-------------------------------------------------------------------------------------
--      Description:   check for triggers from the message
-------------------------------------------------------------------------------------
--        Parameter:   message
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
function Trigger.CheckChat(message, chatType)

    for groupIndex, groupData in ipairs(Data.group) do                                      -- all groups

        if groupData.enabled == true then                                                   -- check if group is enabled

            for timerIndex, timerData in ipairs(groupData.timerList) do                     -- all timer of the group

                if timerData.enabled == true then                                           -- check if timer is enabled
                
                    for triggerIndex, triggerData in ipairs(timerData.chatTrigger) do       -- all chatTrigger of the timer

                        if triggerData.enabled == true then                                 -- check if trigger is enabled

                            local token = Trigger.ReplacePlaceholder(triggerData.token)     -- fix token

                            if triggerData.useRegex == true then                            -- useRegex

                                local pos1 = string.find( message, token )
                                if pos1 ~= nil then

                                    Trigger.ProcessChatTrigger(
                                                                message,
                                                                chatType,
                                                                groupIndex,
                                                                timerIndex,
                                                                triggerIndex,
                                                                (pos1 - 1)
                                                            )
                                end

                            else

                                if message == token then

                                    Trigger.ProcessChatTrigger(
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
        
    end
    
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
function Trigger.ProcessChatTrigger(
                                    message,
                                    chatType,
                                    groupIndex,
                                    timerIndex,
                                    triggerIndex,
                                    posAdjustment
                                   )

    local groupData = Data.group[groupIndex]
    local timerData = groupData.timerList[timerIndex]
    local triggerData = timerData.chatTrigger[triggerIndex]
   
    local startTime = Turbine.Engine.GetGameTime()
    local text      = ""
    local target    = ""
    local duration  = 1
    local icon      = nil
    local entity    = nil
    local key

    -- check for placeholder
    local token = triggerData.token
    local placeholder = Trigger.GetPlaceholder(token, message, posAdjustment)

    text = placeholder["&2"]
    duration = tonumber( placeholder["&1"] )
    
    if triggerData.action == Action.Add then
        Group[groupIndex]:Add(groupData, timerData, timerIndex, startTime, duration, icon, text, entity, key)
    else
        Group[groupIndex]:Remove(timerIndex, key)
    end

end

