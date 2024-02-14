--=================================================================================================
--= selection options
--= ===============================================================================================
--= 
--=================================================================================================



Options.Elements.ImportWindow = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function Options.Elements.ImportWindow:Constructor( parent )
	Turbine.UI.Control.Constructor( self )

	self.parent = parent
	self:CreatBackground()

	self:SetZOrder(1)

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ImportWindow:LanguageChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ImportWindow:SizeChanged()

	local width, height = self:GetSize()

	-- calclulate size
	local background1_width  = width - ( 2 * Options.Defaults.window.spacing )
	local background1_height = height - ( 2 * Options.Defaults.window.spacing )

	local frame_width        = background1_width - ( 2 * Options.Defaults.window.spacing )
	local frame_height       = background1_height - ( 2 * Options.Defaults.window.spacing )

	local textbox_width  = frame_width - ( 2 * Options.Defaults.window.frame )-10
	local textbox_height = frame_height - ( 3 * Options.Defaults.window.frame ) -  Options.Defaults.window.toolbar_height

	-- set size
	self.background1:SetSize( background1_width, background1_height )
	self.frame:SetSize( frame_width, frame_height )
	self.textbox:SetSize( textbox_width, textbox_height )
	self.scrollbar:SetHeight( textbox_height )

	self.header_back:SetSize( textbox_width +10, Options.Defaults.window.toolbar_height )
	
	-- calclulate position
	local background1_pos    =  Options.Defaults.window.spacing
	local frame_pos          =  Options.Defaults.window.spacing
	local textbox_left   =  Options.Defaults.window.frame 
	local textbox_top    = ( 2 * Options.Defaults.window.frame ) + Options.Defaults.window.toolbar_height
	local c_n_b_left      = textbox_width - 110
	local c_n_b_top      = textbox_height - 35
	local i_b_left      = c_n_b_left - 160
	local i_b_top      = c_n_b_top

	-- set position
	self.background1:SetPosition( background1_pos, background1_pos )
	self.frame:SetPosition( frame_pos, frame_pos )
	self.textbox:SetPosition( textbox_left, textbox_top )
	self.header_back:SetPosition( Options.Defaults.window.frame, Options.Defaults.window.frame )
	self.scrollbar:SetPosition( textbox_width + 2, textbox_top )
	self.create_new_back:SetPosition( c_n_b_left, c_n_b_top )
	self.insert_back:SetPosition( i_b_left, i_b_top )
	
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ImportWindow:CreatBackground()

	self:SetBackColor( Options.Defaults.window.basecolor )

	-- background
	self.background1 = Turbine.UI.Control()
	self.background1:SetParent( self )
	self.background1:SetBackColor( Options.Defaults.window.backcolor1 )

	self.frame = Turbine.UI.Control()
	self.frame:SetParent( self.background1 )
	self.frame:SetBackColor( Options.Defaults.window.framecolor )

	self.textbox = Turbine.UI.Lotro.TextBox()
	self.textbox:SetParent( self.frame )
	self.textbox:SetBackColor( Options.Defaults.window.backcolor2 )
	self.textbox:SetFont( Options.Defaults.move.headerfont )

	self.scrollbar = Turbine.UI.Lotro.ScrollBar()
	self.scrollbar:SetParent( self.frame )
    self.scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical)
	self.scrollbar:SetBackColor( Options.Defaults.window.framecolor )
    self.scrollbar:SetWidth( 10 )
    self.scrollbar:SetTop( 2 )

    self.textbox:SetVerticalScrollBar( self.scrollbar )

	-- background
	self.header_back = Turbine.UI.Label()
	self.header_back:SetParent( self.frame )
	self.header_back:SetBackColor( Options.Defaults.window.backcolor2 )
	self.header_back:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter )
	self.header_back:SetFont( Options.Defaults.window.w_font )

	self.create_new_back = Turbine.UI.Control()
	self.create_new_back:SetParent( self.textbox )
	self.create_new_back:SetSize( 100, Options.Defaults.window.toolbar_height )
	self.create_new_back:SetBackColor( Options.Defaults.window.framecolor )
	self.create_new_back:SetZOrder(100)

	self.create_new_button = Turbine.UI.Button()
	self.create_new_button:SetParent( self.create_new_back )
	self.create_new_button:SetPosition( Options.Defaults.window.frame , Options.Defaults.window.frame )
	self.create_new_button:SetSize( 100 - 2*Options.Defaults.window.frame , Options.Defaults.window.toolbar_height - 2*Options.Defaults.window.frame )
	self.create_new_button:SetBackColor( Options.Defaults.window.w_window_base )
	self.create_new_button:SetFont( Options.Defaults.window.w_font )

	self.create_new_button.MouseEnter = function ()
		self.create_new_button:SetBackColor( Options.Defaults.window.w_window_hover )
	end
	self.create_new_button.MouseLeave = function ()
		self.create_new_button:SetBackColor( Options.Defaults.window.w_window_base )
	end
	self.create_new_button.MouseClick = function ()
		self:CreateNewClicked()
	end

	
	self.insert_back = Turbine.UI.Control()
	self.insert_back:SetParent( self.textbox )
	self.insert_back:SetSize( 150, Options.Defaults.window.toolbar_height )
	self.insert_back:SetBackColor( Options.Defaults.window.framecolor )
	self.insert_back:SetZOrder(100)

	self.insert_button = Turbine.UI.Button()
	self.insert_button:SetParent( self.insert_back )
	self.insert_button:SetPosition( Options.Defaults.window.frame , Options.Defaults.window.frame )
	self.insert_button:SetSize( 150 - 2*Options.Defaults.window.frame , Options.Defaults.window.toolbar_height - 2*Options.Defaults.window.frame )
	self.insert_button:SetBackColor( Options.Defaults.window.w_window_base )
	self.insert_button:SetFont( Options.Defaults.window.w_font )

	self.insert_button.MouseEnter = function ()
		self.insert_button:SetBackColor( Options.Defaults.window.w_window_hover )
	end
	self.insert_button.MouseLeave = function ()
		self.insert_button:SetBackColor( Options.Defaults.window.w_window_base )
	end
	self.insert_button.MouseClick = function ()
		self:InsertIntoClicked()
	end


	self:LanguageChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ImportWindow:ShowExport( data, type )

	self.textbox:SetEnabled( false )
	self.insert_back:SetVisible(false)
	self.create_new_back:SetVisible(false)
	self.header_back:SetText( UTILS.GetText( "import", "export" ) )
	self.textbox:SetText( UTILS.DataToString(data, type) )

	Options.Window.Object:Activate()
	self.textbox:Focus()
	self.textbox:SelectAll()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ImportWindow:ShowImport()

	self.textbox:SetEnabled( true )
	self.insert_back:SetVisible(true)
	self.create_new_back:SetVisible(true)
	self.header_back:SetText( UTILS.GetText( "import", "import" ) )
	self.textbox:SetText( "" )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ImportWindow:LanguageChanged()

	self.create_new_button:SetText( UTILS.GetText("import", "create_new") )
	self.insert_button:SetText( UTILS.GetText("import", "insert_into") )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ImportWindow:InsertIntoClicked()

	local data = UTILS.StringToData( self.textbox:GetText(), true )

	self.textbox:SetText( "" )
	self.parent:CloseImport()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.ImportWindow:CreateNewClicked()

	local data = UTILS.StringToData( self.textbox:GetText(), false )


	self.textbox:SetText( "" )
	self.parent:CloseImport()

end
---------------------------------------------------------------------------------------------------
