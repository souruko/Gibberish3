--=================================================================================================
--= Condition Trigger Listbox Item
--= ===============================================================================================
--=
--=================================================================================================



ConditionTriggerItem = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function ConditionTriggerItem:Constructor( index, data, width, parent )
    Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.index  = index
    self.data   = data

    self:SetBackColor( Options.Defaults.window.w_window_base )
    self:SetSize( width, Options.Defaults.window.t_item_height )

    self.background = Turbine.UI.Control()
    self.background:SetParent( self )
    self.background:SetSize( width, Options.Defaults.window.t_item_height )
    self.background:SetMouseVisible( false )

    -- orange left stripe
    self.triggerStripe = Turbine.UI.Control()
    self.triggerStripe:SetParent( self.background )
    self.triggerStripe:SetPosition( 0, 0 )
    self.triggerStripe:SetSize( 5, Options.Defaults.window.t_item_height )
    self.triggerStripe:SetBackColor( Options.Defaults.window.color_trigger )
    self.triggerStripe:SetMouseVisible( false )

    self.MouseEnter = function ()
        if self.index == Data.selectedConditionTriggerIndex and self.data.type == Data.selectedConditionTriggerType then return end
        self:SetBackColor( Options.Defaults.window.w_window_hover )
    end

    self.MouseLeave = function ()
        if self.index == Data.selectedConditionTriggerIndex and self.data.type == Data.selectedConditionTriggerType then return end
        self:SetBackColor( Options.Defaults.window.w_window_base )
    end

    self.MouseClick = function ( sender, args )
        self.parent:TriggerClicked( self.index, self.data.type )
        if args.Button == Turbine.UI.MouseButton.Right then
            self.rightClickMenu:Show()
        end
    end

    -- rightclick menu
    self.rightClickMenu = Options.Elements.RightClickMenu( Options.Defaults.window.menu_width )

    self.rc_delete = Options.Elements.Row( "selection", "delete", function ()
        self.parent:DeleteTrigger( self.index, self.data.type )
    end, Options.Defaults.rc_menu.item_height )

    self.rc_copy = Options.Elements.Row( "selection", "copy", function ()
        self.parent:CopyTrigger( self.data )
    end, Options.Defaults.rc_menu.item_height )

    self.rightClickMenu:AddRow( self.rc_delete )
    self.rightClickMenu:AddRow( self.rc_copy )

    -- description label: upper half, full width
    self.textLabel = Turbine.UI.Label()
    self.textLabel:SetParent( self.background )
    self.textLabel:SetPosition( 8, 4 )
    self.textLabel:SetSize( width - 16, 20 )
    self.textLabel:SetMultiline( true )
    self.textLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft )
    self.textLabel:SetFont( Options.Defaults.window.w_font )
    self.textLabel:SetForeColor( Options.Defaults.window.textcolor )
    self.textLabel:SetMouseVisible( false )

    -- type label: below text
    self.typeLabel = Turbine.UI.Label()
    self.typeLabel:SetParent( self.background )
    self.typeLabel:SetPosition( 8, 28 )
    self.typeLabel:SetSize( width - 16, 12 )
    self.typeLabel:SetMultiline( false )
    self.typeLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight )
    self.typeLabel:SetFont( Turbine.UI.Lotro.Font.Verdana12 )
    self.typeLabel:SetForeColor( Options.Defaults.window.textdark )
    self.typeLabel:SetMouseVisible( false )

    -- enabled checkbox: bottom-left
    self.enabledCheckbox = Options.Elements.CheckBox()
    self.enabledCheckbox:SetParent( self.background )
    self.enabledCheckbox:SetPosition( 4, Options.Defaults.window.t_item_height - 30 )
    self.enabledCheckbox:SetChecked( self.data.enabled )
    self.enabledCheckbox.CheckedChanged = function( value )
        self.data.enabled = value
    end

    self:TriggerSelectionChanged()
    self:UpdateData()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionTriggerItem:SizeChanged()

    local w, h = self:GetSize()
    self.background:SetSize( w, h )
    self.triggerStripe:SetHeight( h )

    local half = math.floor( h / 2 )
    self.textLabel:SetSize( w - 16, half - 4 )
    self.typeLabel:SetTop( half )
    self.enabledCheckbox:SetTop( h - 30 )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionTriggerItem:UpdateData()

    local text = self.data.description
    if text == nil or text == "" then
        text = self.data.token
    end
    self.textLabel:SetText( text )
    self.typeLabel:SetText( UTILS.GetText( "triggerType", self.data.type ) )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionTriggerItem:TriggerSelectionChanged()

    if self.index == Data.selectedConditionTriggerIndex and self.data.type == Data.selectedConditionTriggerType then
        self:SetBackColor( Options.Defaults.window.w_window_select )
    else
        self:SetBackColor( Options.Defaults.window.w_window_base )
    end

end
---------------------------------------------------------------------------------------------------
