local HEADER_H  = 26
local SEARCH_H  = 24
local FOOTER_H  = 20
local SEP_H     = 1
local ITEM_H    = 26
local SCROLL_W  = 10
local BTN_SIZE  = 20
local BTN_GAP   = 4
local BTN_ICON  = 16
local PAD       = 8
local LIST_TOP  = HEADER_H + SEARCH_H + SEP_H

local FONT_SMALL = Turbine.UI.Lotro.Font.Verdana10
local FONT_BODY  = Turbine.UI.Lotro.Font.Verdana12

-- accent_color, when given, draws a 2px bar under the glyph. A .tga background
-- cannot be tinted (SetBackColor fills the control behind it rather than
-- colouring it), so a button's colour coding is carried by this bar.
-- Tooltip.AddTooltip owns MouseEnter/MouseLeave, so wrap it to keep the hover
local function add_hover_tooltip(control, description, enter_fn, leave_fn)
    Options2.Elements.Tooltip.AddTooltip(control, "tooltip", description, false)
    local tip_enter, tip_leave = control.MouseEnter, control.MouseLeave
    control.MouseEnter = function(sender, args) tip_enter(sender, args) enter_fn() end
    control.MouseLeave = function(sender, args) tip_leave(sender, args) leave_fn() end
end

local function make_nav_btn(parent, icon_path, click_fn, tooltip)
    local btn = Turbine.UI.Control()
    btn:SetParent(parent)
    btn:SetSize(BTN_SIZE, BTN_SIZE)
    btn:SetTop(math.floor((HEADER_H - BTN_SIZE) / 2))
    btn:SetMouseVisible(true)

    local icon = Turbine.UI.Control()
    icon:SetParent(btn)
    icon:SetSize(BTN_ICON, BTN_ICON)
    icon:SetPosition(math.floor((BTN_SIZE - BTN_ICON) / 2),
                     math.floor((BTN_SIZE - BTN_ICON) / 2))
    icon:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    icon:SetBackground(icon_path)
    icon:SetMouseVisible(false)

    add_hover_tooltip(btn, tooltip,
        function() btn:SetBackColor(Options.Defaults.window.select) end,
        function() btn:SetBackColor(nil) end)
    btn.MouseClick = click_fn

    return btn
end

Options2.Window.Nav = {}
Options2.Window.Nav.Constructor = class(Turbine.UI.Control)

