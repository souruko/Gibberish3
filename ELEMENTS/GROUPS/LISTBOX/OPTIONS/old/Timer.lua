--===================================================================================
--             Name:    GeneralTab
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================
local window = Options.Controls[Group.Types.LISTBOX]
window.TimerTab = Options.Constructor.Tab( 706, L[Language.Local].Tab.Timer, window.TabWindow )


local row = 0
local row_height = 28
local top = 60
local checkBoxFix = 5
local colum1_left = 10
local colum2_left = 140
local colum1_widht = 110
local colum2_width = 210
local content_height = 20

window.TimerTab.SizeChanged = function ()
   
    window.TimerTab.background:SetHeight( window.TimerTab:GetHeight() - 40 )
    window.TimerTab.frame:SetHeight( window.TimerTab.background:GetHeight() - 10 )
    window.TimerTab.list:SetHeight( window.TimerTab.frame:GetHeight() - 26 )
    window.TimerTab.TabWindow:SetHeight( window.TimerTab.background:GetHeight() - 10 )
end

-------------------------------------------------------------------------------------
-- background

window.TimerTab.background                   = Turbine.UI.Control()
window.TimerTab.background:SetParent(          window.TimerTab )
window.TimerTab.background:SetPosition(        5, 35 )
window.TimerTab.background:SetBackColor(       Defaults.Colors.BackgroundColor1 )
window.TimerTab.background:SetMouseVisible(    false )
window.TimerTab.background:SetWidth(           696 )

-------------------------------------------------------------------------------------
--  frame  
window.TimerTab.frame                        = Turbine.UI.Control()
window.TimerTab.frame:SetParent(               window.TimerTab.background )
window.TimerTab.frame:SetPosition(             5, 5 )
window.TimerTab.frame:SetBackColor(            Defaults.Colors.BackgroundColor6 )
window.TimerTab.frame:SetMouseVisible(         false )
window.TimerTab.frame:SetWidth(                200 )

-------------------------------------------------------------------------------------
--  new button  
window.TimerTab.button                        = Turbine.UI.Button()
window.TimerTab.button:SetParent(               window.TimerTab.frame )
window.TimerTab.button:SetPosition(             2,2 )
window.TimerTab.button:SetBackColor(            Turbine.UI.Color.Black )
window.TimerTab.button:SetFont(             Defaults.Fonts.SmallFont )
window.TimerTab.button:SetTextAlignment(    Turbine.UI.ContentAlignment.MiddleCenter)

window.TimerTab.button:SetText(         "New" )
window.TimerTab.button:SetSize(                30, 20 )

-------------------------------------------------------------------------------------
--  serachBoxBox
window.TimerTab.searchText = ""

window.TimerTab.serachBox                    = Turbine.UI.Lotro.TextBox()
window.TimerTab.serachBox:SetParent(           window.TimerTab.frame )
window.TimerTab.serachBox:SetPosition(         34,2 )
window.TimerTab.serachBox:SetSize(             164, 20)
window.TimerTab.serachBox:SetTextAlignment(    Turbine.UI.ContentAlignment.MiddleLeft)
window.TimerTab.serachBox:SetFont(             Defaults.Fonts.SmallFont )
window.TimerTab.serachBox:SetForeColor(       Turbine.UI.Color.White)
window.TimerTab.serachBox:SetText(             L[Language.Local].Text.SearchBoxDefault)

window.TimerTab.serachBox.FocusGained = function(sender, args)
    if window.TimerTab.searchText == "" then
        window.TimerTab.serachBox:SetText("")
    end		
end
window.TimerTab.serachBox.FocusLost = function(sender, args)
    if window.TimerTab.searchText == "" then
        window.TimerTab.serachBox:SetText(L[Language.Local].Text.SearchBoxDefault )
    end
end
window.TimerTab.serachBox.TextChanged = function(sender, args)		
    window.TimerTab.searchText = string.lower(window.TimerTab.serachBox:GetText())
end

window.TimerTab.list                 = Turbine.UI.ListBox()
window.TimerTab.list:SetParent(        window.TimerTab.frame)
window.TimerTab.list:SetPosition(      2, 24 )
window.TimerTab.list:SetBackColor(     Defaults.Colors.BackgroundColor1 )
window.TimerTab.list:SetWidth(         196 )





-------------------------------------------------------------------------------------
--      Description:    timertabwindow
-------------------------------------------------------------------------------------
window.TimerTab.TabWindow = Options.Constructor.TabWindow( window.TimerTab, 490, 98 )
window.TimerTab.TabWindow:SetPosition(210, 40)

window.TimerTab.GeneralTab = Options.Constructor.Tab( 480, L[Language.Local].Tab.General, window.TimerTab.TabWindow )


-------------------------------------------------------------------------------------
--      Description:    TriggerTab
-------------------------------------------------------------------------------------
window.TimerTab.TriggerTab = Options.Constructor.Tab( 485, L[Language.Local].Tab.Trigger, window.TimerTab.TabWindow )

-------------------------------------------------------------------------------------
-- background

