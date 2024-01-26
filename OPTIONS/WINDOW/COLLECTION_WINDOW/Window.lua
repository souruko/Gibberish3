--=================================================================================================
--= collection window
--= ===============================================================================================
--= 
--=================================================================================================



Options.Elements.CollectionWindow = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function Options.Elements.CollectionWindow:Constructor()
	Turbine.UI.Control.Constructor( self )

	self:CreateBackground()
	self:CreateToolbar()

	self.skill_segment = SegmentItem( self.listbox:GetWidth(), "segment", "skills", self, 1 )
	self:FillSkillSegment()
	self.listbox:AddItem( self.skill_segment )

	self.effect_segment = SegmentItem( self.listbox:GetWidth(), "segment", "effects", self, 2 )
	self.listbox:AddItem( self.effect_segment )

	self.chat_segment = SegmentItem( self.listbox:GetWidth(), "segment", "chat", self, 3 )
	self.listbox:AddItem( self.chat_segment )

	-- if Data.options.window.collection_segment == 1 then
	-- 	self:SegmentClicked( self.skill_segment )

	-- elseif Data.options.window.collection_segment == 2 then
	-- 	self:SegmentClicked( self.effect_segment )
		
	-- elseif Data.options.window.collection_segment == 3 then
	-- 	self:SegmentClicked( self.chat_segment )
	-- end


