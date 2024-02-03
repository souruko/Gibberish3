--=================================================================================================
--= Dropdown TextOptions
--= ===============================================================================================
--= 
--=================================================================================================



TextOptions = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function TextOptions:Constructor( data )
	Turbine.UI.Control.Constructor( self )

    self.data = data

    self:SetVisible( false )

    local left = Options.Defaults.window.tab_c_left
    local top = Options.Defaults.window.tab_c_top

    self.font = Options.Elements.DropDownRow( Options.Defaults.window.basecolor, "options", "font", "win_font", 30 )
    self.font:SetParent( self )
    self.font:SetPosition( left, top )
    for name, value in pairs(Font.Type) do
        self.font:AddItem( "font", name, value)
    end
    self.font:Sort()
    self.font.SelectionChanged = function ( sender, index, value )
        self:FontChanged( sender, index, value )
    end

    top = top + 30

    self.fontSize = Options.Elements.DropDownRow( Options.Defaults.window.basecolor, "options", "fontSize", "win_font_size", 30 )
    self.fontSize:SetParent( self )
    self.fontSize:SetPosition( left, top )

    top = top + 35
    
    self.numberFormat = Options.Elements.DropDownRow( Options.Defaults.window.basecolor, "options", "numberFormat", "win_number_format", 30 )
    self.numberFormat:SetParent( self )
    self.numberFormat:SetPosition( left, top )
    for name, value in pairs(NumberFormat) do
        self.numberFormat:AddItem( "numberFormat", name, value)
    end
    self.numberFormat:Sort()
    top = top + 35
    
    self.textAlignment = Options.Elements.DropDownRow( Options.Defaults.window.basecolor, "options", "textAlignment", "win_text_align", 30 )
    self.textAlignment:SetParent( self )
    self.textAlignment:SetPosition( left, top )
    for name, value in pairs(Alignment) do
        self.textAlignment:AddItem( "alignment", name, value)
    end
    self.textAlignment:Sort()

    top = top + 30
    
    self.timerAlignment = Options.Elements.DropDownRow( Options.Defaults.window.basecolor, "options", "timerAlignment", "win_timer_align", 30 )
    self.timerAlignment:SetParent( self )
    self.timerAlignment:SetPosition( left, top )
    for name, value in pairs(Alignment) do
        self.timerAlignment:AddItem( "alignment", name, value)
    end
    self.timerAlignment:Sort()

    top = top + 35

    self.showTimer = Options.Elements.CheckBoxRow( Options.Defaults.window.basecolor, "options", "showTimer", "win_show_timer", 30 )
    self.showTimer:SetParent( self )
    self.showTimer:SetPosition( left, top )

    top = top + 35

    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TextOptions:FontChanged( sender, index, value )

    local size
    for key, font in pairs(Font[ value ]) do
        size = key
        break
    end

    self.fontSize:ClearItems()
    for name, font in pairs(Font[ value ]) do
        self.fontSize:AddItem( "fontSize", name, name)
    end
    self.fontSize:Sort()
    self.fontSize:SetSelection( size )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TextOptions:ResetContent()

    self.font:SetSelection( self.data.font )
    self.fontSize:ClearItems()
    for name, value in pairs(Font[ self.data.font ]) do
        self.fontSize:AddItem( "fontSize", name, name)
    end
    self.fontSize:Sort()
    self.fontSize:SetSelection( self.data.fontSize )

    self.numberFormat:SetSelection( self.data.durationFormat )
    self.textAlignment:SetSelection( self.data.textAlignment )
    self.timerAlignment:SetSelection( self.data.timerAlignment )
    self.showTimer:SetChecked( self.data.showTimer )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TextOptions:SizeChanged()

    local width, height = self:GetSize()
    width = width - 10

    self.font:SetWidth( width )
    self.fontSize:SetWidth( width )
    self.numberFormat:SetWidth( width )
    self.textAlignment:SetWidth( width )
    self.timerAlignment:SetWidth( width )
    self.showTimer:SetWidth( width )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TextOptions:Save()

    self.data.font = self.font:GetSelectedValue(  )
    self.data.fontSize = self.fontSize:GetSelectedValue(  )
    self.data.durationFormat = self.numberFormat:GetSelectedValue(  )
    self.data.textAlignment = self.textAlignment:GetSelectedValue(  )
    self.data.timerAlignment = self.timerAlignment:GetSelectedValue(  )
    self.data.showTimer = self.showTimer:IsChecked(  )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TextOptions:Reset()

    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TextOptions:LanguageChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TextOptions:Show()

    self:SetVisible( true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TextOptions:Hide()

    self:SetVisible( false )

end
---------------------------------------------------------------------------------------------------
