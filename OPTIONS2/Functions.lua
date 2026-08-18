Options2.clipboard    = { item = nil, itemType = nil }
Options2.selectedNode = nil

local _trigger_types = nil

-- every Trigger.Types value, sorted, so menus and rows list them in one order
function Options2.TriggerTypes()
    if _trigger_types == nil then
        _trigger_types = {}
        for _, t in pairs(Trigger.Types) do
            _trigger_types[#_trigger_types + 1] = t
        end
        table.sort(_trigger_types)
    end
    return _trigger_types
end

-- Both list columns push their restored selection into the editor. Every path that
-- does so goes through here so a full refresh can hold them off and set the editor
-- once at the end, instead of letting the columns set it twice.
Options2._holdEditor = false

function Options2.SetEditorNode(nodeData)
    if Options2._holdEditor then return end
    local obj = Options2.Window.Object
    if obj == nil or obj.editor_panel == nil then return end
    obj.editor_panel:SetNode(nodeData)
end

-- Rebuild both list columns. Adding or deleting anything shifts array indices,
-- which invalidates the index-based row caches in both columns.
function Options2.RefreshAll()
    local obj = Options2.Window.Object
    if obj == nil then return end

    -- Left alone the rebuild sets the editor twice - the container from the
    -- structure column, then the row inside it from the contents column. The
    -- second call sees a different node type than the first, so the editor treats
    -- it as a switch and drops the open tab: saving from Style or Animation
    -- landed back on General. Hold the editor, rebuild, then set it once.
    Options2._holdEditor = true
    if obj.nav ~= nil then obj.nav:RebuildFresh() end
    if obj.contents ~= nil then obj.contents:RebuildFresh() end
    Options2._holdEditor = false

    if obj.simple ~= nil then obj.simple:Rebuild() end

    -- a row inside the container outranks the container itself, the same
    -- precedence the panel uses when it first opens
    local nd = nil
    if obj.contents ~= nil and obj.contents.selectedItem ~= nil then
        nd = obj.contents.selectedItem.nodeData
    elseif obj.nav ~= nil and obj.nav.selectedItem ~= nil then
        nd = obj.nav.selectedItem.nodeData
    end
    Options2.SetEditorNode(nd)
end

-- drop the current selection in both columns and empty the editor
function Options2.ClearSelection()
    local obj = Options2.Window.Object
    if obj == nil then return end
    if obj.nav ~= nil then obj.nav.selectedKey = nil end
    if obj.contents ~= nil then obj.contents:ClearSelection() end
    Options2.selectedNode = nil
end

-- Drop the row selection in the contents column only. Deleting a trigger, timer or
-- condition invalidates that column's index-based keys, but the structure column
-- still points at a container that exists, so the user keeps their place.
function Options2.ClearContentSelection()
    local obj = Options2.Window.Object
    if obj == nil then return end
    if obj.contents ~= nil then obj.contents:ClearSelection() end
    Options2.selectedNode = nil
end

function Options2.EffectCollectionChanged()
    local obj = Options2.Window.Object
    if obj ~= nil and obj.library ~= nil then
        obj.library:_FillEffects()
        obj.library:_ApplyLayout()
    end
    Options2.Simple.CollectionChanged()
end

function Options2.ChatCollectionChanged()
    local obj = Options2.Window.Object
    if obj ~= nil and obj.library ~= nil then
        obj.library:_FillChat()
        obj.library:_ApplyLayout()
    end
    Options2.Simple.CollectionChanged()
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

-- ── armed field ────────────────────────────────────────────────────────────────
--
-- Clicking a paste button in the editor arms that field: the library names it,
-- switches to a tab that can fill it, and the next library item clicked writes
-- straight into it. Nothing is armed until the user asks for it.
--   attr  - which library item attribute feeds the field ("token", "icon", ...)
--   types - library tabs that can supply it (1 skills, 2 effects, 3 chat)
--   label - localised field name, shown in the library header
--   set   - receives the value
Options2.armedField = nil

function Options2.ArmField(spec)
    Options2.armedField = spec
    Options2.NotifyArmedFieldChanged()
end

function Options2.ClearArmedField()
    if Options2.armedField == nil then return end
    Options2.armedField = nil
    Options2.NotifyArmedFieldChanged()
end

function Options2.NotifyArmedFieldChanged()
    local obj = Options2.Window.Object
    if obj == nil then return end
    if obj.library ~= nil and obj.library.ArmedFieldChanged ~= nil then
        obj.library:ArmedFieldChanged()
    end
    local ep = obj.editor_panel
    if ep ~= nil and ep.content ~= nil and ep.content.ArmedFieldChanged ~= nil then
        ep.content:ArmedFieldChanged()
    end
end

-- true when this library item could fill whatever is armed
function Options2.CanFillArmedField(item, itemType)
    local armed = Options2.armedField
    if armed == nil or item == nil then return false end
    if item[armed.attr] == nil then return false end
    for _, t in ipairs(armed.types or {}) do
        if t == itemType then return true end
    end
    return false
end

-- writes the item into the armed field and disarms; returns whether it did
function Options2.FillArmedField(item, itemType)
    if not Options2.CanFillArmedField(item, itemType) then return false end
    local armed = Options2.armedField
    armed.set(item[armed.attr])
    Options2.ClearArmedField()
    return true
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

-- ── panel mode ─────────────────────────────────────────────────────────────────
--
-- Advanced is the four-column expert panel; simple edits one timer at a time
-- through a handful of fields. The mode is persisted per character alongside
-- the rest of the panel state, and switching keeps the selection.
Options2.Mode = {
    ADVANCED = 1,
    SIMPLE   = 2,
}

-- Persisted panel state. Lives under the historic "gibberish_options2_nav" key and is
-- extended, never replaced, so a save written by an older version still restores.
local _panel_state = {
    selectedKey        = nil,   -- structure column
    contentKey         = nil,   -- contents column
    structureCollapsed = false,
    libraryCollapsed   = false,
    mode               = Options2.Mode.ADVANCED,
    simpleTimerKey     = nil,   -- simple mode's timers column
}

local function _WritePanelState()
    Turbine.PluginData.Save(Turbine.DataScope.Character, "gibberish_options2_nav", {
        selectedKey        = _panel_state.selectedKey,
        contentKey         = _panel_state.contentKey,
        structureCollapsed = _panel_state.structureCollapsed,
        libraryCollapsed   = _panel_state.libraryCollapsed,
        mode               = _panel_state.mode,
        simpleTimerKey     = _panel_state.simpleTimerKey,
    }, nil)
end

function Options2.StartUp()
    -- PluginData.Load is only synchronous during the plugin load phase; cache it now.
    local state = Turbine.PluginData.Load(Turbine.DataScope.Character, "gibberish_options2_nav", nil)
    if type(state) == "table" then
        if type(state.selectedKey) == "string" then
            _panel_state.selectedKey = state.selectedKey
        end
        if type(state.contentKey) == "string" then
            _panel_state.contentKey = state.contentKey
        end
        if type(state.structureCollapsed) == "boolean" then
            _panel_state.structureCollapsed = state.structureCollapsed
        end
        if type(state.libraryCollapsed) == "boolean" then
            _panel_state.libraryCollapsed = state.libraryCollapsed
        end
        -- a save from before simple mode existed has no mode; it stays advanced
        if state.mode == Options2.Mode.SIMPLE or state.mode == Options2.Mode.ADVANCED then
            _panel_state.mode = state.mode
        end
        if type(state.simpleTimerKey) == "string" then
            _panel_state.simpleTimerKey = state.simpleTimerKey
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
        Options2.Window.Object:Activate()
        Data.options.window.open2 = true
        return
    end

    local obj = Options2.Window.Object
    local now_visible = not obj:IsVisible()
    obj:SetVisible(now_visible)
    -- Activate only raises a window that is already visible, so activate after
    -- showing; otherwise the settings window can end up covering this one.
    if now_visible then obj:Activate() end
    Data.options.window.open2 = now_visible
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

function Options2.SaveContentState(contentKey)
    _panel_state.contentKey = contentKey
    _WritePanelState()
end

function Options2.LoadContentState()
    return _panel_state.contentKey
end

function Options2.GetMode()
    return _panel_state.mode or Options2.Mode.ADVANCED
end

function Options2.SetMode(mode)
    if mode ~= Options2.Mode.SIMPLE and mode ~= Options2.Mode.ADVANCED then return end
    if _panel_state.mode == mode then return end
    _panel_state.mode = mode
    _WritePanelState()

    local obj = Options2.Window.Object
    if obj ~= nil and obj.ApplyMode ~= nil then obj:ApplyMode() end
end

-- ── font size ──────────────────────────────────────────────────────────────────
--
-- Nothing in OPTIONS2 can re-font itself in place: every label takes its font and
-- every row its height when it is built. So a change is applied by building the
-- windows again. That is cheap and loses nothing - the panel restores its mode,
-- both column selections and the collapse flags from the persisted panel state,
-- and every window's position is saved data too.

local function _RebuildUI()
    local obj = Options2.Window.Object
    if obj ~= nil then
        local was_open = obj:IsVisible()
        -- the paste popover is an unparented window, so it would be left behind
        if obj.simple ~= nil then obj.simple.fields:ClosePaste() end
        obj:Close()
        Options2.Window.Object = nil
        if was_open then
            Options2.Window.Object = Options2.Window.Constructor()
            Options2.Window.Object:Activate()
            Data.options.window.open2 = true
        end
    end

    -- built hidden at startup and shown on demand, so it never needs restoring
    if Options2.Window.ImportDialogObject ~= nil then
        Options2.Window.ImportDialogObject:Close()
        Options2.Window.ImportDialogObject = Options2.Window.ImportDialog()
    end

    -- the toolbar button builds its right-click menu once, in its constructor
    if Options.Shortcut.Object ~= nil then
        Options.Shortcut.Object:Close()
        Options.Shortcut.Object = Options.Shortcut.Constructor()
    end

    if Options.Move.Object ~= nil then
        Options.Move.Object:Close()
        Options.Move.Object = nil
        if Data.moveMode == true then
            Options.Move.Object = Options.Move.Constructor()
        end
    end

    -- last, because the change was made in this one
    local settings = Options2.Window.SettingsWindowObject
    if settings ~= nil then
        local was_visible = settings:IsVisible()
        settings:Close()
        Options2.Window.SettingsWindowObject = nil
        if was_visible then
            Options2.Window.SettingsWindowObject = Options2.Window.SettingsWindow()
        end
    end
end

local _rebuild_tick = nil

function Options2.ApplyFontScale(scale)
    if not Options2.Fonts.IsValid(scale) then return end
    if scale == Options2.Fonts.Current() then return end

    Data.options.window.fontScale = scale
    Options.SaveData()

    Options2.Fonts.Apply(scale)

    -- This runs from the settings dropdown's own click handler and the windows
    -- about to be destroyed are that dropdown's ancestors, so rebuild on the
    -- next tick rather than from inside the event. Same trick as the reloader
    -- in UTILS/Load.lua.
    if _rebuild_tick ~= nil then return end

    _rebuild_tick = Turbine.UI.Window()
    _rebuild_tick.Update = function(sender)
        sender:SetWantsUpdates(false)
        _rebuild_tick = nil
        _RebuildUI()
        sender:Close()
    end
    _rebuild_tick:SetWantsUpdates(true)
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
