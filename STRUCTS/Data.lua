--===================================================================================
--             Name:    Data
-------------------------------------------------------------------------------------
--      Description:    Data structure and functions
--===================================================================================


-------------------------------------------------------------------------------------
--      Description:    Set base data structure       
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Data.New()

    Data.group  = {}   -- list of group data
    Data.group.lastID = 0

    Data.folder  = {}   -- list of folder data
    Data.folder.lastID = 0

    Data.lastSortIndex = 0

    Data.selectedGroupIndex = {}
    Data.selectedFolderIndex = {}
    Data.selectedTimerIndex = {}
    Data.selectedTriggerIndex = {}

    Data.moveMode = false
    Data.showTooltips = true

    Data.trackGroupEffects = true
    Data.trackTargetEffects = false

    Data.options = {}   -- list of options data
    Data.options.tab1 = 1
    Data.options.tab2 = 1

    Data.options.shortcut = {}
    Data.options.window = {}
    Data.options.collection = {}

    Data.options.shortcut.left = 0.2
    Data.options.shortcut.top  = 0.2
    Data.options.window.left  = 0
    Data.options.window.top  = 0
    Data.options.collection.left  = 0.2
    Data.options.collection.top  = 0.2

    Data.options.shortcut.moveable = true

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Data.GetNextSortIndex()

    Data.lastSortIndex = Data.lastSortIndex + 1
    return Data.lastSortIndex

end



-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    fromData, toData
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Data.SortTo(fromData, toData)

    local fromSortIndex = fromData.sortIndex
    local toSortIndex = toData.sortIndex

    if fromSortIndex > toSortIndex then

        for key, group in ipairs(Data.group) do

            if group.sortIndex >= toSortIndex and group.sortIndex <= fromSortIndex then

                group.sortIndex = group.sortIndex + 1

            end
    
        end

        for key, folder in ipairs(Data.folder) do

            if folder.sortIndex >= toSortIndex and folder.sortIndex <= fromSortIndex then

                folder.sortIndex = folder.sortIndex + 1

            end
    
        end

    else

        for key, group in ipairs(Data.group) do

            if group.sortIndex <= toSortIndex and group.sortIndex >= fromSortIndex then

                group.sortIndex = group.sortIndex - 1

            end
    
        end

        for key, folder in ipairs(Data.folder) do

            if folder.sortIndex <= toSortIndex and folder.sortIndex >= fromSortIndex then

                folder.sortIndex = folder.sortIndex - 1

            end
    
        end
      
    end

    fromData.sortIndex = toSortIndex

end

-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:   
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Data.CopyCache()


end

-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Data.CutCache()

    local targetData = nil

    if #Data.selectedGroupIndex == 0 then
        targetData = Data.folder[ Data.selectedFolderIndex[1] ]
    else
        targetData = Data.group[ Data.selectedGroupIndex[1] ]
    end

    for i, index in ipairs(Options.CopyCache.content.folder) do
        Data.folder[index].folder = targetData.folder
        Data.SortTo( Data.folder[index], targetData )
    end

    for j, index in ipairs(Options.CopyCache.content.groups) do
        Data.group[index].folder = targetData.folder
        Data.SortTo( Data.group[index], targetData )
    end

end