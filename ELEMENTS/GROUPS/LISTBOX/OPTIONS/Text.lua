--===================================================================================
--             Name:    GeneralTab
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
local window = Options.Controls[Group.Types.LISTBOX]
window.TextTab = Options.Constructor.Tab( 706, L[Language.Local].Tab.Text, window.TabWindow )


local row = 0
local row_height = 28
local top = 60
local checkBoxFix = 5
local colum1_left = 10
local colum2_left = 140
local colum1_widht = 110
local colum2_width = 210
local content_height = 20

-------------------------------------------------------------------------------------
-- font
window.TextTab.fontLabel = Turbine.UI.Label()
window.TextTab.fontLabel:SetParent(window.TextTab)
window.TextTab.fontLabel:SetPosition(             colum1_left, top + row * row_height )
window.TextTab.fontLabel:SetSize(                 colum1_widht, content_height )
window.TextTab.fontLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
window.TextTab.fontLabel:SetFont(                 Defaults.Fonts.TabFont )
window.TextTab.fontLabel:SetText(                 L[Language.Local].Options.Font )
window.TextTab.fontLabel.MouseEnter = function ()

    if Data.showTooltips == true then
        local widthh = 200
        local heightt = 60
        local leftt, topp = Turbine.UI.Display.GetMousePosition()
        leftt = leftt - (widthh / 2)
        topp = topp + 10

        local heading = L[Language.Local].Tooltip.Heading.Font
        local text  =  L[Language.Local].Tooltip.Text.Font
        Options.MainWindow.ShowTooltip( leftt, topp, widthh, heightt, heading, text )
    end

end
window.TextTab.fontLabel.MouseLeave = function ()
    Options.MainWindow.HideTooltip()
end


window.TextTab.fontDropdown = Options.Constructor.Dropdown( window.TextTab, 140 )
window.TextTab.fontDropdown:SetPosition( colum2_left + 10, top + row * row_height - 5 )

for name, value in pairs(Font.Type) do

    window.TextTab.fontDropdown:AddItem( name, value )
    
end

window.TextTab.fontSizeDropdown = Options.Constructor.Dropdown( window.TextTab, 50 )
window.TextTab.fontSizeDropdown:SetPosition( colum2_left + 160, top + row * row_height -5 )

window.TextTab.fontDropdown.SelectionChanged = function(sender, index, value)

    if sender == window.TextTab.fontDropdown then

        window.TextTab.fontSizeDropdown:ClearItems()

        local fonttype = window.TextTab.fontDropdown:GetSelectionValue()

        if fonttype ~= nil then

            for size, turbinefont in pairs(Font[fonttype]) do

                window.TextTab.fontSizeDropdown:AddItem( size, size )
    
            end

            window.TextTab.fontSizeDropdown:SetSelection(1)

        end
  
    end
    
end

row = row + 2


-------------------------------------------------------------------------------------
-- timer format
window.TextTab.timerFormatLabel = Turbine.UI.Label()
window.TextTab.timerFormatLabel:SetParent(window.TextTab)
window.TextTab.timerFormatLabel:SetPosition(             colum1_left, top + row * row_height )
window.TextTab.timerFormatLabel:SetSize(                 colum1_widht, content_height )
window.TextTab.timerFormatLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
window.TextTab.timerFormatLabel:SetFont(                 Defaults.Fonts.TabFont )
window.TextTab.timerFormatLabel:SetText(                 L[Language.Local].Options.DurationFormat )
window.TextTab.timerFormatLabel.MouseEnter = function ()

    if Data.showTooltips == true then
        local widthh = 200
        local heightt = 60
        local leftt, topp = Turbine.UI.Display.GetMousePosition()
        leftt = leftt - (widthh / 2)
        topp = topp + 10

        local heading = L[Language.Local].Tooltip.Heading.DurationFormat
        local text  =  L[Language.Local].Tooltip.Text.DurationFormat
        Options.MainWindow.ShowTooltip( leftt, topp, widthh, heightt, heading, text )
    end

end
window.TextTab.timerFormatLabel.MouseLeave = function ()
    Options.MainWindow.HideTooltip()
end


window.TextTab.numberDropdown = Options.Constructor.Dropdown( window.TextTab, 140 )
window.TextTab.numberDropdown:SetPosition( colum2_left + 10, top + row * row_height - 5 )

for name, value in pairs(NumberFormat) do

    window.TextTab.numberDropdown:AddItem( name, value )
    
end


row = row + 2


