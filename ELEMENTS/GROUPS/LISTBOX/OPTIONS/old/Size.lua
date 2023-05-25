--===================================================================================
--             Name:    SizeTab
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
local window = Options.Controls[Group.Types.LISTBOX]
window.SizeTab = Options.Constructor.Tab( 706, L[Language.Local].Tab.Size, window.TabWindow )


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
-- left
window.SizeTab.leftLabel = Turbine.UI.Label()
window.SizeTab.leftLabel:SetParent(window.SizeTab)
window.SizeTab.leftLabel:SetPosition(             colum1_left, top + row * row_height )
window.SizeTab.leftLabel:SetSize(                 colum1_widht, content_height )
window.SizeTab.leftLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
window.SizeTab.leftLabel:SetFont(                 Defaults.Fonts.TabFont )
window.SizeTab.leftLabel:SetText(                 L[Language.Local].Options.Left )
window.SizeTab.leftLabel.MouseEnter = function ()

    if Data.showTooltips == true then
        local widthh = 200
        local heightt = 60
        local leftt, topp = Turbine.UI.Display.GetMousePosition()
        leftt = leftt - (widthh / 2)
        topp = topp + 10

        local heading = L[Language.Local].Tooltip.Heading.Left
        local text  =  L[Language.Local].Tooltip.Text.Left
        Options.MainWindow.ShowTooltip( leftt, topp, widthh, heightt, heading, text )
    end
    
end
window.SizeTab.leftLabel.MouseLeave = function ()
    Options.MainWindow.HideTooltip()
end

window.SizeTab.leftTextBox = Turbine.UI.Lotro.TextBox()
window.SizeTab.leftTextBox:SetParent(window.SizeTab)
window.SizeTab.leftTextBox:SetPosition(             colum2_left, top + row * row_height )
window.SizeTab.leftTextBox:SetSize(                 colum2_width / 4, content_height )
window.SizeTab.leftTextBox:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
window.SizeTab.leftTextBox:SetFont(                 Defaults.Fonts.TabFont )

row = row + 1

-------------------------------------------------------------------------------------
-- top
window.SizeTab.topLabel = Turbine.UI.Label()
window.SizeTab.topLabel:SetParent(window.SizeTab)
window.SizeTab.topLabel:SetPosition(             colum1_left, top + row * row_height )
window.SizeTab.topLabel:SetSize(                 colum1_widht, content_height )
window.SizeTab.topLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
window.SizeTab.topLabel:SetFont(                 Defaults.Fonts.TabFont )
window.SizeTab.topLabel:SetText(                 L[Language.Local].Options.Top )
window.SizeTab.topLabel.MouseEnter = function ()

    if Data.showTooltips == true then
        local widthh = 200
        local heightt = 60
        local leftt, topp = Turbine.UI.Display.GetMousePosition()
        leftt = leftt - (widthh / 2)
        topp = topp + 10

        local heading = L[Language.Local].Tooltip.Heading.Top
        local text  =  L[Language.Local].Tooltip.Text.Top
        Options.MainWindow.ShowTooltip( leftt, topp, widthh, heightt, heading, text )
    end
    
end
window.SizeTab.topLabel.MouseLeave = function ()
    Options.MainWindow.HideTooltip()
end

window.SizeTab.topTextBox = Turbine.UI.Lotro.TextBox()
window.SizeTab.topTextBox:SetParent(window.SizeTab)
window.SizeTab.topTextBox:SetPosition(             colum2_left, top + row * row_height )
window.SizeTab.topTextBox:SetSize(                 colum2_width / 4, content_height )
window.SizeTab.topTextBox:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
window.SizeTab.topTextBox:SetFont(                 Defaults.Fonts.TabFont )

row = row + 2

