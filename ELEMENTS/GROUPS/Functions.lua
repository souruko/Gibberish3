--===================================================================================
--             Name:    GROUP Functions
-------------------------------------------------------------------------------------
--      Description:    Collection of GROUP Functions
--===================================================================================



-------------------------------------------------------------------------------------
--      Description:    create a group with type and data then return the group
-------------------------------------------------------------------------------------
--        Parameter:    group type
--                      group data
-------------------------------------------------------------------------------------
--           Return:    the created group element
-------------------------------------------------------------------------------------
function Group.Create(type, index, data)

    if type == Group.Types.LISTBOX then

        return LISTBOX.ListBoxElement(index, data)
    
    else

        -- ERROR case
    
    end

end



-------------------------------------------------------------------------------------
--      Description:    selection changed event
-------------------------------------------------------------------------------------
--        Parameter:    
-------------------------------------------------------------------------------------
--           Return:    
-------------------------------------------------------------------------------------
function Group.SelectionChanged(index)

    Data.selectedGroupIndex = index

    for key, group in ipairs(Group) do

        group:SelectionChanged()

    end

end