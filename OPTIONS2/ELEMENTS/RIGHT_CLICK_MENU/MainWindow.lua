Options2.Elements.RightClickMenu = class(Turbine.UI.Window)
function Options2.Elements.RightClickMenu:Constructor(width)
    Turbine.UI.Window.Constructor(self)

    self.width       = width or 180
    self.height      = 2 * Options.Defaults.rc_menu.spacing
    self.orientation = Turbine.UI.ContentAlignment.BottomRight
    self.children    = {}

    self:SetMouseVisible(false)
    self:SetSize(1000, 1000)

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

function Options2.Elements.RightClickMenu:Show(left, top, orientation)
    self.orientation = orientation

    if left == nil then
        left, top = Turbine.UI.Display.GetMousePosition()
    end
    self:SetPosition(left, top)

    local b_left = 0
    local b_top  = 0
    if self.orientation == Turbine.UI.ContentAlignment.BottomRight then
        b_left = 1000 - self.width
        b_top  = 1000 - self.height
    elseif self.orientation == Turbine.UI.ContentAlignment.BottomLeft then
        b_top = 1000 - self.height
    elseif self.orientation == Turbine.UI.ContentAlignment.TopRight then
        b_left = 1000 - self.width
    end

    self.background:SetPosition(b_left, b_top)
    self:LanguageChanged()
    self:SetVisible(true)
    self:Activate()
    self:Focus()
end

function Options2.Elements.RightClickMenu:Hide()
    self:SetVisible(false)
    for _, child in pairs(self.children) do
        child:Hide()
    end
end

function Options2.Elements.RightClickMenu:FocusLost()
    self:Hide()
end

function Options2.Elements.RightClickMenu:Used()
    self:Hide()
end

function Options2.Elements.RightClickMenu:AddRow(row)
    row:SetWidth(self.width)
    row:SetSuper(self)
    self.list:AddItem(row)
    self:ChangeHeight(Options.Defaults.rc_menu.item_height)
end

function Options2.Elements.RightClickMenu:AddCheckRow(row)
    row:SetWidth(self.width)
    row:SetSuper(self)
    self.list:AddItem(row)
    self:ChangeHeight(Options.Defaults.rc_menu.item_height)
    return row
end

function Options2.Elements.RightClickMenu:AddSeperator()
    self.list:AddItem(Options2.Elements.Separator(self.width, Options.Defaults.rc_menu.seperator_height, self))
    self:ChangeHeight(Options.Defaults.rc_menu.seperator_height)
end

function Options2.Elements.RightClickMenu:AddSubRow(row, subMenu)
    row:SetWidth(self.width)
    row:SetSuper(self)
    subMenu:SetParent(self)
    self.children[#self.children + 1] = subMenu
    self.list:AddItem(row)
    self:ChangeHeight(Options.Defaults.rc_menu.item_height)
end

function Options2.Elements.RightClickMenu:ChangeHeight(value)
    self.height = self.height + value
    self.list:SetHeight(self.height)
    self.background:SetHeight(self.height)
end

function Options2.Elements.RightClickMenu:HoverChanged(selected)
    for i = 1, self.list:GetItemCount() do
        local child = self.list:GetItem(i)
        if child ~= selected then
            child:Hover(false)
        end
    end
end

function Options2.Elements.RightClickMenu:GetPos()
    return self.background:GetPosition()
end

function Options2.Elements.RightClickMenu:LanguageChanged()
    for i = 1, self.list:GetItemCount() do
        self.list:GetItem(i):LanguageChanged()
    end
    for _, subMenu in pairs(self.children) do
        subMenu:LanguageChanged()
    end
end
