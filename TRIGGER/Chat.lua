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



-------------------------------------------------------------------------------------
--      Description:    CHAT OPTIONS Control
-------------------------------------------------------------------------------------
Trigger.Options[ Trigger.Types.Chat ] = Turbine.UI.Control()

local width = 306
local chatOptions = Trigger.Options[ Trigger.Types.Chat ]
chatOptions.multiselect = false

chatOptions:SetWidth(width)
chatOptions:SetBackColor( Defaults.Colors.BackgroundColor2 )


local row = 0
local row_height = 28
local top = 20
local checkBoxFix = 5
local colum1_left = 0
local colum2_left = 120
local colum1_widht = 100
local colum2_width = 180
local content_height = 20


-------------------------------------------------------------------------------------
    -- action
    chatOptions.actionLabel = Turbine.UI.Label()
    chatOptions.actionLabel:SetParent( chatOptions)
    chatOptions.actionLabel:SetPosition(             colum1_left, top + row * row_height )
    chatOptions.actionLabel:SetSize(                 colum1_widht, content_height )
    chatOptions.actionLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    chatOptions.actionLabel:SetFont(                 Defaults.Fonts.TabFont )
    chatOptions.actionLabel:SetText(                 L[Language.Local].Options.Action )
    Options.Constructor.Tooltip.AddTooltip( chatOptions.actionLabel, L[Language.Local].Tooltip.Text.Action)


    chatOptions.actionDropdown = Options.Constructor.Dropdown(  chatOptions, 140 )
    chatOptions.actionDropdown:SetPosition( colum2_left, top + row * row_height - 5 )

    for name, value in pairs(Actions) do

        chatOptions.actionDropdown:AddItem( name, value )
   
    end


    row = row + 2

-------------------------------------------------------------------------------------
    -- useRegex
    chatOptions.useRegexLabel = Turbine.UI.Label()
    chatOptions.useRegexLabel:SetParent(chatOptions)
    chatOptions.useRegexLabel:SetPosition(             colum1_left, top + row * row_height  )
    chatOptions.useRegexLabel:SetSize(                 colum1_widht, content_height )
    chatOptions.useRegexLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    chatOptions.useRegexLabel:SetFont(                 Defaults.Fonts.TabFont )
    chatOptions.useRegexLabel:SetText(                 L[Language.Local].Options.UseRegex )
    Options.Constructor.Tooltip.AddTooltip(chatOptions.useRegexLabel, L[Language.Local].Tooltip.Text.UseRegex)

    chatOptions.useRegexCheckBox = Options.Constructor.CheckBox()
    chatOptions.useRegexCheckBox:SetParent(chatOptions)
    chatOptions.useRegexCheckBox:SetPosition(             colum2_left + 10, top + row * row_height - checkBoxFix )
    chatOptions.useRegexCheckBox:SetSize(                 30, 30 )

    row = row + 1

-------------------------------------------------------------------------------------
    -- token
    chatOptions.tokenLabel = Turbine.UI.Label()
    chatOptions.tokenLabel:SetParent( chatOptions)
    chatOptions.tokenLabel:SetPosition(             colum1_left, top + row * row_height )
    chatOptions.tokenLabel:SetSize(                 colum1_widht, content_height )
    chatOptions.tokenLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    chatOptions.tokenLabel:SetFont(                 Defaults.Fonts.TabFont )
    chatOptions.tokenLabel:SetText(                 L[Language.Local].Options.Token )
    Options.Constructor.Tooltip.AddTooltip( chatOptions.tokenLabel, L[Language.Local].Tooltip.Text.Token)

    chatOptions.tokenTextBox = Options.Constructor.TextBox( chatOptions, colum2_width)
    chatOptions.tokenTextBox:SetPosition( colum2_left, top + row * row_height -5)
    chatOptions.tokenTextBox:SetMultiline(        false)


     row = row + 2

-------------------------------------------------------------------------------------
    -- targetList
    chatOptions.targetListLabel = Turbine.UI.Label()
    chatOptions.targetListLabel:SetParent( chatOptions)
    chatOptions.targetListLabel:SetPosition(             colum1_left, top + row * row_height )
    chatOptions.targetListLabel:SetSize(                 colum1_widht, content_height )
    chatOptions.targetListLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    chatOptions.targetListLabel:SetFont(                 Defaults.Fonts.TabFont )
    chatOptions.targetListLabel:SetText(                 L[Language.Local].Options.TargetList )
    Options.Constructor.Tooltip.AddTooltip( chatOptions.targetListLabel, L[Language.Local].Tooltip.Text.TargetList)

    chatOptions.targetListTextBox = Options.Constructor.TextBox( chatOptions, colum2_width, 100)
    chatOptions.targetListTextBox:SetPosition( colum2_left, top + row * row_height -5)
    chatOptions.targetListTextBox:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft)

     

    row = row + 5

-------------------------------------------------------------------------------------
    -- description
    chatOptions.descriptionLabel = Turbine.UI.Label()
    chatOptions.descriptionLabel:SetParent( chatOptions)
    chatOptions.descriptionLabel:SetPosition(             colum1_left, top + row * row_height )
    chatOptions.descriptionLabel:SetSize(                 colum1_widht, content_height )
    chatOptions.descriptionLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    chatOptions.descriptionLabel:SetFont(                 Defaults.Fonts.TabFont )
    chatOptions.descriptionLabel:SetText(                 L[Language.Local].Options.Description )
    Options.Constructor.Tooltip.AddTooltip( chatOptions.descriptionLabel, L[Language.Local].Tooltip.Text.Description)
    
    chatOptions.descriptionTextBox = Options.Constructor.TextBox( chatOptions, colum2_width, 100)
    chatOptions.descriptionTextBox:SetPosition( colum2_left, top + row * row_height -5)
    chatOptions.descriptionTextBox:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft)

    row = row + 5

    function chatOptions:FillContent(triggerData, triggerIndex, multiselect)

        if triggerData == nil then

        else

            chatOptions.actionDropdown:SetSelection(triggerData.action)
            chatOptions.useRegexCheckBox:SetChecked(triggerData.useRegex)
            chatOptions.tokenTextBox:SetText(triggerData.token)
            chatOptions.targetListTextBox:SetText(triggerData.targetList)
            chatOptions.descriptionTextBox:SetText(triggerData.description)

        end

    end