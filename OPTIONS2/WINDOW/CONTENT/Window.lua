-- Contents column: the selection surface for everything inside the container
-- picked in the structure column.
--   window -> its own triggers, then each timer with its triggers, its
--             conditions, and each condition's triggers
--   folder -> its own triggers only; sub-folders and windows stay in column 1
-- Row click selects into the editor; the structure column keeps the container
-- selection.

local HEADER_H = 34
-- the header stacks the name over the hint that says what clicking it does
local NAME_H   = 20
local HINT_H   = HEADER_H - NAME_H
local SEP_H    = 1
local LIST_TOP = HEADER_H + SEP_H
local SCROLL_W = 10
local PAD      = 10
local GAP      = 8
local MARK     = 16
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

    self.head_mark = Options2.Elements.RowParts.MakeIcon(self.header, nil, HEADER_H)

    self.head_name = Turbine.UI.Label()
    self.head_name:SetParent(self.header)
    self.head_name:SetHeight(NAME_H)
    self.head_name:SetFont(FONT_NAME)
    self.head_name:SetForeColor(Options.Defaults.window.text)
    self.head_name:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.head_name:SetMouseVisible(false)

    self.head_meta = Turbine.UI.Label()
    self.head_meta:SetParent(self.header)
    self.head_meta:SetHeight(NAME_H)
    self.head_meta:SetFont(FONT_SMALL)
    self.head_meta:SetForeColor(Options.Defaults.window.text_faint)
    self.head_meta:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.head_meta:SetMouseVisible(false)

    -- the header is not an obvious button, so it says so in as many words
    self.head_hint = Turbine.UI.Label()
    self.head_hint:SetParent(self.header)
    self.head_hint:SetHeight(HINT_H)
    self.head_hint:SetFont(FONT_SMALL)
    self.head_hint:SetForeColor(Options.Defaults.window.text_faint)
    self.head_hint:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.head_hint:SetMouseVisible(false)

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

    self:_InitDrag()
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
    self.head_hint:SetPosition(name_left, NAME_H)
    self.head_hint:SetWidth(avail)

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

    if self._drag_ghost ~= nil then
        self._drag_ghost:SetWidth(list_w)
        self._drag_ghost_lbl:SetWidth(math.max(0, list_w - 16))
        self._drag_line:SetWidth(list_w)
        self._drag_hl:SetWidth(list_w)
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

    Options2.SetEditorNode(self.container)
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

