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
