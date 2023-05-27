--===================================================================================
--             Name:    LISTBOX OPTIONS Group TabWindow
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================


-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS Control
-------------------------------------------------------------------------------------
Group.Options[ Group.Types.LISTBOX ] = Turbine.UI.Control()

local width = 706

Group.Options[ Group.Types.LISTBOX ].multiselect = false

Group.Options[ Group.Types.LISTBOX ]:SetWidth(width)
Group.Options[ Group.Types.LISTBOX ]:SetBackColor( Defaults.Colors.BackgroundColor2 )

-------------------------------------------------------------------------------------
--      Description:    LISTBOX OPTIONS GROUP OPTIONS
-------------------------------------------------------------------------------------
Group.Options[ Group.Types.LISTBOX ].groupTabWindow = Options.Constructor.TabWindow( Group.Options[  Group.Types.LISTBOX ], width, 101  )

Group.Options[ Group.Types.LISTBOX ].groupTabs = {}
Group.Options[ Group.Types.LISTBOX ].groupTabs.general = OPTIONS.GROUP_OPTIONS.GroupGeneralTab( width, L[Language.Local].Tab.General, Group.Options[ Group.Types.LISTBOX ].groupTabWindow )
Group.Options[ Group.Types.LISTBOX ].groupTabs.timer = OPTIONS.GROUP_OPTIONS.GroupTimerTab( width, L[Language.Local].Tab.Timer, Group.Options[ Group.Types.LISTBOX ].groupTabWindow )
Group.Options[ Group.Types.LISTBOX ].groupTabs.ui = OPTIONS.GROUP_OPTIONS.GroupUITab( width, L[Language.Local].Tab.UI, Group.Options[ Group.Types.LISTBOX ].groupTabWindow )
Group.Options[ Group.Types.LISTBOX ].groupTabs.color = OPTIONS.GROUP_OPTIONS.GroupColorTab( width, L[Language.Local].Tab.Color, Group.Options[ Group.Types.LISTBOX ].groupTabWindow )
Group.Options[ Group.Types.LISTBOX ].groupTabs.text = OPTIONS.GROUP_OPTIONS.GroupTextTab( width, L[Language.Local].Tab.Text, Group.Options[ Group.Types.LISTBOX ].groupTabWindow )
Group.Options[ Group.Types.LISTBOX ].groupTabs.enable = OPTIONS.GROUP_OPTIONS.GroupEnableTab( width, L[Language.Local].Tab.Enable, Group.Options[ Group.Types.LISTBOX ].groupTabWindow )
Group.Options[ Group.Types.LISTBOX ].groupTabs.misc = OPTIONS.GROUP_OPTIONS.GroupMiscTab( width, L[Language.Local].Tab.Misc, Group.Options[ Group.Types.LISTBOX ].groupTabWindow )

Group.Options[ Group.Types.LISTBOX ].groupTabWindow:AddTab( Group.Options[ Group.Types.LISTBOX ].groupTabs.general )
Group.Options[ Group.Types.LISTBOX ].groupTabWindow:AddTab( Group.Options[ Group.Types.LISTBOX ].groupTabs.timer )
Group.Options[ Group.Types.LISTBOX ].groupTabWindow:AddTab( Group.Options[ Group.Types.LISTBOX ].groupTabs.ui )
Group.Options[ Group.Types.LISTBOX ].groupTabWindow:AddTab( Group.Options[ Group.Types.LISTBOX ].groupTabs.color )
Group.Options[ Group.Types.LISTBOX ].groupTabWindow:AddTab( Group.Options[ Group.Types.LISTBOX ].groupTabs.text )
Group.Options[ Group.Types.LISTBOX ].groupTabWindow:AddTab( Group.Options[ Group.Types.LISTBOX ].groupTabs.enable )
Group.Options[ Group.Types.LISTBOX ].groupTabWindow:AddTab( Group.Options[ Group.Types.LISTBOX ].groupTabs.misc )

Group.Options[ Group.Types.LISTBOX ].groupTabWindow:ResetSelection()


-------------------------------------------------------------------------------------
--      Description:    SizeChanged
-------------------------------------------------------------------------------------
Group.Options[ Group.Types.LISTBOX ].SizeChanged = function ()

    Group.Options[ Group.Types.LISTBOX ].groupTabWindow:SetHeight(  Group.Options[ Group.Types.LISTBOX ]:GetHeight() )
    
end


-------------------------------------------------------------------------------------
--      Description:    FillContent
-------------------------------------------------------------------------------------
Group.Options[ Group.Types.LISTBOX ].FillContent = function ( groupData, groupIndex, multiselect )

    Group.Options[ Group.Types.LISTBOX ].multiselect = multiselect

    Group.Options[ Group.Types.LISTBOX ].groupTabs.general:FillContent( groupData, groupIndex, multiselect )
    Group.Options[ Group.Types.LISTBOX ].groupTabs.timer:FillContent( groupData, groupIndex, multiselect )
    Group.Options[ Group.Types.LISTBOX ].groupTabs.ui:FillContent( groupData, groupIndex, multiselect )
    Group.Options[ Group.Types.LISTBOX ].groupTabs.color:FillContent( groupData, groupIndex, multiselect )
    Group.Options[ Group.Types.LISTBOX ].groupTabs.text:FillContent( groupData, groupIndex, multiselect )
    Group.Options[ Group.Types.LISTBOX ].groupTabs.enable:FillContent( groupData, groupIndex, multiselect )
    Group.Options[ Group.Types.LISTBOX ].groupTabs.misc:FillContent( groupData, groupIndex, multiselect )

end


-------------------------------------------------------------------------------------
--      Description:    CheckContent
-------------------------------------------------------------------------------------
Group.Options[ Group.Types.LISTBOX ].CheckContent = function ()
    
end


-------------------------------------------------------------------------------------
--      Description:    SaveContent
-------------------------------------------------------------------------------------
Group.Options[ Group.Types.LISTBOX ].SaveContent = function ()
    
end