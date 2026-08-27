-- Simple mode, column C: the fields for one timer.
--
-- Every row is built once and shown or hidden per kind, so switching Tracks
-- does not rebuild the panel. Row fills alternate over the *visible* rows, so
-- the stripes stay even whatever is on show.
--
-- Only per-timer settings live here. Anything visual -- the display type, the
-- size, the colours, the duration readout -- belongs to the window, because a
-- window holds timers of one display type (see STRUCTS/Window.lua). Those are
-- edited in SIMPLE/WindowEditor.lua, reached by clicking the timers column's
-- header.

local ROW_H    = Options2.Elements.EditorRow.ROW_H
local ICON_H   = 40   -- the icon row, sized around the 32px game icon
local PAD      = 10
local GAP      = 8
local SEG_H    = Options2.Simple.SEG_H
local HINT_GAP = 8
local PASTE_W  = 52
local PASTE_H  = 22
local ICON_W   = 130  -- an icon id is a fixed-length number, so the field is
                      -- narrow and the rest of the row explains what empty does

-- the metrics that hold text follow the panel's font size; see OPTIONS2/Fonts.lua
Options2.Fonts.Register(function()
    local F = Options2.Fonts
    -- the shared editor row height, so every editor stays in step
    ROW_H   = Options2.Elements.EditorRow.ROW_H
    -- Kinds.lua rescales the shared segment height; re-read it rather than
    -- holding the value this file loaded with
    SEG_H   = Options2.Simple.SEG_H
    PASTE_W = F.Px(52)
    PASTE_H = F.Px(22)
    ICON_W  = F.Px(130)
end)

-- ── kind tables ─────────────────────────────────────────────────────────────

-- localisation suffix per trigger type, for the Tracks dropdown and the header
local KIND_KEY = {}
local TOKEN_KEY = {}
do
    local names = { "Skill", "EffectSelf", "EffectGroup", "EffectTarget", "Chat" }
    local keys  = { "skill", "self",       "group",       "target",       "chat" }
    -- the token field is labelled for what it holds, which differs by kind
    local toks  = { "skill", "effect",     "effect",      "effect",       "message" }
    for i, name in ipairs(names) do
        local tt = Trigger.Types[name]
        if tt ~= nil then
            KIND_KEY[tt]  = keys[i]
            TOKEN_KEY[tt] = toks[i]
        end
    end
end

Options2.Simple.KIND_KEY = KIND_KEY

-- ── token helpers ───────────────────────────────────────────────────────────

-- A stacking effect's tier is captured out of the effect name by an &N group in
-- the token, which only works as a pattern. Choosing a stacking option has to
-- put one there, or there is nothing for the timer to print.
local function ensure_capture(trigData)
    local token = trigData.token or ""
    if not string.find(token, "&%d") then
        trigData.token = (token ~= "" and (token .. " &1") or "&1")
    end
    trigData.useRegex     = true
    Trigger.ClearPattern(trigData)
end

-- the literal part of a token, with the capture group taken back out
local function strip_capture(token)
    local text = string.gsub(token or "", "&%d", "")
    return (string.gsub(text, "^%s*(.-)%s*$", "%1"))
end

-- ── editor ──────────────────────────────────────────────────────────────────

Options2.Window.SimpleEditor = class(Turbine.UI.Control)

