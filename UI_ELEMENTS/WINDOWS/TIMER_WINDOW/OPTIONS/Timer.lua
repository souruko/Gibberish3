--=================================================================================================
--= Dropdown TimerOptions
--= ===============================================================================================
--= 
--=================================================================================================



TimerOptions = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function TimerOptions:Constructor( data )
	Turbine.UI.Control.Constructor( self )

    self.data = data

    self:SetVisible( false )

    local left = Options.Defaults.window.tab_c_left
    local top = Options.Defaults.window.tab_c_top

    self.timerType = Options.Elements.DropDownRow( Options.Defaults.window.basecolor, "options", "timerType", "win_timer_type", 30 )
    self.timerType:SetParent( self )
    self.timerType:SetPosition( left, top )

    if self.data.type == Window.Types.TIMER_WINDOW then
        self.timerType:AddItem( "type", Timer.Types.BAR, Timer.Types.BAR)
        self.timerType:AddItem( "type", Timer.Types.ICON, Timer.Types.ICON)
        self.timerType:AddItem( "type", Timer.Types.TEXT, Timer.Types.TEXT)
        self.timerType:AddItem( "type", Timer.Types.CIRCEL, Timer.Types.CIRCEL)

    elseif self.data.type == Window.Types.COUNTER_WINDOW then
        self.timerType:AddItem( "type", Timer.Types.COUNTER_BAR, Timer.Types.COUNTER_BAR)

    end
    
    top = top + 35
    
    self.background1 = Turbine.UI.Control()
    self.background1:SetParent(self)
    self.background1:SetPosition( Options.Defaults.window.tab_c_left, top )
    -- self.background1:SetHeight( self.height + 2*Options.Defaults.window.spacing )
    self.background1:SetBackColor( Options.Defaults.window.basecolor )

    self.listbox = Options.Elements.TimerListbox( self.data.type, self )
    self.listbox:SetParent( self.background1 )
    self.listbox:SetPosition( Options.Defaults.window.spacing, Options.Defaults.window.spacing )
    -- self.listbox:SetSize( 200, self.height )
    self.listbox:SetWidth( 200 )

    self.listbox:ContentChanged( self.data )
    self.timerOptions = nil

    self:ResetContent()

    self:TimerSelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TimerOptions:ResetContent()

    self.timerType:SetSelection( self.data.timerType )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TimerOptions:SizeChanged()

    local width, height = self:GetSize()
    local content_height = height - Options.Defaults.window.tab_c_top - Options.Defaults.window.spacing -35

    self.timerType:SetWidth( width - 2*Options.Defaults.window.spacing )

    self.background1:SetSize( width - 2*Options.Defaults.window.spacing, content_height )
    self.listbox:SetHeight( content_height - 2*Options.Defaults.window.spacing )

    if self.timerOptions ~= nil then
        self.timerOptions:SetWidth( width - 200 - (3*Options.Defaults.window.spacing) )
        self.timerOptions:SetHeight( self.listbox:GetHeight() + 2*Options.Defaults.window.spacing )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TimerOptions:Save()

    local timerType = self.timerType:GetSelectedValue(  )

    if timerType ~= self.data.timerType then

        self.data.timerType = timerType

        for index, timerData in ipairs(self.data.timerList) do
            timerData.type = self.data.timerType
        end

    end

    if self.timerOptions == nil  then
        return
    end

    self.timerOptions:Save()
    self.listbox:UpdateData()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TimerOptions:Reset()

    self:ResetContent()
    
    if self.timerOptions == nil  then
        return
    end

    self.timerOptions:Reset()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TimerOptions:LanguageChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TimerOptions:Show()

    self:SetVisible( true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TimerOptions:Hide()

    self:SetVisible( false )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TimerOptions:TimerSelectionChanged()

    self.listbox:TimerSelectionChanged()

    -- close old
    if self.timerOptions ~= nil then
        self.timerOptions:Close()
        self.timerOptions:SetParent()
        self.timerOptions = nil
    end

    if Data.selectedTimerIndex ~= 0 then
        local timerData = self.data.timerList[ Data.selectedTimerIndex ]

        self.timerOptions = Timer[ timerData.type ].Options( self, timerData, 0 )
        self.timerOptions:SetParent( self.background1 )
        self.timerOptions:SetPosition( 200 + (Options.Defaults.window.spacing), 0 )
        self:SizeChanged()

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TimerOptions:TriggerSelectionChanged()

    if self.timerOptions == nil  then
        return
    end

    self.timerOptions:TriggerSelectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TimerOptions:DeleteTimer( timerIndex )

    Options.DeleteTimer( self.data, timerIndex )
    self.listbox:ContentChanged( self.data )
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TimerOptions:CopyTimer( timerData )

    local timer = Timer.Copy( timerData )
    local index = #self.data.timerList + 1

    self.data.timerList[ index ] = timer
    self.listbox:ContentChanged( self.data )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TimerOptions:DraggingEnd( timerData )

    self.listbox:DraggingEnd( timerData )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TimerOptions:BuildCollectionRightClickMenu( data, menu )

    if self.timerOptions == nil then
        return
    end

    self.timerOptions:BuildCollectionRightClickMenu( data, menu )

end
---------------------------------------------------------------------------------------------------