window.TimerTab.TriggerTab.background                   = Turbine.UI.Control()
window.TimerTab.TriggerTab.background:SetParent(          window.TimerTab.TriggerTab )
window.TimerTab.TriggerTab.background:SetPosition(        5, 35 )
window.TimerTab.TriggerTab.background:SetMouseVisible(    false )
window.TimerTab.TriggerTab.background:SetWidth(           696 )

-------------------------------------------------------------------------------------
--  frame  
window.TimerTab.TriggerTab.frame                        = Turbine.UI.Control()
window.TimerTab.TriggerTab.frame:SetParent(               window.TimerTab.TriggerTab.background )
window.TimerTab.TriggerTab.frame:SetPosition(             5, 5 )
window.TimerTab.TriggerTab.frame:SetBackColor(            Defaults.Colors.BackgroundColor6 )
window.TimerTab.TriggerTab.frame:SetMouseVisible(         false )
window.TimerTab.TriggerTab.frame:SetWidth(                200 )

-------------------------------------------------------------------------------------
--  new button  
window.TimerTab.button                        = Turbine.UI.Button()
window.TimerTab.button:SetParent(               window.TimerTab.TriggerTab.frame )
window.TimerTab.button:SetPosition(             2,2 )
window.TimerTab.button:SetBackColor(            Turbine.UI.Color.Black )
window.TimerTab.button:SetFont(             Defaults.Fonts.SmallFont )
window.TimerTab.button:SetTextAlignment(    Turbine.UI.ContentAlignment.MiddleCenter)

window.TimerTab.button:SetText(         "New" )
window.TimerTab.button:SetSize(                30, 20 )


-------------------------------------------------------------------------------------
--  serachBoxBox
window.TimerTab.TriggerTab.searchText = ""

window.TimerTab.TriggerTab.serachBox                    = Turbine.UI.Lotro.TextBox()
window.TimerTab.TriggerTab.serachBox:SetParent(           window.TimerTab.TriggerTab.frame )
window.TimerTab.TriggerTab.serachBox:SetPosition(         34,2 )
window.TimerTab.TriggerTab.serachBox:SetSize(             164, 20)
window.TimerTab.TriggerTab.serachBox:SetTextAlignment(    Turbine.UI.ContentAlignment.MiddleLeft)
window.TimerTab.TriggerTab.serachBox:SetFont(             Defaults.Fonts.SmallFont )
window.TimerTab.TriggerTab.serachBox:SetForeColor(       Turbine.UI.Color.White)
window.TimerTab.TriggerTab.serachBox:SetText(             L[Language.Local].Text.SearchBoxDefault)


window.TimerTab.TriggerTab.serachBox.FocusGained = function(sender, args)
    if window.TimerTab.TriggerTab.searchText == "" then
        window.TimerTab.TriggerTab.serachBox:SetText("")
    end		
end
window.TimerTab.TriggerTab.serachBox.FocusLost = function(sender, args)
    if window.TimerTab.TriggerTab.searchText == "" then
        window.TimerTab.TriggerTab.serachBox:SetText(L[Language.Local].Text.SearchBoxDefault )
    end
end
window.TimerTab.TriggerTab.serachBox.TextChanged = function(sender, args)		
    window.TimerTab.TriggerTab.searchText = string.lower(window.TimerTab.TriggerTab.serachBox:GetText())
end

window.TimerTab.TriggerTab.list                 = Turbine.UI.ListBox()
window.TimerTab.TriggerTab.list:SetParent(        window.TimerTab.TriggerTab.frame)
window.TimerTab.TriggerTab.list:SetPosition(      2, 24 )
window.TimerTab.TriggerTab.list:SetBackColor(     Defaults.Colors.BackgroundColor1 )
window.TimerTab.TriggerTab.list:SetWidth(         196 )

window.TimerTab.TriggerTab.SizeChanged = function ()

    local height = window.TimerTab.TriggerTab:GetHeight()

    window.TimerTab.TriggerTab.background:SetHeight(height - 30)
    window.TimerTab.TriggerTab.frame:SetHeight(height - 40)
    window.TimerTab.TriggerTab.list:SetHeight(height - 66)

end

window.TimerTab.TimerTab = Options.Constructor.Tab( 480, L[Language.Local].Tab.Timer, window.TimerTab.TabWindow )
window.TimerTab.TextTab = Options.Constructor.Tab( 480, L[Language.Local].Tab.Text, window.TimerTab.TabWindow )
window.TimerTab.AnimationTab = Options.Constructor.Tab( 480, L[Language.Local].Tab.Animation, window.TimerTab.TabWindow )

window.TimerTab.TabWindow:AddTab(window.TimerTab.GeneralTab)
window.TimerTab.TabWindow:AddTab(window.TimerTab.TriggerTab)
window.TimerTab.TabWindow:AddTab(window.TimerTab.TimerTab)
window.TimerTab.TabWindow:AddTab(window.TimerTab.TextTab)
window.TimerTab.TabWindow:AddTab(window.TimerTab.AnimationTab)