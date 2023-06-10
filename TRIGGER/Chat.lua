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

--===================================================================================
--             Name:    LISTBOX OPTIONS Group TabWindow
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================



ChatOptions = class(Turbine.UI.Control)

function ChatOptions:Constructor()
	Turbine.UI.Control.Constructor( self )



    local width = 306
    self.multiselect = false

    self:SetWidth(width)
    self:SetBackColor( Defaults.Colors.BackgroundColor2 )


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
    self.actionLabel = Turbine.UI.Label()
    self.actionLabel:SetParent( self)
    self.actionLabel:SetPosition(             colum1_left, top + row * row_height )
    self.actionLabel:SetSize(                 colum1_widht, content_height )
    self.actionLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    self.actionLabel:SetFont(                 Defaults.Fonts.TabFont )
    self.actionLabel:SetText(                 L[Language.Local].Options.Action )
    Options.Constructor.Tooltip.AddTooltip( self.actionLabel, L[Language.Local].Tooltip.Text.Action)


    self.actionDropdown = Options.Constructor.Dropdown(  self, 140 )
    self.actionDropdown:SetPosition( colum2_left, top + row * row_height - 5 )

    for name, value in pairs(Actions) do

        self.actionDropdown:AddItem( name, value )
   
    end


    row = row + 2

-------------------------------------------------------------------------------------
    -- useRegex
    self.useRegexLabel = Turbine.UI.Label()
    self.useRegexLabel:SetParent(self)
    self.useRegexLabel:SetPosition(             colum1_left, top + row * row_height  )
    self.useRegexLabel:SetSize(                 colum1_widht, content_height )
    self.useRegexLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    self.useRegexLabel:SetFont(                 Defaults.Fonts.TabFont )
    self.useRegexLabel:SetText(                 L[Language.Local].Options.UseRegex )
    Options.Constructor.Tooltip.AddTooltip(self.useRegexLabel, L[Language.Local].Tooltip.Text.UseRegex)

    self.useRegexCheckBox = Options.Constructor.CheckBox()
    self.useRegexCheckBox:SetParent(self)
    self.useRegexCheckBox:SetPosition(             colum2_left + 10, top + row * row_height - checkBoxFix )
    self.useRegexCheckBox:SetSize(                 30, 30 )

    row = row + 1

-------------------------------------------------------------------------------------
    -- token
    self.tokenLabel = Turbine.UI.Label()
    self.tokenLabel:SetParent( self)
    self.tokenLabel:SetPosition(             colum1_left, top + row * row_height )
    self.tokenLabel:SetSize(                 colum1_widht, content_height )
    self.tokenLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    self.tokenLabel:SetFont(                 Defaults.Fonts.TabFont )
    self.tokenLabel:SetText(                 L[Language.Local].Options.Token )
    Options.Constructor.Tooltip.AddTooltip( self.tokenLabel, L[Language.Local].Tooltip.Text.Token)

    self.tokenTextBox = Options.Constructor.TextBox( self, colum2_width)
    self.tokenTextBox:SetPosition( colum2_left, top + row * row_height -5)
    self.tokenTextBox:SetMultiline(        false)


     row = row + 2

-------------------------------------------------------------------------------------
    -- targetList
    self.targetListLabel = Turbine.UI.Label()
    self.targetListLabel:SetParent( self)
    self.targetListLabel:SetPosition(             colum1_left, top + row * row_height )
    self.targetListLabel:SetSize(                 colum1_widht, content_height )
    self.targetListLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    self.targetListLabel:SetFont(                 Defaults.Fonts.TabFont )
    self.targetListLabel:SetText(                 L[Language.Local].Options.TargetList )
    Options.Constructor.Tooltip.AddTooltip( self.targetListLabel, L[Language.Local].Tooltip.Text.TargetList)

    self.targetListTextBox = Options.Constructor.TextBox( self, colum2_width, 100)
    self.targetListTextBox:SetPosition( colum2_left, top + row * row_height -5)
    self.targetListTextBox:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft)

     

    row = row + 5

-------------------------------------------------------------------------------------
    -- description
    self.descriptionLabel = Turbine.UI.Label()
    self.descriptionLabel:SetParent( self)
    self.descriptionLabel:SetPosition(             colum1_left, top + row * row_height )
    self.descriptionLabel:SetSize(                 colum1_widht, content_height )
    self.descriptionLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    self.descriptionLabel:SetFont(                 Defaults.Fonts.TabFont )
    self.descriptionLabel:SetText(                 L[Language.Local].Options.Description )
    Options.Constructor.Tooltip.AddTooltip( self.descriptionLabel, L[Language.Local].Tooltip.Text.Description)
    
    self.descriptionTextBox = Options.Constructor.TextBox( self, colum2_width, 100)
    self.descriptionTextBox:SetPosition( colum2_left, top + row * row_height -5)
    self.descriptionTextBox:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft)

    row = row + 5


end


-------------------------------------------------------------------------------------
--      Description:    CHAT OPTIONS Control
-------------------------------------------------------------------------------------
function ChatOptions:FillContent(triggerData, triggerIndex, multiselect)

    if triggerData == nil then

    else

        self.actionDropdown:SetSelection(triggerData.action)
        self.useRegexCheckBox:SetChecked(triggerData.useRegex)
        self.tokenTextBox:SetText(triggerData.token)
        self.targetListTextBox:SetText(triggerData.targetList)
        self.descriptionTextBox:SetText(triggerData.description)

    end

end
    


-------------------------------------------------------------------------------------
--      Description:    constructor array workaround
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
Trigger.Options[ Trigger.Types.Chat ] = function ()

    return ChatOptions()

end
