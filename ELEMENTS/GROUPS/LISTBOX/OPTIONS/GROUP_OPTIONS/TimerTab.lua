--===================================================================================
--             Name:    LISTBOX OPTIONS Group TimerTabs
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================


GroupTimerTab = class(  Options.Constructor.Tab )

-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS GROUP TABWINDOW
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function GroupTimerTab:Constructor( width, name, tabwindow )
	Options.Constructor.Tab.Constructor( self )

    self.selectedTimer = nil

    self:SetWidth( width )
    self:SetName( name )
    self:SetTabWindow( tabwindow )


    -------------------------------------------------------------------------------------
    --      Description:    TIMER SELECTION
    -------------------------------------------------------------------------------------
    self.timerSelection = Options.Constructor.ListControl()
    self.timerSelection:SetParent(self)
    self.timerSelection:SetWidth(202)
    self.timerSelection:SetPosition( -2, 35)

    -------------------------------------------------------------------------------------
    --      Description:    TIMER TABS
    -------------------------------------------------------------------------------------
    self.timerTabWindow = Options.Constructor.TabWindow(self, width - 200, 101  )
    self.timerTabWindow:SetPosition( 200, 35)

    self.timerTabs = {}
    self.timerTabs.general = OPTIONS.TIMER_OPTIONS.TimerGeneralTab( width, L[Language.Local].Tab.General, self.timerTabWindow )
    self.timerTabs.trigger = OPTIONS.TIMER_OPTIONS.TimerTriggerTab( width, L[Language.Local].Tab.Trigger, self.timerTabWindow )
    self.timerTabs.timer = OPTIONS.TIMER_OPTIONS.TimerTimerTab( width, L[Language.Local].Tab.Timer, self.timerTabWindow )
    self.timerTabs.text = OPTIONS.TIMER_OPTIONS.TimerTextTab( width, L[Language.Local].Tab.Text, self.timerTabWindow )
    self.timerTabs.animation = OPTIONS.TIMER_OPTIONS.TimerAnimationTab( width, L[Language.Local].Tab.Animation, self.timerTabWindow )

    self.timerTabWindow:AddTab( self.timerTabs.general )
    self.timerTabWindow:AddTab( self.timerTabs.trigger )
    self.timerTabWindow:AddTab( self.timerTabs.timer )
    self.timerTabWindow:AddTab( self.timerTabs.text )
    self.timerTabWindow:AddTab( self.timerTabs.animation )

end

function GroupTimerTab:SizeChanged()

    local width, height = self:GetSize()

    height = height - 35

    self.timerSelection:SetHeight(height + 2)

    self.timerTabWindow:SetSize(width, height)
    
end



-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS FillContent
-------------------------------------------------------------------------------------
--        Parameter:    data
--                      index
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function GroupTimerTab:FillContent( groupData, groupIndex )

    self.timerSelection:ClearItems()
    if groupData ~= nil then
        for index, timerData in ipairs(groupData.timerList) do
            self.timerSelection:AddItem( Options.Constructor.TimerControl(timerData, index, 202, self) )
        end
    end

    self.timerSelection:ResetSelection()

end


-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS DraggEnd
-------------------------------------------------------------------------------------
--        Parameter:    data
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function GroupTimerTab:DraggingEnd( fromData )

    local toData = self.timerSelection:GetItemAtMousePos()

    if toData ~= nil then
        Group.SortTo( Data.group[ Data.selectedGroupIndex[1] ], fromData, toData.data )

        self.timerSelection:Sort()
    end
    
end



-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS SelectionChanged
-------------------------------------------------------------------------------------
--        Parameter:    data
--                      index
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function GroupTimerTab:SelectionChanged( timerControl )

    if timerControl ~= nil then
        Data.selectedTimerIndex = {}
        Data.selectedTimerIndex[1] = timerControl.index
    end

    self.timerSelection:SelectionChanged( Timer.IsSelected )

    self.timerTabs.trigger:FillContent(timerControl)

end
