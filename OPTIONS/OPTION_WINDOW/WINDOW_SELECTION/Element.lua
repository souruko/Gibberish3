--===================================================================================
--             Name:    Window selection
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
Options.Constructor.WindowSelection = class( Turbine.UI.Control )





-------------------------------------------------------------------------------------
--      Description:    window selection constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent
--                      width
--                      height
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:Constructor( parent )
	Turbine.UI.Control.Constructor( self )


    self.parent = parent

    self:SetBackColor(  Defaults.Colors.BackgroundColor2 )

    self:SetParent(     parent)

end




-------------------------------------------------------------------------------------
--      Description:    finish and close window
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.WindowSelection:Finish()

    self:SetVisible(false)

    self:Close()

end
