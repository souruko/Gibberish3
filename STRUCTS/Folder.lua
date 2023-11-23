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
    for index, triggerType in ipairs( Trigger.Types ) do

        folder[triggerType] = {}

    end

    -- get next index
    local index = #Data.folder + 1
    Data.folder[index] = folder

    return index

end
---------------------------------------------------------------------------------------------------




