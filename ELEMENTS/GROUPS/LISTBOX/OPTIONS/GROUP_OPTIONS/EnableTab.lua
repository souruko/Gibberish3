--===================================================================================
--             Name:    LISTBOX OPTIONS Group EnableTabs
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================


GroupEnableTab = class(  Options.Constructor.Tab )

-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS GROUP TABWINDOW
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function GroupEnableTab:Constructor( width, name, tabwindow )
	Options.Constructor.Tab.Constructor( self )

    self:SetWidth( width )
    self:SetName( name )
    self:SetTabWindow( tabwindow )

end

-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS GROUP TABWINDOW
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function GroupEnableTab:FillContent( groupData, groupIndex )

end





