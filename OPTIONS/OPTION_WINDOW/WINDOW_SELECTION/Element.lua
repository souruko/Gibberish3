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
    self.content_width          = list_width


    local list_top              = 64
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

    function self.list:DraggingEnd( fromData )

        local left, top = self:GetMousePosition()

        local toData = self:GetItemAt(left, top)
    
        if toData == nil then
    
            if top <= 0 then
    
                toData = self:GetItem(1)
    
            else
    
                toData = self:GetItem(self:GetItemCount())
    
            end

        end

        if toData ~= nil then

            Data.SortTo( fromData, toData.data )

            self:GetParent():Sort()

        end

    end



    self.scroll = Turbine.UI.Lotro.ScrollBar()
    self.scroll:SetOrientation(Turbine.UI.Orientation.Vertical)
    self.scroll:SetPosition(content_left + list_width - 10, list_top)
    self.scroll:SetParent(self)
    self.scroll:SetWidth(10)
    self.scroll:SetZOrder(50)
    self.list:SetVerticalScrollBar(self.scroll)

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

    for j, groupData in ipairs(Data.group) do

        self.groupList[j] = GroupItem( self, groupData, j, self.content_width )
        
    end

    for i, folderData in ipairs(Data.folder) do

        self.folderList[i] = FolderItem( self, folderData, i, self.content_width )
  
    end


    for i, folderItem in pairs(self.folderList) do

        if folderItem.data.folder ~= nil then
            self.folderList[folderItem.data.folder]:AddItem(folderItem)
        end

        
        for k, groupItem in pairs(self.groupList) do

            if groupItem.folderIndex == i then
                
                self.folderList[i]:AddItem(groupItem)
        
            end
            
        end
        
    end

    for i, folderItem in pairs(self.folderList) do

       folderItem:ChangeWidth(self.content_width - 5*Folder.GetFolderLevel(folderItem.data))

    end

    for k, groupItem in pairs(self.groupList) do
        groupItem:ChangeWidth(self.content_width - 5*Folder.GetFolderLevel(groupItem.data))
    end

    self:CollapsedChanged()

end

-------------------------------------------------------------------------------------
--      Description:    finish and close window
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:CollapsedChanged()

    for key, folderItem in pairs(self.folderList) do

        folderItem:CollapsedChanged()
        
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

        if folder.data.folder == nil then
            self.list:AddItem( folder )
        end

    end
    
    for j, group in ipairs(self.groupList) do

        if group.folderIndex == nil then
            self.list:AddItem( group )
        end
    end

    self:Sort()

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
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:DraggingEnd( fromData )

    -- local toData = self.list:GetItemAt(self.list:GetMousePosition()).data

    -- Data.SortTo( fromData, toData )

    -- for key, folderItem in pairs(self.folderList) do

    --     folderItem:Sort()
        
    -- end
    
    -- self:Sort()

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
    local list_height         = frame_height - 26

    self.background:SetHeight(   background_height )
    self.frame:SetHeight(        frame_height )
    self.list:SetHeight(         list_height )

    self.scroll:SetHeight(list_height)

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