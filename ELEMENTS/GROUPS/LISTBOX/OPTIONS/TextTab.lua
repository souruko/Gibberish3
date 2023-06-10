--===================================================================================
--             Name:    LISTBOX OPTIONS Group TextTabs
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================


GroupTextTab = class(  Options.Constructor.Tab )

-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS GROUP TABWINDOW
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function GroupTextTab:Constructor( width, name, tabwindow )
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
-- font
self.fontLabel = Turbine.UI.Label()
self.fontLabel:SetParent(self)
self.fontLabel:SetPosition(             colum1_left, top + row * row_height )
self.fontLabel:SetSize(                 colum1_widht, content_height )
self.fontLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
self.fontLabel:SetFont(                 Defaults.Fonts.TabFont )
self.fontLabel:SetText(                 L[Language.Local].Options.Font )
Options.Constructor.Tooltip.AddTooltip(self.fontLabel, L[Language.Local].Tooltip.Text.Font)


self.fontDropdown = Options.Constructor.Dropdown( self, 140 )
self.fontDropdown:SetPosition( colum2_left + 10, top + row * row_height - 5 )

for name, value in pairs(Font.Type) do

    self.fontDropdown:AddItem( name, value )
    
end

self.fontSizeDropdown = Options.Constructor.Dropdown( self, 50 )
self.fontSizeDropdown:SetPosition( colum2_left + 160, top + row * row_height -5 )

self.fontDropdown.SelectionChanged = function(sender, index, value)

    if sender == self.fontDropdown then

        self.fontSizeDropdown:ClearItems()

        local fonttype = self.fontDropdown:GetSelectionValue()

        if fonttype ~= nil then

            for size, turbinefont in pairs(Font[fonttype]) do

                self.fontSizeDropdown:AddItem( size, size )
    
            end

            self.fontSizeDropdown:SetSelection(1)

        end
  
    end
    
end

row = row + 2


-------------------------------------------------------------------------------------
-- timer format
self.timerFormatLabel = Turbine.UI.Label()
self.timerFormatLabel:SetParent(self)
self.timerFormatLabel:SetPosition(             colum1_left, top + row * row_height )
self.timerFormatLabel:SetSize(                 colum1_widht, content_height )
self.timerFormatLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
self.timerFormatLabel:SetFont(                 Defaults.Fonts.TabFont )
self.timerFormatLabel:SetText(                 L[Language.Local].Options.DurationFormat )
Options.Constructor.Tooltip.AddTooltip(self.timerFormatLabel, L[Language.Local].Tooltip.Text.DurationFormat)


self.numberDropdown = Options.Constructor.Dropdown( self, 140 )
self.numberDropdown:SetPosition( colum2_left + 10, top + row * row_height - 5 )

for name, value in pairs(NumberFormat) do

    self.numberDropdown:AddItem( name, value )
    
end


row = row + 2


-------------------------------------------------------------------------------------
-- timer format
self.textAlignmentLabel = Turbine.UI.Label()
self.textAlignmentLabel:SetParent(self)
self.textAlignmentLabel:SetPosition(             colum1_left, top + row * row_height )
self.textAlignmentLabel:SetSize(                 colum1_widht, content_height )
self.textAlignmentLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
self.textAlignmentLabel:SetFont(                 Defaults.Fonts.TabFont )
self.textAlignmentLabel:SetText(                 L[Language.Local].Options.TextAlignment )
Options.Constructor.Tooltip.AddTooltip(self.textAlignmentLabel, L[Language.Local].Tooltip.Text.TextAlignment)

self.textAlignmentDropdown = Options.Constructor.Dropdown( self, 140 )
self.textAlignmentDropdown:SetPosition( colum2_left + 10, top + row * row_height - 5 )

for name, value in pairs(Turbine.UI.ContentAlignment) do

    if name ~= "Undefined" and name ~= "IsA" then
        self.textAlignmentDropdown:AddItem( name, value )
    end
    
end


row = row + 1


-------------------------------------------------------------------------------------
-- timer format
self.timerAlignmentLabel = Turbine.UI.Label()
self.timerAlignmentLabel:SetParent(self)
self.timerAlignmentLabel:SetPosition(             colum1_left, top + row * row_height )
self.timerAlignmentLabel:SetSize(                 colum1_widht, content_height )
self.timerAlignmentLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
self.timerAlignmentLabel:SetFont(                 Defaults.Fonts.TabFont )
self.timerAlignmentLabel:SetText(                 L[Language.Local].Options.TimerAlignment )
Options.Constructor.Tooltip.AddTooltip(self.timerAlignmentLabel, L[Language.Local].Tooltip.Text.TimerAlignment)


self.timerAlignmentDropdown = Options.Constructor.Dropdown( self, 140 )
self.timerAlignmentDropdown:SetPosition( colum2_left + 10, top + row * row_height - 5 )

for name, value in pairs(Turbine.UI.ContentAlignment) do

    if name ~= "Undefined" and name ~= "IsA" then
        self.timerAlignmentDropdown:AddItem( name, value )
    end
    
end


row = row + 2


-------------------------------------------------------------------------------------
-- timer format
self.showTimerLabel = Turbine.UI.Label()
self.showTimerLabel:SetParent(self)
self.showTimerLabel:SetPosition(             colum1_left, top + row * row_height )
self.showTimerLabel:SetSize(                 colum1_widht, content_height )
self.showTimerLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
self.showTimerLabel:SetFont(                 Defaults.Fonts.TabFont )
self.showTimerLabel:SetText(                 L[Language.Local].Options.ShowTimer )
Options.Constructor.Tooltip.AddTooltip(self.showTimerLabel, L[Language.Local].Tooltip.Text.ShowTimer)


self.showTimerCheckBox = Options.Constructor.CheckBox()
self.showTimerCheckBox:SetParent(self)
self.showTimerCheckBox:SetPosition(             colum2_left + 10, top + row * row_height - checkBoxFix )
self.showTimerCheckBox:SetSize(                 30, 30 )


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
function GroupTextTab:FillContent( groupData, groupIndex, multiselect )

    self.fontDropdown:SetSelection(groupData.font)
    self.fontSizeDropdown:SetSelection(groupData.fontSize)

    self.numberDropdown:SetSelection(groupData.durationFormat)
    
    self.textAlignmentDropdown:SetSelection(groupData.textAlignment)
    self.timerAlignmentDropdown:SetSelection(groupData.timerAlignment)

    self.showTimerCheckBox:SetChecked(groupData.ShowTimer)

end






-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function GroupTextTab:Finish()

    self.fontDropdown:Finish()
    self.fontSizeDropdown:Finish()
    self.numberDropdown:Finish()
    self.textAlignmentDropdown:Finish()
    self.timerAlignmentDropdown:Finish()

end

