--=================================================================================================
--= Effect Group          
--= ===============================================================================================
--= trigger from effect group events
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- effect group event processing start up
---------------------------------------------------------------------------------------------------
-- members of the party that currently have a callback registered, by name
Trigger[ Trigger.Types.EffectGroup ].tracked = {}
Trigger[ Trigger.Types.EffectGroup ].party   = nil

Trigger[Trigger.Types.EffectGroup].Init = function ()

    -- only the first GetParty works, so it is read once here and kept. A party
    -- change reloads the plugin, by way of the auto reload on the party messages
    -- in chat, and that runs this again with a fresh one.
    Trigger[ Trigger.Types.EffectGroup ].party = LocalPlayer:GetParty()

    Trigger[ Trigger.Types.EffectGroup ].Sync()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- bring the registered callbacks in line with the current party
---------------------------------------------------------------------------------------------------
-- called at start up and whenever group tracking is switched on or off, so that
-- switching it on registers the callbacks instead of leaving them until the next
-- reload. Works off the party read at start up: it never asks the game again.
Trigger[ Trigger.Types.EffectGroup ].Sync = function ()

    local tracked = Trigger[ Trigger.Types.EffectGroup ].tracked
    local present = {}

    -- track group
    if  Data.trackGroupEffects == true then

        local party = Trigger[ Trigger.Types.EffectGroup ].party

        -- party exists
        if party ~= nil then

            local localPlayerName = LpData.name

            -- iterate member
            for i = 1, party:GetMemberCount(), 1 do

                local player     = party:GetMember(i)
                local playerName = player:GetName()

                -- if member ~= lp
                if playerName ~= localPlayerName then

                    present[ playerName ] = true

                    -- only members that are not tracked yet are registered and
                    -- swept, so one member joining does not check the active
                    -- effects of everyone already in the party a second time
                    if tracked[ playerName ] == nil then

                        tracked[ playerName ] = Trigger[ Trigger.Types.EffectGroup ].Register( player, playerName )

                        Trigger[ Trigger.Types.EffectGroup ].CheckMemberEffects( player, playerName )

                    end

                end

            end

        end

    end

    -- everyone who left, and everyone at all once tracking is switched off
    for playerName, record in pairs( tracked ) do

        if present[ playerName ] ~= true then

            record.active = false
            Trigger.RemoveCallback( record.effects, "EffectAdded", record.callback )
            tracked[ playerName ] = nil

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- register the effect callback of one party member
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectGroup ].Register = function ( player, playerName )

    local effects = player:GetEffects()
    local record  = { effects = effects, active = true }

    -- add
    record.callback = Trigger.AddCallback( effects, "EffectAdded", function ( sender, args )

        -- a callback can outlive the member it was registered for, and tracking
        -- can be switched off without the plugin being reloaded
        if record.active ~= true or Data.trackGroupEffects ~= true then
            return
        end

        local index = Trigger[ Trigger.Types.EffectGroup ].GetIndex()

        -- without a single group trigger there is nothing to check, so the
        -- effect is not even read unless it is being collected
        if index.empty == true and Options.CollectEffects == false then
            return
        end

        local effect = effects:Get(args.Index)

        -- read the effect once for the whole event instead of once per trigger
        local effectView = Trigger.NewEffectView( effect )

        Trigger.AddToEffectCollection( effect, "Group", effectView )

        Trigger[ Trigger.Types.EffectGroup ].Dispatch( index, effectView, player, playerName )

    end )

    return record

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check the active effects of one party member
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectGroup ].CheckMemberEffects = function ( player, playerName )

    local index = Trigger[ Trigger.Types.EffectGroup ].GetIndex()

    if index.empty == true then
        return
    end

    local effects = player:GetEffects()

    -- iterate effects
    for j = 1, effects:GetCount(), 1 do

        local effectView = Trigger.NewEffectView( effects:Get(j) )

        Trigger[ Trigger.Types.EffectGroup ].Dispatch( index, effectView, player, playerName )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- trigger index
---------------------------------------------------------------------------------------------------
-- Walking every window, timer, condition and folder for every effect of every
-- party member costs the same whether a trigger can match or not. The index
-- lists the places that hold a group trigger, keyed by token, so an event only
-- visits the ones whose token is the effect name. Regex triggers cannot be
-- keyed and are kept in one list that every event visits.
--
-- The entries keep the order the full walk would visit them in (seq), and the
-- two lists are merged by it, so actions fire in the same order as before.
-- Entries hold references into Data: enabled flags and the trigger fields are
-- read live, CheckTrigger still compares the token itself. Only a change to
-- the structure or a token makes the index stale, and all of those end in
-- Options.SaveData, which drops it. It is rebuilt on the next event.
local ENTRY_WINDOW_TRIGGER   = 1
local ENTRY_TIMER_CONDITIONS = 2
local ENTRY_TIMER_TRIGGER    = 3
local ENTRY_FOLDER_TRIGGER   = 4

