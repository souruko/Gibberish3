--===================================================================================
--             Name:    seperator
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
Seperator = class(Turbine.UI.Control)






-------------------------------------------------------------------------------------
--      Description:    seperator constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent
--                      width
--                      height
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Seperator:Constructor( parent, width, height )
	Turbine.UI.Control.Constructor( self )

    self.parent             = parent

    local line_thickness    = 2
    local spacing           = 5
    local line_width        = width - 2 * spacing
    local line_top          = (height / 2) - (line_thickness / 2)

    self:SetSize(           width, height )
    self:SetMouseVisible(   true )

    self.line               = Turbine.UI.Control()
    self.line:SetParent(    self )
    self.line:SetBackColor( Defaults.Colors.MenuColor2 )
    self.line:SetSize(      line_width, line_thickness )
    self.line:SetPosition(  spacing, line_top )

end




-------------------------------------------------------------------------------------
--      Description:    deactivate
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------

function Seperator:Deactivate( )

end



