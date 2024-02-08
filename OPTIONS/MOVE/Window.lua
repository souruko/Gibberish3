--=================================================================================================
--= Move window
--= ===============================================================================================
--= 
--=================================================================================================



Options.Move = {}
Options.Move.Constructor = class(Turbine.UI.Window)
---------------------------------------------------------------------------------------------------
function Options.Move.Constructor:Constructor()
	Turbine.UI.Window.Constructor( self )

    self:SetSize( Options.Defaults.move.width,  Options.Defaults.move.height )
    self:SetPosition( 0, ( ( Options.ScreenHeight - Options.Defaults.move.height ) / 2 ) )
    self:SetBackColor( Options.Defaults.move.backcolor )
    self:SetZOrder(1)

    -- shows the name of the selected window
    self.header = Turbine.UI.Label()
    self.header:SetParent( self )
    self.header:SetPosition( 1, 1 )
    self.header:SetSize( Options.Defaults.move.width - 2,  30 )
    self.header:SetBackColor( Options.Defaults.move.headercolor )
    self.header:SetFont( Options.Defaults.move.headerfont )
    self.header:SetFontStyle( Options.Defaults.move.headerstyle )
    self.header:SetTextAlignment( Options.Defaults.move.TextAlignment )

    -- left value of the selected window
    self.left_label = Turbine.UI.Label()
    self.left_label:SetParent( self )
    self.left_label:SetPosition( 0, 50 )
    self.left_label:SetSize( 35,  25 )
    self.left_label:SetFont( Options.Defaults.move.Font )
    self.left_label:SetTextAlignment( Options.Defaults.move.labelalignment )

    self.left_textbox = Turbine.UI.Lotro.TextBox()
    self.left_textbox:SetParent( self )
    self.left_textbox:SetPosition( 45, 52 )
    self.left_textbox:SetSize( 95,  20 )
    self.left_textbox:SetFont( Options.Defaults.move.Font )
    self.left_textbox:SetTextAlignment( Options.Defaults.move.TextAlignment )

    -- top value of the selected window
    self.top_label = Turbine.UI.Label()   
    self.top_label:SetParent( self )
    self.top_label:SetPosition( 0, 75 )
    self.top_label:SetSize( 35,  25 )
    self.top_label:SetFont( Options.Defaults.move.Font )
    self.top_label:SetTextAlignment( Options.Defaults.move.labelalignment )

    self.top_textbox = Turbine.UI.Lotro.TextBox()
    self.top_textbox:SetParent( self )
    self.top_textbox:SetPosition( 45, 77 )
    self.top_textbox:SetSize( 95,  20 )
    self.top_textbox:SetFont( Options.Defaults.move.Font )
    self.top_textbox:SetTextAlignment( Options.Defaults.move.TextAlignment )

    -- update changes
    self.update_button = Turbine.UI.Lotro.Button()
    self.update_button:SetParent( self )
    self.update_button:SetPosition( 42, 102 )
    self.update_button:SetSize( 100,  22 )
    self.update_button:SetFont( Options.Defaults.move.Font )
    self.update_button:SetTextAlignment( Options.Defaults.move.TextAlignment )
    self.update_button.Click = function ()
        self:UpdateClicked()
    end

    -- move selected window 1 pixel per buttonpress
    self.up_back = Turbine.UI.Control()
    self.up_back:SetParent( self )
    self.up_back:SetPosition( 60, 150 )
    self.up_back:SetSize( 30,  20 )
    self.up_back:SetBackColor( Options.Defaults.move.headercolor )

    self.up_button = Turbine.UI.Button()
    self.up_button:SetParent( self.up_back )
    self.up_button:SetPosition( 3, -2 )
    self.up_button:SetSize(20, 20 )
    self.up_button:SetBlendMode( Turbine.UI.BlendMode.Overlay )
    self.up_button:SetBackground( "Gibberish3/RESOURCES/arrow_up.tga" )
    self.up_button.Click = function ()
        self:ArrowClicked( 0, -1 )
    end
    self.up_button.MouseDown = function ()
        self:ArrowDown( 0, -1 )
    end
    self.up_button.MouseUp = function ()
        self:SetWantsUpdates( false )
    end

    
    self.left_back = Turbine.UI.Control()
    self.left_back:SetParent( self )
    self.left_back:SetPosition(  30, 175 )
    self.left_back:SetSize( 30,  20 )
    self.left_back:SetBackColor( Options.Defaults.move.headercolor )

    self.left_button = Turbine.UI.Button()
    self.left_button:SetParent( self.left_back )
    self.left_button:SetPosition( 2, -2 )
    self.left_button:SetSize(20, 20 )
    self.left_button:SetBlendMode( Turbine.UI.BlendMode.Overlay )
    self.left_button:SetBackground( "Gibberish3/RESOURCES/arrow_left.tga" )
    self.left_button.Click = function ()
        self:ArrowClicked( -1, 0 )
    end
    self.left_button.MouseDown = function ()
        self:ArrowDown( -1, 0 )
    end
    self.left_button.MouseUp = function ()
        self:SetWantsUpdates( false )
    end

    self.right_back = Turbine.UI.Control()
    self.right_back:SetParent( self )
    self.right_back:SetPosition( 90, 175 )
    self.right_back:SetSize( 30,  20 )
    self.right_back:SetBackColor( Options.Defaults.move.headercolor )

    self.right_button = Turbine.UI.Button()
    self.right_button:SetParent( self.right_back )
    self.right_button:SetPosition( 5, -2 )
    self.right_button:SetSize(20, 20 )
    self.right_button:SetBlendMode( Turbine.UI.BlendMode.Overlay )
    self.right_button:SetBackground( "Gibberish3/RESOURCES/arrow_right.tga" )
    self.right_button.Click = function ()
        self:ArrowClicked( 1, 0 )
    end
    self.right_button.MouseDown = function ()
        self:ArrowDown( 1, 0 )
    end
    self.right_button.MouseUp = function ()
        self:SetWantsUpdates( false )
    end
    
    self.down_back = Turbine.UI.Control()
    self.down_back:SetParent( self )
    self.down_back:SetPosition( 60, 200 )
    self.down_back:SetSize( 30,  20 )
    self.down_back:SetBackColor( Options.Defaults.move.headercolor )

    self.down_button = Turbine.UI.Button()
    self.down_button:SetParent( self.down_back )
    self.down_button:SetPosition( 3, -2 )
    self.down_button:SetSize( 20,  20 )
    self.down_button:SetBlendMode( Turbine.UI.BlendMode.Overlay )
    self.down_button:SetBackground( "Gibberish3/RESOURCES/arrow_down.tga" )
    self.down_button.Click = function ()
        self:ArrowClicked( 0, 1 )
    end
    self.down_button.MouseDown = function ()
        self:ArrowDown( 0, 1 )
    end
    self.down_button.MouseUp = function ()
        self:SetWantsUpdates( false )
    end
    

    -- end movemode
    self.close_button = Turbine.UI.Lotro.Button()
    self.close_button:SetParent( self )
    self.close_button:SetPosition( 42, 242 )
    self.close_button:SetSize( 100,  22 )
    self.close_button:SetFont( Options.Defaults.move.Font )
    self.close_button:SetTextAlignment( Options.Defaults.move.TextAlignment )
    self.close_button.Click = function ()
        Options.MoveChanged( false )
    end

    self.x_line = Turbine.UI.Window()
    self.x_line:SetSize( Options.ScreenWidth, 4 )
    self.x_line:SetBackColor( Turbine.UI.Color.White )
    self.x_line:SetPosition( 0, (Options.ScreenHeight/2) - 2)
    self.x_line:SetVisible(true)
    self.x_line:SetMouseVisible(false)

    self.x_fill = Turbine.UI.Control()
    self.x_fill:SetParent(self.x_line)
    self.x_fill:SetSize( Options.ScreenWidth, 2 )
    self.x_fill:SetBackColor( Turbine.UI.Color.Black )
    self.x_fill:SetPosition( 0, 1)
    self.x_fill:SetMouseVisible(false)

    self.y_line = Turbine.UI.Window()
    self.y_line:SetSize( 4,Options.ScreenHeight )
    self.y_line:SetBackColor( Turbine.UI.Color.White )
    self.y_line:SetPosition( (Options.ScreenWidth/2) - 2, 0)
    self.y_line:SetVisible(true)
    self.y_line:SetMouseVisible(false)

    self.y_fill = Turbine.UI.Control()
    self.y_fill:SetParent(self.y_line)
    self.y_fill:SetSize( 2 , Options.ScreenHeight )
    self.y_fill:SetBackColor( Turbine.UI.Color.Black )
    self.y_fill:SetPosition( 1, 0 )
    self.y_fill:SetMouseVisible(false)

    self:LanguageChanged()
    self:SelectionChanged()
    self:SetVisible( true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Move.Constructor:SelectionChanged()

    if Data.selectedIndex > 0 then

        local selected  = Data.window[ Data.selectedIndex ]
        local left, top = UTILS.ScreenRatioToPixel( selected.left, selected.top)

        self.header:SetText( selected.name )
        self.left_textbox:SetText( tostring(left) )
        self.top_textbox:SetText( tostring(top) )

    else
        self.header:SetText( "" )
        self.left_textbox:SetText( "" )
        self.top_textbox:SetText( "" )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Move.Constructor:UpdateClicked()

    -- convert text to number
    local left = tonumber( self.left_textbox:GetText() )
    local top  = tonumber( self.top_textbox:GetText() )

    -- check 
    if left == nil or top == nil then
        return
    end

    self:UpdateChanges( left, top )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Move.Constructor:ArrowClicked( left_value, top_value )

    if Data.selectedIndex ~= 0 then

        -- selected data
        local selected  = Data.window[ Data.selectedIndex ]
        local left, top = UTILS.ScreenRatioToPixel( selected.left, selected.top)

        left = left + left_value
        top  = top + top_value

        self:UpdateChanges( left, top )
        self:SelectionChanged()

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Move.Constructor:ArrowDown( left_value, top_value )

    self.left_value = left_value
    self.top_value  = top_value
    self.next      = Turbine.Engine.GetGameTime() + 0.5

    self:SetWantsUpdates( true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Move.Constructor:Update()

    local time = Turbine.Engine.GetGameTime()

    if Data.selectedIndex ~= 0 and time > self.next  then

        self:ArrowClicked( self.left_value, self.top_value )
        
        self.next = time + 0.01

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Move.Constructor:UpdateChanges( left, top )

    if Data.selectedIndex ~= 0 then

        -- selected data
        local selected  = Data.window[ Data.selectedIndex ]

        -- fix 
        if left < 0 then
            left = 0
        end
        if top < 0 then
            top = 0
        end
        if left > Options.ScreenWidth - 20 then
           left =  Options.ScreenWidth - 20
        end
        if top > Options.ScreenHeight - 20 then
            top = Options.ScreenHeight - 20
        end

        -- update data
        selected.left,  selected.top = UTILS.PixelToScreenRatio( left, top )

        -- update window
        Windows.DataChanged( Data.selectedIndex )

    end

end
---------------------------------------------------------------------------------------------------
    
---------------------------------------------------------------------------------------------------
function Options.Move.Constructor:LanguageChanged()

    self.left_label:SetText( UTILS.GetText( "move", "left"))
    self.top_label:SetText( UTILS.GetText( "move", "top"))
    self.update_button:SetText( UTILS.GetText( "move", "update"))
    self.close_button:SetText( UTILS.GetText( "move", "close"))

end
---------------------------------------------------------------------------------------------------
    
---------------------------------------------------------------------------------------------------
function Options.Move.Constructor:Closing()

    self.x_line:Close()
    self.y_line:Close()

end
---------------------------------------------------------------------------------------------------
