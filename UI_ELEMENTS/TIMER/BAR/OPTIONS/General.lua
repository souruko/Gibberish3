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

    self.description = Options.Elements.TextBoxRow( Options.Defaults.window.basecolor, "options", "description", "TODO", 50, true )
    self.description:SetParent( self )
    self.description:SetPosition( left, top )
    
    top = top + 55

    self.permanent = Options.Elements.CheckBoxRow( Options.Defaults.window.basecolor, "options", "permanent2", "TODO", 30 )
    self.permanent:SetParent( self )
    self.permanent:SetPosition( left, top )
    
    top = top + 35

    self.stacking = Options.Elements.DropDownRow( Options.Defaults.window.basecolor, "options", "stacking", "TODO", 30 )
    self.stacking:SetParent( self )
    self.stacking:SetPosition( left, top )
    for name, value in pairs(Stacking) do
        self.stacking:AddItem( "stacking", name, value)
    end

    top = top + 35

    self.loop = Options.Elements.CheckBoxRow( Options.Defaults.window.basecolor, "options", "loop", "TODO", 30 )
    self.loop:SetParent( self )
    self.loop:SetPosition( left, top )
    
    top = top + 35
    
    self.reset = Options.Elements.CheckBoxRow( Options.Defaults.window.basecolor, "options", "reset", "TODO", 30 )
    self.reset:SetParent( self )
    self.reset:SetPosition( left, top )
    
    top = top + 35
        
    self.useCustomTimer = Options.Elements.CheckBoxRow( Options.Defaults.window.basecolor, "options", "useCustomTimer", "TODO", 30 )
    self.useCustomTimer:SetParent( self )
    self.useCustomTimer:SetPosition( left, top )
    
    top = top + 35

    self.timerValue = Options.Elements.TextBoxRow( Options.Defaults.window.basecolor, "options", "timerValue", "TODO", 30 )
    self.timerValue:SetParent( self )
    self.timerValue:SetPosition( left, top )
    
    top = top + 35

    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function GeneralOptions:ResetContent()

    self.description:SetText( self.data.description )
    self.permanent:SetChecked( self.data.permanent )
    self.stacking:SetSelection( self.data.stacking )
    self.loop:SetChecked( self.data.loop )
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
    self.reset:SetWidth( width )
    self.useCustomTimer:SetWidth( width )
    self.timerValue:SetWidth( width )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function GeneralOptions:Save()

    self.data.description   = self.description:GetText(  )
    self.data.permanent      = self.permanent:IsChecked(  )
    self.data.stacking      = self.stacking:GetSelectedValue(  )
    self.data.loop      = self.loop:IsChecked(  )
    self.data.reset      = self.reset:IsChecked(  )
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
