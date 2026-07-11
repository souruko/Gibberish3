local ROW_H   = 30
local DESC_H  = 50
local TOKEN_H = 60
local ICON_H  = 40
local LEFT    = 5
local TOP     = 8
local HDR_H   = 26

local BC_ODD  = Turbine.UI.Color(0.18, 0.18, 0.18)
local BC_EVEN = Turbine.UI.Color(0.13, 0.13, 0.13)

-- ── helpers ───────────────────────────────────────────────────────────────────

local function make_rows(parent, y_start)
    local rows  = {}
    local y     = y_start or TOP
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

-- Creates a [<-] button that pastes a clipboard attribute into a row field.
-- Returns a descriptor used by refresh_paste / size_paste.
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

-- Shows/hides paste buttons based on current clipboard content.
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

-- Sizes rows, shrinking those with a paste button to leave room for it.
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

-- Determine which actions belong to a given nodeData context.
local function build_action_dd(bc, nodeData)
    local dd = Options2.Elements.DropDownRow(bc, "options", "action", "trg_action", ROW_H)
    local nt = nodeData.nodeType

    if nt == "foldertrigger" then
        dd:AddItem("action", Action.Enable,  Action.Enable)
        dd:AddItem("action", Action.Disable, Action.Disable)
        dd:AddItem("action", Action.Reset,   Action.Reset)

    elseif nt == "windowtrigger" then
        dd:AddItem("action", Action.Enable,  Action.Enable)
        dd:AddItem("action", Action.Disable, Action.Disable)
        dd:AddItem("action", Action.Clear,   Action.Clear)
        dd:AddItem("action", Action.Reset,   Action.Reset)

    elseif nt == "conditiontrigger" then
        dd:AddItem("action", Action.Add,    Action.Add)
        dd:AddItem("action", Action.Remove, Action.Remove)

    else -- "trigger"
        local is_counter = false
        local wi, ti = nodeData.windowIndex, nodeData.timerIndex
        if wi ~= nil and ti ~= nil then
            local wd = Data.window[wi]
            if wd ~= nil and wd.timerList ~= nil then
                local tmd = wd.timerList[ti]
                if tmd ~= nil then
                    is_counter = (tmd.type == Timer.Types.COUNTER_BAR)
                end
            end
        end
        dd:AddItem("action", Action.Add,    Action.Add)
        if is_counter then
            dd:AddItem("action", Action.Subtract, Action.Subtract)
        end
        dd:AddItem("action", Action.Remove,  Action.Remove)
        dd:AddItem("action", Action.Enable,  Action.Enable)
        dd:AddItem("action", Action.Disable, Action.Disable)
    end

    return dd
end

-- Returns true when a value (counter amount) field should be shown.
local function needs_value(nodeData)
    if nodeData.nodeType ~= "trigger" then return false end
    local wi, ti = nodeData.windowIndex, nodeData.timerIndex
    if wi == nil or ti == nil then return false end
    local wd = Data.window[wi]
    if wd == nil or wd.timerList == nil then return false end
    local tmd = wd.timerList[ti]
    return tmd ~= nil and tmd.type == Timer.Types.COUNTER_BAR
end

-- ── Effect trigger form (Self / Group / Target / RemoveSelf) ──────────────────

