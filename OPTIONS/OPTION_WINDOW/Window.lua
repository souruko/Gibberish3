--===================================================================================
--             Name:    OPTIONS WINDOW
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
Options.Constructor.OptionsWindow = class(Turbine.UI.Lotro.Window)





-------------------------------------------------------------------------------------
--      Description:    options window constructor
-------------------------------------------------------------------------------------
function Options.Constructor.OptionsWindow:Constructor(  )
	Turbine.UI.Lotro.Window.Constructor( self )

    self.width = 1300
    self.height = 700

    local max_min_width = 1300
    local min_height = 700

    --self constuct
    self:SetText(           "Gibberish" )
    self:SetSize(           self.width,     self.height )
    self:SetPosition(       Utils.ScreenRatioToPixel( Data.options.window.left, Data.options.window.top ) )
    self:SetMinimumSize(    max_min_width,  min_height )
    self:SetMaximumWidth(   max_min_width )
    self:SetResizable(      true )

    --children construction
    self.windowSelection  = Options.Constructor.WindowSelection ( self )

    self.windowOptions    = Options.Constructor.WindowOptions   ( self )

    self.windowCollection = Options.Constructor.WindowCollection( self )

    --startup
    self:SizeChanged()
    self:SelectionChanged()
    self:SetVisible(true)

end


-------------------------------------------------------------------------------------
--      Description:    size changed
-------------------------------------------------------------------------------------
function Options.Constructor.OptionsWindow:SizeChanged()

    local height = self:GetHeight()

    local height_child_max = height - 50    -- 35 top / 15 bottom

    self.windowSelection:SetHeight(height_child_max)
    self.windowOptions:SetHeight(height_child_max)
    self.windowCollection:SetHeight(height_child_max)

end


-------------------------------------------------------------------------------------
--      Description:    selection changed
-------------------------------------------------------------------------------------
function Options.Constructor.OptionsWindow:SelectionChanged()

end


-------------------------------------------------------------------------------------
--      Description:    finish
-------------------------------------------------------------------------------------
function Options.Constructor.OptionsWindow:Finish()

    self:SetVisible( false )

    self.windowSelection:   Finish()
    self.windowOptions:     Finish()
    self.generalOptions:    Finish()
    self.windowCollection:  Finish()

    self:Close()
    
end