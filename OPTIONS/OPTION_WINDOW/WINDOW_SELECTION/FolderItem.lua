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
function FolderItem:Constructor( parent, data, index, width )
	Turbine.UI.Control.Constructor( self )

	
	self.data 			= data
    self.index          = index
    self.parent         = parent

	self.thickness_line = 2
	self.spacing_line = 5

	self.height = 26
	self.height_base = 26
	self.height_unfolded = self.height_base + self.thickness_line + self.spacing_line
	self.width = width


	local left_collaps  = 3
    local left_name     = 40

	-------------------------------------------------------------------------------------
	self:SetHeight( self.height_base )
    self:SetBackColor(           Defaults.Colors.FolderBase )

	-------------------------------------------------------------------------------------
	self.dragWindow = Turbine.UI.Window()
    self.dragWindow:SetParent(self)
    self.dragWindow:SetHeight(self.height_base)
    self.dragWindow:SetBackColor( Defaults.Colors.FolderDragging )
    self.dragWindow:SetMouseVisible(false)
    self.dragWindow:SetVisible(false)

	-------------------------------------------------------------------------------------
    self.foreground = Turbine.UI.Control()
    self.foreground:SetParent(self)
    self.foreground:SetMouseVisible(false)
    self.foreground:SetHeight(self.height_base)

	-------------------------------------------------------------------------------------
	self.collapsButton = Turbine.UI.Button()
    self.collapsButton:SetParent( self.foreground )
    self.collapsButton:SetSize(32, 32)
    self.collapsButton:SetPosition( left_collaps, -3 )
    self.collapsButton:SetBlendMode( Turbine.UI.BlendMode.Overlay )
    self.collapsButton.MouseClick = function ()

		self.data.collapsed = not(self.data.collapsed)
		self:CollapsChanged()
		self:GetParent():ChildHeightChanged()

	end


	-------------------------------------------------------------------------------------
    -- self.enabledCheckBox = Options.Constructor.CheckBox( self, function ()

    --     self:EnableChanged()
        
    -- end )
    -- self.enabledCheckBox:SetPosition( self.width - 50, 0)
    -- self.enabledCheckBox:SetChecked( data.enabled )


	-------------------------------------------------------------------------------------
    self.nameLabel = Turbine.UI.Label()
    self.nameLabel:SetParent(               self.foreground )
    self.nameLabel:SetPosition(             left_name, 0 )
    self.nameLabel:SetHeight(               self.height_base )
    self.nameLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
    self.nameLabel:SetFont(                 Defaults.Fonts.MediumFont )
    self.nameLabel:SetText(                 data.name )
    self.nameLabel:SetMouseVisible(         false )

	
	-------------------------------------------------------------------------------------
	self.list = Turbine.UI.ListBox()
    self.list:SetParent(self)
    self.list:SetPosition( self.thickness_line + self.spacing_line, self.height_base )
	self.list.ChildHeightChanged = function ()
		
		self:FixHeight()

	end
	-------------------------------------------------------------------------------------
    self.folderLevel_H = Turbine.UI.Control()
    self.folderLevel_H:SetParent(                   self )
    self.folderLevel_H:SetPosition(self.spacing_line, self.height_base)
    self.folderLevel_H:SetHeight(                     self.thickness_line )
    self.folderLevel_H:SetMouseVisible(             false )
    self.folderLevel_H:SetBackColor(                Defaults.Colors.FolderLevel )

	-------------------------------------------------------------------------------------
    self.folderLevel_V = Turbine.UI.Control()
    self.folderLevel_V:SetParent(                   self )
    self.folderLevel_V:SetPosition(self.spacing_line, self.height_base)
    self.folderLevel_V:SetWidth(                     self.thickness_line )
    self.folderLevel_V:SetMouseVisible(             false )
    self.folderLevel_V:SetBackColor(                Defaults.Colors.FolderLevel )
	self.folderLevel_V:SetHeight( 	0 )

	
	-------------------------------------------------------------------------------------
	self.rightClickMenu                   = Options.Constructor.RightClickMenu(125)

	self.exportMenu                       = Options.Constructor.RightClickSubMenu(125)			
	self.exportMenu:AddRow(                 L[Language.Local].Menu.Folder, function ()
		
	end)
	self.exportMenu:AddRow(                 L[Language.Local].Menu.ListOfGroups, function ()
		
	end)
	self.exportMenu:AddRow(                 L[Language.Local].Menu.ListOfTimers, function ()
		
	end)

	self.rightClickMenu:AddSubMenuRow(      L[Language.Local].Menu.Export, self.exportMenu )	-- export
	self.rightClickMenu:AddRow(             L[Language.Local].Menu.Move, function ()			-- move	
        Options.Move.UpdateMode(true, false)
	end)
	self.rightClickMenu:AddSeperator()

	self.rightClickMenu:AddRow(             L[Language.Local].Menu.Delete, function ()			-- delete
        Options.Delete( Options.CopyCache.ItemTypes.FolderAndGroup )
	end)
	self.rightClickMenu:AddRow(             L[Language.Local].Menu.Cut, function ()				-- cut
        Options.Cut( Options.CopyCache.ItemTypes.FolderAndGroup )
    end)
    self.rightClickMenu:AddRow(             L[Language.Local].Menu.Copy, function ()			-- copy
        Options.Copy( Options.CopyCache.ItemTypes.FolderAndGroup )
    end)
    self.rightClickMenu:AddRow(             L[Language.Local].Menu.Paste, function ()			-- paste
       
        Options.Paste( Options.CopyCache.ItemTypes.FolderAndGroup )
    end)

	-------------------------------------------------------------------------------------
	self.MouseEnter = function (sender, args)

		if Folder.IsSelected( self.index ) then

		else
			self:SetBackColor(           Defaults.Colors.FolderHover )
		end
		
	end
	-------------------------------------------------------------------------------------
	self.MouseLeave = function (sender, args)

		if Folder.IsSelected( self.index ) then

		else
			self:SetBackColor(           Defaults.Colors.FolderBase )
		end
		
	end
	-------------------------------------------------------------------------------------
	self.MouseClick = function (sender, args)

        local selected      = Group.IsSelected(self.index)
        local control       = self:IsControlKeyDown()
        local rightClick    = ( args.Button == Turbine.UI.MouseButton.Right )

        if selected == true then
        
            if control == true then
                
                Options.RemoveFromFolderSelection(self.index)

            elseif rightClick == true then

                self.rightClickMenu:Show(nil, nil, true)
                return

            else

                Data.selectedGroupIndex = {}
                Data.selectedFolderIndex = {}
                
                Data.selectedFolderIndex[1] = self.index

            end

            Options.SelectionChanged()
            
        else

            if control == true then

                Options.AddToFolderSelection(self.index)

            else

                Data.selectedGroupIndex = {}
                Data.selectedFolderIndex = {}
                
                Data.selectedFolderIndex[1] = self.index

            end

            Options.SelectionChanged()

            if rightClick == true then
                       
                self.rightClickMenu:Show(nil, nil, true)
                
            end

        end

	end
	-------------------------------------------------------------------------------------
	self.MouseDoubleClick = function (sender, args)
		
        if args.Button == Turbine.UI.MouseButton.Left then

			self.data.collapsed = not(self.data.collapsed)
			self:CollapsChanged()
			self:GetParent():ChildHeightChanged()
	
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
            self:CollapsChanged(true)
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
            self:CollapsChanged()
            self:SetZOrder(nil)
            self.dragWindow:SetVisible(false)
            self.foreground:SetParent(self)
		end
    end

	-------------------------------------------------------------------------------------
    self:ChangeWidth( width )
	self:CollapsChanged()

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
function FolderItem:ChangeWidth( width )

    local left_name     = 55
    local name_width    = width - left_name - 15
	local child_width   = width - self.thickness_line - self.spacing_line

    self:SetWidth(        width )
    self.dragWindow:SetWidth(width)
    self.foreground:SetWidth(width)
    self.nameLabel:SetWidth(                 name_width )
	self.list:SetWidth( width - self.spacing_line - self.thickness_line )
	self.folderLevel_H:SetWidth( width - self.spacing_line - self.thickness_line )

	for i = 1, self.list:GetItemCount() do
		
		self.list:GetItem(i):ChangeWidth( child_width )

	end

