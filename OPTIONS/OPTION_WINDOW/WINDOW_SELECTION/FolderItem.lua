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

    self.data                       = data
    self.index                            = index
    self.parent                           = parent
    self.selected                         = false

    self.height                           = 40

    self.children                         = {}

    self.base_height                           = 40

    local folder_left                       = 3
    local name_left                       = 45


    self.frame = Turbine.UI.Control()
    self.frame:SetParent(                   self )
    self.frame:SetMouseVisible(             false )
    self.frame:SetBackColor(                Defaults.Colors.BackgroundColor1 )

    self.background = Turbine.UI.Control()
    self.background:SetParent(              self )
    self.background:SetPosition(            0, 1 )
    self.background:SetBackColor(           Defaults.Colors.FolderColor2 )
    self.background:SetBackColorBlendMode(  Turbine.UI.BlendMode.Overlay )
    self.background:SetMouseVisible(        false )

    
    self.collapsButton = Turbine.UI.Button()
    self.collapsButton:SetParent( self )
    self.collapsButton:SetSize(32, 32)
    self.collapsButton:SetPosition( folder_left, 3 )
    self.collapsButton:SetBlendMode( Turbine.UI.BlendMode.Overlay )

    self.collapsButton.MouseClick = function ()
        self.data.collapsed = not(self.data.collapsed)
        if self.data.collapsed == true then
            self.collapsButton:SetBackground( "Gibberish3/RESOURCES/arrow_right.tga" )
        else
            self.collapsButton:SetBackground( "Gibberish3/RESOURCES/arrow_down.tga" )
        end    
        self:CollapsedChanged()
        self.parent:CollapsedChanged()
    end


    self.nameLabel = Turbine.UI.Label()
    self.nameLabel:SetParent(               self )
    self.nameLabel:SetPosition(             name_left, 5 )
    self.nameLabel:SetHeight(self.base_height - 5)
    self.nameLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
    self.nameLabel:SetFont(                 Defaults.Fonts.HeadingFont )
    self.nameLabel:SetText(                 data.name)
    self.nameLabel:SetMouseVisible(         false )

    self.enabledCheckBox = Options.Constructor.CheckBox( self, function ()
        
    end )
    self.enabledCheckBox:SetTop(  5 )


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

        Data.selectedGroupIndex = {}
        Data.selectedFolderIndex = {}
        
        Data.selectedFolderIndex[1] = self.index

        Options.SelectionChanged()
		
	end )

	self.rightClickMenu:AddRow(             "Move", function ()
		
	end)

	self.rightClickMenu:AddRow(             "Delete", function ()
		
	end)

    self.rightClickMenu:AddSeperator()

    self.rightClickMenu:AddRow(             "Cut", function ()
        
        Options.Cut( Options.CopyCache.ItemTypes.FolderAndGroup )
          
    end)

    self.rightClickMenu:AddRow(             "Copy", function ()
        
        Options.Copy( Options.CopyCache.ItemTypes.FolderAndGroup )

    end)

    self.rightClickMenu:AddRow(             "Past", function ()
        
        Options.Paste( Options.CopyCache.ItemTypes.FolderAndGroup )

    end)


	self.list = Turbine.UI.ListBox()
    self.list:SetParent(self)
    self.list:SetPosition(5, self.base_height)

    
    function self.list:DraggingEnd( fromData )

        local toData = self:GetItemAt(self:GetMousePosition())

        if toData ~= nil then

            Data.SortTo( fromData, toData.data )

            self:GetParent():Sort()

        end

    end
    
    self.folderLevel_H = Turbine.UI.Control()
    self.folderLevel_H:SetParent(                   self )
    self.folderLevel_H:SetLeft(3)
    self.folderLevel_H:SetHeight(                     2 )
    self.folderLevel_H:SetMouseVisible(             false )
    self.folderLevel_H:SetBackColor(                Defaults.Colors.BackgroundColor6 )

    self.folderLevel_V = Turbine.UI.Control()
    self.folderLevel_V:SetParent(                   self )
    self.folderLevel_V:SetPosition(3, self.base_height)
    self.folderLevel_V:SetWidth(                     2 )
    self.folderLevel_V:SetMouseVisible(             false )
    self.folderLevel_V:SetBackColor(                Defaults.Colors.BackgroundColor6 )


	-------------------------------------------------------------------------------------
    --      Description:    has to be here because : breaks args ...
    -------------------------------------------------------------------------------------
    self.MouseClick = function ( sender, args )


        if Folder.IsSelected(self.index) == false then

            if self:IsControlKeyDown() == true then

                Options.AddToFolderSelection(self.index)

            else

                Data.selectedGroupIndex = {}
                Data.selectedFolderIndex = {}
                
                Data.selectedFolderIndex[1] = self.index

            end
    
            Options.SelectionChanged()

        end

            
        if args.Button == Turbine.UI.MouseButton.Right then

            self.rightClickMenu:Show(nil, nil, true)

        end

    end

    -------------------------------------------------------------------------------------
    --      Description:    has to be here because : breaks args ...
    -------------------------------------------------------------------------------------
    self.MouseDoubleClick = function ( sender, args )

        if args.Button == Turbine.UI.MouseButton.Right then

        else

            self.data.collapsed = not(self.data.collapsed)
            if self.data.collapsed == true then
                self.collapsButton:SetBackground( "Gibberish3/RESOURCES/arrow_right.tga" )
            else
                self.collapsButton:SetBackground( "Gibberish3/RESOURCES/arrow_down.tga" )
            end   
            self:CollapsedChanged()
            self.parent:CollapsedChanged()

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
            self:CollapsedChanged(true)
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
            self:CollapsedChanged()
		end
    end

    self:CollapsedChanged()
    self:SetVisible(true)

    self:ChangeWidth(width)

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function FolderItem:MatchesSearch( text )

    if string.find( string.lower( self.data.name ) , text ) then
        return true
    end

    for index, child in ipairs(self.children) do

        if child:MatchesSearch(text) == true then
            return true
        end

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
function FolderItem:CollapsedChanged( collapsed )
    
    if collapsed == nil then
        collapsed =  self.data.collapsed
    end

    if collapsed == true then

        self.collapsButton:SetBackground( "Gibberish3/RESOURCES/arrow_right.tga" )
        self.list:SetVisible(false)

        self:SetHeight(self.base_height)
        self.frame:SetHeight(self.base_height)
        self.background:SetHeight(self.base_height - 2)

        self.height = self.base_height

    else
        
        self.collapsButton:SetBackground( "Gibberish3/RESOURCES/arrow_down.tga" )
   
        self.list:SetVisible(true)

        local height = 0

        for index, child in ipairs(self.children) do

            height = height + child.height
            
        end
         
        self.list:SetHeight(height)
        self.folderLevel_V:SetHeight(height)
        self.folderLevel_H:SetTop(self.list:GetTop() + self.list:GetHeight())
 
        height = height + self.base_height +  5

        self:SetHeight(height)
        self.frame:SetHeight(height)
        self.background:SetHeight(height - 2)

       

        self.height = height


    end

