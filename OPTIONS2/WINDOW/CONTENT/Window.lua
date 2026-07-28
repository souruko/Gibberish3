-- Contents column: the selection surface for everything inside the container
-- picked in the structure column.
--   window -> its own triggers, then each timer with its triggers, its
--             conditions, and each condition's triggers
--   folder -> its own triggers only; sub-folders and windows stay in column 1
-- Row click selects into the editor; the structure column keeps the container
-- selection.

local HEADER_H = 34
local SEP_H    = 1
local SCROLL_W = 10
local PAD      = 10
local GAP      = 8
local MARK     = 11
local BTN_H    = 20
local BTN_GAP  = 4
local BTN_PAD  = 8

local FONT_NAME  = Turbine.UI.Lotro.Font.Verdana14
local FONT_SMALL = Turbine.UI.Lotro.Font.Verdana10

-- 1px-bordered text button for the header's add actions
local function make_add_btn(parent, click_fn, tooltip)
    local btn = Turbine.UI.Control()
    btn:SetParent(parent)
    btn:SetHeight(BTN_H)
    btn:SetBackColor(Options.Defaults.window.line)
    btn:SetMouseVisible(true)

    local fill = Turbine.UI.Control()
    fill:SetParent(btn)
    fill:SetPosition(1, 1)
    fill:SetBackColor(Options.Defaults.window.bg)
    fill:SetMouseVisible(false)

    local label = Turbine.UI.Label()
    label:SetParent(fill)
    label:SetFont(FONT_SMALL)
    label:SetForeColor(Options.Defaults.window.text_muted)
    label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    label:SetMouseVisible(false)

    Options2.Elements.Tooltip.AddTooltip(btn, "tooltip", tooltip, false)
    local tip_enter, tip_leave = btn.MouseEnter, btn.MouseLeave
    btn.MouseEnter = function(sender, args)
        tip_enter(sender, args)
        fill:SetBackColor(Options.Defaults.window.select)
    end
    btn.MouseLeave = function(sender, args)
        tip_leave(sender, args)
        fill:SetBackColor(Options.Defaults.window.bg)
    end
    btn.MouseClick = click_fn

    function btn:SetLabel(text)
        label:SetText(text)
        local w = BTN_PAD * 2 + string.len(text) * 6
        self:SetWidth(w)
        fill:SetSize(w - 2, BTN_H - 2)
        label:SetSize(w - 2, BTN_H - 2)
    end

    return btn
end

Options2.Window.Content = {}
Options2.Window.Content.Constructor = class(Turbine.UI.Control)

