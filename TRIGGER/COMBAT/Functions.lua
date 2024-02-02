--=================================================================================================
--= Skill         
--= ===============================================================================================
--= trigger from skill reset time changed
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- skill event processing start up
---------------------------------------------------------------------------------------------------
Trigger[Trigger.Types.Combat].Init = function ()

    function LocalPlayer.InCombatChanged( sender, args)
      
        -- all groups
        for windowIndex, windowData in ipairs(Data.window) do
            
            if LocalPlayer:IsInCombat() == true then

                Trigger[Trigger.Types.Combat].CheckWindows( Source.CombatStart, windowIndex, windowData )

            else

                Trigger[Trigger.Types.Combat].CheckWindows( Source.CombatEnd, windowIndex, windowData )

            end

        end

        -- iterate folder data
        for folderIndex, folderData in ipairs(Data.folder) do

            if LocalPlayer:IsInCombat() == true then
                Trigger[Trigger.Types.Combat].CheckFolder( Source.CombatEnd, folderIndex, folderData )
            else
                Trigger[Trigger.Types.Combat].CheckFolder( Source.CombatEnd, folderIndex, folderData )
            end
        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check folder
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.Combat ].CheckFolder = function( combatState, folderIndex, folderData)

    -- check window triggers
    for triggerIndex, triggerData in ipairs(folderData[ Trigger.Types.Combat ]) do
        
        local posAdjustment = Trigger[ Trigger.Types.Combat ].CheckTrigger( combatState, triggerData)

        if posAdjustment ~= nil then
            -- fix posAdjustment
            posAdjustment = posAdjustment - 1
            Windows.FolderAction( folderIndex, folderData, triggerData )

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- skill event processing start up
---------------------------------------------------------------------------------------------------
Trigger[Trigger.Types.Combat].CheckWindows = function ( combatState, windowIndex, windowData )

    -- check window triggers
    for triggerIndex, triggerData in ipairs(windowData[ Trigger.Types.Combat ]) do

        if Trigger[ Trigger.Types.Combat ].CheckTrigger(combatState, triggerData) ~= false then
            Windows.WindowAction( windowIndex, windowData, triggerData )

        end

    end

    -- only check for enabled windows
    if windowData.enabled == false then
        return
    end
    
    -- check the timers of the window
    for timerIndex, timerData in ipairs( windowData.timerList ) do
        Trigger[ Trigger.Types.Combat ].CheckTimer(combatState, windowIndex, timerIndex, timerData)

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- skill event processing start up
---------------------------------------------------------------------------------------------------
Trigger[Trigger.Types.Combat].CheckTimer = function ( combatState, windowIndex, timerIndex, timerData )

    -- only check for enabled timers
    if timerData.enabled == false then
        return
    end

    -- check timer triggers
    for triggerIndex, triggerData in ipairs(timerData[ Trigger.Types.Combat ]) do

        if Trigger[ Trigger.Types.Combat ].CheckTrigger( combatState, triggerData ) ~= false then
            Trigger[ Trigger.Types.Combat ].ProcessTrigger( combatState, windowIndex, timerIndex, triggerIndex )

        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- skill event processing start up
---------------------------------------------------------------------------------------------------
Trigger[Trigger.Types.Combat].CheckTrigger = function ( combatState, triggerData )

    -- only check for enabled trigger
    if triggerData.enabled == false then
        return false
    end

    -- check if combatState matches
    if triggerData.source == Source.Any
    or triggerData.source == combatState then
        return true
    end

    return false

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- process skill trigger
---------------------------------------------------------------------------------------------------
Trigger[ Trigger.Types.Combat ].ProcessTrigger = function ( combatState, windowIndex, timerIndex, triggerIndex )

    -- declarations
    local windowData = Data.window[windowIndex]
    local timerData = windowData.timerList[timerIndex]
    local triggerData = timerData[Trigger.Types.Combat][triggerIndex]

    
    local startTime = Turbine.Engine.GetGameTime()
    local text      = ""
    local duration  = 10
    local icon      = timerData.icon
    local entity    = nil
    local key       = nil

    -- key
    -- every trigger = new timer
    if timerData.stacking == Stacking.Multi then

        key              = CombatTriggerID
        CombatTriggerID  = CombatTriggerID + 1

    else

        key = nil

    end

    -- text
    if timerData.textOption == TimerTextOptions.CustomText then

       text = timerData.textValue

    elseif timerData.textOption == TimerTextOptions.NoText then

        text      = ""

    else

        if combatState == Source.CombatStart then
            text = "Combat Start"
        else
            text = "Combat End"
        end

    end

    -- duration
    if timerData.useCustomTimer == true then

        duration = timerData.timerValue

    end

    -- window call
    Windows[ windowIndex ]:TimerAction( triggerData, timerData, timerIndex, startTime, duration, icon, text, entity, key )


end
---------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------
CombatTriggerID = 1
---------------------------------------------------------------------------------------------------