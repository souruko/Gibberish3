local SCROLL_W    = 10
local MAX_POPUP_H = 240

Options2.Elements.Dropdown = class(Turbine.UI.Control)
function Options2.Elements.Dropdown:Constructor(width, lines)
    Turbine.UI.Control.Constructor(self)

    self.selected_item  = nil
    self.selected_index = 0
    self.popup_open     = false
    self.item_height    = Options.Defaults.dropdown.item_line_height * (lines or 1)

    self.background = Turbine.UI.Control()
    self.background:SetParent(self)
    self.background:SetBackColor(Options.Defaults.dropdown.base_color)
    self.background:SetMouseVisible(false)

    self.label = Turbine.UI.Label()
    self.label:SetParent(self)
    self.label:SetLeft(5)
    self.label:SetMultiline(false)
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

    self.scrollbar = Turbine.UI.Lotro.ScrollBar()
    self.scrollbar:SetParent(self.popup)
    self.scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical)
    self.popup_list:SetVerticalScrollBar(self.scrollbar)

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
        local item_count  = self.popup_list:GetItemCount()
        local list_height = math.min(item_count * self.item_height, MAX_POPUP_H)
        local popup_width = self:GetWidth()
        local list_w      = popup_width - SCROLL_W
        local sx, sy = self:PointToScreen(0, self:GetHeight())
        self.popup:SetPosition(sx, sy)
        self.popup:SetSize(popup_width, list_height)
        self.popup_list:SetPosition(0, 0)
        self.popup_list:SetSize(list_w, list_height)
        self.scrollbar:SetPosition(list_w, 0)
        self.scrollbar:SetSize(SCROLL_W, list_height)
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
    local item = Options2DropdownItem(self, self:GetWidth() - SCROLL_W, text_control, text_description, value, self.item_height)
    self.popup_list:AddItem(item)
end

function Options2.Elements.Dropdown:ClearItems()
    self.popup_list:ClearItems()
    self.selected_item  = nil
    self.selected_index = 0
    self.label:SetText("")
    self:Show(false)
end

function Options2.Elements.Dropdown:SetSelection(value)
    for i = 1, self.popup_list:GetItemCount() do
        local item = self.popup_list:GetItem(i)
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
    self.selected_item  = child
    self.selected_index = self.popup_list:IndexOfItem(child)
    child:Select(true)
    self.label:SetText(child.label:GetText())
    self:Show(false)
    self.SelectionChanged(self, self.selected_index, child.value)
end

function Options2.Elements.Dropdown:Sort()
    self.popup_list:Sort(function(a, b) return a.value < b.value end)
end

function Options2.Elements.Dropdown:SortAlpha()
    self.popup_list:Sort(function(a, b)
        return (a.label:GetText() or "") < (b.label:GetText() or "")
    end)
end

function Options2.Elements.Dropdown:LanguageChanged()
    for i = 1, self.popup_list:GetItemCount() do
        self.popup_list:GetItem(i):LanguageChanged()
    end
    if self.selected_item ~= nil then
        self.label:SetText(self.selected_item.label:GetText())
    end
end

function Options2.Elements.Dropdown.SelectionChanged(sender, index, value)
end