function Options2.Window.Content.Constructor:Constructor()
    Turbine.UI.Control.Constructor(self)

    self.container    = nil   -- nodeData of the folder or window on show
    self.items        = {}
    self.selectedKey  = Options2.LoadContentState()
    self.selectedItem = nil
    self._itemCache   = {}
    self._last_list_w = -1

    self:SetBackColor(Options.Defaults.window.bg)

    -- ── header ───────────────────────────────────────────────────
    -- the header doubles as the row for the container itself, so its own
    -- settings stay reachable after picking something inside it
    self.header = Turbine.UI.Control()
    self.header:SetParent(self)
    self.header:SetPosition(0, 0)
    self.header:SetHeight(HEADER_H)
    self.header:SetBackColor(Options.Defaults.window.bg_sunken)
    self.header:SetMouseVisible(true)
    self.header.MouseEnter = function()
        if not self._header_selected then
            self.header:SetBackColor(Options.Defaults.window.row_odd)
        end
    end
    self.header.MouseLeave = function() self:_UpdateHeaderState() end
    self.header.MouseClick = function(sender, args)
        if args ~= nil and args.Button == Turbine.UI.MouseButton.Right then
            self:_RightClickContainer()
        else
            self:SelectContainer()
        end
    end

    self.head_rail = Turbine.UI.Control()
    self.head_rail:SetParent(self.header)
    self.head_rail:SetPosition(0, 0)
    self.head_rail:SetSize(Options2.Elements.RowParts.RAIL_W, HEADER_H)
    self.head_rail:SetVisible(false)
    self.head_rail:SetMouseVisible(false)

    self.head_mark = Turbine.UI.Control()
    self.head_mark:SetParent(self.header)
    self.head_mark:SetSize(MARK, MARK)
    self.head_mark:SetTop(math.floor((HEADER_H - MARK) / 2))
    self.head_mark:SetMouseVisible(false)

    self.head_name = Turbine.UI.Label()
    self.head_name:SetParent(self.header)
    self.head_name:SetHeight(HEADER_H)
    self.head_name:SetFont(FONT_NAME)
    self.head_name:SetForeColor(Options.Defaults.window.text)
    self.head_name:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.head_name:SetMouseVisible(false)

    self.head_meta = Turbine.UI.Label()
    self.head_meta:SetParent(self.header)
    self.head_meta:SetHeight(HEADER_H)
    self.head_meta:SetFont(FONT_SMALL)
    self.head_meta:SetForeColor(Options.Defaults.window.text_faint)
    self.head_meta:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.head_meta:SetMouseVisible(false)

    self.btn_timer = make_add_btn(self.header, function()
        local c = self.container
        if c == nil or c.nodeType ~= "window" then return end
        local wd = Data.window[c.windowIndex]
        Window.AddTimer(c.windowIndex, Timer.New(wd.timerType))
        Options.SaveData()
        Options2.RefreshAll()
    end, "o2_add_timer")

    self.btn_trigger = make_add_btn(self.header, function()
        self:_ShowAddTriggerMenu()
    end, "o2_add_trigger")

    self.header_sep = Turbine.UI.Control()
    self.header_sep:SetParent(self)
    self.header_sep:SetPosition(0, HEADER_H)
    self.header_sep:SetHeight(SEP_H)
    self.header_sep:SetBackColor(Options.Defaults.window.line)
    self.header_sep:SetMouseVisible(false)

    -- ── row list ─────────────────────────────────────────────────
    self.listbox = Turbine.UI.ListBox()
    self.listbox:SetParent(self)
    self.listbox:SetBackColor(Options.Defaults.window.bg)

    self.scrollbar = Turbine.UI.Lotro.ScrollBar()
    self.scrollbar:SetParent(self)
    self.scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical)
    self.listbox:SetVerticalScrollBar(self.scrollbar)

    self.placeholder = Turbine.UI.Label()
    self.placeholder:SetParent(self)
    self.placeholder:SetFont(Turbine.UI.Lotro.Font.Verdana12)
    self.placeholder:SetForeColor(Options.Defaults.window.text_faint)
    self.placeholder:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.placeholder:SetMouseVisible(false)

    self:_RefreshTexts()
end

-- ── layout ─────────────────────────────────────────────────────────────────────

function Options2.Window.Content.Constructor:SizeChanged()
    if self.header == nil then return end
    local w, h = self:GetSize()
    if w <= 0 or h <= 0 then return end
    local list_w = w - SCROLL_W

    self.header:SetWidth(w)
    self.header_sep:SetWidth(w)

    -- add buttons sit at the right, name and meta take what is left
    local x = w - PAD
    if self.btn_trigger:IsVisible() then
        x = x - self.btn_trigger:GetWidth()
        self.btn_trigger:SetPosition(x, math.floor((HEADER_H - BTN_H) / 2))
        x = x - BTN_GAP
    end
    if self.btn_timer:IsVisible() then
        x = x - self.btn_timer:GetWidth()
        self.btn_timer:SetPosition(x, math.floor((HEADER_H - BTN_H) / 2))
        x = x - BTN_GAP
    end

    self.head_rail:SetHeight(HEADER_H)
    self.head_mark:SetLeft(PAD)
    local name_left = PAD + MARK + GAP
    local avail     = math.max(0, x - GAP - name_left)
    local name_w    = math.floor(avail * 0.6)
    self.head_name:SetPosition(name_left, 0)
    self.head_name:SetWidth(name_w)
    self.head_meta:SetPosition(name_left + name_w + GAP, 0)
    self.head_meta:SetWidth(math.max(0, avail - name_w - GAP))

    local list_top = HEADER_H + SEP_H
    local view_h   = math.max(0, h - list_top)
    self.listbox:SetPosition(0, list_top)
    self.listbox:SetSize(list_w, view_h)
    self.scrollbar:SetPosition(list_w, list_top)
    self.scrollbar:SetSize(SCROLL_W, view_h)

    self.placeholder:SetPosition(0, list_top)
    self.placeholder:SetSize(w, view_h)

    if list_w ~= self._last_list_w then
        self._last_list_w = list_w
        for _, item in ipairs(self.items) do item:SetWidth(list_w) end
    end
