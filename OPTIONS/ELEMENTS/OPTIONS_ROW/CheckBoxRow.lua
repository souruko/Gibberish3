--=================================================================================================
--= TextBox
--= ===============================================================================================
--= 
--=================================================================================================



Options.Elements.CheckBoxRow = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function Options.Elements.CheckBoxRow:Constructor( back_color, label_control, label_description, tooltip_description, height )
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


    self.checkbox = Options.Elements.CheckBox()
	self.checkbox:SetParent( self )
	self.checkbox:SetPosition( 140, Options.Defaults.window.g_content_top )
	-- self.checkbox:SetChecked( Data.showTooltips )
	-- function self.checkbox:CheckedChanged( value )
	-- 	Options.ShowTooltipChanged( value )
	-- end

	self.checkbox.CheckedChanged = function ( value )
		self.CheckedChanged( value )
	end

    self:LanguageChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.CheckBoxRow:LanguageChanged()

    self.label:SetText( UTILS.GetText( self.label_control, self.label_description ) )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.CheckBoxRow:SizeChanged()

    -- local width, height = self:GetSize()

    -- self.checkbox:SetWidth( width - 130 - 3*Options.Defaults.window.spacing )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.CheckBoxRow:SetChecked( value )
    self.checkbox:SetChecked( value)
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.CheckBoxRow:IsChecked()
    return self.checkbox:IsChecked()
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.CheckBoxRow.CheckedChanged( value )

end
---------------------------------------------------------------------------------------------------