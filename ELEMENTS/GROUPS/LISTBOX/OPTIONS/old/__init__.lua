--===================================================================================
--             Name:    LISTBOX OPTIONS init
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================






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


-------------------------------------------------------------------------------------
--      Description:    tabwindow
-------------------------------------------------------------------------------------
window.TabWindow = Options.Constructor.TabWindow( window, 706, 101 )



-------------------------------------------------------------------------------------
--      Description:    tabs
-------------------------------------------------------------------------------------
import "Gibberish3.ELEMENTS.GROUPS.LISTBOX.OPTIONS.General"
import "Gibberish3.ELEMENTS.GROUPS.LISTBOX.OPTIONS.Timer"
import "Gibberish3.ELEMENTS.GROUPS.LISTBOX.OPTIONS.Size"
import "Gibberish3.ELEMENTS.GROUPS.LISTBOX.OPTIONS.Color"
import "Gibberish3.ELEMENTS.GROUPS.LISTBOX.OPTIONS.Text"
import "Gibberish3.ELEMENTS.GROUPS.LISTBOX.OPTIONS.Enable"
import "Gibberish3.ELEMENTS.GROUPS.LISTBOX.OPTIONS.Misc"



-------------------------------------------------------------------------------------
--      Description:    add
-------------------------------------------------------------------------------------
window.TabWindow:AddTab(window.GeneralTab)
window.TabWindow:AddTab(window.TimerTab)
window.TabWindow:AddTab(window.SizeTab)
window.TabWindow:AddTab(window.ColorTab)
window.TabWindow:AddTab(window.TextTab)
window.TabWindow:AddTab(window.EnableTab)
window.TabWindow:AddTab(window.MiscTab)


-------------------------------------------------------------------------------------
--      Description:    functions
-------------------------------------------------------------------------------------
window.TabWindow:ResetSelection()

window.SizeChanged = function ()
    window.TabWindow:SetSize(window:GetSize())
end


function window:FillContent(groupData, groupIndex)

    window.GeneralTab.nameTextBox:SetText( groupData.name )
    window.GeneralTab.typeTextBox:SetText( L[Language.Local].Terms.GroupTypes[ groupData.type ] )
    window.GeneralTab.globalyCheckBox:SetChecked( groupData.saveGlobaly )
    window.GeneralTab.descriptionTextBox:SetText( groupData.description )
  
    local left, top =  Utils.ScreenRatioToPixel( groupData.left,  groupData.top )
    window.SizeTab.leftTextBox:SetText( left )
    window.SizeTab.topTextBox:SetText( top )
    window.SizeTab.widthTextBox:SetText( groupData.width )
    window.SizeTab.heightTextBox:SetText( groupData.height )
    window.SizeTab.frameTextBox:SetText( groupData.frame )
    window.SizeTab.spacingTextBox:SetText( groupData.spacing )

    window.SizeTab.directionCheckBox:SetChecked( groupData.direction )
    window.SizeTab.orientationCheckBox:SetChecked( groupData.orientation )
    window.SizeTab.overlayCheckBox:SetChecked( groupData.overlay )

end