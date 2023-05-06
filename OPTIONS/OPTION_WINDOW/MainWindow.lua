--===================================================================================
--             Name:    OPTIONS MAIN WINDOW
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
OptionsMainWindow = class(Turbine.UI.Lotro.Window)





-------------------------------------------------------------------------------------
--      Description:    template constructor
-------------------------------------------------------------------------------------
--        Parameter:    group data 
-------------------------------------------------------------------------------------
--           Return:    group template element
-------------------------------------------------------------------------------------
function OptionsMainWindow:Constructor(  )
	Turbine.UI.Lotro.Window.Constructor( self )

    self.width  = 1080
    self.height = 720



    self:SetText("Gibberish")
    self:SetSize(self.width, self.height)



    self:SetVisible(true)

end




-------------------------------------------------------------------------------------
--      Description:    template constructor
-------------------------------------------------------------------------------------
--        Parameter:    group data 
-------------------------------------------------------------------------------------
--           Return:    group template element
-------------------------------------------------------------------------------------
function OptionsMainWindow:Finish(  )

    self:SetVisible(false)

    

end
