--===================================================================================
--             Name:    COUNTER_BAR Element
-------------------------------------------------------------------------------------
--      Description:    COUNTER_BAR Class
--===================================================================================
CounterBarElement = class(Turbine.UI.Window)







-------------------------------------------------------------------------------------
--      Description:    COUNTER_BAR constructor
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
--           Return:    timer COUNTER_BAR element
-------------------------------------------------------------------------------------
function CounterBarElement:Constructor(    parent,
                                    groupData,
                                    timerData,
                                    timerIndex,
                                    startTime,
                                    duration,
                                    icon,
                                    text,
                                    entity,
                                    key,
                                    activ )

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

    Trigger.TimerStart.Event( self.timerData.id )

-------------------------------------------------------------------------------------
--  construct


    self.entityControl = Turbine.UI.Lotro.EntityControl ( )
    self.entityControl:SetParent            ( self )
    self.entityControl:SetZOrder            ( 1 )

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




-------------------------------------------------------------------------------------
--  ready

    self:GroupDataChanged                   ( )
    self:TimerDataChanged                   ( )

    if self.groupData.counterDirection == Direction.Ascending then
        self.counter = 0

    else
        if self.timerData.counterValue == nil then

            self.counter        = 10

        else

            self.counter        = self.timerData.counterValue
        
        end

    end
    
    self:UpdateTimer                        ( startTime, 0, icon, text, entity, key, activ )

    self:Visibility                         ( true )

end



-------------------------------------------------------------------------------------
--      Description:    reset event
-------------------------------------------------------------------------------------
--        Parameter:     
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function CounterBarElement:Visibility ( visible )

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
function CounterBarElement:Reset()

    if self.timerData.reset == true then

        self:Shutdown()

    end

end



-------------------------------------------------------------------------------------
--      Description:    timer data has changed event
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function CounterBarElement:TimerDataChanged()

end




-------------------------------------------------------------------------------------
--      Description:    group data has changed event
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function CounterBarElement:GroupDataChanged()

-------------------------------------------------------------------------------------
--  size

    local labelSpacing = 4
    local maxHeight, maxWidth, width, height, barBackLeft, barBackTop
    local labelBackLeft, labelBackTop, selfWdith, selfHeight


    if self.groupData.orientation == Orientation.Vertical then

        maxWidth        = self.groupData.width  + ( 2 * self.groupData.frame ) + self.groupData.height
        maxHeight       = self.groupData.height + ( 2 * self.groupData.frame )

        selfWdith       = maxWidth
        selfHeight      = maxHeight + self.groupData.spacing

        width           = self.groupData.width
        height          = self.groupData.height

        barBackLeft     = self.groupData.frame + self.groupData.height
        barBackTop      = self.groupData.frame

        labelBackLeft   = self.groupData.frame + self.groupData.height + labelSpacing
        labelBackTop    = self.groupData.frame

    else

        maxHeight       = self.groupData.width  + ( 2 * self.groupData.frame ) + self.groupData.height
        maxWidth        = self.groupData.height + ( 2 * self.groupData.frame )

        selfWdith       = maxWidth + self.groupData.spacing
        selfHeight      = maxHeight

        width           = self.groupData.height
        height          = self.groupData.width

        barBackTop      = self.groupData.frame + self.groupData.height
        barBackLeft     = self.groupData.frame

        labelBackTop    = self.groupData.frame + self.groupData.height + labelSpacing
        labelBackLeft   = self.groupData.frame

    end

    self:SetSize                    ( selfWdith, selfHeight )
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
function CounterBarElement:UpdateTimer(startTime, counter, icon, text, entity, key, activ)

    self.key        = key

    if entity ~= nil then
        self.entityControl:SetEntity            ( entity )
    end

    if icon ~= nil then

        self.iconControl:SetSize            ( Utils.GetImageSize(icon) )
        self.iconControl:SetStretchMode     ( 1 )
        self.iconControl:SetBackground      ( icon )
        self.iconControl:SetSize            ( self.groupData.height, self.groupData.height )

    end

    self.counter = self.counter + counter
    if self.groupData.counterDirection == Direction.Ascending then
       
        if self.counter >= self.timerData.counterValue then
            self:Shutdown()
            return
        end

    else

        if self.counter < 1 then
            self:Shutdown()
            return
        end

    end

    self.textLabel:SetText                  ( text )
    self.timerLabel:SetText                 ( tostring( self.counter ) )

    self:Activ(activ)

    self:UpdateTimeAndCounterBar()

end



-------------------------------------------------------------------------------------
--      Description: update bar and timeLabel  
-------------------------------------------------------------------------------------
--        Parameter: timeLeft   
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function CounterBarElement:UpdateTimeAndCounterBar()

    if self.timerData.direction == Direction.Ascending then

        local counterPast = self.timerData.counterValue - self.counter

        self.bar:SetSize( counterPast / self.timerData.counterValue * self.barWdith, self.groupData.height )

    else

        local counterValue = self.timerData.counterValue

        if counterValue == nil then
           counterValue = 0
        end

        self.bar:SetSize( self.counter / counterValue * self.barWdith, self.groupData.height )

    end

end



-------------------------------------------------------------------------------------
--      Description: threshold
-------------------------------------------------------------------------------------
--        Parameter: timeLeft   
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function CounterBarElement:UpdateThreshold()

end




-------------------------------------------------------------------------------------
--      Description:    Loop 
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function CounterBarElement:Loop()

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
function CounterBarElement:Shutdown()

    Trigger.TimerEnd.Event( self.timerData.id )

    if self.timerData.permanent == true then
        
        self:Activ(false)

    else

        self:Finish()

    end

end


-------------------------------------------------------------------------------------
--      Description:    Finish
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function CounterBarElement:Finish()

    self:Visibility(false)

    self.parent:RemoveChild(self)

    self.labelBack:Close()

    self.barBack:Close()
    self:Close()

end


-------------------------------------------------------------------------------------
--      Description:    Activ
-------------------------------------------------------------------------------------
--        Parameter:    true/false
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function CounterBarElement:Activ(activ)

    self.activ = activ

    if activ == true then

        self:SetOpacity                 ( self.groupData.opacityActiv )
        self.barBack:SetOpacity         ( self.groupData.opacityActiv )
        self.textLabel:SetVisible(true)
        self.timerLabel:SetVisible(true)

    else

        self:SetOpacity                 ( self.groupData.opacityPassiv )
        self.barBack:SetOpacity         ( self.groupData.opacityPassiv )
        
        self.bar:SetWidth(0)
        self.textLabel:SetVisible(false)
        self.timerLabel:SetVisible(false)

    end

end