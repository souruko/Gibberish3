--===================================================================================
--             Name:    BAR Element
-------------------------------------------------------------------------------------
--      Description:    BAR Class
--===================================================================================
BarElement = class(Turbine.UI.Window)







-------------------------------------------------------------------------------------
--      Description:    BAR constructor
-------------------------------------------------------------------------------------
--        Parameter:    parent,
--                      groupData
--                      timerData
--                      timerIndex
--                      startTime
--                      duration
--                      icon
--                      text
--                      entity
--                      key
-------------------------------------------------------------------------------------
--           Return:    timer BAR element
-------------------------------------------------------------------------------------
function BarElement:Constructor(    parent,
                                    groupData,
                                    timerData,
                                    timerIndex,
                                    startTime,
                                    duration,
                                    icon,
                                    text,
                                    entity,
                                    key)

    Turbine.UI.Window.Constructor( self )

-------------------------------------------------------------------------------------
--  attributes

    self.index          = timerIndex
    self.groupData      = groupData
    self.timerData      = timerData
    self.parent         = parent

    self.key            = key

    self.barWdith       = self.groupData.width
    self.backColor      = Utils.ColorFix( self.groupData.color2 )
    self.firstThreshold = false

-------------------------------------------------------------------------------------
--  construct

    self.frame = Turbine.UI.Control         ( )
    self.frame:SetParent                    ( self )
    self.frame:SetMouseVisible              ( false )
    self.frame:SetZOrder                    ( 2 )

    self.barBack = Turbine.UI.Window        ( )
    self.barBack:SetParent                  ( self )
    self.barBack:SetMouseVisible            ( false )
    self.barBack:SetZOrder                  ( 4 )

    self.bar = Turbine.UI.Control           ( )
    self.bar:SetParent                      ( self.barBack )
    self.bar:SetMouseVisible                ( false )
    self.bar:SetZOrder                      ( 5 )

    self.labelBack = Turbine.UI.Window      ( )
    self.labelBack:SetParent                ( self )
    self.labelBack:SetMouseVisible          ( false )
    self.labelBack:SetZOrder                ( 6 )

    self.textLabel = Turbine.UI.Label       ( )
    self.textLabel:SetParent                ( self.labelBack )
    self.textLabel:SetMouseVisible          ( false )
    self.textLabel:SetZOrder                ( 7 )
    self.textLabel:SetFontStyle             ( Turbine.UI.FontStyle.Outline )

    self.timerLabel = Turbine.UI.Label      ( )
    self.timerLabel:SetParent               ( self.labelBack )
    self.timerLabel:SetMouseVisible         ( false )
    self.timerLabel:SetZOrder               ( 8 )
    self.timerLabel:SetFontStyle            ( Turbine.UI.FontStyle.Outline )


    self.iconControl = Turbine.UI.Control   ( )
    self.iconControl:SetParent              ( self )
    self.iconControl:SetMouseVisible        ( false )
    self.iconControl:SetZOrder              ( 3 )

    self.entityControl = Turbine.UI.Lotro.EntityControl ( )
    self.entityControl:SetParent            ( self )
    self.entityControl:SetZOrder            ( 1 )



-------------------------------------------------------------------------------------
--  ready

    self:GroupDataChanged                   ( )
    self:TimerDataChanged                   ( )

    self:UpdateTimer                        ( startTime, duration, icon, text, entity, key )

    self:Visibility                         ( true )

end



-------------------------------------------------------------------------------------
--      Description:    reset event
-------------------------------------------------------------------------------------
--        Parameter:     
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function BarElement:Visibility ( visible )

    self:SetVisible            ( visible )
    self.barBack:SetVisible    ( visible )
    self.labelBack:SetVisible  ( visible )

end



-------------------------------------------------------------------------------------
--      Description:    reset event
-------------------------------------------------------------------------------------
--        Parameter:     
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function BarElement:Reset()

    if self.timerData.reset == true then

    end

end



