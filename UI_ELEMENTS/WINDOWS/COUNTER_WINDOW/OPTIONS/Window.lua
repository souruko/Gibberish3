
-- function table for window constructors
Window[ Window.Types.COUNTER_WINDOW ].Options = function ( parent, data )

    return OptionsWindow( parent, data )

end

OptionsWindow = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function OptionsWindow:Constructor( parent, data )
	Turbine.UI.Control.Constructor( self )

    self.parent = parent
    self.data   = data

    -- self.background1 = Turbine.UI.Control()
    -- self.background1:SetParent(self)
    -- self.background1:SetPosition( Options.Defaults.window.spacing, Options.Defaults.window.spacing )
    -- self.background1:SetHeight( self.height + 2*Options.Defaults.window.spacing )
    -- self.background1:SetBackColor( Options.Defaults.window.basecolor )

    self.tabwindow = Options.Elements.TabWindow( 131 )
    self.tabwindow:SetParent( self )
    self.tabwindow:SetPosition( Options.Defaults.window.spacing, Options.Defaults.window.spacing )

    self.tab_general = GeneralOptions( self.data )
    self.tab_timer = TimerOptions( self.data )
    self.tab_size = SizeOptions( self.data )
    self.tab_color = ColorOptions( self.data )
    self.tab_text = TextOptions( self.data )
    self.tab_trigger = TriggerOptions( self.data )

    self.tabwindow:AddTab( self.tab_general, "tab", "general")
    self.tabwindow:AddTab( self.tab_timer, "tab", "timer")
    self.tabwindow:AddTab( self.tab_size, "tab", "size")
    self.tabwindow:AddTab( self.tab_color, "tab", "color")
    self.tabwindow:AddTab( self.tab_text, "tab", "text")
    self.tabwindow:AddTab( self.tab_trigger, "tab", "trigger")

    self.tabwindow:ChangeSelection( Data.options.window.tab1 )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function OptionsWindow:TabSelectionChanged( index )

    Data.options.window.tab1 = index

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function OptionsWindow:Close()


end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function OptionsWindow:SizeChanged()

    local width, height = self:GetSize()

    self.tabwindow:SetSize( width - 2*Options.Defaults.window.spacing, height - 2*Options.Defaults.window.spacing )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function OptionsWindow:Save()

    self.tab_general:Save()
    self.tab_timer:Save()
    self.tab_size:Save()
    self.tab_text:Save()
    self.tab_trigger:Save()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function OptionsWindow:Reset()

    self.tab_general:Reset()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function OptionsWindow:TriggerSelectionChanged()

    self.tab_timer:TriggerSelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function OptionsWindow:Trigger2SelectionChanged()

    self.tab_trigger:Trigger2SelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function OptionsWindow:TimerSelectionChanged()

    self.tab_timer:TimerSelectionChanged()

end
---------------------------------------------------------------------------------------------------
