local DLG_W  = 520
local DLG_H  = 360
local PAD    = 8
local BTN_H  = 26
local BTN_W  = 140
local SCROLL = 10
local WARN_H = 58

-- the metrics that hold text follow the panel's font size; see OPTIONS2/Fonts.lua
Options2.Fonts.Register(function()
    local F = Options2.Fonts
    DLG_W  = F.Px(520)
    DLG_H  = F.Px(360)
    BTN_H  = F.Px(26)
    BTN_W  = F.Px(140)
    WARN_H = F.Px(58)
end)

-- ── helpers ───────────────────────────────────────────────────────────────────

local function make_btn(parent, label, click_fn)
    local btn = Turbine.UI.Control()
    btn:SetParent(parent)
    btn:SetSize(BTN_W, BTN_H)
    btn:SetBackColor(Options.Defaults.window.bg_sunken)
    btn:SetMouseVisible(true)
    local lbl = Turbine.UI.Label()
    lbl:SetParent(btn)
    lbl:SetSize(BTN_W, BTN_H)
    lbl:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    lbl:SetFont(Options.Defaults.window.font)
    lbl:SetForeColor(Options.Defaults.window.text)
    lbl:SetText(label)
    lbl:SetMouseVisible(false)
    btn.MouseEnter = function() btn:SetBackColor(Options.Defaults.window.select) end
    btn.MouseLeave = function() btn:SetBackColor(Options.Defaults.window.bg_sunken) end
    btn.MouseClick = click_fn
    btn._lbl = lbl
    return btn
end

-- Temporarily stub Options.Window.Object if the old panel is not open, so
-- StringToData's ResetSelectedContent() call doesn't error.
local function call_string_to_data(text, insert, context_nd)
    local old_si  = Data.selectedIndex
    local old_sti = Data.selectedTimerIndex

    if insert and context_nd ~= nil then
        local nt = context_nd.nodeType
        if nt == "window" or nt == "windowtrigger" then
            Data.selectedIndex = context_nd.windowIndex
        elseif nt == "folder" or nt == "foldertrigger" then
            Data.selectedIndex = -(context_nd.folderIndex)
        elseif nt == "timer" or nt == "trigger"
            or nt == "condition" or nt == "conditiontrigger" then
            Data.selectedIndex      = context_nd.windowIndex
            Data.selectedTimerIndex = context_nd.timerIndex
        end
    end

    local orig_obj = Options.Window.Object
    if orig_obj == nil then
        Options.Window.Object = { ResetSelectedContent = function() end }
    end

    UTILS.StringToData(text, insert)

    Options.Window.Object   = orig_obj
    Data.selectedIndex      = old_si
    Data.selectedTimerIndex = old_sti

    Options.SaveData()
    if Options2.Window.Object ~= nil then
        Options2.Window.Object.nav:Rebuild()
    end
end

-- ── ImportDialog ──────────────────────────────────────────────────────────────

Options2.Window.ImportDialog = class(Options2.Elements.PanelWindow)

function Options2.Window.ImportDialog:Constructor()
    Options2.Elements.PanelWindow.Constructor(self, {
        min_width  = DLG_W,
        min_height = DLG_H,
    })

    self:SetSize(DLG_W, DLG_H)
    self:SetVisible(false)

    self._mode       = "export"
    self._context_nd = nil

    -- TextBox
    self.textbox = Turbine.UI.Lotro.TextBox()
    self.textbox:SetParent(self.client)
    self.textbox:SetBackColor(Options.Defaults.window.bg_sunken)
    self.textbox:SetFont(Options.Defaults.move.headerfont)
    self.textbox:SetMultiline(true)

    self.scrollbar = Turbine.UI.Lotro.ScrollBar()
    self.scrollbar:SetParent(self.client)
    self.scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical)
    self.scrollbar:SetWidth(SCROLL)
    self.textbox:SetVerticalScrollBar(self.scrollbar)

    -- External-image warning (export mode only, and only when there is one).
    -- The export string carries the filename but not the file, so the person
    -- importing needs the images copied across separately.
    self.warn = Turbine.UI.Control()
    self.warn:SetParent(self.client)
    self.warn:SetBackColor(Options.Defaults.window.color_trigger)
    self.warn:SetVisible(false)
    self.warn:SetMouseVisible(false)

    self.warn_fill = Turbine.UI.Control()
    self.warn_fill:SetParent(self.warn)
    self.warn_fill:SetPosition(1, 1)
    self.warn_fill:SetBackColor(Options.Defaults.window.bg_sunken)
    self.warn_fill:SetMouseVisible(false)

    self.warn_label = Turbine.UI.Label()
    self.warn_label:SetParent(self.warn_fill)
    self.warn_label:SetPosition(PAD, 4)
    self.warn_label:SetFont(Options.Defaults.window.font)
    self.warn_label:SetForeColor(Options.Defaults.window.text)
    self.warn_label:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft)
    self.warn_label:SetMultiline(true)
    self.warn_label:SetMouseVisible(false)

    -- Buttons (import mode only)
    self.btn_create = make_btn(self.client, "Create New", function()
        local text = self.textbox:GetText()
        if text ~= "" then
            call_string_to_data(text, false, nil)
            self:SetVisible(false)
        end
    end)

    self.btn_insert = make_btn(self.client, "Insert Into Selection", function()
        local text = self.textbox:GetText()
        if text ~= "" then
            call_string_to_data(text, true, self._context_nd)
            self:SetVisible(false)
        end
    end)

    self:OnLayout(self.client:GetSize())
    self:LanguageChanged()
