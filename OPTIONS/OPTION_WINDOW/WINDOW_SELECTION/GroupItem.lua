--===================================================================================
--             Name:    Window selection
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
GroupItem = class( Turbine.UI.Control )





-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
function GroupItem:Constructor( parent, data, index, width )
	Turbine.UI.Control.Constructor( self )

	self.data 			= data
    self.index          = index
    self.parent         = parent

	self.height = 26
    self.width = width

    local name_left     = 40

	-------------------------------------------------------------------------------------
	self:SetHeight( self.height )
    self:SetBackColor(           Defaults.Colors.GroupBase )

    self.dragWindow = Turbine.UI.Window()
    self.dragWindow:SetParent(self)
    self.dragWindow:SetHeight(self.height)
    self.dragWindow:SetBackColor( Defaults.Colors.GroupDragging )
    self.dragWindow:SetMouseVisible(false)
    self.dragWindow:SetVisible(false)

    self.foreground = Turbine.UI.Control()
    self.foreground:SetParent(self)
    self.foreground:SetMouseVisible(false)
    self.foreground:SetHeight(self.height)
	
	-------------------------------------------------------------------------------------
    self.enabledCheckBox = Options.Constructor.CheckBox( self.foreground, function ()

        self:EnabledChanged()
        
    end )
    self.enabledCheckBox:SetPosition( 3, -3)
    self.enabledCheckBox:SetChecked( data.enabled )

	
	-------------------------------------------------------------------------------------
    self.typeLabel = Turbine.UI.Label()
    self.typeLabel:SetParent(               self.foreground )
    self.typeLabel:SetTop(              	1 )
    self.typeLabel:SetSize(                 50, self.height )
    self.typeLabel:SetPosition(             self.width - 70, 0 )
    self.typeLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleRight )
    self.typeLabel:SetFont(                 Defaults.Fonts.SmallFont )
    self.typeLabel:SetText(                 L[Language.Local].Short.GroupTypes[data.type] )
    self.typeLabel:SetMouseVisible(         false )
    self.typeLabel:SetForeColor(            Defaults.Colors.TypeColor )
	

	-------------------------------------------------------------------------------------
    self.nameLabel = Turbine.UI.Label()
    self.nameLabel:SetParent(               self.foreground )
    self.nameLabel:SetPosition(             name_left, 0 )
    self.nameLabel:SetHeight(               self.height  )
    self.nameLabel:SetMultiline(false)
    self.nameLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
    self.nameLabel:SetFont(                 Defaults.Fonts.MediumFont )
    self.nameLabel:SetText(                 data.name )
    self.nameLabel:SetMouseVisible(         false )

    
	-------------------------------------------------------------------------------------
    self.rightClickMenu = Options.Constructor.RightClickMenu(125)

        self.exportMenu                       = Options.Constructor.RightClickSubMenu(125)
        self.exportMenu:AddRow(                 L[Language.Local].Menu.Group, function ()

        end)
        self.exportMenu:AddRow(                 L[Language.Local].Menu.ListOfTimers, function ()
            
        end)

    self.rightClickMenu:AddSubMenuRow( L[Language.Local].Menu.Export, self.exportMenu )     -- export submenu

    self.rightClickMenu:AddRow( L[Language.Local].Menu.Move, function ()                    -- move
        Options.Move.UpdateMode(true, false)
    end)
    self.rightClickMenu:AddSeperator()

    self.rightClickMenu:AddRow( L[Language.Local].Menu.Delete, function ()                  -- delete
        Options.Delete( Options.CopyCache.ItemTypes.FolderAndGroup )
    end)
    self.rightClickMenu:AddRow( L[Language.Local].Menu.Cut, function ()                     -- cut
        Options.Cut( Options.CopyCache.ItemTypes.FolderAndGroup )
    end)
    self.rightClickMenu:AddRow( L[Language.Local].Menu.Copy, function ()                    -- copy
        Options.Copy( Options.CopyCache.ItemTypes.FolderAndGroup )
    end)
    self.rightClickMenu:AddRow( L[Language.Local].Menu.Paste, function ()                   -- paste
        Options.Paste( Options.CopyCache.ItemTypes.FolderAndGroup )
    end)

	-------------------------------------------------------------------------------------
	self.MouseEnter = function (sender, args)

		if Group.IsSelected( self.index ) then

		else
			self:SetBackColor(           Defaults.Colors.GroupHover )
		end
		
	end
	-------------------------------------------------------------------------------------
	self.MouseLeave = function (sender, args)

		if Group.IsSelected( self.index ) then

		else
			self:SetBackColor(           Defaults.Colors.GroupBase )
		end
		
	end
	-------------------------------------------------------------------------------------
	self.MouseClick = function (sender, args)

        local selected      = Group.IsSelected(self.index)
        local control       = self:IsControlKeyDown()
        local rightClick    = ( args.Button == Turbine.UI.MouseButton.Right )

        if selected == true then
        
            if control == true then
                
                Options.RemoveFromGroupSelection(self.index)

            elseif rightClick == true then

                self.rightClickMenu:Show(nil, nil, true)
                return

            else

                Data.selectedGroupIndex = {}
                Data.selectedFolderIndex = {}
                
                Data.selectedGroupIndex[1] = self.index

            end

            Options.SelectionChanged()

        else

            if control == true then

                Options.AddToGroupSelection(self.index)

            else

                Data.selectedGroupIndex = {}
                Data.selectedFolderIndex = {}
                
                Data.selectedGroupIndex[1] = self.index

            end

            Options.SelectionChanged()

            if rightClick == true then
                       
                self.rightClickMenu:Show(nil, nil, true)
                
            end

        end

	end
	-------------------------------------------------------------------------------------
    self.MouseDown = function( sender, args )

		if args.Button == Turbine.UI.MouseButton.Left then
			self.dragging = true	
            self.leftSave, self.topSave = self:GetPosition()
            self.dragStartY = args.Y
            self.dragStartX = args.X
            self:SetZOrder(200)
		end
	end
	-------------------------------------------------------------------------------------
	self.MouseMove = function( sender, args )
		if self.dragging then
			local x, y = self:GetPosition()
            local x_offset = args.X - self.dragStartX
            local y_offset = args.Y - self.dragStartY
            x = x + x_offset
            y = y + y_offset
            self.dragWindow:SetVisible(true)
            self.foreground:SetParent(self.dragWindow)
            self:SetPosition( x, y )
		end
	end
	-------------------------------------------------------------------------------------
	self.MouseUp = function( sender, args )
		if args.Button == Turbine.UI.MouseButton.Left then
			self.dragging = false
            self:SetPosition( self.leftSave, self.topSave )
            self.parent:DraggingEnd(self.data)
            self:SetZOrder(nil)
            self.dragWindow:SetVisible(false)
            self.foreground:SetParent(self)
		end
    end
	-------------------------------------------------------------------------------------
    self:ChangeWidth( width )

