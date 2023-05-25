--===================================================================================
--             Name:    LISTBOX OPTIONS Timer AnimationTabs
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================


TimerAnimationTab = class(  Options.Constructor.Tab )

-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS Timer TABWINDOW
-------------------------------------------------------------------------------------
--        Parameter:    index
--                      data
-------------------------------------------------------------------------------------
--           Return:    Timer listbox element
-------------------------------------------------------------------------------------
function TimerAnimationTab:Constructor( width, name, tabwindow )
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
function TimerAnimationTab:FillContent( selectedItem )

end



