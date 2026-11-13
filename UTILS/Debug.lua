--=================================================================================================
--= Debug
--= ===============================================================================================
--= /gibdebug shell command to print memory usage and timer counts
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- color as short text
---------------------------------------------------------------------------------------------------
local function ColorText( color )

    if color == nil then
        return "nil"
    end

    return string.format( "%.2f/%.2f/%.2f/%.2f", color.R, color.G, color.B, color.A )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- /gibdebug timers: visual state of every running timer
---------------------------------------------------------------------------------------------------
local function PrintTimers()

    local gameTime = Turbine.Engine.GetGameTime()

    Turbine.Shell.WriteLine( "--- Gibberish3 timers ---" )

    for windowIndex, windowData in ipairs( Data.window ) do

        local window = Windows[ windowIndex ]

        if window ~= nil and window.children ~= nil and #window.children > 0 then

            Turbine.Shell.WriteLine( string.format( "[%d] %s", windowIndex, tostring( windowData.name ) ) )

            for i, child in ipairs( window.children ) do

                local line = string.format( "  #%d timer %s reused %d active %s left %.1f dur %s opacity %.2f threshold %s",
                    i,
                    tostring( child.index ),
                    child.reuseCount or 0,
                    tostring( Windows.IsTimerActive( child ) ),
                    ( child.endTime or 0 ) - gameTime,
                    tostring( child.duration ),
                    child:GetOpacity(),
                    tostring( child._inThreshold ) )

                -- bar timers
                if child.bar ~= nil and child.barBack ~= nil then
                    line = line .. string.format( " | bar w %d (cache %s) vis %s col %s | barBack col %s | barBase vis %s z %d",
                        child.bar:GetWidth(),
                        tostring( child._lastBarWidth ),
                        tostring( child.bar:IsVisible() ),
                        ColorText( child.bar:GetBackColor() ),
                        ColorText( child.barBack:GetBackColor() ),
                        tostring( child.barBase:IsVisible() ),
                        child.barBase:GetZOrder() )
                end

                Turbine.Shell.WriteLine( line )

            end

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- /gibdebug save: what one data save costs
---------------------------------------------------------------------------------------------------
-- Options.SaveData writes the whole of Data twice, character scope and account scope, and the
-- client stands still while it does. A trigger that turns a window or a timer on or off changes
-- the data and so needs a save, and a trait line swap can fire a whole set of those at once, which
-- is how the saving - not the switching - ends up freezing the game. This times one save, and
-- counts how many the triggers have asked for since the plugin loaded.
local function PrintSaveCost()

    local windowCount, timerCount, triggerCount = 0, 0, 0

    -- trigger lists sit under the numeric trigger type, on windows, timers, conditions and folders
    local function CountTriggers( holder )

        for _, triggerType in pairs( Trigger.Types ) do

            local list = holder[ triggerType ]

            if type( list ) == "table" then
                triggerCount = triggerCount + #list
            end

        end

    end

    for _, folderData in ipairs( Data.folder ) do
        CountTriggers( folderData )
    end

    for _, windowData in ipairs( Data.window ) do

        windowCount = windowCount + 1
        CountTriggers( windowData )

        for _, timerData in ipairs( windowData.timerList or {} ) do

            timerCount = timerCount + 1
            CountTriggers( timerData )

            for _, conditionData in ipairs( timerData.conditionList or {} ) do
                CountTriggers( conditionData )
            end

        end

    end

    local start = Turbine.Engine.GetGameTime()
    Options.SaveData()
    local spent = Turbine.Engine.GetGameTime() - start

    Turbine.Shell.WriteLine( "--- Gibberish3 save cost ---" )
    Turbine.Shell.WriteLine( string.format( "%d windows, %d timers, %d triggers", windowCount, timerCount, triggerCount ) )
    Turbine.Shell.WriteLine( string.format( "One save ( character and account scope ): %.0f ms", spent * 1000 ) )
    Turbine.Shell.WriteLine( string.format( "Since load: %d enable flags flipped by a trigger, %d saves written for them", DebugStats.enableToggles, DebugStats.dataSaves ) )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- debug command
---------------------------------------------------------------------------------------------------
DebugCommand = Turbine.ShellCommand()

