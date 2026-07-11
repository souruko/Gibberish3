local TOOLBAR_H = 30
local ITEM_H    = 28
local SCROLL_W  = 10
local BTN_SIZE  = 24
local BTN_GAP   = 2
local BTN_ICON  = 16
local LABEL_W   = 44

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

    -- ── toolbar ──────────────────────────────────────────────────
    self.toolbar = Turbine.UI.Control()
    self.toolbar:SetParent(self)
    self.toolbar:SetPosition(0, 0)
    self.toolbar:SetBackColor(Options.Defaults.window.backcolor2)

    self.search_label = Turbine.UI.Label()
    self.search_label:SetParent(self.toolbar)
    self.search_label:SetPosition(4, 0)
    self.search_label:SetSize(LABEL_W, TOOLBAR_H)
    self.search_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.search_label:SetFont(Options.Defaults.window.font)
    self.search_label:SetForeColor(Options.Defaults.window.textdark)
    self.search_label:SetText("Filter:")
    self.search_label:SetMouseVisible(false)

    self.search_box = Turbine.UI.Lotro.TextBox()
    self.search_box:SetParent(self.toolbar)
    self.search_box:SetHeight(TOOLBAR_H - 8)
    self.search_box:SetFont(Options.Defaults.window.font)
    self.search_box:SetForeColor(Options.Defaults.window.textcolor)
    self.search_box:SetMultiline(false)
    self.search_box.TextChanged = function()
        self.filter = self.search_box:GetText():lower()
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

    -- ── flat-list ListBox (right-click events reach items) ────────
    self.listbox = Turbine.UI.ListBox()
    self.listbox:SetParent(self)
    self.listbox:SetBackColor(Options.Defaults.window.backcolor1)

    self.scrollbar = Turbine.UI.Lotro.ScrollBar()
    self.scrollbar:SetParent(self)
    self.scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical)
    self.listbox:SetVerticalScrollBar(self.scrollbar)
end

function Options2.Window.Nav.Constructor:SizeChanged()
    local w, h = self:GetSize()
    local list_w = w - SCROLL_W

    self.toolbar:SetSize(w, TOOLBAR_H)

    local collapse_left   = w - 4 - BTN_SIZE
    local add_window_left = collapse_left - BTN_GAP - BTN_SIZE
    local add_folder_left = add_window_left - BTN_GAP - BTN_SIZE
    local import_left     = add_folder_left - BTN_GAP - BTN_SIZE
    self.import_btn:SetLeft(import_left)
    self.add_folder_btn:SetLeft(add_folder_left)
    self.add_window_btn:SetLeft(add_window_left)
    self.collapse_btn:SetLeft(collapse_left)

    local search_left = 4 + LABEL_W
    self.search_box:SetPosition(search_left, 4)
    self.search_box:SetWidth(import_left - search_left - 4)

    local view_h = h - TOOLBAR_H
    self.listbox:SetPosition(0, TOOLBAR_H)
    self.listbox:SetSize(list_w, view_h)

    self.scrollbar:SetPosition(list_w, TOOLBAR_H)
    self.scrollbar:SetSize(SCROLL_W, view_h)

    for _, item in ipairs(self.items) do
        item:SetWidth(list_w)
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
            roots[#roots + 1] = { kind = "folder", idx = fi, data = fd, si = fd.sortIndex or 0 }
        end
    end
    for wi, wd in ipairs(Data.window) do
        if wd.folder == nil then
            roots[#roots + 1] = { kind = "window", idx = wi, data = wd, si = wd.sortIndex or 0 }
        end
    end
    table.sort(roots, function(a, b) return a.si < b.si end)

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
            children[#children + 1] = { kind = "folder", idx = fi2, data = fd2, si = fd2.sortIndex or 0 }
        end
    end
    for wi, wd in ipairs(Data.window) do
        if wd.folder == fi then
            children[#children + 1] = { kind = "window", idx = wi, data = wd, si = wd.sortIndex or 0 }
        end
    end
    table.sort(children, function(a, b) return a.si < b.si end)
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

    for tmi, tmd in ipairs(wd.timerList or {}) do
        self:_AddTimer(wi, tmi, tmd, w, depth + 1)
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

    for ci, cd in ipairs(tmd.conditionList or {}) do
        self:_AddCondition(wi, tmi, ci, cd, w, depth + 1)
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

function Options2.Window.Nav.Constructor:ItemClicked(item)
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

    if item:IsExpandable() then
        local key = item:GetKey()
        if self.filter == "" then
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
        end
        self:Rebuild()
    end
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
