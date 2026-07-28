local HEADER_H = 34
local SEP_H    = 1
local PAD      = 10
local GAP      = 8
local MARK     = 16
local BTN_H    = 22

-- Save / Revert: a bordered pill, Save picked out in the accent colour
local function make_action_btn(parent, border, fg, click_fn, tooltip)
    local btn = Turbine.UI.Control()
    btn:SetParent(parent)
    btn:SetHeight(BTN_H)
    btn:SetBackColor(border)
    btn:SetMouseVisible(true)

    local fill = Turbine.UI.Control()
    fill:SetParent(btn)
    fill:SetPosition(1, 1)
    fill:SetBackColor(Options.Defaults.window.bg_sunken)
    fill:SetMouseVisible(false)

    local label = Turbine.UI.Label()
    label:SetParent(fill)
    label:SetFont(Turbine.UI.Lotro.Font.Verdana12)
    label:SetForeColor(fg)
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
        fill:SetBackColor(Options.Defaults.window.bg_sunken)
    end
    btn.MouseClick = click_fn

    function btn:SetLabel(text)
        label:SetText(text)
        local w = 20 + string.len(text) * 6
        self:SetWidth(w)
        fill:SetSize(w - 2, BTN_H - 2)
        label:SetSize(w - 2, BTN_H - 2)
    end

    return btn
end

Options2.Window.Editor = {}
Options2.Window.Editor.Constructor = class(Turbine.UI.Control)

function Options2.Window.Editor.Constructor:Constructor()
    Turbine.UI.Control.Constructor(self)

    self.nodeData = nil
    self.content  = nil

    -- ── header: what is being edited, plus Save / Revert ────────────────────
    self.toolbar = Turbine.UI.Control()
    self.toolbar:SetParent(self)
    self.toolbar:SetPosition(0, 0)
    self.toolbar:SetHeight(HEADER_H)
    self.toolbar:SetBackColor(Options.Defaults.window.bg_sunken)
    self.toolbar:SetMouseVisible(false)

    self.head_mark = Options2.Elements.RowParts.MakeIcon(self.toolbar, nil, HEADER_H)
    self.head_mark:SetLeft(PAD)
    self.head_mark:SetVisible(false)

    self.head_name = Turbine.UI.Label()
    self.head_name:SetParent(self.toolbar)
    self.head_name:SetHeight(HEADER_H)
    self.head_name:SetFont(Turbine.UI.Lotro.Font.Verdana14)
    self.head_name:SetForeColor(Options.Defaults.window.text)
    self.head_name:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.head_name:SetMouseVisible(false)

    self.head_kind = Turbine.UI.Label()
    self.head_kind:SetParent(self.toolbar)
    self.head_kind:SetHeight(HEADER_H)
    self.head_kind:SetFont(Turbine.UI.Lotro.Font.Verdana10)
    self.head_kind:SetForeColor(Options.Defaults.window.text_faint)
    self.head_kind:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.head_kind:SetMouseVisible(false)

    self.btn_save = make_action_btn(self.toolbar,
        Options.Defaults.window.accent, Options.Defaults.window.accent,
        function()
            if self.content ~= nil and self.content.Save ~= nil then
                self.content:Save()
                Options2.RefreshAll()
                self:_ShowSaved()
            end
        end, "o2_save")

    self.btn_reset = make_action_btn(self.toolbar,
        Options.Defaults.window.line, Options.Defaults.window.text_muted,
        function()
            self:_HideSaved()
            if self.content ~= nil and self.content.Reset ~= nil then
                self.content:Reset()
            end
        end, "o2_revert")

    self.saved_label = Turbine.UI.Label()
    self.saved_label:SetParent(self.toolbar)
    self.saved_label:SetHeight(HEADER_H)
    self.saved_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.saved_label:SetFont(Turbine.UI.Lotro.Font.Verdana10)
    self.saved_label:SetForeColor(Options.Defaults.window.on)
    self.saved_label:SetVisible(false)
    self.saved_label:SetMouseVisible(false)

    self.toolbar_sep = Turbine.UI.Control()
    self.toolbar_sep:SetParent(self)
    self.toolbar_sep:SetPosition(0, HEADER_H)
    self.toolbar_sep:SetHeight(SEP_H)
    self.toolbar_sep:SetBackColor(Options.Defaults.window.line)
    self.toolbar_sep:SetMouseVisible(false)

    self:_RefreshTexts()

    -- ── content area ─────────────────────────────────────────────────────────
    self.content_area = Turbine.UI.Control()
    self.content_area:SetParent(self)
    self.content_area:SetBackColor(Options.Defaults.window.bg)

    self.placeholder = Turbine.UI.Label()
    self.placeholder:SetParent(self.content_area)
    self.placeholder:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.placeholder:SetFont(Turbine.UI.Lotro.Font.Verdana12)
    self.placeholder:SetForeColor(Options.Defaults.window.text_faint)
    self.placeholder:SetText(UTILS.GetText("options2", "no_selection"))
    self.placeholder:SetMouseVisible(false)
