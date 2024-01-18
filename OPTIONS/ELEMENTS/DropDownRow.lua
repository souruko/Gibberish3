--=================================================================================================
--= TextBox
--= ===============================================================================================
--= 
--=================================================================================================



Options.Elements.DropDownRow = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function Options.Elements.DropDownRow:Constructor( back_color, label_control, label_description, tooltip_description, height )
	Turbine.UI.Control.Constructor( self )

    self.label_control = label_control
    self.label_description = label_description

    self:SetHeight( height )
    self:SetBackColor( back_color )

	self.label = Turbine.UI.Label()
	self.label:SetParent( self )
	self.label:SetPosition( Options.Defaults.window.spacing, Options.Defaults.window.spacing )
	self.label:SetSize( 110, height - Options.Defaults.window.spacing )
	self.label:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight )
	self.label:SetFont( Options.Defaults.window.font )
	Options.Elements.Tooltip.AddTooltip( self.label, "tooltip", tooltip_description, false )

    self.drop_down = Options.Elements.Dropdown( 150 )
	-- self.drop_down:SetParent( self.background2 )
	self.drop_down:SetPosition( 173, Options.Defaults.window.g_content_top + 5 )
    self.drop_down:SetParent( self )

    self:LanguageChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.DropDownRow:LanguageChanged()

    self.label:SetText( UTILS.GetText( self.label_control, self.label_description ) )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.DropDownRow:SizeChanged()

    -- local width, height = self:GetSize()


end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.DropDownRow:AddItem( text_control, text_description, value )
    self.drop_down:AddItem( text_control, text_description, value )
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.DropDownRow:SetSelection( value )
    self.drop_down:SetSelection( value )
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.DropDownRow:GetSelectedValue()
    return self.drop_down:GetSelectedValue()
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.DropDownRow:Close()
    self.drop_down:Close()
end
---------------------------------------------------------------------------------------------------