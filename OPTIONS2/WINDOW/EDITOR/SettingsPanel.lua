local ROW_GAP    = 4
local LEFT       = 5
local TOP        = 8

-- this panel's rows are taller than the editor's, so it keeps its own metrics
local ROW_H      = 30
local STEP_BTN_W = 24
local STEP_BTN_H = 22
local VAL_W      = 46
local LABEL_W    = 110
local CTRL_LEFT  = 145

-- two lines of warning text under the prime parse integration row
local WARN_H     = 38

-- the prime parse integration row's label needs more room than the shared 104px column
local LABEL_W2   = 150

-- the metrics that hold text follow the panel's font size; see OPTIONS2/Fonts.lua
Options2.Fonts.Register(function()
    local F = Options2.Fonts
    ROW_H      = F.Px(30)
    STEP_BTN_W = F.Px(24)
    STEP_BTN_H = F.Px(22)
    VAL_W      = F.Px(46)
    LABEL_W    = F.Px(110)
    CTRL_LEFT  = F.Px(145)
    WARN_H     = F.Px(38)
    LABEL_W2   = F.Px(150)
end)

-- height this panel needs for its rows, so the window can size itself to them
function Options2.Window.SettingsPanelHeight(rows)
    return TOP + rows * (ROW_H + ROW_GAP) + TOP
end

-- the warning under the prime parse integration row keeps its room whether it is showing or not, so
-- switching group tracking never resizes the window
function Options2.Window.SettingsWarningHeight()
    return WARN_H
end

