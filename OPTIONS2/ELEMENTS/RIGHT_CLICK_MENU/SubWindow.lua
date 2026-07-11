Options2.Elements.RightClickSubMenu = class(Turbine.UI.Control)
function Options2.Elements.RightClickSubMenu:Constructor(width)
    Turbine.UI.Control.Constructor(self)

    self.width       = width or 180
    self.height      = 2 * Options.Defaults.rc_menu.spacing
    self.orientation = Turbine.UI.ContentAlignment.BottomRight
    self.children    = {}
    self.has_rows    = false

    self:SetMouseVisible(false)
    self:SetWidth(self.width)
    self:SetVisible(false)

    self.background = Turbine.UI.Control()
    self.background:SetParent(self)
    self.background:SetWidth(self.width)
    self.background:SetBackColor(Options.Defaults.rc_menu.back_color)

    self.list = Turbine.UI.ListBox()
    self.list:SetParent(self.background)
    self.list:SetWidth(self.width)
    self.list:SetTop(Options.Defaults.rc_menu.spacing)
    self.list:SetMouseVisible(false)
end

function Options2.Elements.RightClickSubMenu:Show(left, top, orientation)
    self.orientation = orientation or self.orientation
    self:SetPosition(left, top)
    self:SetVisible(true)
end

function Options2.Elements.RightClickSubMenu:Hide()
    self:SetVisible(false)
    for _, child in pairs(self.children) do
        child:Hide()
    end
end

function Options2.Elements.RightClickSubMenu:AddRow(row)
    row:SetWidth(self.width)
    row:SetSuper(self)
    self.list:AddItem(row)
    self:ChangeHeight(Options.Defaults.rc_menu.item_height)
    self.has_rows = true
end

function Options2.Elements.RightClickSubMenu:AddCheckRow(row)
    row:SetWidth(self.width)
    row:SetSuper(self)
    self.list:AddItem(row)
    self:ChangeHeight(Options.Defaults.rc_menu.item_height)
end

function Options2.Elements.RightClickSubMenu:AddSeperator()
    self.list:AddItem(Options2.Elements.Separator(self.width, Options.Defaults.rc_menu.seperator_height, self))
    self:ChangeHeight(Options.Defaults.rc_menu.seperator_height)
end

function Options2.Elements.RightClickSubMenu:AddSubRow(row, subMenu)
    row:SetWidth(self.width)
    row:SetSuper(self)
    subMenu:SetParent(self)
    self.children[#self.children + 1] = subMenu
    self.list:AddItem(row)
    self:ChangeHeight(Options.Defaults.rc_menu.item_height)
    self.has_rows = true
end

function Options2.Elements.RightClickSubMenu:HasRows()
    return self.has_rows == true
end

function Options2.Elements.RightClickSubMenu:ChangeHeight(value)
    self.height = self.height + value
    self:SetHeight(self.height)
    self.list:SetHeight(self.height)
    self.background:SetHeight(self.height)
end

function Options2.Elements.RightClickSubMenu:HoverChanged(selected)
    for i = 1, self.list:GetItemCount() do
        local child = self.list:GetItem(i)
        if child ~= selected then
            child:Hover(false)
        end
    end
end

function Options2.Elements.RightClickSubMenu:FocusLost()
    self:Hide()
end

function Options2.Elements.RightClickSubMenu:Used()
    self:GetParent():Hide()
end

function Options2.Elements.RightClickSubMenu:GetPos()
    return self:GetPosition()
end

function Options2.Elements.RightClickSubMenu:LanguageChanged()
    for i = 1, self.list:GetItemCount() do
        self.list:GetItem(i):LanguageChanged()
    end
    for _, subMenu in pairs(self.children) do
        subMenu:LanguageChanged()
    end
end
