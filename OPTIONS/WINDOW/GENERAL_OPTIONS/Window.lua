--=================================================================================================
--= general options
--= ===============================================================================================
--= 
--=================================================================================================



Options.Elements.GeneralOptions = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function Options.Elements.GeneralOptions:Constructor()
	Turbine.UI.Control.Constructor( self )

	self:CreateBackground()
	self:CreateContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.GeneralOptions:LanguageChanged()

	self.show_tooltip_label:SetText( UTILS.GetText( "general", "show_tooltip" ) )
	self.language_label:SetText( UTILS.GetText( "general", "language" ) )

	self.language_dropdown:LanguageChanged()
	
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.GeneralOptions:SelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.GeneralOptions:SizeChanged()

	local width, height = self:GetSize()

	-- calclulate size
	local background1_width  = width - ( 2 * Options.Defaults.window.spacing )
	local background1_height = height - ( 2 * Options.Defaults.window.spacing )

	local frame_width        = background1_width - ( 2 * Options.Defaults.window.spacing )
	local frame_height       = background1_height - ( 2 * Options.Defaults.window.spacing )

	local background2_width  = frame_width - ( 2 * Options.Defaults.window.frame )
	local background2_height = frame_height - ( 2 * Options.Defaults.window.frame )

	-- set size
	self.background1:SetSize( background1_width, background1_height )
	self.frame:SetSize( frame_width, frame_height )
	self.background2:SetSize( background2_width, background2_height )
	self.seperator:SetHeight( background2_height )

	-- calclulate position
	local background1_pos    =  Options.Defaults.window.spacing
	local frame_pos          =  Options.Defaults.window.spacing
	local background2_pos    =  Options.Defaults.window.frame

	-- set position
	self.background1:SetPosition( background1_pos, background1_pos )
	self.frame:SetPosition( frame_pos, frame_pos )
	self.background2:SetPosition( background2_pos, background2_pos )
	self.seperator:SetLeft( background2_width / 2 )
	
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.GeneralOptions:PositionChanged()

	local left, top = self.language_placeholder:PointToScreen( 0, 0)

	self.language_dropdown:SetPosition( left, top )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.GeneralOptions:Closing()

	self.language_dropdown:SetVisible(false)
	self.language_dropdown:Close()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.GeneralOptions:CreateBackground()

	-- background
	self:SetBackColor( Options.Defaults.window.basecolor )

	self.background1 = Turbine.UI.Control()
	self.background1:SetParent( self )
	self.background1:SetBackColor( Options.Defaults.window.backcolor1 )

	self.frame = Turbine.UI.Control()
	self.frame:SetParent( self.background1 )
	self.frame:SetBackColor( Options.Defaults.window.framecolor )

	self.background2 = Turbine.UI.Control()
	self.background2:SetParent( self.frame )
	self.background2:SetBackColor( Options.Defaults.window.backcolor2 )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.GeneralOptions:CreateContent()

	-- show tooltip
	self.show_tooltip_label = Turbine.UI.Label()
	self.show_tooltip_label:SetParent( self.background2 )
	self.show_tooltip_label:SetPosition( 0, Options.Defaults.window.g_content_top )
	self.show_tooltip_label:SetSize( 70, 32 )
	self.show_tooltip_label:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight )
	self.show_tooltip_label:SetFont( Options.Defaults.window.font )
	Options.Elements.Tooltip.AddTooltip( self.show_tooltip_label, "tooltip", "TODO", false )

	self.show_tooltip_checkbox = Options.Elements.CheckBox()
	self.show_tooltip_checkbox:SetParent( self.background2 )
	self.show_tooltip_checkbox:SetPosition( 80, Options.Defaults.window.g_content_top )
	self.show_tooltip_checkbox:SetChecked( Data.showTooltips )
	function self.show_tooltip_checkbox:CheckedChanged( value )
		Options.ShowTooltipChanged( value )
	end

	self.seperator = Turbine.UI.Control()
	self.seperator:SetParent( self.background2 )
	self.seperator:SetBackColor( Options.Defaults.window.framecolor )
	self.seperator:SetWidth( Options.Defaults.window.frame )

	-- language
	self.language_label = Turbine.UI.Label()
	self.language_label:SetParent( self.background2 )
	self.language_label:SetPosition( 100, Options.Defaults.window.g_content_top )
	self.language_label:SetSize( 68, 32 )
	self.language_label:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight )
	self.language_label:SetFont( Options.Defaults.window.font )
	Options.Elements.Tooltip.AddTooltip( self.language_label, "tooltip", "TODO", false )

	self.language_placeholder = Turbine.UI.Control()
	self.language_placeholder:SetParent( self.background2 )
	self.language_placeholder:SetPosition( 173, Options.Defaults.window.g_content_top + 5 )

	self.language_dropdown = Options.Elements.Dropdown( 50 )
	-- self.language_dropdown:SetParent( self.background2 )
	self.language_dropdown:SetPosition( 173, Options.Defaults.window.g_content_top + 5 )
	self.language_dropdown:SetZOrder(1)

	self.language_dropdown:AddItem( "general", "english", Language.English )
	self.language_dropdown:AddItem( "general", "german", Language.German )
	self.language_dropdown:AddItem( "general", "french", Language.French )

	self.language_dropdown:SetSelection( Data.options.language )
	self.language_dropdown.SelectionChanged = function ( sender, index, value )
		
		Options.LanguageChanged( value )

	end

end
---------------------------------------------------------------------------------------------------