local function make_effect_form(data, bc, nodeData, trigType)
    local panel = Turbine.UI.Control()
    local add, rows = make_rows(panel, 0)
    local has_exclude = (trigType == Trigger.Types.EffectGroup)
    local has_value   = needs_value(nodeData)
    local plist = {}

    local desc = Options2.Elements.TextBoxRow(bc, "options", "description", "trg_description", DESC_H, true)
    add(desc, DESC_H)
    local token = Options2.Elements.TextBoxRow(bc, "options", "token", "trg_token", TOKEN_H, true)
    add(token, TOKEN_H)
    plist[#plist+1] = paste_btn(panel, token, "token", {1,2,3},
        function(v) token:SetText(tostring(v)) end)
    local useRegex = Options2.Elements.CheckBoxRow(bc, "options", "useRegex", "trg_use_regex", ROW_H)
    add(useRegex)
    local icon = Options2.Elements.IconBoxRow(bc, "options", "icon", "trg_icon", ICON_H)
    add(icon, ICON_H)
    plist[#plist+1] = paste_btn(panel, icon, "icon", {1,2},
        function(v) icon:SetText(tostring(v)) end)

    local isDebuff = Options2.Elements.DropDownRow(bc, "options", "isDebuff", "trg_is_debuff", ROW_H)
    isDebuff:AddItem("source", "Any",    Source.Any)
    isDebuff:AddItem("source", "Buff",   Source.Buff)
    isDebuff:AddItem("source", "Debuff", Source.Debuff)
    add(isDebuff)

    local isDispellable = Options2.Elements.DropDownRow(bc, "options", "isDispellable", "trg_is_dispellable", ROW_H)
    isDispellable:AddItem("source", "Any",            Source.Any)
    isDispellable:AddItem("source", "IsDispellable",  Source.Dispellable)
    isDispellable:AddItem("source", "NotDispellable", Source.NotDispellable)
    add(isDispellable)

    local category = Options2.Elements.DropDownRow(bc, "options", "category", "trg_category", ROW_H)
    category:AddItem("source", "Any", Source.Any)
    for name, value in pairs(EffectCategory) do category:AddItem("source", name, value) end
    category:SortAlpha()
    add(category)

    local excludeSelf
    if has_exclude then
        excludeSelf = Options2.Elements.CheckBoxRow(bc, "options", "excludeSelf", "trg_exclude_self", ROW_H)
        add(excludeSelf)
    end

    local action = build_action_dd(bc, nodeData)
    add(action)

    local valueRow
    if has_value then
        valueRow = Options2.Elements.NumberBoxRow(bc, "options", "value", "trg_value", ROW_H)
        add(valueRow)
    end

    local function load()
        desc:SetText(data.description or "")
        token:SetText(data.token or "")
        useRegex:SetChecked(data.useRegex == true)
        icon:SetText(data.icon ~= nil and tostring(data.icon) or "")
        isDebuff:SetSelection(data.isDebuff or Source.Any)
        isDispellable:SetSelection(data.isDispellable or Source.Any)
        category:SetSelection(data.category or Source.Any)
        if excludeSelf ~= nil then excludeSelf:SetChecked(data.excludeSelf == true) end
        action:SetSelection(data.action)
        if valueRow ~= nil then valueRow:SetText(tostring(data.value or 0)) end
    end
    local function save()
        data.description   = desc:GetText()
        data.token         = token:GetText()
        data.useRegex      = useRegex:IsChecked()
        data.icon          = icon:GetText()
        data.isDebuff      = isDebuff:GetSelectedValue()
        data.isDispellable = isDispellable:GetSelectedValue()
        data.category      = category:GetSelectedValue()
        if excludeSelf ~= nil then data.excludeSelf = excludeSelf:IsChecked() end
        data.action        = action:GetSelectedValue()
        if valueRow ~= nil then data.value = valueRow:GetText() or 0 end
    end

    load()
    return panel, load, save,
        function() lang_rows(rows) end,
        function(w) size_paste(rows, plist, w) end,
        plist
end

-- ── Chat trigger form ─────────────────────────────────────────────────────────

local function make_chat_form(data, bc, nodeData)
    local panel = Turbine.UI.Control()
    local add, rows = make_rows(panel, 0)
    local has_value = needs_value(nodeData)
    local plist = {}

    local desc = Options2.Elements.TextBoxRow(bc, "options", "description", "trg_description", DESC_H, true)
    add(desc, DESC_H)
    local token = Options2.Elements.TextBoxRow(bc, "options", "token", "trg_token", TOKEN_H, true)
    add(token, TOKEN_H)
    plist[#plist+1] = paste_btn(panel, token, "token", {1,2,3},
        function(v) token:SetText(tostring(v)) end)
    local useRegex = Options2.Elements.CheckBoxRow(bc, "options", "useRegex", "trg_use_regex", ROW_H)
    add(useRegex)

    local source = Options2.Elements.DropDownRow(bc, "options", "source_chat", "trg_source_chat", ROW_H)
    source:AddItem("source", "Any", Source.Any)
    for name, value in pairs(ChatChannel) do source:AddItem("source", name, value) end
    source:Sort()
    add(source)
    plist[#plist+1] = paste_btn(panel, source, "source", {3},
        function(v) source:SetSelection(v) end)

    local listOfTargets = Options2.Elements.TextBoxRow(bc, "options", "listOfTargets", "trg_list_of_targets", DESC_H, true)
    add(listOfTargets, DESC_H)

    local action = build_action_dd(bc, nodeData)
    add(action)

    local valueRow
    if has_value then
        valueRow = Options2.Elements.NumberBoxRow(bc, "options", "value", "trg_value", ROW_H)
        add(valueRow)
    end

    local function load()
        desc:SetText(data.description or "")
        token:SetText(data.token or "")
        useRegex:SetChecked(data.useRegex == true)
        source:SetSelection(data.source or Source.Any)
        listOfTargets:SetText(UTILS.ListOfTargetsToString(data.listOfTargets or {}))
        action:SetSelection(data.action)
        if valueRow ~= nil then valueRow:SetText(tostring(data.value or 0)) end
    end
    local function save()
        data.description     = desc:GetText()
        data.token           = token:GetText()
        data._cachedPattern  = nil
        data.useRegex        = useRegex:IsChecked()
        data.source          = source:GetSelectedValue()
        data.listOfTargets   = UTILS.StringOfTargetsToList(listOfTargets:GetText())
        data.action          = action:GetSelectedValue()
        if valueRow ~= nil then data.value = valueRow:GetText() or 0 end
    end

    load()
    return panel, load, save,
        function() lang_rows(rows) end,
        function(w) size_paste(rows, plist, w) end,
        plist
