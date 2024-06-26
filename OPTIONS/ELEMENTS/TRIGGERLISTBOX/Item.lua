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

        -- if self.index == Data.selectedTriggerIndex and self.data.type == Data.selectedTriggerType then
        --     return
        -- end
        -- self:SetBackColor( Options.Defaults.window.w_window_hover )

    end

    self.MouseLeave = function ()

        -- if self.index == Data.selectedTriggerIndex and self.data.type == Data.selectedTriggerType then
        --     return
        -- end
        -- self:SetBackColor( Options.Defaults.window.w_window_base )

    end

    self.MouseClick = function ( sender, args )

        -- change selection
        self.parent:TriggerClicked( self.index, self.data.type )

        -- show rightclick menu
        if args.Button == Turbine.UI.MouseButton.Right then
            
            self.rightClickMenu:Show()

        end

    end

    self.MouseDown = function ( sender, args )
        
        -- only allow move with leftclick
        if args.Button == Turbine.UI.MouseButton.Left then

            -- set state to dragging and save start positions
            -- self.dragging = true
            -- self.leftSave, self.topSave = self:GetPosition()
            -- self.dragStartX = args.X
            -- self.dragStartY = args.Y
            -- self:SetZOrder(200)

        end

    end

    self.MouseMove = function ( sender, args )

        if self.dragging then

			-- local x, y = self:GetPosition()
            -- local x_offset = args.X - self.dragStartX
            -- local y_offset = args.Y - self.dragStartY
            -- x = x + x_offset
            -- y = y + y_offset
            -- self.dragWindow:SetVisible( true )
            -- self.background:SetParent( self.dragWindow )
            -- self:SetPosition( x, y )

		end

    end

    self.MouseUp = function ( sender, args )
     
        if args.Button == Turbine.UI.MouseButton.Left then

			-- self.dragging = false
            -- self:SetPosition( self.leftSave, self.topSave )
            -- -- self.parent:DraggingEnd(self.data)
            -- self:SetZOrder(nil)
            -- self.dragWindow:SetVisible(false)
            -- self.background:SetParent(self)
            
		end
           
    end

    -- rightclick menu
    self.rightClickMenu = Options.Elements.RightClickMenu( Options.Defaults.window.menu_width )

    -- export
    self.rc_export = Options.Elements.Row( "selection", "export", function ()
        Options.Window.Object:ShowExport( self.data, ImportType.Trigger )
    end,
    Options.Defaults.rc_menu.item_height )

    -- delete
    self.rc_delete = Options.Elements.Row( "selection", "delete", function ()
        self.parent:DeleteTrigger( self.index, self.data.type )
    end,
    Options.Defaults.rc_menu.item_height)

    -- copy
    self.rc_copy = Options.Elements.Row( "selection", "copy", function ()
        self.parent:CopyTrigger( self.data )
    end,
    Options.Defaults.rc_menu.item_height)

    self.rightClickMenu:AddRow( self.rc_export )
    self.rightClickMenu:AddSeperator()
    self.rightClickMenu:AddRow( self.rc_delete )
    self.rightClickMenu:AddRow( self.rc_copy )

    -- window name


    self.textLabel = Turbine.UI.Label()
    self.textLabel:SetParent( self.background )
    self.textLabel:SetLeft( 10 )
    self.textLabel:SetSize( width - 40, Options.Defaults.window.t_item_height - 12 )
    self.textLabel:SetMultiline( false )
    self.textLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft )
    self.textLabel:SetFont( Options.Defaults.window.w_font )
    self.textLabel:SetForeColor( Options.Defaults.window.textcolor )
    self.textLabel:SetMouseVisible( false )

    self.actionLabel = Turbine.UI.Label()
    self.actionLabel:SetParent( self.background )
    self.actionLabel:SetPosition( 10, Options.Defaults.window.t_item_height - 13 )
    self.actionLabel:SetSize( width - 10, 12 )
    self.actionLabel:SetMultiline( false )
    self.actionLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft )
    self.actionLabel:SetFont( Turbine.UI.Lotro.Font.Verdana12 )
    self.actionLabel:SetForeColor( Options.Defaults.window.textdark )
    self.actionLabel:SetMouseVisible( false )
    
    self.typeLabel = Turbine.UI.Label()
    self.typeLabel:SetParent( self.background )
    self.typeLabel:SetPosition( 10, Options.Defaults.window.t_item_height - 13 )
    self.typeLabel:SetSize( width - 23, 12 )
    self.typeLabel:SetMultiline( false )
    self.typeLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight )
    self.typeLabel:SetFont( Turbine.UI.Lotro.Font.Verdana12 )
    self.typeLabel:SetForeColor( Options.Defaults.window.textdark )
    self.typeLabel:SetMouseVisible( false )
    
    -- enable checkbox
    self.enabledCheckbox = Options.Elements.CheckBox()
    self.enabledCheckbox:SetParent( self.background )
    self.enabledCheckbox:SetPosition( width - 40, -5 )
    self.enabledCheckbox:SetChecked( self.data.enabled )
    self.enabledCheckbox.CheckedChanged = function( value )
        self.data.enabled = value
    end

    self:TriggerSelectionChanged()
    self:UpdateData()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Item:UpdateData()

    -- text
    local text = self.data.description
    if text == "" then
        text = self.data.token
    end

    self.textLabel:SetText( text )

    self:LanguageChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Item:LanguageChanged()

    self.rightClickMenu:LanguageChanged()
    self.actionLabel:SetText(UTILS.GetText("action", self.data.action ))
    self.typeLabel:SetText( UTILS.GetText("triggerType", self.data.type ))

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Item:Filter( filter )
    
    if string.find( string.lower( self.data.token ) , filter ) then
        return true
    end

    return false

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Item:TriggerSelectionChanged()

    if self.index == Data.selectedTriggerIndex and self.data.type == Data.selectedTriggerType then

        self:SetBackColor( Options.Defaults.window.w_window_select )

    else

        self:SetBackColor( Options.Defaults.window.w_window_base )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Item:Trigger2SelectionChanged()

    if self.index == Data.selectedTriggerIndex2 and self.data.type == Data.selectedTriggerType2 then

        self:SetBackColor( Options.Defaults.window.w_window_select )

    else

        self:SetBackColor( Options.Defaults.window.w_window_base )

    end

end
---------------------------------------------------------------------------------------------------
