--=================================================================================================
--= Bar Element
--= ===============================================================================================
--= 
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- create class
IconElement = class( Turbine.UI.Window )

-- function table for window constructors
Timer[ Timer.Types.ICON ].Constructor = function ( parent, data, index, startTime, duration, icon, text, entity, key, activ )

    return IconElement( parent, data, index, startTime, duration, icon, text, entity, key, activ )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Bar Constructor
---------------------------------------------------------------------------------------------------
function IconElement:Constructor( parent, data, index, startTime, duration, icon, text, entity, key, activ )
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
    -- animation 
    self.nextAnimation  = 0
    self.animationStep  = 1

    -- build elements
    self.entityControl = Turbine.UI.Lotro.EntityControl()
    self.entityControl:SetParent( self )
    self.entityControl:SetZOrder( 1 )

    self.frame = Turbine.UI.Control()
    self.frame:SetParent( self )
    self.frame:SetMouseVisible( false )
    self.frame:SetZOrder( 2 )

    self.iconControl = Turbine.UI.Control()
    self.iconControl:SetParent( self )
    self.iconControl:SetMouseVisible( false )
    self.iconControl:SetZOrder( 3 )

    self.shadow = Turbine.UI.Control()
    self.shadow:SetParent( self )
    self.shadow:SetBackColorBlendMode( Turbine.UI.BlendMode.Overlay )
    self.shadow:SetBackColor( Turbine.UI.Color.Black )
    self.shadow:SetMouseVisible( false )
    self.shadow:SetZOrder( 4 )

    self.animation = Turbine.UI.Control()
    self.animation:SetParent( self )
    self.animation:SetBackColorBlendMode( Turbine.UI.BlendMode.Overlay )
    self.animation:SetMouseVisible( false )
    self.animation:SetZOrder( 5 )

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
function IconElement:DataChanged()

    -- declarations
    local parentData = self.parent.data

    self:Resize()

    -- colors
    self.frame:SetBackColor( UTILS.ColorFix( parentData.color1 ) )
    
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

    -- set 
    self.frameColor = UTILS.ColorFix( parentData.color1 )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] update timer values
---------------------------------------------------------------------------------------------------
function IconElement:UpdateContent( startTime, duration, icon, text, entity, key, activ )

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

    -- reset target entity
    self.entityControl:SetEntity( entity )

    -- reset icon
    if self.data.showIcon == true then

        self.iconControl:SetSize( UTILS.GetImageSize( icon ) )
        self.iconControl:SetStretchMode( 1 )
        self.iconControl:SetBackground( icon )
        self.iconControl:SetSize( self.parent.data.width, self.parent.data.height )
    
    else

        self.iconControl:SetBackground( UTILS.IconID.Blank )
        self.iconControl:SetSize( self.parent.data.width, self.parent.data.height )

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
function IconElement:Finish()

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
function IconElement:Update()
    
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

        self:UpdateShadow( timeLeft )
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
function IconElement:UpdateShadow( timeLeft )

    -- return if shadow not used
    if self.data.useShadow == false then
        return
    end

    -- calculate shadow id depending on direction
    local shadowID

    if self.data.direction == Direction.Ascending then
        shadowID = 61 - math.floor(timeLeft / self.duration * 60)

    else
        shadowID = math.floor(timeLeft / self.duration * 60)

    end

    self.shadow:SetSize( 32, 32 )
    self.shadow:SetBackground( UTILS.IconID[ UTILS.IconID.Type.Shadow ][ shadowID ] )
    self.shadow:SetStretchMode( 1 )
    self.shadow:SetSize( self.width, self.height )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- update timer
