--=================================================================================================
--= Effect Self Options        
--= ===============================================================================================
--= effect self options control
--=================================================================================================



SkillOptions = class(Turbine.UI.Control)

Trigger[ Trigger.Types.Skill ].Options = function ( parent, data, parentType )

    return SkillOptions( parent, data, parentType )

end

---------------------------------------------------------------------------------------------------
function SkillOptions:Constructor( parent, data, parentType )
	Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.data = data

    local top = 0

    self.description = Options.Elements.TextBoxRow( Options.Defaults.window.backcolor1, "options", "description", "TODO", 50, true )
    self.description:SetParent( self )
    self.description:SetTop( top )
    
    top = top + 55

    self.token = Options.Elements.TextBoxRow( Options.Defaults.window.backcolor1, "options", "token", "TODO", 50, true )
    self.token:SetParent( self )
    self.token:SetTop( top )

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


    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function SkillOptions:ResetContent()

    self.description:SetText( self.data.description )
    self.token:SetText( self.data.token )
    self.action:SetSelection( self.data.action )
    self.value:SetText( self.data.value )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function SkillOptions:SizeChanged()

    self.description:SetWidth( self:GetWidth() )
    self.token:SetWidth( self:GetWidth() )
    self.action:SetWidth( self:GetWidth() )
    self.value:SetWidth( self:GetWidth() )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function SkillOptions:Save()

    self.data.description   = self.description:GetText(  )
    self.data.token         = self.token:GetText(  )
    self.data.action        = self.action:GetSelectedValue(  )
    self.data.value         = self.value:GetText(  )
    Trigger[Trigger.Types.Skill].Init()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function SkillOptions:Reset()

    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function SkillOptions:Close()


end
---------------------------------------------------------------------------------------------------
