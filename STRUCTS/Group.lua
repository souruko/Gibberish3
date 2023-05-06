
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
    group.id                    = Group.GetlastID()
    group.name                  = ""
    group.type                  = type
    group.enabled               = true
    group.saveGlobaly           = true
    group.description           = Group.Defaults[type].description
    group.resetOnTargetChange   = Group.Defaults[type].resetOnTargetChange
    group.useTargetEntity       = Group.Defaults[type].useTargetEntity

    -- position / size
    group.left                  = Group.Defaults[type].left
    group.top                   = Group.Defaults[type].top
    group.width                 = Group.Defaults[type].width
    group.height                = Group.Defaults[type].height
    group.frame                 = Group.Defaults[type].frame
    group.spacing               = Group.Defaults[type].spacing
    group.direction             = Group.Defaults[type].direction
    group.orientation           = Group.Defaults[type].orientation
    group.overlay               = Group.Defaults[type].overlay

    -- color / opacity
    group.color1                = Group.Defaults[type].color1
    group.color2                = Group.Defaults[type].color2
    group.color3                = Group.Defaults[type].color3
    group.color4                = Group.Defaults[type].color4
    group.color5                = Group.Defaults[type].color5

    group.opacityActiv          = Group.Defaults[type].opacityActiv
    group.opacityPassiv         = Group.Defaults[type].opacityPassiv

    -- text
    group.font                  = Group.Defaults[type].font
    group.durationFormat        = Group.Defaults[type].durationFormat
    group.textAlignment         = Group.Defaults[type].textAlignment
    group.timerAlignment        = Group.Defaults[type].timerAlignment
    group.showTimer             = Group.Defaults[type].showTimer

    group.counterDirection      = Group.Defaults[type].counterDirection

    group.timerList = {}

    -- timerList
    group[Trigger.EffectSelf]     = {}
    group[Trigger.EffectGroup]    = {}
    group[Trigger.EffectTarget]   = {}
    group[Trigger.Skill]          = {}
    group[Trigger.Chat]           = {}
    group[Trigger.TimerEnd]       = {}
    group[Trigger.TimerStart]     = {}
    group[Trigger.TimerThreshold] = {}

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

