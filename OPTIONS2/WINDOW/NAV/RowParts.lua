-- Shared chrome for the structure column rows (FolderItem / WindowItem).
-- Row anatomy per SPEC-metrics "Column 1 — Structure".

Options2NavParts = {}

Options2NavParts.ROW_H       = 26
Options2NavParts.PAD         = 8
Options2NavParts.GAP         = 6
Options2NavParts.RAIL_W      = 3
Options2NavParts.CHEVRON     = 11
Options2NavParts.NODE_ICON   = 13
Options2NavParts.BOX         = 9
Options2NavParts.BOLT        = 4

-- indent: 4px lead, then per level an 8px spacer plus a 1px guide line
local INDENT_LEAD = 4
local INDENT_STEP = 9
local GUIDE_OFF   = 8   -- guide sits at the end of each level's spacer

function Options2NavParts.ContentLeft(depth)
    return INDENT_LEAD + depth * INDENT_STEP + 5
end

-- utf-8 aware; Label clips mid-glyph, so never rely on clipping
function Options2NavParts.Truncate(text, max_chars)
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
function Options2NavParts.CharBudget(pixels)
    return math.floor(pixels / 6.5)
end

-- one 1px vertical guide per ancestor level, pooled on the row
function Options2NavParts.LayoutGuides(row, depth)
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
        guide:SetHeight(Options2NavParts.ROW_H)
        guide:SetVisible(true)
    end

    for i = depth + 1, #row._guides do
        row._guides[i]:SetVisible(false)
    end
end

-- 3px left rail in the node colour, shown only while the row is selected
function Options2NavParts.MakeRail(row, color)
    local rail = Turbine.UI.Control()
    rail:SetParent(row)
    rail:SetPosition(0, 0)
    rail:SetSize(Options2NavParts.RAIL_W, Options2NavParts.ROW_H)
    rail:SetBackColor(color)
    rail:SetVisible(false)
    rail:SetMouseVisible(false)
    return rail
end

-- 9x9 enable box: filled when on, 1px outline when off
function Options2NavParts.MakeEnableBox(row, click_fn)
    local S = Options2NavParts.BOX

    local box = Turbine.UI.Control()
    box:SetParent(row)
    box:SetSize(S, S)
    box:SetTop(math.floor((Options2NavParts.ROW_H - S) / 2))
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
function Options2NavParts.MakeBolt(row)
    local S = Options2NavParts.BOLT
    local bolt = Turbine.UI.Control()
    bolt:SetParent(row)
    bolt:SetSize(S, S)
    bolt:SetTop(math.floor((Options2NavParts.ROW_H - S) / 2))
    bolt:SetBackColor(Options.Defaults.window.color_trigger)
    bolt:SetVisible(false)
    bolt:SetMouseVisible(false)
    return bolt
end

function Options2NavParts.MakeIcon(row, size, path)
    local icon = Turbine.UI.Control()
    icon:SetParent(row)
    icon:SetSize(size, size)
    icon:SetTop(math.floor((Options2NavParts.ROW_H - size) / 2))
    icon:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    icon:SetBackground(path)
    icon:SetStretchMode(1)
    icon:SetMouseVisible(false)
    return icon
end

function Options2NavParts.MakeLabel(row, size, color, alignment)
    local label = Turbine.UI.Label()
    label:SetParent(row)
    label:SetHeight(Options2NavParts.ROW_H)
    label:SetFont(size)
    label:SetForeColor(color)
    label:SetTextAlignment(alignment)
    label:SetMouseVisible(false)
    return label
end

-- selection / hover / drag / click wiring shared by both row types
function Options2NavParts.WireRow(row, navWin)
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

function Options2NavParts.ApplySelected(row, selected)
    row.selected = selected
    row.rail:SetVisible(selected)
    row:SetBackColor(selected and Options.Defaults.window.select or nil)
end

-- true when the container holds at least one trigger of any type
function Options2NavParts.HasTriggers(container, trig_types)
    for _, tt in ipairs(trig_types) do
        local list = container[tt]
        if list ~= nil and #list > 0 then return true end
    end
    return false
end
