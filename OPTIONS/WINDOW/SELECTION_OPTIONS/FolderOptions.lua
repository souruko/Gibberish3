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

    self.height = 300

    self.background1 = Turbine.UI.Control()
    self.background1:SetParent(self)
    self.background1:SetPosition( Options.Defaults.window.spacing, Options.Defaults.window.spacing )
    self.background1:SetHeight( self.height + 2*Options.Defaults.window.spacing )
    self.background1:SetBackColor( Options.Defaults.window.basecolor )

    self.listbox = Options.Elements.TriggerListbox()
    self.listbox:SetParent( self.background1 )
    self.listbox:SetPosition( Options.Defaults.window.spacing, Options.Defaults.window.spacing )
    self.listbox:SetSize( 200, self.height )


    self.listbox:ContentChanged( self.data )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.FolderOptions:Close()


end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.FolderOptions:SizeChanged()

    local width, height = self:GetSize()

    self.background1:SetWidth( width - 2*Options.Defaults.window.spacing )

    if self.triggerOptions ~= nil then
        self.triggerOptions:SetWidth( width - 200 - (5*Options.Defaults.window.spacing) )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.FolderOptions:Save()

    if self.triggerOptions == nil  then
        return
    end

    self.triggerOptions:Save()
    self.listbox:ReloadNames()

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
function Options.Elements.FolderOptions:TriggerSelectionChanged()

    self.listbox:TriggerSelectionChanged()

    -- close old
    if self.triggerOptions ~= nil then
        self.triggerOptions:Close()
        self.triggerOptions:SetParent()
        self.triggerOptions = nil
    end

    if Data.selectedTriggerIndex ~= 0 then
        local triggerData = self.data[ Data.selectedTriggerType ][ Data.selectedTriggerIndex ]

        self.triggerOptions = Trigger[ Data.selectedTriggerType ].Options( self, triggerData, 0 )
        self.triggerOptions:SetParent( self.background1 )
        self.triggerOptions:SetPosition( 200 + (2*Options.Defaults.window.spacing), Options.Defaults.window.spacing )
        self.triggerOptions:SetHeight( self.height )

        self:SizeChanged()
    end

end
---------------------------------------------------------------------------------------------------
