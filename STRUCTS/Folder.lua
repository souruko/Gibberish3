--=================================================================================================
--= Folder        
--= ===============================================================================================
--= folder struct construction and functions
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- creates new folder struct and returns index
---------------------------------------------------------------------------------------------------
function Folder.New(name)

    local folder        = {}

    -- set default values
    folder.id           = DataFunction.GetNextFolderID()
    folder.sortIndex    = DataFunction.GetNextSortIndex()
    folder.name         = name
    folder.collapsed    = false
    folder.folder       = nil

    -- create trigger tables
    for index, triggerType in pairs( Trigger.Types ) do

        folder[triggerType] = {}

    end

    -- get next index
    local index = #Data.folder + 1
    Data.folder[index] = folder

    return index

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- copy folder struct and returns index
---------------------------------------------------------------------------------------------------
function Folder.Copy(oldIndex)

    local folder        = {}

    -- set default values
    folder.id           = DataFunction.GetNextFolderID()
    folder.sortIndex    = DataFunction.GetNextSortIndex()
    folder.name         = Data.folder[oldIndex].name
    folder.collapsed    = Data.folder[oldIndex].collapsed
    folder.folder       = Data.folder[oldIndex].folder

    -- create trigger tables
    for name, triggerType in pairs( Trigger.Types ) do

        folder[triggerType] = {}

        for i, triggerData in ipairs( Data.folder[oldIndex][ triggerType ] ) do
            folder[ triggerType ][ i ] = Trigger.Copy( triggerData )
        end

    end

    -- get next index
    local newIndex = #Data.folder + 1
    Data.folder[newIndex] = folder

    --  copy windows
    for index, window_data in ipairs(Data.window) do

        if window_data.folder == oldIndex then

            local window_index = Window.Copy( index )
            Data.window[ window_index ].folder = newIndex

        end

    end

    -- copy folder
    for index, folder_data in ipairs(Data.folder) do

        if folder_data.folder == oldIndex then

            local folder_index = Folder.Copy( index )
            Data.folder[ folder_index ].folder = newIndex

        end
        
    end

    return newIndex

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- delete folder
---------------------------------------------------------------------------------------------------
function Folder.Delete(index)

    -- kill all child folders/windows
    local delete = true
    local startIndex = 1
    while delete do 
        delete = false
        for i=startIndex,#Data.window do
            if Data.window[i].folder == index then
                delete = true
                startIndex = i
                Options.DeleteWindow( i )
                break
            end
        end
    end
    local delete = true
    local startIndex = 1
    while delete do 
        delete = false
        for i=startIndex,#Data.folder do
            if Data.folder[i].folder == index then
                delete = true
                startIndex = i
                Options.DeleteFolder( i )
                break
            end
        end
    end

    local folder_count = #Data.folder
    Data.folder[ index ]        = Data.folder[ folder_count ]
    Data.folder[ folder_count ] = nil

    -- fix folder index of moved folder
    for i, item in ipairs(Data.window) do
        if item.folder == folder_count then
            item.folder = index
        end
    end
    for i, item in ipairs(Data.folder) do
        if item.folder == folder_count then
            item.folder = index
        end
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- delete folder
---------------------------------------------------------------------------------------------------
function Folder.GetListOfWindows( folder_index )

    local list = {}

    -- find windows
    for index, window_data in ipairs(Data.window) do
        if window_data.folder == folder_index then
            list[#list+1] = window_data
        end
    end

    -- find folders / recursive ...
    for index, folder_data in ipairs(Data.folder) do
        if folder_data.folder == folder_index then
            local list2 = Folder.GetListOfWindows( index )

            for key, value in pairs(list2) do
                list[#list+1] = value
            end
        end
    end

    return list

end
---------------------------------------------------------------------------------------------------
