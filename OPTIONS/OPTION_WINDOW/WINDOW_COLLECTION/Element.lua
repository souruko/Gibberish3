--===================================================================================
--             Name:    Window Options
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
Options.Constructor.WindowCollection = class(Turbine.UI.Control)





-------------------------------------------------------------------------------------
--      Description:    Window Options constructor
-------------------------------------------------------------------------------------
function Options.Constructor.WindowCollection:Constructor( parent )
	Turbine.UI.Control.Constructor( self )

	-------------------------------------------------------------------------------------
	-- dimensions
	self.width = 210

    local left  = 1075
    local top   = 35
	
	local frame_thickness = 2

	local left_background = 5
	local left_frame = 5
	local left_label = 45
	local left_checkBox = 150

	local top_background  = 5
	local top_frame = 5
	local top_list = 34

	local width_background = self.width - 10
	local width_frame = width_background - 10
	local width_content = width_frame - 4

	local height_search = 30

	-------------------------------------------------------------------------------------
	-- children

	-------------------------------------------------------------------------------------
	-- background
    self.background = Turbine.UI.Control()
    self.background:SetParent( self )
    self.background:SetPosition( left_background, top_background )
    self.background:SetBackColor( Defaults.Colors.BackgroundColor2 )
    self.background:SetMouseVisible( false )
    self.background:SetWidth( width_background )

	-------------------------------------------------------------------------------------
	--  frame  
	self.frame                        = Turbine.UI.Control()
	self.frame:SetParent(               self.background )
	self.frame:SetPosition(             left_frame, top_frame )
	self.frame:SetBackColor(            Defaults.Colors.FrameColor )
	self.frame:SetMouseVisible(         false )
	self.frame:SetWidth(                width_frame )

	-------------------------------------------------------------------------------------
	--  serachBoxBox
	self.back_Search                    = Turbine.UI.Control()
	self.back_Search:SetParent(           self.frame )
	self.back_Search:SetPosition(         frame_thickness, frame_thickness )
	self.back_Search:SetSize(             width_content, height_search)
	self.back_Search:SetBackColor(       Defaults.Colors.BackgroundColor2 )
	self.back_Search:SetMouseVisible(false)

	-------------------------------------------------------------------------------------
	self.searchText = ""

	self.textBox_Search                    = Turbine.UI.TextBox()
	self.textBox_Search:SetParent(           self.back_Search )
	self.textBox_Search:SetPosition(4,1)
	self.textBox_Search:SetSize(             width_content - 8, 28)
	self.textBox_Search:SetTextAlignment(    Turbine.UI.ContentAlignment.MiddleLeft)
	self.textBox_Search:SetMultiline(        false)
	self.textBox_Search:SetFont(             Defaults.Fonts.TabFont )
	self.textBox_Search.FocusGained = function (sender, args)
		self.icon_Search:SetVisible(false)
	end
	self.textBox_Search.FocusLost = function (sender, args)
		self.icon_Search:SetVisible(true)
	end


	-------------------------------------------------------------------------------------
	-- new file
	self.icon_Search                    = Turbine.UI.Control()
	self.icon_Search:SetParent(           self.textBox_Search )
	self.icon_Search:SetSize( height_search, height_search)
	self.icon_Search:SetLeft(-1)
	self.icon_Search:SetBlendMode(Turbine.UI.BlendMode.Overlay)
	self.icon_Search:SetBackground("Gibberish3/Resources/search30.tga")
	self.icon_Search:SetMouseVisible(false)

	-------------------------------------------------------------------------------------
	--  listbox  
	self.list                 = Turbine.UI.ListBox()
	self.list:SetParent(        self.frame )
	self.list:SetPosition(      frame_thickness, top_list )
	self.list:SetBackColor(     Defaults.Colors.BackgroundColor1 )
	self.list:SetWidth(         width_content )

	-------------------------------------------------------------------------------------
	--  listbox  
	self.back_Effect                 = Turbine.UI.Control()
	self.back_Effect:SetParent(        self.frame )
	self.back_Effect:SetLeft(      frame_thickness )
	self.back_Effect:SetBackColor(     Defaults.Colors.BackgroundColor1 )
	self.back_Effect:SetSize(         width_content, height_search )

	-------------------------------------------------------------------------------------
	self.button_Effect = Turbine.UI.Button()
	self.button_Effect:SetParent(        self.back_Effect )
	self.button_Effect:SetLeft( 0 )
	self.button_Effect:SetFont( Defaults.Fonts.MediumFont )
	self.button_Effect:SetSize( height_search, height_search )
	self.button_Effect:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
	self.button_Effect:SetBlendMode(Turbine.UI.BlendMode.Overlay)
	self.button_Effect:SetBackground("Gibberish3/RESOURCES/play.tga")
    Options.Constructor.Tooltip.AddTooltip(self.button_Effect, L[Language.Local].Tooltip.CollectEffects, true)
	self.button_Effect.MouseClick = function (sender, args)
		Options.Collection.CollectEffects = not(Options.Collection.CollectEffects)

		if  Options.Collection.CollectEffects then
			self.button_Effect:SetBackground("Gibberish3/RESOURCES/stop.tga")
			self.back_Effect:SetBackColor(    Defaults.Colors.Collecting )
		else
			self.button_Effect:SetBackground("Gibberish3/RESOURCES/play.tga")
			self.back_Effect:SetBackColor(    Defaults.Colors.BackgroundColor1 )

		end
	end

	-------------------------------------------------------------------------------------
	self.label_Effect = Turbine.UI.Label()
	self.label_Effect:SetParent(        self.back_Effect )
	self.label_Effect:SetLeft( left_label )
	self.label_Effect:SetFont( Defaults.Fonts.TabFont )
	self.label_Effect:SetForeColor( Defaults.Colors.FrameColor )
	self.label_Effect:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
	self.label_Effect:SetHeight( height_search )
	self.label_Effect:SetText(L[Language.Local].Options.effect)

	self.checkBox_Effect = Options.Constructor.CheckBox( self.back_Effect, function ()

    end )

	self.checkBox_Effect:SetLeft(left_checkBox)
    Options.Constructor.Tooltip.AddTooltip(self.checkBox_Effect, L[Language.Local].Tooltip.OnlyDebuffs, true)

	-------------------------------------------------------------------------------------
	--  listbox  
	self.back_Chat                 = Turbine.UI.Control()
	self.back_Chat:SetParent(        self.frame )
	self.back_Chat:SetLeft(      frame_thickness )
	self.back_Chat:SetBackColor(    Defaults.Colors.BackgroundColor1 )
	self.back_Chat:SetSize(         width_content, height_search )

	-------------------------------------------------------------------------------------
	self.button_Chat = Turbine.UI.Button()
	self.button_Chat:SetParent(        self.back_Chat )
	self.button_Chat:SetLeft( 0 )
	self.button_Chat:SetFont( Defaults.Fonts.MediumFont )
	self.button_Chat:SetSize( height_search, height_search )
	self.button_Chat:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
	self.button_Chat:SetBlendMode(Turbine.UI.BlendMode.Overlay)
	self.button_Chat:SetBackground("Gibberish3/RESOURCES/play.tga")
    Options.Constructor.Tooltip.AddTooltip(self.button_Chat, L[Language.Local].Tooltip.CollectChat, true)
	self.button_Chat.MouseClick = function (sender, args)
		Options.Collection.CollectChat = not(Options.Collection.CollectChat)

		if  Options.Collection.CollectChat then
			self.button_Chat:SetBackground("Gibberish3/RESOURCES/stop.tga")
			self.back_Chat:SetBackColor(    Defaults.Colors.Collecting )
		else
			self.button_Chat:SetBackground("Gibberish3/RESOURCES/play.tga")
			self.back_Chat:SetBackColor(    Defaults.Colors.BackgroundColor1 )

		end
	end

	-------------------------------------------------------------------------------------
	self.label_Chat = Turbine.UI.Label()
	self.label_Chat:SetParent(        self.back_Chat )
	self.label_Chat:SetLeft( left_label )
	self.label_Chat:SetFont( Defaults.Fonts.TabFont )
	self.label_Chat:SetForeColor( Defaults.Colors.FrameColor )
	self.label_Chat:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
	self.label_Chat:SetHeight( height_search )
	self.label_Chat:SetWidth(100)
	self.label_Chat:SetText(L[Language.Local].Options.chat)

	self.checkBox_Chat = Options.Constructor.CheckBox( self.back_Chat, function ()

    end )

	self.checkBox_Chat:SetLeft(left_checkBox)
    Options.Constructor.Tooltip.AddTooltip(self.checkBox_Chat, L[Language.Local].Tooltip.OnlySay, true)

	
	-------------------------------------------------------------------------------------
	-- self
	self:SetWidth(self.width)
	self:SetParent(parent)
    self:SetPosition( left, top )
    self:SetBackColor( Defaults.Colors.BackgroundColor )

end

-------------------------------------------------------------------------------------
--      Description:    size changed
-------------------------------------------------------------------------------------
function Options.Constructor.WindowCollection:SizeChanged()

	local height = self:GetHeight()

	local height_background = height - 10
	local height_frame = height_background - 10
	local height_list = height_frame - 100

	local top_effect = height_frame - 64
	local top_chat = height_frame - 32

	self.background:SetHeight( height_background )
	self.frame:SetHeight( height_frame )
	self.list:SetHeight( height_list )

	self.back_Effect:SetTop(top_effect)
	self.back_Chat:SetTop(top_chat)

end


-------------------------------------------------------------------------------------
--      Description:    selection changed
-------------------------------------------------------------------------------------
function Options.Constructor.WindowCollection:SelectionChanged()

end


-------------------------------------------------------------------------------------
--      Description:    finish
-------------------------------------------------------------------------------------
function Options.Constructor.WindowCollection:Finish()

end