-------------------------------------------------------------------------------------
-- width
window.SizeTab.widthLabel = Turbine.UI.Label()
window.SizeTab.widthLabel:SetParent(window.SizeTab)
window.SizeTab.widthLabel:SetPosition(             colum1_left, top + row * row_height )
window.SizeTab.widthLabel:SetSize(                 colum1_widht, content_height )
window.SizeTab.widthLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
window.SizeTab.widthLabel:SetFont(                 Defaults.Fonts.TabFont )
window.SizeTab.widthLabel:SetText(                 L[Language.Local].Options.Width )
window.SizeTab.widthLabel.MouseEnter = function ()

    if Data.showTooltips == true then
        local widthh = 200
        local heightt = 60
        local leftt, topp = Turbine.UI.Display.GetMousePosition()
        leftt = leftt - (widthh / 2)
        topp = topp + 10

        local heading = L[Language.Local].Tooltip.Heading.Width
        local text  =  L[Language.Local].Tooltip.Text.Width
        Options.MainWindow.ShowTooltip( leftt, topp, widthh, heightt, heading, text )
    end
    
end
window.SizeTab.widthLabel.MouseLeave = function ()
    Options.MainWindow.HideTooltip()
end

window.SizeTab.widthTextBox = Turbine.UI.Lotro.TextBox()
window.SizeTab.widthTextBox:SetParent(window.SizeTab)
window.SizeTab.widthTextBox:SetPosition(             colum2_left, top + row * row_height )
window.SizeTab.widthTextBox:SetSize(                 colum2_width / 4, content_height )
window.SizeTab.widthTextBox:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
window.SizeTab.widthTextBox:SetFont(                 Defaults.Fonts.TabFont )

row = row + 1

-------------------------------------------------------------------------------------
-- height
window.SizeTab.heightLabel = Turbine.UI.Label()
window.SizeTab.heightLabel:SetParent(window.SizeTab)
window.SizeTab.heightLabel:SetPosition(             colum1_left, top + row * row_height )
window.SizeTab.heightLabel:SetSize(                 colum1_widht, content_height )
window.SizeTab.heightLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
window.SizeTab.heightLabel:SetFont(                 Defaults.Fonts.TabFont )
window.SizeTab.heightLabel:SetText(                 L[Language.Local].Options.Height )
window.SizeTab.heightLabel.MouseEnter = function ()

    if Data.showTooltips == true then
        local widthh = 200
        local heightt = 60
        local leftt, topp = Turbine.UI.Display.GetMousePosition()
        leftt = leftt - (widthh / 2)
        topp = topp + 10

        local heading = L[Language.Local].Tooltip.Heading.Height
        local text  =  L[Language.Local].Tooltip.Text.Height
        Options.MainWindow.ShowTooltip( leftt, topp, widthh, heightt, heading, text )
    end
    
end
window.SizeTab.heightLabel.MouseLeave = function ()
    Options.MainWindow.HideTooltip()
end

window.SizeTab.heightTextBox = Turbine.UI.Lotro.TextBox()
window.SizeTab.heightTextBox:SetParent(window.SizeTab)
window.SizeTab.heightTextBox:SetPosition(             colum2_left, top + row * row_height )
window.SizeTab.heightTextBox:SetSize(                 colum2_width / 4, content_height )
window.SizeTab.heightTextBox:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
window.SizeTab.heightTextBox:SetFont(                 Defaults.Fonts.TabFont )

row = row + 2

-------------------------------------------------------------------------------------
-- frame
window.SizeTab.frameLabel = Turbine.UI.Label()
window.SizeTab.frameLabel:SetParent(window.SizeTab)
window.SizeTab.frameLabel:SetPosition(             colum1_left, top + row * row_height )
window.SizeTab.frameLabel:SetSize(                 colum1_widht, content_height )
window.SizeTab.frameLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
window.SizeTab.frameLabel:SetFont(                 Defaults.Fonts.TabFont )
window.SizeTab.frameLabel:SetText(                 L[Language.Local].Options.Frame )
window.SizeTab.frameLabel.MouseEnter = function ()

    if Data.showTooltips == true then
        local widthh = 200
        local heightt = 60
        local leftt, topp = Turbine.UI.Display.GetMousePosition()
        leftt = leftt - (widthh / 2)
        topp = topp + 10

        local heading = L[Language.Local].Tooltip.Heading.Frame
        local text  =  L[Language.Local].Tooltip.Text.Frame
        Options.MainWindow.ShowTooltip( leftt, topp, widthh, heightt, heading, text )
    end
    