function Options2.Window.Nav.Constructor:Constructor()
    Turbine.UI.Control.Constructor(self)

    self.expanded     = {}
    self.selectedKey  = Options2.LoadNavState()
    self.selectedItem = nil
    self.items        = {}
    self.filter       = ""
    self._initial_restore = (self.selectedKey ~= nil)
    self._itemCache   = {}
    self._last_list_w = -1
    self._add_mode    = "listbox"

    self.trig_types = Options2.TriggerTypes()


    self:SetBackColor(Options.Defaults.window.bg_sunken)

    -- ── header ───────────────────────────────────────────────────
    self.header = Turbine.UI.Control()
    self.header:SetParent(self)
    self.header:SetPosition(0, 0)
    self.header:SetHeight(HEADER_H)
    self.header:SetBackColor(Options.Defaults.window.row_even)
    self.header:SetMouseVisible(false)

    self.header_label = Turbine.UI.Label()
    self.header_label:SetParent(self.header)
    self.header_label:SetPosition(PAD, 0)
    self.header_label:SetHeight(HEADER_H)
    self.header_label:SetFont(FONT_SMALL)
    self.header_label:SetForeColor(Options.Defaults.window.text_muted)
    self.header_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.header_label:SetMouseVisible(false)

    self.add_folder_btn = make_nav_btn(self.header,
        "Gibberish3/RESOURCES/node_folder.tga",
        function()
            Folder.New(UTILS.GetText("options2", "new_folder"))
            Options.SaveData()
            self:RebuildFresh()
        end, "o2_add_folder")

    self.add_window_btn = make_nav_btn(self.header,
        "Gibberish3/RESOURCES/node_window.tga",
        function()
            Options2.ShowAddWindowMenu(nil)
        end, "o2_add_window")

    self.import_btn = make_nav_btn(self.header,
        "Gibberish3/RESOURCES/nav_btn_import.tga",
        function()
            local nd = Options2.selectedNode
            Options2.ShowImport(nd)
        end, "o2_import")

    self.collapse_btn = make_nav_btn(self.header,
        "Gibberish3/RESOURCES/nav_btn_collapse.tga",
        function()
            self:CollapseAll()
        end, "o2_collapse_all")

    -- ── search row ───────────────────────────────────────────────
    self.search_row = Turbine.UI.Control()
    self.search_row:SetParent(self)
    self.search_row:SetPosition(0, HEADER_H)
    self.search_row:SetHeight(SEARCH_H)
    self.search_row:SetMouseVisible(false)

    self.search_icon = Turbine.UI.Control()
    self.search_icon:SetParent(self.search_row)
    self.search_icon:SetSize(16, 16)
    self.search_icon:SetTop(math.floor((SEARCH_H - 16) / 2))
    self.search_icon:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    self.search_icon:SetBackground("Gibberish3/RESOURCES/search.tga")
    self.search_icon:SetMouseVisible(true)
    self.search_icon.MouseClick = function() self.search_box:Focus() end

    self.search_box = Turbine.UI.TextBox()
    self.search_box:SetParent(self.search_row)
    self.search_box:SetHeight(SEARCH_H - 4)
    self.search_box:SetTop(2)
    self.search_box:SetFont(FONT_BODY)
    self.search_box:SetForeColor(Options.Defaults.window.text)
    self.search_box:SetBackColor(nil)
    self.search_box:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.search_box:SetMultiline(false)
    self.search_box:SetSelectable(true)
    self.search_box.TextChanged = function()
        self.filter = self.search_box:GetText():lower()
        self.search_clear:SetVisible(self.filter ~= "")
        self.search_hint:SetVisible(self.filter == "")
        self:Rebuild()
    end

    -- Turbine.UI.TextBox has no placeholder, so this label sits over the empty box
    self.search_hint = Turbine.UI.Label()
    self.search_hint:SetParent(self.search_row)
    self.search_hint:SetHeight(SEARCH_H)
    self.search_hint:SetFont(FONT_BODY)
    self.search_hint:SetForeColor(Options.Defaults.window.text_faint)
    self.search_hint:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.search_hint:SetMouseVisible(false)

    self.search_clear = Turbine.UI.Button()
    self.search_clear:SetSize(20, 20)
    self.search_clear:SetParent(self.search_box)
    self.search_clear:SetText("x")
    self.search_clear:SetFont(FONT_BODY)
    self.search_clear:SetVisible(false)
    self.search_clear.Click = function()
        self.search_box:SetText("")
        self.filter = ""
        self.search_clear:SetVisible(false)
        self.search_hint:SetVisible(true)
        self:Rebuild()
    end

    self.search_sep = Turbine.UI.Control()
    self.search_sep:SetParent(self)
    self.search_sep:SetPosition(0, HEADER_H + SEARCH_H)
    self.search_sep:SetHeight(SEP_H)
    self.search_sep:SetBackColor(Options.Defaults.window.line)
    self.search_sep:SetMouseVisible(false)

    -- ── flat-list ListBox (right-click events reach items) ────────
    self.listbox = Turbine.UI.ListBox()
    self.listbox:SetParent(self)
    self.listbox:SetBackColor(Options.Defaults.window.bg_sunken)

    self.scrollbar = Turbine.UI.Lotro.ScrollBar()
    self.scrollbar:SetParent(self)
    self.scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical)
    self.listbox:SetVerticalScrollBar(self.scrollbar)

    -- ── footer ───────────────────────────────────────────────────
    self.footer_sep = Turbine.UI.Control()
    self.footer_sep:SetParent(self)
    self.footer_sep:SetHeight(SEP_H)
    self.footer_sep:SetBackColor(Options.Defaults.window.line)
    self.footer_sep:SetMouseVisible(false)

    self.footer = Turbine.UI.Label()
    self.footer:SetParent(self)
    self.footer:SetHeight(FOOTER_H)
    self.footer:SetFont(FONT_SMALL)
    self.footer:SetForeColor(Options.Defaults.window.text_faint)
    self.footer:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.footer:SetMouseVisible(false)

    self:_RefreshTexts()
    self:_InitDrag()
end

function Options2.Window.Nav.Constructor:_RefreshTexts()
    self.header_label:SetText(UTILS.GetText("options2", "structure"))
    self.search_hint:SetText(UTILS.GetText("options2", "find_folder_window"))
    self:_RefreshFooter()
end