end

-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function FolderItem:ChangeWidth( width )

    local name_left                       = 45
    local name_width                      = width - name_left

    self:SetWidth(                           width )
    self.frame:SetWidth(                     width )
    self.background:SetWidth(                width)
    self.nameLabel:SetWidth(                 name_width )
    self.list:SetWidth(width - 5)
    self.folderLevel_H:SetWidth(             width )
    self.enabledCheckBox:SetLeft( width - 55 )

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function FolderItem:MouseEnter( sender, args )

    if self.selected == false then
        self.background:SetBackColor( Defaults.Colors.FolderColor3 )
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
function FolderItem:MouseLeave( sender, args )

    if self.selected == false then
        self.background:SetBackColor( Defaults.Colors.FolderColor1 )
    end
	
end


-------------------------------------------------------------------------------------
--      Description:    group selection changed
-------------------------------------------------------------------------------------
--        Parameter:     
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function FolderItem:SelectionChanged()

    if Folder.IsSelected(self.index) then

        self.selected = true
        self.background:SetBackColor( Defaults.Colors.FolderColor2 )

    else
        
        self.selected = false
        self.background:SetBackColor( Defaults.Colors.FolderColor1 )

    end

    for i = 1, self.list:GetItemCount() do

        self.list:GetItem(i):SelectionChanged()
        
    end

end



-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    item
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function FolderItem:AddItem( item )

    self.children[#self.children+1] = item

    self.list:AddItem(item)

    local height = 0

    for index, child in ipairs(self.children) do

        height = height + child.height
        
    end

    self:Sort()

   self:CollapsedChanged()

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function FolderItem:Sort()

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
function FolderItem:ClearItems()

    self.children = {}

    self.list:ClearItems()

end
