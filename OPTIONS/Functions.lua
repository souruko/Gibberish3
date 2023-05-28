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

            if Options.CopyCache.actionType == Options.CopyCache.ActionTypes.Cut then
                Data.CutCache()
                -- change cut to copy after first paste 
                Options.CopyCache.actionType    = Options.CopyCache.ActionTypes.Copy

            else
                
                Data.CopyCache()

            end

        elseif targetType == Options.CopyCache.ItemTypes.Timer then

            if Options.CopyCache.actionType == Options.CopyCache.ActionTypes.Cut then
                Group.CutCache()
                -- change cut to copy after first paste 
                Options.CopyCache.actionType    = Options.CopyCache.ActionTypes.Copy

            else
                
                Group.CopyCache()

            end

        elseif targetType == Options.CopyCache.ItemTypes.Trigger then

            if Options.CopyCache.actionType == Options.CopyCache.ActionTypes.Cut then
                Timer.CutCache() 
                -- change cut to copy after first paste 
                Options.CopyCache.actionType    = Options.CopyCache.ActionTypes.Copy

            else
                
                Timer.CopyCache()

            end

        end

        Options.ResetContent()
        Options.SelectionChanged()
 
    end

end


-------------------------------------------------------------------------------------
--      Description:    listbox constructor
-------------------------------------------------------------------------------------
--        Parameter:    group data 
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function Options.MoveToFolder( folderIndex )

    for index, groupData in ipairs(Data.selectedGroupIndex) do

        Data.group[ groupData ].folder = folderIndex
        
    end

    for index, folderData in ipairs(Data.selectedFolderIndex) do

        if index ~= folderIndex then
            
            Data.folder[ folderData ].folder = folderIndex

        end
        
    end

    Options.ResetContent()

end



-------------------------------------------------------------------------------------
--      Description:    listbox constructor
-------------------------------------------------------------------------------------
--        Parameter:    group data 
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function Options.Delete()

    for index, folderIndex in ipairs(Data.selectedFolderIndex) do

        Folder.Delete(folderIndex)

    end

    for index, groupIndex in ipairs(Data.selectedGroupIndex) do

        Group.Delete(groupIndex)
        
    end

    Data.selectedGroupIndex = {}
    Data.selectedFolderIndex = {}
    Options.ResetContent()

end