--===================================================================================
--             Name:    LISTBOX OPTIONS Timer TriggerTabs
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================


TimerTriggerTab = class(  Options.Constructor.Tab )

-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS Timer TABWINDOW
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
-------------------------------------------------------------------------------------
--           Return:    Timer listbox element
-------------------------------------------------------------------------------------
function TimerTriggerTab:Constructor( width, name, tabwindow )
	Options.Constructor.Tab.Constructor( self )

    self:SetWidth( width )
    self:SetName( name )
    self:SetTabWindow( tabwindow )

    -------------------------------------------------------------------------------------
    --      Description:    TIMER SELECTION
    -------------------------------------------------------------------------------------
    self.triggerSelection = Options.Constructor.ListControl()
    self.triggerSelection:SetParent(self)
    self.triggerSelection:SetWidth(200)
    self.triggerSelection:SetPosition( -2, 35)

end




function TimerTriggerTab:SizeChanged()

    local width, height = self:GetSize()

    height = height - 35

    self.triggerSelection:SetHeight(height + 2)

end


-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS GROUP TABWINDOW
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function TimerTriggerTab:FillContent( selectedItem )

    self.triggerSelection:ClearItems()

    if selectedItem == nil then

    else

        local timerData = selectedItem.data
        

        for i, triggerList in ipairs(timerData) do

            for j, triggerData in ipairs(triggerList) do

                self.triggerSelection:AddItem( Options.Constructor.TriggerControl(triggerData, j, 202, self) )
 
            end
            
        end
        
        self.triggerSelection:ResetSelection()

    end

end


-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS DraggEnd
-------------------------------------------------------------------------------------
--        Parameter:    data
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function TimerTriggerTab:DraggingEnd( fromData )

    local toData = self.triggerSelection:GetItemAtMousePos()

    if toData ~= nil then

        Timer.SortTo( Data.group[ Data.selectedGroupIndex[1] ].timerList[ Data.selectedTimerIndex[1] ], fromData, toData.data )

        self.triggerSelection:Sort()

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
function TimerTriggerTab:SelectionChanged( triggerControl )

    if triggerControl ~= nil then
        Data.selectedTriggerIndex = {}
        Data.selectedTriggerIndex[1] = triggerControl.index
    end

    self.triggerSelection:SelectionChanged( Trigger.IsSelected )

end