--=================================================================================================
--= Folder Item
--= ===============================================================================================
--= 
--=================================================================================================



FolderItem = class( Turbine.UI.Control )
---------------------------------------------------------------------------------------------------
function FolderItem:Constructor( parent, data, index )
	Turbine.UI.Control.Constructor( self )

    self.data 	= data
    self.index  = index * (-1)
    self.parent = parent

    self:CreateBackground()
    self:CreateRightClick()
    self:CreateContent()

    self:CollapsChanged( self.data.collapsed )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function FolderItem:DataChanged()

    self.nameLabel:SetText( self.data.name )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function FolderItem:AddItem( item )

    self.listbox:AddItem( item )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function FolderItem:ClearItems()

    self.items = {}
    self.listbox:ClearItems()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function FolderItem:CreateBackground()

    -- base background

    -- window for dragging of the window
    self.dragWindow = Turbine.UI.Window()
    self.dragWindow:SetParent( self )
    self.dragWindow:SetMouseVisible( false )
    self.dragWindow:SetVisible( false )

    -- content background
    self.frame = Turbine.UI.Control()
    self.frame:SetParent( self )
    self.frame:SetPosition( 2* Options.Defaults.window.w_folder_frame, 2* Options.Defaults.window.w_folder_frame )
    self.frame:SetMouseVisible( false )

    -- content background
    self.background = Turbine.UI.Control()
    self.background:SetParent( self.frame )
    self.background:SetPosition( Options.Defaults.window.w_folder_frame, Options.Defaults.window.w_folder_frame )
    self.background:SetMouseVisible( false )

    -- mouse actions
    self.MouseEnter = function ()

        self.hover = true
        if self.index ~= Data.selectedIndex then

            self:FixColor()

        end

    end

    self.MouseLeave = function ()

        self.hover = false
        if self.index ~= Data.selectedIndex then

            self:FixColor()

        end

    end

    self.MouseClick = function ( sender, args )

        --  select window if not already selected
        if self.index ~= Data.selectedIndex then

            Options.SelectionChanged( self.index )

        end

        -- show rightclick menu
        if args.Button == Turbine.UI.MouseButton.Right then
            
            self.rightClickMenu:Show()

        end

    end

    self.MouseDoubleClick = function ()

		self:CollapsChanged()
        self.parent:FixElementHeight()

	end

    self.MouseDown = function( sender, args )

		if args.Button == Turbine.UI.MouseButton.Left then

            self.collapsSave = self.data.collapsed
			self.dragging = true
            self.leftSave, self.topSave = self:GetPosition()
            self.dragStartY = args.Y
            self.dragStartX = args.X
            self:SetZOrder(200)

		end

	end

    self.MouseMove = function( sender, args )

		if self.dragging then

            self:CollapsChanged( true )
            self:Height( true )
			local x, y = self:GetPosition()
            local x_offset = args.X - self.dragStartX
            local y_offset = args.Y - self.dragStartY
            x = x + x_offset
            y = y + y_offset
            self.dragWindow:SetVisible( true )
            self.frame:SetParent( self.dragWindow )
            self:SetPosition( x, y )

		end

	end

    self.MouseUp = function( sender, args )

		if args.Button == Turbine.UI.MouseButton.Left then

			self.dragging = false
            self:SetPosition( self.leftSave, self.topSave )
            self.parent:DraggingEnd(self.data)
            self:CollapsChanged( self.collapsSave )
            self:Height()
            self:SetZOrder( nil )
            self.dragWindow:SetVisible( false )
            self.frame:SetParent( self )

		end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function FolderItem:CreateRightClick()

    -- rightclick menu
    self.rightClickMenu = Options.Elements.RightClickMenu( Options.Defaults.window.menu_width )


        -- export subMenu
        self.rc_exportSubMenu = Options.Elements.RightClickSubMenu( Options.Defaults.window.menu_width )

        -- export folder
        self.rc_ex_folder = Options.Elements.Row( "selection", "ex_folder", function ()

        end,
        Options.Defaults.rc_menu.item_height)

        -- export list of window
        self.rc_ex_low = Options.Elements.Row( "selection", "ex_low", function ()

        end,
        Options.Defaults.rc_menu.item_height)
 
        -- export list of timer
        self.rc_ex_lot = Options.Elements.Row( "selection", "ex_lot", function ()

        end,
        Options.Defaults.rc_menu.item_height)

        self.rc_exportSubMenu:AddRow( self.rc_ex_folder )
        self.rc_exportSubMenu:AddRow( self.rc_ex_low )
        self.rc_exportSubMenu:AddRow( self.rc_ex_lot )

    -- export
    self.rc_export = Options.Elements.SubRow( "selection", "export", self.rc_exportSubMenu,
    Options.Defaults.rc_menu.item_height )

    -- delete
    self.rc_delete = Options.Elements.Row( "selection", "delete", function ()
        Options.DeleteFolder( self.index*(-1) )
        self.parent:ReFill()
    end,
    Options.Defaults.rc_menu.item_height)

    -- copy
    self.rc_copy = Options.Elements.Row( "selection", "copy", function ()
        local index = Folder.Copy( self.index * (-1) )
        self.parent:CreateFolderElements()
        self.parent:FillContent()
        self.parent:FixElementHeight()
        Options.SelectionChanged( index * (-1) )
    end,
    Options.Defaults.rc_menu.item_height)

    
    self.rightClickMenu:AddSubRow( self.rc_export, self.rc_exportSubMenu )
    self.rightClickMenu:AddSeperator()
    self.rightClickMenu:AddRow( self.rc_delete )
    self.rightClickMenu:AddRow( self.rc_copy )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function FolderItem:CreateContent()

	self.collapsButton = Turbine.UI.Button()
    self.collapsButton:SetParent( self.background )
    self.collapsButton:SetSize(32, 32)
    self.collapsButton:SetPosition( 0, 3 )
    self.collapsButton:SetBlendMode( Turbine.UI.BlendMode.Overlay )
    self.collapsButton.MouseClick = function ()

		self:CollapsChanged()
        self.parent:FixElementHeight()

	end
    -- window name
    self.nameLabel = Turbine.UI.Label()
    self.nameLabel:SetParent( self.background )
    self.nameLabel:SetLeft( 40 )
    self.nameLabel:SetHeight( Options.Defaults.window.w_item_height )
    self.nameLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft )
    self.nameLabel:SetFont( Options.Defaults.window.w_font )
    self.nameLabel:SetForeColor( Options.Defaults.window.textcolor )
    self.nameLabel:SetText( self.data.name )
    self.nameLabel:SetMouseVisible( false )

    --listbox
    self.listbox = Turbine.UI.ListBox()
    self.listbox:SetParent( self.background )
    self.listbox:SetPosition( Options.Defaults.window.w_folder_frame, Options.Defaults.window.w_item_height )
    self.listbox:SetMouseVisible( false )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function FolderItem:Filter( filter )

    -- check if folder matches filter
    if string.find( string.lower( self.data.name ) , filter ) then
        return true
    end

    -- check if children match filter
    for i = 1, self.listbox:GetItemCount() do

        local item = self.listbox:GetItem(i)
        if item:Filter( filter ) == true then
            return true
        end

    end

    return false

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function FolderItem:Width( value )

    self:SetWidth( value )
    self.dragWindow:SetWidth( value )
    self.frame:SetWidth( value - 4* Options.Defaults.window.w_folder_frame  )
    self.background:SetWidth( value - 6* Options.Defaults.window.w_folder_frame  )
    self.nameLabel:SetWidth( value - 55)
    self.listbox:SetWidth( value - 4* Options.Defaults.window.w_folder_frame )

    local item_width = self.listbox:GetWidth()

    for i = 1, self.listbox:GetItemCount() do

        local item = self.listbox:GetItem(i)

        item:Width( item_width )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function FolderItem:Height( collapsed )

    if collapsed == nil then
        collapsed = self.data.collapsed
    end

    local height
    local item_count = self.listbox:GetItemCount()

    if collapsed == true then
        height =  Options.Defaults.window.w_item_height + 4 * Options.Defaults.window.w_folder_frame
    else
        height =  Options.Defaults.window.w_item_height + 7 * Options.Defaults.window.w_folder_frame

        
        for i = 1, self.listbox:GetItemCount() do

            local item = self.listbox:GetItem(i)

            height = height + item:Height()

        end

    end

    self:SetHeight( height )
    self.dragWindow:SetHeight( height )
    self.frame:SetHeight( height - ( 2 * Options.Defaults.window.w_folder_frame ) )
    self.background:SetHeight( height - ( 4 * Options.Defaults.window.w_folder_frame ) )
    self.listbox:SetHeight( height - Options.Defaults.window.w_item_height )

    return height

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function FolderItem:SetColor( hover )


