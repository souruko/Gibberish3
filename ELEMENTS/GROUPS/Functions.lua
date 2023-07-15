--===================================================================================
--             Name:    GROUP Functions
-------------------------------------------------------------------------------------
--      Description:    Collection of GROUP Functions
--===================================================================================






-------------------------------------------------------------------------------------
--      Description:    selection changed event
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Group.SelectionChanged()

    for key, group in ipairs(Data.group) do

        if group.enabled == true then
            Group[key]:SelectionChanged()
        end

    end

end


-------------------------------------------------------------------------------------
--      Description:    enable/disable group
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      enable
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Group.Enable(index, enable)

    Data.group[index].enabled = enable

    if enable == Actions.Add then

        Group.Open(index)

    else

        Group.Close(index)

    end

end


-------------------------------------------------------------------------------------
--      Description:    close group
-------------------------------------------------------------------------------------
--        Parameter:    index
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Group.Close(index)

    if Group[index] ~= nil then
        Group[index]:Finish()
    end

    Group[index] = nil

end


-------------------------------------------------------------------------------------
--      Description:    open group
-------------------------------------------------------------------------------------
--        Parameter:    index
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Group.Open(index)

    if Group[index] == nil then
        Group[index] =  Group.Constructor[ Data.group[index].type ](index, Data.group[index])
    end

end


-------------------------------------------------------------------------------------
--      Description:    open all groups
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Group.OpenAll()

    for index, groupData in ipairs(Data.group) do

        if groupData.enabled == true then

            if Group[index] ~= nil then
                Group.Close(index)
            end
            
            Group.Open(index)

        end

    end

end



-------------------------------------------------------------------------------------
--      Description:    reset all timers with the reset setting
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Group.Reset()

    for index, groupData in ipairs(Data.group) do

        if groupData.enabled == true then

            Group[index]:Reset()

        end

    end

end




-------------------------------------------------------------------------------------
--      Description:    move mode changed
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Group.MoveModeChanged(all)


    for index, groupData in ipairs(Data.group) do

        if groupData.enabled == true and (all or Group.IsSelected(index)) then

            Group[index]:MoveChanged()

        end

    end

end

