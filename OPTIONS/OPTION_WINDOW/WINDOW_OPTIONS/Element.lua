--===================================================================================
--             Name:    Window Options
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
Options.Constructor.WindowOptions = class(Turbine.UI.Control)





-------------------------------------------------------------------------------------
--      Description:    Window Options constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent
--                      width
--                      height
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.WindowOptions:Constructor( parent )
	Turbine.UI.Control.Constructor( self )

    self.parent = parent


    self:SetBackColor( Defaults.Colors.BackgroundColor2 )


    self:SetParent(parent)

end




-------------------------------------------------------------------------------------
--      Description:    template constructor
-------------------------------------------------------------------------------------
--        Parameter:    group data 
-------------------------------------------------------------------------------------
--           Return:    group template element
-------------------------------------------------------------------------------------
function Options.Constructor.WindowOptions:Finish(  )

    self:SetVisible(false)

end
