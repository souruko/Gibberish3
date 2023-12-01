--=================================================================================================
--= Bar Element
--= ===============================================================================================
--= 
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- create class
CircelElement = class( Turbine.UI.Window )

-- function table for window constructors
Timer[ Timer.Types.CIRCEL ].Constructor = function ( parent, data, index, startTime, duration, icon, text, entity, key, activ )

    return CircelElement( parent, data, index, startTime, duration, icon, text, entity, key, activ )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Bar Constructor
---------------------------------------------------------------------------------------------------
function CircelElement:Constructor( parent, data, index, startTime, duration, icon, text, entity, key, activ )
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

    self.circelBack = Turbine.UI.Window()
    self.circelBack:SetParent( self )
    self.circelBack:SetMouseVisible( false )
    self.circelBack:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay)
    self.circelBack:SetZOrder( 3 )

    self.circel = Turbine.UI.Control()
    self.circel:SetParent( self.circelBack )
    self.circel:SetMouseVisible( false )
    self.circel:SetBackColorBlendMode(Turbine.UI.BlendMode.Overlay)
    self.circel:SetZOrder( 4 )

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
function CircelElement:DataChanged()

    -- declarations
    local parentData = self.parent.data

    self:Resize()

    -- orientation ( turn circel upside down)
    if self.parent.data.orientation == Orientation.Vertical then

        self.circelBack:SetRotation({x = 0, y = 0, z = 0})

    else

        self.circelBack:SetRotation({x = 0, y = 0, z = 180})

    end

    -- colors
    self.circelBack:SetBackColor( UTILS.ColorFix( parentData.color2 ) )
    self.circel:SetBackColor( UTILS.ColorFix( parentData.color3 ) )
    
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

    -- set circelWidth
    self.backColor = UTILS.ColorFix( parentData.color3 )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- [required] update timer values
---------------------------------------------------------------------------------------------------
function CircelElement:UpdateContent( startTime, duration, icon, text, entity, key, activ )

    -- reset key
    self.key = key

    -- reset time
    self.startTime = startTime
    self.duration = duration
    self.endTime = startTime + duration

    -- reset target entity
    self.entityControl:SetEntity( entity )

    -- reset icon
    if self.parent.data.showIcon == true then

        self.iconControl:SetSize( UTILS.GetImageSize( icon ) )
        self.iconControl:SetStretchMode( 1 )
        self.iconControl:SetBackground( icon )
        self.iconControl:SetSize( 32, 32 )

    else

        self.iconControl:SetBackground( UTILS.IconID.Blank )
        self.iconControl:SetSize( 32, 32 )

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
function CircelElement:Finish()

    -- stop updates and set visibility to false
    self:SetWantsUpdates( false )
    self:SetVisibility( false )

    self.parent:ChildFinished( self )

    -- close all windows
    self.labelBack:Close()
    self.circelBack:Close()
    self:Close()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- update element ( called every frame )
---------------------------------------------------------------------------------------------------
function CircelElement:Update()
    
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

        self:UpdateCircel( timeLeft )
        self:UpdateTime( timeLeft )
        self:UpdateThreshold( timeLeft )

    -- permanent timers without running time
    else

        self.timerLabel:SetText( "" )
        self.circel:SetBackground( UTILS.IconID[ UTILS.IconID.Type.Circel ][ 0 ] )
        self.circel:SetStretchMode( 2 )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- update circel
---------------------------------------------------------------------------------------------------
function CircelElement:UpdateCircel( timeLeft )

    if self.parent.data.direction == Direction.Ascending then

        local circelID = 100 - ( math.floor( timeLeft / self.duration * 100 ) )
        self.circel:SetBackground( UTILS.IconID[ UTILS.IconID.Type.Circel ][ circelID ] )
        self.circel:SetStretchMode( 2 )

    else

        local circelID = math.floor( timeLeft / self.duration * 100 )
        self.circel:SetBackground( UTILS.IconID[ UTILS.IconID.Type.Circel ][ circelID ] )
        self.circel:SetStretchMode( 2 )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- update timer
---------------------------------------------------------------------------------------------------
function CircelElement:UpdateTime( timeLeft )

    -- update time depending on the direction
    if self.parent.data.direction == Direction.Ascending then

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
function CircelElement:UpdateThreshold( timeLeft )

    -- return if not using threshold
    if self.data.useThreshold == false then
        return
    end

    -- not in the threshold
    if timeLeft > self.data.thresholdValue then

        -- use backColor
        self.circel:SetBackColor( self.backColor )

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

            self.circel:SetBackColor( Turbine.UI.Color( 1, value, value ) )

        -- no animation only red background
        else
            
            self.circel:SetBackColor( Turbine.UI.Color.Red )

        end
        
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- timer is done
---------------------------------------------------------------------------------------------------
function CircelElement:Ended()

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
function CircelElement:Activ( value )

    -- change opacity and text/timer visiblilty depending on activ
    if value == true then

        self:SetOpacity( self.parent.data.opacityActiv )
        self.circelBack:SetOpacity( self.parent.data.opacityActiv )

        self.textLabel:SetVisible( true )
        self.timerLabel:SetVisible( self.parent.data.showTimer )

    else

        self:SetOpacity( self.parent.data.opacityPassiv )
        self.circelBack:SetOpacity( self.parent.data.opacityPassiv )

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
function CircelElement:Loop()

    -- reset timer with current time as start time
    local startTime = Turbine.Engine.GetGameTime()

    self:UpdateContent( startTime, self.duration, nil, nil, nil, self.key )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- reset timer
---------------------------------------------------------------------------------------------------
function CircelElement:Reset()

    -- if reset attribute is set call the timer end
    if self.data.reset == true then
        
        self:Ended()

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- update visibility
---------------------------------------------------------------------------------------------------
function CircelElement:SetVisibility( value )

    -- change visiblility for all windows
    self:SetVisible( value )
    self.circelBack:SetVisible( value )
    self.labelBack:SetVisible( value )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- reset size
---------------------------------------------------------------------------------------------------
function CircelElement:Resize()

    -- declarations
    local width  = self.parent.data.width
    local height = self.parent.data.height

    self:SetSize( width, height )
    self.entityControl:SetSize( width, height )

    self.circelBack:SetSize( width, height)
    self.circelBack.nativeWidth = width
    self.circelBack.nativeHeight = height
    self.circelBack:SetBackground( UTILS.IconID[ UTILS.IconID.Type.Circel ][ 100 ] )
    self.circelBack:SetStretchMode( 2 )

    self.circel:SetSize( width, height )
    self.circel.nativeWidth = width
    self.circel.nativeHeight = height
    self.circel:SetStretchMode( 2 )

    self.labelBack:SetSize( width, height )
    self.textLabel:SetSize( width, height )
    self.timerLabel:SetSize( width, height )

    self.iconControl:SetSize( 32, 32 )

    self.circelBack:SetPosition( 0, 0 )
    self.labelBack:SetPosition( 0, 0 )
    self.iconControl:SetPosition( ( width / 2 - 16 ), ( height / 2 - 16 ) )

end
---------------------------------------------------------------------------------------------------
