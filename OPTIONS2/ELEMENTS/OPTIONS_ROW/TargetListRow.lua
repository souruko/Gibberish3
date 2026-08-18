-- A managed list of target names, replacing the semicolon-separated text box.
--
-- Each name is its own entry with a remove button; new ones come from the add
-- field below the list, or straight from the current target. The row keeps the
-- fixed height every other editor row has and scrolls internally, so a long
-- list never pushes the rest of the form off the bottom of the editor.

local ENTRY_H  = 20
local SCROLL_W = 10
local BTN_H    = 20
local X_SIZE   = 16          -- close.tga is authored at 16x16
local GAP      = 4
local PAD_V    = 4
local ENTRY_PAD = 6
local MIN_FIELD_W = 70

-- the metrics that hold text follow the panel's font size; see OPTIONS2/Fonts.lua
Options2.Fonts.Register(function()
    local F = Options2.Fonts
    ENTRY_H     = F.Px(20)
    BTN_H       = F.Px(20)
    MIN_FIELD_W = F.Px(70)
end)

local M = Options2.Elements.EditorRow

-- ── helpers ───────────────────────────────────────────────────────────────────

local function trim(text)
    return (string.gsub(text or "", "^%s*(.-)%s*$", "%1"))
end

-- A bordered pill, sized from its own label. Same chrome as the editor's
-- Save / Revert buttons, at row scale.
local function make_button(parent, border, fg, tooltip_description, click_fn)
    local btn = Turbine.UI.Control()
    btn:SetParent(parent)
    btn:SetHeight(BTN_H)
    btn:SetBackColor(border)
    btn:SetMouseVisible(true)

    local fill = Turbine.UI.Control()
    fill:SetParent(btn)
    fill:SetPosition(1, 1)
    fill:SetBackColor(Options.Defaults.window.bg_sunken)
    fill:SetMouseVisible(false)

    local label = Turbine.UI.Label()
    label:SetParent(fill)
    label:SetFont(Options2.Fonts.SMALL)
    label:SetForeColor(fg)
    label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    label:SetMouseVisible(false)

    Options2.Elements.Tooltip.AddTooltip(btn, "tooltip", tooltip_description, false)
    local tip_enter, tip_leave = btn.MouseEnter, btn.MouseLeave
    btn.MouseEnter = function(sender, args)
        tip_enter(sender, args)
        fill:SetBackColor(Options.Defaults.window.select)
    end
    btn.MouseLeave = function(sender, args)
        tip_leave(sender, args)
        fill:SetBackColor(Options.Defaults.window.bg_sunken)
    end
    btn.MouseClick = click_fn

    -- Verdana10 is proportional; this is the same budget the editor toolbar uses
    function btn:SetLabel(text)
        label:SetText(text)
        self._w = 18 + string.len(text) * 6
    end

    function btn:GetPreferredWidth()
        return self._w or 40
    end

    function btn:Layout(left, top)
        local w = self:GetPreferredWidth()
        self:SetPosition(left, top)
        self:SetWidth(w)
        fill:SetSize(w - 2, BTN_H - 2)
        label:SetSize(w - 2, BTN_H - 2)
    end

    return btn
end

