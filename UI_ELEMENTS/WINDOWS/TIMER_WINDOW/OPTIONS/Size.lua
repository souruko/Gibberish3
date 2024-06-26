--=================================================================================================
--= Dropdown SizeOptions
--= ===============================================================================================
--= 
--=================================================================================================



SizeOptions = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function SizeOptions:Constructor( data )
	Turbine.UI.Control.Constructor( self )

    self.data = data

    self:SetVisible( false )

    local left = Options.Defaults.window.tab_c_left
    local top = Options.Defaults.window.tab_c_top

    -- width
    self.width = Options.Elements.NumberBoxRow( Options.Defaults.window.basecolor, "options", "width", "win_width", 30 )
    self.width:SetParent( self )
    self.width:SetPosition( left, top )
    
    top = top + 30

    -- height
    self.height = Options.Elements.NumberBoxRow( Options.Defaults.window.basecolor, "options", "height", "win_height", 30 )
    self.height:SetParent( self )
    self.height:SetPosition( left, top )
    
    top = top + 35

    -- frame
    self.frame = Options.Elements.NumberBoxRow( Options.Defaults.window.basecolor, "options", "frame", "win_frame", 30 )
    self.frame:SetParent( self )
    self.frame:SetPosition( left, top )
    
    top = top + 30

    -- spacing
    self.spacing = Options.Elements.NumberBoxRow( Options.Defaults.window.basecolor, "options", "spacing", "win_spacing", 30 )
    self.spacing:SetParent( self )
    self.spacing:SetPosition( left, top )
    
    top = top + 35

    -- direction
    self.direction = Options.Elements.DropDownRow( Options.Defaults.window.basecolor, "options", "direction", "win_direction", 30 )
    self.direction:SetParent( self )
    self.direction:SetPosition( left, top )
    for name, value in pairs(Direction) do
        self.direction:AddItem( "direction", name, value)
    end

    top = top + 30

    -- direction
    self.sort_direction = Options.Elements.DropDownRow( Options.Defaults.window.basecolor, "options", "sort_direction", "win_sort_direction", 30 )
    self.sort_direction:SetParent( self )
    self.sort_direction:SetPosition( left, top )
    for name, value in pairs(Direction) do
        self.sort_direction:AddItem( "direction", name, value)
    end

    top = top + 30

    -- orientation
    self.orientation = Options.Elements.DropDownRow( Options.Defaults.window.basecolor, "options", "orientation", "win_orientation", 30 )
    self.orientation:SetParent( self )
    self.orientation:SetPosition( left, top )
    for name, value in pairs(Orientation) do
        self.orientation:AddItem( "orientation", name, value)
    end
    
    top = top + 35

    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function SizeOptions:ResetContent()

    self.width:SetText( self.data.width )
    self.height:SetText( self.data.height )
    self.frame:SetText( self.data.frame )
    self.spacing:SetText( self.data.spacing )

    self.direction:SetSelection( self.data.direction )
    self.sort_direction:SetSelection( self.data.sort_direction )
    self.orientation:SetSelection( self.data.orientation )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function SizeOptions:SizeChanged()

    local width, height = self:GetSize()
    width = width - 10

    self.width:SetWidth( width )
    self.height:SetWidth( width )
    self.frame:SetWidth( width )
    self.spacing:SetWidth( width )
    self.direction:SetWidth( width )
    self.sort_direction:SetWidth( width )
    self.orientation:SetWidth( width )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function SizeOptions:Save()

    self.data.width   = self.width:GetText(  )
    self.data.height   = self.height:GetText(  )
    self.data.frame   = self.frame:GetText(  )
    self.data.spacing   = self.spacing:GetText(  )
    self.data.direction        = self.direction:GetSelectedValue(  )
    self.data.sort_direction        = self.sort_direction:GetSelectedValue(  )
    self.data.orientation        = self.orientation:GetSelectedValue(  )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function SizeOptions:Reset()

    self:ResetContent()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function SizeOptions:LanguageChanged()

    self.width:LanguageChanged()
    self.height:LanguageChanged()
    self.frame:LanguageChanged()
    self.spacing:LanguageChanged()
    self.direction:LanguageChanged()
    self.sort_direction:LanguageChanged()
    self.orientation:LanguageChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function SizeOptions:Show()

    self:SetVisible( true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function SizeOptions:Hide()

    self:SetVisible( false )

end
---------------------------------------------------------------------------------------------------
