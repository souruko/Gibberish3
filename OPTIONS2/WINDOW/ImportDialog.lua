local DLG_W  = 520
local DLG_H  = 360
local PAD    = 8
local BTN_H  = 26
local BTN_W  = 140
local SCROLL = 10

-- ── helpers ───────────────────────────────────────────────────────────────────

local function make_btn(parent, label, click_fn)
    local btn = Turbine.UI.Control()
    btn:SetParent(parent)
    btn:SetSize(BTN_W, BTN_H)
    btn:SetBackColor(Options.Defaults.window.w_window_base)
    btn:SetMouseVisible(true)
    local lbl = Turbine.UI.Label()
    lbl:SetParent(btn)
    lbl:SetSize(BTN_W, BTN_H)
    lbl:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    lbl:SetFont(Options.Defaults.window.font)
    lbl:SetForeColor(Options.Defaults.window.textcolor)
    lbl:SetText(label)
    lbl:SetMouseVisible(false)
    btn.MouseEnter = function() btn:SetBackColor(Options.Defaults.window.w_window_hover) end
    btn.MouseLeave = function() btn:SetBackColor(Options.Defaults.window.w_window_base) end
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

Options2.Window.ImportDialog = class(Turbine.UI.Lotro.Window)

function Options2.Window.ImportDialog:Constructor()
    Turbine.UI.Lotro.Window.Constructor(self)

    self:SetSize(DLG_W, DLG_H)
    self:SetResizable(false)
    self:SetVisible(false)

    self._mode       = "export"
    self._context_nd = nil

    -- TextBox
    self.textbox = Turbine.UI.Lotro.TextBox()
    self.textbox:SetParent(self)
    self.textbox:SetBackColor(Options.Defaults.window.backcolor2)
    self.textbox:SetFont(Options.Defaults.move.headerfont)
    self.textbox:SetMultiline(true)

    self.scrollbar = Turbine.UI.Lotro.ScrollBar()
    self.scrollbar:SetParent(self)
    self.scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical)
    self.scrollbar:SetWidth(SCROLL)
    self.textbox:SetVerticalScrollBar(self.scrollbar)

    -- Buttons (import mode only)
    self.btn_create = make_btn(self, "Create New", function()
        local text = self.textbox:GetText()
        if text ~= "" then
            call_string_to_data(text, false, nil)
            self:SetVisible(false)
        end
    end)

    self.btn_insert = make_btn(self, "Insert Into Selection", function()
        local text = self.textbox:GetText()
        if text ~= "" then
            call_string_to_data(text, true, self._context_nd)
            self:SetVisible(false)
        end
    end)

    self:SizeChanged()
    self:LanguageChanged()
end

function Options2.Window.ImportDialog:SizeChanged()
    if self.textbox == nil then return end
    local w, h  = self:GetSize()
    local top   = Options.Defaults.window.top_spacing
    local sp    = Options.Defaults.window.outer_spacing
    local txt_w = w - sp * 2 - SCROLL
    local txt_h = h - top - sp - BTN_H - sp * 2

    self.textbox:SetPosition(sp, top)
    self.textbox:SetSize(txt_w, txt_h)

    self.scrollbar:SetPosition(sp + txt_w, top)
    self.scrollbar:SetHeight(txt_h)

    local btn_top = top + txt_h + sp
    self.btn_insert:SetPosition(w - sp - BTN_W, btn_top)
    self.btn_create:SetPosition(w - sp - BTN_W * 2 - sp, btn_top)
end

function Options2.Window.ImportDialog:LanguageChanged()
    if self.btn_create == nil then return end
    self.btn_create._lbl:SetText(UTILS.GetText("import", "create_new"))
    self.btn_insert._lbl:SetText(UTILS.GetText("import", "insert_into"))
end

function Options2.Window.ImportDialog:ShowExport(data, importType, index)
    self._mode = "export"
    self:SetText(UTILS.GetText("import", "export"))
    self.textbox:SetEnabled(false)
    self.textbox:SetText(UTILS.DataToStringV2(data, importType, index))
    self.btn_create:SetVisible(false)
    self.btn_insert:SetVisible(false)
    self:_CenterOnOptions2()
    self:SetVisible(true)
    self:Activate()
    self.textbox:Focus()
    self.textbox:SelectAll()
end

function Options2.Window.ImportDialog:ShowImport(context_nd)
    self._mode       = "import"
    self._context_nd = context_nd
    self:SetText(UTILS.GetText("import", "import"))
    self.textbox:SetEnabled(true)
    self.textbox:SetText("")
    self.btn_create:SetVisible(true)
    -- Insert Into is only useful when there is a selection that provides context
    local has_context = context_nd ~= nil and
        (context_nd.nodeType == "window" or context_nd.nodeType == "folder"
         or context_nd.nodeType == "timer" or context_nd.nodeType == "trigger"
         or context_nd.nodeType == "windowtrigger" or context_nd.nodeType == "foldertrigger")
    self.btn_insert:SetVisible(has_context)
    self:_CenterOnOptions2()
    self:SetVisible(true)
    self:Activate()
    self.textbox:Focus()
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
