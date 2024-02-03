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

    -- for threshold timer event
    self.firstThreshold = true

    -- build elements
    self.entityControl = Turbine.UI.Lotro.EntityControl()
    self.entityControl:SetParent( self )
    self.entityControl:SetZOrder( 1 )

    self.frame = Turbine.UI.Control()
    self.frame:SetParent( self )
    self.frame:SetMouseVisible( false )
    self.frame:SetZOrder( 2 )

    self.barBack = Turbine.UI.Control()
    self.barBack:SetParent( self )
    self.barBack:SetMouseVisible( false )
    self.barBack:SetZOrder( 3 )

    self.bar = Turbine.UI.Window()
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

    self:SetVisibility( true )

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

    -- set barWidth
    self.barWidth  = parentData.width
    self.backColor = UTILS.ColorFix( parentData.color2 )

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
    if self.data.showIcon == true then

        self.iconControl:SetSize( UTILS.GetImageSize( icon ) )
        self.iconControl:SetStretchMode( 1 )
        self.iconControl:SetBackground( icon )
        self.iconControl:SetSize( self.parent.data.height, self.parent.data.height )

    else

        self.iconControl:SetBackground( UTILS.IconID.Blank )
        self.iconControl:SetSize( self.parent.data.height, self.parent.data.height )

    end
    
    -- reset text/timer
    if text ~= nil then
        self.textLabel:SetText( text )
        self.timerLabel:SetText( "" )
    end

    -- check if firstThreshold has to be reset
    if self.data.useThreshold and
    self.firstThreshold == false then

        local timeLeft = self.endTime - Turbine.Engine.GetGameTime()

        if timeLeft > self.data.thresholdValue then

            self.firstThreshold = true

        end

    end

    self:Activ( activ )
    
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] close timer
---------------------------------------------------------------------------------------------------
function BarElement:Finish()

    -- stop updates and set visibility to false
    self:SetWantsUpdates( false )
    self:SetVisibility( false )

    self.parent:ChildFinished( self )

    -- close all windows
    self.labelBack:Close()
    self.bar:Close()
    self:Close()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- update element ( called every frame )
---------------------------------------------------------------------------------------------------
function BarElement:Update()
    
    -- calculate the timeLeft until timer ends
    local timeLeft = self.endTime - Turbine.Engine.GetGameTime()

    -- timer ended
    if timeLeft <= 0 then
        
        -- if loop attribute is set reset timer
        if self.data.loop == true then
            
            self:Loop()
        
        -- natural end
        else

            self:Ended()

        end

    -- running timer
    elseif timeLeft < 99999 then

        self:UpdateBar( timeLeft )
        self:UpdateTime( timeLeft )
        self:UpdateThreshold( timeLeft )

    -- permanent timers without running time
    else

        self.timerLabel:SetText( "" )
        self.bar:SetWidth( 0 )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- update bar
---------------------------------------------------------------------------------------------------
function BarElement:UpdateBar( timeLeft )

    -- update bar size depending on direction and orientation
    -- descending horizontal
    if self.data.direction == Direction.Descending and
    self.parent.data.orientation == Orientation.Vertical then

        self.bar:SetWidth( timeLeft / self.duration * self.barWidth )

    -- descending vertical
    elseif self.data.direction == Direction.Descending and
    self.parent.data.orientation == Orientation.Horizontal then

        self.bar:SetHeight( timeLeft / self.duration * self.barWidth )

    -- ascending horizontal
    elseif self.data.direction == Direction.Ascending and
    self.parent.data.orientation == Orientation.Vertical then

        local timePast = self.duration - timeLeft
        self.bar:SetWidth( timePast / self.duration * self.barWidth )

    -- ascending vertical
    else

        local timePast = self.duration - timeLeft
        self.bar:SetWidth( timePast / self.duration * self.barWidth )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- update timer
---------------------------------------------------------------------------------------------------
function BarElement:UpdateTime( timeLeft )

    -- update time depending on the direction
    if self.data.direction == Direction.Ascending then

        local timePast = self.duration - timeLeft
        self.timerLabel:SetText( UTILS.TimerFormat( timePast, self.parent.data.durationFormat ) )

    else
        
        self.timerLabel:SetText( UTILS.TimerFormat( timeLeft, self.parent.data.durationFormat ) )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- update threshold
