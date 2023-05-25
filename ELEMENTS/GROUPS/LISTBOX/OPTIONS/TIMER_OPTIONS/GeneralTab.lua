--===================================================================================
--             Name:    LISTBOX OPTIONS Timer GeneralTabs
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================


TimerGeneralTab = class(  Options.Constructor.Tab )

-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS Timer TABWINDOW
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
-------------------------------------------------------------------------------------
--           Return:    Timer listbox element
-------------------------------------------------------------------------------------
function TimerGeneralTab:Constructor( width, name, tabwindow )
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
function TimerGeneralTab:FillContent( selectedItem )

end







