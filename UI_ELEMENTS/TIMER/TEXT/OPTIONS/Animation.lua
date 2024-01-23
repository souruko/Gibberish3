--=================================================================================================
--= Dropdown AnimationOptions
--= ===============================================================================================
--= 
--=================================================================================================



AnimationOptions = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function AnimationOptions:Constructor( data )
	Turbine.UI.Control.Constructor( self )

    self.data = data

    self:SetVisible( false )

    local left = Options.Defaults.window.tab_c_left
    local top = Options.Defaults.window.tab_c_top

    self.useThreshold = Options.Elements.CheckBoxRow( Options.Defaults.window.basecolor, "options", "useThreshold", "TODO", 30 )
    self.useThreshold:SetParent( self )
    self.useThreshold:SetPosition( left, top )
    
    top = top + 30
    
    self.thresholdValue = Options.Elements.TextBoxRow( Options.Defaults.window.basecolor, "options", "thresholdValue", "TODO", 30 )
    self.thresholdValue:SetParent( self )
    self.thresholdValue:SetPosition( left, top )
    
    top = top + 35

    self.useAnimation = Options.Elements.CheckBoxRow( Options.Defaults.window.basecolor, "options", "useAnimation", "TODO", 30 )
    self.useAnimation:SetParent( self )
    self.useAnimation:SetPosition( left, top )
    
    top = top + 30

    self.animationType = Options.Elements.DropDownRow( Options.Defaults.window.basecolor, "options", "animationType", "TODO", 30 )
    self.animationType:SetParent( self )
    self.animationType:SetPosition( left, top )
    for name, value in pairs(AnimationType) do
        self.animationType:AddItem( "animationType", name, value)
    end

    top = top + 30

    self.animationSpeed = Options.Elements.TextBoxRow( Options.Defaults.window.basecolor, "options", "animationSpeed", "TODO", 30 )
    self.animationSpeed:SetParent( self )
    self.animationSpeed:SetPosition( left, top )
    
    top = top + 35

    self.useShadow = Options.Elements.CheckBoxRow( Options.Defaults.window.basecolor, "options", "useShadow", "TODO", 30 )
    self.useShadow:SetParent( self )
    self.useShadow:SetPosition( left, top )
    
    top = top + 35

    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function AnimationOptions:ResetContent()

    self.thresholdValue:SetText( self.data.thresholdValue )
    self.useThreshold:SetChecked( self.data.useThreshold )
    self.useAnimation:SetChecked( self.data.useAnimation )
    self.useShadow:SetChecked( self.data.useShadow )
    self.animationType:SetSelection( self.data.animationType )
    self.animationSpeed:SetText( self.data.animationSpeed )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function AnimationOptions:SizeChanged()

    local width, height = self:GetSize()
    width = width - 10

    self.thresholdValue:SetWidth( width )
    self.useThreshold:SetWidth( width )
    self.useAnimation:SetWidth( width )
    self.useShadow:SetWidth( width )
    self.animationType:SetWidth( width )
    self.animationSpeed:SetWidth( width )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function AnimationOptions:Save()

    self.data.thresholdValue   = self.thresholdValue:GetText(  )
    self.data.useThreshold      = self.useThreshold:IsChecked(  )
    self.data.useAnimation      = self.useAnimation:IsChecked(  )
    self.data.useShadow      = self.useShadow:IsChecked(  )
    self.data.animationType      = self.animationType:GetSelectedValue(  )
    self.data.animationSpeed      = self.animationSpeed:GetText(  )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function AnimationOptions:Reset()

    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function AnimationOptions:LanguageChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function AnimationOptions:Show()

    self:SetVisible( true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function AnimationOptions:Hide()

    self:SetVisible( false )

end
---------------------------------------------------------------------------------------------------
