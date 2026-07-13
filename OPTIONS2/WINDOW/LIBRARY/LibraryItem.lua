local ITEM_H = Options.Defaults.window.segment_item_height  -- 36

Options2.Library.LibraryItem = class(Turbine.UI.Control)
function Options2.Library.LibraryItem:Constructor(data, typeIdx, library)
    Turbine.UI.Control.Constructor(self)

    self.data    = data
    self.typeIdx = typeIdx
    self.library = library

    self.icon_ctrl = Turbine.UI.Control()
    self.icon_ctrl:SetParent(self)
    self.icon_ctrl:SetPosition(4, 2)
    self.icon_ctrl:SetSize(32, 32)
    self.icon_ctrl:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    self.icon_ctrl:SetMouseVisible(false)
    if data.icon ~= nil then
        self.icon_ctrl:SetBackground(data.icon)
    else
        self.icon_ctrl:SetBackColor(Turbine.UI.Color(0.15, 0.15, 0.15))
    end

    self.token_label = Turbine.UI.Label()
    self.token_label:SetParent(self)
    self.token_label:SetFont(Options.Defaults.window.font)
    self.token_label:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft)
    self.token_label:SetForeColor(Options.Defaults.window.textcolor)
    self.token_label:SetText(data.token or "")
    self.token_label:SetMouseVisible(false)

    self.sub_label = Turbine.UI.Label()
    self.sub_label:SetParent(self)
    self.sub_label:SetFont(Options.Defaults.window.font)
    self.sub_label:SetTextAlignment(Turbine.UI.ContentAlignment.BottomLeft)
    self.sub_label:SetForeColor(Options.Defaults.window.textdark)
    self.sub_label:SetMouseVisible(false)
    if typeIdx == 2 and data.originType ~= nil then
        self.sub_label:SetText(data.originType)
    elseif data.timer ~= nil then
        self.sub_label:SetText(data.timer .. "s")
    end

    -- pin button anchored to right edge (★ = pinned, · = not pinned)
    self.pin_btn = Turbine.UI.Button()
    self.pin_btn:SetParent(self)
    self.pin_btn:SetSize(18, 18)
    self.pin_btn:SetFont(Options.Defaults.window.font)
    self.pin_btn:SetMouseVisible(true)
    self:_RefreshPin()
    self.pin_btn.Click = function()
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

    self:SetHeight(ITEM_H)
    self:_Refresh()

    self.MouseEnter = function()
        if self.library._selectedItem ~= self then
            self:SetBackColor(Options.Defaults.window.segmenthover)
        end
    end
    self.MouseLeave = function()
        self:_Refresh()
    end
    self.MouseClick = function(sender, args)
        if args.Button == Turbine.UI.MouseButton.Right then
            self.data.persistent = not self.data.persistent
            if self.data.persistent then
                Options.KeepInCollection(self.data, self.typeIdx)
            else
                Options.RemoveFromCollection(
                    Options.CheckForIndexInCollection(self.data, self.typeIdx))
            end
            self:_RefreshPin()
            self:_Refresh()
        else
            self.library:SelectItem(self)
        end
    end
end

function Options2.Library.LibraryItem:SizeChanged()
    local w, h = self:GetSize()
    local pin_w  = 18
    local pin_x  = w - pin_w - 2
    local text_w = pin_x - 38 - 4
    self.token_label:SetPosition(38, 0)
    self.token_label:SetSize(text_w, h)
    self.sub_label:SetPosition(38, 0)
    self.sub_label:SetSize(text_w, h)
    self.pin_btn:SetPosition(pin_x, math.floor((h - pin_w) / 2))
end

function Options2.Library.LibraryItem:_RefreshPin()
    if self.data.persistent then
        self.pin_btn:SetText("*")
        self.pin_btn:SetForeColor(Turbine.UI.Color(1.0, 0.85, 0.2))
    else
        self.pin_btn:SetText("o")
        self.pin_btn:SetForeColor(Options.Defaults.window.textdark)
    end
end

function Options2.Library.LibraryItem:_Refresh()
    if self.library._selectedItem == self then
        self:SetBackColor(Turbine.UI.Color(0.1, 0.28, 0.45))
    elseif self.data.persistent then
        self:SetBackColor(Options.Defaults.window.w_window_hover)
    else
        self:SetBackColor(nil)
    end
end
