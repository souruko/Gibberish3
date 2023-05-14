--===================================================================================
--             Name:    LISTBOX Options Window
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================

Options.Controls[Group.Types.LISTBOX] = Turbine.UI.Control()

local window = Options.Controls[Group.Types.LISTBOX]

window:SetWidth(706)
window:SetPosition(12, 42)
window:SetBackColor( Defaults.Colors.BackgroundColor2 )


window.TabWindow = Options.Constructor.TabWindow( window, 706 )



window.GeneralTab = Options.Constructor.Tab( 706, "General", window.TabWindow )

window.GeneralTab.nameLabel = Turbine.UI.Label()
window.GeneralTab.nameLabel:SetParent(window.GeneralTab)
window.GeneralTab.nameLabel:SetPosition(             20, 60 )
window.GeneralTab.nameLabel:SetSize(                 100, 25 )
window.GeneralTab.nameLabel:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
window.GeneralTab.nameLabel:SetFont(                 Defaults.Fonts.TabFont )
window.GeneralTab.nameLabel:SetText(                 L[Language.Local].Options.Name )

window.GeneralTab.nameTextBox = Turbine.UI.Lotro.TextBox()
window.GeneralTab.nameTextBox:SetParent(window.GeneralTab)
window.GeneralTab.nameTextBox:SetPosition(             130, 60 )
window.GeneralTab.nameTextBox:SetSize(                 180, 25 )
window.GeneralTab.nameTextBox:SetTextAlignment(        Turbine.UI.ContentAlignment.MiddleLeft )
window.GeneralTab.nameTextBox:SetFont(                 Defaults.Fonts.TabFont )



window.SizeTab = Options.Constructor.Tab( 706, "Size & Position", window.TabWindow )
window.ColorsTab = Options.Constructor.Tab( 706, "Colors", window.TabWindow )
window.TextTab = Options.Constructor.Tab( 706, "Text", window.TabWindow )
window.TimersTab = Options.Constructor.Tab( 706, "Timers", window.TabWindow )

window.TabWindow:AddTab(window.GeneralTab)
window.TabWindow:AddTab(window.SizeTab)
window.TabWindow:AddTab(window.ColorsTab)
window.TabWindow:AddTab(window.TextTab)
window.TabWindow:AddTab(window.TimersTab)


window.TabWindow:ResetSelection()

window.SizeChanged = function ()
    window.TabWindow:SetSize(window:GetSize())
end


function window:FillContent(groupData, groupIndex)

    window.GeneralTab.nameTextBox:SetText( groupData.name )

end