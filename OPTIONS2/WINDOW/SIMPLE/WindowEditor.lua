-- Simple mode, column C: the settings for one window.
--
-- Everything visual belongs here rather than to a timer. A window holds timers
-- of one display type (STRUCTS/Window.lua sets window.timerType and Timer.New
-- only copies it), and the size, colours, font and duration readout are all
-- window fields too. Presenting them per timer would have been a lie the save
-- format could not keep.
--
-- Reached by clicking the timers column's header, the same way the advanced
-- contents column's header doubles as the row for the container itself.
--
-- This is the simple subset. The advanced window editor still has the frame,
-- spacing, opacities, alignments, threshold colours and the rest.

local ROW_H    = Options2.Elements.EditorRow.ROW_H
local PAD      = 10
local GAP      = 8
local HINT_GAP = 8

-- the metrics that hold text follow the panel's font size; see OPTIONS2/Fonts.lua
Options2.Fonts.Register(function()
    local F = Options2.Fonts
    -- ROW_H is the shared editor row height, so every editor stays in step
    ROW_H = Options2.Elements.EditorRow.ROW_H
end)

-- window.timerType values the Look row offers, in display order
local LOOK_TYPES = { Timer.Types.BAR, Timer.Types.ICON, Timer.Types.CIRCEL, Timer.Types.TEXT }

-- the font sizes the simple panel offers; the advanced editor has the full list
local TEXT_SIZES = { 10, 12, 14, 16, 18, 20, 22 }

Options2.Window.SimpleWindowEditor = class(Turbine.UI.Control)

