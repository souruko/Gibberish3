--=================================================================================================
--= Bar Element
--= ===============================================================================================
--= 
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- create class
BarElement = class( Turbine.UI.Window )

-- function table for window constructors
Timer[ Timer.Types.BAR ].Constructor = function ( parent, data, index, startTime, duration, icon, text, entity, key, activ )

    return BarElement( parent, data, index, startTime, duration, icon, text, entity, key, activ )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Bar Constructor
---------------------------------------------------------------------------------------------------
function BarElement:Constructor( parent, data, index, startTime, duration, icon, text, entity, key, activ )
	Turbine.UI.Window.Constructor( self )

    -- parent window control
    self.parent = parent
    -- timer data index
    self.index = index
    -- timer data
    self.data  = data
    -- key
    self.key = key


    -- build elements
    self.entityControl = Turbine.UI.Lotro.EntityControl()
    self.entityControl:SetParent( self )
    self.entityControl:SetZOrder( 1 )

    self.frame = Turbine.UI.Control()
    self.frame:SetParent( self )
    self.frame:SetMouseVisible( false )
    self.frame:SetZOrder( 2 )

    self.barBack = Turbine.UI.Window()
    self.barBack:SetParent( self )
    self.barBack:SetMouseVisible( false )
    self.barBack:SetZOrder( 3 )

    self.bar = Turbine.UI.Control()
    self.bar:SetParent( self.barBack )
    self.bar:SetMouseVisible( false )
    self.bar:SetZOrder( 4 )

    self.iconControl = Turbine.UI.Control()
    self.iconControl:SetParent( self )
    self.iconControl:SetMouseVisible( false )
    self.iconControl:SetZOrder( 5 )

    self.labelBack = Turbine.UI.Window()
    self.labelBack:SetParent( self )
    self.labelBack:SetMouseVisible( false )
    self.labelBack:SetZOrder( 6 )
    
    self.textLabel = Turbine.UI.Label()
    self.textLabel:SetParent( self.labelBack )
    self.textLabel:SetMouseVisible( false )
    self.textLabel:SetFontStyle( Options.Defaults.timer.fontStyle )
    self.textLabel:SetZOrder( 7 )
    
    self.timerLabel = Turbine.UI.Label()
    self.timerLabel:SetParent( self.labelBack )
    self.timerLabel:SetMouseVisible( false )
    self.timerLabel:SetFontStyle( Options.Defaults.timer.fontStyle )
    self.timerLabel:SetZOrder( 8 )
    
    -- load settings
    self:DataChanged()


    -- start up
    self:UpdateContent( startTime, duration, icon, text, entity, key, activ )

    -- timer started trigger event
    Trigger.TimerEvent( self.data.id, Trigger.Types.TimerStart )

    self:Visibility( true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] load timer settings
---------------------------------------------------------------------------------------------------
function BarElement:DataChanged()

    -- declarations
    local parentData = self.parent.data

    self:Resize()

    -- colors
    self.frame:SetBackColor( UTILS.ColorFix( parentData.color1 ) )
    self.barBack:SetBackColor( UTILS.ColorFix( parentData.color2 ) )
    self.bar:SetBackColor( UTILS.ColorFix( parentData.color3 ) )
    
    -- font colors
    self.timerLabel:SetForeColor( UTILS.ColorFix( parentData.color4 ) )
    self.textLabel:SetForeColor( UTILS.ColorFix( parentData.color5 ) )

    -- text alignment
    self.textLabel:SetTextAlignment( parentData.textAlignment )
    self.timerLabel:SetTextAlignment( parentData.timerAlignment )
    
    -- fonts
    self.textLabel:SetFont( Font[ parentData.font ][ parentData. fontSize ] )
    self.timerLabel:SetFont( Font[ parentData.font ][ parentData. fontSize ] )

    -- show timer
    self.timerLabel:SetVisible( parentData.showTimer )

    -- entity
    self:SetMouseVisible( parentData.useTargetEntity )
    self.entityControl:SetMouseVisible( parentData.useTargetEntity )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] update timer values
