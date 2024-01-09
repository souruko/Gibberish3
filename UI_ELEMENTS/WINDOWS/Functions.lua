--=================================================================================================
--= Window Functions
--= ===============================================================================================
--= window level ui element functions    
--=================================================================================================



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
        Windows[ windowIndex ] = Window[ windowData.type ].Constructor( windowIndex )

    elseif triggerData.action == Action.Disable and windowData.enabled == true then

        --TODO disable window

    elseif  windowData.enabled == true then

        Windows[ windowIndex ]:WindowAction( triggerData )

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Data changed
---------------------------------------------------------------------------------------------------
function Windows.DataChanged( windowIndex )

    if Data.window[ windowIndex ].enabled == true then
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





