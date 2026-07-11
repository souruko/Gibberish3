local ROW_H  = 30
local LEFT   = 5
local TOP    = 8

Options2.Window.FolderEditor = class(Turbine.UI.Control)
function Options2.Window.FolderEditor:Constructor(folderData, folderIndex)
    Turbine.UI.Control.Constructor(self)

    self.data        = folderData
    self.folderIndex = folderIndex

    -- name row
    self.name = Options2.Elements.TextBoxRow(
        Options.Defaults.window.basecolor,
        "options2", "name", "name", ROW_H, false
    )
    self.name:SetParent(self)
    self.name:SetPosition(LEFT, TOP)
    self.name:SetText(folderData.name or "")
end

function Options2.Window.FolderEditor:SizeChanged()
    if self.name == nil then return end
    self.name:SetWidth(self:GetWidth() - LEFT - 5)
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
