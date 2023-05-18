--===================================================================================
--             Name:    Window selection
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
Options.Constructor.WindowSelection = class( Turbine.UI.Control )





-------------------------------------------------------------------------------------
--      Description:    window selection constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent
--                      width
--                      height
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:Constructor( parent )
	Turbine.UI.Control.Constructor( self )

    self.folderList = {}
    self.groupList = {}

    self.currentFolderIndex = nil

    self.parent = parent
    self:SetParent(     parent)
    self:SetBackColor(  Defaults.Colors.BackgroundColor2 )

    local width                 = 300
    local background_pos        = 5
    local newButton_pos         = 10
    local heading_top           = 7
    local searchButton_left     = 70
    local collapsButton_width   = 24
    local collapsButton_height  = 24
    local collapsButton_top     = 12
    local frame_left            = 10
    local frame_top             = 40
    local content_left          = 12
    local serachBox_top         = 42
    local serachBox_width       = 300 - 24
    local serachBox_height      = 20
    local background_width      = width - 10
    local frame_width           = background_width - 10
    local list_width            = frame_width - 4
    local currentFolder_height  = 60
    local currentFolder_top     = serachBox_top + serachBox_height + 2

    self.content_width          = list_width


    local list_top              = 66 + currentFolder_height
    local heading_height        = 25


-------------------------------------------------------------------------------------
--  background  
    self.background                   = Turbine.UI.Control()
    self.background:SetParent(          self )
    self.background:SetPosition(        background_pos, background_pos )
    self.background:SetBackColor(       Defaults.Colors.BackgroundColor1 )
    self.background:SetMouseVisible(    false )
    self.background:SetWidth(           background_width )

-------------------------------------------------------------------------------------
--  new group / fodler  

    self.newFileButton                    = Turbine.UI.Button()
    self.newFileButton:SetParent(           self )
    self.newFileButton:SetFont(             Defaults.Fonts.ButtonFont )
    self.newFileButton:SetForeColor(        Turbine.UI.Color.White)
    self.newFileButton:SetPosition(         newButton_pos, newButton_pos - 2 )
    self.newFileButton:SetSize( 30, 30)
    self.newFileButton:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    self.newFileButton:SetBackground("Gibberish3/Resources/new_file.tga")

    self.newFolderButton                    = Turbine.UI.Button()
    self.newFolderButton:SetParent(           self )
    self.newFolderButton:SetFont(             Defaults.Fonts.ButtonFont )
    self.newFolderButton:SetForeColor(        Turbine.UI.Color.White)
    self.newFolderButton:SetPosition(         newButton_pos + 30, newButton_pos )
    self.newFolderButton:SetSize( 30, 30)
    self.newFolderButton:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    self.newFolderButton:SetBackground("Gibberish3/Resources/new_folder.tga")


-------------------------------------------------------------------------------------
--  heading
    self.headingLabel                 = Turbine.UI.Label()
    self.headingLabel:SetParent(        self )
    self.headingLabel:SetTop(           heading_top )
    self.headingLabel:SetWidth(         width )
    self.headingLabel:SetHeight(        heading_height )
    self.headingLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter )
    self.headingLabel:SetFont(          Defaults.Fonts.HeadingFont )
    self.headingLabel:SetText(          L[Language.Local].Headings.WindowSelection )
    self.headingLabel:SetMouseVisible(  false )


-------------------------------------------------------------------------------------
--  frame  
    self.frame                        = Turbine.UI.Control()
    self.frame:SetParent(               self )
    self.frame:SetPosition(             frame_left, frame_top )
    self.frame:SetBackColor(            Defaults.Colors.BackgroundColor6 )
    self.frame:SetMouseVisible(         false )
    self.frame:SetWidth(                frame_width )

-------------------------------------------------------------------------------------
--  serachBoxBox
    self.searchText = ""

    self.serachBox                    = Turbine.UI.Lotro.TextBox()
    self.serachBox:SetPosition(         content_left, serachBox_top )
    self.serachBox:SetParent(           self )
    self.serachBox:SetSize(             serachBox_width, serachBox_height)
    self.serachBox:SetTextAlignment(    Turbine.UI.ContentAlignment.MiddleLeft)
    self.serachBox:SetFont(             Defaults.Fonts.SmallFont )
    self.serachBox:SetForeColor(       Turbine.UI.Color.White)
    self.serachBox:SetText(             L[Language.Local].Text.SearchBoxDefault)

    self.serachBox.FocusGained = function(sender, args)
		if self.searchText == "" then
			self.serachBox:SetText("")
		end		
	end
	self.serachBox.FocusLost = function(sender, args)
		if self.searchText == "" then
			self.serachBox:SetText(L[Language.Local].Text.SearchBoxDefault )
		end
	end
	self.serachBox.TextChanged = function(sender, args)		
		self.searchText = string.lower(self.serachBox:GetText())
	end



-------------------------------------------------------------------------------------
--  listbox  
    self.list                 = Turbine.UI.ListBox()
    self.list:SetParent(        self)
    self.list:SetPosition(      content_left, list_top )
    self.list:SetBackColor(     Defaults.Colors.BackgroundColor1 )
    self.list:SetWidth(         list_width )



-------------------------------------------------------------------------------------
--  currentFolder
    self.currentFolder = Turbine.UI.Control()
    self.currentFolder:SetParent(           self )
    self.currentFolder:SetPosition(         content_left, currentFolder_top )
    self.currentFolder:SetSize(             self.content_width, currentFolder_height )
    self.currentFolder:SetBackColor(        Defaults.Colors.BackgroundColor2 )
    self.currentFolder.MouseLeave         = function ()
        self.currentFolder:SetBackColor(    Defaults.Colors.BackgroundColor2 )
    end
    self.currentFolder.MouseEnter         = function ()
        self.currentFolder:SetBackColor(    Defaults.Colors.BackgroundColor3 )
    end
    self.currentFolder.MouseClick         = function ( sender, args )

        if args.Button == Turbine.UI.MouseButton.Right then

            self.folderRightClick:Show(nil, nil, true)

        end

    end

