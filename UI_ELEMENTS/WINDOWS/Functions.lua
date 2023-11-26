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
-- 
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


