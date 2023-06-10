--===================================================================================
--             Name:    TextBox
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
Options.Constructor.TextBox = class( Turbine.UI.Control )






-------------------------------------------------------------------------------------
--      Description:    TextBox constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, width
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.TextBox:Constructor( parent, width, height )
	Turbine.UI.Control.Constructor( self )

    self.activ = false

    if height == nil then
        self.frame_height = 30
    else
        self.frame_height = height
    end
    self.spacing = 2
    local left_spacing = 5

    self.parent = parent
    self.selection = nil
    self.selectedValue = nil
    self.width = width

    self:SetSize( width, self.frame_height)
    self:SetParent( parent )
    self:SetMouseVisible(false)

    self.frame = Turbine.UI.Control()
    self.frame:SetParent(self)
    self.frame:SetSize( width, self.frame_height )
    self.frame:SetBackColor( Defaults.Colors.BackgroundColor4 )

    self.background = Turbine.UI.Control()
    self.background:SetParent(self)
    self.background:SetSize( width - 2*self.spacing, self.frame_height - 2*self.spacing )
    self.background:SetPosition( self.spacing , self.spacing )
    self.background:SetBackColor( Defaults.Colors.BackgroundColor1 )
    self.background:SetMouseVisible(false)

    self.text = Turbine.UI.TextBox()
    self.text:SetParent(self)
    self.text:SetSize( self.background:GetWidth() - left_spacing, self.background:GetHeight() )
    self.text:SetPosition(self.background:GetLeft() + left_spacing, self.background:GetTop() )
    self.text:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
    self.text:SetFont(                 Defaults.Fonts.TabFont )
    self.text:SetSelectable(true)

    
    self.MouseEnter = function ()
        self.background:SetBackColor(Defaults.Colors.BackgroundColor2)
    end
    self.MouseLeave = function ()
        self.background:SetBackColor(Defaults.Colors.BackgroundColor1)
    end

    self:SetVisible(true)

end


-------------------------------------------------------------------------------------
--      Description:    TextBox constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, width
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.TextBox:SetText( text )

    self.text:SetText(text)

end

-------------------------------------------------------------------------------------
--      Description:    TextBox constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, width
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.TextBox:GetText()

    return self.text:GetText()

end

-------------------------------------------------------------------------------------
--      Description:    TextBox constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, width
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.TextBox:SetTextAlignment(value)

    self.text:SetTextAlignment(value)

end

-------------------------------------------------------------------------------------
--      Description:    TextBox constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent, width
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.TextBox:SetMultiline(value)

    self.text:SetMultiline(value)

end