Trigger[ Trigger.Types.EffectGroup ].index = nil

Trigger[ Trigger.Types.EffectGroup ].InvalidateIndex = function ()

    Trigger[ Trigger.Types.EffectGroup ].index = nil

end

Trigger[ Trigger.Types.EffectGroup ].BuildIndex = function ()

    local groupType = Trigger.Types.EffectGroup
    local index     = { byToken = {}, regex = {}, empty = true }
    local seq       = 0

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

        for _, triggerData in ipairs( windowData[ groupType ] or {} ) do
            add( { kind = ENTRY_WINDOW_TRIGGER, windowIndex = windowIndex, windowData = windowData, triggerData = triggerData }, triggerData )
        end

        for timerIndex, timerData in ipairs( windowData.timerList or {} ) do

            -- Condition.CheckAll runs over all conditions of the timer, so the
            -- timer gets one entry, placed in every list one of its condition
            -- triggers belongs in. The same entry object in two lists is
            -- visited once, see Dispatch.
            local entry  = nil
            local placed = {}

            for _, condition in ipairs( timerData.conditionList or {} ) do

                for _, condTriggerData in ipairs( condition[ groupType ] or {} ) do

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

            for _, triggerData in ipairs( timerData[ groupType ] or {} ) do
                add( { kind = ENTRY_TIMER_TRIGGER, windowIndex = windowIndex, windowData = windowData, timerIndex = timerIndex, timerData = timerData, triggerData = triggerData }, triggerData )
            end

        end

    end

    for folderIndex, folderData in ipairs( Data.folder ) do

        for _, triggerData in ipairs( folderData[ groupType ] or {} ) do
            add( { kind = ENTRY_FOLDER_TRIGGER, folderIndex = folderIndex, folderData = folderData, triggerData = triggerData }, triggerData )
        end

    end

    return index

end

