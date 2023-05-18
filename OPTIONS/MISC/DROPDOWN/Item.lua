--===================================================================================
--             Name:    Dropdown
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
Item = class( Turbine.UI.Control )






-------------------------------------------------------------------------------------
--      Description:    Dropdown constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, mouseclick function
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Item:Constructor( parent, width, height, text, value )
	Turbine.UI.Control.Constructor( self )

    local left_spacing = 5

    self.value = value
    self.selected = false
    self.parent = parent

    self:SetSize( width, height )
    self.MouseClick = function (sender, args)
        
        if self.selected == false then
            self.parent:ItemClicked( self )
        end

    end
    self.MouseEnter = function ()

        if self.selected == false then
            self:SetBackColor( Defaults.Colors.BackgroundColor4 )
        end
        
    end

    self.MouseLeave = function ()

        self:SetBackColor( nil )

    end

    self.label = Turbine.UI.Label()
    self.label:SetParent(self)
    self.label:SetSize( width - left_spacing - 10, height )
    self.label:SetLeft(left_spacing)
    self.label:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
    self.label:SetFont(                 Defaults.Fonts.TabFont )
    self.label:SetText( text )
    self.label:SetMouseVisible(false)

end


-------------------------------------------------------------------------------------
--      Description:    TabWindow Deselect
-------------------------------------------------------------------------------------
--        Parameter:    parent, mouseclick function
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Item:Deselect()

    self.label:SetForeColor( Turbine.UI.Color.White )
    self.selected = false

end

-------------------------------------------------------------------------------------
--      Description:    TabWindow Deselect
-------------------------------------------------------------------------------------
--        Parameter:    parent, mouseclick function
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Item:Select()

    self.selected = true
    self.label:SetForeColor( Defaults.Colors.BackgroundColor5 )

end
