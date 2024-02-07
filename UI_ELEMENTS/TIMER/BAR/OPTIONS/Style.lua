--=================================================================================================
--= Dropdown StyleOptions
--= ===============================================================================================
--= 
--=================================================================================================



StyleOptions = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function StyleOptions:Constructor( data )
	Turbine.UI.Control.Constructor( self )

    self.data = data

    self:SetVisible( false )

    local left = Options.Defaults.window.tab_c_left
    local top = Options.Defaults.window.tab_c_top

    self.icon = Options.Elements.IconBoxRow( Options.Defaults.window.basecolor, "options", "icon", "tim_icon", 42 )
    self.icon:SetParent( self )
    self.icon:SetPosition( left, top )

    top = top + 47

    self.showIcon = Options.Elements.CheckBoxRow( Options.Defaults.window.basecolor, "options", "showIcon", "tim_show_icon", 30 )
    self.showIcon:SetParent( self )
    self.showIcon:SetPosition( left, top )
    
    top = top + 35
    
    self.textOption = Options.Elements.DropDownRow( Options.Defaults.window.basecolor, "options", "textOption", "tim_text_option", 30 )
    self.textOption:SetParent( self )
    self.textOption:SetPosition( left, top )
    for name, value in pairs(TimerTextOptions) do
        self.textOption:AddItem( "textOption", name, value)
    end

    top = top + 35

    self.textValue = Options.Elements.TextBoxRow( Options.Defaults.window.basecolor, "options", "textValue", "tim_text_value", 30, false )
    self.textValue:SetParent( self )
    self.textValue:SetPosition( left, top )
    
    top = top + 35

    self.direction = Options.Elements.DropDownRow( Options.Defaults.window.basecolor, "options", "direction", "tim_direction", 30 )
    self.direction:SetParent( self )
    self.direction:SetPosition( left, top )
    for name, value in pairs(Direction) do
        self.direction:AddItem( "direction", name, value)
    end

    top = top + 35

    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function StyleOptions:ResetContent()

    self.icon:SetText( self.data.icon )
    self.showIcon:SetChecked( self.data.showIcon )
    self.textOption:SetSelection( self.data.textOption )
    self.textValue:SetText( self.data.textValue )
    self.direction:SetSelection( self.data.direction )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function StyleOptions:SizeChanged()

    local width, height = self:GetSize()
    width = width - 10

    self.icon:SetWidth( width )
    self.showIcon:SetWidth( width )
    self.textOption:SetWidth( width )
    self.textValue:SetWidth( width )
    self.direction:SetWidth( width )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function StyleOptions:Save()

    self.data.icon   = self.icon:GetText(  )
    self.data.showIcon      = self.showIcon:IsChecked(  )
    self.data.textOption      = self.textOption:GetSelectedValue(  )
    self.data.textValue      = self.textValue:GetText(  )
    self.data.direction      = self.direction:GetSelectedValue(  )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function StyleOptions:Reset()

    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function StyleOptions:LanguageChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function StyleOptions:Show()

    self:SetVisible( true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function StyleOptions:Hide()

    self:SetVisible( false )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function StyleOptions:BuildCollectionRightClickMenu( data, menu )

    
    if data.icon ~= nil then
        local row2 =  Options.Elements.Row(
            "collection",
            "icon",
            function ()
                self.icon:SetText( data.icon )
            end,
            Options.Defaults.rc_menu.item_height
        )
        menu:AddRow( row2 )
    end

end
---------------------------------------------------------------------------------------------------
