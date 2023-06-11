
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
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Folder.Delete(index)

    local list = {}
    -- delete all groups within the group
    for i, groupData in ipairs(Data.group) do

        if groupData.folder == index then
            list[#list+1] = i
        end
        
    end
    for j, i in ipairs(list) do
        Group.Delete(i)
    end
    list = {}
    -- delete all groups within the group
    for i, folderData in ipairs(Data.folder) do

        if folderData.folder == index then
            list[#list+1] = i
        end
        
    end
    for j, i in ipairs(list) do
        Folder.Delete(i)
    end

    -- delete the group and fix indexes
    for i = index, (#Data.folder - 1) do

        local temp = i+1
        Data.folder[i] = Data.folder[temp]

        -- fix folderIndex for all groups in this folder
        for j, groupData in ipairs(Data.group) do

            if groupData.folder == temp then
                groupData.folder = i
            end
            
        end
         -- fix folderIndex for all groups in this folder
         for j, folderData in ipairs(Data.folder) do

            if folderData.folder == temp then
                folderData.folder = i
            end
            
        end


    end

    Data.folder[#Data.folder] = nil

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