--=================================================================================================
--= Effect Self Options        
--= ===============================================================================================
--= effect self options control
--=================================================================================================



TimerOptions = class(Turbine.UI.Control)

Trigger[ Trigger.Types.TimerEnd ].Options = function ( parent, data, parentType )

    return TimerOptions( parent, data, parentType )

end

Trigger[ Trigger.Types.TimerStart ].Options = function ( parent, data, parentType )

    return TimerOptions( parent, data, parentType )

end

Trigger[ Trigger.Types.TimerThreshold ].Options = function ( parent, data, parentType )

    return TimerOptions( parent, data, parentType )

end

---------------------------------------------------------------------------------------------------
function TimerOptions:Constructor( parent, data, parentType )
	Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.data = data

    local top = 0

    self.description = Options.Elements.TextBoxRow( Options.Defaults.window.backcolor1, "options", "description", "trg_description", 50, true )
    self.description:SetParent( self )
    self.description:SetTop( top )
    
    top = top + 55

    self.token = Options.Elements.DropDownRow( Options.Defaults.window.backcolor1, "options", "token", "trg_token", 30, true )
    self.token:SetParent( self )
    self.token:SetTop( top )

    for i, window_data in ipairs(Data.window) do
        
        for j, timer_data in ipairs(window_data.timerList) do

            local text =  timer_data.description
            if text == "" then
                text = timer_data.textValue
            end
            if text ~= "" then
                self.token:AddItem( nil, text, timer_data.id)
            end

        end

    end

    top = top + 35

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


    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TimerOptions:ResetContent()

    self.description:SetText( self.data.description )
    self.token:SetSelection( self.data.token )
    self.action:SetSelection( self.data.action )
    self.value:SetText( self.data.value )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TimerOptions:SizeChanged()

    self.description:SetWidth( self:GetWidth() )
    self.token:SetWidth( self:GetWidth() )
    self.action:SetWidth( self:GetWidth() )
    self.value:SetWidth( self:GetWidth() )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TimerOptions:Save()

    self.data.description   = self.description:GetText(  )
    Turbine.Shell.WriteLine(self.token:GetSelectedValue(  ))
    local token = self.token:GetSelectedValue(  )
    if token == nil then
        self.data.token = ""
    else
        self.data.token = token
    end
    -- self.data.token         = self.token:GetSelectedValue(  )
    self.data.action        = self.action:GetSelectedValue(  )
    self.data.value         = self.value:GetText(  )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TimerOptions:Reset()

    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TimerOptions:Close()


end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TimerOptions:BuildCollectionRightClickMenu( data, menu )

end
---------------------------------------------------------------------------------------------------