end

-- ── Skill trigger form ────────────────────────────────────────────────────────

local function make_skill_form(data, bc, nodeData)
    local panel = Turbine.UI.Control()
    local add, rows = make_rows(panel, 0)
    local has_value = needs_value(nodeData)
    local plist = {}

    local desc = Options2.Elements.TextBoxRow(bc, "options", "description", "trg_description", DESC_H, true)
    add(desc, DESC_H)
    local token = Options2.Elements.TextBoxRow(bc, "options", "token", "trg_token", TOKEN_H, true)
    add(token, TOKEN_H)
    plist[#plist+1] = paste_btn(panel, token, "token", {1,2,3},
        function(v) token:SetText(tostring(v)) end)
    local useRegex = Options2.Elements.CheckBoxRow(bc, "options", "useRegex", "trg_use_regex", ROW_H)
    add(useRegex)

    local action = build_action_dd(bc, nodeData)
    add(action)

    local valueRow
    if has_value then
        valueRow = Options2.Elements.NumberBoxRow(bc, "options", "value", "trg_value", ROW_H)
        add(valueRow)
    end

    local function load()
        desc:SetText(data.description or "")
        token:SetText(data.token or "")
        useRegex:SetChecked(data.useRegex == true)
        action:SetSelection(data.action)
        if valueRow ~= nil then valueRow:SetText(tostring(data.value or 0)) end
    end
    local function save()
        data.description = desc:GetText()
        data.token       = token:GetText()
        data.useRegex    = useRegex:IsChecked()
        data.action      = action:GetSelectedValue()
        if valueRow ~= nil then data.value = valueRow:GetText() or 0 end
    end

    load()
    return panel, load, save,
        function() lang_rows(rows) end,
        function(w) size_paste(rows, plist, w) end,
        plist
end

-- ── TimerStart / TimerEnd / TimerThreshold form ───────────────────────────────

local function make_timer_form(data, bc, nodeData)
    local panel = Turbine.UI.Control()
    local add, rows = make_rows(panel, 0)
    local has_value = needs_value(nodeData)

    local desc = Options2.Elements.TextBoxRow(bc, "options", "description", "trg_description", DESC_H, true)
    add(desc, DESC_H)
    local token = Options2.Elements.TextBoxRow(bc, "options", "token", "trg_token", ROW_H, false)
    add(token)

    local action = build_action_dd(bc, nodeData)
    add(action)

    local valueRow
    if has_value then
        valueRow = Options2.Elements.NumberBoxRow(bc, "options", "value", "trg_value", ROW_H)
        add(valueRow)
    end

    local function load()
        desc:SetText(data.description or "")
        token:SetText(data.token or "")
        action:SetSelection(data.action)
        if valueRow ~= nil then valueRow:SetText(tostring(data.value or 0)) end
    end
    local function save()
        data.description = desc:GetText()
        data.token       = token:GetText()
        data.action      = action:GetSelectedValue()
        if valueRow ~= nil then data.value = valueRow:GetText() or 0 end
    end

    load()
    return panel, load, save,
        function() lang_rows(rows) end,
        function(w) size_rows(rows, w) end,
        {}
end

-- ── Combat trigger form ───────────────────────────────────────────────────────

local function make_combat_form(data, bc, nodeData)
    local panel = Turbine.UI.Control()
    local add, rows = make_rows(panel, 0)
    local has_value = needs_value(nodeData)

    local desc = Options2.Elements.TextBoxRow(bc, "options", "description", "trg_description", DESC_H, true)
    add(desc, DESC_H)

    local source = Options2.Elements.DropDownRow(bc, "options", "source_combat", "trg_source_combat", ROW_H)
    source:AddItem("source", "CombatStart", Source.CombatStart)
    source:AddItem("source", "CombatEnd",   Source.CombatEnd)
    add(source)

    local action = build_action_dd(bc, nodeData)
    add(action)

    local valueRow
    if has_value then
        valueRow = Options2.Elements.NumberBoxRow(bc, "options", "value", "trg_value", ROW_H)
        add(valueRow)
    end

    local function load()
        desc:SetText(data.description or "")
        source:SetSelection(data.source or Source.CombatEnd)
        action:SetSelection(data.action)
        if valueRow ~= nil then valueRow:SetText(tostring(data.value or 0)) end
    end
    local function save()
        data.description = desc:GetText()
        data.source      = source:GetSelectedValue()
        data.action      = action:GetSelectedValue()
        if valueRow ~= nil then data.value = valueRow:GetText() or 0 end
    end

    load()
    return panel, load, save,
        function() lang_rows(rows) end,
        function(w) size_rows(rows, w) end,
        {}
