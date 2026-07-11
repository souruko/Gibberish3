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
    if data.timer ~= nil then
        self.sub_label:SetText(data.timer .. "s")
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
        if args.Button == Turbine.UI.MouseButton.Right
           or self.library._selectedItem == self then
            self.library:SelectItem(self)
        else
            -- pin toggle
            self.data.persistent = not self.data.persistent
            if self.data.persistent then
                Options.KeepInCollection(self.data, self.typeIdx)
            else
                Options.RemoveFromCollection(
                    Options.CheckForIndexInCollection(self.data, self.typeIdx))
            end
            self:_Refresh()
        end
    end
end

function Options2.Library.LibraryItem:SizeChanged()
    local w, h = self:GetSize()
    self.token_label:SetPosition(38, 0)
    self.token_label:SetSize(w - 42, h)
    self.sub_label:SetPosition(38, 0)
    self.sub_label:SetSize(w - 42, h)
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