function Options2.Window.SimpleEditor:Constructor(owner)
    Turbine.UI.Control.Constructor(self)

    local M = Options2.Elements.EditorRow

    self.owner    = owner
    self.nodeData = nil
    self.rows     = {}

    -- one row shell: the 104px right-aligned label plus whatever control sits
    -- to its right. Fills are assigned at layout time, over visible rows only.
    local function add_row(key, height)
        local row = Turbine.UI.Control()
        row:SetParent(self)
        row:SetHeight(height or ROW_H)
        row:SetMouseVisible(false)
        row.label = M.MakeLabel(row, nil)
        row.label:SetHeight(height or ROW_H)
        row.key = key
        row.h   = height or ROW_H
        self.rows[#self.rows + 1] = row
        return row
    end

    local function add_hint(row)
        local hint = Turbine.UI.Label()
        hint:SetParent(row)
        hint:SetHeight(ROW_H)
        hint:SetFont(Options2.Fonts.SMALL)
        hint:SetForeColor(Options.Defaults.window.text_faint)
        hint:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
        hint:SetMouseVisible(false)
        return hint
    end

    -- Tracks
    self.row_tracks = add_row("tracks")
    self.dd_tracks  = Options2.Elements.Dropdown(M.DROP_W)
    self.dd_tracks:SetParent(self.row_tracks)
    self.dd_tracks:SetHeight(M.CTRL_H)
    self.dd_tracks.SelectionChanged = function() self:_KindChanged() end
    self.hint_tracks = add_hint(self.row_tracks)

    -- Name
    self.row_name   = add_row("name")
    self.field_name = M.MakeField(self.row_name, false)

    -- token: label and contents follow the kind
    self.row_token   = add_row("token")
    self.field_token = M.MakeField(self.row_token, false)
    self.btn_paste   = self:_MakePasteButton(self.row_token)

    -- Runs for (chat only)
    self.row_runs   = add_row("runs")
    self.field_runs = M.MakeField(self.row_runs, false)
    self.hint_runs  = add_hint(self.row_runs)

    -- Timer text (self effect only)
    self.row_text = add_row("text")
    self.seg_text = Options2.Simple.MakeSegments(self.row_text, 4)

    -- Icon: the same setting as Style > Icon in the advanced editor. Left empty
    -- the timer falls back to the icon of whatever effect or skill triggered
    -- it, which is what most timers want.
    self.row_icon    = add_row("icon", ICON_H)
    self.icon_view   = Turbine.UI.Control()
    self.icon_view:SetParent(self.row_icon)
    self.icon_view:SetSize(Options2.Elements.RowParts.ICON_NATIVE,
                           Options2.Elements.RowParts.ICON_NATIVE)
    self.icon_view:SetMouseVisible(false)

    self.field_icon = M.MakeField(self.row_icon, false)
    self.field_icon.box.TextChanged = function() self:_RefreshIconPreview() end
    self.btn_icon  = self:_MakePasteButton(self.row_icon,
        function() self:_ToggleIconPaste() end)
    self.hint_icon = add_hint(self.row_icon)
    self.hint_icon:SetHeight(ICON_H)

    -- an external image is a path rather than an id; simple mode has no switch
    -- for it, but it must not be thrown away when such a timer is saved here
    self._iconExternal = false

    self:_FillKinds()
    self:_RefreshTexts()
end

-- ── paste ───────────────────────────────────────────────────────────────────

-- The paste button: a sunken pill with a green border, as in the advanced
-- editor. While the popover is open it fills with the selection colour and the
-- field's own border turns accent, so the pair reads as one open control.
function Options2.Window.SimpleEditor:_MakePasteButton(row, click_fn)
    local btn = Turbine.UI.Control()
    btn:SetParent(row)
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
    label:SetFont(Options2.Fonts.SMALL)
    label:SetForeColor(Options.Defaults.window.paste_border)
    label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    label:SetMouseVisible(false)

    btn._fill  = fill
    btn._label = label

    function btn:SetOpen(open)
        fill:SetBackColor(open and Options.Defaults.window.select
                               or  Options.Defaults.window.bg_sunken)
    end

    function btn:LanguageChanged()
        label:SetText(UTILS.GetText("options2", "paste"))
    end
    btn:LanguageChanged()

    btn.MouseClick = click_fn or function() self:_TogglePaste() end

    return btn
end

-- Two fields share the one popover, so a click has to know whose it is. The
-- popover closes on Deactivated, which the click on the other button triggers
-- first: without the owner test that close would swallow the click, and the
-- other field's picker would need a second one to open.
function Options2.Window.SimpleEditor:_PasteBlocked(owner)
    local popover = Options2.Simple.Popover()
    if popover == nil then return true end

    if popover:IsVisible() then
        popover:Close()
        if self._pasteOwner == owner then return true end
    elseif popover:JustClosed() and self._pasteOwner == owner then
        return true
    end

    self._pasteOwner = owner
    return false
end

function Options2.Window.SimpleEditor:_TogglePaste()
    local popover = Options2.Simple.Popover()
    if popover == nil then return end
    if self:_PasteBlocked("token") then return end

    local kind = self.dd_tracks:GetSelectedValue()
    if kind == nil then return end

    self:_SetPasteOpen(true)
    popover:Open(self.field_token, kind,
        UTILS.GetText("options2", "field_token_" .. (TOKEN_KEY[kind] or "effect")),
        self.field_token.box:GetText(),
        function(data) self.field_token.box:SetText(data.token or "") end,
        function() self:_SetPasteOpen(false) end)
end

function Options2.Window.SimpleEditor:_SetPasteOpen(open)
    self.btn_paste:SetOpen(open)
    self.field_token:SetBackColor(open and Options.Defaults.window.accent
                                       or  Options.Defaults.window.line)
end

-- The icon picker: the same popover on the same collection, but what it writes
-- is the picked entry's icon rather than its token. The kind decides the
-- collection, so a skill timer lists skill icons and an effect timer effect
-- icons; the entry for the effect already being tracked is highlighted.
function Options2.Window.SimpleEditor:_ToggleIconPaste()
    local popover = Options2.Simple.Popover()
    if popover == nil then return end
    if self:_PasteBlocked("icon") then return end

    local kind = self.dd_tracks:GetSelectedValue()
    if kind == nil then return end

    -- Chat lines carry no icon of their own, so that kind picks from the
    -- effects instead -- the same two collections the advanced icon field
    -- offers, narrowed to the one this timer is most likely to want.
    if kind == Trigger.Types.Chat then kind = Trigger.Types.EffectSelf end

    self:_SetIconPasteOpen(true)
    popover:Open(self.field_icon, kind,
        UTILS.GetText("options2", "field_icon"),
        self.field_token.box:GetText(),
        function(data)
            self.field_icon.box:SetText(data.icon ~= nil and tostring(data.icon) or "")
            -- a picked entry is always a game icon id, never a file of ours
            self._iconExternal = false
            self:_RefreshIconPreview()
        end,
        function() self:_SetIconPasteOpen(false) end)
end

function Options2.Window.SimpleEditor:_SetIconPasteOpen(open)
    self.btn_icon:SetOpen(open)
    self.field_icon:SetBackColor(open and Options.Defaults.window.accent
                                      or  Options.Defaults.window.line)
end

-- Empty means "whatever triggered this timer", which cannot be previewed here,
-- so the swatch is simply left blank.
function Options2.Window.SimpleEditor:_RefreshIconPreview()
    local text = self.field_icon.box:GetText()
    local id   = self._iconExternal and text or tonumber(text)

    if id == nil or id == "" then
        self.icon_view:SetBackground()
        self.icon_view:SetSize(Options2.Elements.RowParts.ICON_NATIVE,
                               Options2.Elements.RowParts.ICON_NATIVE)
        return
    end
    Options2.Elements.RowParts.SetNativeIcon(self.icon_view,
        UTILS.ResolveTimerIcon(id, self._iconExternal))
end

-- closing the panel, or moving off this timer, must not leave it floating
function Options2.Window.SimpleEditor:ClosePaste()
    local popover = Options2.Simple.Popover()
    if popover ~= nil and popover:IsVisible() then popover:Close() end
end

function Options2.Window.SimpleEditor:_FillKinds()
    self.dd_tracks:ClearItems()
    for _, tt in ipairs(Options2.Simple.KINDS) do
        self.dd_tracks:AddItem("options2", "track_" .. KIND_KEY[tt], tt)
    end
end

function Options2.Window.SimpleEditor:_RefreshTexts()
    self.row_tracks.label:SetText(UTILS.GetText("options2", "field_tracks"))
    self.row_name.label:SetText(UTILS.GetText("options2", "field_name"))
    self.row_runs.label:SetText(UTILS.GetText("options2", "field_runs"))
    self.row_text.label:SetText(UTILS.GetText("options2", "field_timer_text"))
    self.row_icon.label:SetText(UTILS.GetText("options2", "field_icon"))

    self.hint_runs:SetText(UTILS.GetText("options2", "field_runs_hint"))
    self.hint_icon:SetText(UTILS.GetText("options2", "field_icon_hint"))

    self.seg_text:SetLabels({
        UTILS.GetText("options2", "text_none"),
        UTILS.GetText("options2", "text_name"),
        UTILS.GetText("options2", "text_stacks"),
        UTILS.GetText("options2", "text_both"),
    })

    self:_RefreshKindTexts()
end

-- the Tracks hint and the token row's label both follow the selected kind
function Options2.Window.SimpleEditor:_RefreshKindTexts()
    local kind = self.dd_tracks:GetSelectedValue()
    local key  = KIND_KEY[kind]
    if key == nil then return end

    self.hint_tracks:SetText(UTILS.GetText("options2", "track_" .. key .. "_hint"))
    self.row_token.label:SetText(
        UTILS.GetText("options2", "field_token_" .. TOKEN_KEY[kind]))
end

function Options2.Window.SimpleEditor:LanguageChanged()
    if self.rows == nil then return end
    self.dd_tracks:LanguageChanged()
    self:_RefreshTexts()
    self:_ApplyLayout()
end

-- ── load ────────────────────────────────────────────────────────────────────

function Options2.Window.SimpleEditor:SetTimer(nodeData)
    self.nodeData = nodeData
    if nodeData == nil then return end
    self:Load()
end

function Options2.Window.SimpleEditor:Load()
    local nd = self.nodeData
    if nd == nil then return end

    local td   = nd.data
    local info = Options2.Simple.Inspect(td)

    self.dd_tracks:SetSelection(info.triggerType or Options2.Simple.KINDS[1])
    self.field_name.box:SetText(td.description or "")
    self.field_token.box:SetText(info.trigger and (info.trigger.token or "") or "")
    self.field_runs.box:SetText(tostring(td.timerValue or 10))
    self.seg_text:SetSelected(self:_TextIndex(td))

    self._iconExternal = (td.useExternalImage == true)
    self.field_icon.box:SetText(td.icon ~= nil and tostring(td.icon) or "")
    self:_RefreshIconPreview()

    self:_ApplyLayout()
end

-- No text / Name / Stacks / Name with stacks, read back off the timer.
--
-- The tier of a stacking effect is a capture out of the effect name, so
-- "Stacks" is custom text holding just that capture, "Name" is custom text
-- holding the literal part, and "Name with stacks" is the game's own effect
-- name, which already carries the number.
function Options2.Window.SimpleEditor:_TextIndex(td)
    if td.textOption == TimerTextOptions.NoText then return 1 end
    if td.textOption == TimerTextOptions.Token  then return 4 end
    if td.textOption == TimerTextOptions.CustomText then
        if string.find(td.textValue or "", "&%d") then return 3 end
        return 2
    end
    return 1
end

-- ── save ────────────────────────────────────────────────────────────────────

function Options2.Window.SimpleEditor:Save()
    local nd = self.nodeData
    if nd == nil then return end

    local td = nd.data
    local wi = nd.windowIndex
    local wd = Data.window[wi]
    if wd == nil then return end

    td.description = self.field_name.box:GetText()

    -- Icon: nil for an empty field, so the timer takes the icon of whatever
    -- triggered it. tonumber does that on its own for a game icon id.
    local icon_text = self.field_icon.box:GetText()
    if self._iconExternal then
        td.icon = (icon_text ~= "") and icon_text or nil
    else
        td.icon = tonumber(icon_text)
    end

    -- Tracks: keep the trigger when the kind is unchanged, otherwise replace
    -- every trigger with one of the new kind. A simple timer holds only what
    -- this editor wrote, so there is nothing else to preserve.
    local kind = self.dd_tracks:GetSelectedValue()
    local info = Options2.Simple.Inspect(td)
    local trg  = info.trigger

    if trg == nil or info.triggerType ~= kind then
        for _, tt in ipairs(Options2.TriggerTypes()) do td[tt] = {} end
        trg = Trigger.New(kind)
        table.insert(td[kind], trg)
    end

    trg.action          = Action.Add
    trg.token           = self.field_token.box:GetText()
    Trigger.ClearPattern(trg)

    -- Chat has no duration of its own, so the timer supplies one
    if kind == Trigger.Types.Chat then
        td.useCustomTimer = true
        td.timerValue     = tonumber(self.field_runs.box:GetText()) or 10
    end

    if kind == Trigger.Types.EffectSelf then
        local choice = self.seg_text:GetSelected()
        if choice == 1 then
            td.textOption = TimerTextOptions.NoText
        elseif choice == 2 then
            td.textOption = TimerTextOptions.CustomText
            td.textValue  = strip_capture(trg.token)
        elseif choice == 3 then
            td.textOption = TimerTextOptions.CustomText
            td.textValue  = "&1"
            ensure_capture(trg)
            td.stacking   = Stacking.Single
        else
            td.textOption = TimerTextOptions.Token
            ensure_capture(trg)
            td.stacking   = Stacking.Single
        end

        -- The other half of the pair: without it the bar would keep running
        -- after the effect is cured or falls off early. Written last, because
        -- the timer-text options above may still have rewritten the token.
        self:_SyncRemoveTrigger(td, trg)
    end


    Options.SaveData()
    Options.DataChanged(wi)
    Windows.EnabledChanged(wi)
end

-- Keep the EffectRemoveSelf half of a self-effect timer on the same effect as
-- the EffectSelf half that starts it. Anything the timer already has is reused
-- rather than replaced, so a trigger the player renamed in advanced mode keeps
-- its description.
function Options2.Window.SimpleEditor:_SyncRemoveTrigger(td, trg)
    local rt  = Trigger.Types.EffectRemoveSelf
    local rem = (td[rt] or {})[1]

    if rem == nil then
        rem   = Trigger.New(rt)
        td[rt] = { rem }
    else
        -- a second one would make the timer advanced-only on the next redraw
        for i = #td[rt], 2, -1 do table.remove(td[rt], i) end
    end

    rem.enabled        = true
    rem.action         = Action.Remove
    rem.token          = trg.token
    rem.useRegex       = trg.useRegex
    Trigger.ClearPattern(rem)
end

-- Changing the kind clears the token: it named something in the old
-- collection, and means nothing in the new one.
function Options2.Window.SimpleEditor:_KindChanged()
    -- the popover is showing the old kind's collection
    self:ClosePaste()
    self.field_token.box:SetText("")
    self:_RefreshKindTexts()
    self:_ApplyLayout()
end

function Options2.Window.SimpleEditor:GetKind()
    return self.dd_tracks:GetSelectedValue()
end

-- ── layout ──────────────────────────────────────────────────────────────────

function Options2.Window.SimpleEditor:SizeChanged()
    if self.rows == nil then return end
    self:_ApplyLayout()
end

-- which rows the selected kind shows
function Options2.Window.SimpleEditor:_VisibleRows()
    local kind = self.dd_tracks:GetSelectedValue()
    local list = { self.row_tracks, self.row_name, self.row_token }
    if kind == Trigger.Types.Chat then
        list[#list + 1] = self.row_runs
    end
    if kind == Trigger.Types.EffectSelf then
        list[#list + 1] = self.row_text
    end
    -- every kind can carry its own icon
    list[#list + 1] = self.row_icon
    return list
end

function Options2.Window.SimpleEditor:_ApplyLayout()
    local M = Options2.Elements.EditorRow
    local w = self:GetWidth()
    if w <= 0 then return end

    local visible = {}
    for _, row in ipairs(self:_VisibleRows()) do visible[row] = true end

    local ctrl_left = M.CTRL_LEFT
    local ctrl_top  = M.CentreTop(ROW_H, M.CTRL_H)
    local y         = 0
    local index     = 0

    for _, row in ipairs(self.rows) do
        if not visible[row] then
            row:SetVisible(false)
        else
            index = index + 1
            row:SetVisible(true)
            row:SetPosition(0, y)
            row:SetWidth(w)
            row:SetBackColor(M.Fill(index))
            y = y + (row.h or ROW_H)
        end
    end

    -- Tracks
    self.dd_tracks:SetPosition(ctrl_left, ctrl_top)
    self.hint_tracks:SetPosition(ctrl_left + M.DROP_W + HINT_GAP, 0)
    self.hint_tracks:SetWidth(math.max(0, w - ctrl_left - M.DROP_W - HINT_GAP - PAD))

    -- Name stretches to the right edge; the token field gives up room for paste
    local field_w = math.max(0, w - ctrl_left - PAD)
    self.field_name:Layout(ctrl_left, ctrl_top, field_w, M.CTRL_H)

    local token_w = math.max(0, field_w - PASTE_W - GAP)
    self.field_token:Layout(ctrl_left, ctrl_top, token_w, M.CTRL_H)
    self.btn_paste:SetPosition(ctrl_left + token_w + GAP,
                               M.CentreTop(ROW_H, PASTE_H))

    -- Runs for: a narrow number box plus its unit
    self.field_runs:Layout(ctrl_left, ctrl_top, M.NUM_W, M.CTRL_H)
    self.hint_runs:SetPosition(ctrl_left + M.NUM_W + HINT_GAP, 0)
    self.hint_runs:SetWidth(math.max(0, w - ctrl_left - M.NUM_W - HINT_GAP - PAD))

    self.seg_text:Layout(ctrl_left, M.CentreTop(ROW_H, SEG_H))

    -- Icon: the preview at its native size, then a short field, its paste
    -- button, and the note about leaving it empty in whatever is left
    local IC        = Options2.Elements.RowParts.ICON_NATIVE
    local icon_left = ctrl_left + IC + GAP
    local icon_w    = math.min(ICON_W, math.max(0, w - icon_left - PASTE_W - GAP - PAD))
    local hint_left = icon_left + icon_w + GAP + PASTE_W + HINT_GAP
    local hint_w    = math.max(0, w - hint_left - PAD)

    self.icon_view:SetPosition(ctrl_left, M.CentreTop(ICON_H, IC))
    self.field_icon:Layout(icon_left, M.CentreTop(ICON_H, M.CTRL_H), icon_w, M.CTRL_H)
    self.btn_icon:SetPosition(icon_left + icon_w + GAP, M.CentreTop(ICON_H, PASTE_H))
    self.hint_icon:SetPosition(hint_left, 0)
    self.hint_icon:SetWidth(hint_w)
    -- half a sentence reads as broken, so a narrow column drops it entirely
    self.hint_icon:SetVisible(hint_w >= 100)

    self._content_h = y
end

function Options2.Window.SimpleEditor:GetContentHeight()
    return self._content_h or 0
end
