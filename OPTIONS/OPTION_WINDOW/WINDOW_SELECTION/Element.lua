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


    self.parent = parent
    self:SetParent(     parent)
    self:SetBackColor(  Defaults.Colors.BackgroundColor2 )

    local width                 = 300
    local background_pos        = 5
    local newButton_pos         = 10
    local heading_top           = 7
    local collapsButton_width   = 18
    local collapsButton_height  = 15
    local collapsButton_left    = 270
    local collapsButton_top     = 12
    local frame_left            = 10
    local frame_top             = 40
    local content_left          = 12
    local searchBox_top         = 42
    local searchBox_width       = 300 - 24
    local searchBox_height      = 20
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
    self.newButton                    = Turbine.UI.Lotro.Button()
    self.newButton:SetParent(           self )
    self.newButton:SetFont(             Defaults.Fonts.ButtonFont )
    self.newButton:SetForeColor(        Turbine.UI.Color.White)
    self.newButton:SetText(             L[Language.Local].Button.New )
    self.newButton:SetPosition(         newButton_pos, newButton_pos )

    self.newMenu                      = Options.Constructor.RightClickMenu( 90 )
    self.newMenu:AddRow(                L[Language.Local].Menu.Folder, function ()

    end )

    self.newMenu:AddRow(                L[Language.Local].Menu.Group, function ()

    end )

    function self.newButton.Click( sender, args )
        self.newMenu:Show()

    end


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
--  collapsButton
    self.collapseButton               = Turbine.UI.Button()
    self.collapseButton:SetParent(      self )
    self.collapseButton:SetPosition(    collapsButton_left, collapsButton_top )
    self.collapseButton:SetSize(        collapsButton_width, collapsButton_height )
    self.collapseButton:SetText(        "-")
    self.collapseButton:SetTextAlignment( Turbine.UI.ContentAlignment.BottomCenter )
    self.collapseButton:SetBackColor(   Defaults.Colors.BackgroundColor2)

-------------------------------------------------------------------------------------
--  frame  
    self.frame                        = Turbine.UI.Control()
    self.frame:SetParent(               self )
    self.frame:SetPosition(             frame_left, frame_top )
    self.frame:SetBackColor(            Defaults.Colors.BackgroundColor6 )
    self.frame:SetMouseVisible(         false )
    self.frame:SetWidth(                frame_width )

-------------------------------------------------------------------------------------
--  searchBoxBox

    self.searchBoxText = ""

    self.searchBox                    = Turbine.UI.Lotro.TextBox()
    self.searchBox:SetPosition(         content_left, searchBox_top )
    self.searchBox:SetParent(           self )
    self.searchBox:SetSize(             searchBox_width, searchBox_height)
    self.searchBox:SetTextAlignment(    Turbine.UI.ContentAlignment.MiddleLeft)
    self.searchBox:SetFont(             Defaults.Fonts.SmallFont )
    self.searchBox:SetText(             L[Language.Local].Text.SearchBoxDefault )

    self.searchBox.FocusGained = function(sender, args)

        if self.searchBoxText == "" then
            self.searchBox:SetText("")

        end

    end

    self.searchBox.FocusLost = function(sender, args)

        if self.searchBoxText == "" then
            self.searchBox:SetText( L[Language.Local].Text.SearchBoxDefault )

        end

    end

    self.searchBox.TextChanged = function(sender, args)


    end


-------------------------------------------------------------------------------------
--  listbox  
    self.list                 = Turbine.UI.ListBox()
    self.list:SetParent(        self)
    self.list:SetPosition(      content_left, list_top )
    self.list:SetBackColor(     Defaults.Colors.BackgroundColor1 )
    self.list:SetWidth(         list_width )


-------------------------------------------------------------------------------------
--  getting started

    self:FillContent()

end



-------------------------------------------------------------------------------------
--      Description:    finish and close window
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:FillContent()

    local folderList = {}

    for i, folderData in ipairs(Data.folder) do

        folderList[i] = FolderItem( folderData, i, self.content_width )

        self.list:AddItem( folderList[i] )
        
    end


    for i, groupData in ipairs(Data.group) do

        local item = GroupItem( groupData, i, self.content_width )

        if groupData.folder == nil then
            self.list:AddItem( item )

        else
            folderList[i]:AddGroup( item )

        end
        
    end

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

    local width, height       = self:GetSize()

    local background_height   = height - 10
    local frame_height        = background_height - 40
    local list_height         = frame_height - 26

    
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
function Options.Constructor.WindowSelection:SelectedWindowChanged()

    for i = 1, self.list:GetItemCount() do

        self.list:GetItem(i):SelectionChanged()
        
    end

end