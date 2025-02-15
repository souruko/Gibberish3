--=================================================================================================
--= collection window
--= ===============================================================================================
--= 
--=================================================================================================



Item = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function Item:Constructor( width, data, type, parent )
	Turbine.UI.Control.Constructor( self )

	self.parent = parent
	self.type = type
	self.data = data

	self.token = Turbine.UI.Label()
	self.token:SetParent( self )
	self.token:SetFont( Options.Defaults.window.font )
	self.token:SetTextAlignment( Turbine.UI.ContentAlignment.TopLeft )
	self.token:SetText( data.token )
	self.token:SetLeft( 38 )
	self.token:SetMouseVisible( false )
	
	self.timer = Turbine.UI.Label()
	self.timer:SetParent( self )
	self.timer:SetFont( Options.Defaults.window.font )
	self.timer:SetTextAlignment( Turbine.UI.ContentAlignment.BottomLeft )
	self.timer:SetLeft( 38 )
	self.timer:SetMouseVisible( false )
	if data.timer ~= nil then
		self.timer:SetText( data.timer .. "s" )
	end

	self.icon = Turbine.UI.Control()
	self.icon:SetParent( self )
	self.icon:SetPosition( 4, 2 )
	self.icon:SetSize(32, 32)
	self.icon:SetMouseVisible( false )
    self.icon:SetBlendMode(Turbine.UI.BlendMode.Overlay)
	
	if data.icon ~= nil then
		self.icon:SetBackground( data.icon )
	else
		self.icon:SetBackColor(Turbine.UI.Color.Black)
	end

	self.MouseEnter = function ()
		if self.data.persistent == false then
			self:SetBackColor( Options.Defaults.window.segmenthover )
		else
			self:SetBackColor( Options.Defaults.window.framecolor )
		end
	end

	self.MouseLeave = function ()
		if self.data.persistent == false then
			self:SetBackColor(	nil )
		else
			self:SetBackColor( Options.Defaults.window.w_window_hover )
		end
	end

	self.MouseClick = function (sender, args)
		
        if args.Button == Turbine.UI.MouseButton.Right then
			self:RightClick()
		else
			self:LeftClick()
		end

	end

	self:PersistentChanged()
	self:SetSize( width, Options.Defaults.window.segment_item_height)

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Item:SizeChanged()

	local  width, height = self:GetSize()

	self.token:SetSize( width - 50, height)
	self.timer:SetSize( width - 50, height)

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Item:PersistentChanged()

	if self.data.persistent == true then
		self:SetBackColor( Options.Defaults.window.w_window_hover )
		
	else
		self:SetBackColor(	nil )

	end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Item:LeftClick()

	self.data.persistent = not( self.data.persistent )

	if self.data.persistent == true then
		Options.KeepInCollection( self.data, self.type )

	else
		Options.RemoveFromCollection( Options.CheckForIndexInCollection( self.data, self.type ) )

	end

	self:PersistentChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Item:RightClick()

	self.parent:CollectionItemClicked( self.data )

end
---------------------------------------------------------------------------------------------------

