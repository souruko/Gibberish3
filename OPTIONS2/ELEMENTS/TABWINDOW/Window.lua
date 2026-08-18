Options2.Elements.TabWindow = class(Turbine.UI.Control)
function Options2.Elements.TabWindow:Constructor(tab_width)
    Turbine.UI.Control.Constructor(self)

    self.tabs     = {}
    self.tab_width = tab_width
    self.selected = 0

    self.tab_back = Turbine.UI.Control()
    self.tab_back:SetParent(self)
    self.tab_back:SetBackColor(Options.Defaults.window.bg_sunken)
    self.tab_back:SetPosition(0, 0)
    self.tab_back:SetMouseVisible(false)

    self.tab_sep = Turbine.UI.Control()
    self.tab_sep:SetParent(self)
    self.tab_sep:SetBackColor(Options.Defaults.window.line)
    self.tab_sep:SetMouseVisible(false)

    self.content_back = Turbine.UI.Control()
    self.content_back:SetParent(self)
    self.content_back:SetBackColor(Options.Defaults.window.bg)
    self.content_back:SetMouseVisible(false)
end

local TAB_H = 26

-- the metrics that hold text follow the panel's font size; see OPTIONS2/Fonts.lua
Options2.Fonts.Register(function()
    local F = Options2.Fonts
    TAB_H = F.Px(26)
end)

function Options2.Elements.TabWindow:SizeChanged()
    local width, height = self:GetSize()
    local sep_h = 1

    self.tab_back:SetSize(width, TAB_H)
    self.tab_sep:SetPosition(0, TAB_H)
    self.tab_sep:SetSize(width, sep_h)
    self.content_back:SetPosition(0, TAB_H + sep_h)
    self.content_back:SetSize(width, math.max(0, height - TAB_H - sep_h))

    -- tabs share the width equally, the last one taking any rounding slack
    local n = #self.tabs
    if n > 0 then
        local each = math.floor(width / n)
        for i, entry in ipairs(self.tabs) do
            local w = (i == n) and (width - each * (n - 1)) or each
            entry.tab:SetPosition(each * (i - 1), 0)
            entry.tab:SetSize(w, TAB_H)
            entry.content:SetSize(width, math.max(0, height - TAB_H - sep_h))
        end
    end
end

function Options2.Elements.TabWindow:AddTab(item, name_control, name_description)
    local index = #self.tabs + 1
    local tab   = Options2Tab(index, name_control, name_description, self, self.tab_width)
    tab:SetParent(self.tab_back)

    item:SetParent(self.content_back)
    item:SetPosition(0, 0)
    item:SetVisible(false)

    table.insert(self.tabs, { tab = tab, content = item })

    if self.selected == 0 then
        self:ChangeSelection(1)
    end
    self:SizeChanged()
end

function Options2.Elements.TabWindow:ChangeSelection(index)
    if self.selected ~= 0 and self.tabs[self.selected] then
        self.tabs[self.selected].content:SetVisible(false)
    end
    self.selected = index
    for i, entry in ipairs(self.tabs) do
        entry.tab:Select(index)
    end
    if self.tabs[index] and self.accent_color ~= nil then
        self.tabs[index].tab:SetAccentColor(self.accent_color)
    end
    if self.tabs[index] then
        self.tabs[index].content:SetVisible(true)
    end
    local parent = self:GetParent()
    if parent ~= nil and parent.TabSelectionChanged ~= nil then
        parent:TabSelectionChanged(index)
    end
end

function Options2.Elements.TabWindow:SetAccentColor(color)
    self.accent_color = color
    if self.selected ~= 0 and self.tabs[self.selected] then
        self.tabs[self.selected].tab:SetAccentColor(color)
    end
end

function Options2.Elements.TabWindow:LanguageChanged()
    for _, entry in ipairs(self.tabs) do
        entry.tab:LanguageChanged()
    end
end
