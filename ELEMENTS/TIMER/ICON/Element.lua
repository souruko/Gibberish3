--===================================================================================
--             Name:    ICON Element
-------------------------------------------------------------------------------------
--      Description:    ICON Class
--===================================================================================
IconElement = class(Turbine.UI.Window)







-------------------------------------------------------------------------------------
--      Description:    ICON constructor
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
--           Return:    timer ICON element
-------------------------------------------------------------------------------------
function IconElement:Constructor(    parent,
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

    self.nextAnimation  = 0
    self.animationStep  = 1

    self.key            = key

    self.backColor      = Utils.ColorFix( self.groupData.color1 )
    self.firstThreshold = false

    Trigger.TimerStart.Event( self.timerData.id )

-------------------------------------------------------------------------------------
--  construct

    self.frame = Turbine.UI.Control         ( )
    self.frame:SetParent                    ( self )
    self.frame:SetMouseVisible              ( false )
    self.frame:SetZOrder                    ( 2 )

    self.iconControl = Turbine.UI.Control   ( )
    self.iconControl:SetParent              ( self )
    self.iconControl:SetMouseVisible        ( false )
    self.iconControl:SetZOrder              ( 3 )

    self.shadow = Turbine.UI.Control        ()
    self.shadow:SetParent                   (self)
    self.shadow:SetBackColorBlendMode       (Turbine.UI.BlendMode.Overlay)
    self.shadow:SetBackColor                (Turbine.UI.Color.Black)
    self.shadow:SetMouseVisible             (false)
    self.shadow:SetZOrder                   (4)

    self.animation = Turbine.UI.Control     ()
    self.animation:SetParent                (self)
    self.animation:SetBackColorBlendMode    (Turbine.UI.BlendMode.Overlay)
    self.animation:SetMouseVisible          (false)
    self.animation:SetZOrder                (5)

    self.entityControl = Turbine.UI.Lotro.EntityControl ( )
    self.entityControl:SetParent            ( self )
    self.entityControl:SetZOrder            ( 1 )

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



-------------------------------------------------------------------------------------
--  ready

    self:GroupDataChanged                   ( )
    self:TimerDataChanged                   ( )

    self:UpdateTimer                        ( startTime, duration, icon, text, entity, key, activ )

    self:Visibility                         ( true )

end



-------------------------------------------------------------------------------------
--      Description:    reset event
-------------------------------------------------------------------------------------
--        Parameter:     
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function IconElement:Visibility ( visible )

    self:SetVisible            ( visible )
    self.labelBack:SetVisible  ( visible )

end



-------------------------------------------------------------------------------------
--      Description:    reset event
-------------------------------------------------------------------------------------
--        Parameter:     
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function IconElement:Reset()

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
function IconElement:TimerDataChanged()

end




-------------------------------------------------------------------------------------
--      Description:    group data has changed event
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function IconElement:GroupDataChanged()

-------------------------------------------------------------------------------------
--  size

    local labelSpacing = 4
    local maxHeight, maxWidth, selfWdith, selfHeight

    maxWidth            = self.groupData.width  + ( 2 * self.groupData.frame )
    maxHeight           = self.groupData.height + ( 2 * self.groupData.frame )

    selfWdith       = maxWidth  + self.groupData.spacing
    selfHeight      = maxHeight + self.groupData.spacing

    self:SetSize                    ( selfWdith, selfHeight )
    if self.groupData.frame == 0 then
        self.frame:SetVisible(false)
    else
        self.frame:SetVisible(true)
    end
    self.frame:SetSize              ( maxWidth, maxHeight )
    self.entityControl:SetSize      ( maxWidth, maxHeight )

    self.labelBack:SetSize          ( self.groupData.width - ( 2 * labelSpacing ),
                                      self.groupData.height - ( 2 * labelSpacing ) )

    self.timerLabel:SetSize         ( self.labelBack:GetSize() )
    self.textLabel:SetSize          ( self.labelBack:GetSize() )

    self.iconControl:SetSize        ( self.groupData.width, self.groupData.height)



-------------------------------------------------------------------------------------
--  position

    self.iconControl:SetPosition    ( self.groupData.frame, self.groupData.frame )
    self.shadow:SetPosition    ( self.groupData.frame, self.groupData.frame )
    self.animation:SetPosition    ( self.groupData.frame, self.groupData.frame )
    self.labelBack:SetPosition      ( labelSpacing, labelSpacing )

-------------------------------------------------------------------------------------
--  color

    self.frame:SetBackColor         (  Utils.ColorFix( self.groupData.color1 ) )

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
function IconElement:UpdateTimer(startTime, duration, icon, text, entity, key, activ)

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

    self:Activ(activ)


end



-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function IconElement:Update()

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

        self:UpdateTimeAndIcon   ( timeLeft )

        self:UpdateThreshold     ( timeLeft, gameTime )

    else

        self.timerLabel:SetText("")
 
    end

end




-------------------------------------------------------------------------------------
--      Description: update bar and timeLabel  
-------------------------------------------------------------------------------------
--        Parameter: timeLeft   
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function IconElement:UpdateTimeAndIcon(timeLeft)

    if self.timerData.direction == Direction.Ascending then

        local timePast = self.duration - timeLeft

        self.timerLabel:SetText( Utils.SecondsToClock( timePast, self.groupData.durationFormat ) )

        if self.timerData.useShadow == true then
            local shadowIndex = 61- math.floor(timeLeft / self.duration * 60)

            self.shadow:SetSize(32, 32)
            self.shadow:SetBackground( IconID[ IconID.Type.Shadow ][ shadowIndex ] )
            self.shadow:SetStretchMode(1)
            self.shadow:SetSize( self.groupData.width, self.groupData.height )
    
        end

    else

        self.timerLabel:SetText( Utils.SecondsToClock( timeLeft, self.groupData.durationFormat ) )

        if self.timerData.useShadow == true then

            local shadowIndex = math.floor(timeLeft / self.duration * 60)
            self.shadow:SetSize(32, 32)
            self.shadow:SetBackground( IconID[ IconID.Type.Shadow ][ shadowIndex ] )
            self.shadow:SetStretchMode(1)
            self.shadow:SetSize( self.groupData.width, self.groupData.height)
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
function IconElement:UpdateThreshold( timeLeft, gameTime )

    if self.timerData.useThreshold then

        if timeLeft <= self.timerData.thresholdValue then

            if self.firstThreshold == true then

                self.firstThreshold = false

                Trigger.TimerThreshold.Event( self.timerData.id )
                
            end


            if self.timerData.useAnimation == true then

                self:ThresholdAnimation( gameTime )

            else

                self.frame:SetBackColor( Turbine.UI.Color.Red )
                
            end

        else

            self.frame:SetBackColor( self.backColor )

        end
        
    end

end



-------------------------------------------------------------------------------------
--      Description:    Threshold Animation 
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function IconElement:ThresholdAnimation ( gameTime )

    if  self.nextAnimation < gameTime then
        
        self.animation:SetSize(32, 32)
        self.animation:SetBackground(IconID[ self.timerData.animationType ][ self.animationStep ])
        self.animation:SetStretchMode(1)
        self.animation:SetSize( self.groupData.width, self.groupData.height )

        --set next step
        if self.animationStep == #IconID[ self.timerData.animationType ] then
            self.animationStep = 1

        else
            self.animationStep = self.animationStep + 1

        end
        -- set next frame for animation
        self.nextAnimation = gameTime + ( 0.2 / self.timerData.animationSpeed )
    end
 
end



-------------------------------------------------------------------------------------
--      Description:    Loop 
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function IconElement:Loop()

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
function IconElement:Shutdown()

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
function IconElement:Finish()

    self:SetWantsUpdates(false)

    self:Visibility(false)

    self.parent:RemoveChild(self)

    self.iconControl:Close()
    self.frame:Close()

    self.timerLabel:Close()
    self.textLabel:Clse()
    self.labelBack:Close()

    self.animation:Close()
    self.shadow:Close()
    self:Close()

end


-------------------------------------------------------------------------------------
--      Description:    Activ
-------------------------------------------------------------------------------------
--        Parameter:    true/false
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function IconElement:Activ(activ)

    self.activ = activ

    if activ == true then

        self:SetOpacity                 ( self.groupData.opacityActiv )
        self.iconControl:SetOpacity     ( self.groupData.opacityActiv )

        self.textLabel:SetVisible(true)
        self.timerLabel:SetVisible(true)

    else

        self:SetOpacity                 ( self.groupData.opacityPassiv )
        self.iconControl:SetOpacity     ( self.groupData.opacityPassiv )
        
        self.bar:SetWidth(0)
        self.textLabel:SetVisible(false)
        self.timerLabel:SetVisible(false)

    end

    self:SetWantsUpdates(self.activ)

end