--=================================================================================================
--= TextBox
--= ===============================================================================================
--= 
--=================================================================================================



Options.Elements.ColorBoxRow = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function Options.Elements.ColorBoxRow:Constructor( back_color, label_control, label_description, tooltip_description, height, allow_multiline )
	Turbine.UI.Control.Constructor( self )

    self.label_control = label_control
    self.label_description = label_description

    local content_height = height - 2*Options.Defaults.window.spacing

	self.label = Turbine.UI.Label()
	self.label:SetParent( self )
	self.label:SetPosition( Options.Defaults.window.spacing, Options.Defaults.window.spacing )
	self.label:SetSize( 110, content_height )
	self.label:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight )
	self.label:SetFont( Options.Defaults.window.font )
	Options.Elements.Tooltip.AddTooltip( self.label, "tooltip", tooltip_description, false )

    self.color = Turbine.UI.Control()
    self.color:SetParent( self )
    self.color:SetPosition( 130 + 2*Options.Defaults.window.spacing, Options.Defaults.window.spacing )
    self.color:SetSize( content_height, content_height)
    self.color:SetBackColor(Turbine.UI.Color.Black)

    self.textbox = Turbine.UI.Lotro.TextBox()
    self.textbox:SetParent( self )
    -- self.textbox:SetBackColor()
    self.textbox:SetPosition( 130 + 3*Options.Defaults.window.spacing + content_height, Options.Defaults.window.spacing )
    self.textbox:SetHeight( content_height )
    self.textbox:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft )
	self.textbox:SetForeColor( Options.Defaults.window.textcolor )
	self.textbox:SetSelectable( true )
    self.textbox:SetFont( Options.Defaults.window.font )
    self.textbox:SetMultiline( allow_multiline )
    self.textbox.TextChanged = function ()
        self:TextChanged()
    end

    self:SetHeight( height )
    self:SetBackColor( back_color )

    self:LanguageChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ColorBoxRow:LanguageChanged()

    self.label:SetText( UTILS.GetText( self.label_control, self.label_description ) )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ColorBoxRow:SizeChanged()

    local width, height = self:GetSize()

    self.textbox:SetWidth( width - 130 - 2*Options.Defaults.window.spacing - height )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ColorBoxRow:SetText( value )
    self.textbox:SetText( UTILS.ColorToText( value ) )
    self:TextChanged()
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ColorBoxRow:GetText()
    return UTILS.TextToColor( self.textbox:GetText() )
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ColorBoxRow:TextChanged()

    local color = UTILS.TextToColor( self.textbox:GetText() )
    self.color:SetBackColor( UTILS.ColorFix( color ) )

end
---------------------------------------------------------------------------------------------------