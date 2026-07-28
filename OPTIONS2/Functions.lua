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

-- Persisted panel state. Lives under the historic "gibberish_options2_nav" key and is
-- extended, never replaced, so a save written by an older version still restores.
local _panel_state = {
    selectedKey        = nil,
    structureCollapsed = false,
    libraryCollapsed   = false,
}

local function _WritePanelState()
    Turbine.PluginData.Save(Turbine.DataScope.Character, "gibberish_options2_nav", {
        selectedKey        = _panel_state.selectedKey,
        structureCollapsed = _panel_state.structureCollapsed,
        libraryCollapsed   = _panel_state.libraryCollapsed,
    }, nil)
end

function Options2.StartUp()
    -- PluginData.Load is only synchronous during the plugin load phase; cache it now.
    local state = Turbine.PluginData.Load(Turbine.DataScope.Character, "gibberish_options2_nav", nil)
    if type(state) == "table" then
        if type(state.selectedKey) == "string" then
            _panel_state.selectedKey = state.selectedKey
        end
        if type(state.structureCollapsed) == "boolean" then
            _panel_state.structureCollapsed = state.structureCollapsed
        end
        if type(state.libraryCollapsed) == "boolean" then
            _panel_state.libraryCollapsed = state.libraryCollapsed
        end
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
    _panel_state.selectedKey = selectedKey
    _WritePanelState()
end

function Options2.LoadNavState()
    return _panel_state.selectedKey
end

-- read a persisted panel flag (structureCollapsed / libraryCollapsed)
function Options2.GetPanelState(name)
    return _panel_state[name]
end

-- write a persisted panel flag
function Options2.SetPanelState(name, value)
    _panel_state[name] = value
    _WritePanelState()
end
