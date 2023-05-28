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
function GroupItem:Constructor( parent, data, index, width )
	Turbine.UI.Control.Constructor( self )

    self.data      = data
    self.index          = index
    self.parent         = parent
    self.folderIndex    = data.folder

    self.height         = 40
    local height        = 40

    local name_left     = 55

    self:SetHeight(        height )

    self.frame = Turbine.UI.Control()
    self.frame:SetParent(                   self)
    self.frame:SetHeight(height)
    self.frame:SetMouseVisible(false)

    self.background = Turbine.UI.Control()
    self.background:SetParent(              self )
    self.background:SetPosition(            0, 0 )
    self.background:SetHeight(                height  )
    self.background:SetBackColor(           Defaults.Colors.BackgroundColor1 )
    self.background:SetBackColorBlendMode(  Turbine.UI.BlendMode.Overlay )
    self.background:SetMouseVisible(false)

    self.enabledCheckBox = Options.Constructor.CheckBox( self, function ()

        self:EnableChanged()
        
    end )
    self.enabledCheckBox:SetPosition( 10, 5)
    self.enabledCheckBox:SetChecked( data.enabled )

    self.nameLabel = Turbine.UI.Label()
    self.nameLabel:SetParent(               self )
    self.nameLabel:SetPosition(             name_left, 5 )
    self.nameLabel:SetHeight(                 height - 5 )
    self.nameLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
    self.nameLabel:SetFont(                 Defaults.Fonts.HeadingFont )
    self.nameLabel:SetText(                 data.name )
    self.nameLabel:SetMouseVisible(         false )
    self.nameLabel:SetMouseVisible(         false )


    self.typeLabel = Turbine.UI.Label()
    self.typeLabel:SetParent(               self )
    self.typeLabel:SetTop(              1 )
    self.typeLabel:SetSize(                 50, 15 )
    self.typeLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
    self.typeLabel:SetFont(                 Defaults.Fonts.SmallFont )
    self.typeLabel:SetText(                 L[Language.Local].Terms.GroupTypes[data.type] )
    self.typeLabel:SetMouseVisible(         false )
    self.typeLabel:SetMouseVisible(         false )
    self.typeLabel:SetForeColor(            Defaults.Colors.BackgroundColor6 )

-------------------------------------------------------------------------------------
--      export
    self.exportMenu                       = Options.Constructor.RightClickSubMenu(125)
    self.exportMenu:AddRow(                 L[Language.Local].Menu.Groups, function ()

    end)

    self.exportMenu:AddRow(                 L[Language.Local].Menu.ListOfTimerss, function ()
        
    end)

-------------------------------------------------------------------------------------
--      addToFolder
    self.addToMenu                        = Options.Constructor.RightClickSubMenu(125)

    self.addToMenu:AddRow( L[Language.Local].Menu.RemoveFromFolder, function ()
        Options.MoveToFolder( nil )

    end)

    self.addToMenu:AddSeperator()

    for i, folder in ipairs(Data.folder) do

        self.addToMenu:AddRow( folder.name, function ()
            Options.MoveToFolder( i )
        end)
        
    end


-------------------------------------------------------------------------------------
--      right click
    self.rightClickMenu = Options.Constructor.RightClickMenu(125)

    self.rightClickMenu:AddSubMenuRow( L[Language.Local].Menu.Export, self.exportMenu )

    self.rightClickMenu:AddSeperator()

    self.rightClickMenu:AddSubMenuRow( L[Language.Local].Menu.MoveToFolder, self.addToMenu )

    self.rightClickMenu:AddSeperator()

    self.rightClickMenu:AddRow( L[Language.Local].Menu.Move, function ()

        Options.Move.UpdateMode(true, false)

    end)

    self.rightClickMenu:AddRow( L[Language.Local].Menu.Delete, function ()

        Options.Delete()

    end)

    self.rightClickMenu:AddSeperator()

    self.rightClickMenu:AddRow( L[Language.Local].Menu.Cut, function ()
        
        Options.Cut( Options.CopyCache.ItemTypes.FolderAndGroup )
        
    end)

    self.rightClickMenu:AddRow( L[Language.Local].Menu.Copy, function ()

        Options.Copy( Options.CopyCache.ItemTypes.FolderAndGroup )
        
    end)

    self.rightClickMenu:AddRow( L[Language.Local].Menu.Paste, function ()
  
        Options.Paste( Options.CopyCache.ItemTypes.FolderAndGroup )
      
    end)



    -------------------------------------------------------------------------------------
    --      Description:    has to be here because : breaks args ...
    -------------------------------------------------------------------------------------
    self.MouseClick = function ( sender, args )

        if Group.IsSelected(self.index) == false then

            if self:IsControlKeyDown() == true then

                Options.AddToGroupSelection(self.index)

            else

                Data.selectedGroupIndex = {}
                Data.selectedFolderIndex = {}
                
                Data.selectedGroupIndex[1] = self.index

            end

        end

        Options.SelectionChanged()

        if args.Button == Turbine.UI.MouseButton.Right then

            self.rightClickMenu:Show(nil, nil, true)

        end

    end

    
    self.MouseDown = function( sender, args )
		if args.Button == Turbine.UI.MouseButton.Left then
			self.dragging = true	
            self.topSave = self:GetTop()
            self.dragStartY = args.Y
            self:SetZOrder(200)
		end
	end
	
	self.MouseMove = function( sender, args )
		if self.dragging then
			local y = self:GetTop()	
            local y_offset = args.Y - self.dragStartY
            y = y + y_offset
            if y < 0 then
                y = 0
            elseif y > self:GetParent():GetHeight() - self:GetHeight() then
                y = self:GetParent():GetHeight() - self:GetHeight()
            end

            self:SetTop( y )
		end
	end
	
	self.MouseUp = function( sender, args )
		if args.Button == Turbine.UI.MouseButton.Left then
			self.dragging = false
            self:SetTop( self.topSave )
            self:GetParent():DraggingEnd(self.data)
            self:SetZOrder(nil)
		end
    end
    self:ChangeWidth( width )
    self:SetVisible(true)

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function GroupItem:ChangeWidth( width )

    local name_left     = 55
    local name_width    = width - name_left - 15

    self:SetWidth(        width )
    self.frame:SetWidth(width)
    self.background:SetWidth(                width )
    self.nameLabel:SetWidth(                 name_width )
    self.typeLabel:SetLeft(             width - 70 )

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function GroupItem:MatchesSearch( text )

    if string.find( string.lower( self.data.name ) , text ) then
        return true
    end

    return false

end



-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function GroupItem:MouseEnter( sender, args )

    if Group.IsSelected(self.index) then

    else

        self.background:SetBackColor(Defaults.Colors.BackgroundColor3)

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

    if Group.IsSelected(self.index) then

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

    if Group.IsSelected(self.index) then

        self.frame:SetBackColor( Defaults.Colors.Selected )
        self.background:SetBackColor(Defaults.Colors.BackgroundColor2 )

    else
 
        self.frame:SetBackColor( Defaults.Colors.BackgroundColor1 )
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
function GroupItem:EnableChanged(enabled)

    if enabled == nil then
        enabled = not( self.data.enabled )
    end 

    self.enabledCheckBox:SetChecked(enabled)

    self.data.enabled = enabled
    if self.data.enabled == true then
        Group.Open(self.index)
    else
        Group.Close(self.index)
    end

    Options.SaveData()

end