end

-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
function GroupItem:ChangeWidth( width )

    local name_left     = 55
    local name_width    = width - name_left - 25

    self:SetWidth(        width )
    self.dragWindow:SetWidth(width)
    self.foreground:SetWidth(width)
    self.nameLabel:SetWidth(                 name_width )
    self.typeLabel:SetLeft(             width - 70 )

end


-------------------------------------------------------------------------------------
--      Description:    finish
-------------------------------------------------------------------------------------
function GroupItem:DraggingEnd( fromData )

    Data.SortTo(fromData, self.data)
    fromData.folder = self.data.folder
    self.parent:FillContent()

end

-------------------------------------------------------------------------------------
--      Description:    match search
-------------------------------------------------------------------------------------
function GroupItem:MatchSearch( search )

    
    if string.find( string.lower( self.data.name ) , search ) then
        return true
    end

    return false

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
function GroupItem:SelectionChanged( )

    if Group.IsSelected(self.index) then

        self:SetBackColor( Defaults.Colors.GroupSelected )

    else

        self:SetBackColor( Defaults.Colors.GroupBase )

    end

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
function GroupItem:EnabledChanged( value )

    if value == nil then
        value = not( self.data.enabled )
    end
    self.data.enabled = value

    self.enabledCheckBox:SetChecked( value )

    if value == true then
        Group.Open(self.index)
    else
        Group.Close(self.index)
    end

    Options.SaveData()

end
