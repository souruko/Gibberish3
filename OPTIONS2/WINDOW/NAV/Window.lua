local TOOLBAR_H = 36
local SEP_H     = 2
local ITEM_H    = 28
local SCROLL_W  = 10
local BTN_SIZE  = 26
local BTN_GAP   = 2
local BTN_ICON  = 16

local function make_nav_btn(parent, icon_path, click_fn)
    local BTN_TOP = math.floor((TOOLBAR_H - BTN_SIZE) / 2)
    local btn = Turbine.UI.Control()
    btn:SetParent(parent)
    btn:SetSize(BTN_SIZE, BTN_SIZE)
    btn:SetTop(BTN_TOP)
    btn:SetMouseVisible(true)

    local icon = Turbine.UI.Control()
    icon:SetParent(btn)
    icon:SetSize(BTN_ICON, BTN_ICON)
    icon:SetPosition(math.floor((BTN_SIZE - BTN_ICON) / 2), math.floor((BTN_SIZE - BTN_ICON) / 2))
    icon:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    icon:SetBackground(icon_path)
    icon:SetMouseVisible(false)

    btn.MouseEnter = function() btn:SetBackColor(Options.Defaults.window.hovercolor) end
    btn.MouseLeave = function() btn:SetBackColor(nil) end
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

    self.trig_types = {}
    for _, t in pairs(Trigger.Types) do
        self.trig_types[#self.trig_types + 1] = t
    end
    table.sort(self.trig_types)


    self:SetBackColor(Options.Defaults.window.backcolor1)

    -- ── toolbar ──────────────────────────────────────────────────
    self.toolbar = Turbine.UI.Control()
    self.toolbar:SetParent(self)
    self.toolbar:SetPosition(0, 0)
    self.toolbar:SetBackColor(Options.Defaults.window.backcolor2)

    self.search_box = Turbine.UI.TextBox()
    self.search_box:SetParent(self.toolbar)
    self.search_box:SetHeight(BTN_SIZE)
    self.search_box:SetFont(Options.Defaults.window.font)
    self.search_box:SetForeColor(Options.Defaults.window.textcolor)
    self.search_box:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.search_box:SetMultiline(false)
    self.search_box:SetSelectable(true)
    self.search_box.TextChanged = function()
        self.filter = self.search_box:GetText():lower()
        self.search_clear:SetVisible(self.filter ~= "")
        self:Rebuild()
    end

    self.search_icon = Turbine.UI.Control()
    self.search_icon:SetParent(self.toolbar)
    self.search_icon:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    self.search_icon:SetBackground("Gibberish3/Resources/search.tga")
    self.search_icon:SetMouseVisible(true)
    self.search_icon.MouseClick = function() self.search_box:Focus() end

    self.search_clear = Turbine.UI.Button()
    self.search_clear:SetSize(20, 20)
    self.search_clear:SetParent(self.search_box)
    self.search_clear:SetText("x")
    self.search_clear:SetFont(Options.Defaults.window.font)
    self.search_clear:SetVisible(false)
    self.search_clear.Click = function()
        self.search_box:SetText("")
        self.filter = ""
        self.search_clear:SetVisible(false)
        self:Rebuild()
    end

    self.add_folder_btn = make_nav_btn(self.toolbar,
        "Gibberish3/RESOURCES/nav_btn_folder.tga",
        function()
            Folder.New("New Folder")
            Options.SaveData()
            self:Rebuild()
        end)

    self.add_window_btn = make_nav_btn(self.toolbar,
        "Gibberish3/RESOURCES/nav_btn_window.tga",
        function()
            Window.New("New Window", Window.Types.TIMER_WINDOW)
            Options.SaveData()
            self:Rebuild()
        end)

    self.collapse_btn = make_nav_btn(self.toolbar,
        "Gibberish3/RESOURCES/nav_btn_collapse.tga",
        function()
            self:CollapseAll()
        end)

    self.import_btn = make_nav_btn(self.toolbar,
        "Gibberish3/RESOURCES/nav_btn_import.tga",
        function()
            local nd = Options2.selectedNode
            Options2.ShowImport(nd)
        end)

    -- separator line below toolbar
    self.toolbar_sep = Turbine.UI.Control()
    self.toolbar_sep:SetParent(self)
    self.toolbar_sep:SetPosition(0, TOOLBAR_H)
    self.toolbar_sep:SetBackColor(Options.Defaults.window.framecolor)
    self.toolbar_sep:SetMouseVisible(false)

    -- ── flat-list ListBox (right-click events reach items) ────────
    self.listbox = Turbine.UI.ListBox()
    self.listbox:SetParent(self)
    self.listbox:SetBackColor(Options.Defaults.window.backcolor1)

    self.scrollbar = Turbine.UI.Lotro.ScrollBar()
    self.scrollbar:SetParent(self)
    self.scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical)
    self.listbox:SetVerticalScrollBar(self.scrollbar)
    self:_InitDrag()