end

-- ── TriggerEditor class ───────────────────────────────────────────────────────

local EFFECT_TYPES = {
    [Trigger.Types.EffectSelf]       = true,
    [Trigger.Types.EffectGroup]      = true,
    [Trigger.Types.EffectTarget]     = true,
    [Trigger.Types.EffectRemoveSelf] = true,
}

local TIMER_TYPES = {
    [Trigger.Types.TimerStart]     = true,
    [Trigger.Types.TimerEnd]       = true,
    [Trigger.Types.TimerThreshold] = true,
}

Options2.Window.TriggerEditor = class(Turbine.UI.Control)
function Options2.Window.TriggerEditor:Constructor(nodeData)
    Turbine.UI.Control.Constructor(self)

    self.nodeData = nodeData
    local data    = nodeData.data
    local bc      = Options.Defaults.window.basecolor
    local tt      = nodeData.triggerType

    -- type header
    local lang_table = L[Language.Local] or L[Language.English]
    local type_name  = (lang_table.triggerType and lang_table.triggerType[tt])
                       or UTILS.GetText("options2", "trigger_type")
    self.type_label = Turbine.UI.Label()
    self.type_label:SetParent(self)
    self.type_label:SetPosition(LEFT + 4, 4)
    self.type_label:SetHeight(HDR_H - 4)
    self.type_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.type_label:SetFont(Options.Defaults.window.font)
    self.type_label:SetForeColor(Options.Defaults.window.color_trigger)
    self.type_label:SetText(type_name)
    self.type_label:SetMouseVisible(false)

    -- form panel below header
    local panel, load_fn, save_fn, lang_fn, size_fn, plist

    if EFFECT_TYPES[tt] then
        panel, load_fn, save_fn, lang_fn, size_fn, plist = make_effect_form(data, bc, nodeData, tt)
    elseif tt == Trigger.Types.Chat then
        panel, load_fn, save_fn, lang_fn, size_fn, plist = make_chat_form(data, bc, nodeData)
    elseif tt == Trigger.Types.Skill then
        panel, load_fn, save_fn, lang_fn, size_fn, plist = make_skill_form(data, bc, nodeData)
    elseif TIMER_TYPES[tt] then
        panel, load_fn, save_fn, lang_fn, size_fn, plist = make_timer_form(data, bc, nodeData)
    elseif tt == Trigger.Types.Combat then
        panel, load_fn, save_fn, lang_fn, size_fn, plist = make_combat_form(data, bc, nodeData)
    else
        panel    = Turbine.UI.Control()
        load_fn  = function() end
        save_fn  = function() end
        lang_fn  = function() end
        size_fn  = function(w) end
        plist    = {}
    end

    self.form_panel = panel
    self.form_panel:SetParent(self)
    self.form_panel:SetPosition(0, HDR_H)

    self._load       = load_fn
    self._save       = save_fn
    self._lang       = lang_fn
    self._size       = size_fn
    self._paste_list = plist

    refresh_paste(self._paste_list)
end

function Options2.Window.TriggerEditor:SizeChanged()
    if self.form_panel == nil then return end
    local w, h = self:GetSize()
    self.type_label:SetWidth(w - LEFT - 5)
    local form_h = h - HDR_H
    self.form_panel:SetSize(w, form_h)
    self._size(w)
end

function Options2.Window.TriggerEditor:Save()
    self._save()
    Options.SaveData()
    local wi = self.nodeData.windowIndex
    if wi ~= nil then
        Options.DataChanged(wi)
        Windows.EnabledChanged(wi)
    end
end

function Options2.Window.TriggerEditor:Reset()
    self._load()
end

function Options2.Window.TriggerEditor:LanguageChanged()
    if self.form_panel == nil then return end
    local lang_table = L[Language.Local] or L[Language.English]
    local tt = self.nodeData.triggerType
    local type_name = (lang_table.triggerType and lang_table.triggerType[tt])
                      or UTILS.GetText("options2", "trigger_type")
    self.type_label:SetText(type_name)
    self._lang()
end

function Options2.Window.TriggerEditor:ClipboardChanged()
    refresh_paste(self._paste_list)
end
