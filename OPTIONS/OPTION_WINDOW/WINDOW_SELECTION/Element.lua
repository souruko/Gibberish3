--===================================================================================
--             Name:    Window selection
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
Options.Constructor.WindowSelection = class( Turbine.UI.Control )





-------------------------------------------------------------------------------------
--      Description:    window selection constructor
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:Constructor( parent )
	Turbine.UI.Control.Constructor( self )

	self.folderList = {}
	self.groupList = {}


	-------------------------------------------------------------------------------------
	-- dimensions
	self.width = 300

    local left = 15
    local top   = 35

	local frame_thickness = 2

	local left_background = 5
	local left_frame = 5
	local left_newFolder = 34
	local left_searchBox = 66
	local left_collaps = 248

	local top_background  = 5
	local top_frame = 5
	local top_list = 34

	local width_background = self.width - 10
	local width_frame = width_background - 10
	local width_searchBox = 180
	local width_list = self.width - 24

	local height_toolbar = 30

	-------------------------------------------------------------------------------------
	-- self
	self:SetWidth(self.width)
    self:SetPosition( left, top )
	self:SetParent(parent)
    self:SetBackColor( Defaults.Colors.BackgroundColor )

	-------------------------------------------------------------------------------------
	-- children

	-- background
    self.background = Turbine.UI.Control()
    self.background:SetParent( self )
    self.background:SetPosition( left_background, top_background )
    self.background:SetBackColor( Defaults.Colors.BackgroundColor2 )
    self.background:SetMouseVisible( false )
    self.background:SetWidth( width_background )

	--  frame  
	self.frame                        = Turbine.UI.Control()
	self.frame:SetParent(               self.background )
	self.frame:SetPosition(             left_frame, top_frame )
	self.frame:SetBackColor(            Defaults.Colors.FrameColor )
	self.frame:SetMouseVisible(         false )
	self.frame:SetWidth(                width_frame )

	-- new file
    self.button_NewFile                        = Turbine.UI.Button()
    self.button_NewFile:SetParent(               self.frame )
    self.button_NewFile:SetPosition(             frame_thickness, frame_thickness )
    self.button_NewFile:SetBackColor(            Defaults.Colors.BackgroundColor2 )
    self.button_NewFile:SetMouseVisible(         false )
    self.button_NewFile:SetSize(                height_toolbar, height_toolbar )

	self.icon_NewFile                    = Turbine.UI.Control()
    self.icon_NewFile:SetParent(           self.button_NewFile )
    self.icon_NewFile:SetSize( 30, 30)
	self.icon_NewFile:SetLeft(-1)
    self.icon_NewFile:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    self.icon_NewFile:SetBackground("Gibberish3/Resources/file_new.tga")
	self.icon_NewFile:SetMouseVisible(false)

	-- new folder
	self.button_NewFolder                        = Turbine.UI.Button()
	self.button_NewFolder:SetParent(               self.frame )
	self.button_NewFolder:SetPosition(             left_newFolder, frame_thickness )
	self.button_NewFolder:SetBackColor(            Defaults.Colors.BackgroundColor2 )
	self.button_NewFolder:SetMouseVisible(         false )
	self.button_NewFolder:SetSize(                height_toolbar, height_toolbar )

	self.icon_NewFolder                    = Turbine.UI.Control()
	self.icon_NewFolder:SetParent(           self.button_NewFolder )
	self.icon_NewFolder:SetLeft(-1)
	self.icon_NewFolder:SetSize( 30, 30)
	self.icon_NewFolder:SetBlendMode(Turbine.UI.BlendMode.Overlay)
	self.icon_NewFolder:SetBackground("Gibberish3/Resources/dir_new.tga")
	self.icon_NewFolder:SetMouseVisible(false)

	--  serachBoxBox
	self.back_Search                    = Turbine.UI.Control()
	self.back_Search:SetParent(           self.frame )
    self.back_Search:SetPosition(         left_searchBox, frame_thickness )
    self.back_Search:SetSize(             width_searchBox, height_toolbar)
    self.back_Search:SetBackColor(       Defaults.Colors.BackgroundColor2 )
	self.back_Search:SetMouseVisible(false)

    self.searchText = ""

    self.textBox_Search                    = Turbine.UI.TextBox()
    self.textBox_Search:SetParent(           self.back_Search )
	self.textBox_Search:SetPosition(4,1)
    self.textBox_Search:SetSize(             width_searchBox - 8, 28)
    self.textBox_Search:SetTextAlignment(    Turbine.UI.ContentAlignment.MiddleLeft)
    self.textBox_Search:SetMultiline(        false)
    self.textBox_Search:SetFont(             Defaults.Fonts.TabFont )
	self.textBox_Search.FocusGained = function (sender, args)
		self.icon_Search:SetVisible(false)
	end
	self.textBox_Search.FocusLost = function (sender, args)
		self.icon_Search:SetVisible(true)
	end


	-- new file
	self.icon_Search                    = Turbine.UI.Control()
	self.icon_Search:SetParent(           self.textBox_Search )
	self.icon_Search:SetSize( height_toolbar, height_toolbar)
	self.icon_Search:SetLeft(-1)
	self.icon_Search:SetBlendMode(Turbine.UI.BlendMode.Overlay)
	self.icon_Search:SetBackground("Gibberish3/Resources/search30.tga")
	self.icon_Search:SetMouseVisible(false)


	-- new folder
	self.button_Collaps                        = Turbine.UI.Button()
	self.button_Collaps:SetParent(               self.frame )
	self.button_Collaps:SetPosition(             left_collaps, frame_thickness )
	self.button_Collaps:SetBackColor(            Defaults.Colors.BackgroundColor2 )
	self.button_Collaps:SetMouseVisible(         false )
	self.button_Collaps:SetSize(                height_toolbar, height_toolbar )

	self.icon_Collaps                    = Turbine.UI.Control()
	self.icon_Collaps:SetParent(           self.button_Collaps )
	self.icon_Collaps:SetLeft(-1)
	self.icon_Collaps:SetSize( 30, 30)
	self.icon_Collaps:SetBlendMode(Turbine.UI.BlendMode.Overlay)
	self.icon_Collaps:SetBackground("Gibberish3/Resources/collaps.tga")
	self.icon_Collaps:SetMouseVisible(false)

	--  listbox  
	self.list                 = Turbine.UI.ListBox()
	self.list:SetParent(        self.frame )
	self.list:SetPosition(      frame_thickness, top_list )
	self.list:SetBackColor(     Defaults.Colors.BackgroundColor1 )
	self.list:SetWidth(         width_list )

end

-------------------------------------------------------------------------------------
--      Description:    size changed
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:SizeChanged()

	local height = self:GetHeight()

	local height_background = height - 10
	local height_frame = height_background - 10
	local height_list = height_frame - 36

	self.background:SetHeight( height_background )
	self.frame:SetHeight( height_frame )
	self.list:SetHeight( height_list )

end


-------------------------------------------------------------------------------------
--      Description:    selection changed
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:SelectionChanged()

end


-------------------------------------------------------------------------------------
--      Description:    finish
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:Finish()

end