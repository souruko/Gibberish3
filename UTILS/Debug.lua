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
-- debug command
---------------------------------------------------------------------------------------------------
DebugCommand = Turbine.ShellCommand()

function DebugCommand:Execute( command, arguments )

    if arguments ~= nil and string.find( arguments, "timers" ) ~= nil then
        PrintTimers()
        return
    end

    local memoryBefore = collectgarbage( "count" )
    collectgarbage( "collect" )
    local memoryAfter  = collectgarbage( "count" )

    Turbine.Shell.WriteLine( "--- Gibberish3 debug ---" )
    Turbine.Shell.WriteLine( string.format( "Lua memory: %.0f KB (after GC: %.0f KB)", memoryBefore, memoryAfter ) )

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
    return "Prints Gibberish3 memory usage and timer counts."
end

function DebugCommand:GetShortHelp()
    return "Gibberish3 debug information."
end

Turbine.Shell.AddCommand( "gibdebug", DebugCommand )
---------------------------------------------------------------------------------------------------
