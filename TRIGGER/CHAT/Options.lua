--=================================================================================================
--= Effect Self Options        
--= ===============================================================================================
--= effect self options control
--=================================================================================================



ChatOptions = class(Turbine.UI.Control)

Trigger[ Trigger.Types.Chat ].Options = function ( parent, data, parentType )

    return ChatOptions( parent, data, parentType )

end

---------------------------------------------------------------------------------------------------
function ChatOptions:Constructor( parent, data, parentType )
	Turbine.UI.Control.Constructor( self )

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
        -- self.action:AddItem( "action", Action.Enable, Action.Enable)
        -- self.action:AddItem( "action", Action.Disable, Action.Disable)

    end

    top = top + 35

    self.value = Options.Elements.NumberBoxRow( Options.Defaults.window.backcolor1, "options", "value", "trg_value", 30 )
    if (parentType *(-1)) == Timer.Types.COUNTER_BAR then
        self.value:SetParent( self )
        self.value:SetTop( top )

        top = top + 35
    end

    self.source = Options.Elements.DropDownRow( Options.Defaults.window.backcolor1, "options", "source_chat", "trg_source_chat", 30 )
    self.source:SetParent( self )
    self.source:SetTop( top )

    self.source:AddItem( "source", "Any", Source.Any)

    for name, value in pairs(ChatChannel) do
        self.source:AddItem( "source", name, value)
    end
    self.source:Sort()
    top = top + 35

    self.listOfTargets = Options.Elements.TextBoxRow( Options.Defaults.window.backcolor1, "options", "listOfTargets", "trg_list_of_targets", 50, true )
    self.listOfTargets:SetParent( self )
    self.listOfTargets:SetTop( top )

    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ChatOptions:ResetContent()

    self.description:SetText( self.data.description )
    self.token:SetText( self.data.token )
    self.action:SetSelection( self.data.action )
    self.value:SetText( self.data.value )
    self.source:SetSelection( self.data.source )
    self.listOfTargets:SetText( UTILS.ListOfTargetsToString( self.data.listOfTargets ) )
    
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ChatOptions:SizeChanged()

    self.description:SetWidth( self:GetWidth() )
    self.token:SetWidth( self:GetWidth() )
    self.action:SetWidth( self:GetWidth() )
    self.value:SetWidth( self:GetWidth() )
    self.source:SetWidth( self:GetWidth() )
    self.listOfTargets:SetWidth( self:GetWidth() )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ChatOptions:LanguageChanged()

    self.description:LanguageChanged()
    self.token:LanguageChanged()
    self.action:LanguageChanged()
    self.value:LanguageChanged()
    self.source:LanguageChanged()
    self.listOfTargets:LanguageChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ChatOptions:Save()

    self.data.description   = self.description:GetText(  )
    self.data.token         = self.token:GetText(  )
    self.data.action        = self.action:GetSelectedValue(  )
    self.data.value         = self.value:GetText(  )
    self.data.source        = self.source:GetSelectedValue()
    local text              = self.listOfTargets:GetText()
    self.data.listOfTargets = UTILS.StringOfTargetsToList( text )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ChatOptions:Reset()

    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ChatOptions:Close()

    self.action:Close()
    self.source:Close()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ChatOptions:BuildCollectionRightClickMenu( data, menu )

	local row1 =  Options.Elements.Row(
		"collection",
		"token",
		function ()
			self.token:SetText( data.token )
		end,
		Options.Defaults.rc_menu.item_height
	)
	menu:AddRow( row1 )

    if data.source ~= nil then
        local row2 =  Options.Elements.Row(
            "collection",
            "source",
            function ()
                self.source:SetSelection( data.source )
            end,
            Options.Defaults.rc_menu.item_height
        )
        menu:AddRow( row2 )
    end

end
---------------------------------------------------------------------------------------------------
