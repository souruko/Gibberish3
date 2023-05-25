--===================================================================================
--             Name:    COUNTER OPTIONS Group TabWindow
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================


-------------------------------------------------------------------------------------
--      Description:    COUNTER OPTIONS Control
-------------------------------------------------------------------------------------
Group.Options[ Group.Types.COUNTER ] = Turbine.UI.Control()

local width = 706

Group.Options[ Group.Types.COUNTER ]:SetWidth(width)
Group.Options[ Group.Types.COUNTER ]:SetBackColor( Defaults.Colors.BackgroundColor2 )


-------------------------------------------------------------------------------------
--      Description:    COUNTER OPTIONS GROUP OPTIONS
-------------------------------------------------------------------------------------
Group.Options[ Group.Types.COUNTER ].groupTabWindow = Options.Constructor.TabWindow( Group.Options[  Group.Types.COUNTER ], width, 101  )

Group.Options[ Group.Types.COUNTER ].groupTabs = {}
Group.Options[ Group.Types.COUNTER ].groupTabs.general = OPTIONS.GROUP_OPTIONS.GroupGeneralTab( width, L[Language.Local].Tab.General, Group.Options[ Group.Types.COUNTER ].groupTabWindow )
Group.Options[ Group.Types.COUNTER ].groupTabs.timer = OPTIONS.GROUP_OPTIONS.GroupTimerTab( width, L[Language.Local].Tab.Timer, Group.Options[ Group.Types.COUNTER ].groupTabWindow )
Group.Options[ Group.Types.COUNTER ].groupTabs.ui = OPTIONS.GROUP_OPTIONS.GroupUITab( width, L[Language.Local].Tab.UI, Group.Options[ Group.Types.COUNTER ].groupTabWindow )
Group.Options[ Group.Types.COUNTER ].groupTabs.color = OPTIONS.GROUP_OPTIONS.GroupColorTab( width, L[Language.Local].Tab.Color, Group.Options[ Group.Types.COUNTER ].groupTabWindow )
Group.Options[ Group.Types.COUNTER ].groupTabs.text = OPTIONS.GROUP_OPTIONS.GroupTextTab( width, L[Language.Local].Tab.Text, Group.Options[ Group.Types.COUNTER ].groupTabWindow )
Group.Options[ Group.Types.COUNTER ].groupTabs.enable = OPTIONS.GROUP_OPTIONS.GroupEnableTab( width, L[Language.Local].Tab.Enable, Group.Options[ Group.Types.COUNTER ].groupTabWindow )
Group.Options[ Group.Types.COUNTER ].groupTabs.misc = OPTIONS.GROUP_OPTIONS.GroupMiscTab( width, L[Language.Local].Tab.Misc, Group.Options[ Group.Types.COUNTER ].groupTabWindow )

Group.Options[ Group.Types.COUNTER ].groupTabWindow:AddTab( Group.Options[ Group.Types.COUNTER ].groupTabs.general )
Group.Options[ Group.Types.COUNTER ].groupTabWindow:AddTab( Group.Options[ Group.Types.COUNTER ].groupTabs.timer )
Group.Options[ Group.Types.COUNTER ].groupTabWindow:AddTab( Group.Options[ Group.Types.COUNTER ].groupTabs.ui )
Group.Options[ Group.Types.COUNTER ].groupTabWindow:AddTab( Group.Options[ Group.Types.COUNTER ].groupTabs.color )
Group.Options[ Group.Types.COUNTER ].groupTabWindow:AddTab( Group.Options[ Group.Types.COUNTER ].groupTabs.text )
Group.Options[ Group.Types.COUNTER ].groupTabWindow:AddTab( Group.Options[ Group.Types.COUNTER ].groupTabs.enable )
Group.Options[ Group.Types.COUNTER ].groupTabWindow:AddTab( Group.Options[ Group.Types.COUNTER ].groupTabs.misc )

Group.Options[ Group.Types.COUNTER ].groupTabWindow:ResetSelection()


-------------------------------------------------------------------------------------
--      Description:    SizeChanged
-------------------------------------------------------------------------------------
Group.Options[ Group.Types.COUNTER ].SizeChanged = function ()

    Group.Options[ Group.Types.COUNTER ].groupTabWindow:SetHeight(  Group.Options[ Group.Types.COUNTER ]:GetHeight() )
    
end


-------------------------------------------------------------------------------------
--      Description:    FillContent
-------------------------------------------------------------------------------------
Group.Options[ Group.Types.COUNTER ].FillContent = function ( groupData, groupIndex )

    Group.Options[ Group.Types.COUNTER ].groupTabs.general:FillContent( groupData, groupIndex )
    Group.Options[ Group.Types.COUNTER ].groupTabs.timer:FillContent( groupData, groupIndex )
    Group.Options[ Group.Types.COUNTER ].groupTabs.ui:FillContent( groupData, groupIndex )
    Group.Options[ Group.Types.COUNTER ].groupTabs.color:FillContent( groupData, groupIndex )
    Group.Options[ Group.Types.COUNTER ].groupTabs.text:FillContent( groupData, groupIndex )
    Group.Options[ Group.Types.COUNTER ].groupTabs.enable:FillContent( groupData, groupIndex )
    Group.Options[ Group.Types.COUNTER ].groupTabs.misc:FillContent( groupData, groupIndex )

end


-------------------------------------------------------------------------------------
--      Description:    CheckContent
-------------------------------------------------------------------------------------
Group.Options[ Group.Types.COUNTER ].CheckContent = function ()
    
end


-------------------------------------------------------------------------------------
--      Description:    SaveContent
-------------------------------------------------------------------------------------
Group.Options[ Group.Types.COUNTER ].SaveContent = function ()
    
end