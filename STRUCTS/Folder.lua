
--===================================================================================
--             Name:    STRUCTS - Folder
-------------------------------------------------------------------------------------
--      Description:    Folder structure and functions
--===================================================================================




-------------------------------------------------------------------------------------
--      Description:   return the base structure for creating a new folder 
-------------------------------------------------------------------------------------
--        Parameter:       
-------------------------------------------------------------------------------------
--           Return:   folder struct 
-------------------------------------------------------------------------------------
function Folder.GetStruct()

    local folder = {}

    folder.id = Folder.GetlastID()
    folder.sortIndex             = Data.GetNextSortIndex()
    folder.name = ""
    folder.enabled = false
    folder.collapsed = false
    folder.folder = nil

    folder[Trigger.Types.EffectSelf]     = {}
    folder[Trigger.Types.EffectGroup]    = {}
    folder[Trigger.Types.EffectTarget]   = {}
    folder[Trigger.Types.Skill]          = {}
    folder[Trigger.Types.Chat]           = {}
    folder[Trigger.Types.TimerEnd]       = {}
    folder[Trigger.Types.TimerStart]     = {}
    folder[Trigger.Types.TimerThreshold] = {}

    return folder

end


-------------------------------------------------------------------------------------
--      Description:    create nur folderdata and returns id
-------------------------------------------------------------------------------------
--        Parameter:    name    - folder name
-------------------------------------------------------------------------------------
--           Return:    index   - index of the new folder
-------------------------------------------------------------------------------------
function Folder.New(name)

    local index = #Data.folder + 1

    Data.folder[index] = Folder.GetStruct()
    Data.folder[index].name = name

    return index

end


-------------------------------------------------------------------------------------
--      Description:    create nur folderdata and returns id
-------------------------------------------------------------------------------------
--        Parameter:    name    - folder name
-------------------------------------------------------------------------------------
--           Return:    index   - index of the new folder
-------------------------------------------------------------------------------------
function Folder.GetFolderLevel(folderData)

    local level = 0

    if folderData == nil then
        return level
    end

    while folderData.folder ~= nil do

        level = level + 1
        folderData = Data.folder[folderData.folder]
       
    end

    return level

end



-------------------------------------------------------------------------------------
--      Description:     
-------------------------------------------------------------------------------------
function Folder.DeleteByIndex(folderIndex)

    local listOfGroups = {}

    -- collect groups to be deleted
    for i, groupData in ipairs(Data.group) do

        if groupData.folder == folderIndex then
            listOfGroups[#listOfGroups+1] = i
        end
        
    end

    -- delete folders within the folder
    for i, folderData in ipairs(Data.folder) do

        if folderData.folder == folderIndex then
            Data.folder[i] = nil
            Folder.DeleteByIndex(i)
        end

    end

    -- delete all groups that were part of the folders
    Group.Delete(listOfGroups)

    Data.folder[folderIndex] = nil

end

-------------------------------------------------------------------------------------
--      Description:     
-------------------------------------------------------------------------------------
function Folder.Delete(list)

    local folderMaxCount = #Data.folder

    for listIndex, folderIndex in ipairs(list) do

        if Data.folder[folderIndex] ~= nil then

           Folder.DeleteByIndex(folderIndex)

        end

    end


    -- the distance the folderindex will  be moved
    local distance = 0

    -- resort Data.folder
    for i=1, folderMaxCount do

        if Data.folder[i] == nil then
            distance = distance + 1
        else
            Data.folder[i - distance] = Data.folder[i]
        end

    end

    for i=folderMaxCount, (folderMaxCount-distance+1), -1 do
        
        Data.folder[i] = nil

    end


end


-------------------------------------------------------------------------------------
--      Description:    return next folder id and add up 
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    next folder id
-------------------------------------------------------------------------------------
function Folder.GetlastID()

    Data.folder.lastID = Data.folder.lastID + 1

    return Data.folder.lastID

end


-------------------------------------------------------------------------------------
--      Description:    return next folder id and add up 
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    next folder id
-------------------------------------------------------------------------------------
function Folder.CollapsAll()

    for index, folder in ipairs(Data.folder) do

        folder.collapsed = true
        
    end

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    fromData, toData
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Folder.IsSelected(index)

    if Data.folder[index] == nil then
        return false
    end

    for i, v in ipairs(Data.selectedFolderIndex) do

        if v == index then
            return true
        end
        
    end

    if Data.folder[index].folder ~= nil then
        return Folder.IsSelected(Data.folder[index].folder)
    end

    return false

end