---------------------------------------------------------------------------------------------------
function BarElement:UpdateThreshold( timeLeft )

    -- return if not using threshold
    if self.data.useThreshold == false then
        return
    end

    -- not in the threshold
    if timeLeft > self.data.thresholdValue then

        -- use backColor
        self.barBack:SetBackColor( self.backColor )

    -- in the threshold
    else

        -- threshold timer event
        if self.firstThreshold == true then

            self.firstThreshold = false
            Trigger.TimerEvent( self.data.id, Trigger.Types.TimerThreshold )

        end

        -- flashing
        if self.data.useAnimation == true and
        self.data.animationType == AnimationType.Flashing then

            local value
            local flashValue = timeLeft * self.data.animationSpeed
            
            if math.floor( flashValue ) % 2 == 0 then
            
                value = 1 - ( flashValue - math.floor( flashValue ) )

            else

                value = ( flashValue - math.floor( flashValue ) )

            end

            self.barBack:SetBackColor( Turbine.UI.Color( 1, value, value ) )

        -- no animation only red background
        else
            
            self.barBack:SetBackColor( Turbine.UI.Color.Red )

        end
        
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- timer is done
---------------------------------------------------------------------------------------------------
function BarElement:Ended()

    -- timer ended trigger event
    Trigger.TimerEvent( self.data.id, Trigger.Types.TimerEnd )

    if self.data.permanent == true then
        
        self:Activ( false )

    else

        self:Finish()

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- starts / stops updates for the timer
---------------------------------------------------------------------------------------------------
function BarElement:Activ( value )

    -- change opacity and text/timer visiblilty depending on activ
    if value == true then

        self:SetOpacity( self.parent.data.opacityActiv )
        self.barBack:SetOpacity( self.parent.data.opacityActiv )

        self.textLabel:SetVisible( true )
        self.timerLabel:SetVisible( self.parent.data.showTimer )

    else

        self:SetOpacity( self.parent.data.opacityPassiv )
        self.barBack:SetOpacity( self.parent.data.opacityPassiv )

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

    -- reset timer with current time as start time
    local startTime = Turbine.Engine.GetGameTime()

    self:UpdateContent( startTime, self.duration, nil, nil, nil, self.key )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- reset timer
---------------------------------------------------------------------------------------------------
function BarElement:Reset()

    -- if reset attribute is set call the timer end
    if self.data.reset == true then
        
        self:Ended()

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- update visibility
---------------------------------------------------------------------------------------------------
function BarElement:SetVisibility( value )

    -- change visiblility for all windows
    self:SetVisible( value )
    self.bar:SetVisible( value )
    self.labelBack:SetVisible( value )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- reset size
---------------------------------------------------------------------------------------------------
function BarElement:Resize()

    -- declarations
    local frame = self.parent.data.frame
    local iconSize, width, height, maxHeight, maxWidth, selfWidth, selfHeight, labelWidth, labelHeight, barBackLeft, labelBackLeft, barBackTop, labelBackTop

    -- set iconsize depeding if icon is shown
    if self.data.showIcon == true then

        iconSize = self.parent.data.height
    
    else

        iconSize = 0

    end

    -- set values depending on orientation
    if self.parent.data.orientation == Orientation.Vertical then

        -- bar width / height
        width           = self.parent.data.width
        height          = self.parent.data.height

        -- timer max sizze
        maxWidth        = width + ( 2 * frame ) + iconSize
        maxHeight       = height + ( 2 * frame)

        -- max size + spacing between timers
        selfWidth       = maxWidth
        selfHeight      = maxHeight + self.parent.data.spacing

        -- subtract labelSpacing so the text/timer dont sit on the edges
        labelWidth      = width - 2 * Options.Defaults.timer.labelSpacing
        labelHeight     = height

        -- bar staring position
        barBackLeft     = frame + iconSize
        barBackTop      = frame

        -- label starting position
        labelBackLeft   = barBackLeft + Options.Defaults.timer.labelSpacing
        labelBackTop    = frame

    else

        -- everything reversed
        width           = self.parent.data.height
        height          = self.parent.data.width

        maxWidth        = width + ( 2 * frame )
        maxHeight       = height + ( 2 * frame) + iconSize

        selfWidth       = maxHeight + self.parent.data.spacing
        selfHeight      = maxWidth

        labelWidth      = width 
        labelHeight     = height - 2 * Options.Defaults.timer.labelSpacing

        barBackLeft     = frame
        barBackTop      = frame + iconSize

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

    self.iconControl:SetSize( iconSize, iconSize )

    self.barBack:SetPosition( barBackLeft, barBackTop )
    self.labelBack:SetPosition( labelBackLeft, labelBackTop )
    self.iconControl:SetPosition( frame, frame )

end
---------------------------------------------------------------------------------------------------