end

function Options2.Window.ImportDialog:OnLayout(w, h)
    if self.textbox == nil then return end
    local sp    = PAD
    local txt_w = w - sp * 2 - SCROLL
    local txt_h = h - sp * 2 - BTN_H - sp

    -- the warning takes its room from the text box rather than growing the
    -- window, so the dialog stays the same size whether or not it is shown
    if self.warn ~= nil and self.warn:IsVisible() then
        txt_h = txt_h - WARN_H - sp
    end
    txt_h = math.max(0, txt_h)

    self.textbox:SetPosition(sp, sp)
    self.textbox:SetSize(txt_w, txt_h)

    self.scrollbar:SetPosition(sp + txt_w, sp)
    self.scrollbar:SetHeight(txt_h)

    if self.warn ~= nil and self.warn:IsVisible() then
        local warn_w = w - sp * 2
        self.warn:SetPosition(sp, sp + txt_h + sp)
        self.warn:SetSize(warn_w, WARN_H)
        self.warn_fill:SetSize(math.max(0, warn_w - 2), WARN_H - 2)
        self.warn_label:SetSize(math.max(0, warn_w - 2 - PAD * 2), WARN_H - 2 - 8)
    end

    local btn_top = h - sp - BTN_H
    self.btn_insert:SetPosition(w - sp - BTN_W, btn_top)
    self.btn_create:SetPosition(w - sp - BTN_W * 2 - sp, btn_top)
end

function Options2.Window.ImportDialog:LanguageChanged()
    if self.btn_create == nil then return end
    self.btn_create._lbl:SetText(UTILS.GetText("import", "create_new"))
    self.btn_insert._lbl:SetText(UTILS.GetText("import", "insert_into"))
    self:_RefreshImageWarning()
end

function Options2.Window.ImportDialog:ShowExport(data, importType, index)
    self._mode = "export"
    self:SetTitleText(UTILS.GetText("import", "export"))
    self.textbox:SetEnabled(false)
    self.textbox:SetText(UTILS.DataToStringV2(data, importType, index))
    self.btn_create:SetVisible(false)
    self.btn_insert:SetVisible(false)
    self:_ShowImageWarning(UTILS.CollectExternalImages(data, importType, index))
    self:_CenterOnOptions2()
    self:SetVisible(true)
    self:Activate()
    self.textbox:Focus()
    self.textbox:SelectAll()
end

function Options2.Window.ImportDialog:ShowImport(context_nd)
    self._mode       = "import"
    self._context_nd = context_nd
    self:SetTitleText(UTILS.GetText("import", "import"))
    self.textbox:SetEnabled(true)
    self.textbox:SetText("")
    self.btn_create:SetVisible(true)
    -- Insert Into is only useful when there is a selection that provides context
    local has_context = context_nd ~= nil and
        (context_nd.nodeType == "window" or context_nd.nodeType == "folder"
         or context_nd.nodeType == "timer" or context_nd.nodeType == "trigger"
         or context_nd.nodeType == "windowtrigger" or context_nd.nodeType == "foldertrigger")
    self.btn_insert:SetVisible(has_context)
    self:_ShowImageWarning(nil)
    self:_CenterOnOptions2()
    self:SetVisible(true)
    self:Activate()
    self.textbox:Focus()
end

-- files is the list from UTILS.CollectExternalImages, or nil to hide the strip
function Options2.Window.ImportDialog:_ShowImageWarning(files)
    if self.warn == nil then return end

    self._warn_files = (files ~= nil and #files > 0) and files or nil
    self.warn:SetVisible(self._warn_files ~= nil)
    self:_RefreshImageWarning()
    self:OnLayout(self.client:GetSize())
end

function Options2.Window.ImportDialog:_RefreshImageWarning()
    if self.warn == nil or self._warn_files == nil then return end
    self.warn_label:SetText(
        UTILS.GetText("import", "external_images")
        .. "\n" .. table.concat(self._warn_files, ", "))
end

function Options2.Window.ImportDialog:_CenterOnOptions2()
    if Options2.Window.Object == nil then return end
    local ox, oy = Options2.Window.Object:GetPosition()
    local ow, oh = Options2.Window.Object:GetSize()
    local dw, dh = self:GetSize()
    self:SetPosition(
        ox + math.floor((ow - dw) / 2),
        oy + math.floor((oh - dh) / 2)
    )
end
