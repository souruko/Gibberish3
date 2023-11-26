--=================================================================================================
--= Data Struct        
--= ===============================================================================================
--= data struct construction and functions
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- create new data struct (only relevant when no savefile is found)
---------------------------------------------------------------------------------------------------
function Data.New()

    -- list of window data
    Data.window                      = {}
    Data.window.lastID = 0

    -- list of folder data
    Data.folder                     = {}
    Data.folder.lastID              = 0

    Data.lastSortIndex              = 0

    Data.selectedIndex              = 0
    Data.selectedTimerIndex         = 0
    Data.selectedTriggerIndex       = 0

    -- 
    Data.moveMode                   = false
    Data.showTooltips               = true

    Data.trackGroupEffects          = true
    Data.trackTargetEffects         = false

    -- list of options data
    Data.options                    = {}

    -- options shortcut savedata
    Data.options.shortcut           = {}

    Data.options.shortcut.left      = 0.2
    Data.options.shortcut.top       = 0.2

    Data.options.shortcut.moveable  = true

    -- options window savedata
    Data.options.window             = {}
    
    Data.options.window.tab1        = 1
    Data.options.window.tab2        = 1

    Data.options.window.left        = 0
    Data.options.window.top         = 0

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- return next sort index
---------------------------------------------------------------------------------------------------
function Data.GetNextSortIndex()

    Data.lastSortIndex = Data.lastSortIndex + 1
    return Data.lastSortIndex

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- get next folder id
---------------------------------------------------------------------------------------------------
function Data.GetNextFolderID()

    Data.folder.lastID = Data.folder.lastID + 1

    return Data.folder.lastID

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- get next window id
---------------------------------------------------------------------------------------------------
function Data.GetNextWindowID()

    Data.window.lastID = Data.window.lastID + 1
    return Data.window.lastID

end
---------------------------------------------------------------------------------------------------
