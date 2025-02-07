--=================================================================================================
--= Bar Element
--= ===============================================================================================
--= 
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- create class
TextElement = class( Turbine.UI.Window )

-- function table for window constructors
Timer[ Timer.Types.TEXT ].Constructor = function ( parent, data, index, startTime, duration, icon, text, entity, key, activ )

    return TextElement( parent, data, index, startTime, duration, icon, text, entity, key, activ )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Bar Constructor
---------------------------------------------------------------------------------------------------
function TextElement:Constructor( parent, data, index, startTime, duration, icon, text, entity, key, activ )
	Turbine.UI.Window.Constructor( self )

    -- parent window control
    self.parent = parent
    -- timer data index
    self.index = index
    -- timer data
    self.data  = data
    -- key
    self.key = key
    self.icon = icon

    -- for threshold timer event
    self.firstThreshold = true

    -- build elements
    self:SetMouseVisible( false )

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
    if Trigger.TimerEvent ~= nil then
        Trigger.TimerEvent( self.data.id, Trigger.Types.TimerStart )
    end

    self:SetVisibility( true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] load timer settings
---------------------------------------------------------------------------------------------------
function TextElement:DataChanged()

    -- declarations
    local parentData = self.parent.data

    self:Resize()

    -- font colors
    self.timerLabel:SetForeColor( UTILS.ColorFix( parentData.color4 ) )
    self.textLabel:SetForeColor( UTILS.ColorFix( parentData.color5 ) )

    -- text alignment
    self.textLabel:SetTextAlignment( parentData.textAlignment )
    self.timerLabel:SetTextAlignment( parentData.timerAlignment )
    
    -- fonts
    self.font = Font[ parentData.font ][ parentData.fontSize ]
    if parentData.thresholdFont ~= nil then
        self.thresholdFont = Font[ parentData.thresholdFont ][ parentData.thresholdFontSize ]
    else
        self.thresholdFont = self.font
    end
    self.textLabel:SetFont( self.font )
    self.timerLabel:SetFont( self.font )

    -- show timer
    self.timerLabel:SetVisible( parentData.showTimer )

    -- remember base color
    self.timerColor = UTILS.ColorFix( parentData.color4 )
    self.textColor = UTILS.ColorFix( parentData.color5 )
    self.thresholdColor = UTILS.ColorFix( parentData.color7 )
    self.thresholdTimerColor = UTILS.ColorFix( parentData.color8 )
    self.thresholdTextColor = UTILS.ColorFix( parentData.color9 )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] update timer values
---------------------------------------------------------------------------------------------------
function TextElement:UpdateContent( startTime, duration, icon, text, entity, key, activ )

    -- protrect timer from updates
    if self.data.protect == true and (self:GetWantsUpdates() == true) then
        return
    end
    
    -- reset key
    self.key = key

    -- reset time
    self.startTime = startTime
    self.duration = duration
    self.endTime = startTime + duration
    self.icon = icon

    -- reset icon
    if self.data.showIcon == true then

        self.iconControl:SetSize( UTILS.GetImageSize( icon ) )
        self.iconControl:SetStretchMode( 1 )
        self.iconControl:SetBackground( icon )
        self.iconControl:SetSize( self.parent.data.height, self.parent.data.height )
        self.iconControl:SetVisible(true)

    else

        self.iconControl:SetBackground( UTILS.IconID.Blank )
        self.iconControl:SetSize( self.parent.data.height, self.parent.data.height )
        self.iconControl:SetVisible(false)

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
function TextElement:Finish()

    -- stop updates and set visibility to false
    self:SetWantsUpdates( false )
    self:SetVisibility( false )

    self.parent:ChildFinished( self )

    -- close all windows
    self.labelBack:Close()
    self:Close()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- update element ( called every frame )
---------------------------------------------------------------------------------------------------
function TextElement:Update()
    
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

        self:UpdateTime( timeLeft )
        self:UpdateThreshold( timeLeft )

    -- permanent timers without running time
    else

        self.timerLabel:SetText( "" )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- update bar
