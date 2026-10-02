--===================================================================================
--             Name:    TRIGGER Chat
-------------------------------------------------------------------------------------
--      Description:    check every Chat event for a trigger
--===================================================================================



---------------------------------------------------------------------------------------------------
-- the trigger types a line of chat is checked against
local CHAT_TYPES = { Trigger.Types.Chat }
---------------------------------------------------------------------------------------------------

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

        -- only the chat triggers for this chat type and those for any chat
        -- type, see TRIGGER/EffectIndex.lua
        Trigger.EffectIndex.Check( CHAT_TYPES, args.Message, args.ChatType, nil )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- trigger index
---------------------------------------------------------------------------------------------------
-- A chat trigger is a pattern, so it cannot be looked up by the text of a line.
-- CheckTrigger drops a trigger for another chat type before anything else,
-- though, so the triggers are filed by their source and a line only tries the
-- ones for its own chat type and the ones for any chat type.
Trigger.EffectIndex.Register( Trigger.Types.Chat, {
    check = function ( message, chatType, triggerData )
        return Trigger[ Trigger.Types.Chat ].CheckTrigger( message, chatType, triggerData )
    end,
    bucket = function ( triggerData )

        -- CheckTrigger never matches these
        if triggerData.token == nil or triggerData.token == "" or triggerData.source == nil then
            return nil
        end

        if triggerData.source == Source.Any then
            return Trigger.EffectIndex.EVERY_EVENT
        end

        return triggerData.source

    end,
    lookupKey = function ( message, chatType )
        return chatType
    end,
    process = function ( message, chatType, posAdjustment, entry )
        Trigger[ Trigger.Types.Chat ].ProcessTrigger( message, chatType, posAdjustment, entry.windowIndex, entry.timerIndex, entry.triggerIndex )
    end,
    folders           = true,
    conditionDuration = false,
} )
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

    -- require a non-empty token
    if triggerData.token == nil or triggerData.token == "" then
        return nil
    end

    -- find match with message and token (cache the processed pattern since the token is immutable at runtime)
    if triggerData._cachedPattern == nil then
        triggerData._cachedPattern = Trigger.ReplacePlaceholder( triggerData.token )
    end
    return string.find( message, triggerData._cachedPattern )

  
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

    local placeholder = Trigger.GetPlaceholder(token, message, posAdjustment, target, triggerData)


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

    end

   -- duration
   if timerData.useCustomTimer == true then
        duration = timerData.timerValue

        for index, value in pairs(placeholder) do
            if index == duration then
                duration = value
            end

        end
        duration = tonumber( duration ) or duration

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

    -- these are whole sentences with full stops in them, so a pattern match pays
    -- for the matcher on every line of chat. They are literal text, so ask for a
    -- plain search.
    for key, text in pairs(L[ Language.Local ].ReloadMessages) do
        
        if string.find( message, text, 1, true ) then
            Options.Reload()
            return
        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
ChatTriggerID = 1
---------------------------------------------------------------------------------------------------