function Options2.Window.Nav.Constructor:_RefreshFooter()
    if self.footer == nil then return end
    self.footer:SetText(string.format(
        UTILS.GetText("options2", "footer_counts"), #Data.folder, #Data.window))
end

-- repaint every visible row's enable box (a folder box reflects its subtree)
function Options2.Window.Nav.Constructor:RefreshEnabledStates()
    for _, item in ipairs(self.items) do
        if item.RefreshEnabled ~= nil then item:RefreshEnabled() end
    end
end

-- ── item cache ─────────────────────────────────────────────────────────────────

function Options2.Window.Nav.Constructor:ClearItemCache()
    self._itemCache = {}
end

-- Returns the cached item for key, creating it if absent.
-- constructor_fn must return a new item when called with no args.
-- Calls item:Refresh(expanded, depth) to update display state.
function Options2.Window.Nav.Constructor:_GetOrCreate(key, constructor_fn, expanded, depth)
    local item = self._itemCache[key]
    if item == nil then
        item = constructor_fn()
        self._itemCache[key] = item
    else
        item:Refresh(expanded, depth)
    end
    return item
end

-- ── size ───────────────────────────────────────────────────────────────────────

function Options2.Window.Nav.Constructor:SizeChanged()
    if self.header == nil then return end
    local w, h = self:GetSize()
    if w <= 0 or h <= 0 then return end
    local list_w = w - SCROLL_W

    self.header:SetWidth(w)

    -- header buttons, right to left; a hidden one takes no room
    local x = w - PAD
    for _, btn in ipairs({ self.collapse_btn, self.import_btn,
                           self.add_window_btn, self.add_folder_btn }) do
        if btn:IsVisible() then
            x = x - BTN_SIZE
            btn:SetLeft(x)
            x = x - BTN_GAP
        end
    end
    self.header_label:SetWidth(math.max(0, x - PAD))

    -- search row
    self.search_row:SetWidth(w)
    self.search_sep:SetWidth(w)
    local search_left = PAD + 16 + 6
    local search_w    = math.max(0, w - search_left - PAD)
    self.search_icon:SetLeft(PAD)
    self.search_box:SetPosition(search_left, 2)
    self.search_box:SetWidth(search_w)
    self.search_hint:SetPosition(search_left + 2, 0)
    self.search_hint:SetWidth(search_w)
    self.search_clear:SetPosition(search_w - 24, math.floor((SEARCH_H - 4 - 20) / 2))

    -- list
    local list_top   = HEADER_H + SEARCH_H + SEP_H
    local footer_top = h - FOOTER_H
    local view_h     = math.max(0, footer_top - SEP_H - list_top)
    self.listbox:SetPosition(0, list_top)
    self.listbox:SetSize(list_w, view_h)

    self.scrollbar:SetPosition(list_w, list_top)
    self.scrollbar:SetSize(SCROLL_W, view_h)

    -- footer
    self.footer_sep:SetPosition(0, footer_top - SEP_H)
    self.footer_sep:SetWidth(w)
    self.footer:SetPosition(PAD, footer_top)
    self.footer:SetWidth(math.max(0, w - 2 * PAD))

    if list_w ~= self._last_list_w then
        self._last_list_w = list_w
        for _, item in ipairs(self.items) do
            item:SetWidth(list_w)
        end
    end

    if self._drag_ghost ~= nil then
        self._drag_ghost:SetWidth(list_w)
        self._drag_ghost_lbl:SetWidth(list_w - 8)
        self._drag_indicator:SetWidth(list_w)
        self._drag_folder_hl:SetWidth(list_w)
    end
end

-- Called after structural changes (add/delete/drag/duplicate) so stale cached
-- items for shifted indices are not reused.
function Options2.Window.Nav.Constructor:RebuildFresh()
    self:ClearItemCache()
    self:Rebuild()
end

-- ── expand helpers ─────────────────────────────────────────────────────────────

function Options2.Window.Nav.Constructor:_IsExpanded(key)
    if self.filter ~= "" then return true end
    return self.expanded[key] == true
end

-- ── filter predicates ──────────────────────────────────────────────────────────

function Options2.Window.Nav.Constructor:_FolderVisible(fi, fd)
    if self.filter == "" then return true end
    if (fd.name or ""):lower():find(self.filter, 1, true) then return true end
    for fi2, fd2 in ipairs(Data.folder) do
        if fd2.folder == fi and self:_FolderVisible(fi2, fd2) then return true end
    end
    for wi, wd in ipairs(Data.window) do
        if wd.folder == fi and self:_WindowVisible(wd) then return true end
    end
    return false
end

function Options2.Window.Nav.Constructor:_WindowVisible(wd)
    if self.filter == "" then return true end
    if (wd.name or ""):lower():find(self.filter, 1, true) then return true end
    for _, tmd in ipairs(wd.timerList or {}) do
        if (tmd.description or ""):lower():find(self.filter, 1, true) then return true end
    end
    return false
end

-- ── ensure ancestor nodes are expanded so a key is visible ────────────────────

-- Only folders nest in this column. Keys saved by an older version may name a
-- timer or trigger; those simply resolve to nothing and the selection is
-- dropped, which is why every lookup here is guarded.
function Options2.Window.Nav.Constructor:_EnsureKeyVisible(key)
    if key == nil then return end
    local parts = {}
    for p in key:gmatch("[^_]+") do parts[#parts + 1] = p end
    local prefix = parts[1]

    local parent_folder = nil
    if prefix == "f" then
        local fi = tonumber(parts[2])
        if fi and Data.folder[fi] then parent_folder = Data.folder[fi].folder end
    elseif prefix == "w" then
        local wi = tonumber(parts[2])
        if wi and Data.window[wi] then parent_folder = Data.window[wi].folder end
    end

    if parent_folder ~= nil then
        local pkey = "f_" .. parent_folder
        self.expanded[pkey] = true
        self:_EnsureKeyVisible(pkey)
    end
end

-- ── rebuild ────────────────────────────────────────────────────────────────────

function Options2.Window.Nav.Constructor:Rebuild()
    if self._initial_restore then
        self:_EnsureKeyVisible(self.selectedKey)
        self._initial_restore = false
    end

    local new_items, list_w = self:_ComputeVisibleItems()

    self.listbox:ClearItems()
    self.selectedItem = nil

    for _, item in ipairs(new_items) do
        item:SetWidth(list_w)
        self.listbox:AddItem(item)
    end
    self.items = new_items

    self:_RefreshFooter()
    self:_RestoreSelection()
end

-- ── tree builders ──────────────────────────────────────────────────────────────

function Options2.Window.Nav.Constructor:_AddItem(item, w)
    if self._add_mode == "collect" then
        self._collected[#self._collected + 1] = item
        return
    end
    item:SetWidth(w)
    self.listbox:AddItem(item)
    self.items[#self.items + 1] = item
end

-- Run the tree traversal in collect mode and return an ordered array of visible
-- items (using the cache) plus the current list width.  Does not touch the listbox.
function Options2.Window.Nav.Constructor:_ComputeVisibleItems()
    self._add_mode = "collect"
    self._collected = {}

    local list_w = self.listbox:GetWidth()
    if list_w <= 0 then list_w = 260 end

    for _, entry in ipairs(self:_ChildrenOf(nil)) do
        if entry.kind == "folder" then
            self:_AddFolder(entry.idx, entry.data, list_w, 0)
        else
            self:_AddWindow(entry.idx, entry.data, list_w, 0)
        end
    end

    local result   = self._collected
    self._add_mode = "listbox"
    self._collected = nil
    return result, list_w
end

-- Update the listbox by diffing the current items against new_items.
-- Removes items that disappeared, adds items that are new, sorts by position.
-- Does not call ClearItems.
function Options2.Window.Nav.Constructor:_SurgicalUpdate()
    local new_items, list_w = self:_ComputeVisibleItems()

    local in_new = {}
    for i, it in ipairs(new_items) do
        in_new[it] = true
        it._sort_order = i
    end

    for _, it in ipairs(self.items) do
        if not in_new[it] then
            self.listbox:RemoveItem(it)
        end
    end

    local in_old = {}
    for _, it in ipairs(self.items) do in_old[it] = true end

    for _, it in ipairs(new_items) do
        if not in_old[it] then
            it:SetWidth(list_w)
            self.listbox:AddItem(it)
        end
    end

    self.listbox:Sort(function(a, b) return a._sort_order < b._sort_order end)
    self.items = new_items
    self:_RestoreSelection()
end

function Options2.Window.Nav.Constructor:_RestoreSelection()
    self.selectedItem = nil
    for _, item in ipairs(self.items) do
        if item:GetKey() == self.selectedKey then
            item:SetSelected(true)
            self.selectedItem = item
            local obj = Options2.Window.Object
            if obj ~= nil and obj.editor_panel ~= nil then
                obj.editor_panel:SetNode(item.nodeData)
            end
            if obj ~= nil and obj.contents ~= nil then
                obj.contents:SetContainer(item.nodeData)
            end
            if obj ~= nil and obj.simple ~= nil then
                obj.simple:SetContainer(item.nodeData)
            end
            return
        end
    end
end

-- Direct children of a folder (nil = root level), ordered per SPEC:
-- folders before windows, enabled before disabled, then A-Z case-insensitive.
function Options2.Window.Nav.Constructor:_ChildrenOf(folderIdx)
    local children = {}

    for fi, fd in ipairs(Data.folder) do
        if fd.folder == folderIdx then
            children[#children + 1] = {
                kind    = "folder",
                idx     = fi,
                data    = fd,
                enabled = self:_FolderEnabled(fi),
            }
        end
    end
    for wi, wd in ipairs(Data.window) do
        if wd.folder == folderIdx then
            children[#children + 1] = {
                kind    = "window",
                idx     = wi,
                data    = wd,
                enabled = (wd.enabled == true),
            }
        end
    end

    table.sort(children, function(a, b)
        if a.kind ~= b.kind then return a.kind == "folder" end
        if a.enabled ~= b.enabled then return a.enabled end
        local an, bn = (a.data.name or ""):lower(), (b.data.name or ""):lower()
        if an ~= bn then return an < bn end
        return a.idx < b.idx
    end)

    return children
end

-- A folder has no enabled flag of its own; it counts as enabled when any window
-- in its subtree is.
function Options2.Window.Nav.Constructor:_FolderEnabled(folderIdx)
    for _, wi in ipairs(Folder.GetWindowIndices(folderIdx)) do
        if Data.window[wi] ~= nil and Data.window[wi].enabled == true then return true end
    end
    return false
end

function Options2.Window.Nav.Constructor:_AddFolder(fi, fd, w, depth)
    depth = depth or 0
    if not self:_FolderVisible(fi, fd) then return end
    local key = "f_" .. fi
    if self.expanded[key] == nil then
        self.expanded[key] = not (fd.collapsed == true)
    end
    local expanded = self:_IsExpanded(key)

    local nav = self
    self:_AddItem(self:_GetOrCreate(key,
        function() return Options2NavFolder(nav, fi, fd, key, expanded, depth) end,
        expanded, depth), w)

    if not expanded then return end

    for _, entry in ipairs(self:_ChildrenOf(fi)) do
        if entry.kind == "folder" then
            self:_AddFolder(entry.idx, entry.data, w, depth + 1)
        else
            self:_AddWindow(entry.idx, entry.data, w, depth + 1)
        end
    end
end

-- Windows are leaves here: their timers, triggers and conditions live in the
-- contents column.
function Options2.Window.Nav.Constructor:_AddWindow(wi, wd, w, depth)
    if not self:_WindowVisible(wd) then return end
    local key = "w_" .. wi

    local nav = self
    self:_AddItem(self:_GetOrCreate(key,
        function() return Options2NavWindow(nav, wi, wd, key, false, depth) end,
        false, depth), w)
end

-- ── interaction ────────────────────────────────────────────────────────────────

function Options2.Window.Nav.Constructor:SelectWindowByIndex(wi)
    local key = "w_" .. wi
    for _, item in ipairs(self.items) do
        if item:GetKey() == key then
            self:_SelectItem(item)
            return
        end
    end
    -- window node not currently visible — expand ancestors and show it
    self:_EnsureKeyVisible(key)
    self.selectedKey = key
    self:_SurgicalUpdate()
end

function Options2.Window.Nav.Constructor:_SelectItem(item)
    if self.selectedItem ~= nil and self.selectedItem ~= item then
        self.selectedItem:SetSelected(false)
    end
    self.selectedKey  = item:GetKey()
    self.selectedItem = item
    item:SetSelected(true)
    Options2.SaveNavState(self.selectedKey)
    Options2.selectedNode = item.nodeData

    local obj = Options2.Window.Object
    if obj ~= nil and obj.editor_panel ~= nil then
        obj.editor_panel:SetNode(item.nodeData)
    end
    -- picking a container refills the contents column and drops whatever row
    -- was selected inside the previous one
    if obj ~= nil and obj.contents ~= nil then
        obj.contents:ClearSelection()
        obj.contents:SetContainer(item.nodeData)
    end
    -- simple mode shows the same container in its own timers column
    if obj ~= nil and obj.simple ~= nil then
        obj.simple:SetContainer(item.nodeData)
    end
end

function Options2.Window.Nav.Constructor:_ToggleExpand(item)
    if not item:IsExpandable() or self.filter ~= "" then return end
    local key = item:GetKey()
    local now_expanded = not (self.expanded[key] == true)
    self.expanded[key] = now_expanded
    local nd = item.nodeData
    -- only folders nest in this column
    if nd.nodeType == "folder" then
        Data.folder[nd.folderIndex].collapsed = not now_expanded
    end

    if not now_expanded then
        -- Surgical collapse: just remove descendants from the listbox.
        item:SetExpanded(false)
        local d = item.depth
        local start = nil
        for i = 1, #self.items do
            if self.items[i] == item then start = i + 1; break end
        end
        if start then
            while start <= #self.items and self.items[start].depth > d do
                self.listbox:RemoveItem(self.items[start])
                table.remove(self.items, start)
            end
        end
    else
        -- Surgical expand: add newly-visible children and sort into position.
        self:_SurgicalUpdate()
    end
end

function Options2.Window.Nav.Constructor:ItemClicked(item)
    if self.selectedItem ~= item then
        local collapsed = not (self.expanded[item:GetKey()] == true)
        self:_SelectItem(item)
        if collapsed then
            self:_ToggleExpand(item)
        end
    else
        self:_ToggleExpand(item)
    end
end

function Options2.Window.Nav.Constructor:ItemRightClicked(item)
    if self.selectedItem ~= item then
        self:_SelectItem(item)
    end
    Options2.ShowContextMenu(item.nodeData)
end

function Options2.Window.Nav.Constructor:CollapseAll()
    for _, fd in ipairs(Data.folder) do
        fd.collapsed = true
    end
    self.expanded = {}
    self:Rebuild()
end

function Options2.Window.Nav.Constructor:LanguageChanged()
    self:_RefreshTexts()
    self:Rebuild()
end

-- ── drag and drop ──────────────────────────────────────────────────────────────

local DRAG_THRESH = 5

local CONTAINER_TO_TRIGGER_NT = {
    folder    = "foldertrigger",
    window    = "windowtrigger",
    timer     = "trigger",
    condition = "conditiontrigger",
}

function Options2.Window.Nav.Constructor:_InitDrag()
    self._drag = {
        pending=false, active=false, item=nil, startY=0,
        dropAfterIdx=0, valid=false,
        dropMode="between",       -- "between" or "into"
        dropIntoFolderItem=nil,
    }
    self._drag_just_ended = false

    self._drag_ghost = Turbine.UI.Window()
    self._drag_ghost:SetParent(self)
    self._drag_ghost:SetHeight(ITEM_H)
    self._drag_ghost:SetBackColor(Turbine.UI.Color(0.5, 0.3, 0.5, 0.6))
    self._drag_ghost:SetZOrder(500)
    self._drag_ghost:SetVisible(false)
    self._drag_ghost:SetMouseVisible(false)

    self._drag_ghost_lbl = Turbine.UI.Label()
    self._drag_ghost_lbl:SetParent(self._drag_ghost)
    self._drag_ghost_lbl:SetPosition(8, 0)
    self._drag_ghost_lbl:SetHeight(ITEM_H)
    self._drag_ghost_lbl:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self._drag_ghost_lbl:SetFont(Options.Defaults.window.font)
    self._drag_ghost_lbl:SetForeColor(Options.Defaults.window.text)
    self._drag_ghost_lbl:SetMouseVisible(false)

    self._drag_indicator = Turbine.UI.Control()
    self._drag_indicator:SetParent(self)
    self._drag_indicator:SetHeight(2)
    self._drag_indicator:SetBackColor(Turbine.UI.Color(1.0, 0.85, 0.2))
    self._drag_indicator:SetZOrder(499)
    self._drag_indicator:SetVisible(false)
    self._drag_indicator:SetMouseVisible(false)

    self._drag_folder_hl = Turbine.UI.Window()
    self._drag_folder_hl:SetParent(self)
    self._drag_folder_hl:SetHeight(ITEM_H)
    self._drag_folder_hl:SetBackColor(Turbine.UI.Color(0.3, 0.25, 0.6, 0.5))
    self._drag_folder_hl:SetZOrder(499)
    self._drag_folder_hl:SetVisible(false)
    self._drag_folder_hl:SetMouseVisible(false)
end

function Options2.Window.Nav.Constructor:_DragBegin(item, args)
    local nt = item.nodeData.nodeType
    if nt ~= "folder" and nt ~= "window" and nt ~= "timer" and nt ~= "condition"
        and nt ~= "foldertrigger" and nt ~= "windowtrigger"
        and nt ~= "trigger" and nt ~= "conditiontrigger" then return end
    self._drag.pending            = true
    self._drag.active             = false
    self._drag.item               = item
    self._drag.startY             = args.Y
    self._drag.dropAfterIdx       = -1    -- sentinel: force update on first move
    self._drag.dropMode           = nil
    self._drag.dropIntoFolderItem = nil
end

function Options2.Window.Nav.Constructor:_DragMove(item, args)
    if not self._drag.pending or self._drag.item ~= item then return end

    if not self._drag.active then
        if math.abs(args.Y - self._drag.startY) < DRAG_THRESH then return end
        local nd = item.nodeData
        local w  = self.listbox:GetWidth()
        self._drag_ghost_lbl:SetText(nd.data.name or nd.data.description or "")
        self._drag_ghost:SetWidth(w)
        self._drag_ghost_lbl:SetWidth(w - 8)
        self._drag_indicator:SetWidth(w)
        self._drag_ghost:SetVisible(true)
        self._drag.active = true
    end

    -- GetItemAt handles scrolling internally; list_y is in listbox visual coords
    local lx, list_y = self.listbox:GetMousePosition()
    local hover      = self.listbox:GetItemAt(lx, list_y)

    -- Ghost always tracks the mouse
    self._drag_ghost:SetTop(LIST_TOP + list_y - math.floor(ITEM_H / 2))

    local nodeType = item.nodeData.nodeType

    -- Triggers can drop onto any parent container (folder/window/timer/condition)
    local is_trigger = nodeType == "foldertrigger" or nodeType == "windowtrigger"
        or nodeType == "trigger" or nodeType == "conditiontrigger"

    if is_trigger then
        -- Scan items directly by cursor position (avoids GetItemAt returning sub-controls)
        local target = nil
        for _, it in ipairs(self.items) do
            if it.nodeData ~= nil then
                local nt = it.nodeData.nodeType
                if nt == "folder" or nt == "window" or nt == "timer" or nt == "condition" then
                    local _, iy = it:GetMousePosition()
                    if iy >= 0 and iy < ITEM_H then
                        target = it
                        break
                    end
                end
            end
        end
        if target then
            if target ~= self._drag.dropIntoFolderItem or self._drag.dropMode ~= "into" then
                self._drag.dropMode           = "into"
                self._drag.dropIntoFolderItem = target
                self._drag.valid              = true
                local _, iy    = target:GetMousePosition()
                local item_top = list_y - iy
                self._drag_folder_hl:SetTop(LIST_TOP + item_top)
                self._drag_folder_hl:SetVisible(true)
                self._drag_indicator:SetVisible(false)
                self._drag_ghost:SetBackColor(Turbine.UI.Color(0.5, 0.3, 0.5, 0.6))
            end
        else
            if self._drag.dropMode ~= "trig_invalid" then
                self._drag.dropMode           = "trig_invalid"
                self._drag.dropIntoFolderItem = nil
                self._drag.valid              = false
                self._drag_folder_hl:SetVisible(false)
                self._drag_indicator:SetVisible(false)
                self._drag_ghost:SetBackColor(Turbine.UI.Color(0.4, 0.25, 0.25, 0.5))
            end
        end
        return
    end

    -- "Drop into folder" when hovering over a folder row while dragging a folder or window
    local drop_into = hover ~= nil
        and hover.nodeData.nodeType == "folder"
        and (nodeType == "folder" or nodeType == "window")
        and hover ~= item

    if drop_into then
        -- Only update highlight if the target folder changed
        if hover ~= self._drag.dropIntoFolderItem or self._drag.dropMode ~= "into" then
            self._drag.dropMode           = "into"
            self._drag.dropIntoFolderItem = hover
            self._drag.valid              = true
            local _, iy    = hover:GetMousePosition()
            local item_top = list_y - iy
            self._drag_folder_hl:SetTop(LIST_TOP + item_top)
            self._drag_folder_hl:SetVisible(true)
            self._drag_indicator:SetVisible(false)
            self._drag_ghost:SetBackColor(Turbine.UI.Color(0.5, 0.3, 0.5, 0.6))
        end
        return
    end

    -- "Drop to root" when hovering over empty space while dragging a folder or window;
    -- indicator tracks the mouse continuously so always update
    if hover == nil and list_y > 0 and (nodeType == "folder" or nodeType == "window") then
        self._drag.dropMode           = "toroot"
        self._drag.dropIntoFolderItem = nil
        self._drag.valid              = true
        self._drag_folder_hl:SetVisible(false)
        self._drag_indicator:SetTop(LIST_TOP + list_y - 1)
        self._drag_indicator:SetVisible(true)
        self._drag_ghost:SetBackColor(Turbine.UI.Color(0.5, 0.3, 0.5, 0.6))
        return
    end

    -- Folder/window drags only support "into" and "toroot"
    if nodeType == "folder" or nodeType == "window" then
        if self._drag.dropMode ~= "fw_invalid" then
            self._drag.dropMode           = "fw_invalid"
            self._drag.dropIntoFolderItem = nil
            self._drag.valid              = false
            self._drag_folder_hl:SetVisible(false)
            self._drag_indicator:SetVisible(false)
            self._drag_ghost:SetBackColor(Turbine.UI.Color(0.4, 0.25, 0.25, 0.5))
        end
        return
    end

    -- Timer drags: drop onto a window row only
    if nodeType == "timer" then
        local target = nil
        for _, it in ipairs(self.items) do
            if it.nodeData ~= nil and it.nodeData.nodeType == "window" then
                local _, iy = it:GetMousePosition()
                if iy >= 0 and iy < ITEM_H then target = it; break end
            end
        end
        if target then
            if target ~= self._drag.dropIntoFolderItem or self._drag.dropMode ~= "into" then
                self._drag.dropMode           = "into"
                self._drag.dropIntoFolderItem = target
                self._drag.valid              = true
                local _, iy    = target:GetMousePosition()
                self._drag_folder_hl:SetTop(LIST_TOP + list_y - iy)
                self._drag_folder_hl:SetVisible(true)
                self._drag_indicator:SetVisible(false)
                self._drag_ghost:SetBackColor(Turbine.UI.Color(0.5, 0.3, 0.5, 0.6))
            end
        else
            if self._drag.dropMode ~= "timer_invalid" then
                self._drag.dropMode           = "timer_invalid"
                self._drag.dropIntoFolderItem = nil
                self._drag.valid              = false
                self._drag_folder_hl:SetVisible(false)
                self._drag_indicator:SetVisible(false)
                self._drag_ghost:SetBackColor(Turbine.UI.Color(0.4, 0.25, 0.25, 0.5))
            end
        end
        return
    end

    -- Condition drags: drop onto a timer row only
    if nodeType == "condition" then
        local target = nil
        for _, it in ipairs(self.items) do
            if it.nodeData ~= nil and it.nodeData.nodeType == "timer" then
                local _, iy = it:GetMousePosition()
                if iy >= 0 and iy < ITEM_H then target = it; break end
            end
        end
        if target then
            if target ~= self._drag.dropIntoFolderItem or self._drag.dropMode ~= "into" then
                self._drag.dropMode           = "into"
                self._drag.dropIntoFolderItem = target
                self._drag.valid              = true
                local _, iy    = target:GetMousePosition()
                self._drag_folder_hl:SetTop(LIST_TOP + list_y - iy)
                self._drag_folder_hl:SetVisible(true)
                self._drag_indicator:SetVisible(false)
                self._drag_ghost:SetBackColor(Turbine.UI.Color(0.5, 0.3, 0.5, 0.6))
            end
        else
            if self._drag.dropMode ~= "cond_invalid" then
                self._drag.dropMode           = "cond_invalid"
                self._drag.dropIntoFolderItem = nil
                self._drag.valid              = false
                self._drag_folder_hl:SetVisible(false)
                self._drag_indicator:SetVisible(false)
                self._drag_ghost:SetBackColor(Turbine.UI.Color(0.4, 0.25, 0.25, 0.5))
            end
        end
        return
    end

end

function Options2.Window.Nav.Constructor:_DragFinish(item, args)
    if not self._drag.pending or self._drag.item ~= item then return end

    local was_active      = self._drag.active
    self._drag.pending    = false
    self._drag.active     = false
    self._drag_ghost:SetVisible(false)
    self._drag_indicator:SetVisible(false)
    self._drag_folder_hl:SetVisible(false)
    self._drag_just_ended = was_active

    if not was_active or not self._drag.valid then return end

    local nd = item.nodeData

    if self._drag.dropMode == "into" and self._drag.dropIntoFolderItem ~= nil then
        local nt     = nd.nodeType
        local tgt_nd = self._drag.dropIntoFolderItem.nodeData
        if nt == "foldertrigger" or nt == "windowtrigger"
            or nt == "trigger" or nt == "conditiontrigger" then
            self:_CommitTriggerMove(nd, tgt_nd)
        elseif nt == "timer" then
            table.remove(Data.window[nd.windowIndex].timerList, nd.timerIndex)
            table.insert(Data.window[tgt_nd.windowIndex].timerList, nd.data)
        elseif nt == "condition" then
            table.remove(Data.window[nd.windowIndex].timerList[nd.timerIndex].conditionList, nd.conditionIndex)
            table.insert(Data.window[tgt_nd.windowIndex].timerList[tgt_nd.timerIndex].conditionList, nd.data)
        else
            self:_CommitDropIntoFolder(nd, tgt_nd.folderIndex)
        end
    elseif self._drag.dropMode == "toroot" then
        self:_CommitDropToRoot(nd)
    end

    Options.SaveData()
    local nt = item.nodeData.nodeType
    if nt == "folder" or nt == "window" then
        -- Folder/window drags only change the .folder parent reference — no array
        -- index shifts — so cached items remain valid.  A surgical update is enough.
        self:_SurgicalUpdate()
    else
        -- Timer/trigger/condition drags do table.remove/insert which shifts array
        -- indices, making index-based cache keys stale.
        self:RebuildFresh()
    end
end

function Options2.Window.Nav.Constructor:_CommitDropIntoFolder(nd, targetFolderIdx)
    nd.data.folder = targetFolderIdx
    local key = "f_" .. targetFolderIdx
    self.expanded[key] = true
    Data.folder[targetFolderIdx].collapsed = false
end

function Options2.Window.Nav.Constructor:_CommitDropToRoot(nd)
    nd.data.folder = nil
end

function Options2.Window.Nav.Constructor:_GetTriggerArray(ref_nd, nt, tt)
    if nt == "foldertrigger" then
        local fi = ref_nd.folderIndex
        if Data.folder[fi][tt] == nil then Data.folder[fi][tt] = {} end
        return Data.folder[fi][tt]
    elseif nt == "windowtrigger" then
        local wi = ref_nd.windowIndex
        if Data.window[wi][tt] == nil then Data.window[wi][tt] = {} end
        return Data.window[wi][tt]
    elseif nt == "trigger" then
        local tmd = Data.window[ref_nd.windowIndex].timerList[ref_nd.timerIndex]
        if tmd[tt] == nil then tmd[tt] = {} end
        return tmd[tt]
    elseif nt == "conditiontrigger" then
        local cd = Data.window[ref_nd.windowIndex].timerList[ref_nd.timerIndex].conditionList[ref_nd.conditionIndex]
        if cd[tt] == nil then cd[tt] = {} end
        return cd[tt]
    end
end

function Options2.Window.Nav.Constructor:_CommitTriggerMove(nd, tgt_parent_nd)
    local src_tt  = nd.triggerType
    local src_ti  = nd.triggerIndex
    local data    = nd.data
    local src_nt  = nd.nodeType
    local tgt_nt  = CONTAINER_TO_TRIGGER_NT[tgt_parent_nd.nodeType]

    local src_arr = self:_GetTriggerArray(nd,            src_nt, src_tt)
    local tgt_arr = self:_GetTriggerArray(tgt_parent_nd, tgt_nt, src_tt)

    table.remove(src_arr, src_ti)
    table.insert(tgt_arr, data)

    self:_ResetActionIfInvalid(data, tgt_nt, tgt_parent_nd)
end

function Options2.Window.Nav.Constructor:_ResetActionIfInvalid(trigData, nt, tgt_nd)
    local a = trigData.action
    if nt == "foldertrigger" then
        if a ~= Action.Enable and a ~= Action.Disable and a ~= Action.Reset then
            trigData.action = Action.Enable
        end
    elseif nt == "windowtrigger" then
        if a ~= Action.Enable and a ~= Action.Disable and a ~= Action.Clear and a ~= Action.Reset then
            trigData.action = Action.Enable
        end
    elseif nt == "trigger" then
        local wi = tgt_nd.windowIndex
        local is_counter = Data.window[wi] and Data.window[wi].timerType == Timer.Types.COUNTER_BAR
        if a ~= Action.Add and a ~= Action.Remove and a ~= Action.Enable and a ~= Action.Disable
            and not (is_counter and a == Action.Subtract) then
            trigData.action = Action.Add
        end
    elseif nt == "conditiontrigger" then
        if a ~= Action.Add and a ~= Action.Remove then
            trigData.action = Action.Add
        end
    end
end

