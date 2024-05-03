--=================================================================================================
--= Dropdown ColorOptions
--= ===============================================================================================
--= 
--=================================================================================================



ColorOptions = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function ColorOptions:Constructor( data )
	Turbine.UI.Control.Constructor( self )

    self.data = data

    self:SetVisible( false )

    local left = Options.Defaults.window.tab_c_left
    local top = Options.Defaults.window.tab_c_top

    --color
    self.color1 = Options.Elements.ColorBoxRow( Options.Defaults.window.basecolor, "options", "color1", "win_color_frame", 30, false )
    self.color1:SetParent( self )
    self.color1:SetPosition( left, top )
    
    top = top + 30

    self.color2 = Options.Elements.ColorBoxRow( Options.Defaults.window.basecolor, "options", "color2", "win_color_back", 30, false )
    self.color2:SetParent( self )
    self.color2:SetPosition( left, top )
    
    top = top + 30

    self.color3 = Options.Elements.ColorBoxRow( Options.Defaults.window.basecolor, "options", "color3", "win_color_bar", 30, false )
    self.color3:SetParent( self )
    self.color3:SetPosition( left, top )
    
    top = top + 30

    self.color4 = Options.Elements.ColorBoxRow( Options.Defaults.window.basecolor, "options", "color4", "win_color_timer", 30, false )
    self.color4:SetParent( self )
    self.color4:SetPosition( left, top )
    
    top = top + 30

    self.color5 = Options.Elements.ColorBoxRow( Options.Defaults.window.basecolor, "options", "color5", "win_color_text", 30, false )
    self.color5:SetParent( self )
    self.color5:SetPosition( left, top )
    
    top = top + 30

    self.color6 = Options.Elements.ColorBoxRow( Options.Defaults.window.basecolor, "options", "color6", "win_color_outline", 30, false )
    self.color6:SetParent( self )
    self.color6:SetPosition( left, top )
    
    top = top + 35

    self.color7 = Options.Elements.ColorBoxRow( Options.Defaults.window.basecolor, "options", "color7", "win_color_threshold", 30, false )
    self.color7:SetParent( self )
    self.color7:SetPosition( left, top )
    
    top = top + 30

    self.color8 = Options.Elements.ColorBoxRow( Options.Defaults.window.basecolor, "options", "color8", "win_color_thresholdTimer", 30, false )
    self.color8:SetParent( self )
    self.color8:SetPosition( left, top )
    
    top = top + 30

    self.color9 = Options.Elements.ColorBoxRow( Options.Defaults.window.basecolor, "options", "color9", "win_color_thresholdText", 30, false )
    self.color9:SetParent( self )
    self.color9:SetPosition( left, top )
    
    top = top + 35

    -- opacity
    self.opacityActiv = Options.Elements.NumberBoxRow( Options.Defaults.window.basecolor, "options", "opacityActiv", "win_opacity_activ", 30 )
    self.opacityActiv:SetParent( self )
    self.opacityActiv:SetPosition( left, top )
    
    top = top + 30
    
    self.opacityPassiv = Options.Elements.NumberBoxRow( Options.Defaults.window.basecolor, "options", "opacityPassiv", "win_opacity_passiv", 30 )
    self.opacityPassiv:SetParent( self )
    self.opacityPassiv:SetPosition( left, top )
    
    top = top + 30
    
    self.opacityThreshold = Options.Elements.NumberBoxRow( Options.Defaults.window.basecolor, "options", "opacityThreshold", "win_opacity_theshold", 30 )
    self.opacityThreshold:SetParent( self )
    self.opacityThreshold:SetPosition( left, top )
    
    top = top + 35

    self:ResetContent()
    
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ColorOptions:ResetContent()

    self.color1:SetText( self.data.color1 )
    self.color2:SetText( self.data.color2 )
    self.color3:SetText( self.data.color3 )
    self.color4:SetText( self.data.color4 )
    self.color5:SetText( self.data.color5 )
    self.color6:SetText( self.data.color6 )
    self.color7:SetText( self.data.color7 )
    self.color8:SetText( self.data.color8 )
    self.color9:SetText( self.data.color9 )

    self.opacityActiv:SetText( self.data.opacityActiv )
    self.opacityPassiv:SetText( self.data.opacityPassiv )
    self.opacityThreshold:SetText( self.data.opacityThreshold )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ColorOptions:SizeChanged()

    local width, height = self:GetSize()
    width = width - 10

    self.color1:SetWidth( width )
    self.color2:SetWidth( width )
    self.color3:SetWidth( width )
    self.color4:SetWidth( width )
    self.color5:SetWidth( width )
    self.color6:SetWidth( width )
    self.color7:SetWidth( width )
    self.color8:SetWidth( width )
    self.color9:SetWidth( width )
    
    self.opacityActiv:SetWidth( width )
    self.opacityPassiv:SetWidth( width )
    self.opacityThreshold:SetWidth( width )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ColorOptions:Save()

    self.data.color1   = self.color1:GetText(  )
    self.data.color2   = self.color2:GetText(  )
    self.data.color3   = self.color3:GetText(  )
    self.data.color4   = self.color4:GetText(  )
    self.data.color5   = self.color5:GetText(  )
    self.data.color6   = self.color6:GetText(  )
    self.data.color7   = self.color7:GetText(  )
    self.data.color8   = self.color8:GetText(  )
    self.data.color9   = self.color9:GetText(  )

    self.data.opacityActiv   = self.opacityActiv:GetText(  )
    self.data.opacityPassiv  = self.opacityPassiv:GetText(  )
    self.data.opacityThreshold  = self.opacityThreshold:GetText(  )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ColorOptions:Reset()

    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ColorOptions:LanguageChanged()

    self.color1:LanguageChanged()
    self.color2:LanguageChanged()
    self.color3:LanguageChanged()
    self.color4:LanguageChanged()
    self.color5:LanguageChanged()
    self.color6:LanguageChanged()
    self.color7:LanguageChanged()
    self.color8:LanguageChanged()
    self.color9:LanguageChanged()

    self.opacityActiv:LanguageChanged()
    self.opacityPassiv:LanguageChanged()
    self.opacityThreshold:LanguageChanged()
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ColorOptions:Show()

    self:SetVisible( true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function ColorOptions:Hide()

    self:SetVisible( false )

end
---------------------------------------------------------------------------------------------------
