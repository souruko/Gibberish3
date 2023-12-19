--=================================================================================================
--= Shortcut Action Button
--= ===============================================================================================
--= 
--=================================================================================================



Row = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function Row:Constructor( text, func, width, height, parent )
	Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.func   = func

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
function Row:MouseClick( sender, args )

    -- activate function
    self.func()

    -- hide rightclick menu
    self.parent:Hide()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Row:MouseEnter( sender, args )

    self:Hover( true )
    self.parent:HoverChanged( self )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Row:Hover( value )

    if value == true then
        self:SetBackColor( Options.Defaults.rc_menu.hover_color )
    else
        self:SetBackColor( nil )
    end

end
---------------------------------------------------------------------------------------------------