function Options2.Window.SimpleWindowEditor:Constructor(owner)
    Turbine.UI.Control.Constructor(self)

    local M = Options2.Elements.EditorRow

    self.owner    = owner
    self.nodeData = nil
    self.rows     = {}

    local function add_row()
        local row = Turbine.UI.Control()
        row:SetParent(self)
        row:SetHeight(ROW_H)
        row:SetMouseVisible(false)
        row.label = M.MakeLabel(row, nil)
        row.label:SetHeight(ROW_H)
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

    -- a bordered colour swatch beside a hex field, as ColorBoxRow does it
    local function add_color_row()
        local row = add_row()
        row.swatch = Turbine.UI.Control()
        row.swatch:SetParent(row)
        row.swatch:SetSize(M.CTRL_H, M.CTRL_H)
        row.swatch:SetMouseVisible(false)
        row.field = M.MakeField(row, false)
        row.field.box.TextChanged = function()
            row.swatch:SetBackColor(UTILS.ColorFix(UTILS.TextToColor(row.field.box:GetText())))
        end
        return row
    end

    -- Name
    self.row_name   = add_row()
    self.field_name = M.MakeField(self.row_name, false)

    -- Look: the window's display type, which every timer in it takes
    self.row_look = add_row()
    self.seg_look = Options2.Simple.MakeSegments(self.row_look, #LOOK_TYPES)

    -- Size
    self.row_size    = add_row()
    self.field_width = M.MakeField(self.row_size, false)
    self.size_by     = add_hint(self.row_size)
    self.field_height = M.MakeField(self.row_size, false)

    -- Show duration
    self.row_duration = add_row()
    self.seg_duration = Options2.Simple.MakeSegments(self.row_duration, 4)

    -- Text size
    self.row_textsize = add_row()
    self.dd_textsize  = Options2.Elements.Dropdown(M.NUM_W)
    self.dd_textsize:SetParent(self.row_textsize)
    self.dd_textsize:SetHeight(M.CTRL_H)
    for _, size in ipairs(TEXT_SIZES) do
        self.dd_textsize:AddItem(nil, tostring(size), size)
    end

    -- Colours, named for what a player sees rather than by index
    self.row_back  = add_color_row()   -- color2
    self.row_fill  = add_color_row()   -- color3
    self.row_num   = add_color_row()   -- color4
    self.row_text  = add_color_row()   -- color5

    self:_RefreshTexts()
end

-- ── texts ───────────────────────────────────────────────────────────────────

function Options2.Window.SimpleWindowEditor:_RefreshTexts()
    self.row_name.label:SetText(UTILS.GetText("options2", "field_name"))
    self.row_look.label:SetText(UTILS.GetText("options2", "field_look"))
    self.row_size.label:SetText(UTILS.GetText("options2", "field_size"))
    self.row_duration.label:SetText(UTILS.GetText("options2", "field_show_duration"))
    self.row_textsize.label:SetText(UTILS.GetText("options2", "field_text_size"))
    self.row_back.label:SetText(UTILS.GetText("options2", "field_color_back"))
    self.row_fill.label:SetText(UTILS.GetText("options2", "field_color_fill"))
    self.row_num.label:SetText(UTILS.GetText("options2", "field_color_number"))
    self.row_text.label:SetText(UTILS.GetText("options2", "field_color_text"))

    self.size_by:SetText(UTILS.GetText("options2", "field_size_by"))

    local lang = L[Language.Local] or L[Language.English]
    local looks = {}
    for i, tt in ipairs(LOOK_TYPES) do
        looks[i] = (lang.type and lang.type[tt]) or ""
    end
    self.seg_look:SetLabels(looks)

    self.seg_duration:SetLabels({
        UTILS.GetText("options2", "dur_off"),
        UTILS.GetText("options2", "dur_seconds"),
        UTILS.GetText("options2", "dur_tenths"),
        UTILS.GetText("options2", "dur_clock"),
    })
end

function Options2.Window.SimpleWindowEditor:LanguageChanged()
    if self.rows == nil then return end
    self.dd_textsize:LanguageChanged()
    self:_RefreshTexts()
    self:_ApplyLayout()
end

-- ── load ────────────────────────────────────────────────────────────────────

function Options2.Window.SimpleWindowEditor:SetWindow(nodeData)
    self.nodeData = nodeData
    if nodeData == nil then return end
    self:Load()
end

function Options2.Window.SimpleWindowEditor:Load()
    local nd = self.nodeData
    if nd == nil then return end
    local wd = nd.data

    self.field_name.box:SetText(wd.name or "")
    self.field_width.box:SetText(tostring(wd.width or 150))
    self.field_height.box:SetText(tostring(wd.height or 20))

    self.seg_look:SetSelected(self:_LookIndex(wd))
    self.seg_duration:SetSelected(self:_DurationIndex(wd))
    self.dd_textsize:SetSelection(wd.fontSize or 14)

    self.row_back.field.box:SetText(UTILS.ColorToText(wd.color2))
    self.row_fill.field.box:SetText(UTILS.ColorToText(wd.color3))
    self.row_num.field.box:SetText(UTILS.ColorToText(wd.color4))
    self.row_text.field.box:SetText(UTILS.ColorToText(wd.color5))

    self:_ApplyLayout()
end

function Options2.Window.SimpleWindowEditor:_LookIndex(wd)
    for i, tt in ipairs(LOOK_TYPES) do
        if wd.timerType == tt then return i end
    end
    return 1
end

function Options2.Window.SimpleWindowEditor:_DurationIndex(wd)
    if wd.showTimer ~= true then return 1 end
    if wd.durationFormat == NumberFormat.Seconds    then return 2 end
    if wd.durationFormat == NumberFormat.OneDecimal then return 3 end
    return 4
end

-- ── save ────────────────────────────────────────────────────────────────────

function Options2.Window.SimpleWindowEditor:Save()
    local nd = self.nodeData
    if nd == nil then return end

    local wd = nd.data
    local wi = nd.windowIndex

    wd.name   = self.field_name.box:GetText()
    wd.width  = tonumber(self.field_width.box:GetText())  or wd.width
    wd.height = tonumber(self.field_height.box:GetText()) or wd.height

    -- A counter window has one allowed display type, so its look is fixed and
    -- the row is hidden; only write the type when it was on offer. Derived here
    -- rather than read off the layout, which may not have run yet.
    if wd.type ~= Window.Types.COUNTER_WINDOW then
        local look = LOOK_TYPES[self.seg_look:GetSelected()]
        if look ~= nil and look ~= wd.timerType then
            wd.timerType = look
            -- every timer in the window follows the window's display type
            for _, tmd in ipairs(wd.timerList or {}) do
                tmd.type = look
            end
        end
    end

    local dur = self.seg_duration:GetSelected()
    if dur == 1 then
        wd.showTimer = false
    else
        wd.showTimer = true
        if dur == 2 then
            wd.durationFormat = NumberFormat.Seconds
        elseif dur == 3 then
            wd.durationFormat = NumberFormat.OneDecimal
        else
            wd.durationFormat = NumberFormat.Minutes
        end
    end

    wd.fontSize = self.dd_textsize:GetSelectedValue() or wd.fontSize

    wd.color2 = UTILS.TextToColor(self.row_back.field.box:GetText())
    wd.color3 = UTILS.TextToColor(self.row_fill.field.box:GetText())
    wd.color4 = UTILS.TextToColor(self.row_num.field.box:GetText())
    wd.color5 = UTILS.TextToColor(self.row_text.field.box:GetText())

    Options.SaveData()
    Options.DataChanged(wi)
    Windows.EnabledChanged(wi)
end

-- ── layout ──────────────────────────────────────────────────────────────────

function Options2.Window.SimpleWindowEditor:SizeChanged()
    if self.rows == nil then return end
    self:_ApplyLayout()
end

function Options2.Window.SimpleWindowEditor:_ApplyLayout()
    local M = Options2.Elements.EditorRow
    local w = self:GetWidth()
    if w <= 0 then return end

    -- A counter window allows one display type, so there is no look to choose.
    local wd = self.nodeData and self.nodeData.data
    self.seg_look_enabled = (wd == nil) or (wd.type ~= Window.Types.COUNTER_WINDOW)

    local ctrl_left = M.CTRL_LEFT
    local ctrl_top  = M.CentreTop(ROW_H, M.CTRL_H)
    local seg_top   = M.CentreTop(ROW_H, Options2.Simple.SEG_H)
    local y         = 0
    local index     = 0

    for _, row in ipairs(self.rows) do
        local shown = (row ~= self.row_look) or self.seg_look_enabled
        row:SetVisible(shown)
        if shown then
            index = index + 1
            row:SetPosition(0, y)
            row:SetWidth(w)
            row:SetBackColor(M.Fill(index))
            y = y + ROW_H
        end
    end

    local field_w = math.max(0, w - ctrl_left - PAD)

    self.field_name:Layout(ctrl_left, ctrl_top, field_w, M.CTRL_H)

    self.seg_look:SetVisible(self.seg_look_enabled)
    if self.seg_look_enabled then
        self.seg_look:Layout(ctrl_left, seg_top)
    end

    -- width x height, sharing the row
    self.field_width:Layout(ctrl_left, ctrl_top, M.NUM_W, M.CTRL_H)
    self.size_by:SetPosition(ctrl_left + M.NUM_W + HINT_GAP, 0)
    self.size_by:SetWidth(14)
    self.field_height:Layout(ctrl_left + M.NUM_W + HINT_GAP + 14 + HINT_GAP,
                             ctrl_top, M.NUM_W, M.CTRL_H)

    self.seg_duration:Layout(ctrl_left, seg_top)
    self.dd_textsize:SetPosition(ctrl_left, ctrl_top)

    for _, row in ipairs({ self.row_back, self.row_fill, self.row_num, self.row_text }) do
        row.swatch:SetPosition(ctrl_left, ctrl_top)
        local field_left = ctrl_left + M.CTRL_H + 6
        row.field:Layout(field_left, ctrl_top,
                         math.max(0, w - field_left - PAD), M.CTRL_H)
    end

    self._content_h = y
end
