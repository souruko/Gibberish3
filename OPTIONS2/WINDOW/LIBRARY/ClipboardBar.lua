local HDR_H   = 18
local ITEM_H  = 36
local TOTAL_H = HDR_H + ITEM_H
local ICON_SZ = 28
local BTN_SZ  = 24

Options2.Library.ClipboardBar = class(Turbine.UI.Control)
function Options2.Library.ClipboardBar:Constructor()
    Turbine.UI.Control.Constructor(self)

    self:SetHeight(TOTAL_H)
    self:SetVisible(false)

    -- header bar: "- Clipboard -"
    self.header = Turbine.UI.Label()
    self.header:SetParent(self)
    self.header:SetPosition(0, 0)
    self.header:SetHeight(HDR_H)
    self.header:SetFont(Options.Defaults.window.font)
    self.header:SetForeColor(Options.Defaults.window.textdark)
    self.header:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    self.header:SetBackColor(Turbine.UI.Color(0.06, 0.06, 0.08))
    self.header:SetText("- Copied -")
    self.header:SetMouseVisible(false)

    -- item row
    self.item_row = Turbine.UI.Control()
    self.item_row:SetParent(self)
    self.item_row:SetPosition(0, HDR_H)
    self.item_row:SetHeight(ITEM_H)
    self.item_row:SetBackColor(Turbine.UI.Color(0.08, 0.12, 0.18))

    self.icon_ctrl = Turbine.UI.Control()
    self.icon_ctrl:SetParent(self.item_row)
    self.icon_ctrl:SetPosition(4, math.floor((ITEM_H - ICON_SZ) / 2))
    self.icon_ctrl:SetSize(ICON_SZ, ICON_SZ)
    self.icon_ctrl:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    self.icon_ctrl:SetMouseVisible(false)

    self.label = Turbine.UI.Label()
    self.label:SetParent(self.item_row)
    self.label:SetTop(0)
    self.label:SetHeight(ITEM_H)
    self.label:SetFont(Options.Defaults.window.font)
    self.label:SetForeColor(Options.Defaults.window.textcolor)
    self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.label:SetMouseVisible(false)

    self.clear_btn = Turbine.UI.Button()
    self.clear_btn:SetParent(self.item_row)
    self.clear_btn:SetSize(BTN_SZ, BTN_SZ)
    self.clear_btn:SetText("x")
    self.clear_btn:SetFont(Options.Defaults.window.font)
    self.clear_btn.Click = function() Options2.ClearClipboard() end
end

function Options2.Library.ClipboardBar:SizeChanged()
    if self.label == nil then return end
    local w = self:GetWidth()
    self.header:SetWidth(w)
    self.item_row:SetWidth(w)
    local text_left = 4 + ICON_SZ + 4
    self.label:SetPosition(text_left, 0)
    self.label:SetWidth(w - text_left - BTN_SZ - 8)
    self.clear_btn:SetPosition(w - BTN_SZ - 4, math.floor((ITEM_H - BTN_SZ) / 2))
end

function Options2.Library.ClipboardBar:ClipboardChanged()
    local clip = Options2.clipboard
    if clip.item == nil then
        self:SetVisible(false)
        return
    end
    self:SetVisible(true)
    if clip.item.icon ~= nil then
        self.icon_ctrl:SetBackground(clip.item.icon)
        self.icon_ctrl:SetBackColor(nil)
    else
        self.icon_ctrl:SetBackground(nil)
        self.icon_ctrl:SetBackColor(Turbine.UI.Color(0.15, 0.15, 0.15))
    end
    self.label:SetText(clip.item.token or "")
end