end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.CollectionWindow:FillSkillSegment()

	local list = {}

	local listOfSkills = LocalPlayer:GetTrainedSkills()

    for i = 1, listOfSkills:GetCount(), 1 do

		local index = #list + 1
        local skill = listOfSkills:GetItem(i):GetSkillInfo()

		list[ index ] = {}
		list[ index ].token = skill:GetName()
		list[ index ].icon = skill:GetIconImageID()

	end

	self.skill_segment:SetList( list )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.CollectionWindow:LanguageChanged()

	self.chat_label:SetText( UTILS.GetText( "collection", "effects" ) )
	self.effects_label:SetText(  UTILS.GetText( "collection", "chat" ) )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.CollectionWindow:SegmentClicked( item )

	local skill_clicked  = (item == self.skill_segment)
	local effect_clicked = (item == self.effect_segment)
	local chat_clicked   = (item == self.chat_segment)

	local height = self.listbox:GetHeight() - 2*Options.Defaults.window.segment_height

	self.skill_segment:Open( skill_clicked, height )
	self.effect_segment:Open( effect_clicked, height )
	self.chat_segment:Open( chat_clicked, height )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.CollectionWindow:SelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.CollectionWindow:SizeChanged()

	local width, height = self:GetSize()

	-- calclulate size
	local background1_width  = width - ( 2 * Options.Defaults.window.spacing )
	local background1_height = height - ( 2 * Options.Defaults.window.spacing )

	local frame_width        = background1_width - ( 2 * Options.Defaults.window.spacing )
	local frame_height       = background1_height - ( 2 * Options.Defaults.window.spacing )

	local listbox_width  = frame_width - ( 2 * Options.Defaults.window.frame )
	local listbox_height = frame_height - ( 5 * Options.Defaults.window.frame ) - ( 3 * Options.Defaults.window.toolbar_height )

	local filter_width       = listbox_width - Options.Defaults.window.frame - Options.Defaults.window.toolbar_height

	-- set size
	self.background1:SetSize( background1_width, background1_height )
	self.frame:SetSize( frame_width, frame_height )
	self.listbox:SetSize( listbox_width, listbox_height )

	self.filter_back:SetSize( filter_width, Options.Defaults.window.toolbar_height )
    self.filter:SetSize( filter_width, Options.Defaults.window.toolbar_height )
	self.filter_icon:SetSize( Options.Defaults.window.toolbar_height, Options.Defaults.window.toolbar_height )
	self.collaps_back:SetSize( Options.Defaults.window.toolbar_height, Options.Defaults.window.toolbar_height)

	self.effects_back:SetSize( listbox_width, Options.Defaults.window.toolbar_height )
	self.effects_button:SetSize( Options.Defaults.window.toolbar_height, Options.Defaults.window.toolbar_height )
	self.effects_label:SetHeight( Options.Defaults.window.toolbar_height )
	self.chat_back:SetSize( listbox_width, Options.Defaults.window.toolbar_height )
	self.chat_button:SetSize( Options.Defaults.window.toolbar_height, Options.Defaults.window.toolbar_height )
	self.chat_label:SetHeight( Options.Defaults.window.toolbar_height )

	-- calculate position
	local background1_pos    =  Options.Defaults.window.spacing
	local frame_pos          =  Options.Defaults.window.spacing
	local listbox_left   = Options.Defaults.window.frame
	local listbox_top    =  2 * Options.Defaults.window.frame + Options.Defaults.window.toolbar_height
	local filter_left        = Options.Defaults.window.frame
	local collaps_left       = frame_width - Options.Defaults.window.toolbar_height - Options.Defaults.window.frame

	-- set position
	self.background1:SetPosition( background1_pos, background1_pos )
	self.frame:SetPosition( frame_pos, frame_pos )
	self.listbox:SetPosition( listbox_left, listbox_top )

	self.filter_back:SetPosition( filter_left, Options.Defaults.window.frame )
	self.filter_clear:SetPosition( filter_width - 30, -3 )
	self.collaps_back:SetPosition( collaps_left, Options.Defaults.window.frame )

	self.effects_back:SetPosition( Options.Defaults.window.frame, frame_height - 2 * ( Options.Defaults.window.frame + Options.Defaults.window.toolbar_height ) )
	self.chat_back:SetPosition( Options.Defaults.window.frame, frame_height - Options.Defaults.window.frame - Options.Defaults.window.toolbar_height )

	self.effect_segment:SetWidth( listbox_width )
	self.chat_segment:SetWidth( listbox_width )
	self.skill_segment:SetWidth( listbox_width )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.CollectionWindow:FilterFocusChanged( value )

	if value == true then
		self.filter_icon:SetVisible( false )

	elseif self.filterText == "" then
		self.filter_icon:SetVisible( true )

	end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.CollectionWindow:CreateBackground()

	self:SetBackColor( Options.Defaults.window.basecolor )

	self.background1 = Turbine.UI.Control()
	self.background1:SetParent( self )
	self.background1:SetBackColor( Options.Defaults.window.backcolor1 )

	self.frame = Turbine.UI.Control()
	self.frame:SetParent( self.background1 )
	self.frame:SetBackColor( Options.Defaults.window.framecolor )

	self.listbox = Turbine.UI.ListBox()
	self.listbox:SetParent( self.frame )
	self.listbox:SetBackColor( Options.Defaults.window.backcolor2 )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.CollectionWindow:CreateToolbar()

	-- filter
	self.filter_back = Turbine.UI.Control()
	self.filter_back:SetParent( self.frame )
	self.filter_back:SetBackColor( Options.Defaults.window.backcolor2 )

	self.filter = Turbine.UI.TextBox()
    self.filter:SetParent( self.filter_back )
	self.filter:SetLeft( 4 )
    self.filter:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft )
	self.filter:SetForeColor( Options.Defaults.window.textcolor )
    self.filter:SetMultiline( false )
	self.filter:SetSelectable( true )
    self.filter:SetFont( Options.Defaults.window.font )
	self.filter.FocusGained = function (sender, args)
		self:FilterFocusChanged(true)
	end
	self.filter.FocusLost = function (sender, args)
		self:FilterFocusChanged(false)
	end
	self.filter.TextChanged = function (sender, args)
		self.filterText = string.lower(self.filter:GetText())

		if self.filterText == "" then
			self.filter_clear:SetVisible(false)
		else
			self.filter_clear:SetVisible(true)
		end
	end

	self.filter_icon = Turbine.UI.Control()
	self.filter_icon:SetParent( self.filter )
	self.filter_icon:SetPosition( -4, -3 )
	self.filter_icon:SetBlendMode(Turbine.UI.BlendMode.Overlay)
	self.filter_icon:SetBackground("Gibberish3/Resources/search30.tga")
	self.filter_icon:SetMouseVisible(false)

	self.filter_clear = Turbine.UI.Button()
	self.filter_clear:SetSize( 32, 32 )
	self.filter_clear:SetParent( self.filter )
	self.filter_clear:SetBlendMode(Turbine.UI.BlendMode.Overlay)
	self.filter_clear:SetBackground("Gibberish3/Resources/cross.tga")
	self.filter_clear:SetVisible(false)
	self.filter_clear.MouseClick = function ()
		self.filter:SetText("")
		self.filterText = ""
		self.filter_clear:SetVisible(false)
		self:FilterFocusChanged( false )
	end

	-- collaps
	self.collaps_back = Turbine.UI.Control()
	self.collaps_back:SetParent( self.frame )
	self.collaps_back:SetBackColor( Options.Defaults.window.backcolor2 )
	
	self.collaps_button = Turbine.UI.Button()
	self.collaps_button:SetParent( self.collaps_back )
	self.collaps_button:SetBlendMode( Turbine.UI.BlendMode.Overlay )
	self.collaps_button:SetBackground( "Gibberish3/RESOURCES/collaps.tga" )
	self.collaps_button:SetPosition( -3, -3 )
	Options.Elements.Tooltip.AddTooltip( self.collaps_button, "tooltip", "collaps", true )

	-- effects
	self.effects_back = Turbine.UI.Control()
	self.effects_back:SetParent( self.frame )
	self.effects_back:SetBackColor( Options.Defaults.window.backcolor2 )

	self.effects_button = Turbine.UI.Button()
	self.effects_button:SetParent( self.effects_back )
	self.effects_button:SetPosition( -3, -3 )
	self.effects_button:SetBlendMode(Turbine.UI.BlendMode.Overlay)
	self.effects_button:SetBackground("Gibberish3/RESOURCES/play.tga")
	self.effects_button.MouseClick = function (sender, args)
		Options.CollectEffects = not( Options.CollectEffects )
		if  Options.CollectEffects then
			self.effects_button:SetBackground("Gibberish3/RESOURCES/stop.tga")
			self.effects_back:SetBackColor( Options.Defaults.window.collecting )
		else
			self.effects_button:SetBackground("Gibberish3/RESOURCES/play.tga")
			self.effects_back:SetBackColor( Options.Defaults.window.backcolor1 )

		end
	end
	Options.Elements.Tooltip.AddTooltip( self.effects_button, "tooltip", "TODO", true )

	self.effects_label = Turbine.UI.Label()
	self.effects_label:SetParent( self.effects_back )
	self.effects_label:SetLeft( 45 )
	self.effects_label:SetFont( Options.Defaults.window.font )
	self.effects_label:SetForeColor( Options.Defaults.window.textcolor )
	self.effects_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)

	self.effects_checkbox = Options.Elements.CheckBox()
	self.effects_checkbox:SetParent( self.effects_back )
	self.effects_checkbox:SetPosition( 143 , - 3 )
	Options.Elements.Tooltip.AddTooltip( self.effects_checkbox, "tooltip", "TODO", true )

	-- chat
	self.chat_back = Turbine.UI.Control()
	self.chat_back:SetParent( self.frame )
	self.chat_back:SetBackColor( Options.Defaults.window.backcolor2 )

	self.chat_button = Turbine.UI.Button()
	self.chat_button:SetParent( self.chat_back )
	self.chat_button:SetPosition( -3, -3 )
	self.chat_button:SetBlendMode(Turbine.UI.BlendMode.Overlay)
	self.chat_button:SetBackground("Gibberish3/RESOURCES/play.tga")
	self.chat_button.MouseClick = function (sender, args)
		Options.CollectChat = not( Options.CollectChat )
		if Options.CollectChat then
			self.chat_button:SetBackground("Gibberish3/RESOURCES/stop.tga")
			self.chat_back:SetBackColor( Options.Defaults.window.collecting )
		else
			self.chat_button:SetBackground("Gibberish3/RESOURCES/play.tga")
			self.chat_back:SetBackColor( Options.Defaults.window.backcolor1 )

		end
	end
	Options.Elements.Tooltip.AddTooltip( self.chat_button, "tooltip", "TODO", true )

	self.chat_label = Turbine.UI.Label()
	self.chat_label:SetParent( self.chat_back )
	self.chat_label:SetLeft( 45 )
	self.chat_label:SetFont( Options.Defaults.window.font )
	self.chat_label:SetForeColor( Options.Defaults.window.textcolor )
	self.chat_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)

	self.chat_checkbox = Options.Elements.CheckBox()
	self.chat_checkbox:SetParent( self.chat_back )
	self.chat_checkbox:SetPosition( 143 , - 3 )
	Options.Elements.Tooltip.AddTooltip( self.chat_checkbox, "tooltip", "TODO", true )

end
---------------------------------------------------------------------------------------------------

