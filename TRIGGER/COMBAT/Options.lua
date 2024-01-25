--=================================================================================================
--= Effect Self Options        
--= ===============================================================================================
--= effect self options control
--=================================================================================================



CombatOptions = class(Turbine.UI.Control)

Trigger[ Trigger.Types.Combat ].Options = function ( parent, data, parentType )

    return CombatOptions( parent, data, parentType )

end

---------------------------------------------------------------------------------------------------
function CombatOptions:Constructor( parent, data, parentType )
	Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.data = data

    local top = 0

    self.description = Options.Elements.TextBoxRow( Options.Defaults.window.backcolor1, "options", "description", "TODO", 50, true )
    self.description:SetParent( self )
    self.description:SetTop( top )
    
    top = top + 55

    self.action = Options.Elements.DropDownRow( Options.Defaults.window.backcolor1, "options", "action", "TODO", 30 )
    self.action:SetParent( self )
    self.action:SetTop( top )

    -- folder
    if parentType == 0 then
        self.action:AddItem( "action", Action.Enable, Action.Enable)
        self.action:AddItem( "action", Action.Disable, Action.Disable)
        self.action:AddItem( "action", Action.Reset, Action.Reset)

    -- window
    elseif parentType > 0 then
        self.action:AddItem( "action", Action.Enable, Action.Enable)
        self.action:AddItem( "action", Action.Disable, Action.Disable)
        self.action:AddItem( "action", Action.Clear, Action.Clear)
        self.action:AddItem( "action", Action.Reset, Action.Reset)
    
    -- timer
    elseif parentType < 0 then
        self.action:AddItem( "action", Action.Add, Action.Add)

        if (parentType *(-1)) == Timer.Types.COUNTER_BAR then
            self.action:AddItem( "action", Action.Subtract, Action.Subtract)
        end
        
        self.action:AddItem( "action", Action.Remove, Action.Remove)
        self.action:AddItem( "action", Action.Enable, Action.Enable)
        self.action:AddItem( "action", Action.Disable, Action.Disable)

    end

    top = top + 35
    
    self.value = Options.Elements.NumberBoxRow( Options.Defaults.window.backcolor1, "options", "value", "TODO", 30 )
    if (parentType *(-1)) == Timer.Types.COUNTER_BAR then
        self.value:SetParent( self )
        self.value:SetTop( top )

        top = top + 35
    end

    self.source = Options.Elements.DropDownRow( Options.Defaults.window.backcolor1, "options", "source", "TODO", 30 )
    self.source:SetParent( self )
    self.source:SetTop( top )

    self.source:AddItem( "source", "Any", Source.Any)
    self.source:AddItem( "source", "CombatStart", Source.CombatStart)
    self.source:AddItem( "source", "CombatEnd", Source.CombatEnd)


    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function CombatOptions:ResetContent()

    self.description:SetText( self.data.description )
    self.action:SetSelection( self.data.action )
    self.value:SetText( self.data.value )
    self.source:SetSelection( self.data.source )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function CombatOptions:SizeChanged()

    self.description:SetWidth( self:GetWidth() )
    self.action:SetWidth( self:GetWidth() )
    self.value:SetWidth( self:GetWidth() )
    self.source:SetWidth( self:GetWidth() )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function CombatOptions:Save()

    self.data.description   = self.description:GetText(  )
    self.data.action        = self.action:GetSelectedValue(  )
    self.data.value         = self.value:GetText(  )
    self.data.source        = self.source:GetSelectedValue(  )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function CombatOptions:Reset()

    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function CombatOptions:Close()

    self.action:Close()
    self.source:Close()

end
---------------------------------------------------------------------------------------------------
