--=================================================================================================
--= Right click menu
--= ===============================================================================================
--= 
--=================================================================================================



Options.Elements.RightClickMenu = class(Turbine.UI.Window)
---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickMenu:Constructor( width )
	Turbine.UI.Window.Constructor( self )

    self.width = width
    self.height = 2 * Options.Defaults.rc_menu.spacing
    self.orientation = Turbine.UI.ContentAlignment.BottomRight

    self.children = {}

    -- self
    self:SetMouseVisible( false )
    self:SetSize( 1000, 1000 )

    -- background
    self.background = Turbine.UI.Control()
    self.background:SetParent( self )
    self.background:SetWidth( self.width )
    self.background:SetBackColor( Options.Defaults.rc_menu.back_color )

    self.list = Turbine.UI.ListBox()
    self.list:SetParent( self.background )
    self.list:SetWidth( self.width )
    self.list:SetTop( Options.Defaults.rc_menu.spacing )
    self.list:SetMouseVisible( false )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickMenu:Show( left, top, orientation )

    self.orientation = orientation

    -- selfposition
    if left == nil then
        left, top = Turbine.UI.Display.GetMousePosition()
    end
    self:SetPosition( left, top )

    -- menu position
    local b_left = 0
    local b_top  = 0

    if self.orientation == Turbine.UI.ContentAlignment.BottomRight then
        b_left = 1000 - self.width
        b_top  = 1000 - self.height
    
    elseif self.orientation == Turbine.UI.ContentAlignment.BottomLeft then
        b_left = 0
        b_top  = 1000 - self.height

    elseif self.orientation == Turbine.UI.ContentAlignment.TopRight then
        b_left = 1000 - self.width
        b_top  = 0

    end

    self.background:SetPosition( b_left, b_top )

    self:LanguageChanged()

    self:SetVisible( true )
    self:Activate()
    self:Focus()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickMenu:Hide()

    self:SetVisible( false )

    for key, child in pairs(self.children) do
        child:Hide()
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickMenu:AddRow( row )

    row:SetWidth( self.width )
    row:SetSuper( self )

    -- add row item with text_control, text_description and function
    self.list:AddItem( row )

    -- fix height
    self:ChangeHeight( Options.Defaults.rc_menu.item_height )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickMenu:AddCheckRow( row )

    row:SetWidth( self.width )
    row:SetSuper( self )

    -- add row item with text_control, text_description and function
    self.list:AddItem( row )

    -- fix height
    self:ChangeHeight( Options.Defaults.rc_menu.item_height )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickMenu:AddSeperator()

    -- add row item with text_control, text_description and function
    self.list:AddItem( Options.Elements.Seperator( self.width, Options.Defaults.rc_menu.seperator_height, self ) )

    -- fix height
    self:ChangeHeight( Options.Defaults.rc_menu.seperator_height )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickMenu:AddSubRow( row, subMenu )

    row:SetWidth( self.width )
    row:SetSuper( self )

    -- set sub menu parent
    subMenu:SetParent( self )
    self.children[ #self.children+1 ] = subMenu

    -- add row item with text_control, text_description and function
    self.list:AddItem( row )

    -- fix height
    self:ChangeHeight( Options.Defaults.rc_menu.item_height )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickMenu:ChangeHeight( value )

    self.height = self.height + value

    self.list:SetHeight( self.height )
    self.background:SetHeight( self.height )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickMenu:HoverChanged( selected )

    for i = 1, self.list:GetItemCount() do

        local child = self.list:GetItem(i)

        if child ~= selected then

            child:Hover( false )

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickMenu:FocusLost()

    self:Hide()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickMenu:GetPos()

    return self.background:GetPosition()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickMenu:LanguageChanged()

    for i = 1, self.list:GetItemCount() do

        local row = self.list:GetItem(i)

        row:LanguageChanged()

    end

    for key, subMenu in pairs(self.children) do
        subMenu:LanguageChanged()
    end

end
---------------------------------------------------------------------------------------------------
