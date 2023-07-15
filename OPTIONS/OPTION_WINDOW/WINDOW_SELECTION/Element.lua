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

	local left_background = 3
	local left_frame = 5
	local left_newFolder = 34
	local left_searchBox = 66
	local left_collaps = 248
	local left_scroll = self.width - 34

	local top_background  = 5
	local top_frame = 5
	local top_list = 34

	local width_background = self.width - 10
	local width_frame = width_background - 10
	local width_searchBox = 180
	local width_list = self.width - 24
	self.content_width = width_list

	local height_toolbar = 30

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
    self.newFileMenu = Options.Constructor.RightClickMenu(100)

    for key, value in pairs(Group.Types) do
            
        self.newFileMenu:AddRow( key, function ()
            self:NewGroup(value)
        end)

    end

    self.button_NewFile                        = Turbine.UI.Button()
    self.button_NewFile:SetParent(               self.frame )
    self.button_NewFile:SetPosition(             frame_thickness, frame_thickness )
    self.button_NewFile:SetBackColor(            Defaults.Colors.BackgroundColor2 )
    self.button_NewFile:SetSize(                height_toolbar, height_toolbar )
    Options.Constructor.Tooltip.AddTooltip(self.button_NewFile, L[Language.Local].Tooltip.NewGroup, true)
	self.button_NewFile.Click =function (sender, args)

        self.newFileMenu:Show(nil, nil, true)

	end

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
	self.button_NewFolder:SetSize(                height_toolbar, height_toolbar )
    Options.Constructor.Tooltip.AddTooltip(self.button_NewFolder, L[Language.Local].Tooltip.NewFolder, true)
	self.button_NewFolder.Click =function (sender, args)

		self:NewFolder()
	
	end

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
	self.textBox_Search:SetSelectable(true)
    self.textBox_Search:SetFont(             Defaults.Fonts.TabFont )
	self.textBox_Search.FocusGained = function (sender, args)
		self:SearchFocusChanged(true)
	end
	self.textBox_Search.FocusLost = function (sender, args)
		self:SearchFocusChanged(false)
	end
	self.textBox_Search.TextChanged = function (sender, args)
		self.searchText = string.lower(self.textBox_Search:GetText())

		if self.searchText == "" then
			self.icon_Clear:SetVisible(false)
		else
			self.icon_Clear:SetVisible(true)
		end

		self:FillContent()

	end

	-- icon search
	self.icon_Search                    = Turbine.UI.Control()
	self.icon_Search:SetParent(           self.textBox_Search )
	self.icon_Search:SetSize( height_toolbar, height_toolbar)
	self.icon_Search:SetLeft(-1)
	self.icon_Search:SetBlendMode(Turbine.UI.BlendMode.Overlay)
	self.icon_Search:SetBackground("Gibberish3/Resources/search30.tga")
	self.icon_Search:SetMouseVisible(false)

	-- icon clear search
	self.icon_Clear                    = Turbine.UI.Control()
	self.icon_Clear:SetSize( 32, 32)
	self.icon_Clear:SetParent(           self.textBox_Search )
	self.icon_Clear:SetLeft( width_searchBox - 32 )
	self.icon_Clear:SetBlendMode(Turbine.UI.BlendMode.Overlay)
	self.icon_Clear:SetBackground("Gibberish3/Resources/cross.tga")
	self.icon_Clear:SetVisible(false)
	self.icon_Clear.MouseClick = function ()
		self.textBox_Search:SetText("")
		self.searchText = ""
		self.icon_Clear:SetVisible(false)
		
		self:FillContent()
	end

	-- new folder
	self.button_Collaps                        = Turbine.UI.Button()
	self.button_Collaps:SetParent(               self.frame )
	self.button_Collaps:SetPosition(             left_collaps, frame_thickness )
	self.button_Collaps:SetBackColor(            Defaults.Colors.BackgroundColor2 )
	self.button_Collaps:SetSize(                height_toolbar, height_toolbar )
    Options.Constructor.Tooltip.AddTooltip(self.button_Collaps, L[Language.Local].Tooltip.CollapsAll, true)
	self.button_Collaps.MouseClick = function ()
		self:CollapsAll()
	end


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
	self.list.ChildHeightChanged = function()
	end
		
    self.scroll = Turbine.UI.Lotro.ScrollBar()
    self.scroll:SetBackColor(Defaults.Colors.BackgroundColor6)
    self.scroll:SetOrientation(Turbine.UI.Orientation.Vertical)
    self.scroll:SetPosition( left_scroll, 0)
    self.scroll:SetParent(self.list)
    self.scroll:SetWidth(10)
    self.scroll:SetZOrder(50)
    self.list:SetVerticalScrollBar(self.scroll)

	-------------------------------------------------------------------------------------
	-- self
	self:SetWidth(self.width)
    self:SetPosition( left, top )
	self:SetParent(parent)
    self:SetBackColor( Defaults.Colors.BackgroundColor )


	--start up
	self:ResetContent()

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
	self.scroll:SetHeight( height_list )

