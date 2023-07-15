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
    self:SetBackColor( Defaults.Colors.Tooltip )
    self:SetZOrder(200)

    self.background = Turbine.UI.Control()
    self.background:SetParent(self)
    self.background:SetPosition( 2, 2)
    self.background:SetBackColor( Defaults.Colors.Tooltip2 )
    self.background:SetMouseVisible(         false )
    
    self.text = Turbine.UI.Label()
    self.text:SetParent(self)
    self.text:SetPosition(2, 2)
    self.text:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleCenter )
    self.text:SetFont(                 Defaults.Fonts.SmallFont )
    self.text:SetMouseVisible(         false )
 
    self:SetVisible(false)
   
end

-------------------------------------------------------------------------------------
--      Description:    Tooltip SetChecked
-------------------------------------------------------------------------------------
--        Parameter:    checked
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.Tooltip:Show( left, top, text )

    local width  = 200

    local height = (math.floor(string.len(text) /35) + 2) * 14

    left = left - 70

    self:SetPosition(left, top)
    self:SetSize(width, height)

    self.background:SetSize( width - 4, height - 4 )
    self.text:SetSize( width - 4, height - 4 )

    self.text:SetText(text)

    self.activationTime = Turbine.Engine.GetGameTime() + Data.options.window.tooltipActivationDelay
    self:SetWantsUpdates(true)

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.Tooltip:Update()

    local currentTime = Turbine.Engine.GetGameTime()

    if self.activationTime <= currentTime then

        self:SetWantsUpdates(false)
        self:SetVisible(true)

    end

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
    self:SetWantsUpdates(false)

end


-------------------------------------------------------------------------------------
--      Description:    Tooltip SetChecked
-------------------------------------------------------------------------------------
--        Parameter:    checked
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.Tooltip.AddTooltip( control, text, always )

    control.MouseEnter = function ()

        if always == true or Data.showTooltips == true then

            local left, top = control:PointToScreen( control:GetWidth()/-2 ,40)
        
            Options.MainWindow.ShowTooltip( left, top, text )

        end
        
    end

    control.MouseLeave = function ()
        
        Options.MainWindow.HideTooltip()
        
    end

end
