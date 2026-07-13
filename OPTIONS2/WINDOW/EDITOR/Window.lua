local TOOLBAR_H = 36
local SEP_H     = 2
local BTN_SIZE  = 26
local BTN_ICON  = 16
local BTN_TOP   = math.floor((TOOLBAR_H - BTN_SIZE) / 2)
local SPACING   = 6

local function make_editor_btn(parent, icon_path, click_fn)
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

Options2.Window.Editor = {}
Options2.Window.Editor.Constructor = class(Turbine.UI.Control)

function Options2.Window.Editor.Constructor:Constructor()
    Turbine.UI.Control.Constructor(self)

    self.nodeData = nil
    self.content  = nil

    -- ── toolbar ─────────────────────────────────────────────────────────────
    self.toolbar = Turbine.UI.Control()
    self.toolbar:SetParent(self)
    self.toolbar:SetPosition(0, 0)
    self.toolbar:SetBackColor(Options.Defaults.window.backcolor2)

    self.btn_save = make_editor_btn(self.toolbar,
        "Gibberish3/RESOURCES/nav_btn_save.tga",
        function()
            if self.content ~= nil and self.content.Save ~= nil then
                self.content:Save()
                if Options2.Window.Object ~= nil then
                    Options2.Window.Object.nav:Rebuild()
                end
                self:_ShowSaved()
            end
        end)
    self.btn_save:SetLeft(SPACING)

    self.btn_reset = make_editor_btn(self.toolbar,
        "Gibberish3/RESOURCES/nav_btn_reset.tga",
        function()
            self:_HideSaved()
            if self.content ~= nil and self.content.Reset ~= nil then
                self.content:Reset()
            end
        end)
    self.btn_reset:SetLeft(SPACING * 2 + BTN_SIZE)

    -- vertical divider between buttons and breadcrumb
    self.vdiv = Turbine.UI.Control()
    self.vdiv:SetParent(self.toolbar)
    self.vdiv:SetBackColor(Options.Defaults.window.framecolor)
    self.vdiv:SetSize(1, TOOLBAR_H - 16)
    self.vdiv:SetTop(8)
    self.vdiv:SetMouseVisible(false)

    self.breadcrumb = Turbine.UI.Label()
    self.breadcrumb:SetParent(self.toolbar)
    self.breadcrumb:SetHeight(TOOLBAR_H)
    self.breadcrumb:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.breadcrumb:SetFont(Turbine.UI.Lotro.Font.Verdana14)
    self.breadcrumb:SetForeColor(Options.Defaults.window.textcolor)
    self.breadcrumb:SetMarkupEnabled(true)
    self.breadcrumb:SetMouseVisible(false)

    self.saved_label = Turbine.UI.Label()
    self.saved_label:SetParent(self.toolbar)
    self.saved_label:SetHeight(TOOLBAR_H)
    self.saved_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.saved_label:SetFont(Options.Defaults.window.font)
    self.saved_label:SetForeColor(Options.Defaults.window.textdark)
    self.saved_label:SetText("Saved")
    self.saved_label:SetVisible(false)
    self.saved_label:SetMouseVisible(false)

    -- separator line below toolbar
    self.toolbar_sep = Turbine.UI.Control()
    self.toolbar_sep:SetParent(self)
    self.toolbar_sep:SetPosition(0, TOOLBAR_H)
    self.toolbar_sep:SetBackColor(Options.Defaults.window.framecolor)
    self.toolbar_sep:SetMouseVisible(false)

    -- ── content area ─────────────────────────────────────────────────────────
    self.content_area = Turbine.UI.Control()
    self.content_area:SetParent(self)
    self.content_area:SetBackColor(Options.Defaults.window.backcolor1)

    self.placeholder = Turbine.UI.Label()
    self.placeholder:SetParent(self.content_area)
    self.placeholder:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.placeholder:SetFont(Options.Defaults.window.font)
    self.placeholder:SetForeColor(Options.Defaults.window.textdark)
    self.placeholder:SetText(UTILS.GetText("options2", "no_selection"))
    self.placeholder:SetMouseVisible(false)
end

function Options2.Window.Editor.Constructor:SizeChanged()
    if self.toolbar == nil then return end
    local w, h = self:GetSize()
    local content_top = TOOLBAR_H + SEP_H
    local content_h   = h - content_top

    self.toolbar:SetSize(w, TOOLBAR_H)
    self.toolbar_sep:SetSize(w, SEP_H)

    local vdiv_left = SPACING * 3 + BTN_SIZE * 2
    self.vdiv:SetLeft(vdiv_left)
    local crumb_left = vdiv_left + SPACING + 4
    self.breadcrumb:SetPosition(crumb_left, 0)
    self.breadcrumb:SetWidth(w - crumb_left - SPACING)
    self.saved_label:SetPosition(crumb_left, 0)
    self.saved_label:SetWidth(w - crumb_left - SPACING)

    self.content_area:SetPosition(0, content_top)
    self.content_area:SetSize(w, content_h)
    self.placeholder:SetSize(w, content_h)

    if self.content ~= nil then
        self.content:SetSize(w, content_h)
    end
end

-- ── save feedback ────────────────────────────────────────────────────────────

function Options2.Window.Editor.Constructor:_ShowSaved()
    self.breadcrumb:SetVisible(false)
    self.saved_label:SetVisible(true)
end

function Options2.Window.Editor.Constructor:_HideSaved()
    self.saved_label:SetVisible(false)
    self.breadcrumb:SetVisible(true)
end

-- ── node switching ────────────────────────────────────────────────────────────

function Options2.Window.Editor.Constructor:SetNode(nodeData)
    self:_HideSaved()
    self:_CloseContent()
    self.nodeData = nodeData

    if nodeData == nil then
        self.placeholder:SetVisible(true)
        self.breadcrumb:SetText("")
        return
    end

    self.placeholder:SetVisible(false)
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
    else
        self.placeholder:SetVisible(true)
        return
    end

    self.content:SetParent(self.content_area)
    self.content:SetPosition(0, 0)
    self.content:SetSize(w, h)
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

    self.breadcrumb:SetText(table.concat(parts, "  <rgb=#666666>></rgb>  "))
end

function Options2.Window.Editor.Constructor:LanguageChanged()
    if self.toolbar == nil then return end
    self.placeholder:SetText(UTILS.GetText("options2", "no_selection"))
    if self.content ~= nil and self.content.LanguageChanged ~= nil then
        self.content:LanguageChanged()
    end
    if self.nodeData ~= nil then
        self:_UpdateBreadcrumb(self.nodeData)
    end
end
