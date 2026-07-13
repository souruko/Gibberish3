local SEG_H = Options.Defaults.window.segment_height  -- 25

Options2.Library.SegmentItem = class(Turbine.UI.Control)
function Options2.Library.SegmentItem:Constructor(nameCtrl, nameDesc, library, typeIdx, toggle_fn)
    Turbine.UI.Control.Constructor(self)

    self.library      = library
    self.typeIdx      = typeIdx
    self.controls     = {}
    self._collecting  = false
    self._nameCtrl    = nameCtrl
    self._nameDesc    = nameDesc
    self._baseText    = UTILS.GetText(nameCtrl, nameDesc)
    self._count       = 0

    self.header = Turbine.UI.Label()
    self.header:SetParent(self)
    self.header:SetHeight(SEG_H)
    self.header:SetFont(Turbine.UI.Lotro.Font.Verdana14)
    self.header:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.header:SetBackColor(Options.Defaults.window.basecolor)
    self.header:SetForeColor(Options.Defaults.window.textcolor)
    self.header:SetText(self._baseText)
    self.header.MouseEnter = function()
        self.header:SetBackColor(Options.Defaults.window.w_window_hover)
    end
    self.header.MouseLeave = function()
        if self._collecting then
            self.header:SetBackColor(Options.Defaults.window.collecting)
        else
            self.header:SetBackColor(Options.Defaults.window.basecolor)
        end
    end
    self.header.MouseClick = function()
        self.library:SegmentClicked(self)
    end

    -- optional collect toggle button (Effects / Chat segments only)
    if toggle_fn ~= nil then
        self.toggle_btn = Turbine.UI.Control()
        self.toggle_btn:SetParent(self.header)
        self.toggle_btn:SetSize(32, 32)
        self.toggle_btn:SetTop(math.floor((SEG_H - 32) / 2))
        self.toggle_btn:SetBlendMode(Turbine.UI.BlendMode.Overlay)
        self.toggle_btn:SetBackground("Gibberish3/RESOURCES/switch_off.tga")
        self.toggle_btn:SetMouseVisible(true)
        self.toggle_btn.MouseClick = toggle_fn
    end

    self.listbox = Turbine.UI.ListBox()
    self.listbox:SetParent(self)
    self.listbox:SetBackColor(Options.Defaults.window.backcolor1)
    self.listbox:SetTop(SEG_H)
    self.listbox:SetMouseVisible(false)

    self.scrollbar = Turbine.UI.Lotro.ScrollBar()
    self.scrollbar:SetParent(self)
    self.scrollbar:SetTop(SEG_H)
    self.scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical)
    self.scrollbar:SetWidth(10)
    self.listbox:SetVerticalScrollBar(self.scrollbar)

    self:SetHeight(SEG_H)
end

function Options2.Library.SegmentItem:_UpdateCount(n)
    self._count = n or 0
    local txt = self._baseText
    if self._count > 0 then txt = txt .. " (" .. self._count .. ")" end
    self.header:SetText(txt)
end

function Options2.Library.SegmentItem:LanguageChanged()
    self._baseText = UTILS.GetText(self._nameCtrl, self._nameDesc)
    self:_UpdateCount(self._count)
end

function Options2.Library.SegmentItem:SetToggleActive(active)
    if self.toggle_btn == nil then return end
    self._collecting = active
    if active then
        self.toggle_btn:SetBackground("Gibberish3/RESOURCES/switch_on.tga")
        self.header:SetBackColor(Options.Defaults.window.collecting)
    else
        self.toggle_btn:SetBackground("Gibberish3/RESOURCES/switch_off.tga")
        self.header:SetBackColor(Options.Defaults.window.basecolor)
    end
end

function Options2.Library.SegmentItem:SizeChanged()
    local w, h = self:GetSize()
    self.header:SetWidth(w)
    if self.toggle_btn ~= nil then
        self.toggle_btn:SetLeft(w - 32 - 3)
    end
    local lb_h = math.max(0, h - SEG_H)
    self.listbox:SetSize(w - 10, lb_h)
    self.scrollbar:SetLeft(w - 10)
    self.scrollbar:SetHeight(lb_h)
    for i = 1, self.listbox:GetItemCount() do
        self.listbox:GetItem(i):SetWidth(w - 10)
    end
end

function Options2.Library.SegmentItem:SetList(list, filter)
    self.controls = {}
    self.listbox:ClearItems()
    for _, data in ipairs(list) do
        self.controls[#self.controls + 1] =
            Options2.Library.LibraryItem(data, self.typeIdx, self.library)
    end
    self:_UpdateCount(#list)
    self:FillContent(filter or "")
end

function Options2.Library.SegmentItem:FillContent(text)
    self.listbox:ClearItems()
    local w     = self:GetWidth()
    local lower = string.lower(text)
    for _, ctrl in ipairs(self.controls) do
        if string.find(string.lower(ctrl.data.token or ""), lower, 1, true) then
            if w > 0 then ctrl:SetWidth(w - 10) end
            self.listbox:AddItem(ctrl)
        end
    end
    self.listbox:Sort(function(a, b) return a.data.token < b.data.token end)
end

function Options2.Library.SegmentItem:Filter(text)
    self:FillContent(text)
end
