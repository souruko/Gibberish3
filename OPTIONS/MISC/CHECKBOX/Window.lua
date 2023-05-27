--===================================================================================
--             Name:    CheckBox
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
Options.Constructor.CheckBox = class( Turbine.UI.Control )






-------------------------------------------------------------------------------------
--      Description:    CheckBox constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, mouseclick function
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.CheckBox:Constructor( parent, func )
	Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.checked = false

    self:SetParent( parent )
    self:SetSize(32, 32)
    self:SetBlendMode( Turbine.UI.BlendMode.Overlay )
    self:SetBackground( "Gibberish3/RESOURCES/switch_off.tga" )
    self.MouseClick = function ()
        
        self:SetChecked( not(self.checked) )

        func()

    end

end

-------------------------------------------------------------------------------------
--      Description:    CheckBox SetChecked
-------------------------------------------------------------------------------------
--        Parameter:    checked
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.CheckBox:SetChecked( checked )

    self.checked = checked

    if checked == true then
        self:SetBackground( "Gibberish3/RESOURCES/switch_on.tga" )
    else
        self:SetBackground( "Gibberish3/RESOURCES/switch_off.tga" )
    end

end


-------------------------------------------------------------------------------------
--      Description:    CheckBox IsChecked
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     checked
-------------------------------------------------------------------------------------
function Options.Constructor.CheckBox:IsChecked()

    return self.checked

end


