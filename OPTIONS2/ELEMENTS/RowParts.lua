-- Shared row chrome for the structure and contents columns.
-- Row anatomy per SPEC-metrics "Column 1 — Structure" / "Column 2 — Contents".
--
-- Lives on Options2.Elements rather than in a global of its own: Turbine gives
-- each package directory its own environment, so a bare global assigned here
-- would be invisible to OPTIONS2/WINDOW/**. Options2 comes from Variables.lua
-- at the root, so every package can see it.

Options2.Elements.RowParts = {}
local RowParts = Options2.Elements.RowParts


RowParts.ROW_H       = 26
RowParts.PAD         = 8
RowParts.GAP         = 6
RowParts.RAIL_W      = 3
RowParts.RAIL_IDLE_W = 2
RowParts.CHEVRON     = 11   -- slot width for the expand marker
RowParts.NODE_ICON   = 13   -- slot width for the node marker
RowParts.CHEV_SQUARE = 7
RowParts.NODE_SQUARE = 11
RowParts.BOX         = 9
RowParts.BOLT        = 4

-- indent: 4px lead, then per level an 8px spacer plus a 1px guide line
local INDENT_LEAD = 4
local INDENT_STEP = 9
local GUIDE_OFF   = 8   -- guide sits at the end of each level's spacer

function RowParts.ContentLeft(depth)
    return INDENT_LEAD + depth * INDENT_STEP + 5
end

-- utf-8 aware; Label clips mid-glyph, so never rely on clipping
function RowParts.Truncate(text, max_chars)
    if text == nil or text == "" then return "" end
    text = tostring(text)
    if max_chars < 1 then return "" end

    local chars = {}
    for c in string.gmatch(text, "[\1-\127\194-\244][\128-\191]*") do
        chars[#chars + 1] = c
    end
    if #chars <= max_chars then return text end
    return table.concat(chars, "", 1, math.max(1, max_chars - 1)) .. "…"
end

-- Verdana12 is proportional; this is the budget used to decide truncation.
function RowParts.CharBudget(pixels)
    return math.floor(pixels / 6.5)
end

-- one 1px vertical guide per ancestor level, pooled on the row
function RowParts.LayoutGuides(row, depth)
    row._guides = row._guides or {}

    for i = 1, depth do
        local guide = row._guides[i]
        if guide == nil then
            guide = Turbine.UI.Control()
            guide:SetParent(row)
            guide:SetWidth(1)
            guide:SetBackColor(Options.Defaults.window.line)
            guide:SetMouseVisible(false)
            row._guides[i] = guide
        end
        guide:SetPosition(INDENT_LEAD + (i - 1) * INDENT_STEP + GUIDE_OFF, 0)
        guide:SetHeight(RowParts.ROW_H)
        guide:SetVisible(true)
    end

    for i = depth + 1, #row._guides do
        row._guides[i]:SetVisible(false)
    end
end

-- Left rail in the node colour. This carries the folder/window colour coding:
-- a .tga background cannot be tinted (SetBackColor fills the control behind the
-- glyph rather than colouring it), so the colour lives on primitives and text.
-- Always visible, and widened while the row is selected.
function RowParts.MakeRail(row, color)
    local rail = Turbine.UI.Control()
    rail:SetParent(row)
    rail:SetPosition(0, 0)
    rail:SetSize(RowParts.RAIL_IDLE_W, RowParts.ROW_H)
    rail:SetBackColor(color)
    rail:SetMouseVisible(false)
    return rail
end

-- Enable box: filled when on, 1px outline when off. 9x9 in the structure
-- column, 8x8 for the contents column's child rows.
function RowParts.MakeEnableBox(row, click_fn, size, row_h)
    local S = size or RowParts.BOX

    local box = Turbine.UI.Control()
    box:SetParent(row)
    box:SetSize(S, S)
    box:SetTop(math.floor(((row_h or RowParts.ROW_H) - S) / 2))
    box:SetMouseVisible(true)

    local inner = Turbine.UI.Control()
    inner:SetParent(box)
    inner:SetPosition(1, 1)
    inner:SetSize(S - 2, S - 2)
    inner:SetMouseVisible(false)

    function box:SetOn(on)
        if on then
            box:SetBackColor(Options.Defaults.window.on)
            inner:SetBackColor(Options.Defaults.window.on)
        else
            box:SetBackColor(Options.Defaults.window.off_border)
            inner:SetBackColor(nil)   -- lets the row fill show through
        end
    end

    box.MouseClick = click_fn
    return box
end

-- small square marking "this node has triggers of its own"; stands in for the
-- node_trigger bolt glyph until that art exists
function RowParts.MakeBolt(row)
    local S = RowParts.BOLT
    local bolt = Turbine.UI.Control()
    bolt:SetParent(row)
    bolt:SetSize(S, S)
    bolt:SetTop(math.floor((RowParts.ROW_H - S) / 2))
    bolt:SetBackColor(Options.Defaults.window.color_trigger)
    bolt:SetVisible(false)
    bolt:SetMouseVisible(false)
    return bolt
end

-- Coloured square, filled or drawn as a 1px outline. Used for the node marker
-- and the folder's expand state, because a .tga glyph cannot be coloured.
-- slot is the horizontal space the square is centred in, so rows keep their
-- alignment whatever size the square is.
function RowParts.MakeSquare(row, size, slot, color)
    local square = Turbine.UI.Control()
    square:SetParent(row)
    square:SetSize(size, size)
    square:SetTop(math.floor((RowParts.ROW_H - size) / 2))
    square:SetMouseVisible(false)

    local inner = Turbine.UI.Control()
    inner:SetParent(square)
    inner:SetPosition(1, 1)
    inner:SetSize(size - 2, size - 2)
    inner:SetMouseVisible(false)

    square._slot   = slot
    square._color  = color
    square._inset  = math.floor((slot - size) / 2)

    function square:SetFilled(filled)
        self:SetBackColor(self._color)
        inner:SetBackColor(filled and self._color or nil)
    end

    -- position by the slot's left edge, not the square's
    function square:SetSlotLeft(x)
        self:SetLeft(x + self._inset)
    end

    square:SetFilled(true)
    return square
end

function RowParts.MakeLabel(row, size, color, alignment)
    local label = Turbine.UI.Label()
    label:SetParent(row)
    label:SetHeight(RowParts.ROW_H)
    label:SetFont(size)
    label:SetForeColor(color)
    label:SetTextAlignment(alignment)
    label:SetMouseVisible(false)
    return label
end

-- selection / hover / drag / click wiring shared by both row types
function RowParts.WireRow(row, navWin)
    row.MouseEnter = function()
        if not row.selected then
            row:SetBackColor(Options.Defaults.window.row_odd)
        end
    end
    row.MouseLeave = function()
        if not row.selected then row:SetBackColor(nil) end
    end
    row.MouseDown = function(sender, args)
        if args.Button == Turbine.UI.MouseButton.Left then navWin:_DragBegin(row, args) end
    end
    row.MouseMove = function(sender, args) navWin:_DragMove(row, args) end
    row.MouseUp = function(sender, args)
        if args.Button == Turbine.UI.MouseButton.Left then navWin:_DragFinish(row, args) end
    end
    row.MouseDoubleClick = function(sender, args)
        if args.Button ~= Turbine.UI.MouseButton.Right then
            navWin:_ToggleExpand(row)
        end
    end
    row.MouseClick = function(sender, args)
        if navWin._drag_just_ended then navWin._drag_just_ended = false; return end
        if args.Button == Turbine.UI.MouseButton.Right then
            navWin:ItemRightClicked(row)
        else
            navWin:ItemClicked(row)
        end
    end
end

-- Contents column rows: select on click, context menu on right click. They are
-- not drag sources — the contents column shows one container at a time, so
-- there is nowhere to drag to.
function RowParts.WireContentRow(row, contentWin)
    row:SetMouseVisible(true)
    row.MouseEnter = function()
        if not row.selected then
            row:SetBackColor(Options.Defaults.window.row_odd)
        end
    end
    row.MouseLeave = function()
        if not row.selected then row:SetBackColor(nil) end
    end
    row.MouseClick = function(sender, args)
        if args.Button == Turbine.UI.MouseButton.Right then
            contentWin:RowRightClicked(row)
        else
            contentWin:RowClicked(row)
        end
    end
end

function RowParts.ApplySelected(row, selected)
    row.selected = selected
    row.rail:SetWidth(selected and RowParts.RAIL_W or RowParts.RAIL_IDLE_W)
    row:SetBackColor(selected and Options.Defaults.window.select or nil)
end

-- Draw a Turbine image at its native size, with no stretching.
--
-- Do not stretch an icon inside a ListBox row: with a scrollbar attached the
-- stretch is applied wrongly and the image ends up drawn outside the list.
-- Size the row around the icon instead. Game icons are 32x32.
-- Overlay blend is for the monochrome .tga glyphs only — it renders a
-- full-colour game icon invisible against the dark panel.
RowParts.ICON_NATIVE = 32

function RowParts.SetNativeIcon(control, image)
    control:SetSize(RowParts.ICON_NATIVE, RowParts.ICON_NATIVE)
    if image == nil then return false end
    control:SetBackground(image)
    return true
end

-- ── trigger presentation, shared by every row that shows one ────────────────

-- trigger types whose whole purpose is matching a token, so an empty one is
-- worth calling out rather than leaving blank
local TOKEN_TYPES = nil

local function token_types()
    if TOKEN_TYPES == nil then
        TOKEN_TYPES = {}
        -- assigned rather than built as a literal: a nil key would throw, and
        -- these names are only guaranteed once TRIGGER/ has been imported
        for _, name in ipairs({ "EffectSelf", "EffectGroup", "EffectTarget",
                                "EffectRemoveSelf", "Chat", "Skill" }) do
            local tt = Trigger.Types[name]
            if tt ~= nil then TOKEN_TYPES[tt] = true end
        end
    end
    return TOKEN_TYPES
end

-- the trigger's own description, falling back to its localised type name
function RowParts.TriggerLabel(trigData, trigType)
    local desc = trigData and trigData.description
    if desc ~= nil and desc ~= "" then return desc end
    local lang = L[Language.Local] or L[Language.English]
    return (lang.triggerType and lang.triggerType[trigType]) or ""
end

-- returns the token to show plus whether it is a "nothing set yet" placeholder
function RowParts.TriggerToken(trigData, trigType)
    local token = trigData and trigData.token
    if token ~= nil and token ~= "" then return token, false end
    if token_types()[trigType] then
        return UTILS.GetText("options2", "no_pattern"), true
    end
    return "", false
end

-- 1px vertical rail spanning the row, used to tie a timer's children together
function RowParts.MakeRailAt(row, x, color, height)
    local rail = Turbine.UI.Control()
    rail:SetParent(row)
    rail:SetPosition(x, 0)
    rail:SetSize(1, height)
    rail:SetBackColor(color)
    rail:SetMouseVisible(false)
    return rail
end

-- true when the container holds at least one trigger of any type
function RowParts.HasTriggers(container, trig_types)
    for _, tt in ipairs(trig_types) do
        local list = container[tt]
        if list ~= nil and #list > 0 then return true end
    end
    return false
end

-- ── contents column child-row geometry ──────────────────────────────────────
-- A timer's children all draw a green rail at the same x, so the rail reads as
-- one continuous line down the whole timer block, including behind a condition
-- and its own triggers. A condition trigger adds a second, purple rail inside
-- that.
RowParts.CHILD_H          = 26
RowParts.CHILD_RAIL_X     = 18   -- timer rail, every child row
RowParts.CHILD_TEXT_X     = 27   -- rail + 8px margin
RowParts.COND_RAIL_X      = 31   -- timer rail + 12px margin
RowParts.COND_TEXT_X      = 40   -- condition rail + 8px margin
RowParts.CHILD_MARK       = 4
RowParts.CHILD_DOT        = 8
RowParts.CHILD_GAP        = 8
RowParts.CHILD_PAD        = 10

-- marker square standing in for the trigger bolt / condition funnel glyphs
function RowParts.MakeChildMark(row, color)
    local S = RowParts.CHILD_MARK
    local mark = Turbine.UI.Control()
    mark:SetParent(row)
    mark:SetSize(S, S)
    mark:SetTop(math.floor((RowParts.CHILD_H - S) / 2))
    mark:SetBackColor(color)
    mark:SetMouseVisible(false)
    return mark
end

function RowParts.MakeChildLabel(row, font, color, alignment)
    local label = Turbine.UI.Label()
    label:SetParent(row)
    label:SetHeight(RowParts.CHILD_H)
    label:SetFont(font)
    label:SetForeColor(color)
    label:SetTextAlignment(alignment)
    label:SetMouseVisible(false)
    return label
end

-- selection treatment shared by every contents child row
function RowParts.ApplyChildSelected(row, selected, sel_rail)
    row.selected = selected
    row:SetBackColor(selected and Options.Defaults.window.select or nil)
    sel_rail:SetVisible(selected)
end