---------------------------------------------------------------------------------------------------
function IconElement:UpdateTime( timeLeft )

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
function IconElement:UpdateThreshold( timeLeft )

    -- return if not using threshold
    if self.data.useThreshold == false then
        return
    end

    -- not in the threshold
    if timeLeft > self.data.thresholdValue then

        -- use backColor
        self.frame:SetBackColor( self.frameColor )

    -- in the threshold
    else

        -- threshold timer event
        if self.firstThreshold == true then

            self.firstThreshold = false
            Trigger.TimerEvent( self.data.id, Trigger.Types.TimerThreshold )

        end

        -- no animation only red background
        if self.data.useAnimation == false  then
   
            self.frame:SetBackColor( Turbine.UI.Color.Red )

        -- flashing
        elseif self.data.animationType == AnimationType.Flashing then
         
            local value
            local flashValue = timeLeft * self.data.animationSpeed
            
            if math.floor( flashValue ) % 2 == 0 then
            
                value = 1 - ( flashValue - math.floor( flashValue ) )

            else

                value = ( flashValue - math.floor( flashValue ) )

            end

            self.frame:SetBackColor( Turbine.UI.Color( 1, value, value ) )

        -- animation
        elseif self.data.animationType == AnimationType.Activation_Border or
        self.data.animationType == AnimationType.Dotted_Border or
        self.data.animationType == AnimationType.New_Activation_Border or
        self.data.animationType == AnimationType.New_Dotted_Border then

            self:ThresholdAnimation()

        else
         
            self.frame:SetBackColor( Turbine.UI.Color.Red )

        end
        
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- threshold animation
---------------------------------------------------------------------------------------------------
function IconElement:ThresholdAnimation()

    local gameTime = Turbine.Engine.GetGameTime()

    if self.nextAnimation <= gameTime then

        -- animation
        self.animation:SetSize(32, 32)
        self.animation:SetBackground( UTILS.IconID[ self.data.animationType ][ self.animationStep ] )
        self.animation:SetStretchMode( 1 )
        self.animation:SetSize( self.width, self.height )

        -- next stop
        if self.animationStep == #UTILS.IconID[ self.data.animationType ] then
            self.animationStep = 1
        else
            self.animationStep = self.animationStep + 1
        end

        -- set next frame for animation
        self.nextAnimation = gameTime + ( 0.2 / self.data.animationSpeed )
        
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- timer is done
---------------------------------------------------------------------------------------------------
function IconElement:Ended()

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
function IconElement:Activ( value )

    -- change opacity and text/timer visiblilty depending on activ
    if value == true then

        self:SetOpacity( self.parent.data.opacityActiv )
        self.iconControl:SetOpacity( self.parent.data.opacityActiv )

        self.textLabel:SetVisible( true )
        self.timerLabel:SetVisible( self.parent.data.showTimer )

    else

        self:SetOpacity( self.parent.data.opacityPassiv )
        self.iconControl:SetOpacity( self.parent.data.opacityPassiv )

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
function IconElement:Loop()

    -- reset timer with current time as start time
    local startTime = Turbine.Engine.GetGameTime()

    self:UpdateContent( startTime, self.duration, self.icon, self.textLabel:GetText(), self.entityControl:GetEntity(), self.key, true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- reset timer
---------------------------------------------------------------------------------------------------
function IconElement:Reset()

    -- if reset attribute is set call the timer end
    if self.data.reset == true then
        
        self:Ended()

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- update visibility
---------------------------------------------------------------------------------------------------
function IconElement:SetVisibility( value )

    -- change visiblility for all windows
    self:SetVisible( value )
    self.labelBack:SetVisible( value )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- reset size
---------------------------------------------------------------------------------------------------
function IconElement:Resize()

    -- declarations
    local frame = self.parent.data.frame
    local width, height, maxHeight, maxWidth, selfWidth, selfHeight, labelWidth, labelHeight, labelBackLeft,  labelBackTop

    -- set values depending on orientation
    if self.parent.data.orientation == Orientation.Vertical then

        -- bar width / height
        width           = self.parent.data.width
        height          = self.parent.data.height

        -- timer max sizze
        maxWidth        = width + ( 2 * frame )
        maxHeight       = height + ( 2 * frame)

        -- max size + spacing between timers
        selfWidth       = maxWidth 
        selfHeight      = maxHeight + self.parent.data.spacing

        -- subtract labelSpacing so the text/timer dont sit on the edges
        labelWidth      = width -- 2 * Options.Defaults.timer.labelSpacing
        labelHeight     = height -- 2 * Options.Defaults.timer.labelSpacing

        -- label starting position
        labelBackLeft   = frame --+ Options.Defaults.timer.labelSpacing
        labelBackTop    = frame --+ Options.Defaults.timer.labelSpacing

    else

        -- everything reversed
        width           = self.parent.data.width
        height          = self.parent.data.height

        maxWidth        = width + ( 2 * frame )
        maxHeight       = height + ( 2 * frame)

        selfWidth       = maxWidth + self.parent.data.spacing
        selfHeight      = maxHeight 

        labelWidth      = width -- 2 * Options.Defaults.timer.labelSpacing
        labelHeight     = height -- 2 * Options.Defaults.timer.labelSpacing

        labelBackLeft   = frame --+ Options.Defaults.timer.labelSpacing
        labelBackTop    = frame --+ Options.Defaults.timer.labelSpacing

    end

    self:SetSize( selfWidth, selfHeight )
    self.frame:SetSize( maxWidth, maxHeight )
    self.entityControl:SetSize( maxWidth, maxHeight )
    self.labelBack:SetSize( labelWidth, labelHeight )
    self.textLabel:SetSize( labelWidth, labelHeight )
    self.timerLabel:SetSize( labelWidth, labelHeight )
    self.iconControl:SetSize( width, height )
    self.shadow:SetSize( width, height )
    self.shadow.nativeWidth = width
    self.shadow.nativeHeight = height
    self.animation:SetSize( width, height )
    self.animation.nativeWidth = width
    self.animation.nativeHeight = height

    self.labelBack:SetPosition( labelBackLeft, labelBackTop )
    self.iconControl:SetPosition( frame, frame )
    self.shadow:SetPosition( frame, frame )
    self.animation:SetPosition( frame, frame )

    self.width = width
    self.height = height

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- get running information
---------------------------------------------------------------------------------------------------
function IconElement:GetRunningInformation()

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
Timer[ Timer.Types.ICON ].GetItemSize = function ( parent_data )

    local width = parent_data.width + ( 2 * parent_data.frame )
    local height = parent_data.height + ( 2 * parent_data.frame)

    return width, height

end
---------------------------------------------------------------------------------------------------