Options2.Window.SettingsPanel = class(Turbine.UI.Control)
function Options2.Window.SettingsPanel:Constructor()
    Turbine.UI.Control.Constructor(self)

    self:SetBackColor(Options.Defaults.window.bg)

    local sp = Options.Defaults.window.spacing

    -- ── language ─────────────────────────────────────────────────────────────
    self.language = Options2.Elements.DropDownRow(
        Options.Defaults.window.row_odd,
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
    self.shortcut_row:SetBackColor(Options.Defaults.window.row_odd)

    self.shortcut_label = Turbine.UI.Label()
    self.shortcut_label:SetParent(self.shortcut_row)
    self.shortcut_label:SetPosition(sp, sp)
    self.shortcut_label:SetSize(LABEL_W, ROW_H - sp)
    self.shortcut_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight)
    self.shortcut_label:SetFont(Options.Defaults.window.font)
    self.shortcut_label:SetForeColor(Options.Defaults.window.text)
    self.shortcut_label:SetText(UTILS.GetText("general", "shortcut_size"))
    Options2.Elements.Tooltip.AddTooltip(self.shortcut_label, "tooltip", "dd_shortcut_size", false)

    local step_top = math.floor((ROW_H - STEP_BTN_H) / 2)

    local function make_step_btn(sign, delta)
        local btn = Turbine.UI.Control()
        btn:SetParent(self.shortcut_row)
        btn:SetSize(STEP_BTN_W, STEP_BTN_H)
        btn:SetTop(step_top)
        btn:SetBackColor(Options.Defaults.window.bg_sunken)
        btn:SetMouseVisible(true)

        local lbl = Turbine.UI.Label()
        lbl:SetParent(btn)
        lbl:SetSize(STEP_BTN_W, STEP_BTN_H)
        lbl:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
        lbl:SetFont(Options.Defaults.window.font)
        lbl:SetForeColor(Options.Defaults.window.text)
        lbl:SetText(sign)
        lbl:SetMouseVisible(false)

        btn.MouseEnter = function() btn:SetBackColor(Options.Defaults.window.select) end
        btn.MouseLeave = function() btn:SetBackColor(Options.Defaults.window.bg_sunken) end
        btn.MouseClick = function() self:_StepShortcutSize(delta) end

        return btn
    end

    self.shortcut_minus = make_step_btn("-", -Options.Defaults.shortcut.size_step)
    self.shortcut_minus:SetLeft(CTRL_LEFT)

    self.shortcut_value_bg = Turbine.UI.Control()
    self.shortcut_value_bg:SetParent(self.shortcut_row)
    self.shortcut_value_bg:SetSize(VAL_W, STEP_BTN_H)
    self.shortcut_value_bg:SetPosition(CTRL_LEFT + STEP_BTN_W + sp, step_top)
    self.shortcut_value_bg:SetBackColor(Options.Defaults.window.bg_sunken)
    self.shortcut_value_bg:SetMouseVisible(false)

    self.shortcut_value = Turbine.UI.Label()
    self.shortcut_value:SetParent(self.shortcut_value_bg)
    self.shortcut_value:SetSize(VAL_W, STEP_BTN_H)
    self.shortcut_value:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.shortcut_value:SetFont(Options.Defaults.window.font)
    self.shortcut_value:SetForeColor(Options.Defaults.window.text)
    self.shortcut_value:SetMouseVisible(false)

    self.shortcut_plus = make_step_btn("+", Options.Defaults.shortcut.size_step)
    self.shortcut_plus:SetLeft(CTRL_LEFT + STEP_BTN_W + sp + VAL_W + sp)

    self:_RefreshShortcutSize()

    -- ── font size ────────────────────────────────────────────────────────────
    -- Scales the options panel and the move window, nothing in the game world.
    -- Picking a size rebuilds both, so the panel comes back at the new size with
    -- the same selection.
    self.font_size = Options2.Elements.DropDownRow(
        Options.Defaults.window.row_odd,
        "general", "font_size", "dd_font_size", ROW_H, nil
    )
    self.font_size:SetParent(self)
    self.font_size:SetPosition(LEFT, TOP + 2 * (ROW_H + ROW_GAP))
    self.font_size:AddItem("general", "font_normal", Options2.Fonts.Scale.NORMAL)
    self.font_size:AddItem("general", "font_large",  Options2.Fonts.Scale.LARGE)
    self.font_size:AddItem("general", "font_xlarge", Options2.Fonts.Scale.XLARGE)
    self.font_size:SetSelection(Options2.Fonts.Current())
    self.font_size:SetCallback(function(sender, index, value)
        Options2.ApplyFontScale(value)
    end)

    -- ── reload mode ──────────────────────────────────────────────────────────
    -- Group effect tracking reads the party once, at start up, so a group change
    -- needs the plugin reloaded. This picks who does it: nobody, the plugin, or
    -- the player answering a prompt.
    self.reload_mode = Options2.Elements.DropDownRow(
        Options.Defaults.window.row_odd,
        "general", "reload_mode", "dd_reload_mode", ROW_H, nil
    )
    self.reload_mode:SetParent(self)
    self.reload_mode:SetPosition(LEFT, TOP + 3 * (ROW_H + ROW_GAP))
    self.reload_mode:AddItem("general", "reload_manual", ReloadMode.Manual)
    self.reload_mode:AddItem("general", "reload_auto",   ReloadMode.Auto)
    self.reload_mode:AddItem("general", "reload_prompt", ReloadMode.Prompt)
    self.reload_mode:SetSelection(Data.reloadMode)
    self.reload_mode:SetCallback(function(sender, index, value)
        Options.ReloadModeChanged(value)
    end)

    -- ── show tooltips ────────────────────────────────────────────────────────
    self.show_tooltips = Options2.Elements.CheckBoxRow(
        Options.Defaults.window.row_odd,
        "general", "show_tooltips", "cb_show_tooltips", ROW_H
    )
    self.show_tooltips:SetParent(self)
    self.show_tooltips:SetPosition(LEFT, TOP + 4 * (ROW_H + ROW_GAP))
    self.show_tooltips:SetChecked(Data.showTooltips)
    self.show_tooltips:SetCallback(function(value)
        Data.showTooltips = value
    end)

    -- ── prime parse integration ─────────────────────────────────────────────
    -- Writes the group's names, classes and trait lines for Prime Group Parse.
    -- Only works with group effect tracking on, since that is what reads the
    -- other members' effects, so the row warns when it is off.
    self.export_group = Options2.Elements.CheckBoxRow(
        Options.Defaults.window.row_odd,
        "general", "export_group_setup", "cb_export_group_setup", ROW_H
    )
    self.export_group:SetParent(self)
    self.export_group:SetPosition(LEFT, TOP + 5 * (ROW_H + ROW_GAP))

    -- This label is far longer than the other rows' and does not fit the shared
    -- 104px label column, so it gets its own width and its switch moves over to
    -- clear it. Left at the shared width the text is simply cut off.
    self.export_group.label:SetWidth(LABEL_W2)
    self.export_group.checkbox:SetLeft(LABEL_W2 + Options2.Elements.EditorRow.LABEL_GAP)

    self.export_group:SetChecked(Data.exportGroupSetup)
    self.export_group:SetCallback(function(value)
        Data.exportGroupSetup = value
        Options.SaveData()

        -- write straight away when switched on, so the file is there without
        -- waiting for the next fight to end
        GroupSetup.Write()
    end)

    -- the warning, shown only while group tracking is off. Its room is always
    -- reserved, so showing and hiding it never resizes the window
    self.export_warn = Turbine.UI.Control()
    self.export_warn:SetParent(self)
    self.export_warn:SetBackColor(Options.Defaults.window.color_trigger)
    self.export_warn:SetMouseVisible(false)

    self.export_warn_fill = Turbine.UI.Control()
    self.export_warn_fill:SetParent(self.export_warn)
    self.export_warn_fill:SetPosition(1, 1)
    self.export_warn_fill:SetBackColor(Options.Defaults.window.bg_sunken)
    self.export_warn_fill:SetMouseVisible(false)

    self.export_warn_label = Turbine.UI.Label()
    self.export_warn_label:SetParent(self.export_warn_fill)
    self.export_warn_label:SetPosition(sp, 2)
    self.export_warn_label:SetFont(Options.Defaults.window.font)
    self.export_warn_label:SetForeColor(Options.Defaults.window.text)
    self.export_warn_label:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft)
    self.export_warn_label:SetMultiline(true)
    self.export_warn_label:SetMouseVisible(false)

    self:TrackGroupChanged()
