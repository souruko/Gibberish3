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

    self.description = Options.Elements.TextBoxRow( Options.Defaults.window.basecolor, "options", "description", "win_description", 50, true )
    self.description:SetParent( self )
    self.description:SetPosition( left, top )
    
    top = top + 55

    self.saveGlobaly = Options.Elements.CheckBoxRow( Options.Defaults.window.basecolor, "options", "saveGlobaly", "win_save_globaly", 30 )
    self.saveGlobaly:SetParent( self )
    self.saveGlobaly:SetPosition( left, top )
    
    top = top + 35
    
    self.resetOnTargetChanged = Options.Elements.CheckBoxRow( Options.Defaults.window.basecolor, "options", "resetOnTargetChanged", "win_reset_on_target_change", 30 )
    self.resetOnTargetChanged:SetParent( self )
    self.resetOnTargetChanged:SetPosition( left, top )
    
    top = top + 35
        
    self.useTargetEntity = Options.Elements.CheckBoxRow( Options.Defaults.window.basecolor, "options", "useTargetEntity", "win_use_target_entity", 30 )
    self.useTargetEntity:SetParent( self )
    self.useTargetEntity:SetPosition( left, top )
    
    top = top + 35

    self.overlay = Options.Elements.CheckBoxRow( Options.Defaults.window.basecolor, "options", "overlay", "win_overlay", 30 )
    self.overlay:SetParent( self )
    self.overlay:SetPosition( left, top )

    top = top + 35

    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function GeneralOptions:ResetContent()

    self.description:SetText( self.data.description )
    self.saveGlobaly:SetChecked( self.data.saveGlobaly )
    self.resetOnTargetChanged:SetChecked( self.data.resetOnTargetChanged )
    self.useTargetEntity:SetChecked( self.data.useTargetEntity )
    self.overlay:SetChecked( self.data.overlay )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function GeneralOptions:SizeChanged()

    local width, height = self:GetSize()
    width = width - 10

    self.description:SetWidth( width )
    self.saveGlobaly:SetWidth( width )
    self.resetOnTargetChanged:SetWidth( width )
    self.useTargetEntity:SetWidth( width )
    self.overlay:SetWidth( width )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function GeneralOptions:Save()

    self.data.description   = self.description:GetText(  )
    self.data.saveGlobaly      = self.saveGlobaly:IsChecked(  )
    self.data.resetOnTargetChanged      = self.resetOnTargetChanged:IsChecked(  )
    self.data.useTargetEntity      = self.useTargetEntity:IsChecked(  )
    self.data.overlay      = self.overlay:IsChecked(  )

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
    self.saveGlobaly:LanguageChanged()
    self.resetOnTargetChanged:LanguageChanged()
    self.useTargetEntity:LanguageChanged()
    self.overlay:LanguageChanged()

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