-- One name in the list: the name, and an x to drop it.
local function make_entry(name, remove_fn)
    local entry = Turbine.UI.Control()
    entry:SetHeight(ENTRY_H)
    entry:SetBackColor(Options.Defaults.window.bg_sunken)

    local label = Turbine.UI.Label()
    label:SetParent(entry)
    label:SetPosition(ENTRY_PAD, 0)
    label:SetHeight(ENTRY_H)
    label:SetFont(M.FONT_FIELD)
    label:SetForeColor(Options.Defaults.window.text)
    label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    label:SetText(name)
    label:SetMouseVisible(false)

    -- native size, never stretched: a stretched image inside a scrolling
    -- ListBox is drawn outside the list
    local del = Turbine.UI.Control()
    del:SetParent(entry)
    del:SetSize(X_SIZE, X_SIZE)
    del:SetTop(math.floor((ENTRY_H - X_SIZE) / 2))
    del:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    del:SetBackground("Gibberish3/RESOURCES/close.tga")
    del:SetMouseVisible(true)

    Options2.Elements.Tooltip.AddTooltip(del, "tooltip", "o2_target_remove", false)
    local tip_enter, tip_leave = del.MouseEnter, del.MouseLeave
    del.MouseEnter = function(sender, args)
        tip_enter(sender, args)
        entry:SetBackColor(Options.Defaults.window.select)
    end
    del.MouseLeave = function(sender, args)
        tip_leave(sender, args)
        entry:SetBackColor(Options.Defaults.window.bg_sunken)
    end
    del.MouseClick = function() remove_fn(name) end

    entry.value = name

    function entry:LayoutRow(w)
        self:SetWidth(w)
        del:SetLeft(w - X_SIZE - ENTRY_PAD)
        label:SetWidth(math.max(0, w - X_SIZE - 2 * ENTRY_PAD - GAP))
    end

    return entry
end

-- ── the row ───────────────────────────────────────────────────────────────────

Options2.Elements.TargetListRow = class(Turbine.UI.Control)
function Options2.Elements.TargetListRow:Constructor(back_color, label_control, label_description, tooltip_description, height)
    Turbine.UI.Control.Constructor(self)

    self.label_control     = label_control
    self.label_description = label_description
    self.values            = {}

    self.label = M.MakeLabel(self, tooltip_description)

    -- the list, in the same sunken frame the text fields use
    self.frame = Turbine.UI.Control()
    self.frame:SetParent(self)
    self.frame:SetBackColor(Options.Defaults.window.line)
    self.frame:SetMouseVisible(false)

    self.inner = Turbine.UI.Control()
    self.inner:SetParent(self.frame)
    self.inner:SetPosition(1, 1)
    self.inner:SetBackColor(Options.Defaults.window.bg_sunken)
    self.inner:SetMouseVisible(false)

    self.listbox = Turbine.UI.ListBox()
    self.listbox:SetParent(self.inner)
    self.listbox:SetPosition(0, 0)
    self.listbox:SetBackColor(Options.Defaults.window.bg_sunken)
    self.listbox:SetMouseVisible(false)

    self.scrollbar = Turbine.UI.Lotro.ScrollBar()
    self.scrollbar:SetParent(self.inner)
    self.scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical)
    self.scrollbar:SetWidth(SCROLL_W)
    self.listbox:SetVerticalScrollBar(self.scrollbar)

    -- spells out what an empty list means, since empty means "match anything"
    self.empty = Turbine.UI.Label()
    self.empty:SetParent(self.inner)
    self.empty:SetPosition(0, 0)
    self.empty:SetFont(Options2.Fonts.SMALL)
    self.empty:SetForeColor(Options.Defaults.window.text_faint)
    self.empty:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.empty:SetMouseVisible(false)

    -- add field and its buttons
    self.field = M.MakeField(self, false)

    self.btn_add = make_button(self,
        Options.Defaults.window.accent, Options.Defaults.window.accent,
        "o2_target_add",
        function() self:AddText(self.field.box:GetText()) end)

    self.btn_target = make_button(self,
        Options.Defaults.window.line, Options.Defaults.window.text_muted,
        "o2_target_current",
        function() self:AddCurrentTarget() end)

    self:SetHeight(height or 112)
    self:SetBackColor(back_color)
    self:LanguageChanged()
    self:_Rebuild()
end

function Options2.Elements.TargetListRow:LanguageChanged()
    self.label:SetText(UTILS.GetText(self.label_control, self.label_description))
    self.empty:SetText(UTILS.GetText("options2", "no_targets"))
    self.btn_add:SetLabel(UTILS.GetText("options2", "add"))
    self.btn_target:SetLabel("+ " .. UTILS.GetText("options2", "target"))
    if self.frame ~= nil then self:SizeChanged() end
end

