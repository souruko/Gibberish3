--=================================================================================================
--= Bar Element
--= ===============================================================================================
--= 
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- create class
CounterBarElement = class( Turbine.UI.Window )

-- function table for window constructors
Timer[ Timer.Types.COUNTER_BAR ].Constructor = function ( parent, data, index )

    return CounterBarElement( parent, data, index )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Bar Constructor
---------------------------------------------------------------------------------------------------
function CounterBarElement:Constructor( parent, data, index )
	Turbine.UI.Window.Constructor( self )

    -- parent window control
    self.parent = parent
    -- timer data index
    self.index = index
    -- timer data
    self.data  = data
    -- key
    self.key = self.data.key

    -- for threshold timer event
    self.firstThreshold = true
    self._inThreshold = nil

    -- counter values
    self.counterEND = 0
    self.counterSPAN = 0
    self.counterCURRENT = data.counterSTART

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
    UTILS.AttachImageEdges( self.iconControl )

    self.labelBack = Turbine.UI.Window()
    self.labelBack:SetParent( self )
    self.labelBack:SetMouseVisible( false )
    self.labelBack:SetZOrder( 6 )
    
    self.textLabel = Turbine.UI.Label()
    self.textLabel:SetParent( self.labelBack )
    self.textLabel:SetMouseVisible( false )
    self.textLabel:SetFontStyle( Options.Defaults.timer.fontStyle )
    self.textLabel:SetMarkupEnabled(true)
    self.textLabel:SetZOrder( 7 )
    
    self.timerLabel = Turbine.UI.Label()
    self.timerLabel:SetParent( self.labelBack )
    self.timerLabel:SetMouseVisible( false )
    self.timerLabel:SetFontStyle( Options.Defaults.timer.fontStyle )
    self.timerLabel:SetZOrder( 8 )
    
    -- load settings
    self:DataChanged()

    -- start up
    self:UpdateContent( 0, data.icon, data.textValue, nil, nil, true )

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
function CounterBarElement:DataChanged()

    -- declarations
    local parentData = self.parent.data

    self:Resize()

    -- colors
    -- the frame carries the bar, so a window with the frame switched off leaves the
    -- control in place and only stops painting it
    self.frame:SetBackColor( parentData.showFrame ~= false and UTILS.ColorFix( parentData.color1 ) or nil )
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
    self.counterEND   = self.data.counterEND
    self.counterSPAN  =  math.abs( self.data.counterEND - self.data.counterSTART )
    self.barWidth     = parentData.width
    self.backColor    = UTILS.ColorFix( parentData.color2 )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] update timer values
---------------------------------------------------------------------------------------------------
function CounterBarElement:UpdateContent( value, icon, text, entity, key, activ )

    -- reset key
    self.key = key
    self.icon = icon

    -- reset target entity
    self.entityControl:SetEntity( entity )

    -- reset icon
    if self.data.showIcon == true then

        local resolvedIcon = UTILS.ResolveTimerIcon( icon, self.data.useExternalImage )
        UTILS.SetStretchedImage( self.iconControl, resolvedIcon )
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
    end
    self.timerLabel:SetText( "" )

    -- check if firstThreshold has to be reset
    if self.data.useThreshold and
    self.firstThreshold == false then

        local counterLeft = self.counterCURRENT + value

        if counterLeft == self.data.thresholdValue then

            self.firstThreshold = true
            self._inThreshold = nil

        end

    end

    self:Activ( activ )
    
    self:UpdateElement( value )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] set timer values
---------------------------------------------------------------------------------------------------
function CounterBarElement:SetContent( value, icon, text, entity, key, activ )

    local setValue = value - self.counterCURRENT
    self:UpdateContent( setValue, icon, text, entity, key, activ )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] close timer
---------------------------------------------------------------------------------------------------
function CounterBarElement:Finish()

    -- stop updates and set visibility to false
    self:SetVisibility( false )

    self.parent:ChildFinished( self )

    -- release the entity reference
    self.entityControl:SetEntity( nil )

    -- close all windows
    self.labelBack:Close()
    self.barBack:Close()
    self:Close()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- update element ( called every frame )
---------------------------------------------------------------------------------------------------
function CounterBarElement:UpdateElement( value )
    
    -- current counter value
    self.counterCURRENT = self.counterCURRENT + value

    -- counter ended
    if self.counterCURRENT == self.counterEND then
        
        -- if loop attribute is set reset timer
        if self.data.loop == true then
            
            self:Loop()
        
        -- natural end
        else

            self:Ended()

        end

    -- running timer
    elseif self.counterCURRENT < 99999 then

        local counterLeft = self.counterCURRENT - self.counterEND

        self:UpdateBar( counterLeft )
        self:UpdateTime( self.counterCURRENT )
        self:UpdateThreshold( counterLeft )

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
function CounterBarElement:UpdateBar( counterLeft )

    -- update bar size depending on direction and orientation
    -- descending horizontal
    if self.data.direction == Direction.Descending and
    self.parent.data.orientation == Orientation.Vertical then

        self.bar:SetWidth( counterLeft / self.counterSPAN * self.barWidth )

    -- descending vertical
    elseif self.data.direction == Direction.Descending and
    self.parent.data.orientation == Orientation.Horizontal then

        self.bar:SetHeight( counterLeft / self.counterSPAN * self.barWidth )

    -- ascending horizontal
    elseif self.data.direction == Direction.Ascending and
    self.parent.data.orientation == Orientation.Vertical then

        local counterPast = self.counterEND - counterLeft
        self.bar:SetWidth( counterPast / self.counterSPAN * self.barWidth )

    -- ascending vertical
    else

        local counterPast = self.counterEND - counterLeft
        self.bar:SetWidth( counterPast / self.counterSPAN * self.barWidth )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- update timer
