--=================================================================================================
--= Effect Index
--= ===============================================================================================
--= finds the effect triggers that can match an effect without walking all data
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- effect trigger index
---------------------------------------------------------------------------------------------------
-- Walking every window, timer, condition and folder for every effect costs the
-- same whether a trigger can match or not, so an effect nothing tracks cost as
-- much as one that is tracked. The index lists, per trigger type, the places
-- that hold a trigger of that type, keyed by token, so an event only visits the
-- ones whose token is the effect name. Regex triggers cannot be keyed and are
-- kept in one list that every event visits.
--
-- The entries keep the order the full walk would visit them in (seq), and the
-- two lists are merged by it, so actions fire in the same order as before.
-- Entries hold references into Data: enabled flags and the trigger fields are
-- read live, and the CheckTrigger of the type still compares the token itself.
-- Only a change to the structure or a token makes an index stale, and all of
-- those end in Options.SaveData, which drops every index. Each is rebuilt on
-- the next event of its type.
Trigger.EffectIndex = {}

local ENTRY_WINDOW_TRIGGER   = 1
local ENTRY_TIMER_CONDITIONS = 2
local ENTRY_TIMER_TRIGGER    = 3
local ENTRY_FOLDER_TRIGGER   = 4

-- how each trigger type is checked, by trigger type
local specs   = {}

-- the built indexes, by trigger type
local indexes = {}