function DebugCommand:Execute( command, arguments )

    if arguments ~= nil and string.find( arguments, "timers" ) ~= nil then
        PrintTimers()
        return
    end

    if arguments ~= nil and string.find( arguments, "save" ) ~= nil then
        PrintSaveCost()
        return
    end

    local memoryBefore = collectgarbage( "count" )
    collectgarbage( "collect" )
    local memoryAfter  = collectgarbage( "count" )

    Turbine.Shell.WriteLine( "--- Gibberish3 debug ---" )
    Turbine.Shell.WriteLine( string.format( "Lua memory: %.0f KB (after GC: %.0f KB)", memoryBefore, memoryAfter ) )

    -- "Use Global Scaling" in the plugin manager. Since update 49.6 that
    -- checkbox is what puts a plugin into ui scaling mode, and images are only
    -- stretched to the size they are given while it is on
    local usesScaling = "unknown"

    -- kept by Main.lua, the only file lotro hands the plugin object to
    pcall( function()
        usesScaling = tostring( Options.Plugin:GetUsesGlobalScaling() )
    end )

    -- older clients have no such method, so say so rather than nothing
    if usesScaling == "unknown" and Options.Plugin ~= nil then
        usesScaling = "not supported by this client"
    end

    Turbine.Shell.WriteLine( "Use Global Scaling: " .. usesScaling )

    -- target tracking
    local targetTrigger = Trigger[ Trigger.Types.EffectTarget ]
    local tracking = "off"
    if Data.trackTargetEffects == true then
        tracking = "on"
    end
    if targetTrigger.IsTracking ~= nil then
        tracking = tracking .. ", target registered: " .. tostring( targetTrigger.IsTracking() )
    end
    Turbine.Shell.WriteLine( "Target tracking: " .. tracking )

    -- group tracking
    local groupTrigger  = Trigger[ Trigger.Types.EffectGroup ]
    local groupTracking = "off"
    if Data.trackGroupEffects == true then
        groupTracking = "on"
    end
    if groupTrigger.TrackedCount ~= nil then
        groupTracking = groupTracking .. ", members registered: " .. tostring( groupTrigger.TrackedCount() )
    end
    Turbine.Shell.WriteLine( "Group tracking: " .. groupTracking )

    -- prime parse integration ( the savefile Prime Parse reads )
    local exportState = "off"
    if Data.exportGroupSetup == true then
        exportState = "on"
        if GroupSetup.Enabled() == false then
            exportState = exportState .. ", idle: needs group tracking"
        elseif groupTrigger.party == nil then
            exportState = exportState .. ", idle: not in a group"
        else
            exportState = exportState .. ", own line: " .. tostring( GroupSetup.DetectOwnLine() )
        end
    end
    Turbine.Shell.WriteLine( "Prime Parse integration: " .. exportState )

    -- what it would pass along right now, so it can be checked without leaving the game
    if Data.exportGroupSetup == true and GroupSetup.Enabled() == true and groupTrigger.party ~= nil then
        for playerName, record in pairs( GroupSetup.roster ) do
            Turbine.Shell.WriteLine( "   " .. playerName
                .. " | " .. tostring( record.className )
                .. " | " .. tostring( record.line ) )
        end
    end

    -- timers per window
    local totalTimers = 0
    local totalActiv  = 0

    for windowIndex, windowData in ipairs( Data.window ) do

        local window = Windows[ windowIndex ]

        if window ~= nil and window.children ~= nil then

            local count = 0
            local activ = 0
            local pooled = 0

            if window.pool ~= nil then
                pooled = #window.pool
            end

            for index, child in pairs( window.children ) do
                count = count + 1
                if Windows.IsTimerActive( child ) == true then
                    activ = activ + 1
                end
            end

            totalTimers = totalTimers + count
            totalActiv  = totalActiv + activ

            if count > 0 or pooled > 0 then
                Turbine.Shell.WriteLine( string.format( "  [%d] %s: %d timer (%d running), %d in pool", windowIndex, tostring( windowData.name ), count, activ, pooled ) )
            end

        end

    end

    Turbine.Shell.WriteLine( string.format( "Timers total: %d (%d running)", totalTimers, totalActiv ) )

    -- counters since plugin load
    Turbine.Shell.WriteLine( string.format( "Since load: %d timer elements created, %d reused, %d target changes", DebugStats.timersCreated, DebugStats.timersReused, DebugStats.targetChanges ) )
    Turbine.Shell.WriteLine( string.format( "Duplicate target effects skipped: %d", DebugStats.effectsSkipped ) )

end

function DebugCommand:GetHelp()
    return "Prints Gibberish3 memory usage and timer counts. 'timers' for the state of every running timer, 'save' for what one data save costs."
end

function DebugCommand:GetShortHelp()
    return "Gibberish3 debug information."
end

Turbine.Shell.AddCommand( "gibdebug", DebugCommand )
---------------------------------------------------------------------------------------------------
