--===================================================================================
--             Name:    LISTBOX OPTIONS Group TabWindow
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================



ListBoxOptions = class(Turbine.UI.Control)

function ListBoxOptions:Constructor()
	Turbine.UI.Control.Constructor( self )


    local width = 706

    self.multiselect = false
    
    self:SetWidth(width)
    self:SetBackColor( Defaults.Colors.BackgroundColor2 )
    
    -------------------------------------------------------------------------------------
    --      Description:    LISTBOX OPTIONS GROUP OPTIONS
    -------------------------------------------------------------------------------------
    self.groupTabWindow = Options.Constructor.TabWindow( self, width, 101  )
    
    self.groupTabs = {}
    self.groupTabs.general = OPTIONS.GroupGeneralTab( width, L[Language.Local].Tab.General, self.groupTabWindow )
    self.groupTabs.timer = OPTIONS.GroupTimerTab( width, L[Language.Local].Tab.Timer, self.groupTabWindow )
    self.groupTabs.ui = OPTIONS.GroupUITab( width, L[Language.Local].Tab.UI, self.groupTabWindow )
    self.groupTabs.color = OPTIONS.GroupColorTab( width, L[Language.Local].Tab.Color, self.groupTabWindow )
    self.groupTabs.text = OPTIONS.GroupTextTab( width, L[Language.Local].Tab.Text, self.groupTabWindow )
    self.groupTabs.enable = OPTIONS.GroupEnableTab( width, L[Language.Local].Tab.Enable, self.groupTabWindow )
    self.groupTabs.misc = OPTIONS.GroupMiscTab( width, L[Language.Local].Tab.Misc, self.groupTabWindow )
    
    self.groupTabWindow:AddTab( self.groupTabs.general )
    self.groupTabWindow:AddTab( self.groupTabs.timer )
    self.groupTabWindow:AddTab( self.groupTabs.ui )
    self.groupTabWindow:AddTab( self.groupTabs.color )
    self.groupTabWindow:AddTab( self.groupTabs.text )
    self.groupTabWindow:AddTab( self.groupTabs.enable )
    self.groupTabWindow:AddTab( self.groupTabs.misc )
    
    self.groupTabWindow:ResetSelection()
    

end


-------------------------------------------------------------------------------------
--      Description:    SizeChanged
-------------------------------------------------------------------------------------
function ListBoxOptions:SizeChanged()

    self.groupTabWindow:SetHeight(  self:GetHeight() )
    
end


-------------------------------------------------------------------------------------
--      Description:    FillContent
-------------------------------------------------------------------------------------
function ListBoxOptions:FillContent ( groupData, groupIndex, multiselect )

    self.multiselect = multiselect

    self.groupTabs.general:FillContent( groupData, groupIndex, multiselect )
    self.groupTabs.timer:FillContent( groupData, groupIndex, multiselect )
    self.groupTabs.ui:FillContent( groupData, groupIndex, multiselect )
    self.groupTabs.color:FillContent( groupData, groupIndex, multiselect )
    self.groupTabs.text:FillContent( groupData, groupIndex, multiselect )
    self.groupTabs.enable:FillContent( groupData, groupIndex, multiselect )
    self.groupTabs.misc:FillContent( groupData, groupIndex, multiselect )

end

-------------------------------------------------------------------------------------
--      Description:    CheckContent
-------------------------------------------------------------------------------------
function ListBoxOptions:Finish()

    self.groupTabs.general:Finish()
    self.groupTabs.timer:Finish()
    self.groupTabs.ui:Finish()
    self.groupTabs.color:Finish()
    self.groupTabs.text:Finish()
    self.groupTabs.enable:Finish()
    self.groupTabs.misc:Finish()

end

-------------------------------------------------------------------------------------
--      Description:    CheckContent
-------------------------------------------------------------------------------------
function ListBoxOptions:CheckContent()
    
end


-------------------------------------------------------------------------------------
--      Description:    SaveContent
-------------------------------------------------------------------------------------
function ListBoxOptions:SaveContent()
    
end
