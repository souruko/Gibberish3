local ROW_H  = Options2.Elements.EditorRow.ROW_H
local LEFT   = 10
local TOP    = 10

-- the metrics that hold text follow the panel's font size; see OPTIONS2/Fonts.lua
Options2.Fonts.Register(function()
    local F = Options2.Fonts
    -- ROW_H is the shared editor row height, so every editor stays in step
    ROW_H = Options2.Elements.EditorRow.ROW_H
end)

Options2.Window.FolderEditor = class(Turbine.UI.Control)
function Options2.Window.FolderEditor:Constructor(folderData, folderIndex)
    Turbine.UI.Control.Constructor(self)

    self.data        = folderData
    self.folderIndex = folderIndex

    -- name row
    self.name = Options2.Elements.TextBoxRow(
        Options.Defaults.window.row_odd,
        "options2", "name", "name", ROW_H, false
    )
    self.name:SetParent(self)
    self.name:SetPosition(LEFT, TOP)
    self.name:SetText(folderData.name or "")
end

function Options2.Window.FolderEditor:SizeChanged()
    if self.name == nil then return end
    self.name:SetWidth(self:GetWidth() - LEFT - LEFT)
end

function Options2.Window.FolderEditor:Load(folderData, folderIndex)
    self.data        = folderData
    self.folderIndex = folderIndex
    self.name:SetText(folderData.name or "")
end

function Options2.Window.FolderEditor:Save()
    self.data.name = self.name:GetText()
end

function Options2.Window.FolderEditor:Reset()
    self.name:SetText(self.data.name or "")
end
