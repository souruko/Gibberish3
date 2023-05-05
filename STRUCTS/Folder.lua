
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
    folder.name = ""
    folder.enabled = false
    folder.collapsed = false

    folder[Trigger.EffectSelf]     = {}
    folder[Trigger.EffectGroup]    = {}
    folder[Trigger.EffectTarget]   = {}
    folder[Trigger.Skill]          = {}
    folder[Trigger.Chat]           = {}
    folder[Trigger.TimerEnd]       = {}
    folder[Trigger.TimerStart]     = {}
    folder[Trigger.TimerThreshold] = {}

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
--      Description:     
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Folder.Delete(index)

    for i = index, (#Data.folder - 1) do

        Data.folder[i] = Data.folder[i + 1]

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