---------------------------------------------------------------------------------------------------
function TextElement:UpdateBar( timeLeft )

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
function TextElement:UpdateTime( timeLeft )

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
function TextElement:UpdateThreshold( timeLeft )

    -- return if not using threshold
    if self.data.useThreshold == false then
        return
    end

    -- not in the threshold
    if timeLeft > self.data.thresholdValue then

        -- use backColor
        self.timerLabel:SetForeColor( self.timerColor )
        self.textLabel:SetForeColor( self.textColor )
        self.timerLabel:SetFont( self.font )
        self.textLabel:SetFont( self.font )
        self:SetOpacity( self.parent.data.opacityActiv )

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

            self.textLabel:SetForeColor( Turbine.UI.Color( 1, value, value ) )

        end

        self.timerLabel:SetForeColor( self.timerColor )
        self.textLabel:SetForeColor( self.textColor )
        self.timerLabel:SetFont( self.font )
        self.textLabel:SetFont( self.font )
        self:SetOpacity( self.parent.data.opacityActiv )
        
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- timer is done
---------------------------------------------------------------------------------------------------
function TextElement:Ended()

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
function TextElement:Activ( value )

    -- change opacity and text/timer visiblilty depending on activ
    if value == true then

        self.textLabel:SetVisible( true )
        self.timerLabel:SetVisible( self.parent.data.showTimer )

    else

        self:SetOpacity( self.parent.data.opacityPassiv )

        self.textLabel:SetVisible( false )
        self.timerLabel:SetVisible( false )

        if self.data.useThreshold == true then

            self.timerLabel:SetForeColor( self.timerColor )
            self.textLabel:SetForeColor( self.textColor )
            self.timerLabel:SetFont( self.font )
            self.textLabel:SetFont( self.font )
            self:SetOpacity( self.parent.data.opacityActiv )

        end

    end

    -- start or stop updates
    self:SetWantsUpdates( value )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check if timer should loop / set loop up and return loop
---------------------------------------------------------------------------------------------------
function TextElement:Loop()

    -- reset timer with current time as start time
    local startTime = Turbine.Engine.GetGameTime()

    self:UpdateContent( startTime, self.duration, self.icon, self.textLabel:GetText(), nil, self.key, true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- reset timer
---------------------------------------------------------------------------------------------------
function TextElement:Reset()

    -- if reset attribute is set call the timer end
    if self.data.reset == true then
        
        self:Ended()

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- update visibility
---------------------------------------------------------------------------------------------------
function TextElement:SetVisibility( value )

    -- change visiblility for all windows
    self:SetVisible( value )
    self.labelBack:SetVisible( value )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- reset size
---------------------------------------------------------------------------------------------------
function TextElement:Resize()

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
        selfWidth       = maxWidth
        selfHeight      = maxHeight + self.parent.data.spacing

        -- subtract labelSpacing so the text/timer dont sit on the edges
        labelWidth      = width - 2 * Options.Defaults.timer.labelSpacing
        labelHeight     = height

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

        maxWidth        = width + ( 2 * frame )
        maxHeight       = height + ( 2 * frame) + width

        selfWidth       = maxHeight + self.parent.data.spacing
        selfHeight      = maxWidth

        labelWidth      = width 
        labelHeight     = height - 2 * Options.Defaults.timer.labelSpacing

        barBackLeft     = frame
        barBackTop      = frame + width

        labelBackLeft   = frame
        labelBackTop    = barBackLeft + Options.Defaults.timer.labelSpacing

    end

    self:SetSize( selfWidth, selfHeight )

    self.labelBack:SetSize( labelWidth, labelHeight )
    self.textLabel:SetSize( labelWidth, labelHeight )
    self.timerLabel:SetSize( labelWidth, labelHeight )

    self.iconControl:SetSize( height, height )


    self.labelBack:SetPosition( labelBackLeft, labelBackTop )
    self.iconControl:SetPosition( frame, frame )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- get running information
---------------------------------------------------------------------------------------------------
function TextElement:GetRunningInformation()

    -- permanent inactiv timer
    if self:GetWantsUpdates() == false then
        return nil
    end

    local running_timer_data = {}

    running_timer_data.index = self.index
    running_timer_data.key = self.key
    running_timer_data.startTime = self.startTime
    running_timer_data.duration = self.duration
    running_timer_data.icon = self.icon
    running_timer_data.text = self.textLabel:GetText()

    return running_timer_data

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- get running information
---------------------------------------------------------------------------------------------------
Timer[ Timer.Types.TEXT ].GetItemSize = function ( parent_data )

    local width = parent_data.width + ( 2 * parent_data.frame ) + parent_data.height
    local height = parent_data.height + ( 2 * parent_data.frame)
    
    return width, height

end
---------------------------------------------------------------------------------------------------
