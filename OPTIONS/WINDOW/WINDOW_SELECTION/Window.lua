--=================================================================================================
--= window selection
--= ===============================================================================================
--= 
--=================================================================================================



Options.Elements.WindowSelection = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function Options.Elements.WindowSelection:Constructor()
	Turbine.UI.Control.Constructor( self )

    self.filterText  = ""
	self.folderTable = {}
	self.windowTable = {}

	self.sortFunction =  function (itema, itemb)

        if itema.data.sortIndex < itemb.data.sortIndex then
            return true
        end
        return false

    end

	self:CreateBackground()
	self:CreateToolbar()
	self:CreateContent()

	self:FixElementHeight()
	self:FillContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.WindowSelection:ClearContent()

	self.listbox:ClearItems()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.WindowSelection:FillContent()

	self:ClearContent()

	for index, folderItem in ipairs( self.folderTable ) do

		-- if folder does not have parentfolder and machtes filter add to listbox
		if folderItem.data.folder == nil and folderItem:Filter( self.filterText ) then
			self.listbox:AddItem( folderItem )
		end
		
	end

	for index, windowItem in ipairs( self.windowTable ) do

		-- if window does not have parentfolder and machtes filter add to listbox
		if windowItem.data.folder == nil and windowItem:Filter( self.filterText ) then

			self.listbox:AddItem( windowItem )
		end
		
	end

	self:Sort()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.WindowSelection:ReFill()

	self:CreateWindowElements()
	self:CreateFolderElements()
	self:FixElementHeight()
	self:FillContent()
	
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.WindowSelection:CreateWindowElements()

	self.windowTable = {}

    for windowIndex, windowData in ipairs(Data.window) do
		self.windowTable[ windowIndex ] = WindowItem( self, windowData, windowIndex )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.WindowSelection:CreateFolderElements()

	for index, folderItem in ipairs(self.folderTable) do
		folderItem:ClearItems()
	end

	self.folderTable = {}

    for folderIndex, folderData in ipairs(Data.folder) do
		self.folderTable[ folderIndex ] = FolderItem( self, folderData, folderIndex )
    end

	self:AsignFolder()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.WindowSelection:AsignFolder()

	for index, folderItem in ipairs( self.folderTable ) do

		-- remove everything
		folderItem:ClearItems()

	end
	self.listbox:ClearItems()
	for index, folderItem in ipairs( self.folderTable ) do

		-- add sub folders
		for i, item in ipairs( self.folderTable ) do
			if item.data.folder == index then
				folderItem:AddItem( item )
			end
		end

		for i, item in ipairs( self.windowTable ) do
			if item.data.folder == index then

				folderItem:AddItem( item )
			end
		end

	end

	self:FixElementWidth()
	self:FixElementHeight()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.WindowSelection:FixElementWidth()

	local width = self.listbox:GetWidth()

	for index, folderItem in ipairs( self.folderTable ) do

		if folderItem.data.folder == nil then
			folderItem:Width( width )
		end

	end

	for index, windowItem in ipairs( self.windowTable ) do

		if windowItem.data.folder == nil then
			windowItem:Width( width )
		end

	end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.WindowSelection:FixElementHeight()

	local width = self.listbox:GetWidth()

	for index, folderItem in ipairs( self.folderTable ) do

		folderItem:Height()

	end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.WindowSelection:Sort()

    self.listbox:Sort( self.sortFunction )

	for index, folderItem in ipairs( self.folderTable ) do

		folderItem:Sort( self.sortFunction )

	end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.WindowSelection:LanguageChanged()
	for index, folderItem in ipairs( self.folderTable ) do
		folderItem:LanguageChanged()
	end
	for index, windowItem in ipairs( self.folderTable ) do
		windowItem:LanguageChanged()
	end
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.WindowSelection:NewFolderPressed()

	local name =  UTILS.GetText( "selection", "new_folder" ) .. tostring( Data.folder.lastID )
    local index = (-1) * Folder.New( name )
	self:CreateFolderElements()
	self:FixElementHeight()
	self:FillContent()
	Options.SelectionChanged( index )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.WindowSelection:NewWindowPressed( type )

	local name = UTILS.GetText( "selection", "new_window" ) .. tostring( Data.window.lastID )
    local index =  Window.New( name, type )
	Windows.EnabledChanged( index )

	self:CreateWindowElements()
	self:AsignFolder()
	self:FillContent()
	self:FixElementHeight()
	
	Options.SelectionChanged( index )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.WindowSelection:DataChanged( index )

	if index > 0 then
		for i, windowItem in ipairs( self.windowTable ) do
			if windowItem.index == index then
				windowItem:DataChanged()
			end
		end
	else
		for i, folderItem in ipairs( self.folderTable ) do
			if folderItem.index == index then
				folderItem:DataChanged()
			end
		end
	end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.WindowSelection:SelectionChanged()

	for index, folderItem in ipairs( self.folderTable ) do

		folderItem:SelectionChanged()

	end

	for index, windowItem in ipairs( self.windowTable ) do

		windowItem:SelectionChanged()

	end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.WindowSelection:SizeChanged()

	local width, height = self:GetSize()

	-- calclulate size
	local background1_width  = width - ( 2 * Options.Defaults.window.spacing )
	local background1_height = height - ( 2 * Options.Defaults.window.spacing )

	local frame_width        = background1_width - ( 2 * Options.Defaults.window.spacing )
	local frame_height       = background1_height - ( 2 * Options.Defaults.window.spacing )

	local background2_width  = frame_width - ( 2 * Options.Defaults.window.frame )
	local background2_height = frame_height - ( 3 * Options.Defaults.window.frame ) - Options.Defaults.window.toolbar_height

	local filter_width       = background2_width - ( 3 * Options.Defaults.window.toolbar_height ) - ( 3 * Options.Defaults.window.frame )

	-- set size
	self.background1:SetSize( background1_width, background1_height )
	self.frame:SetSize( frame_width, frame_height )
	self.background2:SetSize( background2_width, background2_height )
	self.listbox:SetSize( background2_width, background2_height )
	self.scrollbar:SetSize( 10, background2_height )

	self.file_back:SetSize( Options.Defaults.window.toolbar_height, Options.Defaults.window.toolbar_height)
	self.dir_back:SetSize( Options.Defaults.window.toolbar_height, Options.Defaults.window.toolbar_height)
	self.filter_back:SetSize( filter_width, Options.Defaults.window.toolbar_height )
    self.filter:SetSize( filter_width, Options.Defaults.window.toolbar_height )
	self.filter_icon:SetSize( Options.Defaults.window.toolbar_height, Options.Defaults.window.toolbar_height )
	self.collaps_back:SetSize( Options.Defaults.window.toolbar_height, Options.Defaults.window.toolbar_height)

	-- calclulate position
	local background1_pos    = Options.Defaults.window.spacing
	local frame_pos          =  Options.Defaults.window.spacing
	local background2_top    =  2 * Options.Defaults.window.frame + Options.Defaults.window.toolbar_height
	local background2_left   = Options.Defaults.window.frame
	local dir_left           = background2_left + Options.Defaults.window.frame + Options.Defaults.window.toolbar_height
	local filter_left        = dir_left + Options.Defaults.window.frame + Options.Defaults.window.toolbar_height
	local collaps_left       = frame_width - Options.Defaults.window.toolbar_height - Options.Defaults.window.frame
	local scroll_left        = frame_width - 10
	local scroll_top         = Options.Defaults.window.toolbar_height + 2 * Options.Defaults.window.frame

	-- set position
	self.background1:SetPosition( background1_pos, background1_pos )
	self.frame:SetPosition( frame_pos, frame_pos )
	self.background2:SetPosition( background2_left, background2_top )
	
	self.file_back:SetPosition( Options.Defaults.window.frame, Options.Defaults.window.frame )
	self.dir_back:SetPosition( dir_left, Options.Defaults.window.frame )
	self.filter_back:SetPosition( filter_left, Options.Defaults.window.frame )
	self.filter_clear:SetPosition( filter_width - 30, 0 )
	self.collaps_back:SetPosition( collaps_left, Options.Defaults.window.frame )
	self.scrollbar:SetPosition( scroll_left, scroll_top )

	self:FixElementWidth()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.WindowSelection:FilterFocusChanged( value )

	if value == true then
		self.filter_icon:SetVisible( false )

	elseif self.filterText == "" then
		self.filter_icon:SetVisible( true )

	end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.WindowSelection:CreateContent()

	self.listbox = Turbine.UI.ListBox()
	self.listbox:SetParent( self.background2 )

	self.scrollbar = Turbine.UI.Lotro.ScrollBar()
	self.scrollbar:SetParent( self.frame )
    self.scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical)
	self.scrollbar:SetBackColor( Options.Defaults.window.framecolor )

    self.listbox:SetVerticalScrollBar( self.scrollbar )

	self:CreateWindowElements()
	self:CreateFolderElements()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.WindowSelection:CreateBackground()

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
function Options.Elements.WindowSelection:CreateToolbar()

	-- new file button
    self.file_menu = Options.Elements.RightClickMenu( Options.Defaults.window.file_width )

    for key, value in pairs(Window.Types) do

		local item = Options.Elements.Row( "windowType", value, function ()
			self:NewWindowPressed( value )
		end,
		Options.Defaults.rc_menu.item_height)
		self.file_menu:AddRow( item )

	end

	self.file_back = Turbine.UI.Control()
	self.file_back:SetParent( self.frame )
	self.file_back:SetBackColor( Options.Defaults.window.backcolor2 )

	self.file_button = Turbine.UI.Button()
	self.file_button:SetParent( self.file_back )
	self.file_button:SetBlendMode( Turbine.UI.BlendMode.Overlay )
	self.file_button:SetBackground( "Gibberish3/RESOURCES/file_new.tga" )
	self.file_button:SetPosition( 0, 0 )
	self.file_button.MouseClick = function ()
		local left, top = self.file_back:PointToScreen(0, Options.Defaults.window.toolbar_height + Options.Defaults.window.frame )
		self.file_menu:Show( left, top )
	end
	Options.Elements.Tooltip.AddTooltip( self.file_button, "tooltip", "button_new_window", false )

	-- new folder button
	self.dir_back = Turbine.UI.Control()
	self.dir_back:SetParent( self.frame )
	self.dir_back:SetBackColor( Options.Defaults.window.backcolor2 )

	self.dir_button = Turbine.UI.Button()
	self.dir_button:SetParent( self.dir_back )
	self.dir_button:SetBlendMode( Turbine.UI.BlendMode.Overlay )
	self.dir_button:SetBackground( "Gibberish3/RESOURCES/dir_new.tga" )
	self.dir_button:SetPosition( 0, 1 )
	self.dir_button.MouseClick = function ()
		self:NewFolderPressed()
	end
	Options.Elements.Tooltip.AddTooltip( self.dir_button, "tooltip", "button_new_folder", false )

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

		self:FillContent()
	end

	self.filter_icon = Turbine.UI.Control()
	self.filter_icon:SetParent( self.filter )
	self.filter_icon:SetPosition( -2, 0 )
	self.filter_icon:SetBlendMode(Turbine.UI.BlendMode.Overlay)
	self.filter_icon:SetBackground("Gibberish3/Resources/search.tga")
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
		self:FillContent()
	end

	-- collaps
	self.collaps_back = Turbine.UI.Control()
	self.collaps_back:SetParent( self.frame )
	self.collaps_back:SetBackColor( Options.Defaults.window.backcolor2 )
	
	self.collaps_button = Turbine.UI.Button()
	self.collaps_button:SetParent( self.collaps_back )
	self.collaps_button:SetBlendMode( Turbine.UI.BlendMode.Overlay )
	self.collaps_button:SetBackground( "Gibberish3/RESOURCES/collaps.tga" )
	self.collaps_button:SetPosition( 0, 0 )
	self.collaps_button.MouseClick = function ()
		self:CollapsButtonPressed()
	end
	Options.Elements.Tooltip.AddTooltip( self.collaps_button, "tooltip", "button_collaps", false )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.WindowSelection:CollapsButtonPressed()

	for index, folderItem in ipairs( self.folderTable ) do
		folderItem:CollapsChanged( true )
	end
	self:FixElementHeight()
	
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.WindowSelection:ShowExport( data, type, index )
	self:GetParent():ShowExport( data, type, index )
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.WindowSelection:DraggingEnd( fromData )

	local left, top = self.listbox:GetMousePosition()

	local toItem = self.listbox:GetItemAt(left, top)

	-- mouse is over child
	if toItem ~= nil and fromData ~= toItem.data then

		toItem:DraggingEnd( fromData )
		self:AsignFolder()
		self:FillContent()

	-- remove item from all folders
	elseif toItem == nil
	    and left >= 0 and left <= self.listbox:GetWidth()
		and top >= 0 and top <= self.listbox:GetHeight() then

			fromData.folder = nil
			Data.lastSortIndex = Data.lastSortIndex + 1
			fromData.sortIndex = Data.lastSortIndex
			self:AsignFolder()
			self:FillContent()
	end

end
---------------------------------------------------------------------------------------------------