end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function FolderItem:SelectionChanged()

    self:FixColor()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function FolderItem:LanguageChanged()
    self.rightClickMenu:LanguageChanged()
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function FolderItem:FixColor()

    local selected  = ( self.index == Data.selectedIndex )
    local hover     = self.hover
    local collapsed = self.data.collapsed

    if selected == true then
        self:SetBackColor( Options.Defaults.window.w_folder_select )
        self.frame:SetBackColor( Options.Defaults.window.w_folder_select )
        self.background:SetBackColor( Options.Defaults.window.w_folder_select )

    elseif hover == true then
        self:SetBackColor( Options.Defaults.window.w_folder_hover )
        self.frame:SetBackColor( Options.Defaults.window.w_folder_hover )
        self.background:SetBackColor( Options.Defaults.window.w_folder_hover )

    else
        self:SetBackColor( Options.Defaults.window.w_folder_base )
        self.frame:SetBackColor( Options.Defaults.window.w_folder_base )
        self.background:SetBackColor( Options.Defaults.window.w_folder_base )
 
    end

    if collapsed == false then
        self:SetBackColor( Turbine.UI.Color.Black )
        self.frame:SetBackColor( Options.Defaults.window.framecolor )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function FolderItem:CollapsChanged( value )

    if value == nil then
        value = not( self.data.collapsed )
    end

    self.data.collapsed = value

    if value == false then
		self.collapsButton:SetBackground( "Gibberish3/RESOURCES/arrow_down.tga" )

    else
		self.collapsButton:SetBackground( "Gibberish3/RESOURCES/arrow_right.tga" )

    end

    self:FixColor()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function FolderItem:Sort( sortFunction )

    self.listbox:Sort( sortFunction )
 
    for i = 1, self.listbox:GetItemCount() do

        local item = self.listbox:GetItem(i)
        item:Sort( sortFunction )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function FolderItem:DraggingEnd( fromData )

	local left, top = self.listbox:GetMousePosition()

	local toItem = self.listbox:GetItemAt(left, top)

	if toItem ~= nil then
		if toItem.data ~= fromData then
			toItem:DraggingEnd( fromData )
		end

	else
		fromData.folder = self.index * (-1)

	end

end
---------------------------------------------------------------------------------------------------