end

function Options2.Window.Editor.Constructor:SizeChanged()
    if self.toolbar == nil then return end
    local w, h = self:GetSize()
    local content_top = HEADER_H + SEP_H
    local content_h   = h - content_top

    self.toolbar:SetWidth(w)
    self.toolbar_sep:SetWidth(w)

    -- actions sit at the right, the name and kind take what is left
    local x = w - PAD - self.btn_reset:GetWidth()
    self.btn_reset:SetPosition(x, math.floor((HEADER_H - BTN_H) / 2))
    x = x - GAP - self.btn_save:GetWidth()
    self.btn_save:SetPosition(x, math.floor((HEADER_H - BTN_H) / 2))

    local name_left = PAD + MARK + GAP
    local avail     = math.max(0, x - GAP - name_left)
    local name_w    = math.floor(avail * 0.62)
    self.head_name:SetPosition(name_left, 0)
    self.head_name:SetWidth(name_w)
    self.head_kind:SetPosition(name_left + name_w + GAP, 0)
    self.head_kind:SetWidth(math.max(0, avail - name_w - GAP))
    self.saved_label:SetPosition(name_left, 0)
    self.saved_label:SetWidth(avail)

    self.content_area:SetPosition(0, content_top)
    self.content_area:SetSize(w, content_h)
    self.placeholder:SetSize(w, content_h)

    if self.content ~= nil then
        self.content:SetSize(w, content_h)
    end
end

-- ── save feedback ────────────────────────────────────────────────────────────

function Options2.Window.Editor.Constructor:_RefreshTexts()
    self.btn_save:SetLabel(UTILS.GetText("options2", "save"))
    self.btn_reset:SetLabel(UTILS.GetText("options2", "revert"))
    self.saved_label:SetText(UTILS.GetText("options2", "saved"))
end

function Options2.Window.Editor.Constructor:_ShowSaved()
    self.head_name:SetVisible(false)
    self.head_kind:SetVisible(false)
    self.saved_label:SetVisible(true)
end

function Options2.Window.Editor.Constructor:_HideSaved()
    self.saved_label:SetVisible(false)
    self.head_name:SetVisible(true)
    self.head_kind:SetVisible(true)
end

-- the header names what is being edited; the breadcrumb path lives in the
-- panel title bar
local KIND_KEY = {
    folder           = "kind_folder",
    window           = "kind_window",
    timer            = "kind_timer",
    condition        = "kind_condition",
    trigger          = "kind_trigger",
    conditiontrigger = "kind_trigger",
    foldertrigger    = "kind_trigger",
    windowtrigger    = "kind_trigger",
}

function Options2.Window.Editor.Constructor:_UpdateHeader(nd)
    if nd == nil then
        self.head_mark:SetVisible(false)
        self.head_name:SetText("")
        self.head_kind:SetText("")
        return
    end

    local nt = nd.nodeType
    self.head_mark:SetBackground(Options2.Elements.RowParts.IconForNode(nt))
    self.head_mark:SetVisible(true)

    local name = nd.data.name
    if name == nil or name == "" then name = nd.data.description end
    if name == nil or name == "" then
        name = Options2.Elements.RowParts.TriggerLabel(nd.data, nd.triggerType)
    end
    self.head_name:SetText(name or "")
    self.head_kind:SetText(UTILS.GetText("options2", KIND_KEY[nt] or "kind_trigger"))
end

-- ── node switching ────────────────────────────────────────────────────────────

function Options2.Window.Editor.Constructor:SetNode(nodeData)
    self:_HideSaved()
    -- the armed setter belongs to the editor being torn down
    Options2.ClearArmedField()

    local prev_tab = nil
    local prev_nt  = self.nodeData and self.nodeData.nodeType
    if self.content ~= nil and self.content.tabs ~= nil then
        prev_tab = self.content.tabs.selected
    end

    self:_CloseContent()
    self.nodeData = nodeData

    if nodeData == nil then
        self.placeholder:SetVisible(true)
        self:_UpdateHeader(nil)
        self:_SetBreadcrumb("")
        return
    end

    self.placeholder:SetVisible(false)
    self:_UpdateHeader(nodeData)
    self:_UpdateBreadcrumb(nodeData)

    local nt = nodeData.nodeType
    local w, h = self.content_area:GetSize()

    if nt == "folder" then
        self.content = Options2.Window.FolderEditor(nodeData.data, nodeData.folderIndex)
    elseif nt == "window" then
        self.content = Options2.Window.WindowEditor(nodeData.data, nodeData.windowIndex)
    elseif nt == "timer" then
        self.content = Options2.Window.TimerEditor(nodeData)
    elseif nt == "condition" then
        self.content = Options2.Window.ConditionEditor(nodeData)
    elseif nt == "trigger" or nt == "conditiontrigger"
        or nt == "foldertrigger" or nt == "windowtrigger" then
        self.content = Options2.Window.TriggerEditor(nodeData)
        if Options2.Window.Object ~= nil and Options2.Window.Object.library ~= nil then
            Options2.Window.Object.library:SetContext(nodeData.triggerType)
        end
    else
        self.placeholder:SetVisible(true)
        return
    end

    self.content:SetParent(self.content_area)
    self.content:SetPosition(0, 0)
    self.content:SetSize(w, h)

    if prev_tab ~= nil and prev_nt == nt
        and self.content.tabs ~= nil and prev_tab <= #self.content.tabs.tabs then
        self.content.tabs:ChangeSelection(prev_tab)
    end
