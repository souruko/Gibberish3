--===================================================================================
--             Name:    General Options
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
Options.Constructor.GeneralOptions = class(Turbine.UI.Control)





-------------------------------------------------------------------------------------
--      Description:    General Options constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent
--                      width
--                      height
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.GeneralOptions:Constructor( parent )
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
function Options.Constructor.GeneralOptions:Finish(  )

    self:SetVisible(false)

end
