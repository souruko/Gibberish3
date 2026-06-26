--=================================================================================================
--= Condition Listbox Item
--= ===============================================================================================
--=
--=================================================================================================



ConditionItem = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function ConditionItem:Constructor( index, data, width, parent )
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

    self.MouseEnter = function ()
        if self.index == Data.selectedConditionsIndex then return end
        self:SetBackColor( Options.Defaults.window.w_window_hover )
    end

    self.MouseLeave = function ()
        if self.index == Data.selectedConditionsIndex then return end
        self:SetBackColor( Options.Defaults.window.w_window_base )
    end

    self.MouseClick = function ( sender, args )
        self.parent:ConditionClicked( self.index )
        if args.Button == Turbine.UI.MouseButton.Right then
            self.rightClickMenu:Show()
        end
    end

    -- rightclick menu
    self.rightClickMenu = Options.Elements.RightClickMenu( Options.Defaults.window.menu_width )

    self.rc_delete = Options.Elements.Row( "selection", "delete", function ()
        self.parent:DeleteCondition( self.index )
    end, Options.Defaults.rc_menu.item_height )

    self.rc_copy = Options.Elements.Row( "selection", "copy", function ()
        self.parent:CopyCondition( self.data )
    end, Options.Defaults.rc_menu.item_height )

    self.rightClickMenu:AddRow( self.rc_delete )
    self.rightClickMenu:AddRow( self.rc_copy )

    -- description label: top portion
    self.textLabel = Turbine.UI.Label()
    self.textLabel:SetParent( self.background )
    self.textLabel:SetPosition( 4, 4 )
    self.textLabel:SetSize( width - 8, 20 )
    self.textLabel:SetMultiline( true )
    self.textLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft )
    self.textLabel:SetFont( Options.Defaults.window.w_font )
    self.textLabel:SetForeColor( Options.Defaults.window.textcolor )
    self.textLabel:SetMouseVisible( false )

    -- enabled checkbox: below label
    self.enabledCheckbox = Options.Elements.CheckBox()
    self.enabledCheckbox:SetParent( self.background )
    self.enabledCheckbox:SetPosition( 4, 28 )
    self.enabledCheckbox:SetChecked( self.data.enabled )
    self.enabledCheckbox.CheckedChanged = function( value )
        self.data.enabled = value
    end

    self:ConditionsSelectionChanged()
    self:UpdateData()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionItem:SizeChanged()

    if self.background == nil then return end

    local w, h = self:GetSize()
    self.background:SetSize( w, h )

    local label_height = math.max( 16, h - 32 )
    self.textLabel:SetSize( w - 8, label_height )
    self.enabledCheckbox:SetTop( label_height + 6 )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionItem:UpdateData()

    local text = self.data.description
    if text == nil or text == "" then
        text = "#" .. tostring( self.index )
    end
    self.textLabel:SetText( text )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ConditionItem:ConditionsSelectionChanged()

    if self.index == Data.selectedConditionsIndex then
        self:SetBackColor( Options.Defaults.window.w_window_select )
    else
        self:SetBackColor( Options.Defaults.window.w_window_base )
    end

end
---------------------------------------------------------------------------------------------------
