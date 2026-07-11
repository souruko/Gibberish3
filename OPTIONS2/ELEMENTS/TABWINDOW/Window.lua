Options2.Elements.TabWindow = class(Turbine.UI.Control)
function Options2.Elements.TabWindow:Constructor(tab_width)
    Turbine.UI.Control.Constructor(self)

    self.tabs     = {}
    self.tab_width = tab_width
    self.selected = 0

    self.tab_back = Turbine.UI.Control()
    self.tab_back:SetParent(self)
    self.tab_back:SetBackColor(Options.Defaults.window.backcolor2)
    self.tab_back:SetPosition(0, 0)
    self.tab_back:SetMouseVisible(false)

    self.tab_sep = Turbine.UI.Control()
    self.tab_sep:SetParent(self)
    self.tab_sep:SetBackColor(Options.Defaults.window.framecolor)
    self.tab_sep:SetMouseVisible(false)

    self.content_back = Turbine.UI.Control()
    self.content_back:SetParent(self)
    self.content_back:SetBackColor(Options.Defaults.window.backcolor1)
    self.content_back:SetMouseVisible(false)
end

function Options2.Elements.TabWindow:SizeChanged()
    local width, height = self:GetSize()
    local tab_h = Options.Defaults.window.tab_height + Options.Defaults.window.frame
    local sep_h = 1

    self.tab_back:SetSize(width, tab_h)
    self.tab_sep:SetPosition(0, tab_h)
    self.tab_sep:SetSize(width, sep_h)
    self.content_back:SetPosition(0, tab_h + sep_h)
    self.content_back:SetSize(width, height - tab_h - sep_h)

    for i, entry in ipairs(self.tabs) do
        entry.content:SetSize(width, height - tab_h - sep_h)
    end
end

function Options2.Elements.TabWindow:AddTab(item, name_control, name_description)
    local index = #self.tabs + 1
    local tab   = Options2Tab(index, name_control, name_description, self, self.tab_width)
    tab:SetParent(self.tab_back)
    tab:SetPosition((index - 1) * self.tab_width, 0)

    item:SetParent(self.content_back)
    item:SetPosition(0, 0)
    item:SetVisible(false)

    table.insert(self.tabs, { tab = tab, content = item })

    if self.selected == 0 then
        self:ChangeSelection(1)
    end
end

function Options2.Elements.TabWindow:ChangeSelection(index)
    if self.selected ~= 0 and self.tabs[self.selected] then
        self.tabs[self.selected].content:SetVisible(false)
    end
    self.selected = index
    for i, entry in ipairs(self.tabs) do
        entry.tab:Select(index)
    end
    if self.tabs[index] then
        self.tabs[index].content:SetVisible(true)
    end
    local parent = self:GetParent()
    if parent ~= nil and parent.TabSelectionChanged ~= nil then
        parent:TabSelectionChanged(index)
    end
end

function Options2.Elements.TabWindow:LanguageChanged()
    for _, entry in ipairs(self.tabs) do
        entry.tab:LanguageChanged()
    end
end
