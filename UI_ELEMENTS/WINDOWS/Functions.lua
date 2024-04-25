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





