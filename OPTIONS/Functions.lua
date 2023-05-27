--===================================================================================
--             Name:    OPTIONS  Functions
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================





-------------------------------------------------------------------------------------
--      Description:    listbox constructor
-------------------------------------------------------------------------------------
--        Parameter:    group data 
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function Options.SelectionChanged()

    if Options.MainWindow.Window ~= nil then
    
        Options.MainWindow.Window:SelectionChanged()

    end

    Group.SelectionChanged()

end

-------------------------------------------------------------------------------------
--      Description:    listbox constructor
-------------------------------------------------------------------------------------
--        Parameter:    group data 
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function Options.ResetContent()

    if Options.MainWindow.Window ~= nil then
    
        Options.MainWindow.Window:ResetContent()

    end

end

-------------------------------------------------------------------------------------
--      Description:    listbox constructor
-------------------------------------------------------------------------------------
--        Parameter:    group data 
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function Options.AddToGroupSelection( groupIndex )

    for i = #Data.selectedGroupIndex, 1, -1 do

        Data.selectedGroupIndex[i + 1] = Data.selectedGroupIndex[i]

    end

    Data.selectedGroupIndex[1] = groupIndex

end

-------------------------------------------------------------------------------------
--      Description:    listbox constructor
-------------------------------------------------------------------------------------
--        Parameter:    group data 
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function Options.AddToFolderSelection( folderIndex )

    for i = #Data.selectedFolderIndex, 1, -1 do

        Data.selectedFolderIndex[i + 1] = Data.selectedFolderIndex[i]

    end

    Data.selectedFolderIndex[1] = folderIndex

end

-------------------------------------------------------------------------------------
--      Description:    listbox constructor
-------------------------------------------------------------------------------------
--        Parameter:    group data 
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function Options.AddToFolderSelection( folderIndex )

    for i = #Data.selectedFolderIndex, 1, -1 do

        Data.selectedFolderIndex[i + 1] = Data.selectedFolderIndex[i]

    end

    Data.selectedFolderIndex[1] = folderIndex

end

-------------------------------------------------------------------------------------
--      Description:    hide tooltip
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Options.Copy( itemType )

    Options.CopyCache.actionType    = Options.CopyCache.ActionTypes.Copy
    Options.CopyCache.itemType      = itemType

    if itemType == Options.CopyCache.ItemTypes.FolderAndGroup then
        Options.CopyCache.content = {}
        Options.CopyCache.content.groups = Data.selectedGroupIndex
        Options.CopyCache.content.folder = Data.selectedFolderIndex

    elseif itemType == Options.CopyCache.ItemTypes.Timer then
        Options.CopyCache.content = Data.selectedTimerIndex

    elseif itemType == Options.CopyCache.ItemTypes.Trigger then
        Options.CopyCache.content = Data.selectedTriggerIndex

    end

end

-------------------------------------------------------------------------------------
--      Description:    hide tooltip
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Options.Cut( itemType )

    Options.CopyCache.actionType    = Options.CopyCache.ActionTypes.Cut
    Options.CopyCache.itemType      = itemType

    if itemType == Options.CopyCache.ItemTypes.FolderAndGroup then
        Options.CopyCache.content = {}
        Options.CopyCache.content.groups = Data.selectedGroupIndex
        Options.CopyCache.content.folder = Data.selectedFolderIndex

    elseif itemType == Options.CopyCache.ItemTypes.Timer then
        Options.CopyCache.content = Data.selectedTimerIndex

    elseif itemType == Options.CopyCache.ItemTypes.Trigger then
        Options.CopyCache.content = Data.selectedTriggerIndex

    end

end


-------------------------------------------------------------------------------------
--      Description:    hide tooltip
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Options.Paste( targetType )

    if Options.CopyCache.itemType ~= nil and targetType == Options.CopyCache.itemType then


        if targetType == Options.CopyCache.ItemTypes.FolderAndGroup then

            Data.CopyCache()

            if Options.CopyCache.actionType == Options.CopyCache.ActionTypes.Cut then
                Data.CutCache()
                -- change cut to copy after first paste 
                Options.CopyCache.actionType    = Options.CopyCache.ActionTypes.Copy
            end

        elseif targetType == Options.CopyCache.ItemTypes.Timer then

            Group.CopyCache()

            if Options.CopyCache.actionType == Options.CopyCache.ActionTypes.Cut then
                Group.CutCache()
                -- change cut to copy after first paste 
                Options.CopyCache.actionType    = Options.CopyCache.ActionTypes.Copy
            end

        elseif targetType == Options.CopyCache.ItemTypes.Trigger then


            Timer.CopyCache()

            if Options.CopyCache.actionType == Options.CopyCache.ActionTypes.Cut then
                Timer.CutCache() 
                -- change cut to copy after first paste 
                Options.CopyCache.actionType    = Options.CopyCache.ActionTypes.Copy
            end

        end

        Options.ResetContent()
        Options.SelectionChanged()
 
    end

end
