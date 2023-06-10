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
    --      right click
    self.rightClickMenu = Options.Constructor.RightClickMenu(125)
    
    for type, text in ipairs(L[Language.Local].Terms.TriggerType) do

        self.rightClickMenu:AddRow( text, function ()
            self:AddNewTrigger(type)
        end)
        
    end

    
    -------------------------------------------------------------------------------------
    --      Description:    TIMER SELECTION
    -------------------------------------------------------------------------------------
    self.triggerSelection = Options.Constructor.ListControl(function ()
        Turbine.Shell.WriteLine("d")
        self.rightClickMenu:Show(nil, nil, true)

    end)
    self.triggerSelection:SetParent(self)
    self.triggerSelection:SetWidth(200)
    self.triggerSelection:SetPosition( -2, 35)

end




function TimerTriggerTab:SizeChanged()

    local width, height = self:GetSize()

    height = height - 35

    self.triggerSelection:SetHeight(height + 2)
    if self.triggerOptions ~= nil then
        self.triggerOptions:SetHeight( self.triggerSelection:GetHeight() )
    end

end


-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS GROUP TABWINDOW
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function TimerTriggerTab:FillContent( timerData, timerIndex, multiselect )

    self.triggerSelection:ClearItems()

    if timerData == nil then

    else

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
function TimerTriggerTab:AddNewTrigger( type )

    local group = Data.group[ Data.selectedGroupIndex[1] ]
    local timer = group.timerList[ Data.selectedTimerIndex[1].timerIndex ]
    local index = Timer.AddTrigger(timer, type)
    self.triggerSelection:AddItem( Options.Constructor.TriggerControl(timer[type][index], index, 202, self) )

    Data.selectedTriggerIndex = {}
    Data.selectedTriggerIndex.groupIndex = Data.selectedGroupIndex[1]
    Data.selectedTriggerIndex.timerIndex = Data.selectedTimerIndex[1].timerIndex
    Data.selectedTriggerIndex.triggerIndex = index

    self:SelectionChanged(timer[type][index], index, false)

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

        Timer.SortTo( Data.group[ Data.selectedGroupIndex[1] ].timerList[ Data.selectedTimerIndex[1].timerIndex ], fromData, toData.data )

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
function TimerTriggerTab:SelectionChanged( triggerData, triggerIndex, add_to_selection )

    if add_to_selection == true then

        if triggerData ~= nil then


            for i = #Data.selectedTriggerIndex, 1, -1 do

                Data.selectedTriggerIndex[i + 1] = Data.selectedTriggerIndex[i]
        
            end
        
            Data.selectedTriggerIndex[1] = {}
            Data.selectedTriggerIndex[1].groupIndex = Data.selectedGroupIndex[1]
            Data.selectedTriggerIndex[1].timerIndex = Data.selectedTimerIndex[1].timerIndex
            Data.selectedTriggerIndex[1].triggerIndex = triggerIndex

        end
        
    else

        Data.selectedTriggerIndex = {}
        if triggerData ~= nil then
            Data.selectedTriggerIndex[1] = {}
            Data.selectedTriggerIndex[1].groupIndex = Data.selectedGroupIndex[1]
            Data.selectedTriggerIndex[1].timerIndex = Data.selectedTimerIndex[1].timerIndex
            Data.selectedTriggerIndex[1].triggerIndex = triggerIndex
        end

    end

    self.triggerSelection:SelectionChanged( Trigger.IsSelected )

    if self.triggerOptions ~= nil then
        self.triggerOptions:SetParent(nil)
        self.triggerOptions:Finish()
    end
    if triggerData ~= nil then

        self.triggerOptions = Trigger.Options[ triggerData.type ]()
        self.triggerOptions:SetPosition(200, 35)
        self.triggerOptions:SetHeight( self.triggerSelection:GetHeight() )
        self.triggerOptions:FillContent( triggerData, triggerIndex, add_to_selection )
        self.triggerOptions:SetParent(self)
    end

end