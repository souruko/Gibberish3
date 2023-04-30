--===================================================================================
--             Name:    BAR Element
-------------------------------------------------------------------------------------
--      Description:    BAR Class
--===================================================================================
BarElement = class(Turbine.UI.Window)





-------------------------------------------------------------------------------------
--      Description:    BAR constructor
-------------------------------------------------------------------------------------
--        Parameter:    timer data 
-------------------------------------------------------------------------------------
--           Return:    timer BAR element
-------------------------------------------------------------------------------------
function BarElement:Constructor(groupData, timerData, timerIndex, startTime, duration, icon, text, entity, key)
    Turbine.UI.Window.Constructor( self )

-------------------------------------------------------------------------------------
--  attributes

    self.index      = timerIndex
    self.groupData  = groupData
    self.timerData  = timerData

    self.key        = key

    self.startTime  = startTime
    self.duration   = duration

    self.barWdith   = self.groupData.width

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
    self.bar:SetZOrder                      ( 6 )


    self.labelBack = Turbine.UI.Window      ( )
    self.labelBack:SetParent                ( self )
    self.labelBack:SetMouseVisible          ( false )
    self.labelBack:SetZOrder                ( 5 )

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
function BarElement:Visibility( visible )

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
    local maxWidth  = self.groupData.width  + ( 2 * self.groupData.frame ) + self.groupData.height
    local maxHeight = self.groupData.height + ( 2 * self.groupData.frame )

    self:SetSize                    ( maxWidth, maxHeight )
    self.frame:SetSize              ( maxWidth, maxHeight )
    self.entityControl:SetSize      ( maxWidth, maxHeight )

    self.barBack:SetSize            ( self.groupData.width, self.groupData.height )
    self.bar:SetSize                ( self.groupData.width, self.groupData.height )

    self.labelBack:SetSize          ( self.groupData.width - ( 2 * labelSpacing ), self.groupData.height )
    self.timerLabel:SetSize         ( self.labelBack:GetSize() )
    self.textLabel:SetSize          ( self.labelBack:GetSize() )

    self.iconControl:SetSize        ( self.groupData.height, self.groupData.height )


-------------------------------------------------------------------------------------
--  position

    self.barBack:SetPosition        ( self.groupData.frame + self.groupData.height, self.groupData.frame )
    self.labelBack:SetPosition      ( self.groupData.frame + self.groupData.height + labelSpacing, self.groupData.frame )

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


-------------------------------------------------------------------------------------
--  text

    self.textLabel:SetTextAlignment ( self.groupData.textAlignment )
    self.timerLabel:SetTextAlignment( self.groupData.timerAlignment )

    local font = Utils.FontFix      ( self.groupData.font )

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

    self.entityControl:SetEntity           ( entity )

    if icon ~= nil then
        self.iconControl:SetBackground     ( icon )
    end

    self.textLabel:SetText                 ( text )
    self.timerLabel:SetText                ( "" )

end

