--===================================================================================
--             Name:    LISTBOX OPTIONS Timer GeneralTabs
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================


TimerGeneralTab = class(  Options.Constructor.Tab )

-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS Timer TABWINDOW
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
-------------------------------------------------------------------------------------
--           Return:    Timer listbox element
-------------------------------------------------------------------------------------
function TimerGeneralTab:Constructor( width, name, tabwindow )
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
    -- permanent
    self.permanentLabel = Turbine.UI.Label()
    self.permanentLabel:SetParent(self)
    self.permanentLabel:SetPosition(             colum1_left, top + row * row_height  )
    self.permanentLabel:SetSize(                 colum1_widht, content_height )
    self.permanentLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    self.permanentLabel:SetFont(                 Defaults.Fonts.TabFont )
    self.permanentLabel:SetText(                 L[Language.Local].Options.Permanent )
    Options.Constructor.Tooltip.AddTooltip(self.permanentLabel, L[Language.Local].Tooltip.Text.Permanent)
    
    self.permanentCheckBox = Options.Constructor.CheckBox()
    self.permanentCheckBox:SetParent(self)
    self.permanentCheckBox:SetPosition(             colum2_left + 10, top + row * row_height - checkBoxFix )
    self.permanentCheckBox:SetSize(                 30, 30 )
    
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
function TimerGeneralTab:FillContent( timerData, timerIndex, multiselect )

    if timerData == nil then
    
        self.permanentCheckBox:SetChecked(false)
        self.descriptionTextBox:SetText("")

    else

        self.permanentCheckBox:SetChecked(timerData.permanent)
        self.descriptionTextBox:SetText(timerData.description)
    
    end

end







