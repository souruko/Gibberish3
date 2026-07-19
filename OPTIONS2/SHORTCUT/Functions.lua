--=================================================================================================
--= Option Functions
--= ===============================================================================================
--= shared state used by the shortcut button, move mode, and OPTIONS2
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- stub so ImportDialog's nil-guard and UTILS/Import.lua stay safe
---------------------------------------------------------------------------------------------------
Options.Window = { Object = nil }
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- selection changed
---------------------------------------------------------------------------------------------------
function Options.SelectionChanged( index )

    -- index = 0: clear selection
    -- index > 0: window selected
    -- index < 0: folder selected

    if index == Data.selectedIndex or index == nil then
        return
    end

    Data.selectedIndex = index

    Windows.SelectionChanged()

    if Data.moveMode == true then
        Options.Move.Object:SelectionChanged()
    end

    if index > 0 and Options2.Window.Object ~= nil then
        Options2.Window.Object.nav:SelectWindowByIndex( index )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- timer selection changed
---------------------------------------------------------------------------------------------------
function Options.TimerSelectionChanged( index )

    if (index ~= 1 and index == Data.selectedTimerIndex) or index == nil then
        return
    end

    Data.selectedTimerIndex = index

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
    Options.SaveData()

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
-- language changed
---------------------------------------------------------------------------------------------------
function Options.LanguageChanged( value )

    if value == Data.options.language or value == nil then
        return
    end

    Data.options.language = value

    if Data.moveMode == true then
        Options.Move.Object:LanguageChanged()
    end

    Options.Shortcut.Object:LanguageChanged()

    if Options2.Window.Object ~= nil and Options2.Window.Object.LanguageChanged ~= nil then
        Options2.Window.Object:LanguageChanged()
    end

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
function Options.SelectionMoved()

    if Data.moveMode == true then

        Options.Move.Object:SelectionChanged()

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- delete window
---------------------------------------------------------------------------------------------------
function Options.DeleteWindow( windowIndex )

    local window_count = #Data.window
    Windows.UnloadWindow( windowIndex )
    Window.Delete( windowIndex )

    -- window_count slot is now nil (swap-delete); also clear if deleted slot was selected
    if Data.selectedIndex == windowIndex or Data.selectedIndex == window_count then
        Options.SelectionChanged( 0 )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- delete folder
---------------------------------------------------------------------------------------------------
function Options.DeleteFolder( folderIndex )

    local folder_count = #Data.folder
    Folder.Delete( folderIndex )

    -- folder_count slot is now nil (swap-delete); also clear if deleted slot was selected
    if Data.selectedIndex == (folderIndex*(-1)) or Data.selectedIndex == (folder_count*(-1)) then
        Options.SelectionChanged( 0 )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- delete timer
---------------------------------------------------------------------------------------------------
function Options.DeleteTimer( data, timerIndex )

    Timer.Delete( data, timerIndex )

    -- reset if selected timer was deleted or shifted out from under us
    if Data.selectedTimerIndex >= timerIndex then
        Options.TimerSelectionChanged( 0 )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- condition selection changed
---------------------------------------------------------------------------------------------------
function Options.ConditionsSelectionChanged( index )

    if index == (Data.selectedConditionsIndex or 0) or index == nil then return end
    Data.selectedConditionsIndex = index
    Options.ConditionTriggerSelectionChanged( 0, 0 )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- condition trigger selection changed
---------------------------------------------------------------------------------------------------
function Options.ConditionTriggerSelectionChanged( index, type )

    if (index == (Data.selectedConditionTriggerIndex or 0) and type == (Data.selectedConditionTriggerType or 0)) or index == nil then return end
    Data.selectedConditionTriggerIndex = index
    Data.selectedConditionTriggerType  = type

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- delete condition
---------------------------------------------------------------------------------------------------
function Options.DeleteConditions( timerData, conditionIndex )

    local count = #timerData.conditionList
    for i = conditionIndex, count - 1 do
        timerData.conditionList[i] = timerData.conditionList[i + 1]
    end
    timerData.conditionList[count] = nil

    if Data.selectedConditionsIndex >= conditionIndex then
        Options.ConditionsSelectionChanged( 0 )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Data changed
---------------------------------------------------------------------------------------------------
function Options.DataChanged( index )

    Windows.DataChanged( index )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Effect Collection Changed
---------------------------------------------------------------------------------------------------
function Options.EffectCollectionChanged()

    Options2.EffectCollectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Chat Collection Changed
---------------------------------------------------------------------------------------------------
function Options.ChatCollectionChanged()

    Options2.ChatCollectionChanged()

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
    list[ index ].token      = data.token
    list[ index ].source     = data.source
    list[ index ].originType = data.originType
    list[ index ].icon       = data.icon
    list[ index ].timer      = data.timer
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