end

-------------------------------------------------------------------------------------
--      Description:    selection changed
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:SearchFocusChanged( focus )

	if focus == true then

		self.icon_Search:SetVisible(false)

	else

		if self.searchText == "" then
			
			self.icon_Search:SetVisible(true)

		end

	end

end


-------------------------------------------------------------------------------------
--      Description:    selection changed
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:CreateItems()

    self.folderList = {}
    self.groupList = {}

    for groupIndex, groupData in ipairs(Data.group) do

        self.groupList[groupIndex] = GroupItem( self, groupData, groupIndex, self.content_width )
        
    end

    for folderIndex, folderData in ipairs(Data.folder) do

        self.folderList[folderIndex] = FolderItem( self, folderData, folderIndex, self.content_width )
  
    end

end


-------------------------------------------------------------------------------------
--      Description:    selection changed
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:FillContent()

	self.list:ClearItems()

	self:AsignFolder()

	-- fill folders
	for folderIndex, folderItem in ipairs(self.folderList) do
		
		-- only add the base level folders 
		if folderItem.data.folder == nil then

			if folderItem:MatchSearch(self.searchText) then
				self.list:AddItem(folderItem)
			end

		end

	end
	
	-- fill groups
	for groupIndex, groupItem in ipairs(self.groupList) do
		
		-- only add the base level groups 
		if groupItem.data.folder == nil then

			if groupItem:MatchSearch(self.searchText) then
				self.list:AddItem(groupItem)
			end

		end

	end

	self:Sort()

end


-------------------------------------------------------------------------------------
--      Description:    selection changed
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:AsignFolder()

	for folderIndex, folderItem in ipairs(self.folderList) do
		
		-- remove everything from folders
		folderItem:RemoveAllChildren()

		-- add folder to folders
		for index, item in ipairs(self.folderList) do

			if item.data.folder == folderIndex then

				if item:MatchSearch(self.searchText) then
					folderItem:AddChild(item)
				end
				
			end
			
		end
		
		-- add group to folders
		for index, item in ipairs(self.groupList) do
		
			if item.data.folder == folderIndex then

				if item:MatchSearch(self.searchText) then
					folderItem:AddChild(item)
				end
				
			end
			
		end

	end

	self:ChangeChildWidth()

end

-------------------------------------------------------------------------------------
--      Description:    fix item width
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:ChangeChildWidth()

	local width = self.list:GetWidth()

	for index, item in ipairs(self.folderList) do

		if item.data.folder == nil then

			item:ChangeWidth(width)
			
		end
		
	end
	
	for index, item in ipairs(self.groupList) do
	
		if item.data.folder == nil then

			item:ChangeWidth(width)
			
		end

	end


end



-------------------------------------------------------------------------------------
--      Description:    selection changed
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:SelectionChanged()

	for index, item in ipairs(self.groupList) do

		item:SelectionChanged()
		
	end

	for index, item in ipairs(self.folderList) do

		item:SelectionChanged()
		
	end

end



-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:Sort()

    self.list:Sort(function (itema, itemb)

        if itema.data.sortIndex < itemb.data.sortIndex then
            return true
        end
        return false

    end)

end

-------------------------------------------------------------------------------------
--      Description:    finish
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:DraggingEnd( fromData )

	local left, top = self.list:GetMousePosition()

	local toItem = self.list:GetItemAt(left, top)

	if toItem ~= nil and fromData ~= toItem.data then

		toItem:DraggingEnd( fromData )

	end


end

-------------------------------------------------------------------------------------
--      Description:    collaps all
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:CollapsAll()

	for index, folderItem in ipairs(self.folderList) do
		
		folderItem.data.collapsed = true
		folderItem:CollapsChanged()
		folderItem:GetParent():ChildHeightChanged()

	end

	Options.SaveData()

end



-------------------------------------------------------------------------------------
--      Description:    finish
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:Finish()

end

-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:NewFolder()

    Data.selectedGroupIndex = {}
    Data.selectedFolderIndex = {}
    Data.selectedFolderIndex[1] = Folder.New( L[Language.Local].Terms.NewFolder .. tostring(Data.folder.lastID) )

	self:ResetContent()

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:NewGroup(type)

    Data.selectedGroupIndex = {}
    Data.selectedFolderIndex = {}
    Data.selectedGroupIndex[1] = Group.New( L[Language.Local].Terms.NewGroup .. tostring(Data.group.lastID), type )

	self:ResetContent()

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:ResetContent()
	
	self:CreateItems()
	self:FillContent()
	self:SelectionChanged()

end