---------------------------------------------------------------------------------------------------
function CounterBarElement:UpdateTime( counterValue )

    -- update time depending on the direction
    if self.data.direction == Direction.Ascending then

        local counterPast = self.counterEND - counterValue
        self.timerLabel:SetText( counterPast )

    else
        
        self.timerLabel:SetText( counterValue )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- put the normal background back ( leaving the threshold, or switching it off )
---------------------------------------------------------------------------------------------------
function CounterBarElement:RestoreNormalAppearance()

    self.barBack:SetBackColor( self.backColor )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- switch the threshold on / off while the counter runs ( Enable/Disable Threshold trigger )
---------------------------------------------------------------------------------------------------
function CounterBarElement:SetThresholdActive( value )

    if self.thresholdForced == value then
        return
    end

    self.thresholdForced = value
    -- sampled on the next update: where the counters own threshold value has it by then, so
    -- a later crossing can be told apart and hand control back
    self.thresholdForcedFrom = nil

    -- let the threshold trigger event fire again
    self.firstThreshold = true

    -- the bar can be painted red right now, and with the threshold ended nothing else
    -- would paint it back
    if value == false then
        self:RestoreNormalAppearance()
    end

    -- make the next update apply the look again
    self._inThreshold = nil

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- update threshold
---------------------------------------------------------------------------------------------------
function CounterBarElement:UpdateThreshold( counterLeft )

    local useThreshold = self.data.useThreshold == true

    -- return if there is no threshold set up and no trigger asking for one
    if not useThreshold and self.thresholdForced == nil then
        return
    end

    -- where the counters own threshold value puts it
    local inThreshold = useThreshold and counterLeft <= self.data.thresholdValue or false

    -- an Enable/Disable Threshold trigger overrides that, until the counter crosses its own
    -- threshold value and hands control back to the setting
    if self.thresholdForced ~= nil then

        if self.thresholdForcedFrom == nil then
            self.thresholdForcedFrom = inThreshold
        end

        if inThreshold ~= self.thresholdForcedFrom then
            self.thresholdForced = nil
        else
            inThreshold = self.thresholdForced
        end

    end

    -- not in the threshold: restore normal background only on state change
    if not inThreshold then

        if self._inThreshold ~= false then
            self._inThreshold = false
            self:RestoreNormalAppearance()
        end

    -- in the threshold
    else

        -- threshold timer event
        if self.firstThreshold == true then
            self.firstThreshold = false
            Trigger.TimerEvent( self.data.id, Trigger.Types.TimerThreshold )
        end

        -- flashing: update every frame
        if self.data.useAnimation == true and
        self.data.animationType == AnimationType.Flashing then

            local flashValue = counterLeft * self.data.animationSpeed
            local value

            if math.floor( flashValue ) % 2 == 0 then
                value = 1 - ( flashValue - math.floor( flashValue ) )
            else
                value = ( flashValue - math.floor( flashValue ) )
            end

            self.barBack:SetBackColor( Turbine.UI.Color( 1, value, value ) )

        -- static background: set once on entry
        elseif self._inThreshold ~= true then

            self.barBack:SetBackColor( Turbine.UI.Color.Red )

        end

        self._inThreshold = true

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- timer is done
---------------------------------------------------------------------------------------------------
function CounterBarElement:Ended( silent )

    -- the run is over: an Enable/Disable Threshold trigger only ever applies to the run it
    -- was fired in. a counters UpdateContent runs on every single count, so unlike the other
    -- timers this is the only place that counts as a fresh run
    self.thresholdForced     = nil
    self.thresholdForcedFrom = nil

    -- timer ended trigger event
    -- a silent end ( reset ) stops the timer without firing the event, so a reset
    -- cannot start another timer that listens for this timers end
    if silent ~= true then

        Trigger.TimerEvent( self.data.id, Trigger.Types.TimerEnd )

    end

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
function CounterBarElement:Activ( value )

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

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check if timer should loop / set loop up and return loop
---------------------------------------------------------------------------------------------------
function CounterBarElement:Loop()

    -- reset timer with current time as start time
    local startTime = Turbine.Engine.GetGameTime()

    self:UpdateContent( startTime, self.counterEND, self.icon, self.textLabel:GetText(), self.entityControl:GetEntity(), self.key, true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- reset timer
---------------------------------------------------------------------------------------------------
function CounterBarElement:Reset(force)

    -- if reset attribute is set call the timer end without the timer end event
    if  force == true or self.data.reset == true then

        self:Ended( true )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- update visibility
---------------------------------------------------------------------------------------------------
function CounterBarElement:SetVisibility( value )

    -- change visiblility for all windows
    self:SetVisible( value )
    self.barBack:SetVisible( value )
    self.labelBack:SetVisible( value )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- reset size
---------------------------------------------------------------------------------------------------
function CounterBarElement:Resize()

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

---------------------------------------------------------------------------------------------------
-- get running information
---------------------------------------------------------------------------------------------------
function CounterBarElement:GetRunningInformation()

    local running_timer_data = {}

    running_timer_data.index = self.index
    running_timer_data.key = self.key
    running_timer_data.startTime = nil
    running_timer_data.duration = self.counterCURRENT
    running_timer_data.icon = self.icon
    running_timer_data.text = self.textLabel:GetText()

    return running_timer_data

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- get running information
---------------------------------------------------------------------------------------------------
Timer[ Timer.Types.COUNTER_BAR ].GetItemSize = function ( parent_data )

    local width = parent_data.width + ( 2 * parent_data.frame ) + Timer.WindowIconSize( parent_data )
    local height = parent_data.height + ( 2 * parent_data.frame)

    return width, height

end
---------------------------------------------------------------------------------------------------