-------------------------------------------------------------------------------------
--      export
    self.exportMenu                       = Options.Constructor.RightClickMenu(125)
    self.exportMenu:AddRow(                 "Group", function ()
        Turbine.Shell.WriteLine(            "group" )
    end)

    self.exportMenu:AddRow(                 "List of Timers", function ()
        
    end)

-------------------------------------------------------------------------------------
--      addToFolder
    self.addToMenu                        = Options.Constructor.RightClickMenu( 125 )

    for i, folder in ipairs(Data.folder) do

        self.addToMenu:AddRow( folder.name, function ()
            
        end)
        
    end



-------------------------------------------------------------------------------------
--      right click
    self.folderRightClick                 = Options.Constructor.RightClickMenu(125)

    self.folderRightClick:AddSubMenuRow(    "Export", self.exportMenu )

    self.folderRightClick:AddSeperator()

    self.folderRightClick:AddSubMenuRow(    "Move to Folder", self.addToMenu )

    self.folderRightClick:AddSeperator()

    self.folderRightClick:AddRow(           "Move", function ()

    end)

    self.folderRightClick:AddRow(           "Delete", function ()
        
    end)

    self.folderRightClick:AddSeperator()

    self.folderRightClick:AddRow(           "Cut", function ()
        
    end)

    self.folderRightClick:AddRow(           "Copy", function ()
        
    end)

    self.folderRightClick:AddRow(           "Past", function ()
        
    end)


    self.currentFolder.backButton             = Turbine.UI.Button()
    self.currentFolder.backButton:SetParent(    self.currentFolder )
    self.currentFolder.backButton.MouseClick  = function (sender, args )

        if self.currentFolderIndex == nil then
            return
        end

        self:OpenFolder(                            Data.folder[self.currentFolderIndex].parent )
        
    end
    
    self.currentFolder.backButton:SetSize(          30, 30 )
    self.currentFolder.backButton:SetPosition(      5, 3 )
    self.currentFolder.backButton:SetBlendMode( Turbine.UI.BlendMode.Overlay )
    self.currentFolder.backButton:SetBackground( "Gibberish3/Resources/back.tga" )


    self.currentFolder.enabledCheckBox = Options.Constructor.CheckBox( self.currentFolder, function ()
        
    end )
    self.currentFolder.enabledCheckBox:SetPosition( self.content_width - 40, 5 )

    self.currentFolder.nameLabel                  = Turbine.UI.Label()
    self.currentFolder.nameLabel:SetParent(         self.currentFolder )
    self.currentFolder.nameLabel:SetSize(           self.currentFolder:GetSize() )
    self.currentFolder.nameLabel:SetTextAlignment(  Turbine.UI.ContentAlignment.MiddleCenter )
    self.currentFolder.nameLabel:SetFont(           Defaults.Fonts.HeadingFont )
    self.currentFolder.nameLabel:SetMouseVisible(   false )


-------------------------------------------------------------------------------------
--  getting started

    self:CreateItems()
    self:FillContent()

end


-------------------------------------------------------------------------------------
--      Description:    finish and close window
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:CreateItems()

    self.folderList = {}
    self.groupList = {}


    for i, folderData in ipairs(Data.folder) do

        self.folderList[i] = FolderItem( self, folderData, i, self.content_width )
        
    end

    for j, groupData in ipairs(Data.group) do

        self.groupList[j] = GroupItem( self, groupData, j, self.content_width )

    end

end


-------------------------------------------------------------------------------------
--      Description:    finish and close window
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:FillContent()

    self.list:ClearItems()

    for i, folder in ipairs(self.folderList) do

        if folder.folderData.parent == self.currentFolderIndex then
            
            self.list:AddItem( folder )

        end
        
    end
    
    for j, group in ipairs(self.groupList) do

        if group.groupData.folder == self.currentFolderIndex then

            self.list:AddItem( group )

        end
        
    end

    if  self.currentFolderIndex == nil then
        self.currentFolder.nameLabel:SetText( "" )
        self.currentFolder.backButton:SetVisible(false)
    else
        self.currentFolder.nameLabel:SetText( Data.folder[self.currentFolderIndex].name )
        self.currentFolder.backButton:SetVisible(true)
    end


end


-------------------------------------------------------------------------------------
--      Description:    open folder
-------------------------------------------------------------------------------------
--        Parameter:    folderIndex
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:OpenFolder( index )

    self.currentFolderIndex = index

    self:FillContent()

end



-------------------------------------------------------------------------------------
--      Description:    finish and close window
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:Finish()

    self:SetVisible(false)

    self:Close()

end



-------------------------------------------------------------------------------------
--      Description:    only for right click menu
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:Hide()

end




-------------------------------------------------------------------------------------
--      Description:    finish and close window
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:SizeChanged()

    local height       = self:GetHeight()

    local background_height   = height - 10
    local frame_height        = background_height - 40
    local list_height         = frame_height - 88

    self.background:SetHeight(   background_height )
    self.frame:SetHeight(        frame_height )
    self.list:SetHeight(         list_height )

end


-------------------------------------------------------------------------------------
--      Description:    group selection changed
-------------------------------------------------------------------------------------
--        Parameter:     
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:SelectionChanged()

    for i = 1, self.list:GetItemCount() do

        self.list:GetItem(i):SelectionChanged()
        
    end

end