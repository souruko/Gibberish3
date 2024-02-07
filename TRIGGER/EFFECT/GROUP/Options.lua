--=================================================================================================
--= Effect Self Options        
--= ===============================================================================================
--= effect self options control
--=================================================================================================



EffectGroupOptions = class(Turbine.UI.Control)

Trigger[ Trigger.Types.EffectGroup ].Options = function ( parent, data, parentType )

    return EffectGroupOptions( parent, data, parentType )

end

---------------------------------------------------------------------------------------------------
function EffectGroupOptions:Constructor( parent, data, parentType )
	Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.data = data

    local top = 0

    self.description = Options.Elements.TextBoxRow( Options.Defaults.window.backcolor1, "options", "description", "trg_description", 50, true )
    self.description:SetParent( self )
    self.description:SetTop( top )
    
    top = top + 55

    self.token = Options.Elements.TextBoxRow( Options.Defaults.window.backcolor1, "options", "token", "trg_token", 90, true )
    self.token:SetParent( self )
    self.token:SetTop( top )

    top = top + 95

    self.useRegex = Options.Elements.CheckBoxRow( Options.Defaults.window.backcolor1, "options", "useRegex", "trg_use_regex", 30 )
    self.useRegex:SetParent( self )
    self.useRegex:SetTop( top )

    top = top + 35

    self.icon = Options.Elements.IconBoxRow( Options.Defaults.window.backcolor1, "options", "icon", "tim_icon", 42 )
    self.icon:SetParent( self )
    self.icon:SetTop( top )

    top = top + 47

    self.action = Options.Elements.DropDownRow( Options.Defaults.window.backcolor1, "options", "action", "trg_action", 30 )
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
    
    self.value = Options.Elements.NumberBoxRow( Options.Defaults.window.backcolor1, "options", "value", "trg_value", 30 )
    if (parentType *(-1)) == Timer.Types.COUNTER_BAR then
        self.value:SetParent( self )
        self.value:SetTop( top )

        top = top + 35
    end

    self.listOfTargets = Options.Elements.TextBoxRow( Options.Defaults.window.backcolor1, "options", "listOfTargets", "trg_list_of_targets", 50, true )
    self.listOfTargets:SetParent( self )
    self.listOfTargets:SetTop( top )

    top = top + 55

    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function EffectGroupOptions:ResetContent()

    self.description:SetText( self.data.description )
    self.token:SetText( self.data.token )
    self.useRegex:SetChecked( self.data.useRegex )
    self.action:SetSelection( self.data.action )
    self.value:SetText( self.data.listOfTargets )
    self.icon:SetText( self.data.icon )
    -- self.listOfTargets:SetText( self.data.value )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function EffectGroupOptions:SizeChanged()

    self.description:SetWidth( self:GetWidth() )
    self.token:SetWidth( self:GetWidth() )
    self.action:SetWidth( self:GetWidth() )
    self.value:SetWidth( self:GetWidth() )
    self.useRegex:SetWidth( self:GetWidth() )
    self.listOfTargets:SetWidth( self:GetWidth() )
    self.icon:SetWidth( self:GetWidth() )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function EffectGroupOptions:Save()

    self.data.description   = self.description:GetText(  )
    self.data.token         = self.token:GetText(  )
    self.data.icon         = self.icon:GetText(  )
    self.data.useRegex      = self.useRegex:IsChecked(  )
    self.data.action        = self.action:GetSelectedValue(  )
    self.data.value         = self.value:GetText(  )
    -- self.data.listOfTargets         = self.listOfTargets:GetText(  )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function EffectGroupOptions:Reset()

    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function EffectGroupOptions:Close()


end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function EffectGroupOptions:BuildCollectionRightClickMenu( data, menu )

	local row1 =  Options.Elements.Row(
		"collection",
		"token",
		function ()
			self.token:SetText( data.token )
		end,
		Options.Defaults.rc_menu.item_height
	)
	menu:AddRow( row1 )

    if data.icon ~= nil then
        local row2 =  Options.Elements.Row(
            "collection",
            "icon",
            function ()
                self.icon:SetText( data.icon )
            end,
            Options.Defaults.rc_menu.item_height
        )
        menu:AddRow( row2 )
    end

end
---------------------------------------------------------------------------------------------------