end
window.SizeTab.frameLabel.MouseLeave = function ()
    Options.MainWindow.HideTooltip()
end

window.SizeTab.frameTextBox = Turbine.UI.Lotro.TextBox()
window.SizeTab.frameTextBox:SetParent(window.SizeTab)
window.SizeTab.frameTextBox:SetPosition(             colum2_left, top + row * row_height )
window.SizeTab.frameTextBox:SetSize(                 colum2_width / 4, content_height )
window.SizeTab.frameTextBox:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
window.SizeTab.frameTextBox:SetFont(                 Defaults.Fonts.TabFont )

row = row + 1

-------------------------------------------------------------------------------------
-- spacing
window.SizeTab.spacingLabel = Turbine.UI.Label()
window.SizeTab.spacingLabel:SetParent(window.SizeTab)
window.SizeTab.spacingLabel:SetPosition(             colum1_left, top + row * row_height )
window.SizeTab.spacingLabel:SetSize(                 colum1_widht, content_height )
window.SizeTab.spacingLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
window.SizeTab.spacingLabel:SetFont(                 Defaults.Fonts.TabFont )
window.SizeTab.spacingLabel:SetText(                 L[Language.Local].Options.Spacing )
window.SizeTab.spacingLabel.MouseEnter = function ()

    if Data.showTooltips == true then
        local widthh = 200
        local heightt = 60
        local leftt, topp = Turbine.UI.Display.GetMousePosition()
        leftt = leftt - (widthh / 2)
        topp = topp + 10

        local heading = L[Language.Local].Tooltip.Heading.Spacing
        local text  =  L[Language.Local].Tooltip.Text.Spacing
        Options.MainWindow.ShowTooltip( leftt, topp, widthh, heightt, heading, text )
    end
    
end
window.SizeTab.spacingLabel.MouseLeave = function ()
    Options.MainWindow.HideTooltip()
end

window.SizeTab.spacingTextBox = Turbine.UI.Lotro.TextBox()
window.SizeTab.spacingTextBox:SetParent(window.SizeTab)
window.SizeTab.spacingTextBox:SetPosition(             colum2_left, top + row * row_height )
window.SizeTab.spacingTextBox:SetSize(                 colum2_width / 4, content_height )
window.SizeTab.spacingTextBox:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
window.SizeTab.spacingTextBox:SetFont(                 Defaults.Fonts.TabFont )

row = row + 2
-------------------------------------------------------------------------------------
-- direction
window.SizeTab.directionLabel = Turbine.UI.Label()
window.SizeTab.directionLabel:SetParent(window.SizeTab)
window.SizeTab.directionLabel:SetPosition(             colum1_left, top + row * row_height  )
window.SizeTab.directionLabel:SetSize(                 colum1_widht, content_height )
window.SizeTab.directionLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
window.SizeTab.directionLabel:SetFont(                 Defaults.Fonts.TabFont )
window.SizeTab.directionLabel:SetText(                 L[Language.Local].Options.Direction )
window.SizeTab.directionLabel.MouseEnter = function ()

    if Data.showTooltips == true then
        local widthh = 200
        local heightt = 80
        local leftt, topp = Turbine.UI.Display.GetMousePosition()
        leftt = leftt - (widthh / 2)
        topp = topp + 10

        local heading = L[Language.Local].Tooltip.Heading.Direction
        local text  =  L[Language.Local].Tooltip.Text.Direction
        Options.MainWindow.ShowTooltip( leftt, topp, widthh, heightt, heading, text )
    end
    