end

function Options2.Window.Content.Constructor:_RefreshTexts()
    self.btn_timer:SetLabel(UTILS.GetText("options2", "add_timer"))
    self.btn_trigger:SetLabel(UTILS.GetText("options2", "add_trigger"))
    self.placeholder:SetText(UTILS.GetText("options2", "no_container"))
end

function Options2.Window.Content.Constructor:LanguageChanged()
    if self.header == nil then return end
    self:_RefreshTexts()
    self:RebuildFresh()
end

-- ── container selection ────────────────────────────────────────────────────────

-- called by the structure column; anything other than a folder or window
-- empties this column
function Options2.Window.Content.Constructor:SetContainer(nodeData)
    local nt = nodeData and nodeData.nodeType
    if nt ~= "folder" and nt ~= "window" then
        self.container = nil
    else
        self.container = nodeData
    end
    self:RebuildFresh()
end

function Options2.Window.Content.Constructor:ClearSelection()
    if self.selectedItem ~= nil then
        self.selectedItem:SetSelected(false)
        self.selectedItem = nil
    end
    self.selectedKey = nil
    Options2.SaveContentState(nil)
    self:_UpdateHeaderState()
end

-- ── the container's own row ────────────────────────────────────────────────────

-- With no row selected, the editor is showing the container, so the header is
-- what reads as selected.
function Options2.Window.Content.Constructor:_UpdateHeaderState()
    self._header_selected = (self.container ~= nil and self.selectedItem == nil)

    if self._header_selected then
        self.header:SetBackColor(Options.Defaults.window.select)
        self.head_rail:SetBackColor(self.container.nodeType == "window"
            and Options.Defaults.window.color_window
            or  Options.Defaults.window.color_folder)
        self.head_rail:SetVisible(true)
    else
        self.header:SetBackColor(Options.Defaults.window.bg_sunken)
        self.head_rail:SetVisible(false)
    end
end

-- clicking the header puts the folder or window itself back in the editor
function Options2.Window.Content.Constructor:SelectContainer()
    if self.container == nil then return end

    self:ClearSelection()
    Options2.selectedNode = self.container

    local obj = Options2.Window.Object
    if obj ~= nil and obj.editor_panel ~= nil then
        obj.editor_panel:SetNode(self.container)
    end
end

function Options2.Window.Content.Constructor:_RightClickContainer()
    if self.container == nil then return end
    self:SelectContainer()
    Options2.ShowContextMenu(self.container)
end

-- ── row cache ──────────────────────────────────────────────────────────────────

function Options2.Window.Content.Constructor:_GetOrCreate(key, constructor_fn)
    local item = self._itemCache[key]
    if item == nil then
        item = constructor_fn()
        self._itemCache[key] = item
    else
        item:Refresh()
    end
    return item
end

function Options2.Window.Content.Constructor:RebuildFresh()
    self._itemCache = {}
    self:Rebuild()
end

-- ── ordering ───────────────────────────────────────────────────────────────────

-- enabled first, then A-Z on the display name, per SPEC. index breaks ties so
-- the order is stable.
local function sort_entries(entries)
    table.sort(entries, function(a, b)
        if a.enabled ~= b.enabled then return a.enabled end
        local an, bn = string.lower(a.name or ""), string.lower(b.name or "")
        if an ~= bn then return an < bn end
        return a.idx < b.idx
    end)
    return entries
end

-- every trigger held by a container, flattened across trigger types
function Options2.Window.Content.Constructor:_TriggerEntries(container)
    local entries = {}
    for _, tt in ipairs(Options2.TriggerTypes()) do
        for ti, td in ipairs(container[tt] or {}) do
            entries[#entries + 1] = {
                tt      = tt,
                idx     = ti,
                data    = td,
                enabled = (td.enabled == true),
                name    = Options2.Elements.RowParts.TriggerLabel(td, tt),
            }
        end
    end
    return sort_entries(entries)
end