-------------------------------------------------------------------------------------
--      Description:    timer data has changed event
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function BarElement:TimerDataChanged()

end




-------------------------------------------------------------------------------------
--      Description:    group data has changed event
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function BarElement:GroupDataChanged()

-------------------------------------------------------------------------------------
--  size

    local labelSpacing = 4
    local maxHeight, maxWidth, width, height, barBackLeft, barBackTop, labelBackLeft, labelBackTop

    if self.groupData.orientation == Orientation.Vertical then

        maxWidth        = self.groupData.width  + ( 2 * self.groupData.frame ) + self.groupData.height
        maxHeight       = self.groupData.height + ( 2 * self.groupData.frame )

        width           = self.groupData.width
        height          = self.groupData.height

        barBackLeft     = self.groupData.frame + self.groupData.height
        barBackTop      = self.groupData.frame

        labelBackLeft   = self.groupData.frame + self.groupData.height + labelSpacing
        labelBackTop    = self.groupData.frame

    else

        maxHeight       = self.groupData.width  + ( 2 * self.groupData.frame ) + self.groupData.height
        maxWidth        = self.groupData.height + ( 2 * self.groupData.frame )

        width           = self.groupData.height
        height          = self.groupData.width

        barBackTop      = self.groupData.frame + self.groupData.height
        barBackLeft     = self.groupData.frame

        labelBackTop    = self.groupData.frame + self.groupData.height + labelSpacing
        labelBackLeft   = self.groupData.frame

    end

        self:SetSize                    ( maxWidth, maxHeight )
        self.frame:SetSize              ( maxWidth, maxHeight )
        self.entityControl:SetSize      ( maxWidth, maxHeight )

        self.barBack:SetSize            ( width, height )
        self.bar:SetSize                ( width, self.groupData.heigth )
    
        self.labelBack:SetSize          ( width - ( 2 * labelSpacing ), height )
        self.timerLabel:SetSize         ( self.labelBack:GetSize() )
        self.textLabel:SetSize          ( self.labelBack:GetSize() )

        self.iconControl:SetSize        ( height, height )


-------------------------------------------------------------------------------------
--  position

        self.barBack:SetPosition        ( barBackLeft, barBackTop )
        self.labelBack:SetPosition      ( labelBackLeft, labelBackTop )

        self.iconControl:SetPosition    ( self.groupData.frame, self.groupData.frame )


-------------------------------------------------------------------------------------
--  color

    self.frame:SetBackColor         (  Utils.ColorFix( self.groupData.color1 ) )
    self.barBack:SetBackColor       (  Utils.ColorFix( self.groupData.color2 ) )
    self.bar:SetBackColor           (  Utils.ColorFix( self.groupData.color3 ) )

    self.timerLabel:SetForeColor    (  Utils.ColorFix( self.groupData.color4 ) )
    self.textLabel:SetForeColor     (  Utils.ColorFix( self.groupData.color5 ) )


-------------------------------------------------------------------------------------
--  opacity

    self:SetOpacity                 ( self.groupData.opacityActiv )
    self.barBack:SetOpacity                 ( self.groupData.opacityActiv )


-------------------------------------------------------------------------------------
--  text

    self.textLabel:SetTextAlignment ( self.groupData.textAlignment )
    self.timerLabel:SetTextAlignment( self.groupData.timerAlignment )

    local font = Font[ self.groupData.font ]

    self.textLabel:SetFont          ( font )
    self.timerLabel:SetFont         ( font )

    self.timerLabel:SetVisible      ( self.groupData.showTimer )


-------------------------------------------------------------------------------------
--  entity

    self:SetMouseVisible              ( self.groupData.useTargetEntity )
    self.entityControl:SetMouseVisible( self.groupData.useTargetEntity )

end



