--===================================================================================
--             Name:    sub menu row
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
SubMenuRow = class(Turbine.UI.Control)






-------------------------------------------------------------------------------------
--      Description:    sub menu row constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent
--                      width
--                      height
--                      text
--                      subMenu
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function SubMenuRow:Constructor( parent, width, height, text, subMenu )
	Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.subMenu = subMenu

    self:SetSize(width, height)
    self:SetMouseVisible(true)

    self.text = Turbine.UI.Label()
    self.text:SetParent(self)
    self.text:SetSize(width - 30, height)
    self.text:SetLeft(30)
    self.text:SetTextAlignment ( Turbine.UI.ContentAlignment.MiddleLeft )
    self.text:SetFont( Defaults.Fonts.SmallFont )
    self.text:SetText(text)
    self.text:SetMouseVisible(false)

end



-------------------------------------------------------------------------------------
--      Description:    mouse enter
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
function SubMenuRow:MouseEnter( sender, args )

    self:SetBackColor( Defaults.Colors.AccentColor7 )

    self.parent:HoverChanged( self )

    local left, top = self:GetPosition()
    local left      = left + self:GetWidth()
    local top       = top

    self.subMenu:Show( left, top )

end




-------------------------------------------------------------------------------------
--      Description:    deactivate
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------

function SubMenuRow:Deactivate()

    self:SetBackColor( nil )

    self.subMenu:SetVisible( false )
    
end


