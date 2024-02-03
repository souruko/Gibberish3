--=================================================================================================
--= Data Struct        
--= ===============================================================================================
--= data struct construction and functions
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- create new data struct (only relevant when no savefile is found)
---------------------------------------------------------------------------------------------------
function DataFunction.New()

    local data = {}

    -- list of window data
    data.window                     = {}
    data.window.lastID              = 0

    -- list of folder data
    data.folder                     = {}
    data.folder.lastID              = 0

    data.lastSortIndex              = 0

    data.selectedIndex              = 0
    data.selectedTimerIndex         = 0
    -- timer trigger
    data.selectedTriggerIndex       = 0
    data.selectedTriggerType        = 0
    -- window/folder trigger
    data.selectedTriggerIndex2      = 0
    data.selectedTriggerType2       = 0

    -- 
    data.moveMode                   = false
    data.showTooltips               = true
    data.autoReload                 = false

    -- list of options data
    data.options                    = {}

    data.options.language           = Language.Local

    -- options shortcut savedata
    data.options.shortcut           = {}
    data.options.shortcut.left      = 0.2
    data.options.shortcut.top       = 0.2

    -- options window savedata
    data.options.window             = {}
    data.options.window.left        = 0.2
    data.options.window.top         = 0.2
    data.options.window.width       = Options.Defaults.window.min_width
    data.options.window.height      = Options.Defaults.window.min_height
    
    data.options.window.open        = false
    data.options.window.tab1        = 1
    data.options.window.tab2        = 1
    
    data.options.window.collection_segment = 1

    data.persistent_collection = {}
    data.persistent_collection.skill = {}
    data.persistent_collection.effects = {}
    data.persistent_collection.chat = {}

    return data

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- return next sort index
---------------------------------------------------------------------------------------------------
function DataFunction.GetNextSortIndex()

    Data.lastSortIndex = Data.lastSortIndex + 1
    return Data.lastSortIndex

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- get next folder id
---------------------------------------------------------------------------------------------------
function DataFunction.GetNextSortIndex()

    Data.folder.lastID = Data.folder.lastID + 1

    return Data.folder.lastID

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- get next window id
---------------------------------------------------------------------------------------------------
function DataFunction.GetNextWindowID()

    Data.window.lastID = Data.window.lastID + 1
    return Data.window.lastID

end
---------------------------------------------------------------------------------------------------
