--=================================================================================================
--= Dropdown ConditionsOptions
--= ===============================================================================================
--= 
--=================================================================================================



ConditionsOptions = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function ConditionsOptions:Constructor( data )
	Turbine.UI.Control.Constructor( self )

    self.data = data

    self:SetVisible( false )

    local left = Options.Defaults.window.tab_c_left
    local top = Options.Defaults.window.tab_c_top

    self.background1 = Turbine.UI.Control()
    self.background1:SetParent(self)
    self.background1:SetPosition( Options.Defaults.window.tab_c_left, Options.Defaults.window.tab_c_top )
    -- self.background1:SetHeight( self.height + 2*Options.Defaults.window.spacing )
    self.background1:SetBackColor( Options.Defaults.window.basecolor )

    self.listbox = Options.Elements.TriggerListbox( self )
    self.listbox:SetParent( self.background1 )
    self.listbox:SetPosition( Options.Defaults.window.spacing, Options.Defaults.window.spacing )
    -- self.listbox:SetSize( 200, self.height )
    self.listbox:SetWidth( 200 )

    self.listbox:ContentChanged( self.data )
    self.conditionOptions = nil

    self:TriggerSelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionsOptions:ConditionsClicked( index , type )

    Options.TriggerSelectionChanged( index, type )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionsOptions:SizeChanged()

    local width, height = self:GetSize()
    local content_height = height - Options.Defaults.window.tab_c_top - Options.Defaults.window.spacing

    self.background1:SetSize( width - 2*Options.Defaults.window.spacing, content_height )
    self.listbox:SetHeight( content_height - 2*Options.Defaults.window.spacing )

    if self.conditionOptions ~= nil then
        self.conditionOptions:SetWidth( width - 200 - (5*Options.Defaults.window.spacing) )
        self.conditionOptions:SetHeight( self.listbox:GetHeight() )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionsOptions:Save()

    if self.conditionOptions == nil  then
        return
    end

    self.conditionOptions:Save()
    self.listbox:UpdateData()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionsOptions:Reset()

    if self.conditionOptions == nil  then
        return
    end

    self.conditionOptions:Reset()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionsOptions:LanguageChanged()

    if self.conditionOptions == nil  then
        return
    end

    self.conditionOptions:LanguageChanged()

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
function ConditionsOptions:TriggerSelectionChanged()

    self.listbox:TriggerSelectionChanged()

    -- close old
    if self.conditionOptions ~= nil then
        self.conditionOptions:Close()
        self.conditionOptions:SetParent()
        self.conditionOptions = nil
    end

    if Data.selectedConditionsIndex ~= 0 then
        local triggerData = self.data[ Data.selectedTriggerType ][ Data.selectedTriggerIndex ]

        self.conditionOptions = Trigger[ Data.selectedTriggerType ].Options( self, triggerData, -1 )
        self.conditionOptions:SetParent( self.background1 )
        self.conditionOptions:SetPosition( 200 + (2*Options.Defaults.window.spacing), Options.Defaults.window.spacing )

        self:SizeChanged()
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionsOptions:DeleteConditions( triggerIndex, triggerType )

    Options.DeleteConditions( self.data, triggerIndex, triggerType )
    Options.SaveData()
    self.listbox:ContentChanged( self.data )
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionsOptions:CopyConditions( triggerData )

    local trigger = Trigger.Copy( triggerData )
    local index = #self.data[ triggerData.type ] + 1

    self.data[ triggerData.type ][ index ] = trigger
    self.listbox:ContentChanged( self.data )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionsOptions:BuildCollectionRightClickMenu( data, menu )

    if self.conditionOptions == nil then
        return
    end

    menu:AddSeperator()

    self.conditionOptions:BuildCollectionRightClickMenu( data, menu )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionsOptions:ConditionsSelected( index, type )

    Options.TriggerSelectionChanged( index, type )

end
---------------------------------------------------------------------------------------------------