local NO_ENTRIES = {}
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- register a trigger type
---------------------------------------------------------------------------------------------------
-- spec.check( effectView, entity, triggerData, entityName )
--     the CheckTrigger of the type, returns the match position or nil
-- spec.folders
--     folder triggers of the type are checked
-- spec.windowTriggersNeedEnabledWindow
--     window triggers only count while their window is enabled
-- spec.conditionDuration
--     a condition without a custom duration runs as long as the effect
-- spec.remove
--     handed to Trigger.ProcessEffectTrigger: the effect is going away
function Trigger.EffectIndex.Register( triggerType, spec )

    spec.triggerType     = triggerType
    specs[ triggerType ] = spec

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- drop all indexes
---------------------------------------------------------------------------------------------------
function Trigger.EffectIndex.InvalidateAll()

    indexes = {}

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- build the index of one trigger type
---------------------------------------------------------------------------------------------------
local function build( spec )

    local triggerType = spec.triggerType
    local index       = { spec = spec, byToken = {}, regex = {}, empty = true }
    local seq         = 0

    -- the list a trigger belongs in, or nil when it can never match
    local function bucket_of( triggerData )

        if triggerData.token == nil then
            return nil
        end

        if triggerData.useRegex == true then
            return index.regex
        end

        local bucket = index.byToken[ triggerData.token ]

        if bucket == nil then
            bucket = {}
            index.byToken[ triggerData.token ] = bucket
        end

        return bucket

    end

    local function add( entry, triggerData )

        local bucket = bucket_of( triggerData )

        if bucket ~= nil then
            seq                   = seq + 1
            entry.seq             = seq
            bucket[ #bucket + 1 ] = entry
            index.empty           = false
        end

    end

    for windowIndex, windowData in ipairs( Data.window ) do

        for _, triggerData in ipairs( windowData[ triggerType ] or {} ) do
            add( { kind = ENTRY_WINDOW_TRIGGER, windowIndex = windowIndex, windowData = windowData, triggerData = triggerData }, triggerData )
        end

        for timerIndex, timerData in ipairs( windowData.timerList or {} ) do

            -- Condition.CheckAll runs over all conditions of the timer, so the
            -- timer gets one entry, placed in every list one of its condition
            -- triggers belongs in. The same entry object in two lists is
            -- visited once, see next_entry.
            local entry  = nil
            local placed = {}

            for _, condition in ipairs( timerData.conditionList or {} ) do

                for _, condTriggerData in ipairs( condition[ triggerType ] or {} ) do

                    local bucket = bucket_of( condTriggerData )

                    if bucket ~= nil and placed[ bucket ] == nil then

                        if entry == nil then
                            seq   = seq + 1
                            entry = { kind = ENTRY_TIMER_CONDITIONS, seq = seq, windowIndex = windowIndex, windowData = windowData, timerData = timerData }
                        end

                        placed[ bucket ]      = true
                        bucket[ #bucket + 1 ] = entry
                        index.empty           = false

                    end

                end

            end

            for _, triggerData in ipairs( timerData[ triggerType ] or {} ) do
                add( { kind = ENTRY_TIMER_TRIGGER, windowIndex = windowIndex, windowData = windowData, timerIndex = timerIndex, timerData = timerData, triggerData = triggerData }, triggerData )
            end

        end

    end

    if spec.folders == true then

        for folderIndex, folderData in ipairs( Data.folder ) do

            for _, triggerData in ipairs( folderData[ triggerType ] or {} ) do
                add( { kind = ENTRY_FOLDER_TRIGGER, folderIndex = folderIndex, folderData = folderData, triggerData = triggerData }, triggerData )
            end

        end

    end

    return index

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- index of one trigger type, built when first asked for
---------------------------------------------------------------------------------------------------
function Trigger.EffectIndex.Get( triggerType )

    local index = indexes[ triggerType ]

    if index == nil then
        index                  = build( specs[ triggerType ] )
        indexes[ triggerType ] = index
    end

    return index

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- run one index entry against an effect
---------------------------------------------------------------------------------------------------
-- does what the full walk over windows, timers and folders did for the one
-- trigger or timer the entry stands for
local function run_entry( spec, entry, effectView, entity, entityName )

    local kind = entry.kind

    if kind == ENTRY_WINDOW_TRIGGER then

        if spec.windowTriggersNeedEnabledWindow == true and entry.windowData.enabled == false then
            return
        end

        if spec.check( effectView, entity, entry.triggerData, entityName ) ~= nil then
            Windows.WindowAction( entry.windowIndex, entry.windowData, entry.triggerData )
        end

        return

    end

    if kind == ENTRY_FOLDER_TRIGGER then

        if spec.check( effectView, entity, entry.triggerData, entityName ) ~= nil then
            Windows.FolderAction( entry.folderIndex, entry.folderData, entry.triggerData )
        end

        return

    end

    -- timers only run in enabled windows, and only when enabled themselves.
    -- Read here and not when the index was built: a window trigger earlier in
    -- the same event may just have switched the window on.
    if entry.windowData.enabled == false or entry.timerData.enabled == false then
        return
    end

    if kind == ENTRY_TIMER_CONDITIONS then

        local effect = nil

        if spec.conditionDuration == true then
            effect = effectView.effect
        end

        Condition.CheckAll( entry.timerData, spec.triggerType, function(t)
            return spec.check( effectView, entity, t, entityName )
        end, nil, effect )

        return

    end

    local posAdjustment = spec.check( effectView, entity, entry.triggerData, entityName )

    if posAdjustment ~= nil then
        -- fix posAdjustment
        posAdjustment = posAdjustment - 1
        Trigger.ProcessEffectTrigger( effectView, entity, posAdjustment, entry.windowIndex, entry.timerIndex, entry.triggerData, spec.remove, entityName )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- cursor over the entries that can match one effect
---------------------------------------------------------------------------------------------------
-- goes through the entries for the effect name and the regex entries together,
-- in seq order
local function new_cursor( index, effectView )

    if index.empty == true then
        return nil
    end

    local exact = index.byToken[ Trigger.EffectName( effectView ) ] or NO_ENTRIES

    if #exact == 0 and #index.regex == 0 then
        return nil
    end

    return { spec = index.spec, exact = exact, regex = index.regex, i = 1, j = 1 }

end

-- the next entry by seq, without moving on; a timer's condition entry can be in
-- both lists, with the same seq, and is visited once
local function next_entry( cursor )

    local a = cursor.exact[ cursor.i ]
    local b = cursor.regex[ cursor.j ]

    if a == nil or ( b ~= nil and b.seq < a.seq ) then
        return b
    end

    return a

end

local function step( cursor, entry )

    if cursor.exact[ cursor.i ] == entry then
        cursor.i = cursor.i + 1
    end

    if cursor.regex[ cursor.j ] == entry then
        cursor.j = cursor.j + 1
    end

end

-- windows come before folders in the full walk
local function position( entry )

    if entry.windowIndex ~= nil then
        return entry.windowIndex
    end

    return #Data.window + entry.folderIndex

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check one effect against the indexes of one or more trigger types
---------------------------------------------------------------------------------------------------
-- The trigger types are run window by window and folder by folder, in the order
-- given: for the effects of the player, the self triggers of a window run
-- before the group triggers of the same window, the way the full walks always
-- did it. Windows and folders without an entry are skipped entirely.
function Trigger.EffectIndex.Check( triggerTypes, effectView, entity, entityName )

    local cursors = {}

    for i = 1, #triggerTypes, 1 do

        local cursor = new_cursor( Trigger.EffectIndex.Get( triggerTypes[i] ), effectView )

        if cursor ~= nil then
            cursors[ #cursors + 1 ] = cursor
        end

    end

    local count = #cursors

    if count == 0 then
        return
    end

    while true do

        -- the first window or folder any cursor still has an entry for
        local nextPosition = nil

        for c = 1, count, 1 do

            local entry = next_entry( cursors[c] )

            if entry ~= nil then

                local p = position( entry )

                if nextPosition == nil or p < nextPosition then
                    nextPosition = p
                end

            end

        end

        if nextPosition == nil then
            return
        end

        -- all entries of that window or folder, one trigger type after the other
        for c = 1, count, 1 do

            local cursor = cursors[c]
            local entry  = next_entry( cursor )

            while entry ~= nil and position( entry ) == nextPosition do

                step( cursor, entry )
                run_entry( cursor.spec, entry, effectView, entity, entityName )

                entry = next_entry( cursor )

            end

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- returns if a trigger type has no trigger at all
---------------------------------------------------------------------------------------------------
function Trigger.EffectIndex.IsEmpty( triggerType )

    return Trigger.EffectIndex.Get( triggerType ).empty == true

end
---------------------------------------------------------------------------------------------------
