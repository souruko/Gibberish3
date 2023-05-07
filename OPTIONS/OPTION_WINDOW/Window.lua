--===================================================================================
--             Name:    OPTIONS WINDOW
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
Options.Constructor.OptionsWindow = class(Turbine.UI.Lotro.Window)





-------------------------------------------------------------------------------------
--      Description:    options window constructor
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Options.Constructor.OptionsWindow:Constructor(  )
	Turbine.UI.Lotro.Window.Constructor( self )

    
    self.width            = 1080
    self.height           = 720

    local max_min_width   = 1080
    local min_height      = 720


    self:SetText(           "Gibberish" )
    self:SetSize(           self.width,     self.height )
    self:SetMinimumSize(    max_min_width,  min_height )
    self:SetMaximumWidth(   max_min_width )
    self:SetResizable(      true )

    self.windowSelection  = Options.Constructor.WindowSelection( self )
    self.windowOptions    = Options.Constructor.WindowOptions  ( self )
    self.generalOptions   = Options.Constructor.GeneralOptions ( self )
 
    self.clickBlock       = Options.Constructor.ClickBlock(      self )

    self:SizeChanged()

    self:SetVisible(true)

end



-------------------------------------------------------------------------------------
--      Description:    resize children after window size changed
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Options.Constructor.OptionsWindow:SizeChanged()

    self.width, self.height = self:GetSize()

    local spacing_sides         = 20
    local spacing_top           = 35
    local spacing_inner         = 10

    local max_height            = self.height   - spacing_top           - spacing_sides
    local windowSelection_width = 300
    local windowOptions_width   = 730
    local generalOptions_height = 100
    local windowOptions_height  = max_height    - spacing_inner         - generalOptions_height
    local windowOptions_left    = spacing_inner + spacing_sides         + windowSelection_width
    local generalOptions_top    = self.height   - generalOptions_height - spacing_sides

    
    self.windowSelection:SetPosition(   spacing_sides,          spacing_top )
    self.windowOptions:SetPosition(     windowOptions_left,     spacing_top )
    self.generalOptions:SetPosition(    windowOptions_left,     generalOptions_top )

    self.clickBlock:SetPosition(        spacing_sides,          spacing_top )

    self.windowSelection:SetSize(       windowSelection_width,  max_height )
    self.windowOptions:SetSize(         windowOptions_width,    windowOptions_height )
    self.generalOptions:SetSize(        windowOptions_width,    generalOptions_height )

    self.clickBlock:SetSize(            self.width,             max_height )


end



-------------------------------------------------------------------------------------
--      Description:    finish things up and close window
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Options.Constructor.OptionsWindow:Finish()

    self:SetVisible( false )

    self.windowSelection:   Finish()
    self.windowOptions:     Finish()
    self.generalOptions:    Finish()

    self:Close()

end


-------------------------------------------------------------------------------------
--      Description:    show click block for right click menu
-------------------------------------------------------------------------------------
--        Parameter:    child       - the child that is using it
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Options.Constructor.OptionsWindow:ClickBlockShow( child )

    self.clickBlock:Show( child )

end


-------------------------------------------------------------------------------------
--      Description:    hide click block again
-------------------------------------------------------------------------------------
--        Parameter:     
-------------------------------------------------------------------------------------
--           Return:     
-------------------------------------------------------------------------------------
function Options.Constructor.OptionsWindow:ClickBlockHide()

    self.clickBlock:Hide()

end
