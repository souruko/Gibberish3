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
    self.timerSelection = Options.Constructor.ListControl(function ()
        
        local group = Data.group[ Data.selectedGroupIndex[1] ]
        local index = Group.AddTimer(group, group.timerType)
        self.timerSelection:AddItem( Options.Constructor.TimerControl(group.timerList[index], index, 202, self) )

        Data.selectedTimerIndex = {}
        Data.selectedTimerIndex.timerIndex = index
        Data.selectedTimerIndex.groupIndex = Data.selectedGroupIndex[1]

        self:SelectionChanged(group.timerList[index], index, false)

    end)

    self.timerSelection:SetParent(self)
    self.timerSelection:SetWidth(202)
    self.timerSelection:SetPosition( -2, 35)


end

function GroupTimerTab:SizeChanged()

    local width, height = self:GetSize()

    height = height - 35

    self.timerSelection:SetHeight(height + 2)


    if self.timerOptions ~= nil then
        self.timerOptions:SetSize(width, height)
    end
end



-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS FillContent
-------------------------------------------------------------------------------------
--        Parameter:    data
--                      index
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function GroupTimerTab:FillContent( groupData, groupIndex, multiselect )

    self.timerSelection:ClearItems()
    
    if multiselect == true then
    
    else
        
        if groupData ~= nil then
            for index, timerData in ipairs(groupData.timerList) do
                self.timerSelection:AddItem( Options.Constructor.TimerControl(timerData, index, 202, self) )
            end
        end

        self.timerSelection:ResetSelection()
    
    end

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
function GroupTimerTab:SelectionChanged( timerData, timerIndex, add_to_selection )

    if add_to_selection == true then

        if timerData ~= nil then

            for i = #Data.selectedTimerIndex, 1, -1 do

                Data.selectedTimerIndex[i + 1] = Data.selectedTimerIndex[i]
        
            end
        
            Data.selectedTimerIndex[1] = {}
            Data.selectedTimerIndex[1].groupIndex = Data.selectedGroupIndex[1]
            Data.selectedTimerIndex[1].timerIndex = timerIndex
        end
        
    else

        Data.selectedTimerIndex = {}
        if timerData ~= nil then
            Data.selectedTimerIndex[1] = {}
            Data.selectedTimerIndex[1].groupIndex = Data.selectedGroupIndex[1]
            Data.selectedTimerIndex[1].timerIndex = timerIndex
        end

    end
    
    self.timerSelection:SelectionChanged( Timer.IsSelected )

    
    if self.currentDisplay ~= nil then
        self.currentDisplay:SetParent(nil)
    end
    if timerData ~= nil then
        self.timerOptions = Timer.Options[ timerData.type ]
        self.timerOptions:SetPosition(200, 35)
        self.timerOptions:SetHeight( self.timerSelection:GetHeight() )
        self.timerOptions.FillContent( timerData, timerIndex, add_to_selection )
        self.timerOptions:SetParent(self)
    end

end
