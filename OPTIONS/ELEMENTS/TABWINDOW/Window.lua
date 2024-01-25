--=================================================================================================
--= TabWindow
--= ===============================================================================================
--= 
--=================================================================================================



Options.Elements.TabWindow = class(Turbine.UI.Control)
---------------------------------------------------------------------------------------------------
function Options.Elements.TabWindow:Constructor( tab_width )
	Turbine.UI.Control.Constructor( self )

    self.selected = 0
    self.tab_width = tab_width
    self.controls = {}

    self:SetBackColor( Options.Defaults.window.basecolor )

	self.frame = Turbine.UI.Control()
	self.frame:SetParent( self )
	self.frame:SetBackColor( Options.Defaults.window.framecolor )
    self.frame:SetPosition( Options.Defaults.window.spacing, Options.Defaults.window.spacing + Options.Defaults.window.tab_height)

    self.listbox = Turbine.UI.ListBox()
    self.listbox:SetParent( self )
    self.listbox:SetPosition( Options.Defaults.window.spacing,  Options.Defaults.window.spacing )
    self.listbox:SetHeight( Options.Defaults.window.frame + Options.Defaults.window.tab_height  )
    self.listbox:SetOrientation( Turbine.UI.Orientation.Horizontal )
    -- self.listbox:SetBackColor( Options.Defaults.window.backcolor1 )

    self.content_back = Turbine.UI.Control()
    self.content_back:SetParent( self.frame )
    self.content_back:SetBackColor( Options.Defaults.window.backcolor1 )
    self.content_back:SetPosition( Options.Defaults.window.frame,  Options.Defaults.window.frame)

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.TabWindow:SizeChanged()

    local width, height = self:GetSize()

    local frame_width = width - (2*Options.Defaults.window.spacing)
    local content_width = frame_width - (2*Options.Defaults.window.frame)
    local frame_height = height - Options.Defaults.window.tab_height - (2*Options.Defaults.window.spacing)
    local content_height = frame_height - (2*Options.Defaults.window.frame)
    self.frame:SetSize( frame_width, frame_height )
    self.listbox:SetWidth( frame_width  )
    self.content_back:SetSize( content_width, content_height )

    for index, control in ipairs(self.controls) do
        control:SetSize( content_width, content_height )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.TabWindow:LanguageChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.TabWindow:Close()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.TabWindow:AddTab( item, name_control, name_description )

    local index = #self.controls + 1
    self.controls[ index ] = item

    item:SetParent( self.content_back )
    self:SizeChanged()


    self.listbox:AddItem( Tab( index, name_control, name_description, self, self.tab_width ) )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function Options.Elements.TabWindow:ChangeSelection( index )

    -- change tab(heading)
    for i = 1, self.listbox:GetItemCount(), 1 do

        local item = self.listbox:GetItem(i)
        item:Select( index )
        
    end

    -- hide old content
    if self.selected ~= 0 then
        self.controls[ self.selected ]:Hide()
    end

    self.selected = index
    self:GetParent():TabSelectionChanged( index )

    -- show new content
    self.controls[ index ]:Show()

end
---------------------------------------------------------------------------------------------------