-------------------------------------------------------------------------------------
-- timer format
window.TextTab.textAlignmentLabel = Turbine.UI.Label()
window.TextTab.textAlignmentLabel:SetParent(window.TextTab)
window.TextTab.textAlignmentLabel:SetPosition(             colum1_left, top + row * row_height )
window.TextTab.textAlignmentLabel:SetSize(                 colum1_widht, content_height )
window.TextTab.textAlignmentLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
window.TextTab.textAlignmentLabel:SetFont(                 Defaults.Fonts.TabFont )
window.TextTab.textAlignmentLabel:SetText(                 L[Language.Local].Options.TextAlignment )
window.TextTab.textAlignmentLabel.MouseEnter = function ()

    if Data.showTooltips == true then
        local widthh = 200
        local heightt = 60
        local leftt, topp = Turbine.UI.Display.GetMousePosition()
        leftt = leftt - (widthh / 2)
        topp = topp + 10

        local heading = L[Language.Local].Tooltip.Heading.TextAlignment
        local text  =  L[Language.Local].Tooltip.Text.TextAlignment
        Options.MainWindow.ShowTooltip( leftt, topp, widthh, heightt, heading, text )
    end

end
window.TextTab.textAlignmentLabel.MouseLeave = function ()
    Options.MainWindow.HideTooltip()
end

window.TextTab.textAlignmentDropdown = Options.Constructor.Dropdown( window.TextTab, 140 )
window.TextTab.textAlignmentDropdown:SetPosition( colum2_left + 10, top + row * row_height - 5 )

for name, value in pairs(Turbine.UI.ContentAlignment) do

    if name ~= "Undefined" and name ~= "IsA" then
        window.TextTab.textAlignmentDropdown:AddItem( name, value )
    end
    
end


row = row + 1


-------------------------------------------------------------------------------------
-- timer format
window.TextTab.timerAlignmentLabel = Turbine.UI.Label()
window.TextTab.timerAlignmentLabel:SetParent(window.TextTab)
window.TextTab.timerAlignmentLabel:SetPosition(             colum1_left, top + row * row_height )
window.TextTab.timerAlignmentLabel:SetSize(                 colum1_widht, content_height )
window.TextTab.timerAlignmentLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
window.TextTab.timerAlignmentLabel:SetFont(                 Defaults.Fonts.TabFont )
window.TextTab.timerAlignmentLabel:SetText(                 L[Language.Local].Options.TimerAlignment )
window.TextTab.timerAlignmentLabel.MouseEnter = function ()

    if Data.showTooltips == true then
        local widthh = 200
        local heightt = 60
        local leftt, topp = Turbine.UI.Display.GetMousePosition()
        leftt = leftt - (widthh / 2)
        topp = topp + 10

        local heading = L[Language.Local].Tooltip.Heading.TimerAlignment
        local text  =  L[Language.Local].Tooltip.Text.TimerAlignment
        Options.MainWindow.ShowTooltip( leftt, topp, widthh, heightt, heading, text )
    end

end
window.TextTab.timerAlignmentLabel.MouseLeave = function ()
    Options.MainWindow.HideTooltip()
end


window.TextTab.timerAlignmentDropdown = Options.Constructor.Dropdown( window.TextTab, 140 )
window.TextTab.timerAlignmentDropdown:SetPosition( colum2_left + 10, top + row * row_height - 5 )

for name, value in pairs(Turbine.UI.ContentAlignment) do

    if name ~= "Undefined" and name ~= "IsA" then
        window.TextTab.timerAlignmentDropdown:AddItem( name, value )
    end
    
end


row = row + 2


-------------------------------------------------------------------------------------
-- timer format
window.TextTab.showTimerLabel = Turbine.UI.Label()
window.TextTab.showTimerLabel:SetParent(window.TextTab)
window.TextTab.showTimerLabel:SetPosition(             colum1_left, top + row * row_height )
window.TextTab.showTimerLabel:SetSize(                 colum1_widht, content_height )
window.TextTab.showTimerLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
window.TextTab.showTimerLabel:SetFont(                 Defaults.Fonts.TabFont )
window.TextTab.showTimerLabel:SetText(                 L[Language.Local].Options.ShowTimer )
window.TextTab.showTimerLabel.MouseEnter = function ()

    if Data.showTooltips == true then
        local widthh = 200
        local heightt = 60
        local leftt, topp = Turbine.UI.Display.GetMousePosition()
        leftt = leftt - (widthh / 2)
        topp = topp + 10

        local heading = L[Language.Local].Tooltip.Heading.ShowTimer
        local text  =  L[Language.Local].Tooltip.Text.ShowTimer
        Options.MainWindow.ShowTooltip( leftt, topp, widthh, heightt, heading, text )
    end

end
window.TextTab.showTimerLabel.MouseLeave = function ()
    Options.MainWindow.HideTooltip()
end


window.TextTab.showTimerCheckBox = Options.Constructor.CheckBox()
window.TextTab.showTimerCheckBox:SetParent(window.TextTab)
window.TextTab.showTimerCheckBox:SetPosition(             colum2_left + 10, top + row * row_height - checkBoxFix )
window.TextTab.showTimerCheckBox:SetSize(                 30, 30 )


row = row + 1

