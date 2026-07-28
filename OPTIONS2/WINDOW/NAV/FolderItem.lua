-- Structure column row: folder.
-- chevron · folder icon · name · [bolt] · child count · enable box

local P = nil   -- resolved lazily; RowParts is imported before this file

local FONT_NAME  = Turbine.UI.Lotro.Font.Verdana12
local FONT_SMALL = Turbine.UI.Lotro.Font.Verdana10


-- a folder has no enabled flag of its own; it reads as enabled when any window
-- below it is enabled, and toggling it loads or unloads the whole subtree
local function folder_enabled(folderIdx)
    for _, wi in ipairs(Folder.GetWindowIndices(folderIdx)) do
        if Data.window[wi] ~= nil and Data.window[wi].enabled == true then return true end
    end
    return false
end

local function child_count(folderIdx)
    local n = 0
    for _, fd in ipairs(Data.folder) do
        if fd.folder == folderIdx then n = n + 1 end
    end
    for _, wd in ipairs(Data.window) do
        if wd.folder == folderIdx then n = n + 1 end
    end
    return n
end

Options2NavFolder = class(Turbine.UI.Control)
function Options2NavFolder:Constructor(navWin, folderIdx, folderData, key, expanded, depth)
    Turbine.UI.Control.Constructor(self)
    P = Options2.Elements.RowParts

    self.navWin   = navWin
    self.key      = key
    self.selected = false
    self.depth    = depth or 0
    self.nodeData = {
        nodeType    = "folder",
        key         = key,
        data        = folderData,
        folderIndex = folderIdx,
    }

    self:SetHeight(P.ROW_H)

    self.rail = P.MakeRail(self, Options.Defaults.window.color_folder)

    self.chevron = P.MakeIcon(self,
        expanded and P.ICON.expanded or P.ICON.collapsed, P.ROW_H, P.CHEVRON)
    self.icon = P.MakeIcon(self, P.ICON.folder, P.ROW_H, P.NODE_ICON)

    self.label = P.MakeLabel(self, FONT_NAME, Options.Defaults.window.color_folder,
        Turbine.UI.ContentAlignment.MiddleLeft)

    self.count = P.MakeLabel(self, FONT_SMALL, Options.Defaults.window.text_faint,
        Turbine.UI.ContentAlignment.MiddleRight)

    self.bolt = P.MakeIcon(self, P.ICON.trigger, P.ROW_H)
    self.bolt:SetVisible(false)

    self.box = P.MakeEnableBox(self, function()
        local indices = Folder.GetWindowIndices(folderIdx)
        if #indices == 0 then return end
        local turn_on = not folder_enabled(folderIdx)
        for _, wi in ipairs(indices) do
            Data.window[wi].enabled = turn_on
            Windows.EnabledChanged(wi)
        end
        Options.SaveData()
        navWin:RefreshEnabledStates()
    end)

    P.WireRow(self, navWin)
    self:_Sync(expanded)
end

-- pulls every display value back off the data
function Options2NavFolder:_Sync(expanded)
    local fd = self.nodeData.data
    local fi = self.nodeData.folderIndex

    self.chevron:SetBackground(expanded and P.ICON.expanded or P.ICON.collapsed)
    self._name = (fd.name ~= nil and fd.name ~= "") and fd.name
        or UTILS.GetText("options2", "unnamed_folder")
    self.count:SetText(tostring(child_count(fi)))
    self.bolt:SetVisible(Options2.Elements.RowParts.HasTriggers(fd, self.navWin.trig_types))
    self.box:SetOn(folder_enabled(fi))

    P.LayoutGuides(self, self.depth)
    self:_Layout()
end

function Options2NavFolder:_Layout()
    local w = self:GetWidth()
    if w <= 0 then return end

    local left = P.ContentLeft(self.depth)
    self.chevron:SetSlotLeft(left)
    self.icon:SetSlotLeft(left + P.CHEVRON + P.GAP)
    local text_left = left + P.CHEVRON + P.GAP + P.NODE_ICON + P.GAP

    -- right to left: enable box, child count, trigger bolt
    local x = w - P.PAD - P.BOX
    self.box:SetLeft(x)

    x = x - P.GAP - 22
    self.count:SetPosition(x, 0)
    self.count:SetWidth(22)

    if self.bolt:IsVisible() then
        x = x - P.GAP - P.ICON_SIZE
        self.bolt:SetLeft(x)
    end

    local text_w = math.max(0, x - P.GAP - text_left)
    self.label:SetPosition(text_left, 0)
    self.label:SetWidth(text_w)
    self.label:SetText(P.Truncate(self._name, P.CharBudget(text_w)))
end

function Options2NavFolder:SizeChanged()
    if self.label == nil then return end
    self:_Layout()
end

function Options2NavFolder:SetSelected(v)
    Options2.Elements.RowParts.ApplySelected(self, v)
end

function Options2NavFolder:GetKey()       return self.key end
function Options2NavFolder:IsExpandable() return true end

function Options2NavFolder:SetExpanded(v)
    local P = Options2.Elements.RowParts
    self.chevron:SetBackground(v and P.ICON.expanded or P.ICON.collapsed)
end

function Options2NavFolder:RefreshEnabled()
    self.box:SetOn(folder_enabled(self.nodeData.folderIndex))
end

function Options2NavFolder:Refresh(expanded, depth)
    self.depth = depth or 0
    Options2.Elements.RowParts.ApplySelected(self, false)
    self:_Sync(expanded)
end
