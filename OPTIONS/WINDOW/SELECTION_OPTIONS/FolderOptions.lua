--=================================================================================================
--= folder options
--= ===============================================================================================
--= 
--=================================================================================================



Options.Elements.FolderOptions = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function Options.Elements.FolderOptions:Constructor( parent, data )
	Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.data   = data

    self.background1 = Turbine.UI.Control()
    self.background1:SetParent(self)
    self.background1:SetPosition( Options.Defaults.window.spacing, Options.Defaults.window.spacing )
    -- self.background1:SetHeight( self.height + 2*Options.Defaults.window.spacing )
    self.background1:SetBackColor( Options.Defaults.window.w_folder_base )
    -- self.background1:SetBackColor( Options.Defaults.window.basecolor )

    self.listbox = Options.Elements.TriggerListbox( self )
    self.listbox:SetParent( self.background1 )
    self.listbox:SetPosition( Options.Defaults.window.spacing, Options.Defaults.window.spacing )
    -- self.listbox:SetSize( 200, self.height )
    self.listbox:SetWidth( 200 )


    self.listbox:ContentChanged( self.data )
    self.triggerOptions = nil
    
    self:Trigger2SelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.FolderOptions:BuildCollectionRightClickMenu( data, menu )

    if self.triggerOptions == nil then
        return
    end

    self.triggerOptions:BuildCollectionRightClickMenu( data, menu )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.FolderOptions:TriggerClicked( index , type )

    Options.Trigger2SelectionChanged( index, type )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.FolderOptions:LanguageChanged()


end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.FolderOptions:Close()


end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.FolderOptions:SizeChanged()

    local width, height = self:GetSize()
    local content_height = height - 2*Options.Defaults.window.spacing

    self.background1:SetSize( width - 2*Options.Defaults.window.spacing, content_height )
    self.listbox:SetHeight( content_height - 2*Options.Defaults.window.spacing )

    if self.triggerOptions ~= nil then
        self.triggerOptions:SetWidth( width - 200 - (5*Options.Defaults.window.spacing) )
        self.triggerOptions:SetHeight( self.listbox:GetHeight() )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.FolderOptions:Save()

    if self.triggerOptions == nil  then
        return
    end

    self.triggerOptions:Save()
    self.listbox:UpdateData()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.FolderOptions:Reset()

    if self.triggerOptions == nil  then
        return
    end

    self.triggerOptions:Reset()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.FolderOptions:Trigger2SelectionChanged()

    self.listbox:Trigger2SelectionChanged()

    -- close old
    if self.triggerOptions ~= nil then
        self.triggerOptions:Close()
        self.triggerOptions:SetParent()
        self.triggerOptions = nil
    end

    if Data.selectedTriggerIndex2 ~= 0 then
        local triggerData = self.data[ Data.selectedTriggerType2 ][ Data.selectedTriggerIndex2 ]

        self.triggerOptions = Trigger[ Data.selectedTriggerType2 ].Options( self, triggerData, 0 )
        self.triggerOptions:SetParent( self.background1 )
        self.triggerOptions:SetPosition( 200 + (2*Options.Defaults.window.spacing), Options.Defaults.window.spacing )
        self.triggerOptions:SetHeight( self.listbox:GetHeight() )

        self:SizeChanged()
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.FolderOptions:TimerSelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.FolderOptions:TriggerSelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.FolderOptions:DeleteTrigger( triggerIndex, triggerType )

    Options.DeleteTrigger2( self.data, triggerIndex, triggerType )
    self.listbox:ContentChanged( self.data )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.FolderOptions:CopyTrigger( triggerData )

    local trigger = Trigger.Copy( triggerData )
    local index = #self.data[ triggerData.type ] + 1

    self.data[ triggerData.type ][ index ] = trigger
    self.listbox:ContentChanged( self.data )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.FolderOptions:TriggerSelected( index, type )

    Options.Trigger2SelectionChanged( index, type )

end
---------------------------------------------------------------------------------------------------
