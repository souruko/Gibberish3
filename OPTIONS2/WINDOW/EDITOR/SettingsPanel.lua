local ROW_H      = 30
local ROW_GAP    = 4
local LEFT       = 5
local TOP        = 8
local STEP_BTN_W = 24
local STEP_BTN_H = 22
local VAL_W      = 46
local LABEL_W    = 110
local CTRL_LEFT  = 145

Options2.Window.SettingsPanel = class(Turbine.UI.Control)
function Options2.Window.SettingsPanel:Constructor()
    Turbine.UI.Control.Constructor(self)

    self:SetBackColor(Options.Defaults.window.backcolor1)

    local sp = Options.Defaults.window.spacing

    -- ── language ─────────────────────────────────────────────────────────────
    self.language = Options2.Elements.DropDownRow(
        Options.Defaults.window.basecolor,
        "general", "language", "dd_language", ROW_H, nil
    )
    self.language:SetParent(self)
    self.language:SetPosition(LEFT, TOP)
    self.language:AddItem("general", "english", Language.English)
    self.language:AddItem("general", "german",  Language.German)
    self.language:AddItem("general", "french",  Language.French)
    self.language:SetSelection(Data.options.language)
    self.language:SetCallback(function(sender, index, value)
        Options.LanguageChanged(value)
    end)

    -- ── shortcut size ────────────────────────────────────────────────────────
    self.shortcut_row = Turbine.UI.Control()
    self.shortcut_row:SetParent(self)
    self.shortcut_row:SetPosition(LEFT, TOP + ROW_H + ROW_GAP)
    self.shortcut_row:SetHeight(ROW_H)
    self.shortcut_row:SetBackColor(Options.Defaults.window.basecolor)

    self.shortcut_label = Turbine.UI.Label()
    self.shortcut_label:SetParent(self.shortcut_row)
    self.shortcut_label:SetPosition(sp, sp)
    self.shortcut_label:SetSize(LABEL_W, ROW_H - sp)
    self.shortcut_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
    self.shortcut_label:SetFont(Options.Defaults.window.font)
    self.shortcut_label:SetForeColor(Options.Defaults.window.textcolor)
    self.shortcut_label:SetText(UTILS.GetText("general", "shortcut_size"))
    Options2.Elements.Tooltip.AddTooltip(self.shortcut_label, "tooltip", "dd_shortcut_size", false)

    local step_top = math.floor((ROW_H - STEP_BTN_H) / 2)

    local function make_step_btn(sign, delta)
        local btn = Turbine.UI.Control()
        btn:SetParent(self.shortcut_row)
        btn:SetSize(STEP_BTN_W, STEP_BTN_H)
        btn:SetTop(step_top)
        btn:SetBackColor(Options.Defaults.window.backcolor2)
        btn:SetMouseVisible(true)

        local lbl = Turbine.UI.Label()
        lbl:SetParent(btn)
        lbl:SetSize(STEP_BTN_W, STEP_BTN_H)
        lbl:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
        lbl:SetFont(Options.Defaults.window.font)
        lbl:SetForeColor(Options.Defaults.window.textcolor)
        lbl:SetText(sign)
        lbl:SetMouseVisible(false)

        btn.MouseEnter = function() btn:SetBackColor(Options.Defaults.window.hovercolor) end
        btn.MouseLeave = function() btn:SetBackColor(Options.Defaults.window.backcolor2) end
        btn.MouseClick = function() self:_StepShortcutSize(delta) end

        return btn
    end

    self.shortcut_minus = make_step_btn("-", -Options.Defaults.shortcut.size_step)
    self.shortcut_minus:SetLeft(CTRL_LEFT)

    self.shortcut_value_bg = Turbine.UI.Control()
    self.shortcut_value_bg:SetParent(self.shortcut_row)
    self.shortcut_value_bg:SetSize(VAL_W, STEP_BTN_H)
    self.shortcut_value_bg:SetPosition(CTRL_LEFT + STEP_BTN_W + sp, step_top)
    self.shortcut_value_bg:SetBackColor(Options.Defaults.window.backcolor2)
    self.shortcut_value_bg:SetMouseVisible(false)

    self.shortcut_value = Turbine.UI.Label()
    self.shortcut_value:SetParent(self.shortcut_value_bg)
    self.shortcut_value:SetSize(VAL_W, STEP_BTN_H)
    self.shortcut_value:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.shortcut_value:SetFont(Options.Defaults.window.font)
    self.shortcut_value:SetForeColor(Options.Defaults.window.textcolor)
    self.shortcut_value:SetMouseVisible(false)

    self.shortcut_plus = make_step_btn("+", Options.Defaults.shortcut.size_step)
    self.shortcut_plus:SetLeft(CTRL_LEFT + STEP_BTN_W + sp + VAL_W + sp)

    self:_RefreshShortcutSize()

    -- ── auto reload ──────────────────────────────────────────────────────────
    self.auto_reload = Options2.Elements.CheckBoxRow(
        Options.Defaults.window.basecolor,
        "shortcut", "auto_reload", "cb_auto_reload", ROW_H
    )
    self.auto_reload:SetParent(self)
    self.auto_reload:SetPosition(LEFT, TOP + 2 * (ROW_H + ROW_GAP))
    self.auto_reload:SetChecked(Data.autoReload)
    self.auto_reload:SetCallback(function(value)
        Options.AutoReloadChanged()
    end)

    -- ── show tooltips ────────────────────────────────────────────────────────
    self.show_tooltips = Options2.Elements.CheckBoxRow(
        Options.Defaults.window.basecolor,
        "general", "show_tooltips", "cb_show_tooltips", ROW_H
    )
    self.show_tooltips:SetParent(self)
    self.show_tooltips:SetPosition(LEFT, TOP + 3 * (ROW_H + ROW_GAP))
    self.show_tooltips:SetChecked(Data.showTooltips)
    self.show_tooltips:SetCallback(function(value)
        Data.showTooltips = value
    end)
end

function Options2.Window.SettingsPanel:_RefreshShortcutSize()
    local size = Data.options.shortcut.size or Options.Defaults.shortcut.size
    self.shortcut_value:SetText(tostring(size) .. "px")
end

function Options2.Window.SettingsPanel:_StepShortcutSize(delta)
    local size = Data.options.shortcut.size or Options.Defaults.shortcut.size
    size = size + delta
    if size < Options.Defaults.shortcut.min_size then size = Options.Defaults.shortcut.min_size end
    if size > Options.Defaults.shortcut.max_size then size = Options.Defaults.shortcut.max_size end

    Data.options.shortcut.size = size
    self:_RefreshShortcutSize()

    if Options.Shortcut.Object ~= nil then
        Options.Shortcut.Object:SetIconSize(size)
    end

    Options.SaveData()
end

function Options2.Window.SettingsPanel:SizeChanged()
    if self.language == nil then return end
    local w = self:GetWidth() - LEFT - 5
    self.language:SetWidth(w)
    self.shortcut_row:SetWidth(w)
    self.auto_reload:SetWidth(w)
    self.show_tooltips:SetWidth(w)
end

function Options2.Window.SettingsPanel:LanguageChanged()
    if self.language == nil then return end
    self.language:LanguageChanged()
    self.language.dropdown:LanguageChanged()
    self.language:SetSelection(Data.options.language)
    self.shortcut_label:SetText(UTILS.GetText("general", "shortcut_size"))
    self.auto_reload:LanguageChanged()
    self.show_tooltips:LanguageChanged()
end

function Options2.Window.SettingsPanel:AutoReloadChanged()
    if self.auto_reload == nil then return end
    self.auto_reload:SetChecked(Data.autoReload)
end
