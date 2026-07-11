local ROW_H  = 30
local DESC_H = 50
local ICON_H = 40
local LEFT   = 5
local TOP    = 8
local TAB_W  = 100

local BC_ODD  = Turbine.UI.Color(0.18, 0.18, 0.18)
local BC_EVEN = Turbine.UI.Color(0.13, 0.13, 0.13)

-- ── helpers ───────────────────────────────────────────────────────────────────

local function make_rows(parent)
    local rows  = {}
    local y     = TOP
    local count = 0
    local function add(widget, h)
        count = count + 1
        widget:SetBackColor(count % 2 == 1 and BC_ODD or BC_EVEN)
        widget:SetParent(parent)
        widget:SetPosition(LEFT, y)
        rows[#rows + 1] = widget
        y = y + (h or ROW_H) + 5
    end
    return add, rows
end

local function size_rows(rows, w)
    for _, r in ipairs(rows) do r:SetWidth(w - LEFT - 5) end
end

local function lang_rows(rows)
    for _, r in ipairs(rows) do r:LanguageChanged() end
end

-- ── paste button helpers ──────────────────────────────────────────────────────

local PASTE_W = 26
local PASTE_H = 20

local function paste_btn(panel, row, attr, types, set_fn)
    local btn = Turbine.UI.Button()
    btn:SetParent(panel)
    btn:SetSize(PASTE_W, PASTE_H)
    btn:SetText("<-")
    btn:SetFont(Options.Defaults.window.font)
    btn:SetForeColor(Turbine.UI.Color(0.5, 0.9, 0.5))
    btn:SetVisible(false)
    btn.Click = function()
        local item = Options2.clipboard.item
        if item ~= nil and item[attr] ~= nil then set_fn(item[attr]) end
    end
    return { btn = btn, row = row, attr = attr, types = types }
end

local function refresh_paste(plist)
    local clip = Options2.clipboard
    for _, p in ipairs(plist) do
        local show = false
        if clip.item ~= nil and clip.item[p.attr] ~= nil then
            for _, t in ipairs(p.types) do
                if t == clip.itemType then show = true; break end
            end
        end
        p.btn:SetVisible(show)
    end
end

local function size_paste(rows, plist, w)
    local marked = {}
    for _, p in ipairs(plist) do marked[p.row] = p end
    for _, r in ipairs(rows) do
        if marked[r] then
            r:SetWidth(w - LEFT - 5 - PASTE_W - 4)
        else
            r:SetWidth(w - LEFT - 5)
        end
    end
    for _, p in ipairs(plist) do
        local ry = p.row:GetTop()
        local rh = p.row:GetHeight()
        p.btn:SetPosition(w - LEFT - PASTE_W - 5, ry + math.floor((rh - PASTE_H) / 2))
    end
end

-- ── General tab (non-COUNTER_BAR) ─────────────────────────────────────────────

local function make_general_tab(data, bc)
    local panel = Turbine.UI.Control()
    local add, rows = make_rows(panel)
    local plist = {}

    local desc = Options2.Elements.TextBoxRow(bc, "options", "description", "tim_description", DESC_H, true)
    add(desc, DESC_H)
    local enabled = Options2.Elements.CheckBoxRow(bc, "options", "enabled", "tim_enabled", ROW_H)
    add(enabled)
    local permanent = Options2.Elements.CheckBoxRow(bc, "options", "permanent2", "tim_permanent2", ROW_H)
    add(permanent)
    local stacking = Options2.Elements.DropDownRow(bc, "options", "stacking", "tim_stacking", ROW_H)
    for name, value in pairs(Stacking) do stacking:AddItem("stacking", name, value) end
    stacking:Sort()
    add(stacking)
    local loop = Options2.Elements.CheckBoxRow(bc, "options", "loop", "tim_loop", ROW_H)
    add(loop)
    local reset = Options2.Elements.CheckBoxRow(bc, "options", "reset", "tim_reset", ROW_H)
    add(reset)
    local protect = Options2.Elements.CheckBoxRow(bc, "options", "proctect", "tim_proctect", ROW_H)
    add(protect)
    local useCustomTimer = Options2.Elements.CheckBoxRow(bc, "options", "useCustomTimer", "tim_use_custom_timer", ROW_H)
    add(useCustomTimer)
    local timerValue = Options2.Elements.NumberBoxRow(bc, "options", "timerValue", "tim_timer_value", ROW_H)
    add(timerValue)
    plist[#plist+1] = paste_btn(panel, timerValue, "timer", {1,2},
        function(v) timerValue:SetText(tostring(v)) end)

    local function load()
        desc:SetText(data.description or "")
        enabled:SetChecked(data.enabled == true)
        permanent:SetChecked(data.permanent == true)
        stacking:SetSelection(data.stacking)
        loop:SetChecked(data.loop == true)
        reset:SetChecked(data.reset == true)
        protect:SetChecked(data.protect == true)
        useCustomTimer:SetChecked(data.useCustomTimer == true)
        timerValue:SetText(tostring(data.timerValue or 10))
    end
    local function save()
        data.description    = desc:GetText()
        data.enabled        = enabled:IsChecked()
        data.permanent      = permanent:IsChecked()
        data.stacking       = stacking:GetSelectedValue()
        data.loop           = loop:IsChecked()
        data.reset          = reset:IsChecked()
        data.protect        = protect:IsChecked()
        data.useCustomTimer = useCustomTimer:IsChecked()
        data.timerValue     = timerValue:GetText() or 10
    end

    load()
    return panel, load, save,
        function() lang_rows(rows) end,
        function(w) size_paste(rows, plist, w) end,
        plist
end

-- ── General tab (COUNTER_BAR) ─────────────────────────────────────────────────

local function make_counter_tab(data, bc)
    local panel = Turbine.UI.Control()
    local add, rows = make_rows(panel)

    local desc = Options2.Elements.TextBoxRow(bc, "options", "description", "tim_description", DESC_H, true)
    add(desc, DESC_H)
    local enabled = Options2.Elements.CheckBoxRow(bc, "options", "enabled", "tim_enabled", ROW_H)
    add(enabled)
    local loop = Options2.Elements.CheckBoxRow(bc, "options", "loop", "tim_loop", ROW_H)
    add(loop)
    local reset = Options2.Elements.CheckBoxRow(bc, "options", "reset", "tim_reset", ROW_H)
    add(reset)
    local counterEND = Options2.Elements.NumberBoxRow(bc, "options", "counterEND", "tim_counter_end", ROW_H)
    add(counterEND)
    local counterSTART = Options2.Elements.NumberBoxRow(bc, "options", "counterSTART", "tim_counter_start", ROW_H)
    add(counterSTART)

    local function load()
        desc:SetText(data.description or "")
        enabled:SetChecked(data.enabled == true)
        loop:SetChecked(data.loop == true)
        reset:SetChecked(data.reset == true)
        counterEND:SetText(tostring(data.counterEND or 0))
        counterSTART:SetText(tostring(data.counterSTART or 10))
    end
    local function save()
        data.description  = desc:GetText()
        data.enabled      = enabled:IsChecked()
        data.loop         = loop:IsChecked()
        data.reset        = reset:IsChecked()
        data.counterEND   = counterEND:GetText() or 0
        data.counterSTART = counterSTART:GetText() or 10
    end

    load()
    return panel, load, save,
        function() lang_rows(rows) end,
        function(w) size_rows(rows, w) end
end

-- ── Style tab ─────────────────────────────────────────────────────────────────

local function make_style_tab(data, bc)
    local panel = Turbine.UI.Control()
    local add, rows = make_rows(panel)
    local plist = {}

    local icon = Options2.Elements.IconBoxRow(bc, "options", "icon", "tim_icon", ICON_H)
    add(icon, ICON_H)
    plist[#plist+1] = paste_btn(panel, icon, "icon", {1,2},
        function(v) icon:SetText(tostring(v)) end)
    local showIcon = Options2.Elements.CheckBoxRow(bc, "options", "showIcon", "tim_show_icon", ROW_H)
    add(showIcon)
    local textOption = Options2.Elements.DropDownRow(bc, "options", "textOption", "tim_text_option", ROW_H)
    for name, value in pairs(TimerTextOptions) do textOption:AddItem("textOption", name, value) end
    textOption:Sort()
    add(textOption)
    local textValue = Options2.Elements.TextBoxRow(bc, "options", "textValue", "tim_text_value", ROW_H, false)
    add(textValue)
    local direction = Options2.Elements.DropDownRow(bc, "options", "direction", "tim_direction", ROW_H)
    for name, value in pairs(Direction) do direction:AddItem("direction", name, value) end
    direction:SortAlpha()
    add(direction)

    local function load()
        icon:SetText(data.icon ~= nil and tostring(data.icon) or "")
        showIcon:SetChecked(data.showIcon == true)
        textOption:SetSelection(data.textOption)
        textValue:SetText(data.textValue or "")
        direction:SetSelection(data.direction)
    end
    local function save()
        data.icon       = icon:GetText()
        data.showIcon   = showIcon:IsChecked()
        data.textOption = textOption:GetSelectedValue()
        data.textValue  = textValue:GetText()
        data.direction  = direction:GetSelectedValue()
    end

    load()
    return panel, load, save,
        function() lang_rows(rows) end,
        function(w) size_paste(rows, plist, w) end,
        plist
end

-- ── Animation tab ─────────────────────────────────────────────────────────────

local function make_animation_tab(data, bc)
    local panel = Turbine.UI.Control()
    local add, rows = make_rows(panel)

    local useThreshold = Options2.Elements.CheckBoxRow(bc, "options", "useThreshold", "tim_use_threshold", ROW_H)
    add(useThreshold)
    local thresholdValue = Options2.Elements.NumberBoxRow(bc, "options", "thresholdValue", "tim_theshold_value", ROW_H)
    add(thresholdValue)
    local useAnimation = Options2.Elements.CheckBoxRow(bc, "options", "useAnimation", "tim_use_animation", ROW_H)
    add(useAnimation)
    local animationType = Options2.Elements.DropDownRow(bc, "options", "animationType", "tim_animation_type", ROW_H)
    for name, value in pairs(AnimationType) do animationType:AddItem("animationType", name, value) end
    animationType:Sort()
    add(animationType)
    local animationSpeed = Options2.Elements.NumberBoxRow(bc, "options", "animationSpeed", "tim_animation_speed", ROW_H)
    add(animationSpeed)
    local useShadow = Options2.Elements.CheckBoxRow(bc, "options", "useShadow", "tim_use_shadow", ROW_H)
    add(useShadow)

    local function load()
        useThreshold:SetChecked(data.useThreshold == true)
        thresholdValue:SetText(tostring(data.thresholdValue or 3))
        useAnimation:SetChecked(data.useAnimation == true)
        animationType:SetSelection(data.animationType)
        animationSpeed:SetText(tostring(data.animationSpeed or 2))
        useShadow:SetChecked(data.useShadow == true)
    end
    local function save()
        data.useThreshold   = useThreshold:IsChecked()
        data.thresholdValue = thresholdValue:GetText() or 3
        data.useAnimation   = useAnimation:IsChecked()
        data.animationType  = animationType:GetSelectedValue()
        data.animationSpeed = animationSpeed:GetText() or 2
        data.useShadow      = useShadow:IsChecked()
    end

    load()
    return panel, load, save,
        function() lang_rows(rows) end,
        function(w) size_rows(rows, w) end
end

-- ── TimerEditor class ─────────────────────────────────────────────────────────

Options2.Window.TimerEditor = class(Turbine.UI.Control)
function Options2.Window.TimerEditor:Constructor(nodeData)
    Turbine.UI.Control.Constructor(self)

    self.nodeData    = nodeData
    local data       = nodeData.data
    local bc         = Options.Defaults.window.basecolor
    local is_counter = (data.type == Timer.Types.COUNTER_BAR)

    self.tabs = Options2.Elements.TabWindow(TAB_W)
    self.tabs:SetParent(self)
    self.tabs:SetPosition(0, 0)

    local gp, gl, gs, glc, gsc, gpl
    if is_counter then
        gp, gl, gs, glc, gsc = make_counter_tab(data, bc)
        gpl = {}
    else
        gp, gl, gs, glc, gsc, gpl = make_general_tab(data, bc)
    end
    local sp, sl, ss, slc, ssc, spl = make_style_tab(data, bc)
    local ap, al, as, alc, asc      = make_animation_tab(data, bc)

    self.tabs:AddTab(gp, "tab", "general")
    self.tabs:AddTab(sp, "tab", "style")
    self.tabs:AddTab(ap, "tab", "animation")

    self._tab_load = { gl, sl, al }
    self._tab_save = { gs, ss, as }
    self._tab_lang = { glc, slc, alc }
    self._tab_size = { gsc, ssc, asc }

    self._paste_list = {}
    for _, p in ipairs(gpl or {}) do self._paste_list[#self._paste_list+1] = p end
    for _, p in ipairs(spl or {}) do self._paste_list[#self._paste_list+1] = p end

    refresh_paste(self._paste_list)
end

function Options2.Window.TimerEditor:SizeChanged()
    if self.tabs == nil then return end
    local w, h = self:GetSize()
    self.tabs:SetSize(w, h)
    for _, fn in ipairs(self._tab_size) do fn(w) end
end

function Options2.Window.TimerEditor:Save()
    for _, fn in ipairs(self._tab_save) do fn() end
    Options.SaveData()
    local wi = self.nodeData.windowIndex
    if wi ~= nil then
        Options.DataChanged(wi)
        Windows.EnabledChanged(wi)
    end
end

function Options2.Window.TimerEditor:Reset()
    for _, fn in ipairs(self._tab_load) do fn() end
end

function Options2.Window.TimerEditor:LanguageChanged()
    if self.tabs == nil then return end
    self.tabs:LanguageChanged()
    for _, fn in ipairs(self._tab_lang) do fn() end
end

function Options2.Window.TimerEditor:ClipboardChanged()
    refresh_paste(self._paste_list)
end
