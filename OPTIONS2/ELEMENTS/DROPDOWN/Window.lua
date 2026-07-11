Options2.Elements.Dropdown = class(Turbine.UI.Control)
function Options2.Elements.Dropdown:Constructor(width)
    Turbine.UI.Control.Constructor(self)

    self.items          = {}
    self.selected_item  = nil
    self.selected_index = 0
    self.popup_open     = false

    self.background = Turbine.UI.Control()
    self.background:SetParent(self)
    self.background:SetBackColor(Options.Defaults.dropdown.base_color)
    self.background:SetMouseVisible(false)

    self.label = Turbine.UI.Label()
    self.label:SetParent(self)
    self.label:SetLeft(5)
    self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.label:SetFont(Options.Defaults.window.font)
    self.label:SetMouseVisible(false)

    self.arrow = Turbine.UI.Control()
    self.arrow:SetParent(self)
    self.arrow:SetSize(10, 10)
    self.arrow:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    self.arrow:SetBackground("Gibberish3/RESOURCES/nav_arrow_down.tga")
    self.arrow:SetMouseVisible(false)

    self.popup = Turbine.UI.Window()
    self.popup:SetBackColor(Options.Defaults.dropdown.back_color)
    self.popup:SetVisible(false)
    self.popup:SetWantsKeyEvents(false)

    self.popup.Deactivated = function()
        self:Show(false)
    end

    self.popup_list = Turbine.UI.ListBox()
    self.popup_list:SetParent(self.popup)
    self.popup_list:SetPosition(0, 0)

    self:SetWidth(width)
    self:SetHeight(Options.Defaults.dropdown.item_height)

    self.MouseClick = function()
        self:Show(not self.popup_open)
    end
end

function Options2.Elements.Dropdown:SizeChanged()
    local width, height = self:GetSize()
    self.background:SetSize(width, height)
    self.label:SetSize(width - 23, height)
    self.arrow:SetPosition(width - 12, math.floor((height - 10) / 2))
end

function Options2.Elements.Dropdown:Show(value)
    self.popup_open = value
    if value == true then
        local list_height = Options.Defaults.dropdown.item_height * #self.items
        if list_height > 200 then
            list_height = 200
        end
        local popup_width = self:GetWidth()
        local sx, sy = self:PointToScreen(0, self:GetHeight())
        self.popup:SetPosition(sx, sy)
        self.popup:SetSize(popup_width, list_height)
        self.popup_list:SetSize(popup_width, list_height)
        self.popup:SetVisible(true)
        self.popup:Activate()
    else
        self.popup:SetVisible(false)
    end
end

function Options2.Elements.Dropdown:Close()
    self:Show(false)
end

function Options2.Elements.Dropdown:AddItem(text_control, text_description, value)
    local item = Options2DropdownItem(self, self:GetWidth(), text_control, text_description, value)
    item:SetParent(self.popup_list)
    local count = #self.items
    item:SetPosition(0, count * Options.Defaults.dropdown.item_height)
    table.insert(self.items, item)
    self.popup_list:SetSize(self:GetWidth(), (#self.items) * Options.Defaults.dropdown.item_height)
end

function Options2.Elements.Dropdown:ClearItems()
    for _, item in ipairs(self.items) do
        item:SetParent(nil)
        item:SetVisible(false)
    end
    self.items          = {}
    self.selected_item  = nil
    self.selected_index = 0
    self.label:SetText("")
    self:Show(false)
end

function Options2.Elements.Dropdown:SetSelection(value)
    for i, item in ipairs(self.items) do
        if item.value == value then
            self:ChangeSelection(item)
            return
        end
    end
end

function Options2.Elements.Dropdown:GetSelectedValue()
    if self.selected_item ~= nil then
        return self.selected_item.value
    end
    return nil
end

function Options2.Elements.Dropdown:ChangeSelection(child)
    if self.selected_item ~= nil then
        self.selected_item:Select(false)
    end
    self.selected_item = child
    child:Select(true)
    for i, item in ipairs(self.items) do
        if item == child then
            self.selected_index = i
            break
        end
    end
    self.label:SetText(child.label:GetText())
    self:Show(false)
    self.SelectionChanged(self, self.selected_index, child.value)
end

function Options2.Elements.Dropdown:Sort()
    table.sort(self.items, function(a, b) return a.value < b.value end)
    for i, item in ipairs(self.items) do
        item:SetTop((i - 1) * Options.Defaults.dropdown.item_height)
    end
end

function Options2.Elements.Dropdown:SortAlpha()
    table.sort(self.items, function(a, b)
        return (a.label:GetText() or "") < (b.label:GetText() or "")
    end)
    for i, item in ipairs(self.items) do
        item:SetTop((i - 1) * Options.Defaults.dropdown.item_height)
    end
end

function Options2.Elements.Dropdown:LanguageChanged()
    for _, item in ipairs(self.items) do
        item:LanguageChanged()
    end
    if self.selected_item ~= nil then
        self.label:SetText(self.selected_item.label:GetText())
    end
end

function Options2.Elements.Dropdown.SelectionChanged(sender, index, value)
end
