Options2.clipboard    = { item = nil, itemType = nil }
Options2.selectedNode = nil

function Options2.NotifyClipboardChanged()
    if Options2.Window.Object == nil then return end
    local obj = Options2.Window.Object
    if obj.library ~= nil and obj.library.ClipboardChanged ~= nil then
        obj.library:ClipboardChanged()
    end
    local ep = obj.editor_panel
    if ep ~= nil and ep.content ~= nil and ep.content.ClipboardChanged ~= nil then
        ep.content:ClipboardChanged()
    end
end

function Options2.SetClipboard(item, itemType)
    Options2.clipboard.item     = item
    Options2.clipboard.itemType = itemType
    Options2.NotifyClipboardChanged()
end

function Options2.ClearClipboard()
    Options2.clipboard.item     = nil
    Options2.clipboard.itemType = nil
    Options2.NotifyClipboardChanged()
end

function Options2.StartUp()
    Options2.Window.Object         = Options2.Window.Constructor()
    Options2.Window.ImportDialogObject = Options2.Window.ImportDialog()
end

function Options2.ShowExport(data, importType, index)
    if Options2.Window.ImportDialogObject == nil then return end
    Options2.Window.ImportDialogObject:ShowExport(data, importType, index)
end

function Options2.ShowImport(context_nd)
    if Options2.Window.ImportDialogObject == nil then return end
    Options2.Window.ImportDialogObject:ShowImport(context_nd)
end

function Options2.SaveNavState(selectedKey)
    Turbine.PluginData.Save(Turbine.DataScope.Character, "gibberish_options2_nav",
        { selectedKey = selectedKey }, nil)
end

function Options2.LoadNavState()
    local state = Turbine.PluginData.Load(Turbine.DataScope.Character, "gibberish_options2_nav", nil)
    if state == nil or type(state.selectedKey) ~= "string" then return nil end
    return state.selectedKey
end
