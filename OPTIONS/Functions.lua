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
--      Description:    
-------------------------------------------------------------------------------------
function Options.AddToGroupSelection( groupIndex )

    for i = #Data.selectedGroupIndex, 1, -1 do

        Data.selectedGroupIndex[i + 1] = Data.selectedGroupIndex[i]

    end

    Data.selectedGroupIndex[1] = groupIndex

end

-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
function Options.AddToFolderSelection( folderIndex )

    for i = #Data.selectedFolderIndex, 1, -1 do

        Data.selectedFolderIndex[i + 1] = Data.selectedFolderIndex[i]

    end

    Data.selectedFolderIndex[1] = folderIndex

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
function Options.RemoveFromGroupSelection( index )

    if #Data.selectedGroupIndex == 1 then

            Data.selectedGroupIndex = {}
            return
        
    end

    local pos = nil

    for i, selection in ipairs(Data.selectedGroupIndex) do

        if selection == index then
            pos = i
        end

    end

    if pos ~= nil then
       
        for i=pos + 1, #Data.selectedGroupIndex do
            
            Data.selectedGroupIndex[i - 1] = Data.selectedGroupIndex[i] 

        end

        Data.selectedGroupIndex[#Data.selectedGroupIndex] = nil

    end

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Options.RemoveFromFolderSelection( index )

    if #Data.selectedFolderIndex == 1 then

            Data.selectedFolderIndex = {}
            return
        
    end

    local pos = nil

    for i, selection in ipairs(Data.selectedFolderIndex) do

        if selection == index then
            pos = i
        end

    end

    if pos ~= nil then
    
        for i=pos + 1, #Data.selectedFolderIndex do
            
            Data.selectedFolderIndex[i - 1] = Data.selectedFolderIndex[i] 

        end

        Data.selectedFolderIndex[#Data.selectedFolderIndex] = nil

    end

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

    if targetType ~= Options.CopyCache.itemType or targetType == nil then
        return
    end

    if targetType == Options.CopyCache.ItemTypes.FolderAndGroup then

        if Options.CopyCache.actionType == Options.CopyCache.ActionTypes.Cut then
            Data.CutCache()
            Options.CopyCache.actionType    = Options.CopyCache.ActionTypes.Copy

        elseif Options.CopyCache.actionType == Options.CopyCache.ActionTypes.Copy then
            Data.CopyCache()

        end
        
    end
    Options.ResetContent()

end



-------------------------------------------------------------------------------------
--      Description:    delete from Data.group
--                      fix index for all data groups
--                      delete activ group
--                      fix index for all activ groups
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Options.Delete( itemType )

    if itemType == Options.CopyCache.ItemTypes.FolderAndGroup then

        Folder.Delete(Data.selectedFolderIndex)
        Group.Delete(Data.selectedGroupIndex)

        Data.selectedGroupIndex = {}
        Data.selectedFolderIndex = {}
        Options.ResetContent()

    elseif itemType == Options.CopyCache.ItemTypes.Timer then

    elseif itemType == Options.CopyCache.ItemTypes.Trigger then

    end

end