end

function Options2.Window.Nav.Constructor:SizeChanged()
    local w, h = self:GetSize()
    local list_w = w - SCROLL_W

    self.toolbar:SetSize(w, TOOLBAR_H)
    self.toolbar_sep:SetSize(w, SEP_H)

    local collapse_left   = w - 4 - BTN_SIZE
    local add_window_left = collapse_left - BTN_GAP - BTN_SIZE
    local add_folder_left = add_window_left - BTN_GAP - BTN_SIZE
    local import_left     = add_folder_left - BTN_GAP - BTN_SIZE
    self.import_btn:SetLeft(import_left)
    self.add_folder_btn:SetLeft(add_folder_left)
    self.add_window_btn:SetLeft(add_window_left)
    self.collapse_btn:SetLeft(collapse_left)

    local icon_top    = math.floor((TOOLBAR_H - BTN_ICON) / 2)
    local btn_top     = math.floor((TOOLBAR_H - BTN_SIZE) / 2)
    local search_left = 4 + BTN_ICON + 2
    local search_w    = import_left - search_left - 4
    self.search_icon:SetPosition(4, icon_top)
    self.search_icon:SetSize(BTN_ICON, BTN_ICON)
    self.search_box:SetPosition(search_left, btn_top)
    self.search_box:SetWidth(search_w)
    self.search_clear:SetPosition(search_w - 26, math.floor((BTN_SIZE - 20) / 2))

    local list_top = TOOLBAR_H + SEP_H
    local view_h   = h - list_top
    self.listbox:SetPosition(0, list_top)
    self.listbox:SetSize(list_w, view_h)

    self.scrollbar:SetPosition(list_w, list_top)
    self.scrollbar:SetSize(SCROLL_W, view_h)

    for _, item in ipairs(self.items) do
        item:SetWidth(list_w)
    end

    if self._drag_ghost ~= nil then
        self._drag_ghost:SetWidth(list_w)
        self._drag_ghost_lbl:SetWidth(list_w - 8)
        self._drag_indicator:SetWidth(list_w)
        self._drag_folder_hl:SetWidth(list_w)
    end
end

function Options2.Window.Nav.Constructor:CollapseAll()
    self.expanded = {}
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

