local _current_menu = nil

-- Right-click menus for every node type, shared by the structure and contents
-- columns. Lifted out of NAV/Window.lua when the tree split in two: the
-- structure column raises the folder and window menus, the contents column
-- raises the rest.

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
    lbl:SetForeColor(Options.Defaults.window.text)
    lbl:SetText(text)
    lbl:SetMouseVisible(false)

    function row:MouseClick()    self._fn(); self.parent:Used() end
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

-- one row per trigger type, appending a new trigger to parent_data
local function AddTriggerRows(container, parent_data)
    local lang = L[Language.Local] or L[Language.English]
    for _, tt in ipairs(Options2.TriggerTypes()) do
        local tname  = (lang.triggerType and lang.triggerType[tt]) or ""
        local tt_cap = tt
        local pd_cap = parent_data
        container:AddRow(raw_row(tname, function()
            local td = Trigger.New(tt_cap)
            if pd_cap[tt_cap] == nil then pd_cap[tt_cap] = {} end
            table.insert(pd_cap[tt_cap], td)
            Options.SaveData()
            -- a new trigger is appended, so no existing index moves and both
            -- columns keep their selection - dropping it here only cost the user
            -- the marker showing which window or folder they were working in
            Options2.RefreshAll()
        end))
    end
end

-- standalone version, raised by the contents column's "+ Trigger" button
function Options2.ShowAddTriggerMenu(parent_data)
    local menu = Options2.Elements.RightClickMenu(172)
    _current_menu = menu
    AddTriggerRows(menu, parent_data)
    menu:Show()
end

local function AddWindowTypeRows(container, lang, on_pick)
    for _, wt in ipairs({ Window.Types.TIMER_WINDOW, Window.Types.COUNTER_WINDOW }) do
        local allowed = Window[wt] and Window[wt].Defaults and Window[wt].Defaults.allowedTimers or {}
        for _, ttype in ipairs(allowed) do
            local label = (wt == Window.Types.COUNTER_WINDOW)
                and ((lang.windowType and lang.windowType[wt]) or "")
                or  ((lang.type and lang.type[ttype]) or "")
            local wt_cap, tt_cap = wt, ttype
            container:AddRow(raw_row(label, function() on_pick(wt_cap, tt_cap) end))
        end
    end
end

-- folderIndex nil adds at the root
function Options2.ShowAddWindowMenu(folderIndex)
    local menu = Options2.Elements.RightClickMenu(172)
    _current_menu = menu

    local lang = L[Language.Local] or L[Language.English]

    AddWindowTypeRows(menu, lang, function(wt, tt)
        local wi = Window.New(UTILS.GetText("options2", "new_window"), wt, tt)
        Data.window[wi].folder = folderIndex
        Options.SaveData()
        Options2.RefreshAll()
    end)

    menu:Show()
end

