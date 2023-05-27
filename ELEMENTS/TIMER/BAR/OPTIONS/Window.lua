--===================================================================================
--             Name:    BAR OPTIONS Timer TabWindow
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================


-------------------------------------------------------------------------------------
--      Description:    BAR OPTIONS Control
-------------------------------------------------------------------------------------
Timer.Options[ Timer.Types.BAR ] = Turbine.UI.Control()

local width = 506

Timer.Options[ Timer.Types.BAR ].multiselect = false

Timer.Options[ Timer.Types.BAR ]:SetWidth(width)
Timer.Options[ Timer.Types.BAR ]:SetBackColor( Defaults.Colors.BackgroundColor2 )

-------------------------------------------------------------------------------------
--      Description:    BAR OPTIONS Timer OPTIONS
-------------------------------------------------------------------------------------
Timer.Options[ Timer.Types.BAR ].TimerTabWindow = Options.Constructor.TabWindow( Timer.Options[  Timer.Types.BAR ], width, 101  )

Timer.Options[ Timer.Types.BAR ].TimerTabs = {}
Timer.Options[ Timer.Types.BAR ].TimerTabs.general = OPTIONS.TIMER_OPTIONS.TimerGeneralTab( width, L[Language.Local].Tab.General, Timer.Options[ Timer.Types.BAR ].TimerTabWindow )
Timer.Options[ Timer.Types.BAR ].TimerTabs.trigger = OPTIONS.TIMER_OPTIONS.TimerTriggerTab( width, L[Language.Local].Tab.Trigger, Timer.Options[ Timer.Types.BAR ].TimerTabWindow )
Timer.Options[ Timer.Types.BAR ].TimerTabs.timer = OPTIONS.TIMER_OPTIONS.TimerTimerTab( width, L[Language.Local].Tab.Timer, Timer.Options[ Timer.Types.BAR ].TimerTabWindow )
Timer.Options[ Timer.Types.BAR ].TimerTabs.text = OPTIONS.TIMER_OPTIONS.TimerTextTab( width, L[Language.Local].Tab.Text, Timer.Options[ Timer.Types.BAR ].TimerTabWindow )
Timer.Options[ Timer.Types.BAR ].TimerTabs.animation = OPTIONS.TIMER_OPTIONS.TimerAnimationTab( width, L[Language.Local].Tab.Animation, Timer.Options[ Timer.Types.BAR ].TimerTabWindow )

Timer.Options[ Timer.Types.BAR ].TimerTabWindow:AddTab( Timer.Options[ Timer.Types.BAR ].TimerTabs.general )
Timer.Options[ Timer.Types.BAR ].TimerTabWindow:AddTab( Timer.Options[ Timer.Types.BAR ].TimerTabs.trigger )
Timer.Options[ Timer.Types.BAR ].TimerTabWindow:AddTab( Timer.Options[ Timer.Types.BAR ].TimerTabs.timer )
Timer.Options[ Timer.Types.BAR ].TimerTabWindow:AddTab( Timer.Options[ Timer.Types.BAR ].TimerTabs.text )
Timer.Options[ Timer.Types.BAR ].TimerTabWindow:AddTab( Timer.Options[ Timer.Types.BAR ].TimerTabs.animation )

Timer.Options[ Timer.Types.BAR ].TimerTabWindow:ResetSelection()


-------------------------------------------------------------------------------------
--      Description:    SizeChanged
-------------------------------------------------------------------------------------
Timer.Options[ Timer.Types.BAR ].SizeChanged = function ()

    Timer.Options[ Timer.Types.BAR ].TimerTabWindow:SetHeight(  Timer.Options[ Timer.Types.BAR ]:GetHeight() )
    
end


-------------------------------------------------------------------------------------
--      Description:    FillContent
-------------------------------------------------------------------------------------
Timer.Options[ Timer.Types.BAR ].FillContent = function ( TimerData, TimerIndex, multiselect )

    Timer.Options[ Timer.Types.BAR ].multiselect = multiselect

    Timer.Options[ Timer.Types.BAR ].TimerTabs.general:FillContent( TimerData, TimerIndex, multiselect )
    Timer.Options[ Timer.Types.BAR ].TimerTabs.trigger:FillContent( TimerData, TimerIndex, multiselect )
    Timer.Options[ Timer.Types.BAR ].TimerTabs.timer:FillContent( TimerData, TimerIndex, multiselect )
    Timer.Options[ Timer.Types.BAR ].TimerTabs.text:FillContent( TimerData, TimerIndex, multiselect )
    Timer.Options[ Timer.Types.BAR ].TimerTabs.animation:FillContent( TimerData, TimerIndex, multiselect )

end


-------------------------------------------------------------------------------------
--      Description:    CheckContent
-------------------------------------------------------------------------------------
Timer.Options[ Timer.Types.BAR ].CheckContent = function ()
    
end


-------------------------------------------------------------------------------------
--      Description:    SaveContent
-------------------------------------------------------------------------------------
Timer.Options[ Timer.Types.BAR ].SaveContent = function ()
    
end