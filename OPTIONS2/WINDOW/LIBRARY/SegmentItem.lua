-- One library tab's contents. The tab button itself lives in LIBRARY/Window.lua;
-- this is just the scrolling list behind it, shown only while its tab is active.

local SCROLL_W = 10

Options2.Library.SegmentItem = class(Turbine.UI.Control)
function Options2.Library.SegmentItem:Constructor(nameCtrl, nameDesc, library, typeIdx)
    Turbine.UI.Control.Constructor(self)

    self.library   = library
    self.typeIdx   = typeIdx
    self.controls  = {}
    self._nameCtrl = nameCtrl
    self._nameDesc = nameDesc
    self._count    = 0

    self:SetVisible(false)

    self.listbox = Turbine.UI.ListBox()
    self.listbox:SetParent(self)
    self.listbox:SetPosition(0, 0)
    self.listbox:SetBackColor(Options.Defaults.window.bg_sunken)
    self.listbox:SetMouseVisible(false)

    self.scrollbar = Turbine.UI.Lotro.ScrollBar()
    self.scrollbar:SetParent(self)
    self.scrollbar:SetPosition(0, 0)
    self.scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical)
    self.scrollbar:SetWidth(SCROLL_W)
    self.listbox:SetVerticalScrollBar(self.scrollbar)
end

-- label for this segment's tab button, without the count
function Options2.Library.SegmentItem:GetTabText()
    return UTILS.GetText(self._nameCtrl, self._nameDesc)
end

function Options2.Library.SegmentItem:GetCount()
    return self._count
end

function Options2.Library.SegmentItem:LanguageChanged()
    for _, ctrl in ipairs(self.controls) do
        if ctrl.LanguageChanged ~= nil then ctrl:LanguageChanged() end
    end
end

function Options2.Library.SegmentItem:SizeChanged()
    local w, h = self:GetSize()
    if w <= 0 or h <= 0 then return end
    local list_w = w - SCROLL_W
    self.listbox:SetSize(list_w, h)
    self.scrollbar:SetPosition(list_w, 0)
    self.scrollbar:SetHeight(h)
    for i = 1, self.listbox:GetItemCount() do
        self.listbox:GetItem(i):SetWidth(list_w)
    end
end

function Options2.Library.SegmentItem:SetList(list, filter)
    self.controls = {}
    self.listbox:ClearItems()
    for _, data in ipairs(list) do
        self.controls[#self.controls + 1] =
            Options2.Library.LibraryItem(data, self.typeIdx, self.library)
    end
    self._count = #list
    self:FillContent(filter or "")
end

function Options2.Library.SegmentItem:FillContent(text)
    self.listbox:ClearItems()
    local list_w = math.max(0, self:GetWidth() - SCROLL_W)
    local lower  = string.lower(text)
    for _, ctrl in ipairs(self.controls) do
        if string.find(string.lower(ctrl.data.token or ""), lower, 1, true) then
            if list_w > 0 then ctrl:SetWidth(list_w) end
            self.listbox:AddItem(ctrl)
        end
    end
    self.listbox:Sort(function(a, b) return a.data.token < b.data.token end)
end

function Options2.Library.SegmentItem:Filter(text)
    self:FillContent(text)
end
