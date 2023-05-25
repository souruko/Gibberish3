--===================================================================================
--             Name:    LISTBOX OPTIONS Group TextTabs
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================


GroupTextTab = class(  Options.Constructor.Tab )

-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS GROUP TABWINDOW
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
-------------------------------------------------------------------------------------
--           Return:    group listbox element
-------------------------------------------------------------------------------------
function GroupTextTab:Constructor( width, name, tabwindow )
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
function GroupTextTab:FillContent( groupData, groupIndex )

end





