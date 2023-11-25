--===================================================================================
--             Name:    TRIGGER Chat
-------------------------------------------------------------------------------------
--      Description:    check every Chat event for a trigger
--===================================================================================



---------------------------------------------------------------------------------------------------
-- chat event processing start up
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.Chat ].Init = function ()

    function Turbine.Chat.Received(sender, args)

        -- filter nil massages
        if  (args.Message  == nil) then

            return

        end

        Trigger[ Trigger.Types.Chat ].CheckChat(args.Message, args.ChatType)

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check message for trigger
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.Chat ].CheckChat = function(message, chatType)

    -- all groups
    for windowIndex, windowData in ipairs(Data.window) do                                      

         -- check if group is enabled
        if windowData.enabled == true then                                                  

            -- all timer of the group
            for timerIndex, timerData in ipairs(windowData.timerList) do

                -- check if timer is enabled
                if timerData.enabled == true then                                           
                
                    -- all chatTrigger of the timer
                    for triggerIndex, triggerData in ipairs(timerData[Trigger.Types.Chat]) do       

                        -- check if trigger is enabled
                        if triggerData.enabled == true then                                 

                            -- check chatType vs source
                            if triggerData.source == Source.Any 
                            or triggerData.source == chatType then
                            
                                -- useRegex
                                if triggerData.useRegex == true then                            

                                    -- fix token if placeholders where used
                                    local token = Trigger.ReplacePlaceholder(triggerData.token)

                                    local pos1 = string.find( message, token )

                                    if pos1 ~= nil then

                                        Trigger[ Trigger.Types.Chat ].ProcessTrigger(
                                                                                        message,
                                                                                        chatType,
                                                                                        windowIndex,
                                                                                        timerIndex,
                                                                                        triggerIndex,
                                                                                        (pos1 - 1) 
                                                                                    )

                                    end

                                else

                                    if message == triggerData.token then

                                        Trigger[ Trigger.Types.Chat ].ProcessTrigger(
                                                                                        message,
                                                                                        chatType,
                                                                                        windowIndex,
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

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- process chat trigger
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.Chat ].ProcessTrigger = function(message, chatType, windowIndex, timerIndex, triggerIndex, posAdjustment)

    -- declarations
    local windowData = Data.window[windowIndex]
    local timerData = windowData.timerList[timerIndex]
    local triggerData = timerData[Trigger.Types.Chat][triggerIndex]
   
    local startTime = Turbine.Engine.GetGameTime()
    local text      = ""
    local target    = ""
    local duration  = 10
    local icon      = timerData.icon
    local entity    = nil
    local key       = nil

    local token = triggerData.token
    local placeholder = Trigger.GetPlaceholder(token, message, posAdjustment)

    -- key
    if timerData.unique == false then

        key              = ChatTriggerID
        ChatTriggerID    = ChatTriggerID + 1
        
    end

    -- text
    if timerData.textOption == TimerTextOptions.Target and
    ( chatType             == Turbine.ChatType.PlayerCombat or
      chatType             == Turbine.ChatType.EnemyCombat ) then

       text, target = Trigger[ Trigger.Types.Chat ].GetTargetNameFromCombatChat(message, chatType)

       if Trigger.CheckListForName(target, triggerData.listOfTargets) == false  then
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

   -- duration
   if timerData.useCustomTimer == true then
        
        duration = timerData.timerValue

        for index, value in pairs(placeholder) do

            duration = string.gsub ( duration, index, value)

        end

        duration = tonumber( duration )

    end

    -- window call
    if triggerData.action == Actions.Add then

        Windows[windowIndex]:Add(  windowData, timerData, timerIndex, startTime, duration, icon, text, entity, key )
      
    elseif triggerData.action == Actions.Remove then

        Windows[windowIndex]:Remove(windowData, timerData, timerIndex, startTime, icon, text, entity, key)

    elseif triggerData.action == Actions.Reset then

        Windows[windowIndex]:ResetAction(windowData, timerData, timerIndex, startTime, icon, text, entity, key)
                        
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- returns name and tier from combat chat message
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.Chat ].GetTargetNameFromCombatChat = function(message, chatType)

    local updateType,initiatorName,targetName,skillName,var1,var2,var3,var4 =  UTILS.ParseCombatChat(string.gsub(string.gsub(message,"<rgb=#......>(.*)</rgb>","%1"),"^%s*(.-)%s*$", "%1"))
   
    local text = Trigger[ Trigger.Types.Chat ].CheckingNameForNumber(skillName)
  
    local target = nil

    if chatType == Turbine.ChatType.PlayerCombat then

        target = targetName

    elseif chatType == Turbine.ChatType.EnemyCombat then

        target = initiatorName
    end

    return text, target

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- returns name and tier from combat chat message
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.Chat ].CheckingNameForNumber = function(name)

    local start_tier, end_tier = string.find(name, "%d+")
    
    if start_tier ~= nil then
        return string.sub(name, start_tier, end_tier)
    else
        return ""
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
ChatTriggerID = 1
---------------------------------------------------------------------------------------------------