end
window.SizeTab.directionLabel.MouseLeave = function ()
    Options.MainWindow.HideTooltip()
end

window.SizeTab.directionCheckBox = Options.Constructor.CheckBox()
window.SizeTab.directionCheckBox:SetParent(window.SizeTab)
window.SizeTab.directionCheckBox:SetPosition(             colum2_left + 10, top + row * row_height - checkBoxFix )
window.SizeTab.directionCheckBox:SetSize(                 30, 30 )

row = row + 1

-------------------------------------------------------------------------------------
-- orientation
window.SizeTab.orientationLabel = Turbine.UI.Label()
window.SizeTab.orientationLabel:SetParent(window.SizeTab)
window.SizeTab.orientationLabel:SetPosition(             colum1_left, top + row * row_height  )
window.SizeTab.orientationLabel:SetSize(                 colum1_widht, content_height )
window.SizeTab.orientationLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
window.SizeTab.orientationLabel:SetFont(                 Defaults.Fonts.TabFont )
window.SizeTab.orientationLabel:SetText(                 L[Language.Local].Options.Orientation )
window.SizeTab.orientationLabel.MouseEnter = function ()

    if Data.showTooltips == true then
        local widthh = 200
        local heightt = 80
        local leftt, topp = Turbine.UI.Display.GetMousePosition()
        leftt = leftt - (widthh / 2)
        topp = topp + 10

        local heading = L[Language.Local].Tooltip.Heading.Orientation
        local text  =  L[Language.Local].Tooltip.Text.Orientation
        Options.MainWindow.ShowTooltip( leftt, topp, widthh, heightt, heading, text )
    end
    
end
window.SizeTab.orientationLabel.MouseLeave = function ()
    Options.MainWindow.HideTooltip()
end

window.SizeTab.orientationCheckBox = Options.Constructor.CheckBox()
window.SizeTab.orientationCheckBox:SetParent(window.SizeTab)
window.SizeTab.orientationCheckBox:SetPosition(             colum2_left + 10, top + row * row_height - checkBoxFix )
window.SizeTab.orientationCheckBox:SetSize(                 30, 30 )

row = row + 1

-------------------------------------------------------------------------------------
-- overlay
window.SizeTab.overlayLabel = Turbine.UI.Label()
window.SizeTab.overlayLabel:SetParent(window.SizeTab)
window.SizeTab.overlayLabel:SetPosition(             colum1_left, top + row * row_height  )
window.SizeTab.overlayLabel:SetSize(                 colum1_widht, content_height )
window.SizeTab.overlayLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
window.SizeTab.overlayLabel:SetFont(                 Defaults.Fonts.TabFont )
window.SizeTab.overlayLabel:SetText(                 L[Language.Local].Options.Overlay )
window.SizeTab.overlayLabel.MouseEnter = function ()

    if Data.showTooltips == true then
        local widthh = 200
        local heightt = 60
        local leftt, topp = Turbine.UI.Display.GetMousePosition()
        leftt = leftt - (widthh / 2)
        topp = topp + 10

        local heading = L[Language.Local].Tooltip.Heading.Overlay
        local text  =  L[Language.Local].Tooltip.Text.Overlay
        Options.MainWindow.ShowTooltip( leftt, topp, widthh, heightt, heading, text )
    end
    
end
window.SizeTab.overlayLabel.MouseLeave = function ()
    Options.MainWindow.HideTooltip()
end

window.SizeTab.overlayCheckBox = Options.Constructor.CheckBox()
window.SizeTab.overlayCheckBox:SetParent(window.SizeTab)
window.SizeTab.overlayCheckBox:SetPosition(             colum2_left + 10, top + row * row_height - checkBoxFix )
window.SizeTab.overlayCheckBox:SetSize(                 30, 30 )

row = row + 1