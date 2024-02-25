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

    self.loop = Options.Elements.CheckBoxRow( Options.Defaults.window.basecolor, "options", "loop", "tim_loop", 30 )
    self.loop:SetParent( self )
    self.loop:SetPosition( left, top )
    
    top = top + 35
    
    self.reset = Options.Elements.CheckBoxRow( Options.Defaults.window.basecolor, "options", "reset", "tim_reset", 30 )
    self.reset:SetParent( self )
    self.reset:SetPosition( left, top )
    
    top = top + 35
       
    self.counterEND = Options.Elements.NumberBoxRow( Options.Defaults.window.basecolor, "options", "counterEND", "tim_counter_end", 30 )
    self.counterEND:SetParent( self )
    self.counterEND:SetPosition( left, top )
    
    top = top + 30
  
    self.counterSTART = Options.Elements.NumberBoxRow( Options.Defaults.window.basecolor, "options", "counterSTART", "tim_counter_start", 30 )
    self.counterSTART:SetParent( self )
    self.counterSTART:SetPosition( left, top )
    
    top = top + 35

    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function GeneralOptions:ResetContent()

    self.description:SetText( self.data.description )
    self.loop:SetChecked( self.data.loop )
    self.reset:SetChecked( self.data.reset )
    self.counterEND:SetText( self.data.counterEND )
    self.counterSTART:SetText( self.data.counterSTART )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function GeneralOptions:SizeChanged()

    local width, height = self:GetSize()
    width = width - 10

    self.description:SetWidth( width )
    self.loop:SetWidth( width )
    self.reset:SetWidth( width )
    self.counterEND:SetWidth( width )
    self.counterSTART:SetWidth( width )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function GeneralOptions:Save()

    self.data.description   = self.description:GetText(  )
    self.data.loop      = self.loop:IsChecked(  )
    self.data.reset      = self.reset:IsChecked(  )
    self.data.counterEND      = self.counterEND:GetText(  )
    self.data.counterSTART      = self.counterSTART:GetText(  )

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
    self.loop:LanguageChanged()
    self.protect:LanguageChanged()
    self.reset:LanguageChanged()
    self.counterEND:LanguageChanged( )
    self.counterSTART:LanguageChanged( )

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
