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
function Options.Move.UpdateMode(enabled)

    Data.moveMode = enabled

    Group.MoveModeChanged()

end