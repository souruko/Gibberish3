--=================================================================================================
--= ConditionsOptions
--= ===============================================================================================
--= Two-panel layout: condition list on the left, condition editor on the right.
--=================================================================================================



ConditionsOptions = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function ConditionsOptions:Constructor( data )
    Turbine.UI.Control.Constructor( self )

    self.data = data

    self:SetVisible( false )

    local sp = Options.Defaults.window.spacing

    -- main content background
    self.background1 = Turbine.UI.Control()
    self.background1:SetParent( self )
    self.background1:SetPosition( Options.Defaults.window.tab_c_left, Options.Defaults.window.tab_c_top )
    self.background1:SetBackColor( Options.Defaults.window.basecolor )

    -- top: full-width condition listbox
    self.COND_LISTBOX_HEIGHT = 100

    self.conditionListbox = Options.Elements.ConditionListbox( self )
    self.conditionListbox:SetParent( self.background1 )
    self.conditionListbox:SetPosition( sp, sp )
    -- width set in SizeChanged

    -- below: edit panel for selected condition
    self.editPanel = Turbine.UI.Control()
    self.editPanel:SetParent( self.background1 )
    self.editPanel:SetVisible( false )

    local ep_top = 0

    self.condDescription = Options.Elements.TextBoxRow(
        Options.Defaults.window.basecolor, "options", "description", "cond_description", 50, true )
    self.condDescription:SetParent( self.editPanel )
    self.condDescription:SetPosition( 0, ep_top )
    ep_top = ep_top + 55

    self.condEnabled = Options.Elements.CheckBoxRow(
        Options.Defaults.window.basecolor, "options", "enabled", "cond_enabled", 30 )
    self.condEnabled:SetParent( self.editPanel )
    self.condEnabled:SetPosition( 0, ep_top )
    ep_top = ep_top + 35

    self.condDuration = Options.Elements.NumberBoxRow(
        Options.Defaults.window.basecolor, "options", "duration", "cond_duration", 30 )
    self.condDuration:SetParent( self.editPanel )
    self.condDuration:SetPosition( 0, ep_top )
    ep_top = ep_top + 35

    -- trigger listbox: full editPanel width, fixed height; trigger options appear below it
    self.triggerRow_top  = ep_top
    self.LISTBOX_HEIGHT  = 100

    self.condTriggerListbox = Options.Elements.ConditionTriggerListbox( self )
    self.condTriggerListbox:SetParent( self.editPanel )
    self.condTriggerListbox:SetPosition( 0, ep_top )
    self.condTriggerListbox:SetHeight( self.LISTBOX_HEIGHT )

    self.condTriggerOptions = nil

    self.conditionListbox:ContentChanged( self.data )

    self:TriggerSelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- called by conditionListbox when a condition row is clicked
---------------------------------------------------------------------------------------------------
function ConditionsOptions:ConditionClicked( index )
    Options.ConditionsSelectionChanged( index )
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- called by condTriggerListbox when a trigger row is clicked
---------------------------------------------------------------------------------------------------
function ConditionsOptions:TriggerClicked( index, type )
    Options.ConditionTriggerSelectionChanged( index, type )
end

