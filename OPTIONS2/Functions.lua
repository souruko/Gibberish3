Options2.clipboard    = { item = nil, itemType = nil }
Options2.selectedNode = nil

function Options2.EffectCollectionChanged()
    local obj = Options2.Window.Object
    if obj ~= nil and obj.library ~= nil then
        obj.library:_FillEffects()
        obj.library:_ApplyLayout()
    end
end

function Options2.ChatCollectionChanged()
    local obj = Options2.Window.Object
    if obj ~= nil and obj.library ~= nil then
        obj.library:_FillChat()
        obj.library:_ApplyLayout()
    end
end

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

local _cached_nav_key = nil

function Options2.StartUp()
    -- PluginData.Load is only synchronous during the plugin load phase; cache it now.
    local state = Turbine.PluginData.Load(Turbine.DataScope.Character, "gibberish_options2_nav", nil)
    if state ~= nil and type(state.selectedKey) == "string" then
        _cached_nav_key = state.selectedKey
    end

    Options2.Window.ImportDialogObject = Options2.Window.ImportDialog()
    if Data.options.window.open2 == true then
        Options2.Window.Object = Options2.Window.Constructor()
    end
end

function Options2.ToggleWindow()
    if Options2.Window.Object == nil then
        Options2.Window.Object = Options2.Window.Constructor()
        Data.options.window.open2 = true
    else
        local now_visible = not Options2.Window.Object:IsVisible()
        Options2.Window.Object:SetVisible(now_visible)
        Data.options.window.open2 = now_visible
    end
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
    _cached_nav_key = selectedKey
    Turbine.PluginData.Save(Turbine.DataScope.Character, "gibberish_options2_nav",
        { selectedKey = selectedKey }, nil)
end

function Options2.LoadNavState()
    return _cached_nav_key
end