function Options2.ShowContextMenu(nd)
    local menu = Options2.Elements.RightClickMenu(172)
    _current_menu = menu

    local h          = Options.Defaults.rc_menu.item_height
    local lang       = L[Language.Local] or L[Language.English]
    local nt         = nd.nodeType
    local export_lbl = (lang.selection and lang.selection.export) or "Export"

    local function trig_submenu(parent_data)
        local sub = Options2.Elements.RightClickSubMenu(172)
        AddTriggerRows(sub, parent_data)
        return sub
    end

    if nt == "folder" then
        local fi = nd.folderIndex
        local fd = nd.data

        menu:AddRow(Options2.Elements.Row("nav_menu", "add_folder", function()
            local fi2 = Folder.New(UTILS.GetText("options2", "new_folder"))
            Data.folder[fi2].folder = fi
            Options.SaveData()
            Options2.RefreshAll()
        end, h))

        local win_sub = Options2.Elements.RightClickSubMenu(172)
        AddWindowTypeRows(win_sub, lang, function(wt, tt)
            local wi = Window.New(UTILS.GetText("options2", "new_window"), wt, tt)
            Data.window[wi].folder = fi
            Options.SaveData()
            Options2.RefreshAll()
        end)
        menu:AddSubRow(Options2.Elements.SubRow("nav_menu", "add_window", win_sub, h), win_sub)

        local trg_sub = trig_submenu(fd)
        menu:AddSubRow(Options2.Elements.SubRow("nav_menu", "add_trigger", trg_sub, h), trg_sub)

        menu:AddSeperator()
        local load_all_lbl   = (lang.selection and lang.selection.load_all)   or "Load All"
        local unload_all_lbl = (lang.selection and lang.selection.unload_all) or "Unload All"

        menu:AddRow(raw_row(load_all_lbl, function()
            local indices = Folder.GetWindowIndices(fi)
            for _, wi in ipairs(indices) do
                Data.window[wi].enabled = true
                Windows.EnabledChanged(wi)
            end
            Options.SaveData()
            Options2.RefreshAll()
        end))

        menu:AddRow(raw_row(unload_all_lbl, function()
            local indices = Folder.GetWindowIndices(fi)
            for _, wi in ipairs(indices) do
                Data.window[wi].enabled = false
                Windows.EnabledChanged(wi)
            end
            Options.SaveData()
            Options2.RefreshAll()
        end))

        menu:AddSeperator()
        menu:AddRow(raw_row(export_lbl, function()
            Options2.ShowExport(fd, ImportType.Folder, fi)
        end))
        menu:AddSeperator()
        menu:AddRow(Options2.Elements.Row("nav_menu", "delete", function()
            Options2.ConfirmDelete(fd.name or UTILS.GetText("options2", "unnamed_folder"), function()
                Options.DeleteFolder(fi)
                Options.SaveData()
                Options2.ClearSelection()
                Options2.RefreshAll()
            end)
        end, h))

    elseif nt == "foldertrigger" then
        local fi = nd.folderIndex
        local fd = Data.folder[fi]
        local tt = nd.triggerType
        local ti = nd.triggerIndex
        local td = nd.data
        local desc = (td.description ~= nil and td.description ~= "") and td.description
            or ((lang.triggerType and lang.triggerType[tt]) or "")

        menu:AddRow(raw_row(export_lbl, function()
            Options2.ShowExport(td, ImportType.Trigger)
        end))
        menu:AddSeperator()
        menu:AddRow(Options2.Elements.Row("nav_menu", "duplicate", function()
            local copy = Trigger.Copy(td)
            if fd[tt] == nil then fd[tt] = {} end
            table.insert(fd[tt], ti + 1, copy)
            Options.SaveData()
            Options2.RefreshAll()
        end, h))
        menu:AddRow(Options2.Elements.Row("nav_menu", "delete", function()
            Options2.ConfirmDelete(desc, function()
                Trigger.Delete(fd, ti, tt)
                Options.SaveData()
                Options2.ClearContentSelection()
                Options2.RefreshAll()
            end)
        end, h))

    elseif nt == "window" then
        local wi = nd.windowIndex
        local wd = nd.data

        menu:AddRow(Options2.Elements.Row("nav_menu", "add_timer", function()
            local tmd = Timer.New(wd.timerType)
            Window.AddTimer(wi, tmd)
            Options.SaveData()
            Options2.RefreshAll()
        end, h))

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
            Options2.RefreshAll()
        end, h))
        menu:AddRow(Options2.Elements.Row("nav_menu", "delete", function()
            Options2.ConfirmDelete(wd.name or UTILS.GetText("options2", "unnamed_window"), function()
                Options.DeleteWindow(wi)
                Options.SaveData()
                Options2.ClearSelection()
                Options2.RefreshAll()
            end)
        end, h))

    elseif nt == "windowtrigger" then
        local wi = nd.windowIndex
        local wd = Data.window[wi]
        local tt = nd.triggerType
        local ti = nd.triggerIndex
        local td = nd.data
        local desc = (td.description ~= nil and td.description ~= "") and td.description
            or ((lang.triggerType and lang.triggerType[tt]) or "")

        menu:AddRow(raw_row(export_lbl, function()
            Options2.ShowExport(td, ImportType.Trigger)
        end))
        menu:AddSeperator()
        menu:AddRow(Options2.Elements.Row("nav_menu", "duplicate", function()
            local copy = Trigger.Copy(td)
            if wd[tt] == nil then wd[tt] = {} end
            table.insert(wd[tt], ti + 1, copy)
            Options.SaveData()
            Options2.RefreshAll()
        end, h))
        menu:AddRow(Options2.Elements.Row("nav_menu", "delete", function()
            Options2.ConfirmDelete(desc, function()
                Trigger.Delete(wd, ti, tt)
                Options.SaveData()
                Options2.ClearContentSelection()
                Options2.RefreshAll()
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
            Options2.RefreshAll()
        end, h))

        menu:AddSeperator()
        menu:AddRow(raw_row(export_lbl, function()
            Options2.ShowExport(tmd, ImportType.Timer)
        end))
        menu:AddSeperator()
        local tname = (tmd.description ~= nil and tmd.description ~= "")
            and tmd.description or UTILS.GetText("options2", "unnamed_timer")
        menu:AddRow(Options2.Elements.Row("nav_menu", "duplicate", function()
            local copy = Timer.Copy(tmd)
            local tlist = Data.window[wi].timerList
            table.insert(tlist, tmi + 1, copy)
            Options.SaveData()
            Options.DataChanged(wi)
            Options2.RefreshAll()
        end, h))
        menu:AddRow(Options2.Elements.Row("nav_menu", "delete", function()
            Options2.ConfirmDelete(tname, function()
                local wd = Data.window[wi]
                Options.DeleteTimer(wd, tmi)
                Options.SaveData()
                Options2.ClearContentSelection()
                Options2.RefreshAll()
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
            or ((lang.triggerType and lang.triggerType[tt]) or "")

        menu:AddRow(raw_row(export_lbl, function()
            Options2.ShowExport(td, ImportType.Trigger)
        end))
        menu:AddSeperator()
        menu:AddRow(Options2.Elements.Row("nav_menu", "duplicate", function()
            local copy = Trigger.Copy(td)
            if tmd[tt] == nil then tmd[tt] = {} end
            table.insert(tmd[tt], ti + 1, copy)
            Options.SaveData()
            Options2.RefreshAll()
        end, h))
        menu:AddRow(Options2.Elements.Row("nav_menu", "delete", function()
            Options2.ConfirmDelete(desc, function()
                Trigger.Delete(tmd, ti, tt)
                Options.SaveData()
                Options2.ClearContentSelection()
                Options2.RefreshAll()
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
            and cd.description or UTILS.GetText("options2", "unnamed_condition")
        menu:AddRow(Options2.Elements.Row("nav_menu", "duplicate", function()
            local copy = Condition.Copy(cd)
            if tmd.conditionList == nil then tmd.conditionList = {} end
            table.insert(tmd.conditionList, ci + 1, copy)
            Options.SaveData()
            Options2.RefreshAll()
        end, h))
        menu:AddRow(Options2.Elements.Row("nav_menu", "delete", function()
            Options2.ConfirmDelete(cname, function()
                Options.DeleteConditions(tmd, ci)
                Options.SaveData()
                Options2.ClearContentSelection()
                Options2.RefreshAll()
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
            or ((lang.triggerType and lang.triggerType[tt]) or "")

        menu:AddSeperator()
        menu:AddRow(Options2.Elements.Row("nav_menu", "duplicate", function()
            local copy = Trigger.Copy(td)
            if cd[tt] == nil then cd[tt] = {} end
            table.insert(cd[tt], ti + 1, copy)
            Options.SaveData()
            Options2.RefreshAll()
        end, h))
        menu:AddRow(Options2.Elements.Row("nav_menu", "delete", function()
            Options2.ConfirmDelete(desc, function()
                Trigger.Delete(cd, ti, tt)
                Options.SaveData()
                Options2.ClearContentSelection()
                Options2.RefreshAll()
            end)
        end, h))
    end

    menu:Show()
end
