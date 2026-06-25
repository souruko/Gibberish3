
-- function table for window constructors
Timer[ Timer.Types.BAR ].Options = function ( parent, data )

    return OptionsWindow( parent, data )

end

OptionsWindow = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function OptionsWindow:Constructor( parent, data )
	Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.data   = data

    self.tabwindow = Options.Elements.TabWindow( 110 )
    self.tabwindow:SetParent( self )
    self.tabwindow:SetLeft( 3 )
    self.tabwindow.frame:SetBackColor( Turbine.UI.Color(0.55, 0.38, 0.08) )
    self.tabwindow.content_back:SetBackColor( Turbine.UI.Color(0.13, 0.10, 0.08) )
    -- self.tabwindow:SetPosition( Options.Defaults.window.spacing, Options.Defaults.window.spacing )

    self.tab_general    = GeneralOptions( self.data )
    self.tab_trigger    = TriggerOptions( self.data )
    self.tab_conditions = ConditionsOptions( self.data )
    self.tab_style      = StyleOptions( self.data )
    self.tab_animation  = AnimationOptions( self.data )

    self.tabwindow:AddTab( self.tab_general,    "tab", "general")
    self.tabwindow:AddTab( self.tab_trigger,    "tab", "trigger")
    self.tabwindow:AddTab( self.tab_conditions, "tab", "conditions")
    self.tabwindow:AddTab( self.tab_style,      "tab", "style")
    self.tabwindow:AddTab( self.tab_animation,  "tab", "animation")

    self.tabwindow:ChangeSelection( Data.options.window.tab2 )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function OptionsWindow:TabSelectionChanged( index )

    Data.options.window.tab2 = index

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function OptionsWindow:LanguageChanged()

    self.tabwindow:LanguageChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function OptionsWindow:Close()


end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function OptionsWindow:SizeChanged()

    local width, height = self:GetSize()

    -- self.tabwindow:SetSize( width - 2*Options.Defaults.window.spacing, height - 2*Options.Defaults.window.spacing )
    self.tabwindow:SetSize( width - 3, height )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function OptionsWindow:Save()

    self.tab_general:Save()
    self.tab_trigger:Save()
    self.tab_conditions:Save()
    self.tab_style:Save()
    self.tab_animation:Save()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function OptionsWindow:Reset()

    self.tab_general:Reset()
    self.tab_trigger:Reset()
    self.tab_conditions:Reset()
    self.tab_style:Reset()
    self.tab_animation:Reset()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function OptionsWindow:TriggerSelectionChanged()

    self.tab_trigger:TriggerSelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function OptionsWindow:ConditionsSelectionChanged()

    self.tab_conditions:TriggerSelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function OptionsWindow:ConditionTriggerSelectionChanged()

    self.tab_conditions:TriggerSelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function OptionsWindow:Trigger2SelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function OptionsWindow:TimerSelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function OptionsWindow:BuildCollectionRightClickMenu( data, menu )

    local height = Options.Defaults.rc_menu.item_height

    local timerSubMenu = Options.Elements.RightClickSubMenu( 150 )
    self.tab_general:BuildCollectionRightClickMenu( data, timerSubMenu )
    self.tab_style:BuildCollectionRightClickMenu( data, timerSubMenu )
    if timerSubMenu:HasRows() then
        menu:AddSubRow( Options.Elements.SubRow( "collection", "sub_timer", timerSubMenu, height ), timerSubMenu )
    end

    local triggerSubMenu = Options.Elements.RightClickSubMenu( 150 )
    self.tab_trigger:BuildCollectionRightClickMenu( data, triggerSubMenu )
    if triggerSubMenu:HasRows() then
        menu:AddSubRow( Options.Elements.SubRow( "collection", "sub_trigger", triggerSubMenu, height ), triggerSubMenu )
    end

    local condSubMenu = Options.Elements.RightClickSubMenu( 150 )
    self.tab_conditions:BuildCollectionRightClickMenu( data, condSubMenu )
    if condSubMenu:HasRows() then
        menu:AddSubRow( Options.Elements.SubRow( "collection", "sub_conditions", condSubMenu, height ), condSubMenu )
    end

end
---------------------------------------------------------------------------------------------------
