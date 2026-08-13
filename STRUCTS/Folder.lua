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

    local folder = Data.folder[ index ]
    if folder == nil then return end

    -- Deleting a child swap-deletes the last slot into the freed one, and that can
    -- move *this* folder. Look our own slot up again before every pass so the
    -- comparisons below - and the final swap - use where we are now, not where we
    -- started; deleting the last folder of a nested pair used to delete a bystander
    -- instead and leave a hole in Data.folder.
    local function own_index()
        for i, fd in pairs(Data.folder) do
            if fd == folder then return i end
        end
        return nil
    end

    -- kill all child windows
    local delete = true
    while delete do
        delete = false
        index = own_index()
        if index == nil then return end
        for i=1,#Data.window do
            if Data.window[i] ~= nil and Data.window[i].folder == index then
                delete = true
                Options.DeleteWindow( i )
                break
            end
        end
    end

    -- kill all child folders
    delete = true
    while delete do
        delete = false
        index = own_index()
        if index == nil then return end
        for i=1,#Data.folder do
            if Data.folder[i] ~= nil and Data.folder[i].folder == index then
                delete = true
                Options.DeleteFolder( i )
                break
            end
        end
    end

    index = own_index()
    if index == nil then return end

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
-- close up holes in Data.folder
---------------------------------------------------------------------------------------------------
-- Everything walks Data.folder with ipairs, which stops at the first empty slot, so a
-- single hole hides every folder after it. Saves written before Folder.Delete was fixed
-- can carry one. Slots are packed down, every folder reference is remapped, and anything
-- that pointed at a folder which is gone moves back to the root.
---------------------------------------------------------------------------------------------------
function Folder.RepairIndices()

    if Data == nil or Data.folder == nil then return false end

    -- highest occupied slot; # cannot be trusted once there is a hole
    local max_index = 0
    for i in pairs(Data.folder) do
        if type(i) == "number" and i > max_index then max_index = i end
    end

    local packed = {}
    local remap  = {}
    for i=1,max_index do
        if Data.folder[i] ~= nil then
            packed[#packed+1] = Data.folder[i]
            remap[i] = #packed
        end
    end

    if #packed == max_index then return false end

    Data.folder = packed

    for i, folder_data in ipairs(Data.folder) do
        if folder_data.folder ~= nil then
            folder_data.folder = remap[ folder_data.folder ]
        end
    end
    for i, window_data in pairs(Data.window or {}) do
        if window_data.folder ~= nil then
            window_data.folder = remap[ window_data.folder ]
        end
    end

    return true

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

---------------------------------------------------------------------------------------------------
-- returns a list of Data.window indices for all windows in folder_index and its sub-folders
---------------------------------------------------------------------------------------------------
function Folder.GetWindowIndices( folder_index )

    local list = {}

    for index, window_data in ipairs(Data.window) do
        if window_data.folder == folder_index then
            list[#list+1] = index
        end
    end

    for index, folder_data in ipairs(Data.folder) do
        if folder_data.folder == folder_index then
            local sub = Folder.GetWindowIndices( index )
            for _, wi in ipairs(sub) do
                list[#list+1] = wi
            end
        end
    end

    return list

end
---------------------------------------------------------------------------------------------------