Trigger[ Trigger.Types.EffectGroup ].GetIndex = function ()

    local index = Trigger[ Trigger.Types.EffectGroup ].index

    if index == nil then
        index = Trigger[ Trigger.Types.EffectGroup ].BuildIndex()
        Trigger[ Trigger.Types.EffectGroup ].index = index
    end

    return index

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- run one index entry against an effect
---------------------------------------------------------------------------------------------------
-- does what CheckWindows, CheckTimer and CheckFolder do for the one trigger or
-- timer the entry stands for
local function run_entry( entry, effectView, player, playerName )

    local kind = entry.kind

    if kind == ENTRY_WINDOW_TRIGGER then

        if Trigger[ Trigger.Types.EffectGroup ].CheckTrigger( effectView, player, entry.triggerData, playerName ) ~= nil then
            Windows.WindowAction( entry.windowIndex, entry.windowData, entry.triggerData )
        end

        return

    end

    if kind == ENTRY_FOLDER_TRIGGER then

        if Trigger[ Trigger.Types.EffectGroup ].CheckTrigger( effectView, player, entry.triggerData, playerName ) ~= nil then
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

        Condition.CheckAll( entry.timerData, Trigger.Types.EffectGroup, function(t)
            return Trigger[ Trigger.Types.EffectGroup ].CheckTrigger( effectView, player, t, playerName )
        end, nil, effectView.effect )

        return

    end

    local posAdjustment = Trigger[ Trigger.Types.EffectGroup ].CheckTrigger( effectView, player, entry.triggerData, playerName )

    if posAdjustment ~= nil then
        -- fix posAdjustment
        posAdjustment = posAdjustment - 1
        Trigger.ProcessEffectTrigger( effectView.effect, player, posAdjustment, entry.windowIndex, entry.timerIndex, entry.triggerData, nil, playerName )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check one effect of a party member against the index
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectGroup ].Dispatch = function ( index, effectView, player, playerName )

    local regex = index.regex
    local exact = index.byToken[ Trigger.EffectName( effectView ) ]

    if exact == nil then

        for i = 1, #regex, 1 do
            run_entry( regex[i], effectView, player, playerName )
        end

        return

    end

    -- merge both lists by seq; a timer's condition entry can sit in both
    local i, j   = 1, 1
    local ni, nj = #exact, #regex

    while i <= ni or j <= nj do

        local a = exact[i]
        local b = regex[j]

        if b == nil or ( a ~= nil and a.seq < b.seq ) then
            run_entry( a, effectView, player, playerName )
            i = i + 1
        elseif a == nil or b.seq < a.seq then
            run_entry( b, effectView, player, playerName )
            j = j + 1
        else
            run_entry( a, effectView, player, playerName )
            i = i + 1
            j = j + 1
        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check folder
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectGroup ].CheckFolder = function(effectView, player, folderIndex, folderData, playerName)

    -- check window triggers
    for triggerIndex, triggerData in ipairs(folderData[ Trigger.Types.EffectGroup ]) do
        
        local posAdjustment = Trigger[ Trigger.Types.EffectGroup ].CheckTrigger(effectView, player, triggerData, playerName)

        if posAdjustment ~= nil then
            -- fix posAdjustment
            posAdjustment = posAdjustment - 1
            Windows.FolderAction( folderIndex, folderData, triggerData )

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check windows
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectGroup ].CheckWindows = function ( effectView, player, windowIndex, windowData, playerName )

    -- check window triggers
    for triggerIndex, triggerData in ipairs(windowData[ Trigger.Types.EffectGroup ]) do
        local posAdjustment = Trigger[ Trigger.Types.EffectGroup ].CheckTrigger(effectView, player, triggerData, playerName)

        if posAdjustment ~= nil then
            Windows.WindowAction( windowIndex, windowData, triggerData )

        end

    end

    -- only check for enabled windows
    if windowData.enabled == false then
        return
    end

    -- check the timers of the window
    for timerIndex, timerData in ipairs( windowData.timerList ) do
        Trigger[ Trigger.Types.EffectGroup ].CheckTimer(effectView, player, windowIndex, timerIndex, timerData, playerName)

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check timer
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.EffectGroup ].CheckTimer = function ( effectView, player, windowIndex, timerIndex, timerData, playerName )

    -- only check for enabled timers
    if timerData.enabled == false then
        return
    end

    if Condition.HasAny( timerData ) then
        Condition.CheckAll( timerData, Trigger.Types.EffectGroup, function(t)
            return Trigger[ Trigger.Types.EffectGroup ].CheckTrigger(effectView, player, t, playerName)
        end, nil, effectView.effect)
    end

    -- check timer triggers
    for triggerIndex, triggerData in ipairs(timerData[ Trigger.Types.EffectGroup ]) do

        local posAdjustment = Trigger[ Trigger.Types.EffectGroup ].CheckTrigger(effectView, player, triggerData, playerName)

        if posAdjustment ~= nil then
            -- fix posAdjustment
            posAdjustment = posAdjustment - 1
            Trigger.ProcessEffectTrigger( effectView.effect, player, posAdjustment, windowIndex, timerIndex, triggerData, nil, playerName )

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check trigger
---------------------------------------------------------------------------------------------------
-- the checks are ordered by what they cost: everything that can be answered from
-- the trigger itself, or from a value already read, runs before the first call
-- into the game
Trigger[ Trigger.Types.EffectGroup ].CheckTrigger = function ( effectView, player, triggerData, playerName )

    -- only check for enabled trigger
    if triggerData.enabled == false then
        return nil
    end

    local effectName = Trigger.EffectName( effectView )
    local match      = 1

    -- check token
    if triggerData.useRegex == true then

        if triggerData._cachedPattern == nil then
            triggerData._cachedPattern = Trigger.ReplacePlaceholder(triggerData.token)
        end

        match = string.find( effectName, triggerData._cachedPattern )

        if match == nil then
            return nil
        end

    elseif effectName ~= triggerData.token then

        return nil

    end

    -- exclude self
    if triggerData.excludeSelf == true and player == LocalPlayer then
        return nil
    end

    -- listOfTargets
    -- reading the name is a call into the game, so only ask for it when there is
    -- a list to check it against
    local listOfTargets = triggerData.listOfTargets

    if listOfTargets ~= nil and #listOfTargets > 0 then

        if playerName == nil then
            playerName = player:GetName()
        end

        if Trigger.CheckListForName( playerName, listOfTargets ) == false then
            return nil
        end

    end

    -- icon
    if triggerData.icon ~= nil and triggerData.icon ~= Trigger.EffectIcon( effectView ) then
        return nil
    end

    -- debuff / buff
    if triggerData.isDebuff ~= Source.Any
        and (Trigger.EffectIsDebuff( effectView ) ~= (triggerData.isDebuff == Source.Debuff)) then
        return nil
    end

    -- dispellable
    if triggerData.isDispellable ~= Source.Any
        and (Trigger.EffectIsCurable( effectView ) ~= (triggerData.isDispellable == Source.Dispellable)) then
        return nil
    end

    -- category
    if triggerData.category ~= Source.Any
        and (Trigger.EffectCategory( effectView ) ~= triggerData.category) then
        return nil
    end

    return match

end
---------------------------------------------------------------------------------------------------
