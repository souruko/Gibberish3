--===================================================================================
--             Name:    Tooltip
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
Options.Constructor.Tooltip = class( Turbine.UI.Window )






-------------------------------------------------------------------------------------
--      Description:    Tooltip constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, mouseclick function
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.Tooltip:Constructor()
	Turbine.UI.Window.Constructor( self )

    self:SetMouseVisible(false)
    self:SetBackColor( Defaults.Colors.AccentColor6 )
    self:SetZOrder(200)

    self.heading = Turbine.UI.Label()
    self.heading:SetParent(self)
    self.heading:SetPosition(2, 2)
    self.heading:SetHeight( 18 )
    self.heading:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleCenter )
    self.heading:SetFont(                 Defaults.Fonts.TabFont )

    self.background = Turbine.UI.Control()
    self.background:SetParent(self)
    self.background:SetPosition( 2, 20)
    self.background:SetBackColor( Defaults.Colors.AccentColor5 )
    
    self.text = Turbine.UI.Label()
    self.text:SetParent(self)
    self.text:SetPosition(2, 20)
    self.text:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleCenter )
    self.text:SetFont(                 Defaults.Fonts.SmallFont )
 
    self:SetVisible(false)
   
end

-------------------------------------------------------------------------------------
--      Description:    Tooltip SetChecked
-------------------------------------------------------------------------------------
--        Parameter:    checked
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.Tooltip:Show( left, top, width, height, heading, text  )

    self:SetPosition(left, top)
    self:SetSize(width, height)

    self.heading:SetWidth( width - 4 )
    self.background:SetSize( width - 4, height - 22 )
    self.text:SetSize( width - 4, height - 22 )

    self.heading:SetText(heading)
    self.text:SetText(text)

    self:SetVisible(true)

end


-------------------------------------------------------------------------------------
--      Description:    Tooltip SetChecked
-------------------------------------------------------------------------------------
--        Parameter:    checked
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.Tooltip:Hide()


    self:SetVisible(false)


end