-------------------------------------------------------------------------------------
--      Description:    update timer 
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function BarElement:UpdateTimer(startTime, duration, icon, text, entity, key)

    self.key        = key

    self.startTime  = startTime
    self.duration   = duration
    self.endTime    = startTime + duration

    if entity ~= nil then
        self.entityControl:SetEntity            ( entity )
    end

    if icon ~= nil then

        self.iconControl:SetSize            ( Utils.GetImageSize(icon) )
        self.iconControl:SetStretchMode     ( 1 )
        self.iconControl:SetBackground      ( icon )
        self.iconControl:SetSize            ( self.groupData.height, self.groupData.height )

    end

    self.textLabel:SetText                  ( text )
    self.timerLabel:SetText                 ( "" )

    self:SetWantsUpdates(true)

end



-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function BarElement:Update()

    local gameTime = Turbine.Engine.GetGameTime()

    local timeLeft = self.endTime - gameTime

-------------------------------------------------------------------------------------
-- stop

    if timeLeft <= 0 then

        if self.timerData.loop == true then
        
            self:Loop()

        else

            self:Shutdown()

        end

    end

-------------------------------------------------------------------------------------
-- running

    if timeLeft < 99999 then

        self:UpdateTimeAndBar   ( timeLeft )

        self:UpdateThreshol     ( timeLeft )

    else

        self.timerLabel:SetText("")
		self.bar:SetSize(0, 0)
 
    end

end




-------------------------------------------------------------------------------------
--      Description: update bar and timeLabel  
-------------------------------------------------------------------------------------
--        Parameter: timeLeft   
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function BarElement:UpdateTimeAndBar(timeLeft)

    if self.timerData.direction == Direction.Ascending then

        local timePast = self.duration - timeLeft

        self.timerLabel:SetText( Utils.SecondsToClock( timePast, self.groupData.durationFormat ) )

        if self.groupData.orientation == Orientation.Vertical then

            self.bar:SetSize( timePast / self.duration * self.barWdith, self.groupData.height )

        else

            self.bar:SetSize( self.groupData.height, timePast / self.duration * self.barWdith )

        end

    else

        self.timerLabel:SetText( Utils.SecondsToClock( timeLeft, self.groupData.durationFormat ) )

        if self.groupData.orientation == Orientation.Vertical then

            self.bar:SetSize( timeLeft / self.duration * self.barWdith, self.groupData.height )

        else

            self.bar:SetSize( self.groupData.height, timeLeft / self.duration * self.barWdith )

        end

    end
    
end



-------------------------------------------------------------------------------------
--      Description: threshold
-------------------------------------------------------------------------------------
--        Parameter: timeLeft   
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function BarElement:UpdateThreshol(timeLeft)

    if self.timerData.useThreshold then

        if timeLeft <= self.timerData.thresholdValue then

            if self.firstThreshold == true then

                self.firstThreshold = false
                
            end


            if self.timerData.useAnimation == true then

                if self.timerData.animationType == AnimationType.Flashing then

                    local value
                    local flashValue = timeLeft * self.timerData.animationSpeed
                    
                    if math.floor( flashValue ) % 2 == 0 then
                    
                        value = 1 - ( flashValue - math.floor( flashValue ) )

                    else

                        value = ( flashValue - math.floor( flashValue ) )

                    end

                    self.barBack:SetBackColor( Turbine.UI.Color( 1, value, value ) )

                else

                    self.barBack:SetBackColor( Turbine.UI.Color.Red )

                end

            else

                self.barBack:SetBackColor( Turbine.UI.Color.Red )
                
            end

        else

            self.barBack:SetBackColor( self.backColor )

        end
        
    end

end




-------------------------------------------------------------------------------------
--      Description:    Loop 
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function BarElement:Loop()

    local startTime = Turbine.Engine.GetGameTime()

    local text = self.textLabel:GetText()
    local key = self.key

    self:UpdateTimer( startTime, self.duration, nil, text, nil, key )
    
end

-------------------------------------------------------------------------------------
--      Description:    Shutdown
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function BarElement:Shutdown()

    self:SetWantsUpdates(false)

    self:Visibility(false)

    self.parent:RemoveChild(self)

end