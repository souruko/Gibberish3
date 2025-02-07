--=================================================================================================
--= Dropdown GeneralOptions
--= ===============================================================================================
--= 
--=================================================================================================



GeneralOptions = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function GeneralOptions:Constructor( data )
	Turbine.UI.Control.Constructor( self )

    self.data = data

    self:SetVisible( false )

    local left = Options.Defaults.window.tab_c_left
    local top = Options.Defaults.window.tab_c_top

    self.description = Options.Elements.TextBoxRow( Options.Defaults.window.basecolor, "options", "description", "tim_description", 50, true )
    self.description:SetParent( self )
    self.description:SetPosition( left, top )
    
    top = top + 55

    self.permanent = Options.Elements.CheckBoxRow( Options.Defaults.window.basecolor, "options", "permanent2", "tim_permanent2", 30 )
    self.permanent:SetParent( self )
    self.permanent:SetPosition( left, top )
    
    top = top + 35

    self.stacking = Options.Elements.DropDownRow( Options.Defaults.window.basecolor, "options", "stacking", "tim_stacking", 30 )
    self.stacking:SetParent( self )
    self.stacking:SetPosition( left, top )
    for name, value in pairs(Stacking) do
        self.stacking:AddItem( "stacking", name, value)
    end

    top = top + 35

    self.loop = Options.Elements.CheckBoxRow( Options.Defaults.window.basecolor, "options", "loop", "tim_loop", 30 )
    self.loop:SetParent( self )
    self.loop:SetPosition( left, top )
    
    top = top + 35
    
    self.reset = Options.Elements.CheckBoxRow( Options.Defaults.window.basecolor, "options", "reset", "tim_reset", 30 )
    self.reset:SetParent( self )
    self.reset:SetPosition( left, top )
    
    top = top + 35
          
    self.protect = Options.Elements.CheckBoxRow( Options.Defaults.window.basecolor, "options", "proctect", "tim_proctect", 30 )
    self.protect:SetParent( self )
    self.protect:SetPosition( left, top )
    
    top = top + 35
        
    self.useCustomTimer = Options.Elements.CheckBoxRow( Options.Defaults.window.basecolor, "options", "useCustomTimer", "tim_use_custom_timer", 30 )
    self.useCustomTimer:SetParent( self )
    self.useCustomTimer:SetPosition( left, top )
    
    top = top + 35

    self.timerValue = Options.Elements.TextBoxRow( Options.Defaults.window.basecolor, "options", "timerValue", "tim_timer_value", 30 )
    self.timerValue:SetParent( self )
    self.timerValue:SetPosition( left, top )
    
    top = top + 35

    self.testTimerButton = Turbine.UI.Lotro.Button()
    self.testTimerButton:SetParent(self)
    self.testTimerButton:SetPosition( left, top )
    self.testTimerButton:SetWidth(150)
    self.testTimerButton:SetText("Test Timer")
    self.testTimerButton.MouseClick = function ()

        local windowIndex = Data.selectedIndex
        local timerIndex = Data.selectedTimerIndex
        
        local fakeTriggerData = {}
        fakeTriggerData.action = Action.Add

        local startTime = Turbine.Engine.GetGameTime()

        local duration = 10
        if self.data.useCustomTimer == true then
            duration = self.data.timerValue
        end

        local icon = self.data.icon

        local text = ""
        if self.data.textOption == TimerTextOptions.Target then
            text = LocalPlayer:GetName()
        elseif self.data.textOption == TimerTextOptions.Token then
            text = "token"
        elseif self.data.textOption == TimerTextOptions.CustomText then
            text = self.data.textValue
        end

        local entity = nil

        local key = nil
        if self.data.stacking == Stacking.Multi then
            key              = startTime
        end

        Windows[ windowIndex ]:TimerAction( fakeTriggerData, self.data, timerIndex, startTime , duration, icon, text, entity, key )
      
    end

    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function GeneralOptions:ResetContent()

    self.description:SetText( self.data.description )
    self.permanent:SetChecked( self.data.permanent )
    self.stacking:SetSelection( self.data.stacking )
    self.loop:SetChecked( self.data.loop )
    self.protect:SetChecked( self.data.protect )
    self.reset:SetChecked( self.data.reset )
    self.useCustomTimer:SetChecked( self.data.useCustomTimer )
    self.timerValue:SetText( self.data.timerValue )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function GeneralOptions:SizeChanged()

    local width, height = self:GetSize()
    width = width - 10

    self.description:SetWidth( width )
    self.permanent:SetWidth( width )
    self.stacking:SetWidth( width )
    self.loop:SetWidth( width )
    self.protect:SetWidth( width )
    self.reset:SetWidth( width )
    self.useCustomTimer:SetWidth( width )
    self.timerValue:SetWidth( width )

    self.testTimerButton:SetLeft( (width / 2) - 75 )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function GeneralOptions:Save()

    self.data.description   = self.description:GetText(  )
    self.data.permanent      = self.permanent:IsChecked(  )
    self.data.stacking      = self.stacking:GetSelectedValue(  )
    self.data.loop      = self.loop:IsChecked(  )
    self.data.reset      = self.reset:IsChecked(  )
    self.data.protect      = self.protect:IsChecked(  )
    self.data.useCustomTimer      = self.useCustomTimer:IsChecked(  )
    self.data.timerValue      = self.timerValue:GetText(  )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function GeneralOptions:Reset()

    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function GeneralOptions:LanguageChanged()

    self.description:LanguageChanged()
    self.permanent:LanguageChanged()
    self.stacking:LanguageChanged()
    self.loop:LanguageChanged()
    self.protect:LanguageChanged()
    self.reset:LanguageChanged()
    self.useCustomTimer:LanguageChanged()
    self.timerValue:LanguageChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function GeneralOptions:Show()

    self:SetVisible( true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function GeneralOptions:Hide()

    self:SetVisible( false )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function GeneralOptions:BuildCollectionRightClickMenu( data, menu )

    
    if data.timer ~= nil then
        local row2 =  Options.Elements.Row(
            "collection",
            "timer",
            function ()
                self.useCustomTimer:SetChecked( true )
                self.timerValue:SetText( data.timer )
            end,
            Options.Defaults.rc_menu.item_height
        )
        menu:AddRow( row2 )
    end

end
---------------------------------------------------------------------------------------------------
