--===================================================================================
--             Name:    Move Windows 
-------------------------------------------------------------------------------------
--      Description:    Functions
--===================================================================================





-------------------------------------------------------------------------------------
--      Description:    listbox constructor
-------------------------------------------------------------------------------------
--        Parameter:    group data 
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function Options.Move.UpdateMode(enabled, all)

    Data.moveMode = enabled

    Group.MoveModeChanged(all)

end