local TOOLBAR_H = 30
local CLIP_H    = 54
local SEG_H     = Options.Defaults.window.segment_height

Options2.Library.Window = class(Turbine.UI.Control)
function Options2.Library.Window:Constructor()
    Turbine.UI.Control.Constructor(self)

    self.filterText    = ""
    self._openSeg      = nil
    self._selectedItem = nil

    self:SetBackColor(Options.Defaults.window.backcolor1)

    -- ── filter toolbar ──────────────────────────────────────────────────────
    self.toolbar = Turbine.UI.Control()
    self.toolbar:SetParent(self)
    self.toolbar:SetPosition(0, 0)
    self.toolbar:SetHeight(TOOLBAR_H)
    self.toolbar:SetBackColor(Options.Defaults.window.backcolor2)

    self.filter = Turbine.UI.TextBox()
    self.filter:SetParent(self.toolbar)
    self.filter:SetPosition(4, 4)
    self.filter:SetHeight(TOOLBAR_H - 8)
    self.filter:SetFont(Options.Defaults.window.font)
    self.filter:SetForeColor(Options.Defaults.window.textcolor)
    self.filter:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft)
    self.filter:SetMultiline(false)
    self.filter:SetSelectable(true)
    self.filter.TextChanged = function()
        self.filterText = string.lower(self.filter:GetText())
        self.filter_clear:SetVisible(self.filterText ~= "")
        self:_FilterAll()
    end

    self.filter_icon = Turbine.UI.Control()
    self.filter_icon:SetParent(self.filter)
    self.filter_icon:SetPosition(-2, 0)
    self.filter_icon:SetBlendMode(Turbine.UI.BlendMode.Overlay)
    self.filter_icon:SetBackground("Gibberish3/Resources/search.tga")
    self.filter_icon:SetMouseVisible(false)

    self.filter_clear = Turbine.UI.Button()
    self.filter_clear:SetSize(20, 20)
    self.filter_clear:SetParent(self.filter)
    self.filter_clear:SetText("x")
    self.filter_clear:SetFont(Options.Defaults.window.font)
    self.filter_clear:SetVisible(false)
    self.filter_clear.Click = function()
        self.filter:SetText("")
        self.filterText = ""
        self.filter_clear:SetVisible(false)
        self:_FilterAll()
    end

    -- ── segment listbox ─────────────────────────────────────────────────────
    self.seg_list = Turbine.UI.ListBox()
    self.seg_list:SetParent(self)
    self.seg_list:SetPosition(0, TOOLBAR_H)
    self.seg_list:SetBackColor(Options.Defaults.window.backcolor1)
    self.seg_list:SetMouseVisible(false)

    self.skill_seg = Options2.Library.SegmentItem("segment", "skills", self, 1)

    self.effect_seg = Options2.Library.SegmentItem("segment", "effects", self, 2, function()
        Options.CollectEffects = not Options.CollectEffects
        if Options.CollectEffects then
            local effects = LocalPlayer:GetEffects()
            for i = 1, effects:GetCount() do
                Trigger.AddToEffectCollection(effects:Get(i))
            end
            self:_FillEffects()
        end
        self:_SyncCollectBtns()
    end)

    self.chat_seg = Options2.Library.SegmentItem("segment", "chat", self, 3, function()
        Options.CollectChat = not Options.CollectChat
        self:_SyncCollectBtns()
    end)

    self.seg_list:AddItem(self.skill_seg)
    self.seg_list:AddItem(self.effect_seg)
    self.seg_list:AddItem(self.chat_seg)

    -- ── clipboard bar ───────────────────────────────────────────────────────
    self.clip_bar = Options2.Library.ClipboardBar()
    self.clip_bar:SetParent(self)

    -- ── initial state ───────────────────────────────────────────────────────
    self:_SyncCollectBtns()
    self:_FillSkills()
    self:_FillEffects()
    self:_FillChat()
    self._openSeg = self.skill_seg
end

function Options2.Library.Window:_SyncCollectBtns()
    self.effect_seg:SetToggleActive(Options.CollectEffects)
    self.chat_seg:SetToggleActive(Options.CollectChat)
end

function Options2.Library.Window:_FillSkills()
    local list = {}
    for _, v in ipairs(Data.persistent_collection.skill) do
        list[#list + 1] = v
    end
    local skills = LocalPlayer:GetTrainedSkills()
    for i = 1, skills:GetCount() do
        local sk   = skills:GetItem(i)
        local info = sk:GetSkillInfo()
        local d    = {
            token      = info:GetName(),
            icon       = info:GetIconImageID(),
            timer      = sk:GetCooldown(),
            source     = nil,
            persistent = false,
        }
        if d.timer ~= nil and d.timer > 999999 then d.timer = nil end
        if Options.CheckForIndexInCollection(d, 1) == nil then
            list[#list + 1] = d
        end
    end
    self.skill_seg:SetList(list, self.filterText)
end

function Options2.Library.Window:_FillEffects()
    self.effect_seg:SetList(Options.Collection.Effects, self.filterText)
end

function Options2.Library.Window:_FillChat()
    self.chat_seg:SetList(Options.Collection.Chat, self.filterText)
end

function Options2.Library.Window:_FilterAll()
    self.skill_seg:Filter(self.filterText)
    self.effect_seg:Filter(self.filterText)
    self.chat_seg:Filter(self.filterText)
end

function Options2.Library.Window:SegmentClicked(seg)
    self._openSeg = seg
    self:_ApplyLayout()
end

function Options2.Library.Window:SelectItem(item)
    if self._selectedItem ~= nil then
        self._selectedItem:_Refresh()
    end
    self._selectedItem = item
    item:_Refresh()
    Options2.SetClipboard(item.data, item.typeIdx)
end

function Options2.Library.Window:ClipboardChanged()
    self.clip_bar:ClipboardChanged()
    if Options2.clipboard.item == nil and self._selectedItem ~= nil then
        local prev = self._selectedItem
        self._selectedItem = nil
        prev:_Refresh()
    end
end

function Options2.Library.Window:SizeChanged()
    if self.toolbar == nil then return end
    self:_ApplyLayout()
end

function Options2.Library.Window:_ApplyLayout()
    local w, h = self:GetSize()
    if w == 0 or h == 0 then return end

    self.toolbar:SetSize(w, TOOLBAR_H)
    self.filter:SetSize(w - 8, TOOLBAR_H - 8)
    self.filter_icon:SetSize(TOOLBAR_H, TOOLBAR_H - 8)
    self.filter_clear:SetPosition(w - 26, math.floor((TOOLBAR_H - 8 - 20) / 2))

    local seg_h  = h - TOOLBAR_H - CLIP_H
    local open_h = math.max(0, seg_h - 2 * SEG_H)
    self.seg_list:SetSize(w, seg_h)

    local op = self._openSeg
    self.skill_seg:SetSize(w,  op == self.skill_seg  and open_h or SEG_H)
    self.effect_seg:SetSize(w, op == self.effect_seg and open_h or SEG_H)
    self.chat_seg:SetSize(w,   op == self.chat_seg   and open_h or SEG_H)

    self.clip_bar:SetPosition(0, TOOLBAR_H + seg_h)
    self.clip_bar:SetSize(w, CLIP_H)
end
