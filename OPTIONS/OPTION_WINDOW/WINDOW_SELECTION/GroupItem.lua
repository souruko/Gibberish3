--===================================================================================
--             Name:    Window selection
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
GroupItem = class( Turbine.UI.Control )





-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    group data
--                      index
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function GroupItem:Constructor( parent, groupData, index, width )
	Turbine.UI.Control.Constructor( self )

    self.groupData      = groupData
    self.index          = index
    self.parent         = parent

    local height        = 40

    local name_left     = 55
    local name_width    = width - name_left - 15

    self:SetSize(       width, height )

    self.frame = Turbine.UI.Control()
    self.frame:SetParent(                   self)
    self.frame:SetSize(width, height)
    self.frame:SetMouseVisible(false)

    self.background = Turbine.UI.Control()
    self.background:SetParent(              self )
    self.background:SetPosition(            0, 1 )
    self.background:SetSize(                width, height - 2 )
    self.background:SetBackColor(           Defaults.Colors.BackgroundColor1 )
    self.background:SetBackColorBlendMode(  Turbine.UI.BlendMode.Overlay )
    self.background:SetMouseVisible(false)

    self.enabledCheckBox = Options.Constructor.CheckBox( self, function ()

        groupData.enabled = not (groupData.enabled)
        
        Options.SaveData()
        
    end )
    self.enabledCheckBox:SetPosition( 10, 5)
    self.enabledCheckBox:SetChecked( groupData.enabled )

    self.nameLabel = Turbine.UI.Label()
    self.nameLabel:SetParent(               self )
    self.nameLabel:SetPosition(             name_left, 5 )
    self.nameLabel:SetSize(                 name_width, height - 5 )
    self.nameLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
    self.nameLabel:SetFont(                 Defaults.Fonts.HeadingFont )
    self.nameLabel:SetText(                 groupData.name )
    self.nameLabel:SetMouseVisible(         false )
    self.nameLabel:SetMouseVisible(         false )


    self.typeLabel = Turbine.UI.Label()
    self.typeLabel:SetParent(               self )
    self.typeLabel:SetPosition(             width - 70, 1 )
    self.typeLabel:SetSize(                 50, 15 )
    self.typeLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
    self.typeLabel:SetFont(                 Defaults.Fonts.SmallFont )
    self.typeLabel:SetText(                 L[Language.Local].Terms.GroupTypes[groupData.type] )
    self.typeLabel:SetMouseVisible(         false )
    self.typeLabel:SetMouseVisible(         false )
    self.typeLabel:SetForeColor(            Defaults.Colors.BackgroundColor6 )

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
    self.addToMenu                        = Options.Constructor.RightClickMenu(125)

    for i, folder in ipairs(Data.folder) do

        self.addToMenu:AddRow( folder.name, function ()
            
        end)
        
    end


-------------------------------------------------------------------------------------
--      right click
    self.rightClickMenu = Options.Constructor.RightClickMenu(125)

    self.rightClickMenu:AddSubMenuRow( "Export", self.exportMenu )

    self.rightClickMenu:AddSeperator()

    self.rightClickMenu:AddSubMenuRow( "Move to Folder", self.addToMenu )

    self.rightClickMenu:AddSeperator()

    self.rightClickMenu:AddRow( "Move", function ()
        Turbine.Shell.WriteLine("move")
    end)

    self.rightClickMenu:AddRow( "Delete", function ()
        
    end)

    self.rightClickMenu:AddSeperator()

    self.rightClickMenu:AddRow( "Cut", function ()
        
    end)

    self.rightClickMenu:AddRow( "Copy", function ()
        
    end)

    self.rightClickMenu:AddRow( "Past", function ()
        
    end)



    -------------------------------------------------------------------------------------
    --      Description:    has to be here because : breaks args ...
    -------------------------------------------------------------------------------------
    self.MouseClick = function ( sender, args )

        Data.selectedGroupIndex = self.index
        Data.selectedFolderIndex = nil
        Options.SelectionChanged()

        if args.Button == Turbine.UI.MouseButton.Right then

            self.rightClickMenu:Show(nil, nil, true)

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
function GroupItem:MouseEnter( sender, args )

    if self.index == Data.selectedGroupIndex then

    else

        self.background:SetBackColor(Defaults.Colors.BackgroundColor2)

    end

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    group data
--                      index
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function GroupItem:MouseLeave( sender, args )

    if self.index == Data.selectedGroupIndex then

    else

        self.background:SetBackColor(Defaults.Colors.BackgroundColor1)

    end

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    group data
--                      index
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function GroupItem:SelectionChanged()

    if self.index == Data.selectedGroupIndex then

        self.frame:SetBackColor( Defaults.Colors.Selected )
        self.background:SetBackColor(Turbine.UI.Color.Black)

    else

        self.frame:SetBackColor( Defaults.Colors.BackgroundColor1 )
        self.background:SetBackColor(Defaults.Colors.BackgroundColor1)

    end

end


