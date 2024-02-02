--=================================================================================================
--= Window Item
--= ===============================================================================================
--= 
--=================================================================================================



WindowItem = class( Turbine.UI.Control )
---------------------------------------------------------------------------------------------------
function WindowItem:Constructor( parent, data, index )
	Turbine.UI.Control.Constructor( self )

    self.data 	= data
    self.index  = index
    self.parent = parent

    self:CreateBackground()
    self:CreateRightClick()
    self:CreateContent()
    self:Height()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function WindowItem:DataChanged()

    self.nameLabel:SetText( self.data.name )
    self.enabledCheckbox:SetChecked( self.data.enabled )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function WindowItem:CreateBackground()

    -- base background
    self:SetBackColor( Options.Defaults.window.w_window_base )

    -- window for dragging of the window
    self.dragWindow = Turbine.UI.Window()
    self.dragWindow:SetParent( self )
    self.dragWindow:SetBackColor( Options.Defaults.window.w_window_select )
    self.dragWindow:SetMouseVisible( false )
    self.dragWindow:SetVisible( false )

    -- content background
    self.background = Turbine.UI.Control()
    self.background:SetParent( self )
    self.background:SetMouseVisible( false )

    -- mouse actions
    self.MouseEnter = function ()

        if self.index ~= Data.selectedIndex then

            self:SetBackColor( Options.Defaults.window.w_window_hover )

        end

    end

    self.MouseLeave = function ()

        if self.index ~= Data.selectedIndex then

            self:SetBackColor( Options.Defaults.window.w_window_base )

        end

    end

    self.MouseClick = function ( sender, args )

        --  select window if not already selected
        if self.index ~= Data.selectedIndex then

            Options.SelectionChanged( self.index )

        end

        -- show rightclick menu
        if args.Button == Turbine.UI.MouseButton.Right then
            
            self.rightClickMenu:Show()

        end

    end

    self.MouseDown = function ( sender, args )
        
        -- only allow move with leftclick
        if args.Button == Turbine.UI.MouseButton.Left then

            -- set state to dragging and save start positions
            self.dragging = true
            self.leftSave, self.topSave = self:GetPosition()
            self.dragStartX = args.X
            self.dragStartY = args.Y
            self:SetZOrder(200)

        end

    end

    self.MouseMove = function ( sender, args )

        if self.dragging then

			local x, y = self:GetPosition()
            local x_offset = args.X - self.dragStartX
            local y_offset = args.Y - self.dragStartY
            x = x + x_offset
            y = y + y_offset
            self.dragWindow:SetVisible( true )
            self.background:SetParent( self.dragWindow )
            self:SetPosition( x, y )

		end

    end

    self.MouseUp = function ( sender, args )
     
        if args.Button == Turbine.UI.MouseButton.Left then

			self.dragging = false
            self:SetPosition( self.leftSave, self.topSave )
            self.parent:DraggingEnd(self.data)
            self:SetZOrder(nil)
            self.dragWindow:SetVisible(false)
            self.background:SetParent(self)
            
		end
           
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function WindowItem:CreateRightClick()

    -- rightclick menu
    self.rightClickMenu = Options.Elements.RightClickMenu( Options.Defaults.window.menu_width )

        -- export subMenu
        self.rc_exportSubMenu = Options.Elements.RightClickSubMenu( Options.Defaults.window.menu_width )

        -- export window
        self.rc_ex_window = Options.Elements.Row( "selection", "ex_window", function ()

        end,
        Options.Defaults.rc_menu.item_height)
 
        -- export list of timer
        self.rc_ex_lot = Options.Elements.Row( "selection", "ex_lot", function ()

        end,
        Options.Defaults.rc_menu.item_height)

        self.rc_exportSubMenu:AddRow( self.rc_ex_window )
        self.rc_exportSubMenu:AddRow( self.rc_ex_lot )

    -- export
    self.rc_export = Options.Elements.SubRow( "selection", "export", self.rc_exportSubMenu,
    Options.Defaults.rc_menu.item_height )

    -- delete
    self.rc_delete = Options.Elements.Row( "selection", "delete", function ()
        Options.DeleteWindow( self.index )
        self.parent:ReFill()
    end,
    Options.Defaults.rc_menu.item_height)

    -- copy
    self.rc_copy = Options.Elements.Row( "selection", "copy", function ()
        local index = Window.Copy( self.index )
        self.parent:CreateWindowElements()
        self.parent:AsignFolder()
        self.parent:FillContent()
        self.parent:FixElementHeight()
        Options.SelectionChanged( index )
    end,
    Options.Defaults.rc_menu.item_height)

    self.rightClickMenu:AddSubRow( self.rc_export, self.rc_exportSubMenu )
    self.rightClickMenu:AddSeperator()
    self.rightClickMenu:AddRow( self.rc_delete )
    self.rightClickMenu:AddRow( self.rc_copy )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function WindowItem:CreateContent()

    -- window name
    self.nameLabel = Turbine.UI.Label()
    self.nameLabel:SetParent( self.background )
    self.nameLabel:SetLeft( 10 )
    self.nameLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft )
    self.nameLabel:SetFont( Options.Defaults.window.w_font )
    self.nameLabel:SetForeColor( Options.Defaults.window.textcolor )
    self.nameLabel:SetText( self.data.name )
    self.nameLabel:SetMouseVisible( false )

    -- enable checkbox
    self.enabledCheckbox = Options.Elements.CheckBox()
    self.enabledCheckbox:SetParent( self.background )
    self.enabledCheckbox:SetTop( 0 )
    self.enabledCheckbox:SetChecked( self.data.enabled )

	self.enabledCheckbox.CheckedChanged = function( value )
        self.data.enabled = value
		Windows.EnabledChanged( self.index )
	end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function WindowItem:Filter( filter )

    if string.find( string.lower( self.data.name ) , filter ) then
        return true
    end

    return false

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function WindowItem:Width( value )

    self:SetWidth( value )
    self.dragWindow:SetWidth( value )
    self.background:SetWidth( value )
    self.nameLabel:SetWidth( value - 55)
    self.enabledCheckbox:SetLeft( value - 40 )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function WindowItem:Height()

    self:SetHeight( Options.Defaults.window.w_item_height )
    self.dragWindow:SetHeight( Options.Defaults.window.w_item_height )
    self.nameLabel:SetHeight( Options.Defaults.window.w_item_height )
    self.background:SetHeight( Options.Defaults.window.w_item_height )

    return Options.Defaults.window.w_item_height

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function WindowItem:SelectionChanged()

    if self.index == Data.selectedIndex then

        self:SetBackColor( Options.Defaults.window.w_window_select )

    else

        self:SetBackColor( Options.Defaults.window.w_window_base )
    
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function WindowItem:LanguageChanged()
    self.rightClickMenu:LanguageChanged()
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function WindowItem:Sort( sortFunction )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function WindowItem:DraggingEnd( fromData )

    Options.MoveTo(fromData, self.data)
    
end
---------------------------------------------------------------------------------------------------
