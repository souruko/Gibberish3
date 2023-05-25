--===================================================================================
--             Name:    GeneralTab
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
local window = Options.Controls[Group.Types.LISTBOX]
window.GeneralTab = Options.Constructor.Tab( 706, L[Language.Local].Tab.General, window.TabWindow )


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
-- name
window.GeneralTab.nameLabel = Turbine.UI.Label()
window.GeneralTab.nameLabel:SetParent(window.GeneralTab)
window.GeneralTab.nameLabel:SetPosition(             colum1_left, top + row * row_height )
window.GeneralTab.nameLabel:SetSize(                 colum1_widht, content_height )
window.GeneralTab.nameLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
window.GeneralTab.nameLabel:SetFont(                 Defaults.Fonts.TabFont )
window.GeneralTab.nameLabel:SetText(                 L[Language.Local].Options.Name )
window.GeneralTab.nameLabel.MouseEnter = function ()

    if Data.showTooltips == true then
        local widthh = 200
        local heightt = 60
        local leftt, topp = Turbine.UI.Display.GetMousePosition()
        leftt = leftt - (widthh / 2)
        topp = topp + 10

        local heading = L[Language.Local].Tooltip.Heading.GroupName
        local text  =  L[Language.Local].Tooltip.Text.GroupName
        Options.MainWindow.ShowTooltip( leftt, topp, widthh, heightt, heading, text )
    end
    
end
window.GeneralTab.nameLabel.MouseLeave = function ()
    Options.MainWindow.HideTooltip()
end

window.GeneralTab.nameTextBox = Turbine.UI.Lotro.TextBox()
window.GeneralTab.nameTextBox:SetParent(window.GeneralTab)
window.GeneralTab.nameTextBox:SetPosition(             colum2_left, top + row * row_height )
window.GeneralTab.nameTextBox:SetSize(                 colum2_width, content_height )
window.GeneralTab.nameTextBox:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
window.GeneralTab.nameTextBox:SetFont(                 Defaults.Fonts.TabFont )

row = row + 1
-------------------------------------------------------------------------------------
-- type
window.GeneralTab.typeLabel = Turbine.UI.Label()
window.GeneralTab.typeLabel:SetParent(window.GeneralTab)
window.GeneralTab.typeLabel:SetPosition(             colum1_left, top + row * row_height )
window.GeneralTab.typeLabel:SetSize(                 colum1_widht, content_height )
window.GeneralTab.typeLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
window.GeneralTab.typeLabel:SetFont(                 Defaults.Fonts.TabFont )
window.GeneralTab.typeLabel:SetText(                 L[Language.Local].Options.Type )
window.GeneralTab.typeLabel.MouseEnter = function ()

    if Data.showTooltips == true then
        local widthh = 200
        local heightt = 80
        local leftt, topp = Turbine.UI.Display.GetMousePosition()
        leftt = leftt - (widthh / 2)
        topp = topp + 10

        local heading = L[Language.Local].Tooltip.Heading.GroupType
        local text  =  L[Language.Local].Tooltip.Text.GroupType
        Options.MainWindow.ShowTooltip( leftt, topp, widthh, heightt, heading, text )
    end

end
window.GeneralTab.typeLabel.MouseLeave = function ()
    Options.MainWindow.HideTooltip()
end

window.GeneralTab.typeTextBox = Turbine.UI.Lotro.TextBox()
window.GeneralTab.typeTextBox:SetParent(window.GeneralTab)
window.GeneralTab.typeTextBox:SetPosition(             colum2_left, top + row * row_height )
window.GeneralTab.typeTextBox:SetSize(                 colum2_width, content_height )
window.GeneralTab.typeTextBox:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
window.GeneralTab.typeTextBox:SetFont(                 Defaults.Fonts.TabFont )
window.GeneralTab.typeTextBox:SetEnabled(false)

row = row + 2
-------------------------------------------------------------------------------------
-- globaly
window.GeneralTab.globalyLabel = Turbine.UI.Label()
window.GeneralTab.globalyLabel:SetParent(window.GeneralTab)
window.GeneralTab.globalyLabel:SetPosition(             colum1_left, top + row * row_height  )
window.GeneralTab.globalyLabel:SetSize(                 colum1_widht, content_height )
window.GeneralTab.globalyLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
window.GeneralTab.globalyLabel:SetFont(                 Defaults.Fonts.TabFont )
window.GeneralTab.globalyLabel:SetText(                 L[Language.Local].Options.Globaly )
window.GeneralTab.globalyLabel.MouseEnter = function ()

    if Data.showTooltips == true then
        local widthh = 200
        local heightt = 80
        local leftt, topp = Turbine.UI.Display.GetMousePosition()
        leftt = leftt - (widthh / 2)
        topp = topp + 10

        local heading = L[Language.Local].Tooltip.Heading.SaveGlobaly
        local text  =  L[Language.Local].Tooltip.Text.SaveGlobaly
        Options.MainWindow.ShowTooltip( leftt, topp, widthh, heightt, heading, text )
    end

end
window.GeneralTab.globalyLabel.MouseLeave = function ()
    Options.MainWindow.HideTooltip()
end

window.GeneralTab.globalyCheckBox = Options.Constructor.CheckBox()
window.GeneralTab.globalyCheckBox:SetParent(window.GeneralTab)
window.GeneralTab.globalyCheckBox:SetPosition(             colum2_left + 10, top + row * row_height - checkBoxFix )
window.GeneralTab.globalyCheckBox:SetSize(                 30, 30 )

row = row + 2
-------------------------------------------------------------------------------------
-- description
window.GeneralTab.descriptionLabel = Turbine.UI.Label()
window.GeneralTab.descriptionLabel:SetParent(window.GeneralTab)
window.GeneralTab.descriptionLabel:SetPosition(             colum1_left, top + row * row_height )
window.GeneralTab.descriptionLabel:SetSize(                 colum1_widht, content_height )
window.GeneralTab.descriptionLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
window.GeneralTab.descriptionLabel:SetFont(                 Defaults.Fonts.TabFont )
window.GeneralTab.descriptionLabel:SetText(                 L[Language.Local].Options.Description )
window.GeneralTab.descriptionLabel.MouseEnter = function ()

    if Data.showTooltips == true then
        local widthh = 200
        local heightt = 60
        local leftt, topp = Turbine.UI.Display.GetMousePosition()
        leftt = leftt - (widthh / 2)
        topp = topp + 10

        local heading = L[Language.Local].Tooltip.Heading.Description
        local text  =  L[Language.Local].Tooltip.Text.Description
        Options.MainWindow.ShowTooltip( leftt, topp, widthh, heightt, heading, text )
    end

end
window.GeneralTab.descriptionLabel.MouseLeave = function ()
    Options.MainWindow.HideTooltip()
end

window.GeneralTab.descriptionTextBox = Turbine.UI.Lotro.TextBox()
window.GeneralTab.descriptionTextBox:SetParent(window.GeneralTab)
window.GeneralTab.descriptionTextBox:SetPosition(             colum2_left, top + row * row_height )
window.GeneralTab.descriptionTextBox:SetSize(                 colum2_width, 100 )
window.GeneralTab.descriptionTextBox:SetTextAlignment(        Turbine.UI.ContentAlignment.TopLeft )
window.GeneralTab.descriptionTextBox:SetFont(                 Defaults.Fonts.TabFont )

row = row + 5
