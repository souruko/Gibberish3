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
function CreateGroup(type, data)

    if type == Group.Types.LISTBOX then

        return LISTBOX.ListBoxElement(data)
    
    else

        -- ERROR case
    
    end

end