function Options2.Elements.TargetListRow:SizeChanged()
    if self.frame == nil then return end
    local w, h = self:GetSize()
    self.label:SetHeight(h)

    local ctrl_left = M.CTRL_LEFT
    local ctrl_w    = math.max(0, w - ctrl_left - M.RIGHT_PAD)
    local list_h    = math.max(0, h - 2 * PAD_V - M.CTRL_H - GAP)

    self.frame:SetPosition(ctrl_left, PAD_V)
    self.frame:SetSize(ctrl_w, list_h)

    local iw = math.max(0, ctrl_w - 2)
    local ih = math.max(0, list_h - 2)
    self.inner:SetSize(iw, ih)
    self.empty:SetSize(iw, ih)

    local list_w = math.max(0, iw - SCROLL_W)
    self.listbox:SetSize(list_w, ih)
    self.scrollbar:SetPosition(list_w, 0)
    self.scrollbar:SetHeight(ih)
    for i = 1, self.listbox:GetItemCount() do
        self.listbox:GetItem(i):LayoutRow(list_w)
    end

    -- add field, then the buttons pinned to the right. The editor column can be
    -- dragged down to 200px, where the field would be squeezed out entirely, so
    -- the convenience button gives way before the field does.
    local btn_top   = PAD_V + list_h + GAP + math.floor((M.CTRL_H - BTN_H) / 2)
    local add_w     = self.btn_add:GetPreferredWidth()
    local target_w  = self.btn_target:GetPreferredWidth()
    local add_left  = ctrl_left + ctrl_w - add_w
    local trg_left  = add_left - GAP - target_w

    local show_target = (trg_left - GAP - ctrl_left) >= MIN_FIELD_W
    self.btn_target:SetVisible(show_target)

    self.btn_add:Layout(add_left, btn_top)
    if show_target then self.btn_target:Layout(trg_left, btn_top) end

    local field_right = show_target and trg_left or add_left
    self.field:Layout(ctrl_left, PAD_V + list_h + GAP,
        math.max(0, field_right - GAP - ctrl_left), M.CTRL_H)
end

-- ── contents ──────────────────────────────────────────────────────────────────

-- keeps the list free of blanks and case-insensitive duplicates
function Options2.Elements.TargetListRow:_Insert(name)
    name = trim(name)
    if name == "" then return false end

    local lower = string.lower(name)
    for _, existing in ipairs(self.values) do
        if string.lower(existing) == lower then return false end
    end

    self.values[#self.values + 1] = name
    return true
end

function Options2.Elements.TargetListRow:_Rebuild()
    self.listbox:ClearItems()
    local list_w = math.max(0, self.listbox:GetWidth())

    for _, name in ipairs(self.values) do
        local entry = make_entry(name, function(value) self:Remove(value) end)
        if list_w > 0 then entry:LayoutRow(list_w) end
        self.listbox:AddItem(entry)
    end

    self.empty:SetVisible(#self.values == 0)
end

-- takes one name or a whole ';' separated string, so a pasted list still works
function Options2.Elements.TargetListRow:AddText(text)
    local added = false
    for _, name in ipairs(UTILS.StringOfTargetsToList(text or "")) do
        if self:_Insert(name) then added = true end
    end
    if added then self:_Rebuild() end
    self.field.box:SetText("")
end

function Options2.Elements.TargetListRow:AddCurrentTarget()
    local target = LocalPlayer:GetTarget()
    if target == nil then return end
    if self:_Insert(target:GetName()) then self:_Rebuild() end
end

function Options2.Elements.TargetListRow:Remove(name)
    for index, existing in ipairs(self.values) do
        if existing == name then
            table.remove(self.values, index)
            self:_Rebuild()
            return
        end
    end
end

function Options2.Elements.TargetListRow:SetValue(list)
    self.values = {}
    for _, name in ipairs(list or {}) do self:_Insert(name) end
    self.field.box:SetText("")
    self:_Rebuild()
end

function Options2.Elements.TargetListRow:GetValue()
    -- a copy: the caller stores this straight into the trigger data
    local out = {}
    for index, name in ipairs(self.values) do out[index] = name end
    return out
end
