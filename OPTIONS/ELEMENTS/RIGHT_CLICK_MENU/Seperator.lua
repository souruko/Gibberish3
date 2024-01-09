--=================================================================================================
--= Shortcut Action Button
--= ===============================================================================================
--= 
--=================================================================================================



 Options.Elements.Seperator = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function   Options.Elements.Seperator:Constructor( width, height, parent )
	Turbine.UI.Control.Constructor( self )

    self.parent = parent

    self:SetSize( width, height )
    self:SetMouseVisible( true )

    self.line = Turbine.UI.Control()
    self.line:SetParent( self )
    self.line:SetBackColor( Turbine.UI.Color(0.2,0.2,0.2) )
    self.line:SetSize( ( width  ), 1 )
    self.line:SetPosition( 0, ( height / 2 ) - 1 )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function  Options.Elements.Seperator:Hover( value )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function  Options.Elements.Seperator:LanguageChanged(  )

end
---------------------------------------------------------------------------------------------------
