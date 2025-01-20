--=================================================================================================
--= Export Functions        
--= ===============================================================================================
--= 
--=================================================================================================

---------------------------------------------------------------------------------------------------
function DataToString( data, type, index )

    local text = "```Gibberish3/" .. tostring(type)

    if type == ImportType.Window then
        text = text .. WindowToString( data )

    elseif type == ImportType.Folder then
        text = text .. FolderToString( data, index )

    elseif type == ImportType.Timer then
        text = text .. TimerToString( data )

    elseif type == ImportType.Trigger then
        text = text .. TriggerToString( data )

    elseif type == ImportType.WindowList then
        for index, window_data in ipairs(data) do   
            text = text .. WindowToString( window_data )
        end

    elseif type == ImportType.TimerList then
        for index, window_data in ipairs(data) do   
            text = text .. TimerToString( window_data )
        end

    elseif type == ImportType.TriggerList then
        for index, window_data in ipairs(data) do   
            text = text .. TriggerToString( window_data )
        end

    end

    text = text .. "```\n"

    return text

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function WindowToString( data )

    local text = "<window>"

    for key, value in pairs(data) do

        if type(value) == "table" then

            -- colors
            if  key == "color1" or
                key == "color2" or
                key == "color3" or
                key == "color4" or
                key == "color5" or
                key == "color6" or
                key == "color7" or
                key == "color8" or
                key == "color9" then
                
                text = text  .. key .. ":{"
                for k, v in pairs(value) do
                    text = text .. k .. ":<" .. v .. ">:"
                end
                text = text .. "}:"
            end

        else

            text = text  .. key .. ":{" .. tostring(value) .. "}:"
        
        end

    end

    -- window triggers
    for name, index in pairs(Trigger.Types) do
        for i, trigger_data in ipairs(data[index]) do
            text = text .. TriggerToString( trigger_data )
        end
    end

    -- timers
    for index, timer_data in ipairs(data.timerList) do
        text = text .. TimerToString( timer_data )
    end

    return text

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TimerToString( data )

    local text = "<timer>"


    for key, value in pairs(data) do

        if type(value) == "table" then

        else

            text = text  .. key .. ":{" .. tostring(value) .. "}:"
        
        end

    end

    -- timer triggers
    for name, index in pairs(Trigger.Types) do
        for i, trigger_data in ipairs(data[index]) do
            text = text .. TriggerToString( trigger_data )
        end
    end


    return text

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function TriggerToString( data )

    local text = "<trigger>"

    for key, value in pairs(data) do

        if type(value) == "table" then

            -- list of Targets
            if key == "listOfTargets" then
                
                text = text  .. key .. ":{" .. tostring( ListOfTargetsToString( value ) ) .. "}:"

            end

        else

            text = text  .. key .. ":{" .. tostring(value) .. "}:"
        
        end

    end

    return text

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
function FolderToString( data, index )

    local text = "<folder>index:{" .. index .. "}:"

    for key, value in pairs(data) do

        if type(value) == "table" then

        else
            text = text  .. key .. ":{" .. tostring(value) .. "}:"
        
        end

    end
    
    -- folder triggers
    for name, i in pairs(Trigger.Types) do
        for j, trigger_data in ipairs(data[i]) do
            text = text .. TriggerToString( trigger_data )
        end
    end

    -- windows
    for i, window_data in ipairs(Data.window) do
        if window_data.folder == index then
            text = text .. WindowToString( window_data )
        end
    end

    -- folders recursive
    for i, folder_data in ipairs(Data.folder) do
        if folder_data.folder == index then
            text = text .. FolderToString( folder_data, i )
        end
    end
  
    return text

end
---------------------------------------------------------------------------------------------------