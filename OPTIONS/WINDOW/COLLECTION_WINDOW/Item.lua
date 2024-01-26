--=================================================================================================
--= collection window
--= ===============================================================================================
--= 
--=================================================================================================



Item = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function Item:Constructor( width, data )
	Turbine.UI.Control.Constructor( self )

	self.data = data

	self.token = Turbine.UI.Label()
	self.token:SetParent( self )
	self.token:SetFont( Options.Defaults.window.font )
	self.token:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft )
	self.token:SetText( data.token )
	self.token:SetLeft( 35 )
	
	self.icon = Turbine.UI.Control()
	self.icon:SetParent( self )
	self.icon:SetTop( 2 )
	self.icon:SetSize(32, 32)
	
	if data.icon ~= nil then
		self.icon:SetBackground( data.icon )
	else
		self.icon:SetBackColor(Turbine.UI.Color.Black)
	end

	self.MouseEnter = function ()
		self:SetBackColor( Options.Defaults.window.segmenthover )
	end

	self.MouseLeave = function ()
		self:SetBackColor(	nil )
	end

	self:SetSize( width, Options.Defaults.window.segment_item_height)

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Item:SizeChanged()

	local  width, height = self:GetSize()

	self.token:SetSize( width - 50, height)

end
---------------------------------------------------------------------------------------------------