end

function Options2.Window.Editor.Constructor:_CloseContent()
    if self.content ~= nil then
        self.content:SetParent(nil)
        self.content = nil
    end
end

function Options2.Window.Editor.Constructor:_UpdateBreadcrumb(nd)
    local parts = {}

    local function ne(s, fallback)
        if s ~= nil and s ~= "" then return s end
        return fallback
    end

    local function push_folder(fi)
        local fd = Data.folder[fi]
        if fd == nil then return end
        if fd.folder ~= nil then push_folder(fd.folder) end
        parts[#parts + 1] = ne(fd.name, "(folder)")
    end

    local function push_win(wi)
        local wd = Data.window[wi]
        if wd == nil then return nil end
        if wd.folder ~= nil then push_folder(wd.folder) end
        parts[#parts + 1] = ne(wd.name, "(window)")
        return wd
    end

    local function trig_label(triggerType, desc)
        if desc ~= nil and desc ~= "" then return desc end
        local lt = L[Language.Local] or L[Language.English]
        return (lt.triggerType and lt.triggerType[triggerType]) or "(?)"
    end

    local nt = nd.nodeType

    if nt == "folder" then
        if nd.data.folder ~= nil then push_folder(nd.data.folder) end
        parts[#parts + 1] = ne(nd.data.name, "(folder)")

    elseif nt == "window" then
        local wd = nd.data
        if wd.folder ~= nil then push_folder(wd.folder) end
        parts[#parts + 1] = ne(wd.name, "(window)")

    elseif nt == "foldertrigger" then
        push_folder(nd.folderIndex)
        parts[#parts + 1] = trig_label(nd.triggerType, nd.data.description)

    elseif nt == "windowtrigger" then
        push_win(nd.windowIndex)
        parts[#parts + 1] = trig_label(nd.triggerType, nd.data.description)

    elseif nt == "timer" then
        push_win(nd.windowIndex)
        parts[#parts + 1] = ne(nd.data.description, "(timer)")

    elseif nt == "trigger" then
        local wd = push_win(nd.windowIndex)
        if wd ~= nil and wd.timerList ~= nil then
            local tmd = wd.timerList[nd.timerIndex]
            if tmd ~= nil then parts[#parts + 1] = ne(tmd.description, "(timer)") end
        end
        parts[#parts + 1] = trig_label(nd.triggerType, nd.data.description)

    elseif nt == "condition" then
        local wd = push_win(nd.windowIndex)
        if wd ~= nil and wd.timerList ~= nil then
            local tmd = wd.timerList[nd.timerIndex]
            if tmd ~= nil then parts[#parts + 1] = ne(tmd.description, "(timer)") end
        end
        parts[#parts + 1] = ne(nd.data.description, "(condition)")

    elseif nt == "conditiontrigger" then
        local wd = push_win(nd.windowIndex)
        if wd ~= nil and wd.timerList ~= nil then
            local tmd = wd.timerList[nd.timerIndex]
            if tmd ~= nil then
                parts[#parts + 1] = ne(tmd.description, "(timer)")
                local cd = tmd.conditionList and tmd.conditionList[nd.conditionIndex]
                if cd ~= nil then parts[#parts + 1] = ne(cd.description, "(condition)") end
            end
        end
        parts[#parts + 1] = trig_label(nd.triggerType, nd.data.description)

    else
        parts[1] = nd.nodeType or ""
    end

    self:_SetBreadcrumb(table.concat(parts, "  /  "))
end

-- the path is shown in the panel's title bar, not in this column
function Options2.Window.Editor.Constructor:_SetBreadcrumb(text)
    local obj = Options2.Window.Object
    if obj ~= nil and obj.SetBreadcrumb ~= nil then
        obj:SetBreadcrumb(text)
    end
end

function Options2.Window.Editor.Constructor:LanguageChanged()
    if self.toolbar == nil then return end
    self:_RefreshTexts()
    self.placeholder:SetText(UTILS.GetText("options2", "no_selection"))
    if self.nodeData ~= nil then self:_UpdateHeader(self.nodeData) end
    if self.content ~= nil and self.content.LanguageChanged ~= nil then
        self.content:LanguageChanged()
    end
    if self.nodeData ~= nil then
        self:_UpdateBreadcrumb(self.nodeData)
    end
end
