--===================================================================================
--             Name:    TimerControl
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
Options.Constructor.TimerControl = class( Turbine.UI.Control )






-------------------------------------------------------------------------------------
--      Description:    TimerControl constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, mouseclick function
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.TimerControl:Constructor( data, timerID, width, parent )
	Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.data = data
    self.index = timerID

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

    self.type = Turbine.UI.Label()
    self.type:SetParent(self)
    self.type:SetWidth(width - 15)
    self.type:SetHeight(12)
    self.type:SetTop(5)
    self.type:SetLeft(5)
    self.type:SetFont( Defaults.Fonts.SmallFont )
    self.type:SetForeColor(Defaults.Colors.BackgroundColor6)
    self.type:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.type:SetText("Bar")
    self.type:SetMouseVisible(false)

    local text = L[Language.Local].Terms.TimerType[ self.data.type ]
    self.type:SetText(text)

    self.enabledCheckBox = Options.Constructor.CheckBox( self, function ()
        
        self.data.enabled = not(self.data.enabled)

    end )
    self.enabledCheckBox:SetPosition(3, 15)
    self.enabledCheckBox:SetChecked(data.enabled)

    self.description = Turbine.UI.Label()
    self.description:SetParent(self)
    self.description:SetPosition(40,10)
    self.description:SetWidth(width - 94)
    self.description:SetHeight(height-10)
    self.description:SetFont( Defaults.Fonts.MediumFont )
    self.description:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.description:SetText(data.description)
    self.description:SetMouseVisible(false)

    self.icon = Turbine.UI.Control()
    self.icon:SetParent(self)
    self.icon:SetSize(32, 32)
    self.icon:SetPosition( width - 44, height / 2 - 16)
    self.icon:SetMouseVisible(false)

    if data.icon ~= nil then
        self.icon:SetBackground( data.icon )

    else
        self.icon:SetBackColor( Defaults.Colors.BackgroundColor4 )

    end



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
    
    Options.Cut( Options.CopyCache.ItemTypes.Timer )
         
end)

self.rightClickMenu:AddRow( L[Language.Local].Menu.Copy, function ()
    
    Options.Copy( Options.CopyCache.ItemTypes.Timer )

end)

self.rightClickMenu:AddRow( L[Language.Local].Menu.Paste, function ()
    
    Options.Paste( Options.CopyCache.ItemTypes.Timer )

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
--      Description:    TimerControl constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, mouseclick function
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.TimerControl:MouseEnter( sender, args )

    if self.selected == false then
        self.background:SetBackColor( Defaults.Colors.BackgroundColor3 )
    end

end


-------------------------------------------------------------------------------------
--      Description:    TimerControl constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, mouseclick function
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.TimerControl:MouseLeave( sender, args )

    if self.selected == false then
        self.background:SetBackColor( Defaults.Colors.BackgroundColor1 )
    end

end




-------------------------------------------------------------------------------------
--      Description:    TimerControl constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, mouseclick function
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.TimerControl:Select()

    self.selected = true
    self.background:SetBackColor(Defaults.Colors.BackgroundColor2)

end


-------------------------------------------------------------------------------------
--      Description:    TimerControl constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, mouseclick function
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.TimerControl:Deselect( sender, args )

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
function Options.Constructor.TimerControl:MatchesSearch( text )

    if string.find( string.lower( self.data.description ) , text ) then
        return true
    end

    return false

end