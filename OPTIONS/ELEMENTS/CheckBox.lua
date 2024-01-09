--=================================================================================================
--= CheckBox
--= ===============================================================================================
--= 
--=================================================================================================



Options.Elements.CheckBox = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function Options.Elements.CheckBox:Constructor()
	Turbine.UI.Control.Constructor( self )

    self.checked = false

    self:SetSize( 32 , 32 )
    self:SetBlendMode( Turbine.UI.BlendMode.Overlay )
    self:SetBackground( "Gibberish3/RESOURCES/switch_off.tga" )
    self.MouseClick = function ()

        self:SetChecked( not( self.checked ) )
        self.CheckedChanged( self.checked )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.CheckBox:SetChecked( value )

    self.checked = value

    if value == true then
        self:SetBackground( "Gibberish3/RESOURCES/switch_on.tga" )

    else
        self:SetBackground( "Gibberish3/RESOURCES/switch_off.tga" )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.CheckBox:IsChecked()

    return self.checked

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.CheckBox.CheckedChanged( value )

end
---------------------------------------------------------------------------------------------------

