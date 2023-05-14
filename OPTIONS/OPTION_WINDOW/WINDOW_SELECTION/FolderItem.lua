--===================================================================================
--             Name:    Window selection
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
FolderItem = class( Turbine.UI.Control )





-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    folder data
--                      index
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function FolderItem:Constructor( parent, folderData, index, width )
	Turbine.UI.Control.Constructor( self )

    self.folderData                       = folderData
    self.index                            = index
    self.parent                           = parent

    local height                          = 40

    local folder_left                       = 10
    local name_left                       = 45
    local name_width                      = width - name_left

    self:SetSize(                           width, height )

    self.frame = Turbine.UI.Control()
    self.frame:SetParent(                   self )
    self.frame:SetSize(                     width, height )
    self.frame:SetMouseVisible(             false )
    self.frame:SetBackColor(                Defaults.Colors.BackgroundColor1 )

    self.background = Turbine.UI.Control()
    self.background:SetParent(              self )
    self.background:SetPosition(            0, 1 )
    self.background:SetSize(                width, height - 2 )
    self.background:SetBackColor(           Defaults.Colors.AccentColor5 )
    self.background:SetBackColorBlendMode(  Turbine.UI.BlendMode.Overlay )
    self.background:SetMouseVisible(        false )

    
    self.folderIcon = Turbine.UI.Control()
    self.folderIcon:SetParent( self )
    self.folderIcon:SetSize(30, 30)
    self.folderIcon:SetPosition( folder_left, 8 )
    self.folderIcon:SetBlendMode( Turbine.UI.BlendMode.Overlay )
    self.folderIcon:SetBackground( "Gibberish3/RESOURCES/ordner_icon.tga" )

    self.nameLabel = Turbine.UI.Label()
    self.nameLabel:SetParent(               self )
    self.nameLabel:SetPosition(             name_left, 5 )
    self.nameLabel:SetSize(                 name_width, height - 5 )
    self.nameLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
    self.nameLabel:SetFont(                 Defaults.Fonts.HeadingFont )
    self.nameLabel:SetText(                 folderData.name)
    self.nameLabel:SetMouseVisible(         false )

    self.enabledCheckBox = Options.Constructor.CheckBox( self, function ()
        
    end )
    self.enabledCheckBox:SetPosition( width - 40, 5 )


	-------------------------------------------------------------------------------------
	--      export
	self.exportMenu                       = Options.Constructor.RightClickMenu(125)
	self.exportMenu:AddRow(                 "Folder", function ()
		
	end)

	self.exportMenu:AddRow(                 "List of Groups", function ()
		
	end)

	self.exportMenu:AddRow(                 "List of Timer", function ()
		
	end)

	-------------------------------------------------------------------------------------
	--      right click
	self.rightClickMenu                   = Options.Constructor.RightClickMenu(125)

	self.rightClickMenu:AddSubMenuRow(      "Export", self.exportMenu )

	self.rightClickMenu:AddSeperator()

	self.rightClickMenu:AddRow(             "Edit", function ()

        Data.selectedFolderIndex = self.index
        Data.selectedGroupIndex = nil

        Options.SelectionChanged()
		
	end )

	self.rightClickMenu:AddRow(             "Move", function ()
		
	end)

	self.rightClickMenu:AddRow(             "Delete", function ()
		
	end)

    self.rightClickMenu:AddSeperator()

    self.rightClickMenu:AddRow(             "Cut", function ()
        
    end)

    self.rightClickMenu:AddRow(             "Copy", function ()
        
    end)

    self.rightClickMenu:AddRow(             "Past", function ()
        
    end)


	self.list = Turbine.UI.ListBox()




	-------------------------------------------------------------------------------------
    --      Description:    has to be here because : breaks args ...
    -------------------------------------------------------------------------------------
    self.MouseClick = function ( sender, args )

        if args.Button == Turbine.UI.MouseButton.Right then

            self.rightClickMenu:Show(nil, nil, true)

        else

            self.parent:OpenFolder(self.index)

        end

    end

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function FolderItem:MouseEnter( sender, args )

    self.background:SetBackColor( Defaults.Colors.AccentColor4 )

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    group data
--                      index
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function FolderItem:MouseLeave( sender, args )

    self.background:SetBackColor( Defaults.Colors.AccentColor5 )
	
end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    group data
--                      index
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------

function FolderItem:SelectionChanged()

end