end

-- group tracking was switched on or off, so the warning and the greyed label follow it
function Options2.Window.SettingsPanel:TrackGroupChanged()
    if self.export_group == nil then return end

    local tracking = (Data.trackGroupEffects == true)

    -- text_muted is what every row label uses, see EditorRow.MakeLabel; only the
    -- greyed out state departs from it
    self.export_group.label:SetForeColor(
        tracking and Options.Defaults.window.text_muted or Options.Defaults.window.text_faint)

    self.export_warn_label:SetText(UTILS.GetText("general", "export_group_warning"))
    self.export_warn:SetVisible(not tracking)
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
    self.font_size:SetWidth(w)
    self.reload_mode:SetWidth(w)
    self.show_tooltips:SetWidth(w)
    self.export_group:SetWidth(w)

    self.export_warn:SetPosition(LEFT, TOP + 6 * (ROW_H + ROW_GAP))
    self.export_warn:SetSize(w, WARN_H)
    self.export_warn_fill:SetSize(w - 2, WARN_H - 2)
    self.export_warn_label:SetSize(w - 2 - 2 * Options.Defaults.window.spacing, WARN_H - 4)
end

function Options2.Window.SettingsPanel:LanguageChanged()
    if self.language == nil then return end
    self.language:LanguageChanged()
    self.language.dropdown:LanguageChanged()
    self.language:SetSelection(Data.options.language)
    self.shortcut_label:SetText(UTILS.GetText("general", "shortcut_size"))
    self.font_size:LanguageChanged()
    self.font_size.dropdown:LanguageChanged()
    self.font_size:SetSelection(Options2.Fonts.Current())
    self.reload_mode:LanguageChanged()
    self.reload_mode.dropdown:LanguageChanged()
    self.reload_mode:SetSelection(Data.reloadMode)
    self.show_tooltips:LanguageChanged()
    self.export_group:LanguageChanged()
    self:TrackGroupChanged()
end

function Options2.Window.SettingsPanel:ReloadModeChanged()
    if self.reload_mode == nil then return end
    self.reload_mode:SetSelection(Data.reloadMode)
end
