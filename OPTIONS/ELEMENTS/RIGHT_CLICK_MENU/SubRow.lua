--=================================================================================================
--= Shortcut Action Button
--= ===============================================================================================
--= 
--=================================================================================================



SubRow = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function SubRow:Constructor( text, subMenu, width, height, parent )
	Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.subMenu   = subMenu

    self:SetSize( width, height )
    self:SetMouseVisible( true )

    self.text = Turbine.UI.Label()
    self.text:SetParent( self )
    self.text:SetSize( ( width - Options.Defaults.rc_menu.text_left ), height)
    self.text:SetLeft( Options.Defaults.rc_menu.text_left )
    self.text:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft )
    self.text:SetFont( Options.Defaults.rc_menu.font )
    self.text:SetText( text )
    self.text:SetMouseVisible( false )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function SubRow:MouseClick( sender, args )



    -- hide rightclick menu
    -- self.parent:Hide()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function SubRow:MouseEnter( sender, args )

    self:Hover( true )
    self.parent:HoverChanged( self )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function SubRow:Hover( value )

    if value == true then

        self:SetBackColor( Options.Defaults.rc_menu.hover_color )

        -- show subMenu
        local left, top = self:GetPosition()
        local p_left, p_top = self.parent:GetPos()

        if self.parent.orientation == Turbine.UI.ContentAlignment.BottomRight then
            left = p_left - 5 - self:GetWidth()
            top  = p_top - top
    
        elseif self.parent.orientation == Turbine.UI.ContentAlignment.BottomLeft then
            left = p_left + 5 + self:GetWidth()
            top  = p_top - top
    
        elseif self.parent.orientation == Turbine.UI.ContentAlignment.TopRight then
            left = p_left - 5 - self:GetWidth()
            top  = p_top + top

        else
            left = p_left + 5 + self:GetWidth()
            top  = p_top + top
      
        end
        self.subMenu:Show( left, top, self.parent.orientation )

    else
        self:SetBackColor( nil )
        self.subMenu:Hide()
    end
    
end
---------------------------------------------------------------------------------------------------