---------------------------------------------------------------------------------------------------
function BarElement:UpdateContent( startTime, duration, icon, text, entity, key, activ )

    -- reset key
    self.key = key

    -- reset time
    self.startTime = startTime
    self.duration = duration
    self.endTime = startTime + duration

    -- reset target entity
    self.entityControl:SetEntity( entity )

    -- reset icon
    self.iconControl:SetSize( UTILS.GetImageSize( icon ) )
    self.iconControl:SetStretchMode( 1 )
    self.iconControl:SetBackground( icon )
    self.iconControl:SetSize( self.parent.data.height, self.parent.data.height )

     -- reset text/timer
    self.textLabel:SetText( text )
    self.timerLabel:SetText( "" )

    self:Activ( activ )
    
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] close timer
---------------------------------------------------------------------------------------------------
function BarElement:Finish()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- update element ( called every frame )
---------------------------------------------------------------------------------------------------
function BarElement:Update()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- timer is done
---------------------------------------------------------------------------------------------------
function BarElement:Ended()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- starts / stops updates for the timer
---------------------------------------------------------------------------------------------------
function BarElement:Activ( value )

    -- change opacity and text/timer visiblilty depending on activ
    if value == true then

        self:SetOpacity( self.parent.opacityActiv )
        self.barBack:SetOpacity( self.parent.opacityActiv )

        self.textLabel:SetVisible( true )
        self.timerLabel:SetVisible( self.parent.showTimer )

    else

        self:SetOpacity( self.parent.opacityPassiv )
        self.barBack:SetOpacity( self.parent.opacityPassiv )

        self.textLabel:SetVisible( false )
        self.timerLabel:SetVisible( false )

    end

    -- start or stop updates
    self:SetWantsUpdates( value )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check if timer should loop / set loop up and return loop
---------------------------------------------------------------------------------------------------
function BarElement:Loop()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- reset timer
---------------------------------------------------------------------------------------------------
function BarElement:Reset()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- update visibility
---------------------------------------------------------------------------------------------------
function BarElement:SetVisibility( value )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- reset size
---------------------------------------------------------------------------------------------------
function BarElement:Resize()

    -- declarations
    local frame = self.parent.data.frame
    local width, height, maxHeight, maxWidth, selfWidth, selfHeight, labelWidth, labelHeight, barBackLeft, labelBackLeft, barBackTop, labelBackTop

    -- set values depending on orientation
    if self.parent.data.orientation == Orientation.Vertical then

        -- bar width / height
        width           = self.parent.data.width
        height          = self.parent.data.height

        -- timer max sizze
        maxWidth        = width + ( 2 * frame ) + height
        maxHeight       = height + ( 2 * frame)

        -- max size + spacing between timers
        selfWidth      = maxWidth
        selfHeight      = maxHeight + self.parent.data.spacing

        -- subtract labelSpacing so the text/timer dont sit on the edges
        labelWidth = width - 2 * Options.Defaults.timer.labelSpacing
        labelHeight = height

        -- bar staring position
        barBackLeft     = frame + height
        barBackTop      = frame

        -- label starting position
        labelBackLeft   = barBackLeft + Options.Defaults.timer.labelSpacing
        labelBackTop    = frame

    else

        -- everything reversed
        width           = self.parent.data.height
        height          = self.parent.data.width

        maxWidth        = height + ( 2 * frame )
        maxHeight       = width + ( 2 * frame) + height

        selfWidth      = maxHeight + self.parent.data.spacing
        selfHeight      = maxWidth

        barBackLeft     = frame
        barBackTop      = frame + height

        labelBackLeft   = frame
        labelBackTop    = barBackLeft + Options.Defaults.timer.labelSpacing

    end

    self:SetSize( selfWidth, selfHeight )

    self.frame:SetSize( maxWidth, maxHeight )
    self.entityControl:SetSize( maxWidth, maxHeight )

    self.barBack:SetSize( width, height)
    self.bar:SetSize( width, height)

    self.labelBack:SetSize( labelWidth, labelHeight )
    self.textLabel:SetSize( labelWidth, labelHeight )
    self.timerLabel:SetSize( labelWidth, labelHeight )

    self.iconControl:SetSize( height, height )

    self.barBack:SetPosition( barBackLeft, barBackTop )
    self.labelBack:SetPosition( labelBackLeft, labelBackTop )
    self.iconControl:SetPosition( frame, frame )

end
---------------------------------------------------------------------------------------------------
