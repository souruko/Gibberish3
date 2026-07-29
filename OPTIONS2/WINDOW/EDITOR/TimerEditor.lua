local ROW_H  = 28
local DESC_H = 40
local ICON_H = 40
local LEFT   = 10
local TOP    = 10
local TAB_W  = 100

local BC_ODD  = Options.Defaults.window.row_odd
local BC_EVEN = Options.Defaults.window.row_even

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
        y = y + (h or ROW_H) + 2
    end
    return add, rows
end

local function size_rows(rows, w)
    for _, r in ipairs(rows) do r:SetWidth(w - LEFT - LEFT) end
end

local function lang_rows(rows)
    for _, r in ipairs(rows) do r:LanguageChanged() end
end

-- ── paste button helpers ──────────────────────────────────────────────────────

local PASTE_W = 64
local PASTE_H = 20

-- Labelled "<- paste" button. Clicking it aims the library at this field; if
-- something usable is already copied it is taken straight away. Idle it is a
-- sunken pill with a green border, armed it fills with the accent colour.
local function paste_btn(panel, row, attr, types, set_fn)
    local btn = Turbine.UI.Control()
    btn:SetParent(panel)
    btn:SetSize(PASTE_W, PASTE_H)
    btn:SetBackColor(Options.Defaults.window.paste_border)
    btn:SetMouseVisible(true)

    local fill = Turbine.UI.Control()
    fill:SetParent(btn)
    fill:SetPosition(1, 1)
    fill:SetSize(PASTE_W - 2, PASTE_H - 2)
    fill:SetBackColor(Options.Defaults.window.bg_sunken)
    fill:SetMouseVisible(false)

    local label = Turbine.UI.Label()
    label:SetParent(fill)
    label:SetSize(PASTE_W - 2, PASTE_H - 2)
    label:SetFont(Turbine.UI.Lotro.Font.Verdana10)
    label:SetForeColor(Options.Defaults.window.text_muted)
    label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    label:SetMouseVisible(false)

    local entry = { btn = btn, row = row, attr = attr, types = types, set = set_fn,
                    fill = fill, label = label }

    function entry:SetArmed(armed)
        if armed then
            btn:SetBackColor(Options.Defaults.window.accent)
            fill:SetBackColor(Options.Defaults.window.accent)
            label:SetForeColor(Options.Defaults.window.bg)
        else
            btn:SetBackColor(Options.Defaults.window.paste_border)
            fill:SetBackColor(Options.Defaults.window.bg_sunken)
            label:SetForeColor(Options.Defaults.window.text_muted)
        end
    end

    function entry:LanguageChanged()
        label:SetText("<- " .. UTILS.GetText("options2", "paste"))
    end
    entry:LanguageChanged()

    btn.MouseClick = function()
        Options2.ArmField({
            attr  = attr,
            types = types,
            label = UTILS.GetText(row.label_control, row.label_description),
            set   = set_fn,
        })
        Options2.FillArmedField(Options2.clipboard.item, Options2.clipboard.itemType)
    end

    return entry
end

-- Paste buttons stay visible so a field can be armed with an empty clipboard.
local function refresh_paste(plist)
    local armed = Options2.armedField
    for _, p in ipairs(plist) do
        p.btn:SetVisible(true)
        p:SetArmed(armed ~= nil and armed.set == p.set)
    end
end

local function size_paste(rows, plist, w)
    local marked = {}
    for _, p in ipairs(plist) do marked[p.row] = p end
    for _, r in ipairs(rows) do
        if marked[r] then
            r:SetWidth(w - LEFT - LEFT - PASTE_W - 6)
        else
            r:SetWidth(w - LEFT - LEFT)
        end
    end
    for _, p in ipairs(plist) do
        local ry = p.row:GetTop()
        local rh = p.row:GetHeight()
        p.btn:SetPosition(w - LEFT - PASTE_W, ry + math.floor((rh - PASTE_H) / 2))
    end
end

-- ── General tab (non-COUNTER_BAR) ─────────────────────────────────────────────