-- ── rebuild ────────────────────────────────────────────────────────────────────

function Options2.Window.Content.Constructor:Rebuild()
    self.listbox:ClearItems()
    self.items        = {}
    self.selectedItem = nil

    local list_w = self.listbox:GetWidth()
    if list_w <= 0 then list_w = 338 end

    self:_RefreshHeader()

    local c = self.container
    if c == nil then
        self.placeholder:SetVisible(true)
        self:_UpdateHeaderState()
        return
    end
    self.placeholder:SetVisible(false)

    if c.nodeType == "folder" then
        self:_BuildFolder(c, list_w)
    else
        self:_BuildWindow(c, list_w)
    end

    self:_RestoreSelection()
    self:_UpdateHeaderState()
end

function Options2.Window.Content.Constructor:_Add(item, w)
    item:SetWidth(w)
    self.listbox:AddItem(item)
    self.items[#self.items + 1] = item
end

function Options2.Window.Content.Constructor:_AddSection(key, text, w)
    local section = self:_GetOrCreate(key, function()
        return Options2ContentSection(key, text)
    end)
    section:SetText(text)
    self:_Add(section, w)
end

function Options2.Window.Content.Constructor:_BuildFolder(c, w)
    local fi = c.folderIndex
    local fd = Data.folder[fi]
    if fd == nil then return end

    self:_AddSection("sec_folder_trig", UTILS.GetText("options2", "folder_triggers"), w)

    for _, e in ipairs(self:_TriggerEntries(fd)) do
        local key = "ft_" .. fi .. "_" .. e.tt .. "_" .. e.idx
        local tt, ti, td = e.tt, e.idx, e.data
        self:_Add(self:_GetOrCreate(key, function()
            return Options2ContentOwnTrigger(self, "foldertrigger", fi, td, tt, ti, key)
        end), w)
    end
end

function Options2.Window.Content.Constructor:_BuildWindow(c, w)
    local wi = c.windowIndex
    local wd = Data.window[wi]
    if wd == nil then return end

    self:_AddSection("sec_window_trig", UTILS.GetText("options2", "window_triggers"), w)

    for _, e in ipairs(self:_TriggerEntries(wd)) do
        local key = "wt_" .. wi .. "_" .. e.tt .. "_" .. e.idx
        local tt, ti, td = e.tt, e.idx, e.data
        self:_Add(self:_GetOrCreate(key, function()
            return Options2ContentOwnTrigger(self, "windowtrigger", wi, td, tt, ti, key)
        end), w)
    end

    self:_AddSection("sec_timers", UTILS.GetText("options2", "timers_sorted"), w)

    local timers = {}
    for tmi, tmd in ipairs(wd.timerList or {}) do
        timers[#timers + 1] = {
            idx     = tmi,
            data    = tmd,
            enabled = (tmd.enabled == true),
            name    = (tmd.description ~= nil and tmd.description ~= "")
                and tmd.description or UTILS.GetText("options2", "unnamed_timer"),
        }
    end
    sort_entries(timers)

    for _, t in ipairs(timers) do
        self:_BuildTimer(wi, t.idx, t.data, w)
    end
end

function Options2.Window.Content.Constructor:_BuildTimer(wi, tmi, tmd, w)
    local key = "t_" .. wi .. "_" .. tmi
    self:_Add(self:_GetOrCreate(key, function()
        return Options2ContentTimer(self, wi, tmi, tmd, key)
    end), w)

    for _, e in ipairs(self:_TriggerEntries(tmd)) do
        local tkey = "tt_" .. wi .. "_" .. tmi .. "_" .. e.tt .. "_" .. e.idx
        local tt, ti, td = e.tt, e.idx, e.data
        self:_Add(self:_GetOrCreate(tkey, function()
            return Options2ContentTrigger(self, wi, tmi, td, tt, ti, tkey)
        end), w)
    end

    local conds = {}
    for ci, cd in ipairs(tmd.conditionList or {}) do
        conds[#conds + 1] = {
            idx     = ci,
            data    = cd,
            enabled = (cd.enabled == true),
            name    = (cd.description ~= nil and cd.description ~= "")
                and cd.description or UTILS.GetText("options2", "unnamed_condition"),
        }
    end
    sort_entries(conds)

    for _, c in ipairs(conds) do
        local ckey = "c_" .. wi .. "_" .. tmi .. "_" .. c.idx
        local ci, cd = c.idx, c.data
        self:_Add(self:_GetOrCreate(ckey, function()
            return Options2ContentCondition(self, wi, tmi, ci, cd, ckey)
        end), w)

        for _, e in ipairs(self:_TriggerEntries(cd)) do
            local ctkey = "ct_" .. wi .. "_" .. tmi .. "_" .. ci .. "_" .. e.tt .. "_" .. e.idx
            local tt, ti, td = e.tt, e.idx, e.data
            self:_Add(self:_GetOrCreate(ctkey, function()
                return Options2ContentCondTrigger(self, wi, tmi, ci, td, tt, ti, ctkey)
            end), w)
        end
    end
end

-- ── header ─────────────────────────────────────────────────────────────────────

function Options2.Window.Content.Constructor:_RefreshHeader()
    local c = self.container

    if c == nil then
        self.head_mark:SetBackColor(nil)
        self.head_name:SetText("")
        self.head_meta:SetText("")
        self.btn_timer:SetVisible(false)
        self.btn_trigger:SetVisible(false)
        self:SizeChanged()
        return
    end

    local is_window = (c.nodeType == "window")
    self.head_mark:SetBackColor(is_window and Options.Defaults.window.color_window
                                          or  Options.Defaults.window.color_folder)

    local name = c.data.name
    if name == nil or name == "" then
        name = UTILS.GetText("options2",
            is_window and "unnamed_window" or "unnamed_folder")
    end
    self.head_name:SetText(name)

    if is_window then
        local wd = Data.window[c.windowIndex]
        local n  = (wd ~= nil and wd.timerList ~= nil) and #wd.timerList or 0
        self.head_meta:SetText(string.format(UTILS.GetText("options2", "meta_timers"), n))
    else
        local fd = Data.folder[c.folderIndex]
        local n  = 0
        if fd ~= nil then
            for _, tt in ipairs(Options2.TriggerTypes()) do n = n + #(fd[tt] or {}) end
        end
        self.head_meta:SetText(string.format(UTILS.GetText("options2", "meta_triggers"), n))
    end

    self.btn_timer:SetVisible(is_window)
    self.btn_trigger:SetVisible(true)
    self:SizeChanged()
end

function Options2.Window.Content.Constructor:_ShowAddTriggerMenu()
    local c = self.container
    if c == nil then return end
    local owner = (c.nodeType == "window") and Data.window[c.windowIndex]
                                           or  Data.folder[c.folderIndex]
    if owner == nil then return end
    Options2.ShowAddTriggerMenu(owner)
end

-- ── selection ──────────────────────────────────────────────────────────────────

function Options2.Window.Content.Constructor:_RestoreSelection()
    if self.selectedKey == nil then return end
    for _, item in ipairs(self.items) do
        if item:IsSelectable() and item:GetKey() == self.selectedKey then
            item:SetSelected(true)
            self.selectedItem = item
            Options2.selectedNode = item.nodeData
            local obj = Options2.Window.Object
            if obj ~= nil and obj.editor_panel ~= nil then
                obj.editor_panel:SetNode(item.nodeData)
            end
            self:_UpdateHeaderState()
            return
        end
    end
end

function Options2.Window.Content.Constructor:_Select(item)
    if self.selectedItem ~= nil and self.selectedItem ~= item then
        self.selectedItem:SetSelected(false)
    end
    self.selectedItem = item
    self.selectedKey  = item:GetKey()
    item:SetSelected(true)
    Options2.SaveContentState(self.selectedKey)
    Options2.selectedNode = item.nodeData

    local obj = Options2.Window.Object
    if obj ~= nil and obj.editor_panel ~= nil then
        obj.editor_panel:SetNode(item.nodeData)
    end
    self:_UpdateHeaderState()
end

function Options2.Window.Content.Constructor:RowClicked(item)
    if not item:IsSelectable() then return end
    self:_Select(item)
end

function Options2.Window.Content.Constructor:RowRightClicked(item)
    if not item:IsSelectable() then return end
    if self.selectedItem ~= item then self:_Select(item) end
    Options2.ShowContextMenu(item.nodeData)
end
