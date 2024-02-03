--=================================================================================================
--= Option Functions
--= ===============================================================================================
--= 
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- selection changed
---------------------------------------------------------------------------------------------------
function Options.SelectionChanged( index )

    -- index = 0: clear selection
    -- index > 0: window selected
    -- index < 0: folder selected
    
    -- do nothing if selection didnt change
    if index == Data.selectedIndex or index == nil then
        return
    end

    -- save new selection
    Data.selectedIndex = index
 
    Options.TimerSelectionChanged( 0 )

    Options.Trigger2SelectionChanged( 0, 0 )

    Windows.SelectionChanged()

    -- if moving then call movewindow
    if Data.moveMode == true then
        Options.Move.Object:SelectionChanged()
    end

    
    -- window
    if Data.options.window.open == true then
        Options.Window.Object:SelectionChanged()
     
    end
    
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- timer selection changed
---------------------------------------------------------------------------------------------------
function Options.TimerSelectionChanged( index )

    -- do nothing if selection didnt change
    if index == Data.selectedTimerIndex or index == nil then
        return
    end

    Data.selectedTimerIndex = index
    
    Options.TriggerSelectionChanged( 0, 0 )

    if Data.options.window.open == true then
        Options.Window.Object:TimerSelectionChanged()
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- trigger selection changed
---------------------------------------------------------------------------------------------------
function Options.TriggerSelectionChanged( index, type )

    -- do nothing if selection didnt change
    if (index == Data.selectedTriggerIndex and type == Data.selectedTriggerType) or index == nil  then
        return
    end

    Data.selectedTriggerIndex = index
    Data.selectedTriggerType  = type

    if Data.options.window.open == true then
        Options.Window.Object:TriggerSelectionChanged()
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- trigger selection changed
---------------------------------------------------------------------------------------------------
function Options.Trigger2SelectionChanged( index, type )

    -- do nothing if selection didnt change
    if (index == Data.selectedTriggerIndex2 and type == Data.selectedTriggerType2) or index == nil  then
        return
    end

    Data.selectedTriggerIndex2 = index
    Data.selectedTriggerType2  = type

    if Data.options.window.open == true then
        Options.Window.Object:Trigger2SelectionChanged()
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- move changed
---------------------------------------------------------------------------------------------------
function Options.MoveChanged( value )

    -- do nothing if move didnt change
    if value == nil then
        return
    end

    -- save new selection
    Data.moveMode = value

    -- change movestate of windows
    Windows.MoveChanged()

    -- create or close move window
    Options.MoveWindow()

    -- shortcut
    Options.Shortcut.Object:MoveChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- auto reload changed
---------------------------------------------------------------------------------------------------
function Options.AutoReloadChanged()

    Data.autoReload = not( Data.autoReload )

    -- shortcut
    Options.Shortcut.Object:AutoReloadChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- track target changed
---------------------------------------------------------------------------------------------------
function Options.TrackTargetChanged()

    Data.trackTargetEffects = not( Data.trackTargetEffects )

    -- shortcut
    Options.Shortcut.Object:TrackTargetChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- track group changed
---------------------------------------------------------------------------------------------------
function Options.TrackGroupChanged()

    Data.trackGroupEffects = not( Data.trackGroupEffects )

    -- shortcut
    Options.Shortcut.Object:TrackGroupChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- show tooltip changed
---------------------------------------------------------------------------------------------------
function Options.ShowTooltipChanged( value )

    if value == nil then
        value = not( Data.showTooltips )
    end

    Data.showTooltips = value

    -- hide current tooltip
    Options.Elements.TooltipObject:Hide()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- language changed
