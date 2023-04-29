
--===================================================================================
--             Name:    STRUCTS - Group
-------------------------------------------------------------------------------------
--      Description:    Group structure and functions
--===================================================================================





-------------------------------------------------------------------------------------
--      Description:    return the base structure for creating a new group 
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    group struct
-------------------------------------------------------------------------------------
function Group.GetStruct(type)

    local group = {}

    -- general
    group.id = Group.GetlastID()
    group.name = ""
    group.type = type
    group.enabled = true
    group.resetOnTargetChange = false

    -- position / size
    group.width  = Group.Defaults[type].width
    group.height = Group.Defaults[type].height

    -- color / opacity
    -- text

    -- timerList
    group.timerList = {}

    return group

end


-------------------------------------------------------------------------------------
--      Description:     
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Group.New(name, type)

    local index = #Data.group + 1

    Data.group[index] = Group.GetStruct(type)
    Data.group[index].name = name
    Data.group[index].type = type

    return index

end


-------------------------------------------------------------------------------------
--      Description:     
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Group.Delete(index)

    for i = index, (#Data.group - 1) do

        Data.group[i] = Data.group[i + 1]

    end

    Data.group[#Data.group] = nil

end


-------------------------------------------------------------------------------------
--      Description:    return next group id and add 1 for next call
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    next group id
-------------------------------------------------------------------------------------
function Group.GetlastID()

    Data.group.lastID = Data.group.lastID + 1
    return Data.group.lastID

end

