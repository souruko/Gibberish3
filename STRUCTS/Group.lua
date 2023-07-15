
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
    group.sortIndex             = Data.GetNextSortIndex()
    group.nextTimerSortIndex    = 1
    group.name                  = ""
    group.folder                = nil
    group.type                  = type
    group.timerType             = Group.Defaults[type].timerType
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
    group.fontSize              = Group.Defaults[type].fontSize
    group.durationFormat        = Group.Defaults[type].durationFormat
    group.textAlignment         = Group.Defaults[type].textAlignment
    group.timerAlignment        = Group.Defaults[type].timerAlignment
    group.showTimer             = Group.Defaults[type].showTimer

    group.counterDirection      = Group.Defaults[type].counterDirection

    group.timerList = {}

    -- timerList
    group[Trigger.Types.EffectSelf]     = {}
    group[Trigger.Types.EffectGroup]    = {}
    group[Trigger.Types.EffectTarget]   = {}
    group[Trigger.Types.Skill]          = {}
    group[Trigger.Types.Chat]           = {}
    group[Trigger.Types.TimerEnd]       = {}
    group[Trigger.Types.TimerStart]     = {}
    group[Trigger.Types.TimerThreshold] = {}

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
function Group.AddTimer(group, type)

    local timerIndex = #group.timerList+1

    group.timerList[ timerIndex ] = Timer.New(type)
    group.timerList[ timerIndex ].sortIndex = group.nextTimerSortIndex

    group.nextTimerSortIndex = group.nextTimerSortIndex + 1

    return timerIndex

end


-------------------------------------------------------------------------------------
--      Description:     
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Group.Delete(list)

    local groupMaxCount = #Data.group

    for listIndex, groupIndex in ipairs(list) do

        if Data.group[groupIndex].enabled == true then
            Group.Close(groupIndex)
        end

        Data.group[groupIndex] = nil

    end

    -- the distance the groupindex will  be moved
    local distance = 0

    -- resort Data.group
    for i=1, groupMaxCount do

        if Data.group[i] == nil then
            distance = distance + 1
        else
            Data.group[i - distance] = Data.group[i]
            
            if Data.group[i].enabled == true then
                Group[i - distance] = Group[i]
                Group[i].index = i
            end
        end

    end

    for i=groupMaxCount, (groupMaxCount-distance+1), -1 do
        
        Data.group[i] = nil

    end

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


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    fromData, toData
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Group.SortTo(groupData, fromData, toData)

    local fromSortIndex = fromData.sortIndex
    local toSortIndex = toData.sortIndex

    if fromSortIndex > toSortIndex then

        for key, timer in ipairs(groupData.timerList) do

            if timer.sortIndex >= toSortIndex and timer.sortIndex <= fromSortIndex then

                timer.sortIndex = timer.sortIndex + 1

            end
    
        end

    else

        for key, timer in ipairs(groupData.timerList) do

            if timer.sortIndex <= toSortIndex and timer.sortIndex >= fromSortIndex then

                timer.sortIndex = timer.sortIndex - 1

            end
    
        end

      
    end

    fromData.sortIndex = toSortIndex

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    fromData, toData
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Group.IsSelected(index)

    if Data.group[index] == nil then
        return false
    end

    for i, v in ipairs(Data.selectedGroupIndex) do

        if v == index then
            return true
        end
        
    end

    if Data.group[index].folder ~= nil then
        return Folder.IsSelected(Data.group[index].folder)
    end

    return false

end


-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:   
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Group.CopyCache()


end

-------------------------------------------------------------------------------------
--      Description:    
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Group.CutCache()

end