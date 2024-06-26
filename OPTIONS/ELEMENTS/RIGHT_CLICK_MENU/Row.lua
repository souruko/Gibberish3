--=================================================================================================
--= Shortcut Action Button
--= ===============================================================================================
--= 
--=================================================================================================



 Options.Elements.Row = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function  Options.Elements.Row:Constructor( text_control, text_description, func, height )
	Turbine.UI.Control.Constructor( self )

    self.parent = nil
    self.func   = func

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
function  Options.Elements.Row:MouseClick( sender, args )

    -- activate function
    self.func()

    -- hide rightclick menu
    self.parent:Hide()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function  Options.Elements.Row:MouseEnter( sender, args )

    self:Hover( true )
    self.parent:HoverChanged( self )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function  Options.Elements.Row:Hover( value )

    if value == true then
        self:SetBackColor( Options.Defaults.rc_menu.hover_color )
    else
        self:SetBackColor( nil )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function  Options.Elements.Row:LanguageChanged()

    local text = UTILS.GetText( self.text_control, self.text_description)
    self.text:SetText( text )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function  Options.Elements.Row:SizeChanged()

    self.text:SetWidth( self:GetWidth() - Options.Defaults.rc_menu.text_left )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function  Options.Elements.Row:SetSuper( parent )

    self.parent = parent
    
end
---------------------------------------------------------------------------------------------------
