--=================================================================================================
--= Shortcut Action Button
--= ===============================================================================================
--= 
--=================================================================================================



Options.Elements.RightClickSubMenu = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickSubMenu:Constructor( width )
	Turbine.UI.Control.Constructor( self )

    self.width = width
    self.height = 2 * Options.Defaults.rc_menu.spacing
    self.orientation = Turbine.UI.ContentAlignment.BottomRight

    self.children = {}

    -- self
    self:SetMouseVisible( false )
    self:SetWidth( self.width )
    self:SetVisible( false )
    
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
function Options.Elements.RightClickSubMenu:Show( left, top, orientation )

    self.orientation = orientation

    self:SetPosition( left, top )

    self:SetVisible( true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickSubMenu:Hide()

    self:SetVisible( false )

    for key, child in pairs(self.children) do
        child:Hide()
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickSubMenu:AddRow( row )

    row:SetWidth( self.width )
    row:SetSuper( self )

    -- add row item with text_control, text_description and function
    self.list:AddItem( row )

    -- fix height
    self:ChangeHeight( Options.Defaults.rc_menu.item_height )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickSubMenu:AddCheckRow( row )

    row:SetWidth( self.width )
    row:SetSuper( self )

    -- add row item with text_control, text_description and function
    self.list:AddItem( row )

    -- fix height
    self:ChangeHeight( Options.Defaults.rc_menu.item_height )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickSubMenu:AddSeperator()

    -- add row item with text_control, text_description and function
    self.list:AddItem( Options.Elements.Seperator( self.width, Options.Defaults.rc_menu.seperator_height, self ) )

    -- fix height
    self:ChangeHeight( Options.Defaults.rc_menu.seperator_height )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickSubMenu:AddSubRow( row, subMenu )

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
function Options.Elements.RightClickSubMenu:ChangeHeight( value )

    self.height = self.height + value

    self:SetHeight( self.height )
    self.list:SetHeight( self.height )
    self.background:SetHeight( self.height )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickSubMenu:HoverChanged( selected )

    for i = 1, self.list:GetItemCount() do

        local child = self.list:GetItem(i)

        if child ~= selected then

            child:Hover( false )

        end

    end
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickSubMenu:FocusLost()

    self:Hide()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickSubMenu:Used()

    self:GetParent():Hide()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickSubMenu:GetPos()

    return self:GetPosition()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.RightClickSubMenu:LanguageChanged()

    for i = 1, self.list:GetItemCount() do

        local row = self.list:GetItem(i)

        row:LanguageChanged()

    end

    for key, subMenu in pairs(self.children) do
        subMenu:LanguageChanged()
    end
    
end
---------------------------------------------------------------------------------------------------
