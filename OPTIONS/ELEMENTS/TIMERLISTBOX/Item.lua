--=================================================================================================
--= Dropdown Item
--= ===============================================================================================
--= 
--=================================================================================================



Item = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function Item:Constructor( index, data, width, parent )
	Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.index = index
    self.data = data

    -- base background
    self:SetBackColor( Options.Defaults.window.w_window_base )
    self:SetSize( width, Options.Defaults.window.t_item_height )

    -- window for dragging of the window
    self.dragWindow = Turbine.UI.Window()
    self.dragWindow:SetParent( self )
    self.dragWindow:SetBackColor( Options.Defaults.window.w_window_select )
    self.dragWindow:SetMouseVisible( false )
    self.dragWindow:SetSize( width, Options.Defaults.window.t_item_height )
    self.dragWindow:SetVisible( false )

    -- content background
    self.background = Turbine.UI.Control()
    self.background:SetParent( self )
    self.background:SetSize( width, Options.Defaults.window.t_item_height )
    self.background:SetMouseVisible( false )

    -- mouse actions
    self.MouseEnter = function ()

        if self.index == Data.selectedTimerIndex then
            return
        end
        self:SetBackColor( Options.Defaults.window.w_window_hover )

    end

    self.MouseLeave = function ()

        if self.index == Data.selectedTimerIndex then
            return
        end
        self:SetBackColor( Options.Defaults.window.w_window_base )

    end

    self.MouseClick = function ( sender, args )

        -- change selection
        Options.TimerSelectionChanged( self.index )

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
            self.parent:DraggingEnd( self.data )
            self:SetZOrder(nil)
            self.dragWindow:SetVisible(false)
            self.background:SetParent(self)
            
		end
           
    end

    -- rightclick menu
    self.rightClickMenu = Options.Elements.RightClickMenu( Options.Defaults.window.menu_width )

    -- export
    self.rc_export = Options.Elements.Row( "selection", "export", function ()
        
    end,
    Options.Defaults.rc_menu.item_height )

    -- delete
    self.rc_delete = Options.Elements.Row( "selection", "delete", function ()
        self.parent:DeleteTimer( self.index )
    end,
    Options.Defaults.rc_menu.item_height)

    -- copy
    self.rc_copy = Options.Elements.Row( "selection", "copy", function ()
        self.parent:CopyTimer( self.data )
    end,
    Options.Defaults.rc_menu.item_height)

    self.rightClickMenu:AddRow( self.rc_export )
    self.rightClickMenu:AddSeperator()
    self.rightClickMenu:AddRow( self.rc_delete )
    self.rightClickMenu:AddRow( self.rc_copy )

    -- window name

    self.icon = Turbine.UI.Control()
    self.icon:SetParent( self.background )
    self.icon:SetPosition( 1, 1 )
    self.icon:SetSize( 32, 32 )


    self.textLabel = Turbine.UI.Label()
    self.textLabel:SetParent( self.background )
    self.textLabel:SetLeft( 38 )
    self.textLabel:SetSize( width - 40, Options.Defaults.window.t_item_height )
    self.textLabel:SetMultiline( false )
    self.textLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft )
    self.textLabel:SetFont( Options.Defaults.window.w_font )
    self.textLabel:SetForeColor( Options.Defaults.window.textcolor )
    self.textLabel:SetMouseVisible( false )

    self.permanentLabel = Turbine.UI.Label()
    self.permanentLabel:SetParent( self.background )
    self.permanentLabel:SetPosition( 10, Options.Defaults.window.t_item_height - 13 )
    self.permanentLabel:SetSize( width - 23, 12 )
    self.permanentLabel:SetMultiline( false )
    self.permanentLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight )
    self.permanentLabel:SetFont( Turbine.UI.Lotro.Font.Verdana12 )
    self.permanentLabel:SetForeColor( Options.Defaults.window.textdark )
    self.permanentLabel:SetMouseVisible( false )


    -- enable checkbox
    self.enabledCheckbox = Options.Elements.CheckBox()
    self.enabledCheckbox:SetParent( self.background )
    self.enabledCheckbox:SetPosition( width - 40, -5 )
    self.enabledCheckbox:SetChecked( self.data.enabled )

    self.enabledCheckbox.CheckedChanged = function( value )
        self.data.enabled = value
    end

    self:UpdateData()
    self:TimerSelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Item:UpdateData()

    -- text
    local text = self.data.description
    if text == "" then
        text = self.data.textValue
    end

    self.textLabel:SetText( text )

    --icon
    if self.data.icon ~= nil then
        self.icon:SetBackground( self.data.icon )
        self.icon:SetBackColor( nil )
    else
        self.icon:SetBackground()
        self.icon:SetBackColor(Turbine.UI.Color.Black)
    end

    self:LanguageChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Item:LanguageChanged()

    self.rightClickMenu:LanguageChanged()

    if self.data.permanent == true then
        self.permanentLabel:SetText( UTILS.GetText( "options", "permanent" ) )
    else
        self.permanentLabel:SetText("")
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Item:Filter( filter )

    if string.find( string.lower( self.data.description ) , filter ) then
        return true
    end

    return false

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Item:TimerSelectionChanged()

    if self.index == Data.selectedTimerIndex then

        self:SetBackColor( Options.Defaults.window.w_window_select )

    else

        self:SetBackColor( Options.Defaults.window.w_window_base )

    end

end
---------------------------------------------------------------------------------------------------
