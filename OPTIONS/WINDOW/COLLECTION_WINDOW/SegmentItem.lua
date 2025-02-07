--=================================================================================================
--= collection window
--= ===============================================================================================
--= 
--=================================================================================================



SegmentItem = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function SegmentItem:Constructor( width, name_control, name_description, parent, index )
	Turbine.UI.Control.Constructor( self )

	self.controls = {}
	self.index = index
	self.parent = parent
	self.open = false

	self.name_control = name_control
	self.name_description = name_description

	-- self:SetBackColor( Options.Defaults.window.basecolor )

	self.name = Turbine.UI.Label()
	self.name:SetParent( self )
	-- self.name:SetPosition( Options.Defaults.window.frame, Options.Defaults.window.frame	)
	self.name:SetBackColor(	Options.Defaults.window.basecolor )
	self.name:SetHeight( Options.Defaults.window.segment_height - 4 )
	self.name:SetFont( Options.Defaults.window.w_font )
	self.name:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter )
	-- self.name:SetMouseVisible( false )

	self.listbox = Turbine.UI.ListBox()
	self.listbox:SetParent( self )
	self.listbox:SetBackColor( Options.Defaults.window.backcolor1 )
	self.listbox:SetTop( Options.Defaults.window.segment_height )
	self.listbox:SetHeight( Options.Defaults.window.segment_height )
	self.listbox:SetMouseVisible( false )

	self.scrollbar = Turbine.UI.Lotro.ScrollBar()
	self.scrollbar:SetParent( self )
	self.scrollbar:SetTop( Options.Defaults.window.segment_height )
    self.scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical)
	-- self.scrollbar:SetBackColor( Options.Defaults.window.framecolor )
  	self.scrollbar:SetWidth( 10 )

    self.listbox:SetVerticalScrollBar( self.scrollbar )

	self.name.MouseEnter = function ()
		self.name:SetBackColor( Options.Defaults.window.w_window_hover )
	end

	self.name.MouseLeave = function ()
		self.name:SetBackColor(	Options.Defaults.window.basecolor )
	end

	self.name.MouseClick = function ()
		self.parent:SegmentClicked( self )
		Data.options.window.collection_segment = self.index
	end

	self:LanguageChanged()
	self:SetHeight( Options.Defaults.window.segment_height )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function SegmentItem:Open( value, height )

	self.open = value

	-- open
	if value == true then
		self:SetHeight( height )

	-- collapsed
	else
		self:SetHeight( Options.Defaults.window.segment_height )

	end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function SegmentItem:LanguageChanged()

	self.name:SetText( UTILS.GetText( self.name_control, self.name_description ) )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function SegmentItem:SizeChanged()

	local  width, height = self:GetSize()

	if self.open == false then
		height = Options.Defaults.window.segment_height
	end

	self.name:SetWidth( width )
	self.listbox:SetSize( width, height - Options.Defaults.window.segment_height )
	self.scrollbar:SetLeft( width - 10 )
	self.scrollbar:SetHeight( self.listbox:GetHeight() )

	for i = 1, self.listbox:GetItemCount() do
		local item = self.listbox:GetItem( i )
		item:SetWidth( width )
	end
	

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function SegmentItem:SetList( list, filter )

	local width = self.listbox:GetWidth()

	self.controls = {}
	self.listbox:ClearItems()

	for index, data in ipairs(list) do
		self.controls[ index ] = Item( width, data, self.index, self.parent )
	end

	self:FillContent( filter )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function SegmentItem:FillContent( text )

	self.listbox:ClearItems()

	for index, control in ipairs(self.controls) do

		if string.find( string.lower( control.data.token ) , text ) then
			self.listbox:AddItem( control )
		end
	end

	self.listbox:Sort(function(a,b) 
		return a.data.token < b.data.token
	end)

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function SegmentItem:Filter( text )
	self:FillContent( text )
end
---------------------------------------------------------------------------------------------------
