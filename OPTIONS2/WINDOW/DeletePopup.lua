-- Full-window dark overlay with a centered card, parented to Options2.Window.Object.
-- Usage: Options2.ConfirmDelete(name, fn)  →  shows overlay; calls fn() on confirm.

local _popup = nil

local CARD_W = 280
local CARD_H = 90
local BTN_W  = 110
local BTN_H  = 28
local GAP    = 10

local function _make()
    -- overlay: Window so SetOpacity works; fills the content area of the options window
    local overlay = Turbine.UI.Window()
    overlay:SetBackColor(Turbine.UI.Color(0.1, 0.1, 0.1))
    overlay:SetOpacity(0.9)
    overlay:SetVisible(false)
    overlay:SetMouseVisible(true)  -- blocks clicks on everything underneath

    -- 1px border frame
    local frame = Turbine.UI.Control()
    frame:SetParent(overlay)
    frame:SetSize(CARD_W + 2, CARD_H + 2)
    frame:SetBackColor(Options.Defaults.window.framecolor)
    frame:SetMouseVisible(false)

    local card = Turbine.UI.Control()
    card:SetParent(frame)
    card:SetPosition(1, 1)
    card:SetSize(CARD_W, CARD_H)
    card:SetBackColor(Options.Defaults.window.backcolor1)
    card:SetMouseVisible(false)

    local msg = Turbine.UI.Label()
    msg:SetParent(card)
    msg:SetSize(CARD_W - 20, 40)
    msg:SetPosition(10, 8)
    msg:SetFont(Options.Defaults.window.font)
    msg:SetForeColor(Options.Defaults.window.textcolor)
    msg:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    msg:SetMultiline(true)
    msg:SetMouseVisible(false)

    local btn_top = CARD_H - BTN_H - 10

    -- delete button (red)
    local del = Turbine.UI.Control()
    del:SetParent(card)
    del:SetSize(BTN_W, BTN_H)
    del:SetPosition(math.floor(CARD_W / 2) - BTN_W - math.floor(GAP / 2), btn_top)
    del:SetBackColor(Turbine.UI.Color(0.55, 0.05, 0.05))
    del:SetMouseVisible(true)

    local del_lbl = Turbine.UI.Label()
    del_lbl:SetParent(del)
    del_lbl:SetSize(BTN_W, BTN_H)
    del_lbl:SetFont(Options.Defaults.window.font)
    del_lbl:SetForeColor(Options.Defaults.window.textcolor)
    del_lbl:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    del_lbl:SetText(UTILS.GetText("selection", "delete"))
    del_lbl:SetMouseVisible(false)

    del.MouseEnter = function() del:SetBackColor(Turbine.UI.Color(0.75, 0.08, 0.08)) end
    del.MouseLeave = function() del:SetBackColor(Turbine.UI.Color(0.55, 0.05, 0.05)) end

    -- cancel button
    local can = Turbine.UI.Control()
    can:SetParent(card)
    can:SetSize(BTN_W, BTN_H)
    can:SetPosition(math.floor(CARD_W / 2) + math.floor(GAP / 2), btn_top)
    can:SetBackColor(Options.Defaults.window.backcolor2)
    can:SetMouseVisible(true)

    local can_lbl = Turbine.UI.Label()
    can_lbl:SetParent(can)
    can_lbl:SetSize(BTN_W, BTN_H)
    can_lbl:SetFont(Options.Defaults.window.font)
    can_lbl:SetForeColor(Options.Defaults.window.textcolor)
    can_lbl:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter)
    can_lbl:SetText(UTILS.GetText("selection", "cancel"))
    can_lbl:SetMouseVisible(false)

    can.MouseEnter = function() can:SetBackColor(Options.Defaults.window.hovercolor) end
    can.MouseLeave = function() can:SetBackColor(Options.Defaults.window.backcolor2) end

    local _fn = nil

    local function _hide()
        overlay:SetVisible(false)
        _fn = nil
    end

    del.MouseClick = function()
        local cb = _fn
        _hide()
        if cb then cb() end
    end
    can.MouseClick = function() _hide() end

    overlay.SizeChanged = function()
        local w, h = overlay:GetSize()
        frame:SetPosition(
            math.floor((w - CARD_W - 2) / 2),
            math.floor((h - CARD_H - 2) / 2)
        )
    end

    function overlay:Present(name, fn)
        _fn = fn
        local dname = (name ~= nil and name ~= "") and name or "?"
        msg:SetText('"' .. dname .. '"')

        local parent = Options2.Window.Object
        if parent ~= nil then
            overlay:SetParent(parent)
            local pw, ph = parent:GetSize()
            local top_sp = Options.Defaults.window.top_spacing
            local outer  = Options.Defaults.window.outer_spacing
            overlay:SetPosition(outer, top_sp)
            overlay:SetSize(pw - 2 * outer, ph - top_sp - outer)
        end
        overlay:SetVisible(true)
    end

    return overlay
end

function Options2.ConfirmDelete(name, fn)
    if _popup == nil then _popup = _make() end
    _popup:Present(name, fn)
end
