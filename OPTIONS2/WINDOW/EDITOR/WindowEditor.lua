local ROW_H   = 30
local DESC_H  = 50
local LEFT    = 5
local TOP     = 8
local TAB_W   = 100

local BC_ODD  = Turbine.UI.Color(0.18, 0.18, 0.18)
local BC_EVEN = Turbine.UI.Color(0.13, 0.13, 0.13)

-- ── helpers ───────────────────────────────────────────────────────────────────

local function make_rows(parent, data, bc)
    local rows  = {}
    local y     = TOP
    local count = 0

    local function add(widget, h)
        count = count + 1
        widget:SetBackColor(count % 2 == 1 and BC_ODD or BC_EVEN)
        widget:SetParent(parent)
        widget:SetPosition(LEFT, y)
        rows[#rows + 1] = widget
        y = y + (h or ROW_H)
    end

    return add, rows, function() return y end
end

-- ── General tab ──────────────────────────────────────────────────────────────

local function make_general_tab(data, bc)
    local panel = Turbine.UI.Control()
    local add, rows = make_rows(panel, data, bc)

    local name = Options2.Elements.TextBoxRow(bc, "options2", "name", "name", ROW_H, false)
    add(name, ROW_H + 5)

    local timerType = Options2.Elements.DropDownRow(bc, "options", "timerType", "win_timer_type", ROW_H)
    if data.type == Window.Types.TIMER_WINDOW then
        timerType:AddItem("type", Timer.Types.BAR,    Timer.Types.BAR)
        timerType:AddItem("type", Timer.Types.ICON,   Timer.Types.ICON)
        timerType:AddItem("type", Timer.Types.TEXT,   Timer.Types.TEXT)
        timerType:AddItem("type", Timer.Types.CIRCEL, Timer.Types.CIRCEL)
        timerType:SortAlpha()
    elseif data.type == Window.Types.COUNTER_WINDOW then
        timerType:AddItem("type", Timer.Types.COUNTER_BAR, Timer.Types.COUNTER_BAR)
    end
    add(timerType, ROW_H + 5)

    local desc = Options2.Elements.TextBoxRow(bc, "options", "description", "win_description", DESC_H, true)
    add(desc, DESC_H + 5)
    local saveGlobaly = Options2.Elements.CheckBoxRow(bc, "options", "saveGlobaly", "win_save_globaly", ROW_H)
    add(saveGlobaly, ROW_H + 5)
    local resetOnTargetChanged = Options2.Elements.CheckBoxRow(bc, "options", "resetOnTargetChanged", "win_reset_on_target_change", ROW_H)
    add(resetOnTargetChanged, ROW_H + 5)
    local useTargetEntity = Options2.Elements.CheckBoxRow(bc, "options", "useTargetEntity", "win_use_target_entity", ROW_H)
    add(useTargetEntity, ROW_H + 5)
    local overlay = Options2.Elements.CheckBoxRow(bc, "options", "overlay", "win_overlay", ROW_H)
    add(overlay, ROW_H + 5)

    local function load()
        name:SetText(data.name or "")
        timerType:SetSelection(data.timerType)
        desc:SetText(data.description or "")
        saveGlobaly:SetChecked(data.saveGlobaly == true)
        resetOnTargetChanged:SetChecked(data.resetOnTargetChanged == true)
        useTargetEntity:SetChecked(data.useTargetEntity == true)
        overlay:SetChecked(data.overlay == true)
    end

    local function save()
        data.name                  = name:GetText()
        local newTimerType         = timerType:GetSelectedValue()
        if newTimerType ~= nil and newTimerType ~= data.timerType then
            data.timerType = newTimerType
            if data.timerList then
                for _, td in ipairs(data.timerList) do
                    td.type = newTimerType
                end
            end
        end
        data.description           = desc:GetText()
        data.saveGlobaly           = saveGlobaly:IsChecked()
        data.resetOnTargetChanged  = resetOnTargetChanged:IsChecked()
        data.useTargetEntity       = useTargetEntity:IsChecked()
        data.overlay               = overlay:IsChecked()
    end

    local function lang_changed()
        for _, r in ipairs(rows) do r:LanguageChanged() end
    end

    local function size_changed(w)
        for _, r in ipairs(rows) do r:SetWidth(w - LEFT - 5) end
    end

    load()
    return panel, load, save, lang_changed, size_changed
end

-- ── Size tab ─────────────────────────────────────────────────────────────────

local function make_size_tab(data, bc)
    local panel = Turbine.UI.Control()
    local add, rows = make_rows(panel, data, bc)

    local width  = Options2.Elements.NumberBoxRow(bc, "options", "width",  "win_width",  ROW_H)
    add(width, ROW_H)
    local height = Options2.Elements.NumberBoxRow(bc, "options", "height", "win_height", ROW_H)
    add(height, ROW_H + 5)
    local frame  = Options2.Elements.NumberBoxRow(bc, "options", "frame",  "win_frame",  ROW_H)
    add(frame, ROW_H)
    local spacing = Options2.Elements.NumberBoxRow(bc, "options", "spacing", "win_spacing", ROW_H)
    add(spacing, ROW_H + 5)

    local direction = Options2.Elements.DropDownRow(bc, "options", "direction", "win_direction", ROW_H)
    for name, value in pairs(Direction) do
        direction:AddItem("direction", name, value)
    end
    direction:SortAlpha()
    add(direction, ROW_H)

    local sort_direction = Options2.Elements.DropDownRow(bc, "options", "sort_direction", "win_sort_direction", ROW_H)
    for name, value in pairs(Direction) do
        sort_direction:AddItem("direction", name, value)
    end
    sort_direction:SortAlpha()
    add(sort_direction, ROW_H)

    local orientation = Options2.Elements.DropDownRow(bc, "options", "orientation", "win_orientation", ROW_H)
    for name, value in pairs(Orientation) do
        orientation:AddItem("orientation", name, value)
    end
    orientation:SortAlpha()
    add(orientation, ROW_H + 5)

    local function load()
        width:SetText(data.width)
        height:SetText(data.height)
        frame:SetText(data.frame)
        spacing:SetText(data.spacing)
        direction:SetSelection(data.direction)
        sort_direction:SetSelection(data.sort_direction)
        orientation:SetSelection(data.orientation)
    end

    local function save()
        data.width         = width:GetText()
        data.height        = height:GetText()
        data.frame         = frame:GetText()
        data.spacing       = spacing:GetText()
        data.direction     = direction:GetSelectedValue()
        data.sort_direction = sort_direction:GetSelectedValue()
        data.orientation   = orientation:GetSelectedValue()
    end

    local function lang_changed()
        for _, r in ipairs(rows) do r:LanguageChanged() end
    end

    local function size_changed(w)
        for _, r in ipairs(rows) do r:SetWidth(w - LEFT - 5) end
    end

    load()
    return panel, load, save, lang_changed, size_changed
end

-- ── Color tab ────────────────────────────────────────────────────────────────

local function make_color_tab(data, bc)
    local panel = Turbine.UI.Control()
    local add, rows = make_rows(panel, data, bc)

    local color1 = Options2.Elements.ColorBoxRow(bc, "options", "color1", "win_color_frame", ROW_H)
    add(color1, ROW_H)
    local color2 = Options2.Elements.ColorBoxRow(bc, "options", "color2", "win_color_back", ROW_H)
    add(color2, ROW_H)
    local color3 = Options2.Elements.ColorBoxRow(bc, "options", "color3", "win_color_bar", ROW_H)
    add(color3, ROW_H)
    local color4 = Options2.Elements.ColorBoxRow(bc, "options", "color4", "win_color_timer", ROW_H)
    add(color4, ROW_H)
    local color5 = Options2.Elements.ColorBoxRow(bc, "options", "color5", "win_color_text", ROW_H)
    add(color5, ROW_H)
    local color6 = Options2.Elements.ColorBoxRow(bc, "options", "color6", "win_color_outline", ROW_H)
    add(color6, ROW_H + 5)
    local color7 = Options2.Elements.ColorBoxRow(bc, "options", "color7", "win_color_threshold", ROW_H)
    add(color7, ROW_H)
    local color8 = Options2.Elements.ColorBoxRow(bc, "options", "color8", "win_color_thresholdTimer", ROW_H)
    add(color8, ROW_H)
    local color9 = Options2.Elements.ColorBoxRow(bc, "options", "color9", "win_color_thresholdText", ROW_H)
    add(color9, ROW_H + 5)
    local opacityActiv = Options2.Elements.SliderBoxRow(bc, "options", "opacityActiv", "win_opacity_activ", ROW_H)
    add(opacityActiv, ROW_H)
    local opacityPassiv = Options2.Elements.SliderBoxRow(bc, "options", "opacityPassiv", "win_opacity_passiv", ROW_H)
    add(opacityPassiv, ROW_H)
    local opacityThreshold = Options2.Elements.SliderBoxRow(bc, "options", "opacityThreshold", "win_opacity_theshold", ROW_H)
    add(opacityThreshold, ROW_H + 5)

    local function load()
        color1:SetText(data.color1)
        color2:SetText(data.color2)
        color3:SetText(data.color3)
        color4:SetText(data.color4)
        color5:SetText(data.color5)
        color6:SetText(data.color6)
        color7:SetText(data.color7)
        color8:SetText(data.color8)
        color9:SetText(data.color9)
        opacityActiv:SetText(data.opacityActiv)
        opacityPassiv:SetText(data.opacityPassiv)
        opacityThreshold:SetText(data.opacityThreshold)
    end

    local function save()
        data.color1           = color1:GetText()
        data.color2           = color2:GetText()
        data.color3           = color3:GetText()
        data.color4           = color4:GetText()
        data.color5           = color5:GetText()
        data.color6           = color6:GetText()
        data.color7           = color7:GetText()
        data.color8           = color8:GetText()
        data.color9           = color9:GetText()
        data.opacityActiv     = opacityActiv:GetText()
        data.opacityPassiv    = opacityPassiv:GetText()
        data.opacityThreshold = opacityThreshold:GetText()
    end

    local function lang_changed()
        for _, r in ipairs(rows) do r:LanguageChanged() end
    end

    local function size_changed(w)
        for _, r in ipairs(rows) do r:SetWidth(w - LEFT - 5) end
    end

    load()
    return panel, load, save, lang_changed, size_changed
end

-- ── Text tab ─────────────────────────────────────────────────────────────────

local function font_populate(dropdown, font_value)
    dropdown:ClearItems()
    for name, _ in pairs(Font[font_value]) do
        dropdown:AddItem("fontSize", name, name)
    end
    dropdown:Sort()
end

local function make_text_tab(data, bc)
    local panel = Turbine.UI.Control()
    local add, rows = make_rows(panel, data, bc)

    local font = Options2.Elements.DropDownRow(bc, "options", "font", "win_font", ROW_H)
    for name, value in pairs(Font.Type) do
        font:AddItem("font", name, value)
    end
    font:Sort()
    add(font, ROW_H)

    local fontSize = Options2.Elements.DropDownRow(bc, "options", "fontSize", "win_font_size", ROW_H)
    add(fontSize, ROW_H + 5)

    font:SetCallback(function(sender, index, value)
        font_populate(fontSize, value)
        fontSize:SetSelection(nil)
    end)

    local numberFormat = Options2.Elements.DropDownRow(bc, "options", "numberFormat", "win_number_format", ROW_H)
    for name, value in pairs(NumberFormat) do
        numberFormat:AddItem("numberFormat", name, value)
    end
    numberFormat:Sort()
    add(numberFormat, ROW_H + 5)

    local textAlignment = Options2.Elements.DropDownRow(bc, "options", "textAlignment", "win_text_align", ROW_H)
    for name, value in pairs(Alignment) do
        textAlignment:AddItem("alignment", name, value)
    end
    textAlignment:Sort()
    add(textAlignment, ROW_H)

    local timerAlignment = Options2.Elements.DropDownRow(bc, "options", "timerAlignment", "win_timer_align", ROW_H)
    for name, value in pairs(Alignment) do
        timerAlignment:AddItem("alignment", name, value)
    end
    timerAlignment:Sort()
    add(timerAlignment, ROW_H + 5)

    local showTimer = Options2.Elements.CheckBoxRow(bc, "options", "showTimer", "win_show_timer", ROW_H)
    add(showTimer, ROW_H + 5)

    local thresholdFont = Options2.Elements.DropDownRow(bc, "options", "thresholdFont", "win_thesholdFont", ROW_H)
    for name, value in pairs(Font.Type) do
        thresholdFont:AddItem("font", name, value)
    end
    thresholdFont:Sort()
    add(thresholdFont, ROW_H)

    local thresholdFontSize = Options2.Elements.DropDownRow(bc, "options", "thresholdFontSize", "win_thesholdFont_size", ROW_H)
    add(thresholdFontSize, ROW_H + 5)

    thresholdFont:SetCallback(function(sender, index, value)
        font_populate(thresholdFontSize, value)
        thresholdFontSize:SetSelection(nil)
    end)

    local function load()
        font:SetSelection(data.font)
        font_populate(fontSize, data.font)
        fontSize:SetSelection(data.fontSize)

        numberFormat:SetSelection(data.durationFormat)
        textAlignment:SetSelection(data.textAlignment)
        timerAlignment:SetSelection(data.timerAlignment)
        showTimer:SetChecked(data.showTimer == true)

        thresholdFont:SetSelection(data.thresholdFont)
        font_populate(thresholdFontSize, data.thresholdFont)
        thresholdFontSize:SetSelection(data.thresholdFontSize)
    end

    local function save()
        data.font              = font:GetSelectedValue()
        data.fontSize          = fontSize:GetSelectedValue()
        data.durationFormat    = numberFormat:GetSelectedValue()
        data.textAlignment     = textAlignment:GetSelectedValue()
        data.timerAlignment    = timerAlignment:GetSelectedValue()
        data.showTimer         = showTimer:IsChecked()
        data.thresholdFont     = thresholdFont:GetSelectedValue()
        data.thresholdFontSize = thresholdFontSize:GetSelectedValue()
    end

    local function lang_changed()
        for _, r in ipairs(rows) do r:LanguageChanged() end
    end

    local function size_changed(w)
        for _, r in ipairs(rows) do r:SetWidth(w - LEFT - 5) end
    end

    load()
    return panel, load, save, lang_changed, size_changed
end

-- ── WindowEditor class ────────────────────────────────────────────────────────

Options2.Window.WindowEditor = class(Turbine.UI.Control)
function Options2.Window.WindowEditor:Constructor(winData, winIndex)
    Turbine.UI.Control.Constructor(self)

    self.data     = winData
    self.winIndex = winIndex

    local bc = Options.Defaults.window.basecolor

    -- Tab window (fills the full area)
    self.tabs = Options2.Elements.TabWindow(TAB_W)
    self.tabs:SetParent(self)
    self.tabs:SetPosition(0, 0)

    -- build each tab panel
    local gp, gl, gs, glc, gsc = make_general_tab(winData, bc)
    local sp, sl, ss, slc, ssc = make_size_tab(winData, bc)
    local cp, cl, cs, clc, csc = make_color_tab(winData, bc)
    local tp, tl, ts, tlc, tsc = make_text_tab(winData, bc)

    self.tabs:AddTab(gp, "options2", "tab_general")
    self.tabs:AddTab(sp, "options2", "tab_size")
    self.tabs:AddTab(cp, "options2", "tab_color")
    self.tabs:AddTab(tp, "options2", "tab_text")

    -- stash the per-tab helpers
    self._tab_load = { gl, sl, cl, tl }
    self._tab_save = { gs, ss, cs, ts }
    self._tab_lang = { glc, slc, clc, tlc }
    self._tab_size = { gsc, ssc, csc, tsc }
end

function Options2.Window.WindowEditor:SizeChanged()
    if self.tabs == nil then return end
    local w, h = self:GetSize()
    self.tabs:SetSize(w, h)
    for _, fn in ipairs(self._tab_size) do fn(w) end
end

function Options2.Window.WindowEditor:Load(winData, winIndex)
    self.data     = winData
    self.winIndex = winIndex
    for _, fn in ipairs(self._tab_load) do fn() end
end

function Options2.Window.WindowEditor:Save()
    for _, fn in ipairs(self._tab_save) do fn() end

    Options.SaveData()
    Options.DataChanged(self.winIndex)
    Windows.EnabledChanged(self.winIndex)
end

function Options2.Window.WindowEditor:Reset()
    for _, fn in ipairs(self._tab_load) do fn() end
end

function Options2.Window.WindowEditor:LanguageChanged()
    if self.tabs == nil then return end
    self.tabs:LanguageChanged()
    for _, fn in ipairs(self._tab_lang) do fn() end
end
