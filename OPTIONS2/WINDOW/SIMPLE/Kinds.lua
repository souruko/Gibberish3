-- What simple mode can and cannot represent.
--
-- Nothing is stored on the timer. An isSimple flag would go stale the moment
-- someone edited that timer in advanced mode, so simple-ness is derived from
-- the timer's structure every time a list is drawn.
--
-- Visual settings are deliberately not part of the test: a timer whose colours,
-- font or size were hand-tuned in advanced mode is still simple. Only structure
-- counts.

Options2.Simple = {}

-- The five trigger types the simple editor knows, in the order the "Tracks"
-- dropdown lists them. Assigned rather than written as a literal, because a nil
-- key would throw and these names only exist once TRIGGER/ has been imported.
Options2.Simple.KINDS   = {}
Options2.Simple.IS_KIND = {}

for _, name in ipairs({ "Skill", "EffectSelf", "EffectGroup", "EffectTarget", "Chat" }) do
    local tt = Trigger.Types[name]
    if tt ~= nil then
        Options2.Simple.KINDS[#Options2.Simple.KINDS + 1] = tt
        Options2.Simple.IS_KIND[tt] = true
    end
end

-- Inspect a timer and report whether the simple panel can edit it, along with
-- every structural reason it cannot. Returns a table:
--
--   simple         true when the simple editor can show the whole timer
--   trigger        the timer's single trigger, when it has exactly one
--   triggerType    that trigger's Trigger.Types value
--   triggerCount   triggers across every type
--   conditionCount entries in conditionList
--   reasons        ordered list of { key, count }, empty when simple
--
-- reason keys: "triggers" (not exactly one), "kind" (a type simple mode does
-- not edit), "action" (something other than a plain start), "conditions".
function Options2.Simple.Inspect(timerData)
    local info = {
        simple         = false,
        trigger        = nil,
        triggerType    = nil,
        triggerCount   = 0,
        conditionCount = #(timerData.conditionList or {}),
        reasons        = {},
    }

    for _, tt in ipairs(Options2.TriggerTypes()) do
        for _, td in ipairs(timerData[tt] or {}) do
            info.triggerCount = info.triggerCount + 1
            if info.trigger == nil then
                info.trigger     = td
                info.triggerType = tt
            end
        end
    end

    local function reason(key, count)
        info.reasons[#info.reasons + 1] = { key = key, count = count }
    end

    if info.triggerCount ~= 1 then
        reason("triggers", info.triggerCount)
    elseif not Options2.Simple.IS_KIND[info.triggerType] then
        reason("kind", 1)
    elseif info.trigger.action ~= Action.Add then
        -- the simple editor only ever writes a trigger that starts the timer;
        -- Remove, Enable, Disable and Subtract cannot be shown or round-tripped
        reason("action", 1)
    end

    if info.conditionCount > 0 then
        reason("conditions", info.conditionCount)
    end

    info.simple = (#info.reasons == 0)
    return info
end

-- The paste popover, built on first use. One instance serves every field: only
-- one can be open at a time, and it is an unparented window that outlives any
-- particular editor.
local _popover = nil

function Options2.Simple.Popover()
    if _popover == nil then
        _popover = Options2.Window.SimplePaste()
    end
    return _popover
end

-- a collection changed under an open popover
function Options2.Simple.CollectionChanged()
    if _popover ~= nil then _popover:CollectionChanged() end
end

-- ── collections ─────────────────────────────────────────────────────────────

-- The skills list: whatever was pinned, plus every trained skill the game
-- knows. Shared with the library column so the two never drift apart.
function Options2.Simple.SkillList()
    local list = {}
    for _, v in ipairs(Data.persistent_collection.skill) do
        list[#list + 1] = v
    end

    local skills = LocalPlayer:GetTrainedSkills()
    for i = 1, skills:GetCount() do
        local sk   = skills:GetItem(i)
        local info = sk:GetSkillInfo()
        local d    = {
            token      = info:GetName(),
            icon       = info:GetIconImageID(),
            timer      = sk:GetCooldown(),
            source     = nil,
            persistent = false,
        }
        if d.timer ~= nil and d.timer > 999999 then d.timer = nil end
        if Options.CheckForIndexInCollection(d, 1) == nil then
            list[#list + 1] = d
        end
    end

    return list
end

-- Which library collection a kind draws from, and whether it is one the game
-- fills by itself. Skills are never recorded — the game already supplies them.
--   1 skills   2 effects   3 chat
function Options2.Simple.CollectionFor(kind)
    if kind == Trigger.Types.Skill then
        return 1, Options2.Simple.SkillList(), false
    end
    if kind == Trigger.Types.Chat then
        return 3, Options.Collection.Chat, true
    end
    return 2, Options.Collection.Effects, true
end

-- reverse lookup so a chat entry's source can be named
local CHANNEL_NAME = {}
for name, value in pairs(ChatChannel) do
    CHANNEL_NAME[value] = name
end

-- the grey line under an item's token: cooldown, scope, or channel
function Options2.Simple.SubLine(item, typeIdx)
    if typeIdx == 2 then
        return item.originType or ""
    end
    if typeIdx == 3 then
        local name = CHANNEL_NAME[item.source]
        return name and UTILS.GetText("source", name) or ""
    end
    if item.timer ~= nil then
        return string.format(UTILS.GetText("options2", "meta_seconds"), item.timer)
    end
    return ""
end

-- ── option segments ─────────────────────────────────────────────────────────
--
-- A butted row of choices, used by both simple editors. Each segment paints its
-- own 1px border and they overlap by a pixel, so neighbours share one edge
-- rather than drawing two.
local SEG_H   = 22
local SEG_PAD = 8

Options2.Simple.SEG_H = SEG_H

function Options2.Simple.MakeSegments(parent, count, pick_fn)
    local strip = { segments = {}, selected = 1 }

    for i = 1, count do
        local seg = Turbine.UI.Control()
        seg:SetParent(parent)
        seg:SetHeight(SEG_H)
        seg:SetMouseVisible(true)

        local fill = Turbine.UI.Control()
        fill:SetParent(seg)
        fill:SetPosition(1, 1)
        fill:SetMouseVisible(false)

        local label = Turbine.UI.Label()
        label:SetParent(fill)
        label:SetFont(Turbine.UI.Lotro.Font.Verdana10)
        label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
        label:SetMouseVisible(false)

        seg._index   = i
        seg._active  = false
        seg._hovered = false

        function seg:ApplyState()
            if self._active then
                self:SetBackColor(Options.Defaults.window.accent)
                fill:SetBackColor(Options.Defaults.window.select)
                label:SetForeColor(Options.Defaults.window.text)
            elseif self._hovered then
                self:SetBackColor(Options.Defaults.window.line)
                fill:SetBackColor(Options.Defaults.window.select)
                label:SetForeColor(Options.Defaults.window.text)
            else
                self:SetBackColor(Options.Defaults.window.line)
                fill:SetBackColor(Options.Defaults.window.bg_sunken)
                label:SetForeColor(Options.Defaults.window.text_muted)
            end
        end

        function seg:SetLabel(text)
            label:SetText(text)
            local w = 2 * SEG_PAD + string.len(text) * 6
            self:SetWidth(w)
            fill:SetSize(w - 2, SEG_H - 2)
            label:SetSize(w - 2, SEG_H - 2)
        end

        seg.MouseEnter = function() seg._hovered = true  seg:ApplyState() end
        seg.MouseLeave = function() seg._hovered = false seg:ApplyState() end
        seg.MouseClick = function()
            strip:SetSelected(seg._index)
            if pick_fn ~= nil then pick_fn(seg._index) end
        end

        seg:ApplyState()
        strip.segments[i] = seg
    end

    -- labels can be fewer than the segments built; the rest are hidden
    function strip:SetLabels(texts)
        self.count = #texts
        for i, seg in ipairs(self.segments) do
            if texts[i] ~= nil then
                seg:SetLabel(texts[i])
                seg:SetVisible(true)
            else
                seg:SetVisible(false)
            end
        end
    end

    function strip:SetSelected(index)
        self.selected = index
        for i, seg in ipairs(self.segments) do
            seg._active = (i == index)
            seg:ApplyState()
        end
    end

    function strip:GetSelected() return self.selected end

    function strip:SetVisible(v)
        for i, seg in ipairs(self.segments) do
            seg:SetVisible(v and (self.count == nil or i <= self.count))
        end
    end

    -- returns the width the whole strip occupies
    function strip:Layout(left, top)
        local x = left
        for i, seg in ipairs(self.segments) do
            if self.count == nil or i <= self.count then
                seg:SetPosition(x, top)
                x = x + seg:GetWidth() - 1   -- overlap so borders merge
            end
        end
        return x + 1 - left
    end

    return strip
end

-- The ADV tag: a bordered 9px label standing in for the enable box on a timer
-- the simple panel will not edit, and repeated in the read-only card's header.
--
-- Built like RowParts.MakeEnableBox — an outer control painting the 1px border
-- with an inset child carrying no fill, so whatever is behind shows through and
-- the tag stays readable over a hovered or selected row.
function Options2.Simple.MakeAdvTag(parent, row_h)
    local W, H = 26, 14

    local tag = Turbine.UI.Control()
    tag:SetParent(parent)
    tag:SetSize(W, H)
    tag:SetTop(math.floor(((row_h or H) - H) / 2))
    tag:SetBackColor(Options.Defaults.window.off_border)
    tag:SetMouseVisible(false)

    local inner = Turbine.UI.Control()
    inner:SetParent(tag)
    inner:SetPosition(1, 1)
    inner:SetSize(W - 2, H - 2)
    inner:SetMouseVisible(false)

    local label = Turbine.UI.Label()
    label:SetParent(tag)
    label:SetSize(W, H)
    label:SetFont(Turbine.UI.Lotro.Font.Verdana10)
    label:SetForeColor(Options.Defaults.window.text_muted)
    label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    label:SetText(UTILS.GetText("options2", "simple_adv_tag"))
    label:SetMouseVisible(false)

    tag._label = label
    function tag:LanguageChanged()
        self._label:SetText(UTILS.GetText("options2", "simple_adv_tag"))
    end

    return tag
end
