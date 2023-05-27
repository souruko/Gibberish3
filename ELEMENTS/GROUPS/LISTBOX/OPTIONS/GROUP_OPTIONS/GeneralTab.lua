
--===================================================================================
--             Name:    LISTBOX OPTIONS Group GeneralTabs
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================


GroupGeneralTab = class(  Options.Constructor.Tab )

-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS GROUP TABWINDOW
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function GroupGeneralTab:Constructor( width, name, tabwindow )
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
    -- globaly
    self.globalyLabel = Turbine.UI.Label()
    self.globalyLabel:SetParent(self)
    self.globalyLabel:SetPosition(             colum1_left, top + row * row_height  )
    self.globalyLabel:SetSize(                 colum1_widht, content_height )
    self.globalyLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    self.globalyLabel:SetFont(                 Defaults.Fonts.TabFont )
    self.globalyLabel:SetText(                 L[Language.Local].Options.Globaly )
    Options.Constructor.Tooltip.AddTooltip(self.globalyLabel, L[Language.Local].Tooltip.Text.SaveGlobaly)
    
    self.globalyCheckBox = Options.Constructor.CheckBox()
    self.globalyCheckBox:SetParent(self)
    self.globalyCheckBox:SetPosition(             colum2_left + 10, top + row * row_height - checkBoxFix )
    self.globalyCheckBox:SetSize(                 30, 30 )
    
    row = row + 2
    
    self.nameLabel = Turbine.UI.Label()
    self.nameLabel:SetParent(self)
    self.nameLabel:SetPosition(             colum1_left, top + row * row_height )
    self.nameLabel:SetSize(                 colum1_widht, content_height )
    self.nameLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    self.nameLabel:SetFont(                 Defaults.Fonts.TabFont )
    self.nameLabel:SetText(                 L[Language.Local].Options.Name )
    Options.Constructor.Tooltip.AddTooltip(self.nameLabel, L[Language.Local].Tooltip.Text.GroupName)
    
        
    self.nameTextBox = Options.Constructor.TextBox(self, colum2_width)
    self.nameTextBox:SetPosition( colum2_left, top + row * row_height -5)
    self.nameTextBox:SetMultiline(        false)
   
    -- self.nameTextBox = Turbine.UI.Lotro.TextBox()
    -- self.nameTextBox:SetParent(self)
    -- self.nameTextBox:SetPosition(             colum2_left, top + row * row_height )
    -- self.nameTextBox:SetSize(                 colum2_width, content_height )
    -- self.nameTextBox:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
    -- self.nameTextBox:SetFont(                 Defaults.Fonts.TabFont )



    row = row + 1
    -------------------------------------------------------------------------------------
    -- type
    self.typeLabel = Turbine.UI.Label()
    self.typeLabel:SetParent(self)
    self.typeLabel:SetPosition(             colum1_left, top + row * row_height )
    self.typeLabel:SetSize(                 colum1_widht, content_height )
    self.typeLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    self.typeLabel:SetFont(                 Defaults.Fonts.TabFont )
    self.typeLabel:SetText(                 L[Language.Local].Options.Type )
    Options.Constructor.Tooltip.AddTooltip(self.typeLabel, L[Language.Local].Tooltip.Text.GroupType)
    

    
    self.typeTextBox = Options.Constructor.TextBox(self, colum2_width)
    self.typeTextBox:SetPosition( colum2_left, top + row * row_height -5)
    self.typeTextBox:SetMultiline(        false)

    -- self.typeTextBox = Turbine.UI.Lotro.TextBox()
    -- self.typeTextBox:SetParent(self)
    -- self.typeTextBox:SetPosition(             colum2_left, top + row * row_height )
    -- self.typeTextBox:SetSize(                 colum2_width, content_height )
    -- self.typeTextBox:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
    -- self.typeTextBox:SetFont(                 Defaults.Fonts.TabFont )
    -- self.typeTextBox:SetEnabled(false)
    
    row = row + 1
    
-------------------------------------------------------------------------------------
-- timerType
    self.timerTypeLabel = Turbine.UI.Label()
    self.timerTypeLabel:SetParent(self)
    self.timerTypeLabel:SetPosition(             colum1_left, top + row * row_height )
    self.timerTypeLabel:SetSize(                 colum1_widht, content_height )
    self.timerTypeLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    self.timerTypeLabel:SetFont(                 Defaults.Fonts.TabFont )
    self.timerTypeLabel:SetText(                 L[Language.Local].Options.TimerType )
    Options.Constructor.Tooltip.AddTooltip(self.timerTypeLabel, L[Language.Local].Tooltip.Text.TimerType)


    self.timerTypeDropdown = Options.Constructor.Dropdown( self, 80 )
    self.timerTypeDropdown:SetPosition( colum2_left, top + row * row_height - 5 )

    for i, value in pairs(Group.Defaults[Group.Types.LISTBOX].allowedTimers) do

        self.timerTypeDropdown:AddItem( L[Language.Local].Terms.TimerType[ value ], value )
        
    end

    row = row + 2
    -------------------------------------------------------------------------------------
    -- description
    self.descriptionLabel = Turbine.UI.Label()
    self.descriptionLabel:SetParent(self)
    self.descriptionLabel:SetPosition(             colum1_left, top + row * row_height )
    self.descriptionLabel:SetSize(                 colum1_widht, content_height )
    self.descriptionLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    self.descriptionLabel:SetFont(                 Defaults.Fonts.TabFont )
    self.descriptionLabel:SetText(                 L[Language.Local].Options.Description )
    Options.Constructor.Tooltip.AddTooltip(self.descriptionLabel, L[Language.Local].Tooltip.Text.Description)
    
    self.descriptionTextBox = Options.Constructor.TextBox(self, colum2_width, 100)
    self.descriptionTextBox:SetPosition( colum2_left, top + row * row_height -5)
    self.descriptionTextBox:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft)

    -- self.descriptionTextBox = Turbine.UI.Lotro.TextBox()
    -- self.descriptionTextBox:SetParent(self)
    -- self.descriptionTextBox:SetPosition(             colum2_left, top + row * row_height )
    -- self.descriptionTextBox:SetSize(                 colum2_width, 100 )
    -- self.descriptionTextBox:SetTextAlignment(        Turbine.UI.ContentAlignment.TopLeft )
    -- self.descriptionTextBox:SetFont(                 Defaults.Fonts.TabFont )
    
    row = row + 5
    




end

-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS GROUP TABWINDOW
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function GroupGeneralTab:FillContent( groupData, groupIndex, multiselect )

    if multiselect == true then
        
        self.nameLabel:SetVisible(false)
        self.nameTextBox:SetVisible(false)
        self.typeLabel:SetVisible(false)
        self.typeTextBox:SetVisible(false)
        self.descriptionLabel:SetVisible(false)
        self.descriptionTextBox:SetVisible(false)

        self.nameTextBox:SetText("")
        self.typeTextBox:SetText("")
        self.descriptionTextBox:SetText("")

    else

        self.nameLabel:SetVisible(true)
        self.nameTextBox:SetVisible(true)
        self.typeLabel:SetVisible(true)
        self.typeTextBox:SetVisible(true)
        self.descriptionLabel:SetVisible(true)
        self.descriptionTextBox:SetVisible(true)

        self.nameTextBox:SetText(groupData.name)
        self.typeTextBox:SetText(L[Language.Local].Terms.GroupTypes[groupData.type])
        self.timerTypeDropdown:SetSelection(groupData.timerType)
        self.descriptionTextBox:SetText(groupData.description)

    end

    self.globalyCheckBox:SetChecked(groupData.saveGlobaly)

end




