-- "Copied" footer at the bottom of the library: what is on the clipboard, and
-- an x to drop it.

-- sized around the icon, which is never scaled (see RowParts.SetNativeIcon)
local ICON_SZ = 32
local BAR_H   = ICON_SZ + 4
local PAD     = 8
local GAP     = 8
local TAG_W   = 46
local BTN_SZ  = 18

-- the metrics that hold text follow the panel's font size; see OPTIONS2/Fonts.lua
Options2.Fonts.Register(function()
    local F = Options2.Fonts
    BAR_H = math.max(ICON_SZ + 4, F.Px(36))
    TAG_W = F.Px(46)
end)

Options2.Library.ClipboardBar = class(Turbine.UI.Control)
function Options2.Library.ClipboardBar:Constructor()
    Turbine.UI.Control.Constructor(self)

    self:SetHeight(BAR_H)
    self:SetBackColor(Options.Defaults.window.row_odd)
    self:SetVisible(false)

    self.top_line = Turbine.UI.Control()
    self.top_line:SetParent(self)
    self.top_line:SetPosition(0, 0)
    self.top_line:SetHeight(1)
    self.top_line:SetBackColor(Options.Defaults.window.line)
    self.top_line:SetMouseVisible(false)

    self.tag = Turbine.UI.Label()
    self.tag:SetParent(self)
    self.tag:SetPosition(PAD, 0)
    self.tag:SetSize(TAG_W, BAR_H)
    self.tag:SetFont(Options2.Fonts.SMALL)
    self.tag:SetForeColor(Options.Defaults.window.text_faint)
    self.tag:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.tag:SetMouseVisible(false)

    self.icon_ctrl = Turbine.UI.Control()
    self.icon_ctrl:SetParent(self)
    self.icon_ctrl:SetSize(ICON_SZ, ICON_SZ)
    self.icon_ctrl:SetTop(math.floor((BAR_H - ICON_SZ) / 2))
    self.icon_ctrl:SetMouseVisible(false)

    self.label = Turbine.UI.Label()
    self.label:SetParent(self)
    self.label:SetHeight(BAR_H)
    self.label:SetFont(Options2.Fonts.BODY)
    self.label:SetForeColor(Options.Defaults.window.text)
    self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.label:SetMouseVisible(false)

    self.clear_btn = Turbine.UI.Button()
    self.clear_btn:SetParent(self)
    self.clear_btn:SetSize(BTN_SZ, BTN_SZ)
    self.clear_btn:SetText("x")
    self.clear_btn:SetFont(Options2.Fonts.BODY)
    self.clear_btn:SetForeColor(Options.Defaults.window.text_muted)
    self.clear_btn.Click = function() Options2.ClearClipboard() end

    self:LanguageChanged()
end

function Options2.Library.ClipboardBar:LanguageChanged()
    self.tag:SetText(UTILS.GetText("options2", "copied"))
end

function Options2.Library.ClipboardBar:SizeChanged()
    if self.label == nil then return end
    local w = self:GetWidth()
    if w <= 0 then return end

    self.top_line:SetWidth(w)
    self.clear_btn:SetPosition(w - PAD - BTN_SZ, math.floor((BAR_H - BTN_SZ) / 2))

    local icon_left = PAD + TAG_W + GAP
    self.icon_ctrl:SetLeft(icon_left)

    local text_left = icon_left + ICON_SZ + GAP
    self.label:SetPosition(text_left, 0)
    self.label:SetWidth(math.max(0, w - PAD - BTN_SZ - GAP - text_left))
end

function Options2.Library.ClipboardBar:ClipboardChanged()
    local clip = Options2.clipboard
    if clip.item == nil then
        self:SetVisible(false)
        return
    end

    self:SetVisible(true)
    local P = Options2.Elements.RowParts
    if P.SetNativeIcon(self.icon_ctrl, clip.item.icon) then
        self.icon_ctrl:SetBackColor(nil)
    else
        self.icon_ctrl:SetBackground(nil)
        self.icon_ctrl:SetBackColor(Options.Defaults.window.bg_sunken)
    end
    self.icon_ctrl:SetTop(math.floor((BAR_H - ICON_SZ) / 2))
    self.icon_ctrl:SetLeft(PAD + TAG_W + GAP)

    local w = math.max(0, self.label:GetWidth())
    self.label:SetText(P.Truncate(clip.item.token or "", P.CharBudget(w)))
end
