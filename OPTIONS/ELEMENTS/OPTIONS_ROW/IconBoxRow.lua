--=================================================================================================
--= TextBox
--= ===============================================================================================
--= 
--=================================================================================================



Options.Elements.IconBoxRow = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function Options.Elements.IconBoxRow:Constructor( back_color, label_control, label_description, tooltip_description, height )
	Turbine.UI.Control.Constructor( self )

    self.label_control = label_control
    self.label_description = label_description

    self.content_height = height - 2*Options.Defaults.window.spacing

	self.label = Turbine.UI.Label()
	self.label:SetParent( self )
	self.label:SetPosition( Options.Defaults.window.spacing, Options.Defaults.window.spacing )
	self.label:SetSize( 110, self.content_height )
	self.label:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight )
	self.label:SetFont( Options.Defaults.window.font )
	Options.Elements.Tooltip.AddTooltip( self.label, "tooltip", tooltip_description, false )

    self.icon = Turbine.UI.Control()
    self.icon:SetParent( self )
    self.icon:SetPosition( 130 + 2*Options.Defaults.window.spacing, Options.Defaults.window.spacing )
    self.icon:SetSize( self.content_height, self.content_height)

    self.textbox = Turbine.UI.Lotro.TextBox()
    self.textbox:SetParent( self )
    -- self.textbox:SetBackColor()
    self.textbox:SetPosition( 130 + 3*Options.Defaults.window.spacing + self.content_height, Options.Defaults.window.spacing )
    self.textbox:SetHeight( self.content_height )
    self.textbox:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft )
	self.textbox:SetForeColor( Options.Defaults.window.textcolor )
	self.textbox:SetSelectable( true )
    self.textbox:SetFont( Options.Defaults.window.font )
    self.textbox:SetMultiline(false)
    self.textbox.TextChanged = function ()
        self:SetIcon()
    end
    self:SetHeight( height )
    self:SetBackColor( back_color )
    
    self:LanguageChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.IconBoxRow:LanguageChanged()

    self.label:SetText( UTILS.GetText( self.label_control, self.label_description ) )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.IconBoxRow:SizeChanged()

    local width, height = self:GetSize()

    self.textbox:SetWidth( width - 130 - 4*Options.Defaults.window.spacing - self.content_height )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.IconBoxRow:SetText( value )
    self.textbox:SetText( value )
    self:SetIcon()
    -- self.textbox.TextChanged()
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.IconBoxRow:GetText()
    return tonumber( self.textbox:GetText() )
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.IconBoxRow:SetIcon()

    local icon_id = tonumber( self.textbox:GetText() )

    if icon_id == nil then
        return
    end

    self.icon:SetSize( UTILS.GetImageSize( icon_id ) )

    self.icon:SetBackground( icon_id )
    -- self.icon:SetStretchMode( 1 )
    -- self.icon:SetSize( self.content_height, self.content_height )

end
---------------------------------------------------------------------------------------------------