local function make_general_tab(data, bc, windowIndex, timerIndex)
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
    local timerValue = Options2.Elements.TextBoxRow(bc, "options", "timerValue", "tim_timer_value", ROW_H, false)
    timerValue:SetMarkupEnabled(true)
    add(timerValue)
    plist[#plist+1] = paste_btn(panel, timerValue, "timer", {1,2},
        function(v) timerValue:SetText(tostring(v)) end)

    -- drawn rather than a Lotro.Button so it carries the panel theme
    local testBtn = Turbine.UI.Control()
    testBtn:SetParent(panel)
    testBtn:SetSize(120, 22)
    testBtn:SetBackColor(Options.Defaults.window.line)
    testBtn:SetMouseVisible(true)

    local test_fill = Turbine.UI.Control()
    test_fill:SetParent(testBtn)
    test_fill:SetPosition(1, 1)
    test_fill:SetSize(118, 20)
    test_fill:SetBackColor(Options.Defaults.window.bg_sunken)
    test_fill:SetMouseVisible(false)

    local test_label = Turbine.UI.Label()
    test_label:SetParent(test_fill)
    test_label:SetSize(118, 20)
    test_label:SetFont(Turbine.UI.Lotro.Font.Verdana12)
    test_label:SetForeColor(Options.Defaults.window.text_muted)
    test_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    test_label:SetMouseVisible(false)
    testBtn._label = test_label
    testBtn.LanguageChanged = function()
        test_label:SetText(UTILS.GetText("options2", "test_timer"))
    end
    testBtn.LanguageChanged()

    local test_enabled = (Windows[windowIndex] ~= nil)
    if not test_enabled then
        test_label:SetForeColor(Options.Defaults.window.text_faint)
    end
    testBtn.MouseEnter = function()
        if test_enabled then test_fill:SetBackColor(Options.Defaults.window.select) end
    end
    testBtn.MouseLeave = function()
        test_fill:SetBackColor(Options.Defaults.window.bg_sunken)
    end
    do
        local y_btn = TOP
        for _, r in ipairs(rows) do
            y_btn = y_btn + r:GetHeight() + 2
        end
        testBtn:SetPosition(LEFT, y_btn)
    end
    testBtn.MouseClick = function()
        if not test_enabled then return end
        if Windows[windowIndex] == nil then return end
        local fakeTriggerData = {}
        fakeTriggerData.action = Action.Add
        local startTime = Turbine.Engine.GetGameTime()
        local duration = 10
        if data.useCustomTimer == true then
            duration = tonumber(data.timerValue) or 10
        end
        local icon = data.icon
        local text = ""
        if data.textOption == TimerTextOptions.Target then
            text = LocalPlayer:GetName()
        elseif data.textOption == TimerTextOptions.Token then
            text = "token"
        elseif data.textOption == TimerTextOptions.CustomText then
            text = data.textValue
        end
        local entity = nil
        local key = nil
        if data.permanent == false and data.stacking == Stacking.Multi then
            key = startTime
        end
        Windows[windowIndex]:TimerAction(fakeTriggerData, data, timerIndex, startTime, duration, icon, text, entity, key)
    end

    local function load()
        desc:SetText(data.description or "")
        enabled:SetChecked(data.enabled == true)
        permanent:SetChecked(data.permanent == true)
        stacking:SetSelection(data.stacking)
        loop:SetChecked(data.loop == true)
        reset:SetChecked(data.reset == true)
        protect:SetChecked(data.protect == true)
        useCustomTimer:SetChecked(data.useCustomTimer == true)
        timerValue:SetText(tostring(data.timerValue ~= nil and data.timerValue or 10))
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
        local tv = timerValue:GetText()
        data.timerValue     = (tv ~= "") and tv or 10
    end

    load()
    return panel, load, save,
        function() lang_rows(rows) testBtn.LanguageChanged() end,
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
    local useExternalImage = Options2.Elements.CheckBoxRow(bc, "options", "useExternalImage", "tim_use_external_image", ROW_H)
    useExternalImage:SetCallback(function(checked) icon:SetExternalMode(checked) end)
    add(useExternalImage)
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
        icon:SetExternalMode(data.useExternalImage == true)
        icon:SetText(data.icon ~= nil and tostring(data.icon) or "")
        useExternalImage:SetChecked(data.useExternalImage == true)
        showIcon:SetChecked(data.showIcon == true)
        textOption:SetSelection(data.textOption)
        textValue:SetText(data.textValue or "")
        direction:SetSelection(data.direction)
    end
    local function save()
        data.icon             = icon:GetText()
        data.useExternalImage = useExternalImage:IsChecked()
        data.showIcon         = showIcon:IsChecked()
        data.textOption       = textOption:GetSelectedValue()
        data.textValue        = textValue:GetText()
        data.direction        = direction:GetSelectedValue()
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
    local bc         = Options.Defaults.window.row_odd
    local is_counter = (data.type == Timer.Types.COUNTER_BAR)

    self.tabs = Options2.Elements.TabWindow(TAB_W)
    self.tabs:SetParent(self)
    self.tabs:SetPosition(0, 0)

    local gp, gl, gs, glc, gsc, gpl
    if is_counter then
        gp, gl, gs, glc, gsc = make_counter_tab(data, bc)
        gpl = {}
    else
        gp, gl, gs, glc, gsc, gpl = make_general_tab(data, bc, nodeData.windowIndex, nodeData.timerIndex)
    end
    local sp, sl, ss, slc, ssc, spl = make_style_tab(data, bc)
    local ap, al, as, alc, asc      = make_animation_tab(data, bc)

    self.tabs:AddTab(gp, "tab", "general")
    self.tabs:AddTab(sp, "tab", "style")
    self.tabs:AddTab(ap, "tab", "animation")
    self.tabs:SetAccentColor(Options.Defaults.window.color_timer)

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

function Options2.Window.TimerEditor:ArmedFieldChanged()
    refresh_paste(self._paste_list)
end
