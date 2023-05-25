--===================================================================================
--             Name:    TabWindow
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
 Options.Constructor.Tab = class( Turbine.UI.Control )






-------------------------------------------------------------------------------------
--      Description:    TabWindow constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, mouseclick function
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.Tab:Constructor()
	Turbine.UI.Control.Constructor( self )

    self.selected = false

    self:SetMouseVisible(false)

    self.header = Turbine.UI.Control()
    self.header:SetBackColor( Defaults.Colors.BackgroundColor1 )
    self.header:SetHeight( 30 )

    self.header.label = Turbine.UI.Label()
    self.header.label:SetParent(self.header)
    self.header.label:SetHeight( 30 )
    self.header.label:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleCenter )
    self.header.label:SetFont(                 Defaults.Fonts.TabFont )
    self.header.label:SetMouseVisible(  false )

    self.header.MouseEnter = function ()

        if self.selected == false then
            self.header:SetBackColor( Defaults.Colors.BackgroundColor3 )
        end
        
    end

    self.header.MouseLeave = function ()

        if self.selected == false then
            self.header:SetBackColor( Defaults.Colors.BackgroundColor1 )
        end
    end

    self.header.MouseClick = function ()

        self:Select()

    end

end


-------------------------------------------------------------------------------------
--      Description:    TabWindow Deselect
-------------------------------------------------------------------------------------
--        Parameter:    parent, mouseclick function
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.Tab:Deselect()

    self.header:SetBackColor( Defaults.Colors.BackgroundColor1 )
    self.selected = false

end

-------------------------------------------------------------------------------------
--      Description:    TabWindow Deselect
-------------------------------------------------------------------------------------
--        Parameter:    parent, mouseclick function
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.Tab:Select()

    self.selected = true
    self.header:SetBackColor( Defaults.Colors.BackgroundColor2 )
    self.tabwindow:SelectionChanged(self)

end

-------------------------------------------------------------------------------------
--      Description:    TabWindow SetName
-------------------------------------------------------------------------------------
--        Parameter:    name
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.Tab:SetName( name )

    self.header.label:SetText( name )

end


-------------------------------------------------------------------------------------
--      Description:    TabWindow SetTabWindow
-------------------------------------------------------------------------------------
--        Parameter:    tabwindow
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.Tab:SetTabWindow( tabwindow )

    self.tabwindow = tabwindow
    self.header:SetWidth( self.tabwindow.header_width )
    self.header.label:SetWidth( self.tabwindow.header_width )

end