function Options2.Window.Nav.Constructor:_EnsureKeyVisible(key)
    if key == nil then return end
    local parts = {}
    for p in key:gmatch("[^_]+") do parts[#parts + 1] = p end
    local prefix = parts[1]

    if prefix == "f" then
        local fi = tonumber(parts[2])
        if fi and Data.folder[fi] and Data.folder[fi].folder ~= nil then
            local pkey = "f_" .. Data.folder[fi].folder
            self.expanded[pkey] = true
            self:_EnsureKeyVisible(pkey)
        end
    elseif prefix == "ft" then
        local fi = tonumber(parts[2])
        if fi then
            local pkey = "f_" .. fi
            self.expanded[pkey] = true
            self:_EnsureKeyVisible(pkey)
        end
    elseif prefix == "w" then
        local wi = tonumber(parts[2])
        if wi and Data.window[wi] and Data.window[wi].folder ~= nil then
            local pkey = "f_" .. Data.window[wi].folder
            self.expanded[pkey] = true
            self:_EnsureKeyVisible(pkey)
        end
    elseif prefix == "wt" then
        local wi = tonumber(parts[2])
        if wi then
            local pkey = "w_" .. wi
            self.expanded[pkey] = true
            self:_EnsureKeyVisible(pkey)
        end
    elseif prefix == "t" then
        local wi = tonumber(parts[2])
        if wi then
            local pkey = "w_" .. wi
            self.expanded[pkey] = true
            self:_EnsureKeyVisible(pkey)
        end
    elseif prefix == "tt" then
        local wi, tmi = tonumber(parts[2]), tonumber(parts[3])
        if wi and tmi then
            local pkey = "t_" .. wi .. "_" .. tmi
            self.expanded[pkey] = true
            self:_EnsureKeyVisible(pkey)
        end
    elseif prefix == "c" then
        local wi, tmi = tonumber(parts[2]), tonumber(parts[3])
        if wi and tmi then
            local pkey = "t_" .. wi .. "_" .. tmi
            self.expanded[pkey] = true
            self:_EnsureKeyVisible(pkey)
        end
    elseif prefix == "ct" then
        local wi, tmi, ci = tonumber(parts[2]), tonumber(parts[3]), tonumber(parts[4])
        if wi and tmi and ci then
            local pkey = "c_" .. wi .. "_" .. tmi .. "_" .. ci
            self.expanded[pkey] = true
            self:_EnsureKeyVisible(pkey)
        end
    end
end

-- ── rebuild ────────────────────────────────────────────────────────────────────

function Options2.Window.Nav.Constructor:Rebuild()
    if self._initial_restore then
        self:_EnsureKeyVisible(self.selectedKey)
        self._initial_restore = false
    end

    self.listbox:ClearItems()
    self.items        = {}
    self.selectedItem = nil

    local list_w = self.listbox:GetWidth()
    if list_w <= 0 then list_w = 260 end

    local roots = {}
    for fi, fd in ipairs(Data.folder) do
        if fd.folder == nil then
            roots[#roots + 1] = { kind = "folder", idx = fi, data = fd }
        end
    end
    for wi, wd in ipairs(Data.window) do
        if wd.folder == nil then
            roots[#roots + 1] = { kind = "window", idx = wi, data = wd }
        end
    end
    table.sort(roots, function(a, b)
        if a.kind ~= b.kind then return a.kind == "folder" end
        return (a.data.name or ""):lower() < (b.data.name or ""):lower()
    end)

    for _, entry in ipairs(roots) do
        if entry.kind == "folder" then
            self:_AddFolder(entry.idx, entry.data, list_w)
        else
            self:_AddWindow(entry.idx, entry.data, list_w, 0)
        end
    end

    -- restore selection highlight and editor content
    for _, item in ipairs(self.items) do
        if item:GetKey() == self.selectedKey then
            item:SetSelected(true)
            self.selectedItem = item
            if Options2.Window.Object ~= nil and Options2.Window.Object.editor_panel ~= nil then
                Options2.Window.Object.editor_panel:SetNode(item.nodeData)
            end
            break
        end
    end
end

-- ── tree builders ──────────────────────────────────────────────────────────────

function Options2.Window.Nav.Constructor:_AddItem(item, w)
    item:SetWidth(w)
    self.listbox:AddItem(item)
    self.items[#self.items + 1] = item
end

function Options2.Window.Nav.Constructor:_AddFolder(fi, fd, w, depth)
    depth = depth or 0
    if not self:_FolderVisible(fi, fd) then return end
    local key = "f_" .. fi
    if self.expanded[key] == nil then
        self.expanded[key] = not (fd.collapsed == true)
    end
    local expanded = self:_IsExpanded(key)

    self:_AddItem(Options2NavFolder(self, fi, fd, key, expanded, depth), w)

    if not expanded then return end

    for _, tt in ipairs(self.trig_types) do
        for ti, td in ipairs(fd[tt] or {}) do
            local tkey = "ft_" .. fi .. "_" .. tt .. "_" .. ti
            self:_AddItem(Options2NavFolderTrigger(self, td, tt, ti, fi, tkey, depth + 1), w)
        end
    end

    local children = {}
    for fi2, fd2 in ipairs(Data.folder) do
        if fd2.folder == fi then
            children[#children + 1] = { kind = "folder", idx = fi2, data = fd2 }
        end
    end
    for wi, wd in ipairs(Data.window) do
        if wd.folder == fi then
            children[#children + 1] = { kind = "window", idx = wi, data = wd }
        end
    end
    table.sort(children, function(a, b)
        if a.kind ~= b.kind then return a.kind == "folder" end
        return (a.data.name or ""):lower() < (b.data.name or ""):lower()
    end)
    for _, entry in ipairs(children) do
        if entry.kind == "folder" then
            self:_AddFolder(entry.idx, entry.data, w, depth + 1)
        else
            self:_AddWindow(entry.idx, entry.data, w, depth + 1)
        end
    end
end

function Options2.Window.Nav.Constructor:_AddWindow(wi, wd, w, depth)
    if not self:_WindowVisible(wd) then return end
    local key = "w_" .. wi
    if self.expanded[key] == nil then
        self.expanded[key] = not (wd.collapsed == true)
    end
    local expanded = self:_IsExpanded(key)

    self:_AddItem(Options2NavWindow(self, wi, wd, key, expanded, depth), w)

    if not expanded then return end

    for _, tt in ipairs(self.trig_types) do
        for ti, td in ipairs(wd[tt] or {}) do
            local tkey = "wt_" .. wi .. "_" .. tt .. "_" .. ti
            self:_AddItem(Options2NavWindowTrigger(self, td, tt, ti, wi, tkey, depth + 1), w)
        end
    end

    local timer_sorted = {}
    for tmi, tmd in ipairs(wd.timerList or {}) do
        timer_sorted[#timer_sorted + 1] = { tmi = tmi, tmd = tmd }
    end
    table.sort(timer_sorted, function(a, b)
        return (a.tmd.description or ""):lower() < (b.tmd.description or ""):lower()
    end)
    for _, entry in ipairs(timer_sorted) do
        self:_AddTimer(wi, entry.tmi, entry.tmd, w, depth + 1)
    end
end

function Options2.Window.Nav.Constructor:_AddTimer(wi, tmi, tmd, w, depth)
    local key = "t_" .. wi .. "_" .. tmi
    if self.expanded[key] == nil then
        self.expanded[key] = not (tmd.collapsed == true)
    end
    local expanded = self:_IsExpanded(key)

    self:_AddItem(Options2NavTimer(self, wi, tmi, tmd, key, expanded, depth), w)

    if not expanded then return end

    for _, tt in ipairs(self.trig_types) do
        for ti, td in ipairs(tmd[tt] or {}) do
            local tkey = "tt_" .. wi .. "_" .. tmi .. "_" .. tt .. "_" .. ti
            self:_AddItem(Options2NavTrigger(self, td, tt, ti, wi, tmi, tkey, depth + 1), w)
        end
    end

    local cond_sorted = {}
    for ci, cd in ipairs(tmd.conditionList or {}) do
        cond_sorted[#cond_sorted + 1] = { ci = ci, cd = cd }
    end
    table.sort(cond_sorted, function(a, b)
        return (a.cd.description or ""):lower() < (b.cd.description or ""):lower()
    end)
    for _, entry in ipairs(cond_sorted) do
        self:_AddCondition(wi, tmi, entry.ci, entry.cd, w, depth + 1)
    end
end

function Options2.Window.Nav.Constructor:_AddCondition(wi, tmi, ci, cd, w, depth)
    local key = "c_" .. wi .. "_" .. tmi .. "_" .. ci
    if self.expanded[key] == nil then
        self.expanded[key] = not (cd.collapsed == true)
    end
    local expanded = self:_IsExpanded(key)

    self:_AddItem(Options2NavCondition(self, wi, tmi, ci, cd, key, expanded, depth), w)

    if not expanded then return end

    for _, tt in ipairs(self.trig_types) do
        for ti, td in ipairs(cd[tt] or {}) do
            local tkey = "ct_" .. wi .. "_" .. tmi .. "_" .. ci .. "_" .. tt .. "_" .. ti
            self:_AddItem(Options2NavCondTrigger(self, td, tt, ti, wi, tmi, ci, tkey, depth + 1), w)
        end
    end
end

-- ── interaction ────────────────────────────────────────────────────────────────

function Options2.Window.Nav.Constructor:_SelectItem(item)
    if self.selectedItem ~= nil and self.selectedItem ~= item then
        self.selectedItem:SetSelected(false)
    end
    self.selectedKey  = item:GetKey()
    self.selectedItem = item
    item:SetSelected(true)
    Options2.SaveNavState(self.selectedKey)
    Options2.selectedNode = item.nodeData
    if Options2.Window.Object ~= nil and Options2.Window.Object.editor_panel ~= nil then
        Options2.Window.Object.editor_panel:SetNode(item.nodeData)
    end
end

function Options2.Window.Nav.Constructor:_ToggleExpand(item)
    if not item:IsExpandable() or self.filter ~= "" then return end
    local key = item:GetKey()
    local now_expanded = not (self.expanded[key] == true)
    self.expanded[key] = now_expanded
    local nd = item.nodeData
    local collapsed = not now_expanded
    if nd.nodeType == "folder" then
        Data.folder[nd.folderIndex].collapsed = collapsed
    elseif nd.nodeType == "window" then
        Data.window[nd.windowIndex].collapsed = collapsed
    elseif nd.nodeType == "timer" then
        Data.window[nd.windowIndex].timerList[nd.timerIndex].collapsed = collapsed
    elseif nd.nodeType == "condition" then
        Data.window[nd.windowIndex].timerList[nd.timerIndex].conditionList[nd.conditionIndex].collapsed = collapsed
    end
    self:Rebuild()
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
    self:ShowContextMenu(item.nodeData)
end

function Options2.Window.Nav.Constructor:CollapseAll()
    for fi, fd in ipairs(Data.folder) do
        fd.collapsed = true
    end
    for wi, wd in ipairs(Data.window) do
        wd.collapsed = true
        for _, tmd in ipairs(wd.timerList or {}) do
            tmd.collapsed = true
            for _, cd in ipairs(tmd.conditionList or {}) do
                cd.collapsed = true
            end
        end
    end
    self.expanded = {}
    self:Rebuild()
end

function Options2.Window.Nav.Constructor:LanguageChanged()
    self:Rebuild()
end

-- ── context menu helpers ───────────────────────────────────────────────────────

local function raw_row(text, fn)
    local h = Options.Defaults.rc_menu.item_height
    local row = Turbine.UI.Control()
    row:SetHeight(h)
    row:SetMouseVisible(true)
    row._fn   = fn
    row.parent = nil

    local lbl = Turbine.UI.Label()
    lbl:SetParent(row)
    lbl:SetHeight(h)
    lbl:SetLeft(Options.Defaults.rc_menu.text_left)
    lbl:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    lbl:SetFont(Options.Defaults.rc_menu.font)
    lbl:SetForeColor(Options.Defaults.window.textcolor)
    lbl:SetText(text)
    lbl:SetMouseVisible(false)

    function row:MouseClick()    self._fn(); self.parent:Hide() end
    function row:MouseEnter()
        self:SetBackColor(Options.Defaults.rc_menu.hover_color)
        self.parent:HoverChanged(self)
    end
    function row:Hover(v)
        if v then self:SetBackColor(Options.Defaults.rc_menu.hover_color)
        else self:SetBackColor(nil) end
    end
    function row:LanguageChanged() end
    function row:SizeChanged()
        lbl:SetWidth(self:GetWidth() - Options.Defaults.rc_menu.text_left)
    end
    function row:SetSuper(p) self.parent = p end
    return row
end

function Options2.Window.Nav.Constructor:ShowContextMenu(nd)
    self._current_menu = nil

    local menu = Options2.Elements.RightClickMenu(172)
    self._current_menu = menu

    local h          = Options.Defaults.rc_menu.item_height
    local nav        = self
    local lang       = L[Language.Local] or L[Language.English]
    local nt         = nd.nodeType
    local export_lbl = (lang.selection and lang.selection.export) or "Export"

    local function trig_submenu(parent_data)
        local sub = Options2.Elements.RightClickSubMenu(172)
        for _, tt in ipairs(self.trig_types) do
            local tname = (lang.triggerType and lang.triggerType[tt]) or ("T" .. tt)
            local tt_cap = tt
            local pd_cap = parent_data
            sub:AddRow(raw_row(tname, function()
                local td = Trigger.New(tt_cap)
                if pd_cap[tt_cap] == nil then pd_cap[tt_cap] = {} end
                table.insert(pd_cap[tt_cap], td)
                Options.SaveData()
                nav.selectedKey = nil
                nav:Rebuild()
            end))
        end
        return sub
    end

    if nt == "folder" then
        local fi = nd.folderIndex
        local fd = nd.data

        menu:AddRow(Options2.Elements.Row("nav_menu", "add_folder", function()
            local fi2 = Folder.New("New Folder")
            Data.folder[fi2].folder = fi
            Options.SaveData()
            nav:Rebuild()
        end, h))

        local win_sub = Options2.Elements.RightClickSubMenu(172)
        for _, wt in ipairs({ Window.Types.TIMER_WINDOW, Window.Types.COUNTER_WINDOW }) do
            local wname = (lang.windowType and lang.windowType[wt]) or "Window"
            local wt_cap = wt
            win_sub:AddRow(raw_row(wname, function()
                local wi = Window.New("New Window", wt_cap)
                Data.window[wi].folder = fi
                Options.SaveData()
                nav:Rebuild()
            end))
        end
        menu:AddSubRow(Options2.Elements.SubRow("nav_menu", "add_window", win_sub, h), win_sub)

        local trg_sub = trig_submenu(fd)
        menu:AddSubRow(Options2.Elements.SubRow("nav_menu", "add_trigger", trg_sub, h), trg_sub)

        menu:AddSeperator()
        menu:AddRow(raw_row(export_lbl, function()
            Options2.ShowExport(fd, ImportType.Folder, fi)
        end))
        menu:AddSeperator()
        menu:AddRow(Options2.Elements.Row("nav_menu", "delete", function()
            Options2.ConfirmDelete(fd.name or "(folder)", function()
                Options.DeleteFolder(fi)
                Options.SaveData()
                nav.selectedKey = nil
                nav:Rebuild()
            end)
        end, h))

    elseif nt == "foldertrigger" then
        local fi = nd.folderIndex
        local fd = Data.folder[fi]
        local tt = nd.triggerType
        local ti = nd.triggerIndex
        local td = nd.data
        local desc = (td.description ~= nil and td.description ~= "") and td.description
            or ((lang.triggerType and lang.triggerType[tt]) or "trigger")

        menu:AddRow(raw_row(export_lbl, function()
            Options2.ShowExport(td, ImportType.Trigger)
        end))
        menu:AddSeperator()
        menu:AddRow(Options2.Elements.Row("nav_menu", "duplicate", function()
            local copy = Trigger.Copy(td)
            if fd[tt] == nil then fd[tt] = {} end
            table.insert(fd[tt], ti + 1, copy)
            Options.SaveData()
            nav:Rebuild()
        end, h))
        menu:AddRow(Options2.Elements.Row("nav_menu", "delete", function()
            Options2.ConfirmDelete(desc, function()
                Trigger.Delete(fd, ti, tt)
                Options.SaveData()
                nav.selectedKey = nil
                nav:Rebuild()
            end)
        end, h))

    elseif nt == "window" then
        local wi = nd.windowIndex
        local wd = nd.data

        local allowed = Window[wd.type] and Window[wd.type].Defaults
            and Window[wd.type].Defaults.allowedTimers
        if allowed ~= nil and #allowed > 0 then
            local timer_sub = Options2.Elements.RightClickSubMenu(172)
            for _, ttype in ipairs(allowed) do
                local tname = (lang.type and lang.type[ttype]) or ("Timer " .. ttype)
                local tt_cap = ttype
                timer_sub:AddRow(raw_row(tname, function()
                    local tmd = Timer.New(tt_cap)
                    Window.AddTimer(wi, tmd)
                    Options.SaveData()
                    nav:Rebuild()
                end))
            end
            menu:AddSubRow(Options2.Elements.SubRow("nav_menu", "add_timer", timer_sub, h), timer_sub)
        end

        local trg_sub = trig_submenu(wd)
        menu:AddSubRow(Options2.Elements.SubRow("nav_menu", "add_trigger", trg_sub, h), trg_sub)

        menu:AddSeperator()
        menu:AddRow(raw_row(export_lbl, function()
            Options2.ShowExport(wd, ImportType.Window)
        end))
        menu:AddSeperator()
        menu:AddRow(Options2.Elements.Row("nav_menu", "duplicate", function()
            local new_wi = Window.Copy(wi)
            Windows.EnabledChanged(new_wi)
            Options.SaveData()
            nav:Rebuild()
        end, h))
        menu:AddRow(Options2.Elements.Row("nav_menu", "delete", function()
            Options2.ConfirmDelete(wd.name or "(window)", function()
                Options.DeleteWindow(wi)
                Options.SaveData()
                nav.selectedKey = nil
                nav:Rebuild()
            end)
        end, h))

    elseif nt == "windowtrigger" then
        local wi = nd.windowIndex
        local wd = Data.window[wi]
        local tt = nd.triggerType
        local ti = nd.triggerIndex
        local td = nd.data
        local desc = (td.description ~= nil and td.description ~= "") and td.description
            or ((lang.triggerType and lang.triggerType[tt]) or "trigger")

        menu:AddRow(raw_row(export_lbl, function()
            Options2.ShowExport(td, ImportType.Trigger)
        end))
        menu:AddSeperator()
        menu:AddRow(Options2.Elements.Row("nav_menu", "duplicate", function()
            local copy = Trigger.Copy(td)
            if wd[tt] == nil then wd[tt] = {} end
            table.insert(wd[tt], ti + 1, copy)
            Options.SaveData()
            nav:Rebuild()
        end, h))
        menu:AddRow(Options2.Elements.Row("nav_menu", "delete", function()
            Options2.ConfirmDelete(desc, function()
                Trigger.Delete(wd, ti, tt)
                Options.SaveData()
                nav.selectedKey = nil
                nav:Rebuild()
            end)
        end, h))

    elseif nt == "timer" then
        local wi  = nd.windowIndex
        local tmi = nd.timerIndex
        local tmd = nd.data

        local trg_sub = trig_submenu(tmd)
        menu:AddSubRow(Options2.Elements.SubRow("nav_menu", "add_trigger", trg_sub, h), trg_sub)

        menu:AddRow(Options2.Elements.Row("nav_menu", "add_condition", function()
            local cd = Condition.New()
            if tmd.conditionList == nil then tmd.conditionList = {} end
            table.insert(tmd.conditionList, cd)
            Options.SaveData()
            nav:Rebuild()
        end, h))

        menu:AddSeperator()
        menu:AddRow(raw_row(export_lbl, function()
            Options2.ShowExport(tmd, ImportType.Timer)
        end))
        menu:AddSeperator()
        local tname = (tmd.description ~= nil and tmd.description ~= "")
            and tmd.description or "(timer)"
        menu:AddRow(Options2.Elements.Row("nav_menu", "duplicate", function()
            local copy = Timer.Copy(tmd)
            local tlist = Data.window[wi].timerList
            table.insert(tlist, tmi + 1, copy)
            Options.SaveData()
            Options.DataChanged(wi)
            nav:Rebuild()
        end, h))
        menu:AddRow(Options2.Elements.Row("nav_menu", "delete", function()
            Options2.ConfirmDelete(tname, function()
                local wd = Data.window[wi]
                Options.DeleteTimer(wd, tmi)
                Options.SaveData()
                nav.selectedKey = nil
                nav:Rebuild()
            end)
        end, h))

    elseif nt == "trigger" then
        local wi  = nd.windowIndex
        local tmi = nd.timerIndex
        local tmd = Data.window[wi].timerList[tmi]
        local tt  = nd.triggerType
        local ti  = nd.triggerIndex
        local td  = nd.data
        local desc = (td.description ~= nil and td.description ~= "") and td.description
            or ((lang.triggerType and lang.triggerType[tt]) or "trigger")

        menu:AddRow(raw_row(export_lbl, function()
            Options2.ShowExport(td, ImportType.Trigger)
        end))
        menu:AddSeperator()
        menu:AddRow(Options2.Elements.Row("nav_menu", "duplicate", function()
            local copy = Trigger.Copy(td)
            if tmd[tt] == nil then tmd[tt] = {} end
            table.insert(tmd[tt], ti + 1, copy)
            Options.SaveData()
            nav:Rebuild()
        end, h))
        menu:AddRow(Options2.Elements.Row("nav_menu", "delete", function()
            Options2.ConfirmDelete(desc, function()
                Trigger.Delete(tmd, ti, tt)
                Options.SaveData()
                nav.selectedKey = nil
                nav:Rebuild()
            end)
        end, h))

    elseif nt == "condition" then
        local wi  = nd.windowIndex
        local tmi = nd.timerIndex
        local ci  = nd.conditionIndex
        local tmd = Data.window[wi].timerList[tmi]
        local cd  = nd.data

        local trg_sub = trig_submenu(cd)
        menu:AddSubRow(Options2.Elements.SubRow("nav_menu", "add_trigger", trg_sub, h), trg_sub)

        menu:AddSeperator()
        menu:AddRow(raw_row(export_lbl, function()
            Options2.ShowExport(cd, ImportType.Condition)
        end))
        menu:AddSeperator()
        local cname = (cd.description ~= nil and cd.description ~= "")
            and cd.description or "(condition)"
        menu:AddRow(Options2.Elements.Row("nav_menu", "duplicate", function()
            local copy = Condition.Copy(cd)
            if tmd.conditionList == nil then tmd.conditionList = {} end
            table.insert(tmd.conditionList, ci + 1, copy)
            Options.SaveData()
            nav:Rebuild()
        end, h))
        menu:AddRow(Options2.Elements.Row("nav_menu", "delete", function()
            Options2.ConfirmDelete(cname, function()
                Options.DeleteConditions(tmd, ci)
                Options.SaveData()
                nav.selectedKey = nil
                nav:Rebuild()
            end)
        end, h))

    elseif nt == "conditiontrigger" then
        local wi  = nd.windowIndex
        local tmi = nd.timerIndex
        local ci  = nd.conditionIndex
        local cd  = Data.window[wi].timerList[tmi].conditionList[ci]
        local tt  = nd.triggerType
        local ti  = nd.triggerIndex
        local td  = nd.data
        local desc = (td.description ~= nil and td.description ~= "") and td.description
            or ((lang.triggerType and lang.triggerType[tt]) or "trigger")

        menu:AddSeperator()
        menu:AddRow(Options2.Elements.Row("nav_menu", "duplicate", function()
            local copy = Trigger.Copy(td)
            if cd[tt] == nil then cd[tt] = {} end
            table.insert(cd[tt], ti + 1, copy)
            Options.SaveData()
            nav:Rebuild()
        end, h))
        menu:AddRow(Options2.Elements.Row("nav_menu", "delete", function()
            Options2.ConfirmDelete(desc, function()
                Trigger.Delete(cd, ti, tt)
                Options.SaveData()
                nav.selectedKey = nil
                nav:Rebuild()
            end)
        end, h))
    end

    menu:Show()
end

-- ── drag and drop ──────────────────────────────────────────────────────────────

local DRAG_THRESH = 5

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
    self._drag_ghost_lbl:SetForeColor(Options.Defaults.window.textcolor)
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
    self._drag_ghost:SetTop(TOOLBAR_H + SEP_H + list_y - math.floor(ITEM_H / 2))

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
                self._drag_folder_hl:SetTop(TOOLBAR_H + SEP_H + item_top)
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
            self._drag_folder_hl:SetTop(TOOLBAR_H + item_top)
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
        self._drag_indicator:SetTop(TOOLBAR_H + SEP_H + list_y - 1)
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
                self._drag_folder_hl:SetTop(TOOLBAR_H + SEP_H + list_y - iy)
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
                self._drag_folder_hl:SetTop(TOOLBAR_H + SEP_H + list_y - iy)
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
    self:Rebuild()
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
    local src_tt = nd.triggerType
    local src_ti = nd.triggerIndex
    local data   = nd.data
    local nt     = nd.nodeType

    local src_arr = self:_GetTriggerArray(nd,            nt, src_tt)
    local tgt_arr = self:_GetTriggerArray(tgt_parent_nd, nt, src_tt)

    table.remove(src_arr, src_ti)
    table.insert(tgt_arr, data)

    self:_ResetActionIfInvalid(data, nt, tgt_parent_nd)
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

