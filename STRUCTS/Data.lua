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

    Data.options = {}   -- list of options data

    Data.lastSortIndex = 0

    Data.selectedGroupIndex = {}
    Data.selectedFolderIndex = {}
    Data.selectedTimerIndex = {}
    Data.selectedTriggerIndex = {}

    Data.moveMode = false
    Data.showTooltips = true

    Data.trackGroupEffects = true
    Data.trackTargetEffects = false

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

    if #Options.CopyCache.content.groups +  #Options.CopyCache.content.folder == 0 then
        return
    end

    local folder_list = {}
    for i, folder in ipairs(Options.CopyCache.content.folder) do
        folder_list[#folder_list+1] = Folder.New(Data.folder[folder].name)
    end

    local group_list = {}
    for j, group in ipairs(Options.CopyCache.content.groups) do
        group_list[#group_list+1] = Group.New(Data.group[group].name, Data.group[group].type)
    end

    local targetData = nil

    if #Data.selectedGroupIndex == 0 then
        targetData = Data.folder[ Data.selectedFolderIndex[1] ]
    else
        targetData = Data.group[ Data.selectedGroupIndex[1] ]
    end

    for i, index in ipairs(group_list) do
        Data.group[index].folder = targetData.folder
        Data.SortTo( Data.group[index], targetData )
    end

    for j, index in ipairs(folder_list) do

        Data.folder[index].folder = targetData.folder
        Data.SortTo( Data.folder[index], targetData )
        
    end

end

-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Data.CutCache()

end