end



-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
function FolderItem:FixHeight()

	-- base
	self.height_unfolded = self.height_base + self.thickness_line + self.spacing_line

	-- add itemsize
	for i=1, self.list:GetItemCount() do
		self.height_unfolded = self.height_unfolded + self.list:GetItem(i).height
	end

	if self.data.collapsed == true then
		self.height = self.height_base
	else
		self.height = self.height_unfolded
	end

	self:SetHeight( self.height )

	local height_list =  self.height_unfolded - self.height_base - self.thickness_line - self.spacing_line
	self.list:SetHeight( 			height_list )
	self.folderLevel_V:SetHeight( 	height_list )
	self.folderLevel_H:SetTop( 		height_list + self.height_base )

	local parent = self:GetParent()
	if parent ~= nil then
		self:GetParent():ChildHeightChanged()
	end

end

-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
function FolderItem:CollapsChanged(collased)

	if collased == nil then
		collased = self.data.collapsed
	end

	if collased == true then
		self.collapsButton:SetBackground( "Gibberish3/RESOURCES/arrow_right.tga" )
		self.height = self.height_base

	else
		self.collapsButton:SetBackground( "Gibberish3/RESOURCES/arrow_down.tga" )
		self.height = self.height_unfolded

	end

	self:SetHeight(self.height)

end



-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
function FolderItem:RemoveAllChildren()

	self.list:ClearItems()

	self:FixHeight()

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
function FolderItem:AddChild( child )

	self.list:AddItem(child)

	self:FixHeight()

end


-------------------------------------------------------------------------------------
--      Description:    finish
-------------------------------------------------------------------------------------
function FolderItem:DraggingEnd( fromData )

	local left, top = self.list:GetMousePosition()

	local toItem = self.list:GetItemAt(left, top)

	if toItem ~= nil then

		if toItem.data ~= fromData then
			toItem:DraggingEnd( fromData )
		end

	else

		Turbine.Shell.WriteLine(self.data.name)
		fromData.folder = self.index
		self.parent:FillContent()

	end

end


-------------------------------------------------------------------------------------
--      Description:    match search
-------------------------------------------------------------------------------------
function FolderItem:MatchSearch( search )

    
    if string.find( string.lower( self.data.name ) , search ) then
        return true
    end

	
	for i=1, self.list:GetItemCount() do
        if self.list:GetItem(i):MatchSearch( search ) == true then
            return true
        end
    end

    return false

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
function FolderItem:SelectionChanged( )

    if Folder.IsSelected(self.index) then

        self:SetBackColor( Defaults.Colors.FolderSelected )

    else

        self:SetBackColor( Defaults.Colors.FolderBase )

    end

end
