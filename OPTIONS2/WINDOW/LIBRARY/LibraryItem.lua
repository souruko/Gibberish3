-- Library row: game icon, name over sub-label, then either the Use action on
-- the selected row or the pin star.
--
-- The row is sized around the icon rather than the icon scaled to the row:
-- stretching inside a ListBox that has a scrollbar draws the image outside the
-- list. That makes the row 36 high instead of the spec's 32.

local ICON_SZ = 32          -- native size of a game icon; never scaled
local ITEM_H  = ICON_SZ + 4
local PAD     = 8
local GAP     = 8
local PIN_W   = 16
local USE_W   = 34
local USE_H   = 20

Options2.Library.LibraryItem = class(Turbine.UI.Control)
function Options2.Library.LibraryItem:Constructor(data, typeIdx, library)
    Turbine.UI.Control.Constructor(self)

    self.data    = data
    self.typeIdx = typeIdx
    self.library = library

    self:SetHeight(ITEM_H)

    self.icon_ctrl = Turbine.UI.Control()
    self.icon_ctrl:SetParent(self)
    self.icon_ctrl:SetPosition(PAD, math.floor((ITEM_H - ICON_SZ) / 2))
    self.icon_ctrl:SetMouseVisible(false)
    if not Options2.Elements.RowParts.SetNativeIcon(self.icon_ctrl, data.icon) then
        self.icon_ctrl:SetBackColor(Options.Defaults.window.bg_sunken)
    end
    self.icon_ctrl:SetPosition(PAD, math.floor((ITEM_H - ICON_SZ) / 2))

    self.token_label = Turbine.UI.Label()
    self.token_label:SetParent(self)
    self.token_label:SetFont(Turbine.UI.Lotro.Font.Verdana12)
    self.token_label:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft)
    self.token_label:SetForeColor(Options.Defaults.window.text)
    self.token_label:SetText(data.token or "")
    self.token_label:SetMouseVisible(false)

    self.sub_label = Turbine.UI.Label()
    self.sub_label:SetParent(self)
    self.sub_label:SetFont(Turbine.UI.Lotro.Font.Verdana10)
    self.sub_label:SetTextAlignment(Turbine.UI.ContentAlignment.BottomLeft)
    self.sub_label:SetForeColor(Options.Defaults.window.text_faint)
    self.sub_label:SetMouseVisible(false)
    if typeIdx == 2 and data.originType ~= nil then
        self.sub_label:SetText(data.originType)
    elseif data.timer ~= nil then
        self.sub_label:SetText(data.timer .. "s")
    end

    -- pin star: keeps the entry in the persistent collection
    self.pin_btn = Turbine.UI.Control()
    self.pin_btn:SetParent(self)
    self.pin_btn:SetSize(PIN_W, PIN_W)
    self.pin_btn:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    self.pin_btn:SetMouseVisible(true)
    self.pin_btn.MouseClick = function() self:_TogglePin() end

    -- shown on the selected row: writes this entry into the armed field
    self.use_btn = Turbine.UI.Control()
    self.use_btn:SetParent(self)
    self.use_btn:SetSize(USE_W, USE_H)
    self.use_btn:SetTop(math.floor((ITEM_H - USE_H) / 2))
    self.use_btn:SetBackColor(Options.Defaults.window.accent)
    self.use_btn:SetVisible(false)
    self.use_btn:SetMouseVisible(true)
    self.use_btn.MouseClick = function()
        self.library:UseItem(self)
    end

    self.use_label = Turbine.UI.Label()
    self.use_label:SetParent(self.use_btn)
    self.use_label:SetSize(USE_W, USE_H)
    self.use_label:SetFont(Turbine.UI.Lotro.Font.Verdana10)
    self.use_label:SetForeColor(Options.Defaults.window.bg)
    self.use_label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.use_label:SetMouseVisible(false)

    self:LanguageChanged()
    self:_RefreshPin()
    self:_Refresh()

    self.MouseEnter = function()
        if self.library._selectedItem ~= self then
            self:SetBackColor(Options.Defaults.window.row_odd)
        end
    end
    self.MouseLeave = function() self:_Refresh() end
    self.MouseClick = function(sender, args)
        if args.Button == Turbine.UI.MouseButton.Right then
            self:_TogglePin()
        else
            self.library:SelectItem(self)
        end
    end
end

function Options2.Library.LibraryItem:LanguageChanged()
    self.use_label:SetText(UTILS.GetText("options2", "use"))
end

function Options2.Library.LibraryItem:_TogglePin()
    self.data.persistent = not self.data.persistent
    if self.data.persistent then
        Options.KeepInCollection(self.data, self.typeIdx)
    else
        Options.RemoveFromCollection(
            Options.CheckForIndexInCollection(self.data, self.typeIdx))
    end
    self:_RefreshPin()
    self:_Refresh()
end

function Options2.Library.LibraryItem:SizeChanged()
    if self.token_label == nil then return end
    local w, h = self:GetSize()
    if w <= 0 then return end

    local right   = w - PAD
    local text_left = PAD + ICON_SZ + GAP

    self.use_btn:SetLeft(right - USE_W)
    self.pin_btn:SetPosition(right - PIN_W, math.floor((h - PIN_W) / 2))

    -- the widest of the two right-hand controls decides the text budget
    local text_w = math.max(0, (right - USE_W) - GAP - text_left)
    self.token_label:SetPosition(text_left, 0)
    self.token_label:SetSize(text_w, h)
    self.sub_label:SetPosition(text_left, 0)
    self.sub_label:SetSize(text_w, h)
end

function Options2.Library.LibraryItem:_RefreshPin()
    self.pin_btn:SetBackground(self.data.persistent
        and "Gibberish3/RESOURCES/pin_on.tga"
        or  "Gibberish3/RESOURCES/pin_off.tga")
end

function Options2.Library.LibraryItem:_Refresh()
    local selected = (self.library._selectedItem == self)

    -- Use replaces the pin on the selected row
    self.use_btn:SetVisible(selected)
    self.pin_btn:SetVisible(not selected)

    if selected then
        self:SetBackColor(Options.Defaults.window.select)
    elseif self.data.persistent then
        self:SetBackColor(Options.Defaults.window.row_even)
    else
        self:SetBackColor(nil)
    end
end
