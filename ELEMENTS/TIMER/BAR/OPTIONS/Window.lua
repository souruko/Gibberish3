--===================================================================================
--             Name:    BAR OPTIONS Timer TabWindow
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================


BarOptions = class(Turbine.UI.Control)

function BarOptions:Constructor()
	Turbine.UI.Control.Constructor( self )

    local width = 506

    self.multiselect = false

    self:SetWidth(width)
    self:SetBackColor( Defaults.Colors.BackgroundColor2 )

    -------------------------------------------------------------------------------------
    --      Description:    BAR OPTIONS Timer OPTIONS
    -------------------------------------------------------------------------------------
    self.TimerTabWindow = Options.Constructor.TabWindow( self, width, 101  )

    self.TimerTabs = {}
    self.TimerTabs.general = OPTIONS.TimerGeneralTab( width, L[Language.Local].Tab.General, self.TimerTabWindow )
    self.TimerTabs.trigger = OPTIONS.TimerTriggerTab( width, L[Language.Local].Tab.Trigger, self.TimerTabWindow )
    self.TimerTabs.timer = OPTIONS.TimerTimerTab( width, L[Language.Local].Tab.Timer, self.TimerTabWindow )
    self.TimerTabs.text = OPTIONS.TimerTextTab( width, L[Language.Local].Tab.Text, self.TimerTabWindow )
    self.TimerTabs.animation = OPTIONS.TimerAnimationTab( width, L[Language.Local].Tab.Animation, self.TimerTabWindow )

    self.TimerTabWindow:AddTab( self.TimerTabs.general )
    self.TimerTabWindow:AddTab( self.TimerTabs.trigger )
    self.TimerTabWindow:AddTab( self.TimerTabs.timer )
    self.TimerTabWindow:AddTab( self.TimerTabs.text )
    self.TimerTabWindow:AddTab( self.TimerTabs.animation )

    self.TimerTabWindow:ResetSelection()

end

-------------------------------------------------------------------------------------
--      Description:    SizeChanged
-------------------------------------------------------------------------------------
function BarOptions:SizeChanged()

    self.TimerTabWindow:SetHeight(  self:GetHeight() )

end


-------------------------------------------------------------------------------------
--      Description:    FillContent
-------------------------------------------------------------------------------------
function BarOptions:FillContent( TimerData, TimerIndex, multiselect )

    self.multiselect = multiselect

    self.TimerTabs.general:FillContent( TimerData, TimerIndex, multiselect )
    self.TimerTabs.trigger:FillContent( TimerData, TimerIndex, multiselect )
    self.TimerTabs.timer:FillContent( TimerData, TimerIndex, multiselect )
    self.TimerTabs.text:FillContent( TimerData, TimerIndex, multiselect )
    self.TimerTabs.animation:FillContent( TimerData, TimerIndex, multiselect )

end


-------------------------------------------------------------------------------------
--      Description:    CheckContent
-------------------------------------------------------------------------------------
function BarOptions:CheckContent()
    
end


-------------------------------------------------------------------------------------
--      Description:    SaveContent
-------------------------------------------------------------------------------------
function BarOptions:SizeContent()
    
end

-------------------------------------------------------------------------------------
--      Description:    SaveContent
-------------------------------------------------------------------------------------
function BarOptions:Finish()
    
end

