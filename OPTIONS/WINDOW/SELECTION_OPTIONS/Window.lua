--=================================================================================================
--= selection options
--= ===============================================================================================
--= 
--=================================================================================================



Options.Elements.SelectionOptions = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function Options.Elements.SelectionOptions:Constructor()
	Turbine.UI.Control.Constructor( self )

	self.import = false

	self.selectedData = nil

	self:CreatBackground()
	self:CreateToolbar()

	self.import_window = Options.Elements.ImportWindow( self )
	self.import_window:SetVisible(false)
	self.import_window:SetParent( self.background2 )

	self.content = nil
	self.collection_menu = nil

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.SelectionOptions:LanguageChanged()
	self.import_window:LanguageChanged()

	if self.content == nil then
		return
	end

	self.content:LanguageChanged()
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.SelectionOptions:CloseImport()

	self.import = false
	self.import_window:SetVisible(false)

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.SelectionOptions:Save()

	if self.content == nil then
		return
	end

	local name = self.name_textbox:GetText()

	if name ~= self.selectedData.name then
		self.selectedData.name = name

	end

	self.content:Save()
	Options.SaveData()

	Options.DataChanged( Data.selectedIndex )

	if Data.selectedIndex > 0 then
		Windows.EnabledChanged( Data.selectedIndex )
	end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.SelectionOptions:Reset()

	if self.content == nil then
		return
	end

	self.name_textbox:SetText( self.selectedData.name )
	self.content:Reset()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.SelectionOptions:SelectionChanged()

	self:CloseContent()

	-- no selection
	if Data.selectedIndex == 0 then
		self.selectedData = nil
	
	-- folder
	elseif Data.selectedIndex < 0 then
		self.selectedData = Data.folder[ Data.selectedIndex * (-1) ]
		self.name_back:SetBackColor( Options.Defaults.window.w_folder_base )
		-- self.background2:SetBackColor( Options.Defaults.window.w_folder_base )
		self.name_textbox:SetText( self.selectedData.name )
		self:FillFolder()

	-- window
	else
		self.selectedData = Data.window[ Data.selectedIndex ]
		self.name_back:SetBackColor( Options.Defaults.window.backcolor2 )
		-- self.background2:SetBackColor( Options.Defaults.window.backcolor2 )
		self.name_textbox:SetText( self.selectedData.name )
		self:FillWindow()
		
	end

	if self.import == true then
		self:ImportClicked()
	end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.SelectionOptions:BuildCollectionRightClickMenu( data )

	-- only display a menu if content is not empty
	if self.content == nil then
		return
	end

	-- clear old menu
	if self.collection_menu ~= nil then
		self.collection_menu:Close()
		self.collection_menu = nil
	end

	self.collection_menu = Options.Elements.RightClickMenu( 150 )

	local row =  Options.Elements.Row(
		"collection",
		"window_name",
		function ()
			self.name_textbox:SetText( data.token )
		end,
		Options.Defaults.rc_menu.item_height
	)
	self.collection_menu:AddRow( row )

	-- build menu for children
	self.content:BuildCollectionRightClickMenu( data, self.collection_menu )

	self.collection_menu:Show( nil, nil, Turbine.UI.ContentAlignment.TopLeft )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.SelectionOptions:TriggerSelectionChanged()

	if self.content ~= nil then
		self.content:TriggerSelectionChanged()
	end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.SelectionOptions:Trigger2SelectionChanged()

	if self.content ~= nil then
		self.content:Trigger2SelectionChanged()
	end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.SelectionOptions:TimerSelectionChanged()

	if self.content ~= nil then
    	self.content:TimerSelectionChanged()
	end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.SelectionOptions:CloseContent()

	if self.content == nil then
		return
	end

	self.content:SetParent( nil )
	self.content:Close()
	self.content = nil

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.SelectionOptions:FillFolder()

	self.content = Options.Elements.FolderOptions( self, self.selectedData )
	self.content:SetParent( self.background2 )
	self.content:SetSize( self.background2:GetSize() )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.SelectionOptions:FillWindow()

	self.content = Window[ self.selectedData.type ].Options( self, self.selectedData )
	self.content:SetParent( self.background2 )
	self.content:SetSize( self.background2:GetSize() )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.SelectionOptions:SizeChanged()

	local width, height = self:GetSize()

	-- calclulate size
	local background1_width  = width - ( 2 * Options.Defaults.window.spacing )
	local background1_height = height - ( 2 * Options.Defaults.window.spacing )

	local frame_width        = background1_width - ( 2 * Options.Defaults.window.spacing )
	local frame_height       = background1_height - ( 2 * Options.Defaults.window.spacing )

	local background2_width  = frame_width - ( 2 * Options.Defaults.window.frame )
	local background2_height = frame_height - ( 3 * Options.Defaults.window.frame ) -  Options.Defaults.window.toolbar_height

	local name_width         = background2_width - ( 4 * Options.Defaults.window.toolbar_height ) - ( 4 * Options.Defaults.window.frame )

	-- set size
	self.background1:SetSize( background1_width, background1_height )
	self.frame:SetSize( frame_width, frame_height )
	self.background2:SetSize( background2_width, background2_height )
	if self.content ~= nil then
		self.content:SetSize( background2_width, background2_height )
	end

	self.reset_back:SetSize( Options.Defaults.window.toolbar_height, Options.Defaults.window.toolbar_height)
	self.save_back:SetSize( Options.Defaults.window.toolbar_height, Options.Defaults.window.toolbar_height)
	self.import_back:SetSize( Options.Defaults.window.toolbar_height, Options.Defaults.window.toolbar_height)
	self.reload_back:SetSize( Options.Defaults.window.toolbar_height, Options.Defaults.window.toolbar_height)

	self.name_back:SetSize( name_width, Options.Defaults.window.toolbar_height)
	self.name_textbox:SetSize( name_width, Options.Defaults.window.toolbar_height)

	-- calclulate position
	local background1_pos    =  Options.Defaults.window.spacing
	local frame_pos          =  Options.Defaults.window.spacing
	local background2_left   =  Options.Defaults.window.frame 
	local background2_top    = ( 2 * Options.Defaults.window.frame ) + Options.Defaults.window.toolbar_height
	local reset_left         = Options.Defaults.window.frame
	local save_left          = reset_left + Options.Defaults.window.frame + Options.Defaults.window.toolbar_height

	local name_left          = save_left + Options.Defaults.window.frame + Options.Defaults.window.toolbar_height

	local reload_left        = frame_width - Options.Defaults.window.frame - Options.Defaults.window.toolbar_height
	local import_left        = reload_left - Options.Defaults.window.frame - Options.Defaults.window.toolbar_height
	

	-- set position
	self.background1:SetPosition( background1_pos, background1_pos )
	self.frame:SetPosition( frame_pos, frame_pos )
	self.background2:SetPosition( background2_left, background2_top )
	
	self.reset_back:SetPosition( reset_left, Options.Defaults.window.frame )
	self.save_back:SetPosition( save_left, Options.Defaults.window.frame )
	self.import_back:SetPosition( import_left, Options.Defaults.window.frame )
	self.reload_back:SetPosition( reload_left, Options.Defaults.window.frame )

	self.name_back:SetPosition( name_left, Options.Defaults.window.frame)
	
	
	self.import_window:SetSize( self.background2:GetSize() )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.SelectionOptions:CreatBackground()

	self:SetBackColor( Options.Defaults.window.basecolor )

	-- background
	self.background1 = Turbine.UI.Control()
	self.background1:SetParent( self )
	self.background1:SetBackColor( Options.Defaults.window.backcolor1 )

	self.frame = Turbine.UI.Control()
	self.frame:SetParent( self.background1 )
	self.frame:SetBackColor( Options.Defaults.window.framecolor )

	self.background2 = Turbine.UI.Control()
	self.background2:SetParent( self.frame )
	self.background2:SetBackColor( Options.Defaults.window.backcolor2 )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.SelectionOptions:CreateToolbar()

	-- reset button
	self.reset_back = Turbine.UI.Control()
	self.reset_back:SetParent( self.frame )
	self.reset_back:SetBackColor( Options.Defaults.window.backcolor2 )

	self.reset_button = Turbine.UI.Button()
	self.reset_button:SetParent( self.reset_back )
	self.reset_button:SetBlendMode( Turbine.UI.BlendMode.Overlay )
	self.reset_button:SetBackground( "Gibberish3/RESOURCES/back.tga" )
	self.reset_button:SetPosition( 0, 0 )
	Options.Elements.Tooltip.AddTooltip( self.reset_button, "tooltip", "button_reset", false )
	self.reset_button.Click = function ()
		self:Reset()
	end
	
	-- save button
	self.save_back = Turbine.UI.Control()
	self.save_back:SetParent( self.frame )
	self.save_back:SetBackColor( Options.Defaults.window.backcolor2 )

	self.save_button = Turbine.UI.Button()
	self.save_button:SetParent( self.save_back )
	self.save_button:SetBlendMode( Turbine.UI.BlendMode.Overlay )
	self.save_button:SetBackground( "Gibberish3/RESOURCES/save.tga" )
	self.save_button:SetPosition( 0, 0 )
	Options.Elements.Tooltip.AddTooltip( self.save_button, "tooltip", "button_save", false )
	self.save_button.Click = function ()
		self:Save()
	end
	
	-- import button
	self.import_back = Turbine.UI.Control()
	self.import_back:SetParent( self.frame )
	self.import_back:SetBackColor( Options.Defaults.window.backcolor2 )

	self.import_button = Turbine.UI.Button()
	self.import_button:SetParent( self.import_back )
	self.import_button:SetBlendMode( Turbine.UI.BlendMode.Overlay )
	self.import_button:SetBackground( "Gibberish3/RESOURCES/import.tga" )
	self.import_button:SetPosition( 0, 0 )
	self.import_button.Click = function ()
		self:ImportClicked()
	end
	Options.Elements.Tooltip.AddTooltip( self.import_button, "tooltip", "button_import", false )
	
	-- reload button
	self.reload_back = Turbine.UI.Control()
	self.reload_back:SetParent( self.frame )
	self.reload_back:SetBackColor( Options.Defaults.window.backcolor2 )

	self.reload_button = Turbine.UI.Button()
	self.reload_button:SetParent( self.reload_back )
	self.reload_button:SetBlendMode( Turbine.UI.BlendMode.Overlay )
	self.reload_button:SetBackground( "Gibberish3/RESOURCES/reload.tga" )
	self.reload_button:SetPosition( 0, 0 )
	self.reload_button.Click = function ()
		Options.Reload()
	end
	Options.Elements.Tooltip.AddTooltip( self.reload_button, "tooltip", "button_reload", false )

	-- name
	self.name_back = Turbine.UI.Control()
	self.name_back:SetParent( self.frame )
	self.name_back:SetBackColor( Options.Defaults.window.backcolor2 )

	self.name_textbox = Turbine.UI.TextBox()
	self.name_textbox:SetParent( self.name_back )
	self.name_textbox:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft )
	self.name_textbox:SetFont( Options.Defaults.window.w_font )
    self.name_textbox:SetForeColor( Options.Defaults.window.textcolor )
    self.name_textbox:SetSelectable( true )
    self.name_textbox:SetMultiline( false )
	self.name_textbox:SetLeft( 5 )
	
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.SelectionOptions:ImportClicked()

	self.import = not(self.import)
	self.import_window:ShowImport()
	self.import_window:SetVisible(self.import)

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.SelectionOptions:ShowExport( data, type, index )

	self.import = true
	self.import_window:ShowExport( data, type, index )
	self.import_window:SetVisible( self.import )

end
---------------------------------------------------------------------------------------------------
