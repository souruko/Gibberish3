--===================================================================================
--             Name:    right click menu row
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
Row = class(Turbine.UI.Control)






-------------------------------------------------------------------------------------
--      Description:    right click menu row constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent
--                      width
--                      height
--                      text
--                      function()
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Row:Constructor(parent, width, height, text, func )
	Turbine.UI.Control.Constructor( self )

    local text_left = 15

    self.parent               = parent
    self.func                 = func

    self:SetSize(               width, height )
    self:SetMouseVisible(       true )

    self.text                 = Turbine.UI.Label()
    self.text:SetParent(        self )
    self.text:SetSize(          width - text_left, height )
    self.text:SetLeft(          text_left )
    self.text:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft )
    self.text:SetFont(          Defaults.Fonts.SmallFont )
    self.text:SetText(          text )
    self.text:SetMouseVisible(  false )

end


-------------------------------------------------------------------------------------
--      Description:    mouse click
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
function Row:MouseClick( sender, args )

    self.func()

    self.parent:Hide()

end


-------------------------------------------------------------------------------------
--      Description:    mouse enter
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:   
-------------------------------------------------------------------------------------
function Row:MouseEnter( sender, args )

    self:SetBackColor(          Defaults.Colors.MenuColor2 )
    self.parent:HoverChanged(   self )

end




-------------------------------------------------------------------------------------
--      Description:    deactivate
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------

function Row:Deactivate( )

    self:SetBackColor( nil )
    
end


