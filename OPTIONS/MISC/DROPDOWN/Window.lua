--===================================================================================
--             Name:    Dropdown
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
Options.Constructor.Dropdown = class( Turbine.UI.Window )






-------------------------------------------------------------------------------------
--      Description:    Dropdown constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, width
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.Dropdown:Constructor( parent, width )
	Turbine.UI.Window.Constructor( self )

    self.activ = false

    self.item_height = 25

    self.frame_height = 30
    self.spacing = 2
    local height = self.item_height + self.frame_height + 3*self.spacing
    local left_spacing = 5

    self.parent = parent
    self.selection = nil
    self.selectedValue = nil
    self.width = width

    self:SetSize( width, height)
    self:SetParent( parent )
    self:SetMouseVisible(false)

    self.frame = Turbine.UI.Control()
    self.frame:SetParent(self)
    self.frame:SetSize( width, self.frame_height )
    self.frame:SetBackColor( Defaults.Colors.BackgroundColor4 )
    self.frame.MouseClick = function (sender, args)
        

        self:Activate()
        self:Focus()

        self:SetActiv( not(self.activ) )

    end

    self.FocusLost = function ()
        
        self:SetActiv(false)

    end

    self.background = Turbine.UI.Control()
    self.background:SetParent(self)
    self.background:SetSize( width - 2*self.spacing, self.frame_height - 2*self.spacing )
    self.background:SetPosition( self.spacing , self.spacing )
    self.background:SetBackColor( Defaults.Colors.BackgroundColor1 )
    self.background:SetMouseVisible(false)

    self.label = Turbine.UI.Label()
    self.label:SetParent(self)
    self.label:SetSize( self.background:GetWidth() - left_spacing, self.background:GetHeight() )
    self.label:SetPosition(self.background:GetLeft() + left_spacing, self.background:GetTop() )
    self.label:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
    self.label:SetFont(                 Defaults.Fonts.TabFont )
    self.label:SetMouseVisible(false)

    self.selectionWindow = Turbine.UI.Control()
    self.selectionWindow:SetParent(self)
    self.selectionWindow:SetTop( self.frame_height + self.spacing)
    self.selectionWindow:SetSize( width , height - self.frame_height - self.spacing )
    self.selectionWindow:SetBackColor( Defaults.Colors.BackgroundColor3 )
    self.selectionWindow:SetVisible(false)

    self.list = Turbine.UI.ListBox()
    self.list:SetParent(self.selectionWindow)
    self.list:SetTop( self.spacing )
    self.list:SetSize( width , self.selectionWindow:GetHeight() - 2*self.spacing )

    self:SetVisible(true)

end

-------------------------------------------------------------------------------------
--      Description:    Dropdown ItemClicked
-------------------------------------------------------------------------------------
--        Parameter:    item
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.Dropdown:ItemClicked( clicked_item )

    for i = 1, self.list:GetItemCount() do

        local item = self.list:GetItem(i)

        if item == clicked_item then
            item:Select()
            self.selection = i
            self.selectedValue = item.value

        else
            item:Deselect()

        end
        
    end

    self.label:SetText( clicked_item.label:GetText() )
    self.SelectionChanged(self, self.selection, self.selectedValue)
    self:SetActiv(false)

end

-------------------------------------------------------------------------------------
--      Description:    Dropdown AddItem
-------------------------------------------------------------------------------------
--        Parameter:    text, value
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.Dropdown:AddItem( text, value )

    local item = Item( self, self.width, self.item_height, text, value )
    
    self.list:AddItem( item )

    local height = self.list:GetItemCount() * self.item_height + self.frame_height + 3*self.spacing

    self:SetHeight(height)
    self.selectionWindow:SetHeight( height - self.frame_height - self.spacing )
    self.list:SetHeight( self.selectionWindow:GetHeight() - 2*self.spacing )

end


-------------------------------------------------------------------------------------
--      Description:    Dropdown RemoveItem
-------------------------------------------------------------------------------------
--        Parameter:    index
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.Dropdown:Remove( index )

    self.list:RemoveItemAt( index )

end


-------------------------------------------------------------------------------------
--      Description:    Dropdown GetSelection
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    index 
-------------------------------------------------------------------------------------
function Options.Constructor.Dropdown:GetSelection()

    return self.selection

end

-------------------------------------------------------------------------------------
--      Description:    Dropdown GetSelectionValue
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    value 
-------------------------------------------------------------------------------------
function Options.Constructor.Dropdown:GetSelectionValue()

    return self.selectedValue

end


-------------------------------------------------------------------------------------
--      Description:    Dropdown GetSelection
-------------------------------------------------------------------------------------
--        Parameter:    index
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.Dropdown:SetSelection( index )

    local item = self.list:GetItem( index )

    self:ItemClicked( item )

end


-------------------------------------------------------------------------------------
--      Description:    Dropdown SelectionChanged
-------------------------------------------------------------------------------------
--        Parameter:    index, value
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.Dropdown.SelectionChanged(sender, index, value)

end



-------------------------------------------------------------------------------------
--      Description:    Dropdown SelectionChanged
-------------------------------------------------------------------------------------
--        Parameter:    index, value
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.Dropdown:SetActiv(activ)

    if activ == true then
        self.selectionWindow:SetVisible(true)
        self.frame:SetBackColor( Defaults.Colors.AccentColor4 )
        self.activ = activ

    else

        self.selectionWindow:SetVisible(false)
        self.frame:SetBackColor( Defaults.Colors.BackgroundColor4 )
        self.activ = activ

    end

end


-------------------------------------------------------------------------------------
--      Description:    Dropdown ClearItems
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.Dropdown:ClearItems()

    self.list:ClearItems()
    self.selection = nil
    self.selectedValue = nil

end
