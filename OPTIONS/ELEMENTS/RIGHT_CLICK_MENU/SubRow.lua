--=================================================================================================
--= Shortcut Action Button
--= ===============================================================================================
--= 
--=================================================================================================



 Options.Elements.SubRow = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function  Options.Elements.SubRow:Constructor( text_control, text_description, subMenu, height )
	Turbine.UI.Control.Constructor( self )

    self.parent = nil
    self.subMenu   = subMenu

    self.text_control = text_control
    self.text_description = text_description

    self.text = Turbine.UI.Label()
    self.text:SetParent( self )
    self.text:SetHeight( height )
    self.text:SetLeft( Options.Defaults.rc_menu.text_left )
    self.text:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft )
    self.text:SetFont( Options.Defaults.rc_menu.font )
    self.text:SetMouseVisible( false )

    self:SetHeight( height )
    self:SetMouseVisible( true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function  Options.Elements.SubRow:MouseClick( sender, args )



    -- hide rightclick menu
    -- self.parent:Hide()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function  Options.Elements.SubRow:MouseEnter( sender, args )

    self:Hover( true )
    self.parent:HoverChanged( self )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function  Options.Elements.SubRow:Hover( value )

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

---------------------------------------------------------------------------------------------------
function  Options.Elements.SubRow:LanguageChanged()

    local text = UTILS.GetText( self.text_control, self.text_description)
    self.text:SetText( text )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function  Options.Elements.SubRow:SizeChanged()

    self.text:SetWidth( self:GetWidth() - Options.Defaults.rc_menu.text_left )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function  Options.Elements.SubRow:SetSuper( parent )

    self.parent = parent
    
end
---------------------------------------------------------------------------------------------------
