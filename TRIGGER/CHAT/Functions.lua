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

        
        -- iterate all window data
        for windowIndex, windowData in ipairs(Data.window) do
            Trigger[ Trigger.Types.Chat ].CheckWindows(args.Message, args.ChatType, windowIndex, windowData)

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check windows
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.Chat ].CheckWindows = function(message, chatType, windowIndex, windowData)

    -- only check for enabled windows
    if windowData.enabled == false then
        return
    end

    -- check window triggers
    for triggerIndex, triggerData in ipairs(windowData[ Trigger.Types.Chat ]) do
        
        local posAdjustment = Trigger[ Trigger.Types.Chat ].CheckTrigger(message, chatType, triggerData)

        if posAdjustment ~= nil then
            -- fix posAdjustment
            posAdjustment = posAdjustment - 1
            Windows.WindowAction( windowIndex, windowData, triggerData )

        end

    end

    
    -- check the timers of the window
    for timerIndex, timerData in ipairs( windowData.timerList ) do
        Trigger[ Trigger.Types.Chat ].CheckTimer(message, chatType, windowIndex, timerIndex, timerData)

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check timers
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.Chat ].CheckTimer = function(message, chatType, windowIndex, timerIndex, timerData)

    -- only check for enabled timers
    if timerData.enabled == false then
        return
    end

    -- check timer triggers
    for triggerIndex, triggerData in ipairs(timerData[ Trigger.Types.Chat ]) do
        local posAdjustment = Trigger[ Trigger.Types.Chat ].CheckTrigger(message, chatType, triggerData)

        if posAdjustment ~= nil then
            Trigger[ Trigger.Types.Chat ].ProcessTrigger( message, chatType, posAdjustment, windowIndex, timerIndex, triggerIndex )

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check message for trigger
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.Chat ].CheckTrigger = function( message, chatType, triggerData )

    -- only check for enabled trigger
    if triggerData.enabled == false then
        return nil
    end

    -- check chatType vs source
    if triggerData.source ~= Source.Any
    and triggerData.source ~= chatType then
        return nil
    end

    -- find match with message and token
    return string.find( message, Trigger.ReplacePlaceholder( triggerData.token ) )

  
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- process chat trigger
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.Chat ].ProcessTrigger = function( message, chatType, posAdjustment, windowIndex, timerIndex, triggerIndex )

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
    local timer     = nil

    local token = triggerData.token
    local placeholder = Trigger.GetPlaceholder(token, message, posAdjustment)

    -- text
    if timerData.textOption == TimerTextOptions.Target and
    ( chatType             == Turbine.ChatType.PlayerCombat or
      chatType             == Turbine.ChatType.EnemyCombat ) then

       text, target = Trigger[ Trigger.Types.Chat ].GetTargetNameFromCombatChat(message, chatType)

       -- check target against listOfTargets
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

    -- key
    -- every trigger = new timer
    if timerData.stacking == Stacking.Multi then

        key              = ChatTriggerID
        ChatTriggerID    = ChatTriggerID + 1

    -- one timer per target
    elseif timerData.stacking == Stacking.PerTarget and
        ( chatType        == Turbine.ChatType.PlayerCombat or
          chatType        == Turbine.ChatType.EnemyCombat ) then

        key = target

    else

        key = nil
        
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
    Windows[ windowIndex ]:TimerAction( triggerData, timerData, timerIndex, startTime, duration, icon, text, entity, key )

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