---------------------------------------------------------------------------------------------------
function Options.LanguageChanged( value )

    -- do nothing if move didnt change
    if value == Data.options.language or value == nil then
        return
    end

    Data.options.language = value

    -- move
    if Data.moveMode == true then
        Options.Move.Object:LanguageChanged()
     
    end

    -- window
    if Data.options.window.open == true then
        Options.Window.Object:LanguageChanged()
     
    end

    -- shortcut
    Options.Shortcut.Object:LanguageChanged()
     
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- move changed
---------------------------------------------------------------------------------------------------
function Options.MoveWindow()

    if Data.moveMode == true and Options.Move.Object == nil then

        Options.Move.Object = Options.Move.Constructor()
        
    elseif Options.Move.Object ~= nil then

        Options.Move.Object:Close()
        Options.Move.Object = nil

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- move changed
---------------------------------------------------------------------------------------------------
function Options.OptionsWindow( value )

    -- either use value or change the current value
    if value == nil then
        Data.options.window.open = not( Data.options.window.open )

    else
        Data.options.window.open = value

    end

    -- open/close window
    if Data.options.window.open == true then
        Options.Window.Object = Options.Window.Constructor()
        
    elseif Options.Window.Object ~= nil then
        Options.Window.Object:Close()
        Options.Window.Object = nil

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- move changed
---------------------------------------------------------------------------------------------------
function Options.SelectionMoved()

    if Data.moveMode == true then

        Options.Move.Object:SelectionChanged()
     
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- move window in options
---------------------------------------------------------------------------------------------------
function Options.MoveTo( fromData, toData )

    local fromSortIndex = fromData.sortIndex
    local toSortIndex = toData.sortIndex
    if toSortIndex > fromSortIndex then
        toSortIndex = toSortIndex + 1
    end


    for index, group in ipairs( Data.window ) do
        
        if group.sortIndex >= toSortIndex then
            group.sortIndex = group.sortIndex + 1
        end

    end

    for index, folder in ipairs( Data.folder ) do
        
        if folder.sortIndex >= toSortIndex then
            folder.sortIndex = folder.sortIndex + 1
        end

    end

    Data.lastSortIndex = Data.lastSortIndex + 1

    fromData.sortIndex = toSortIndex
    fromData.folder = toData.folder
 
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- delete window
---------------------------------------------------------------------------------------------------
function Options.DeleteWindow( windowIndex )

    Windows.UnloadWindow( windowIndex )
    Window.Delete( windowIndex )

    if Data.selectedIndex == windowIndex then
        Options.SelectionChanged( 0 )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- delete folder
---------------------------------------------------------------------------------------------------
function Options.DeleteFolder( folderIndex )

    Folder.Delete( folderIndex )

    if Data.selectedIndex == (folderIndex*(-1)) then
        Options.SelectionChanged( 0 )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- delete timer
---------------------------------------------------------------------------------------------------
function Options.DeleteTimer( data, timerIndex )

    Timer.Delete( data, timerIndex )

    if Data.selectedTimerIndex == (timerIndex) then
        Options.TimerSelectionChanged( 0 )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- delete trigger
---------------------------------------------------------------------------------------------------
function Options.DeleteTrigger( data, triggerIndex, triggerType )

    Trigger.Delete( data, triggerIndex, triggerType )

    if Data.selectedTriggerIndex == (triggerIndex) and Data.selectedTriggerType == triggerType then
        Options.TriggerSelectionChanged( 0, 0 )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- delete folder/window trigger
---------------------------------------------------------------------------------------------------
function Options.DeleteTrigger2( data, triggerIndex, triggerType )

    Trigger.Delete( data, triggerIndex, triggerType )

    if Data.selectedTriggerIndex2 == (triggerIndex) and Data.selectedTriggerType2 == triggerType then
        Options.Trigger2SelectionChanged( 0, 0 )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Data changed
---------------------------------------------------------------------------------------------------
function Options.DataChanged( index )

    if Data.options.window.open == true then
        Options.Window.Object:DataChanged( index )
    end

    Windows.DataChanged( index )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Effect Collection Changed
---------------------------------------------------------------------------------------------------
function Options.EffectCollectionChanged()

    if Data.options.window.open == true then
        Options.Window.Object:EffectCollectionChanged()
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Chat Collection Changed
---------------------------------------------------------------------------------------------------
function Options.ChatCollectionChanged()

    if Data.options.window.open == true then
        Options.Window.Object:ChatCollectionChanged()
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Chat Collection Changed
---------------------------------------------------------------------------------------------------
function Options.KeepInCollection( data, type )

    local list

    if type == 1 then
        list = Data.persistent_collection.skill

    elseif type == 2 then
        list = Data.persistent_collection.effects

    elseif type == 3 then
        list = Data.persistent_collection.chat

    else
        return
    end

    local index = #list + 1
    list[ index ] = {}
    list[ index ].token = data.token
    list[ index ].source = data.source
    list[ index ].icon = data.icon
    list[ index ].timer = data.timer
    list[ index ].persistent = true

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Chat Collection Changed
---------------------------------------------------------------------------------------------------
function Options.CheckForIndexInCollection( data, type )

    local list

    if type == 1 then
        list = Data.persistent_collection.skill

    elseif type == 2 then
        list = Data.persistent_collection.effects

    elseif type == 3 then
        list = Data.persistent_collection.chat

    else
        return
    end

    for index, item in ipairs(list) do
        if item.token == data.token then
            return  index , list
        end
    end

    return nil

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Chat Collection Changed
---------------------------------------------------------------------------------------------------
function Options.RemoveFromCollection( index, list )

    local loopEnd = #list -1
    for i = index, loopEnd do
        list[i] = list[i+1]
    end

    list[#list] = nil

end
---------------------------------------------------------------------------------------------------
