--=================================================================================================
--= Dropdown
--= ===============================================================================================
--= 
--=================================================================================================



Options.Elements.Dropdown = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function Options.Elements.Dropdown:Constructor( width )
	Turbine.UI.Control.Constructor( self )

    self.showing = false
    self.selected_index = nil
    self.selected_value = nil

    local height = 60
    self.width = width

    self:SetSize( width, 60 )
    self:SetMouseVisible( false )

    -- base
    self.base = Turbine.UI.Control()
    self.base:SetParent( self )
    self.base:SetSize( width, Options.Defaults.dropdown.base_height )
    self.base:SetBackColor( Options.Defaults.dropdown.base_color )

    self.background = Turbine.UI.Control()
    self.background:SetParent( self.base )
    -- base - 2x spacing
    self.background:SetSize( width - ( 2 * Options.Defaults.dropdown.spacing ), Options.Defaults.dropdown.base_height - ( 2 * Options.Defaults.dropdown.spacing ) )
    self.background:SetPosition( Options.Defaults.dropdown.spacing , Options.Defaults.dropdown.spacing )
    self.background:SetBackColor( Options.Defaults.dropdown.back_color )
    self.background:SetMouseVisible( false )

    self.label = Turbine.UI.Label()
    self.label:SetParent( self.background )
    self.label:SetSize( self.background:GetWidth() - 5, self.background:GetHeight() )
    self.label:SetPosition( 5, 0 )
    self.label:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft )
    self.label:SetFont( Options.Defaults.window.font )
    self.label:SetMouseVisible( false )

    self.arrow = Turbine.UI.Control()
    self.arrow:SetParent( self.background )
    self.arrow:SetPosition( width - 29, -3 )
    self.arrow:SetSize( 20, 20 )
    self.arrow:SetBlendMode( Turbine.UI.BlendMode.Overlay )
    self.arrow:SetBackground( "Gibberish3/Resources/arrow_down.tga" )
    self.arrow:SetMouseVisible( false )

    -- dropdown
    self.drop_down = Turbine.UI.Window()
    -- self.drop_down:SetParent( self )
    -- self.drop_down:SetTop( Options.Defaults.dropdown.base_height + Options.Defaults.dropdown.spacing )
    self.drop_down:SetSize( width , height - Options.Defaults.dropdown.base_height - Options.Defaults.dropdown.spacing )
    self.drop_down:SetBackColor( Turbine.UI.Color(0.3,0.3,0.3) )
    self.drop_down:SetVisible( false )
    self.drop_down:SetZOrder(1)

    self.listbox = Turbine.UI.ListBox()
    self.listbox:SetParent( self.drop_down )
    self.listbox:SetTop( Options.Defaults.dropdown.spacing )
    self.listbox:SetSize( width , self.drop_down:GetHeight() - ( 2 * Options.Defaults.dropdown.spacing ) )

	self.scrollbar = Turbine.UI.Lotro.ScrollBar()
	self.scrollbar:SetParent( self.listbox )
    self.scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical)
	self.scrollbar:SetBackColor( Options.Defaults.window.framecolor )
    self.scrollbar:SetPosition( width-10 ,0 )
    self.scrollbar:SetWidth( 10 )

    self.listbox:SetVerticalScrollBar( self.scrollbar )

    -- show on click
    self.base.MouseClick = function ()

        if self.drop_down:IsVisible() then

            self:Show( false )
            
        else

            self:Show( true )
            self.drop_down:Activate()
            self.drop_down:Focus()

        end

    end
    -- enter highlight
    self.base.MouseEnter = function ()
        self.background:SetBackColor( Options.Defaults.dropdown.hover_color )
    end
    -- leave remove hightlight
    self.base.MouseLeave = function ()
        self.background:SetBackColor( Options.Defaults.dropdown.back_color )
    end
    -- hide on focus lost
    self.drop_down.FocusLost = function ()
        self:Show( false )
    end
    
    self:SetVisible( true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.Dropdown:Sort( func )

    self.listbox:Sort( func )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.Dropdown:ChangeSelection( child )

    self.selected_index = self.listbox:IndexOfItem( child )
    self.selected_value = child.value

    -- select child
    child:Select( true )

    for i = 1, self.listbox:GetItemCount() do

        local item = self.listbox:GetItem(i)

        if item ~= child then

            -- deselect others
            item:Select( false )

        end

    end

    -- change selection text
    if child.text_control == nil then
        self.label:SetText( child.text_description )

    else
        self.label:SetText( UTILS.GetText( child.text_control, child.text_description ) )

    end
    -- call event
    self.SelectionChanged( self, self.selected_index, self.selected_value )
    -- hide dropdown
    self:Show( false )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.Dropdown:AddItem( text_control, text_description, value )

    local width = self.width-10
    local item = Item( self, width, text_control, text_description, value )

    self.listbox:AddItem( item )
    self:ResizeDropdown()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.Dropdown:RemoveItem( index )

    self.listlox:RemoveItemAt( index )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.Dropdown:GetSelectedIndex()

    return self.selected_index
    
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.Dropdown:GetSelectedValue()

    return self.selected_value

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.Dropdown:SetSelection( value )

    for i = 1, self.listbox:GetItemCount() do

        local item = self.listbox:GetItem( i )

        if item.value == value then
            
            self:ChangeSelection( item )
            return

        end
        
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.Dropdown:Show( value )

    self.showing = value

    local left, top = self:PointToScreen( 0, Options.Defaults.dropdown.base_height + Options.Defaults.dropdown.spacing )
    self.drop_down:SetPosition( left, top )
    self.drop_down:SetVisible( value )
    -- self:SetMouseVisible( value )

    if value == true then
        self.base:SetBackColor( Options.Defaults.dropdown.show_color )

    else
        self.base:SetBackColor( Options.Defaults.dropdown.base_color )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.Dropdown.SelectionChanged( sender, index, value )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.Dropdown:ClearItems()

    self.listbox:ClearItems()
    self.selected_index = nil
    self.selected_value = nil

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.Dropdown:LanguageChanged()

    for i = 1, self.listbox:GetItemCount() do

        local item = self.listbox:GetItem( i )

        item:LanguageChanged()

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.Dropdown:ResizeDropdown()

    local item_count = self.listbox:GetItemCount()
    local height
    if item_count < 11 then
        height = item_count * Options.Defaults.dropdown.item_height

    else
        height = 10 * Options.Defaults.dropdown.item_height

    end

    self.listbox:SetHeight( height )
    self.scrollbar:SetHeight( height )
    height = height + ( 2 * Options.Defaults.dropdown.spacing )
    self.drop_down:SetHeight( height )
    self:SetHeight( height + Options.Defaults.dropdown.spacing + Options.Defaults.dropdown.base_height )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.Dropdown:Close()

    self.drop_down:Close()

end
---------------------------------------------------------------------------------------------------
