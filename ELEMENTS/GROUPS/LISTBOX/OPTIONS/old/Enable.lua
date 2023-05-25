--===================================================================================
--             Name:    GeneralTab
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
local window = Options.Controls[Group.Types.LISTBOX]
window.EnableTab = Options.Constructor.Tab( 706, L[Language.Local].Tab.Enable, window.TabWindow )


local row = 0
local row_height = 28
local top = 60
local checkBoxFix = 5

-------------------------------------------------------------------------------------
-- name