function ConditionsOptions:TriggerSelected( index, type )
    Options.ConditionTriggerSelectionChanged( index, type )
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionsOptions:DeleteTrigger( triggerIndex, triggerType )

    local conditionData = self.data.conditionList[ Data.selectedConditionsIndex ]
    if conditionData == nil then return end

    Trigger.Delete( conditionData, triggerIndex, triggerType )

    if Data.selectedConditionTriggerType == triggerType and
       Data.selectedConditionTriggerIndex >= triggerIndex then
        Options.ConditionTriggerSelectionChanged( 0, 0 )
    end

    Options.SaveData()
    self.condTriggerListbox:ContentChanged( conditionData )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionsOptions:CopyTrigger( triggerData )

    local conditionData = self.data.conditionList[ Data.selectedConditionsIndex ]
    if conditionData == nil then return end

    local trigger = Trigger.Copy( triggerData )
    trigger.sortIndex = self.condTriggerListbox:GetNextSortIndex()
    local index = #conditionData[ triggerData.type ] + 1
    conditionData[ triggerData.type ][ index ] = trigger
    self.condTriggerListbox:ContentChanged( conditionData )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionsOptions:DraggingEnd( triggerData )
    self.condTriggerListbox:DraggingEnd( triggerData )
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionsOptions:DeleteCondition( conditionIndex )
    Options.DeleteConditions( self.data, conditionIndex )
    Options.SaveData()
    self.conditionListbox:ContentChanged( self.data )
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionsOptions:CopyCondition( conditionData )
    local copy = Condition.Copy( conditionData )
    local index = #self.data.conditionList + 1
    self.data.conditionList[index] = copy
    Options.SaveData()
    self.conditionListbox:ContentChanged( self.data )
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionsOptions:SizeChanged()

    local width, height = self:GetSize()
    local sp = Options.Defaults.window.spacing
    local content_height = height - Options.Defaults.window.tab_c_top - sp

    self.background1:SetSize( width - 2*sp, content_height )

    local inner_width = width - 4*sp

    -- condition listbox: full width across the top
    self.conditionListbox:SetSize( inner_width, self.COND_LISTBOX_HEIGHT )

    -- edit panel: below the condition listbox
    local ep_top    = self.COND_LISTBOX_HEIGHT + 2*sp
    local ep_height = content_height - ep_top - sp

    self.editPanel:SetPosition( 0, ep_top )
    self.editPanel:SetSize( inner_width, ep_height )

    local row_width = inner_width - sp
    self.condDescription:SetWidth( row_width )
    self.condEnabled:SetWidth( row_width )
    self.condDuration:SetWidth( row_width )

    self.condTriggerListbox:SetWidth( row_width )

    local trigger_opts_top    = self.triggerRow_top + self.LISTBOX_HEIGHT + sp
    local trigger_opts_height = ep_height - trigger_opts_top - sp

    if self.condTriggerOptions ~= nil then
        self.condTriggerOptions:SetPosition( 0, trigger_opts_top )
        self.condTriggerOptions:SetSize( row_width, trigger_opts_height )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionsOptions:Save()

    local conditionData = self.data.conditionList[ Data.selectedConditionsIndex ]
    if conditionData == nil then return end

    conditionData.description = self.condDescription:GetText()
    conditionData.enabled     = self.condEnabled:IsChecked()
    conditionData.duration    = tonumber( self.condDuration:GetText() ) or conditionData.duration

    if self.condTriggerOptions ~= nil then
        self.condTriggerOptions:Save()
    end

    self.conditionListbox:UpdateData()
    self.condTriggerListbox:UpdateData()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionsOptions:Reset()

    local conditionData = self.data.conditionList[ Data.selectedConditionsIndex ]
    if conditionData == nil then return end

    self.condDescription:SetText( conditionData.description )
    self.condEnabled:SetChecked( conditionData.enabled )
    self.condDuration:SetText( tostring( conditionData.duration ) )

    if self.condTriggerOptions ~= nil then
        self.condTriggerOptions:Reset()
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionsOptions:LanguageChanged()

    self.condDescription:LanguageChanged()
    self.condEnabled:LanguageChanged()
    self.condDuration:LanguageChanged()

    if self.condTriggerOptions ~= nil then
        self.condTriggerOptions:LanguageChanged()
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionsOptions:Show()
    self:SetVisible( true )
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionsOptions:Hide()
    self:SetVisible( false )
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- called when condition selection OR condition trigger selection changes
---------------------------------------------------------------------------------------------------
function ConditionsOptions:TriggerSelectionChanged()

    -- update left panel highlight
    self.conditionListbox:ConditionsSelectionChanged()

    -- close any open trigger options sub-panel
    if self.condTriggerOptions ~= nil then
        self.condTriggerOptions:Close()
        self.condTriggerOptions:SetParent()
        self.condTriggerOptions = nil
    end

    -- no condition selected: hide right panel
    if Data.selectedConditionsIndex == 0 then
        self.editPanel:SetVisible( false )
        return
    end

    local conditionData = self.data.conditionList[ Data.selectedConditionsIndex ]
    if conditionData == nil then
        Options.ConditionsSelectionChanged( 0 )
        return
    end

    -- show right panel with this condition's data
    self.editPanel:SetVisible( true )
    self.condDescription:SetText( conditionData.description )
    self.condEnabled:SetChecked( conditionData.enabled )
    self.condDuration:SetText( tostring( conditionData.duration ) )

    self.condTriggerListbox:ContentChanged( conditionData )

    -- open trigger options sub-panel if a condition trigger is selected
    if Data.selectedConditionTriggerIndex ~= 0 then

        local triggerData = conditionData[ Data.selectedConditionTriggerType ]
        if triggerData ~= nil then
            triggerData = triggerData[ Data.selectedConditionTriggerIndex ]
        end

        if triggerData == nil then
            Options.ConditionTriggerSelectionChanged( 0, 0 )
            return
        end

        self.condTriggerOptions = Trigger[ Data.selectedConditionTriggerType ].Options( self, triggerData, -1 )
        self.condTriggerOptions:SetParent( self.editPanel )

        self:SizeChanged()

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionsOptions:BuildCollectionRightClickMenu( data, menu )

    if self.condTriggerOptions == nil then return end

    self.condTriggerOptions:BuildCollectionRightClickMenu( data, menu )

end
---------------------------------------------------------------------------------------------------
