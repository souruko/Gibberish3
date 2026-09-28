--=================================================================================================
--= Window Functions
--= ===============================================================================================
--= window level ui element functions
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- central timer updater
-- instead of every timer getting its own update call from lotro every frame, one control updates
-- all running timers in a fixed interval and does the pending window layouts ( sort / resize )
---------------------------------------------------------------------------------------------------
Windows.ActiveTimers    = {}
Windows.PendingLayouts  = {}

Windows.Updater             = Turbine.UI.Control()
Windows.Updater.lastUpdate  = 0

Windows.Updater.Update = function( sender )

    local gameTime = Turbine.Engine.GetGameTime()

    -- running timers ( throttled )
    if gameTime - Windows.Updater.lastUpdate >= Options.Defaults.timer.updateInterval then

        Windows.Updater.lastUpdate = gameTime

        -- copy first, timers can start / stop other timers while updating
        local timers = {}
        for element, _ in pairs( Windows.ActiveTimers ) do
            timers[ #timers + 1 ] = element
        end

        for i = 1, #timers do
            -- skip timers that got stopped by an earlier timer in this loop
            if Windows.ActiveTimers[ timers[i] ] == true then
                timers[i]:Update( gameTime )
            end
        end

    end

    -- pending layouts ( every frame, so new timers are sorted before they are drawn )
    if next( Windows.PendingLayouts ) ~= nil then

        local windows = Windows.PendingLayouts
        Windows.PendingLayouts = {}

        for window, _ in pairs( windows ) do
            window:ApplyLayout()
        end

    end

    -- nothing to do, stop the updates
    if next( Windows.ActiveTimers ) == nil and next( Windows.PendingLayouts ) == nil then
        Windows.Updater:SetWantsUpdates( false )
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- start / stop the updates of a timer element
---------------------------------------------------------------------------------------------------
function Windows.SetTimerActive( element, value )

    if value == true then

        Windows.ActiveTimers[ element ] = true
        Windows.Updater:SetWantsUpdates( true )

    else

        Windows.ActiveTimers[ element ] = nil

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- returns if a timer element is running
---------------------------------------------------------------------------------------------------
function Windows.IsTimerActive( element )

    return Windows.ActiveTimers[ element ] == true

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- sort / resize a window once in the next frame instead of after every single change
---------------------------------------------------------------------------------------------------
function Windows.RequestLayout( window )

    Windows.PendingLayouts[ window ] = true
    Windows.Updater:SetWantsUpdates( true )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- close all existing windows and create them new
---------------------------------------------------------------------------------------------------
function Windows.StartUp()

    for index, windowData in ipairs(Data.window) do

        if windowData.enabled == true then
           
            -- if window exists close and load new
            if Windows[ index ] ~= nil then

                Windows[ index ]:Finish()

            end

            -- create window element
            Windows[ index ] = Window[ windowData.type ].Constructor( index )

        end
        
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- window selection changed
---------------------------------------------------------------------------------------------------
function Windows.SelectionChanged()

    for index, windowData in ipairs(Data.window) do

        -- if window is enabled and element exists
        if windowData.enabled == true and
           Windows[ index ] ~= nil then

            Windows[ index ]:SelectionChanged()
           
        end
        
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- window selection changed
---------------------------------------------------------------------------------------------------
function Windows.MoveChanged()

    for index, windowData in ipairs(Data.window) do

        -- if window is enabled and element exists
        if windowData.enabled == true and
           Windows[ index ] ~= nil then

            Windows[ index ]:MoveChanged()
           
        end
        
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- window reset all
---------------------------------------------------------------------------------------------------
function Windows.ResetAll()

    for index, windowData in ipairs(Data.window) do

        -- if window is enabled and element exists
        if windowData.enabled == true and
           Windows[ index ] ~= nil then

            Windows[ index ]:Reset()
           
        end
        
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- 
---------------------------------------------------------------------------------------------------
function Windows.WindowAction( windowIndex, windowData, triggerData )

    if triggerData.action == Action.Enable and windowData.enabled == false then
    
        windowData.enabled = true
        Windows.EnabledChanged( windowIndex )
        Options.DataChanged( windowIndex )

    elseif triggerData.action == Action.Disable and windowData.enabled == true then

        windowData.enabled = false
        Windows.EnabledChanged( windowIndex )
        Options.DataChanged( windowIndex )

    elseif windowData.enabled == true 
           and Windows[ windowIndex ] ~= nil then

        Windows[ windowIndex ]:WindowAction( triggerData )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- 
---------------------------------------------------------------------------------------------------
function Windows.FolderAction( folderIndex, folderData, triggerData )

    for index, windowData in ipairs(Data.window) do

        -- if window is enabled and element exists
        if windowData.folder == folderIndex then

            Windows.WindowAction( index, windowData, triggerData )

        end

    end

    for index, data in ipairs(Data.folder) do

        if data.folder == folderIndex then
            Windows.FolderAction( index, folderData, triggerData )
        end
        
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Data changed
---------------------------------------------------------------------------------------------------
function Windows.DataChanged( windowIndex )

    if windowIndex < 1 then
        return
    end

    if Data.window[ windowIndex ].enabled == true and
        Windows[ windowIndex ] ~= nil then
        
        Windows[ windowIndex ]:DataChanged()
        
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Data changed
---------------------------------------------------------------------------------------------------
function Windows.UnloadWindow( windowIndex )

    if Windows[ windowIndex ] ~= nil then
        Windows[ windowIndex ]:Finish()
        Windows[ windowIndex ] = nil
    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Data changed
---------------------------------------------------------------------------------------------------
function Windows.EnabledChanged( windowIndex )

    local windowData = Data.window[ windowIndex ]

    if windowData == nil then
        return
    end

    if windowData.enabled == true then
    
        if Windows[ windowIndex ] ~= nil then
            Windows.UnloadWindow( windowIndex )
        end

        Windows[ windowIndex ] = Window[ windowData.type ].Constructor( windowIndex )

    elseif Windows[ windowIndex ] ~= nil then

        Windows.UnloadWindow( windowIndex )

    end

end
---------------------------------------------------------------------------------------------------