-- Timers keep a manual order the player sets by dragging, held in each timer's
-- sortIndex — the same field the HUD orders by, so the two agree. sortIndex can
-- be missing or repeated on imported or hand-edited data, so the position in
-- timerList breaks ties and the order stays stable either way.
local function timer_order(wd)
    local order = {}
    for tmi, tmd in ipairs(wd.timerList or {}) do
        order[#order + 1] = { idx = tmi, data = tmd, sort = tonumber(tmd.sortIndex) or 0 }
    end
    table.sort(order, function(a, b)
        if a.sort ~= b.sort then return a.sort < b.sort end
        return a.idx < b.idx
    end)
    return order
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

    self:_AddSection("sec_timers", UTILS.GetText("options2", "timers_order"), w)

    for _, t in ipairs(timer_order(wd)) do
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
        self.head_mark:SetVisible(false)
        self.head_name:SetText("")
        self.head_meta:SetText("")
        self.head_hint:SetText("")
        self.btn_timer:SetVisible(false)
        self.btn_trigger:SetVisible(false)
        self:SizeChanged()
        return
    end

    local is_window = (c.nodeType == "window")
    self.head_mark:SetBackground(Options2.Elements.RowParts.IconForNode(c.nodeType))
    self.head_mark:SetVisible(true)

    local name = c.data.name
    if name == nil or name == "" then
        name = UTILS.GetText("options2",
            is_window and "unnamed_window" or "unnamed_folder")
    end
    self.head_name:SetText(name)
    self.head_hint:SetText(UTILS.GetText("options2",
        is_window and "header_hint_window" or "header_hint_folder"))

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
            Options2.SetEditorNode(item.nodeData)
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

    Options2.SetEditorNode(item.nodeData)
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

-- ── drag and drop ──────────────────────────────────────────────────────────────
-- Two gestures share one set of handlers, told apart by what is being dragged:
--
--   a timer   reorders the window's timers. It drops *between* timer blocks, and
--             the new order is written back as sortIndex.
--   a trigger moves to another container. It drops *onto* a timer, a condition,
--             or the header — never between rows, because triggers keep a fixed
--             order inside whatever holds them, so there is no position to pick.

local DRAG_THRESH = 5
local GHOST_H     = 26

local DRAG_OK      = Turbine.UI.Color(0.569, 0.518, 0.851, 0.55)  -- accent
local DRAG_NO      = Turbine.UI.Color(0.749, 0.200, 0.282, 0.50)  -- warn
local DRAG_TARGET  = Turbine.UI.Color(0.569, 0.518, 0.851, 0.35)

local TRIGGER_NODE = {
    trigger          = true,
    conditiontrigger = true,
    windowtrigger    = true,
    foldertrigger    = true,
}

-- which trigger list a container of this node type owns
local CONTAINER_TO_TRIGGER_NT = {
    folder    = "foldertrigger",
    window    = "windowtrigger",
    timer     = "trigger",
    condition = "conditiontrigger",
}

function Options2.Window.Content.Constructor:_InitDrag()
    self._drag = {
        pending = false, active = false, item = nil, startY = 0,
        mode = nil, valid = false, slot = nil, target = nil,
        offsets = {}, blocks = {}, scroll = 0,
    }
    self._drag_just_ended = false

    -- a parented Turbine.UI.Window starts hidden and draws behind its parent, so
    -- both of these need SetVisible and a z-order above the panel fill
    self._drag_ghost = Turbine.UI.Window()
    self._drag_ghost:SetParent(self)
    self._drag_ghost:SetHeight(GHOST_H)
    self._drag_ghost:SetBackColor(DRAG_OK)
    self._drag_ghost:SetZOrder(500)
    self._drag_ghost:SetVisible(false)
    self._drag_ghost:SetMouseVisible(false)

    self._drag_ghost_lbl = Turbine.UI.Label()
    self._drag_ghost_lbl:SetParent(self._drag_ghost)
    self._drag_ghost_lbl:SetPosition(8, 0)
    self._drag_ghost_lbl:SetHeight(GHOST_H)
    self._drag_ghost_lbl:SetFont(Turbine.UI.Lotro.Font.Verdana12)
    self._drag_ghost_lbl:SetForeColor(Options.Defaults.window.text)
    self._drag_ghost_lbl:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self._drag_ghost_lbl:SetZOrder(501)
    self._drag_ghost_lbl:SetMouseVisible(false)

    -- insertion line, timer reorder only
    self._drag_line = Turbine.UI.Control()
    self._drag_line:SetParent(self)
    self._drag_line:SetHeight(2)
    self._drag_line:SetBackColor(Options.Defaults.window.accent)
    self._drag_line:SetZOrder(499)
    self._drag_line:SetVisible(false)
    self._drag_line:SetMouseVisible(false)

    -- target fill, trigger move only
    self._drag_hl = Turbine.UI.Window()
    self._drag_hl:SetParent(self)
    self._drag_hl:SetHeight(GHOST_H)
    self._drag_hl:SetBackColor(DRAG_TARGET)
    self._drag_hl:SetZOrder(499)
    self._drag_hl:SetVisible(false)
    self._drag_hl:SetMouseVisible(false)
end

function Options2.Window.Content.Constructor:_DragBegin(item, args)
    local nd = item.nodeData
    if nd == nil then return end
    if nd.nodeType ~= "timer" and not TRIGGER_NODE[nd.nodeType] then return end

    self._drag.pending = true
    self._drag.active  = false
    self._drag.item    = item
    self._drag.startY  = args.Y
    self._drag.mode    = nil
    self._drag.valid   = false
    self._drag.slot    = nil
    self._drag.target  = nil
end

-- Row offsets down the list, and the timer blocks — a timer row plus every child
-- row beneath it. Taken once, when the drag starts: the insertion line has to be
-- placed against a block boundary the cursor is not necessarily over.
function Options2.Window.Content.Constructor:_MeasureRows()
    local offsets, blocks, y, cur = {}, {}, 0, nil

    for _, it in ipairs(self.items) do
        offsets[it] = y
        local nd = it.nodeData

        if nd ~= nil and nd.nodeType == "timer" then
            cur = { top = y, timerIndex = nd.timerIndex }
            blocks[#blocks + 1] = cur
        elseif nd == nil then
            cur = nil          -- a section band closes the run
        end

        y = y + it:GetHeight()
        if cur ~= nil then cur.bottom = y end
    end

    self._drag.offsets = offsets
    self._drag.blocks  = blocks
end

-- The list scrolls, so a row's offset down the list and its position on screen
-- differ. Whichever row the cursor is over gives both at once, which is enough
-- to place the indicator anywhere in the list.
function Options2.Window.Content.Constructor:_TrackScroll(list_y)
    for _, it in ipairs(self.items) do
        local _, iy = it:GetMousePosition()
        if iy >= 0 and iy < it:GetHeight() then
            self._drag.scroll = (self._drag.offsets[it] or 0) - (list_y - iy)
            return
        end
    end
end

function Options2.Window.Content.Constructor:_DragActivate(item)
    local nd = item.nodeData
    local w  = self.listbox:GetWidth()

    local text
    if nd.nodeType == "timer" then
        text = (nd.data.description ~= nil and nd.data.description ~= "")
            and nd.data.description or UTILS.GetText("options2", "unnamed_timer")
    else
        text = Options2.Elements.RowParts.TriggerLabel(nd.data, nd.triggerType)
    end

    self._drag_ghost_lbl:SetText(text)
    self._drag_ghost:SetWidth(w)
    self._drag_ghost_lbl:SetWidth(math.max(0, w - 16))
    self._drag_line:SetWidth(w)
    self._drag_hl:SetWidth(w)
    self._drag_ghost:SetVisible(true)

    self:_MeasureRows()
    self._drag.active = true
end

function Options2.Window.Content.Constructor:_DragMove(item, args)
    if not self._drag.pending or self._drag.item ~= item then return end

    if not self._drag.active then
        if math.abs(args.Y - self._drag.startY) < DRAG_THRESH then return end
        self:_DragActivate(item)
    end

    local _, list_y = self.listbox:GetMousePosition()
    self._drag_ghost:SetTop(LIST_TOP + list_y - math.floor(GHOST_H / 2))
    self:_TrackScroll(list_y)

    if item.nodeData.nodeType == "timer" then
        self:_DragMoveTimer(list_y)
    else
        self:_DragMoveTrigger(list_y)
    end
end

function Options2.Window.Content.Constructor:_DragInvalid(mode)
    self._drag.mode   = mode
    self._drag.valid  = false
    self._drag.target = nil
    self._drag_line:SetVisible(false)
    self._drag_hl:SetVisible(false)
    self._drag_ghost:SetBackColor(DRAG_NO)
end

function Options2.Window.Content.Constructor:_DragMoveTimer(list_y)
    local blocks = self._drag.blocks
    if #blocks == 0 then
        self:_DragInvalid("no_blocks")
        return
    end

    local cy = list_y + self._drag.scroll

    -- the boundary the cursor is nearest: 0 is above the first block, #blocks is
    -- below the last. A block's midpoint is where it flips.
    local slot = #blocks
    for i, b in ipairs(blocks) do
        if cy < (b.top + b.bottom) / 2 then
            slot = i - 1
            break
        end
    end

    self._drag.mode  = "reorder"
    self._drag.slot  = slot
    self._drag.valid = true
    self._drag_hl:SetVisible(false)
    self._drag_ghost:SetBackColor(DRAG_OK)

    -- the line still marks a real drop even when the boundary has scrolled out
    -- of view; it just cannot be drawn there
    local boundary = (slot == 0) and blocks[1].top or blocks[slot].bottom
    local y        = boundary - self._drag.scroll
    if y < 0 or y > self.listbox:GetHeight() then
        self._drag_line:SetVisible(false)
    else
        self._drag_line:SetTop(LIST_TOP + y - 1)
        self._drag_line:SetVisible(true)
    end
end

function Options2.Window.Content.Constructor:_DragMoveTrigger(list_y)
    -- the header is the row for the container itself, and sits above the list
    local _, hy = self.header:GetMousePosition()
    if self.container ~= nil and hy >= 0 and hy < HEADER_H then
        self:_SetTriggerTarget(self.container, 0, HEADER_H)
        return
    end

    for _, it in ipairs(self.items) do
        local nd = it.nodeData
        if nd ~= nil and (nd.nodeType == "timer" or nd.nodeType == "condition") then
            local _, iy = it:GetMousePosition()
            local h     = it:GetHeight()
            if iy >= 0 and iy < h then
                self:_SetTriggerTarget(nd, LIST_TOP + list_y - iy, h)
                return
            end
        end
    end

    self:_DragInvalid("no_target")
end

-- A drop onto the container the trigger already sits in would move nothing, so
-- it reads as invalid rather than silently doing nothing.
function Options2.Window.Content.Constructor:_SetTriggerTarget(target_nd, top, h)
    local nd     = self._drag.item.nodeData
    local tgt_nt = CONTAINER_TO_TRIGGER_NT[target_nd.nodeType]

    local src_arr = self:_GetTriggerArray(nd,        nd.nodeType, nd.triggerType)
    local tgt_arr = tgt_nt and self:_GetTriggerArray(target_nd, tgt_nt, nd.triggerType)

    if tgt_arr == nil or tgt_arr == src_arr then
        self:_DragInvalid("same_container")
        return
    end

    self._drag.mode   = "move"
    self._drag.target = target_nd
    self._drag.valid  = true
    self._drag_line:SetVisible(false)
    self._drag_hl:SetHeight(h)
    self._drag_hl:SetTop(top)
    self._drag_hl:SetVisible(true)
    self._drag_ghost:SetBackColor(DRAG_OK)
end

function Options2.Window.Content.Constructor:_DragFinish(item, args)
    if not self._drag.pending or self._drag.item ~= item then return end

    local was_active = self._drag.active
    self._drag.pending    = false
    self._drag.active     = false
    self._drag_just_ended = was_active
    self._drag_ghost:SetVisible(false)
    self._drag_line:SetVisible(false)
    self._drag_hl:SetVisible(false)

    if not was_active or not self._drag.valid then return end

    local nd = item.nodeData
    if self._drag.mode == "reorder" then
        self:_CommitTimerReorder(nd, self._drag.slot)
    elseif self._drag.mode == "move" and self._drag.target ~= nil then
        self:_CommitTriggerMove(nd, self._drag.target)
    else
        return
    end

    Options.SaveData()

    local wi = nd.windowIndex
    if wi == nil and self.container ~= nil then wi = self.container.windowIndex end
    if wi ~= nil then Options.DataChanged(wi) end

    -- moving a trigger shifts array indices, which invalidates the index-based
    -- row caches in both columns
    Options2.RefreshAll()
end

-- Writes the new order back as sortIndex. The whole window is renumbered from 1
-- so the values stay dense, whatever gaps or repeats the data arrived with.
function Options2.Window.Content.Constructor:_CommitTimerReorder(nd, slot)
    local wd = Data.window[nd.windowIndex]
    if wd == nil or slot == nil then return end

    local order = {}
    for _, b in ipairs(self._drag.blocks) do order[#order + 1] = b.timerIndex end

    local from = nil
    for i, ti in ipairs(order) do
        if ti == nd.timerIndex then from = i; break end
    end
    if from == nil then return end

    -- slot counts boundaries in the list as it stands; taking the dragged timer
    -- out first shifts every boundary below it up by one
    table.remove(order, from)
    local to = (slot < from) and (slot + 1) or slot
    if to < 1 then to = 1 end
    if to > #order + 1 then to = #order + 1 end
    table.insert(order, to, nd.timerIndex)

    for i, ti in ipairs(order) do
        if wd.timerList[ti] ~= nil then wd.timerList[ti].sortIndex = i end
    end
    wd.nextTimerSortIndex = #order + 1
end

function Options2.Window.Content.Constructor:_GetTriggerArray(ref_nd, nt, tt)
    local owner
    if nt == "foldertrigger" then
        owner = Data.folder[ref_nd.folderIndex]
    elseif nt == "windowtrigger" then
        owner = Data.window[ref_nd.windowIndex]
    elseif nt == "trigger" then
        local wd = Data.window[ref_nd.windowIndex]
        owner = wd and wd.timerList[ref_nd.timerIndex]
    elseif nt == "conditiontrigger" then
        local wd  = Data.window[ref_nd.windowIndex]
        local tmd = wd and wd.timerList[ref_nd.timerIndex]
        owner = tmd and tmd.conditionList and tmd.conditionList[ref_nd.conditionIndex]
    end

    if owner == nil then return nil end
    if owner[tt] == nil then owner[tt] = {} end
    return owner[tt]
end

-- The trigger keeps its type, so it lands in the same per-type list on the other
-- side and takes its place in that container's fixed order. Only its action may
-- need adjusting: not every action means anything to every kind of container.
function Options2.Window.Content.Constructor:_CommitTriggerMove(nd, target_nd)
    local tgt_nt = CONTAINER_TO_TRIGGER_NT[target_nd.nodeType]
    if tgt_nt == nil then return end

    local src_arr = self:_GetTriggerArray(nd,        nd.nodeType, nd.triggerType)
    local tgt_arr = self:_GetTriggerArray(target_nd, tgt_nt,      nd.triggerType)
    if src_arr == nil or tgt_arr == nil or src_arr == tgt_arr then return end

    table.remove(src_arr, nd.triggerIndex)
    table.insert(tgt_arr, nd.data)

    self:_ResetActionIfInvalid(nd.data, tgt_nt, target_nd)
end

function Options2.Window.Content.Constructor:_ResetActionIfInvalid(trigData, nt, tgt_nd)
    local a = trigData.action

    if nt == "foldertrigger" then
        if a ~= Action.Enable and a ~= Action.Disable and a ~= Action.Reset then
            trigData.action = Action.Enable
        end
    elseif nt == "windowtrigger" then
        if a ~= Action.Enable and a ~= Action.Disable and a ~= Action.Clear
            and a ~= Action.Reset then
            trigData.action = Action.Enable
        end
    elseif nt == "trigger" then
        local wd         = Data.window[tgt_nd.windowIndex]
        local is_counter = wd ~= nil and wd.timerType == Timer.Types.COUNTER_BAR
        if a ~= Action.Add and a ~= Action.Remove and a ~= Action.Enable
            and a ~= Action.Disable and not (is_counter and a == Action.Subtract) then
            trigData.action = Action.Add
        end
    elseif nt == "conditiontrigger" then
        if a ~= Action.Add and a ~= Action.Remove then
            trigData.action = Action.Add
        end
    end
end
