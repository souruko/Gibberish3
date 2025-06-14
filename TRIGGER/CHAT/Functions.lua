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

        -- auto reload
        if Data.autoReload == true and
            args.ChatType == Turbine.ChatType.Standard then
            
                Trigger[ Trigger.Types.Chat ].CheckForReload( args.Message )
            
        end

        -- keep track of activ skills
        if args.ChatType == Turbine.ChatType.Advancement then
            if string.find(args.Message, L[ Language.Local ].traitline_changed) then
                Trigger.SkillTreeChanged_control:Go()
            end
        end

        

        -- collection
        Trigger[ Trigger.Types.Chat ].AddToCollection( args.Message, args.ChatType )
        
        -- iterate all window data
        for windowIndex, windowData in ipairs(Data.window) do
            Trigger[ Trigger.Types.Chat ].CheckWindows(args.Message, args.ChatType, windowIndex, windowData)

        end

        -- iterate folder data
        for folderIndex, folderData in ipairs(Data.folder) do
            Trigger[ Trigger.Types.Chat ].CheckFolder(args.Message, args.ChatType, folderIndex, folderData)

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- add to collection
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.Chat ].AddToCollection = function( message, chatType )

    -- stop if not collecting
    if Options.CollectChat == false then
        return
    end

    -- check for only say
    if Options.OnlySay == true and
        chatType ~= Turbine.ChatType.Say then

        return
    end

    -- check for duplicates
    for index, value in ipairs(Options.Collection.Chat) do
        if value.token == message and
            value.source == chatType then

            return

        end
    end

    local index = #Options.Collection.Chat + 1

    Options.Collection.Chat[ index ] = {}
    Options.Collection.Chat[ index ].token  = message
    Options.Collection.Chat[ index ].source = chatType
    Options.Collection.Chat[ index ].icon = nil
    Options.Collection.Chat[ index ].timer = nil
    Options.Collection.Chat[ index ].persistent = false

    Options.ChatCollectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check folder
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.Chat ].CheckFolder = function(message, chatType, folderIndex, folderData)

    -- check window triggers
    for triggerIndex, triggerData in ipairs(folderData[ Trigger.Types.Chat ]) do
        
        local posAdjustment = Trigger[ Trigger.Types.Chat ].CheckTrigger(message, chatType, triggerData)

        if posAdjustment ~= nil then
            -- fix posAdjustment
            posAdjustment = posAdjustment - 1
            Windows.FolderAction( folderIndex, folderData, triggerData )

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check windows
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.Chat ].CheckWindows = function(message, chatType, windowIndex, windowData)


    -- check window triggers
    for triggerIndex, triggerData in ipairs(windowData[ Trigger.Types.Chat ]) do
        
        local posAdjustment = Trigger[ Trigger.Types.Chat ].CheckTrigger(message, chatType, triggerData)

        if posAdjustment ~= nil then
            -- fix posAdjustment
            posAdjustment = posAdjustment - 1

            Windows.WindowAction( windowIndex, windowData, triggerData )

        end

    end

    -- only check for enabled windows
    if windowData.enabled == false then
        return
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

    if ( chatType == Turbine.ChatType.PlayerCombat or
       chatType == Turbine.ChatType.EnemyCombat ) then

        text, target = Trigger[ Trigger.Types.Chat ].GetTargetNameFromCombatChat(message, chatType)

        -- check target against listOfTargets
        if Trigger.CheckListForName(target, triggerData.listOfTargets) == false  then
            return
        end

    end

    local placeholder = Trigger.GetPlaceholder(token, message, posAdjustment, target)


    -- text
    if timerData.textOption == TimerTextOptions.Target then

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
    if timerData.permanent == false and
        timerData.stacking == Stacking.Multi then

        key              = ChatTriggerID
        ChatTriggerID    = ChatTriggerID + 1

    -- one timer per target
    elseif timerData.permanent == false and
          timerData.stacking == Stacking.PerTarget and
        ( chatType        == Turbine.ChatType.PlayerCombat or
          chatType        == Turbine.ChatType.EnemyCombat ) then

        key = target

    else

        key = nil
        
    end
Turbine.Shell.WriteLine(tostring(key))
   -- duration
   if timerData.useCustomTimer == true then
        duration = timerData.timerValue

        for index, value in pairs(placeholder) do
            if index == duration then
                duration = value
            end

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

    local updateType,initiatorName,targetName,skillName,var1,var2,var3,var4 = Trigger.ParseCombatChat(string.gsub(string.gsub(message,"<rgb=#......>(.*)</rgb>","%1"),"^%s*(.-)%s*$", "%1"))

    local text = Trigger.CheckingNameForNumber(skillName)
  
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
Trigger[ Trigger.Types.Chat ].CheckForReload = function (message)

    for key, text in pairs(L[ Language.Local ].ReloadMessages) do
        
        if string.find( message, text ) then
            Options.Reload()
            return
        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
ChatTriggerID = 1
---------------------------------------------------------------------------------------------------