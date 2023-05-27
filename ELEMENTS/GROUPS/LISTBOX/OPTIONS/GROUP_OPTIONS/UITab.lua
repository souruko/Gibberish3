--===================================================================================
--             Name:    LISTBOX OPTIONS Group UITabs
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================


GroupUITab = class(  Options.Constructor.Tab )

-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS GROUP TABWINDOW
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function GroupUITab:Constructor( width, name, tabwindow )
	Options.Constructor.Tab.Constructor( self )

    self:SetWidth( width )
    self:SetName( name )
    self:SetTabWindow( tabwindow )

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
    self.leftLabel = Turbine.UI.Label()
    self.leftLabel:SetParent(self)
    self.leftLabel:SetPosition(             colum1_left, top + row * row_height )
    self.leftLabel:SetSize(                 colum1_widht, content_height )
    self.leftLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    self.leftLabel:SetFont(                 Defaults.Fonts.TabFont )
    self.leftLabel:SetText(                 L[Language.Local].Options.Left )
    Options.Constructor.Tooltip.AddTooltip(self.leftLabel, L[Language.Local].Tooltip.Text.Left)

    
    self.leftTextBox = Options.Constructor.TextBox(self, colum2_width / 4)
    self.leftTextBox:SetPosition( colum2_left, top + row * row_height -5)
    self.leftTextBox:SetMultiline(        false)

    row = row + 1

    -------------------------------------------------------------------------------------
    -- top
    self.topLabel = Turbine.UI.Label()
    self.topLabel:SetParent(self)
    self.topLabel:SetPosition(             colum1_left, top + row * row_height )
    self.topLabel:SetSize(                 colum1_widht, content_height )
    self.topLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    self.topLabel:SetFont(                 Defaults.Fonts.TabFont )
    self.topLabel:SetText(                 L[Language.Local].Options.Top )
    Options.Constructor.Tooltip.AddTooltip(self.topLabel, L[Language.Local].Tooltip.Text.Top)

    
    self.topTextBox = Options.Constructor.TextBox(self, colum2_width / 4)
    self.topTextBox:SetPosition( colum2_left, top + row * row_height -5)
    self.topTextBox:SetMultiline(        false)

    row = row + 2

    -------------------------------------------------------------------------------------
    -- width
    self.widthLabel = Turbine.UI.Label()
    self.widthLabel:SetParent(self)
    self.widthLabel:SetPosition(             colum1_left, top + row * row_height )
    self.widthLabel:SetSize(                 colum1_widht, content_height )
    self.widthLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    self.widthLabel:SetFont(                 Defaults.Fonts.TabFont )
    self.widthLabel:SetText(                 L[Language.Local].Options.Width )
    Options.Constructor.Tooltip.AddTooltip(self.widthLabel, L[Language.Local].Tooltip.Text.Width)

    self.widthTextBox = Options.Constructor.TextBox(self, colum2_width / 4)
    self.widthTextBox:SetPosition( colum2_left, top + row * row_height -5)
    self.widthTextBox:SetMultiline(        false)

    row = row + 1

    -------------------------------------------------------------------------------------
    -- height
    self.heightLabel = Turbine.UI.Label()
    self.heightLabel:SetParent(self)
    self.heightLabel:SetPosition(             colum1_left, top + row * row_height )
    self.heightLabel:SetSize(                 colum1_widht, content_height )
    self.heightLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    self.heightLabel:SetFont(                 Defaults.Fonts.TabFont )
    self.heightLabel:SetText(                 L[Language.Local].Options.Height )
    Options.Constructor.Tooltip.AddTooltip(self.heightLabel, L[Language.Local].Tooltip.Text.Height)

    self.heightTextBox = Options.Constructor.TextBox(self, colum2_width / 4)
    self.heightTextBox:SetPosition( colum2_left, top + row * row_height -5)
    self.heightTextBox:SetMultiline(        false)

    row = row + 2

    -------------------------------------------------------------------------------------
    -- frame
    self.frameLabel = Turbine.UI.Label()
    self.frameLabel:SetParent(self)
    self.frameLabel:SetPosition(             colum1_left, top + row * row_height )
    self.frameLabel:SetSize(                 colum1_widht, content_height )
    self.frameLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    self.frameLabel:SetFont(                 Defaults.Fonts.TabFont )
    self.frameLabel:SetText(                 L[Language.Local].Options.Frame )
    Options.Constructor.Tooltip.AddTooltip(self.frameLabel, L[Language.Local].Tooltip.Text.Frame)

    self.frameTextBox = Options.Constructor.TextBox(self, colum2_width / 4)
    self.frameTextBox:SetPosition( colum2_left, top + row * row_height -5)
    self.frameTextBox:SetMultiline(        false)

    row = row + 1

    -------------------------------------------------------------------------------------
    -- spacing
    self.spacingLabel = Turbine.UI.Label()
    self.spacingLabel:SetParent(self)
    self.spacingLabel:SetPosition(             colum1_left, top + row * row_height )
    self.spacingLabel:SetSize(                 colum1_widht, content_height )
    self.spacingLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    self.spacingLabel:SetFont(                 Defaults.Fonts.TabFont )
    self.spacingLabel:SetText(                 L[Language.Local].Options.Spacing )
    Options.Constructor.Tooltip.AddTooltip(self.spacingLabel, L[Language.Local].Tooltip.Text.Spacing)

    self.spacingTextBox = Options.Constructor.TextBox(self, colum2_width / 4)
    self.spacingTextBox:SetPosition( colum2_left, top + row * row_height -5)
    self.spacingTextBox:SetMultiline(        false)

    row = row + 2
    -------------------------------------------------------------------------------------
    -- direction
    self.directionLabel = Turbine.UI.Label()
    self.directionLabel:SetParent(self)
    self.directionLabel:SetPosition(             colum1_left, top + row * row_height  )
    self.directionLabel:SetSize(                 colum1_widht, content_height )
    self.directionLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    self.directionLabel:SetFont(                 Defaults.Fonts.TabFont )
    self.directionLabel:SetText(                 L[Language.Local].Options.Direction )
    Options.Constructor.Tooltip.AddTooltip(self.directionLabel, L[Language.Local].Tooltip.Text.Direction)

    self.directionCheckBox = Options.Constructor.CheckBox()
    self.directionCheckBox:SetParent(self)
    self.directionCheckBox:SetPosition(             colum2_left + 10, top + row * row_height - checkBoxFix )
    self.directionCheckBox:SetSize(                 30, 30 )

    row = row + 1

    -------------------------------------------------------------------------------------
    -- orientation
    self.orientationLabel = Turbine.UI.Label()
    self.orientationLabel:SetParent(self)
    self.orientationLabel:SetPosition(             colum1_left, top + row * row_height  )
    self.orientationLabel:SetSize(                 colum1_widht, content_height )
    self.orientationLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    self.orientationLabel:SetFont(                 Defaults.Fonts.TabFont )
    self.orientationLabel:SetText(                 L[Language.Local].Options.Orientation )
    Options.Constructor.Tooltip.AddTooltip(self.orientationLabel, L[Language.Local].Tooltip.Text.Orientation)

    self.orientationCheckBox = Options.Constructor.CheckBox()
    self.orientationCheckBox:SetParent(self)
    self.orientationCheckBox:SetPosition(             colum2_left + 10, top + row * row_height - checkBoxFix )
    self.orientationCheckBox:SetSize(                 30, 30 )

    row = row + 1

    -------------------------------------------------------------------------------------
    -- overlay
    self.overlayLabel = Turbine.UI.Label()
    self.overlayLabel:SetParent(self)
    self.overlayLabel:SetPosition(             colum1_left, top + row * row_height  )
    self.overlayLabel:SetSize(                 colum1_widht, content_height )
    self.overlayLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    self.overlayLabel:SetFont(                 Defaults.Fonts.TabFont )
    self.overlayLabel:SetText(                 L[Language.Local].Options.Overlay )
    Options.Constructor.Tooltip.AddTooltip(self.overlayLabel, L[Language.Local].Tooltip.Text.Overlay)

    self.overlayCheckBox = Options.Constructor.CheckBox()
    self.overlayCheckBox:SetParent(self)
    self.overlayCheckBox:SetPosition(             colum2_left + 10, top + row * row_height - checkBoxFix )
    self.overlayCheckBox:SetSize(                 30, 30 )

    row = row + 1

end

-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS GROUP TABWINDOW
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function GroupUITab:FillContent( groupData, groupIndex, multiselect )

    if multiselect == true then

        self.leftLabel:SetVisible(false)
        self.leftTextBox:SetVisible(false)
        self.topLabel:SetVisible(false)
        self.topTextBox:SetVisible(false)

        self.leftTextBox:SetText("")
        self.topTextBox:SetText("")
    
    else

        self.leftLabel:SetVisible(true)
        self.leftTextBox:SetVisible(true)
        self.topLabel:SetVisible(true)
        self.topTextBox:SetVisible(true)

        local left, top = Utils.ScreenRatioToPixel( groupData.left, groupData.top)
        self.leftTextBox:SetText(left)
        self.topTextBox:SetText(top)

    end

    self.widthTextBox:SetText(groupData.width)
    self.heightTextBox:SetText(groupData.height)
    self.frameTextBox:SetText(groupData.frame)
    self.spacingTextBox:SetText(groupData.spacing)
    
    self.overlayCheckBox:SetChecked(groupData.overlay)
    self.directionCheckBox:SetChecked(groupData.direction)
    self.orientationCheckBox:SetChecked(groupData.orientation)

end





