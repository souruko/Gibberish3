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
    folder.id           = Data.GetNextFolderID()
    folder.sortIndex    = Data.GetNextSortIndex()
    folder.name         = name
    folder.enabled      = false
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
function Folder.Copy(index)

    local folder        = {}

    -- set default values
    folder.id           = Data.GetNextFolderID()
    folder.sortIndex    = Data.GetNextSortIndex()
    folder.name         = Data.folder[index].name
    folder.collapsed    = Data.folder[index].collapsed
    folder.folder       = Data.folder[index].folder

    -- create trigger tables
    for name, triggerType in pairs( Trigger.Types ) do

        folder[triggerType] = {}

        for i, triggerData in ipairs( Data.folder[index][ triggerType ] ) do
            folder[ triggerType ][ i ] = Trigger.Copy( triggerData )
        end

    end

    -- get next index
    local newIndex = #Data.folder + 1
    Data.folder[newIndex] = folder

    return newIndex

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- delete folder
---------------------------------------------------------------------------------------------------
function Folder.Delete(index)

    -- kill all child folders/windows
    for i, item in ipairs(Data.window) do
        if item.folder == index then
            Options.DeleteWindow( i )
        end
    end
    for j, item in ipairs(Data.folder) do
        if item.folder == index then
            Options.DeleteFolder( j )
        end
    end

    -- dreieckstausch
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
