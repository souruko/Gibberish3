--===================================================================================
--             Name:    TriggerControl
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
Options.Constructor.TriggerControl = class( Turbine.UI.Control )






-------------------------------------------------------------------------------------
--      Description:    TriggerControl constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, mouseclick function
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.TriggerControl:Constructor( data, triggerIndex, width, parent )
	Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.data = data
    self.index = triggerIndex

    self.selected = false

    local height = 60
    local frame_size = 0

    self:SetSize(width, height)
    self:SetMouseVisible(true)

    self.background = Turbine.UI.Control()
    self.background:SetParent(self)
    self.background:SetPosition( 0, frame_size)
    self.background:SetSize(width, height - 2*frame_size)
    self.background:SetMouseVisible(false)

    self.enabledCheckBox = Options.Constructor.CheckBox( self )
    self.enabledCheckBox:SetPosition(3, 15)
    self.enabledCheckBox:SetChecked(data.enabled)

    self.action = Turbine.UI.Label()
    self.action:SetParent(self)
    self.action:SetLeft(5)
    self.action:SetWidth(width - 10)
    self.action:SetHeight(12)
    self.action:SetTop(5)
    self.action:SetFont( Defaults.Fonts.SmallFont )
    self.action:SetForeColor(Defaults.Colors.BackgroundColor6)
    self.action:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.action:SetMouseVisible(false)

    local text = L[Language.Local].Terms.Action[ self.data.action ] .. " - " .. L[Language.Local].Terms.TriggerType[ self.data.type ]
    self.action:SetText(text)

    self.token = Turbine.UI.Label()
    self.token:SetParent(self)
    self.token:SetPosition(40,10)
    self.token:SetWidth(width - 40)
    self.token:SetHeight(height - 10)
    self.token:SetFont( Defaults.Fonts.MediumFont )
    self.token:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.token:SetText(data.token)
    self.token:SetMouseVisible(false)

-------------------------------------------------------------------------------------
--      export
    self.exportMenu                       = Options.Constructor.RightClickMenu(125)
    self.exportMenu:AddRow(                 L[Language.Local].Menu.Group, function ()
    end)

    self.exportMenu:AddRow(                 L[Language.Local].Menu.ListOfTimers, function ()
        
    end)


-------------------------------------------------------------------------------------
--      right click
    self.rightClickMenu = Options.Constructor.RightClickMenu(125)

    self.rightClickMenu:AddSubMenuRow( L[Language.Local].Menu.Export, self.exportMenu )

    self.rightClickMenu:AddSeperator()

    self.rightClickMenu:AddRow( L[Language.Local].Menu.Delete, function ()
        
    end)

    self.rightClickMenu:AddSeperator()

    self.rightClickMenu:AddRow( L[Language.Local].Menu.Cut, function ()
        
    end)

    self.rightClickMenu:AddRow( L[Language.Local].Menu.Copy, function ()
        
    end)

    self.rightClickMenu:AddRow( L[Language.Local].Menu.Paste, function ()
        
    end)

    
    self.MouseDown = function( sender, args )
		if args.Button == Turbine.UI.MouseButton.Left then
			self.dragging = true	
            self.topSave = self:GetTop()
            self.dragStartY = args.Y
            self:SetZOrder(200)
		end
	end
	
	self.MouseMove = function( sender, args )
		if self.dragging then
			local y = self:GetTop()	
            local y_offset = args.Y - self.dragStartY
            y = y + y_offset
            if y < 0 then
                y = 0
            elseif y > self:GetParent():GetHeight() - self:GetHeight() then
                y = self:GetParent():GetHeight() - self:GetHeight()
            end

            self:SetTop( y )
		end
	end
	
	self.MouseUp = function( sender, args )
		if args.Button == Turbine.UI.MouseButton.Left then
			self.dragging = false
            self:SetTop( self.topSave )
            self.parent:DraggingEnd(self.data)
            self:SetZOrder(nil)
		end
    end
 -------------------------------------------------------------------------------------
--      Description:    TimerControl constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, mouseclick function
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
    function self.MouseClick( sender, args )

        if self.selected == false then

            if self:IsControlKeyDown() == true then

                self.parent:SelectionChanged(self.data, self.index, true)

            else

                self.parent:SelectionChanged(self.data, self.index, false)

            end
            
        end

        
        if args.Button == Turbine.UI.MouseButton.Right then

            self.rightClickMenu:Show(nil, nil, true)

        end

    end


end


-------------------------------------------------------------------------------------
--      Description:    TriggerControl constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, mouseclick function
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.TriggerControl:MouseEnter( sender, args )

    if self.selected == false then
        self.background:SetBackColor( Defaults.Colors.BackgroundColor3 )
    end

end


-------------------------------------------------------------------------------------
--      Description:    TriggerControl constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, mouseclick function
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.TriggerControl:MouseLeave( sender, args )

    if self.selected == false then
        self.background:SetBackColor( Defaults.Colors.BackgroundColor1 )
    end

end


-------------------------------------------------------------------------------------
--      Description:    TriggerControl constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, mouseclick function
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
-- function Options.Constructor.TriggerControl:MouseClick( sender, args )

--     if self.selected == false then
--         self.parent:SelectionChanged(self)
--     end

-- end


-------------------------------------------------------------------------------------
--      Description:    TriggerControl constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, mouseclick function
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.TriggerControl:Select()

    self.selected = true
    self.background:SetBackColor(Defaults.Colors.BackgroundColor2)

end


-------------------------------------------------------------------------------------
--      Description:    TriggerControl constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, mouseclick function
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.TriggerControl:Deselect( sender, args )

    self.selected = false
    self.background:SetBackColor( Defaults.Colors.BackgroundColor1 )

end

-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.TriggerControl:MatchesSearch( text )

    if string.find( string.lower( self.data.token ) , text ) then
        return true
    end

    return false

end