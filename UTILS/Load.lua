--=================================================================================================
--= Load        
--= ===============================================================================================
--= 
--=================================================================================================

--this is just to unload the reloader plugin if it is loaded on load up
local status  = 0
Close_reload_plugin = Turbine.UI.Window()
 
function Close_reload_plugin:Update()
	if status == 1 then
        Turbine.PluginManager.UnloadScriptState( "Gibberish3Reloader" )
    elseif status > 1 then
        self:SetWantsUpdates( false )
        self:Close()
        Close_reload_plugin = nil
	end

    status = status + 1
end

Close_reload_plugin:SetWantsUpdates( true )
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- load data
---------------------------------------------------------------------------------------------------
function Options.LoadData()

    -- account data
    local global_data = Turbine.PluginData.Load( Turbine.DataScope.Account, "gibberish_global_" .. Language[ Language.Local ], nil)

    -- no global data > create new data struct
    if global_data == nil then
        return DataFunction.New()

    end

    -- fix data for non english clients
    if Language.Local ~= Language.English then
        global_data = Options.ConvertFromEuro( global_data )

    end

    -- char data
    local char_data = Turbine.PluginData.Load( Turbine.DataScope.Character, "gibberish_char_" .. Language[ Language.Local ], nil)

    -- no char data > use global_data
    if char_data == nil then
        return global_data

    end

    return Options.OverwriteCharData( global_data, char_data )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- overwrite global data with char data
---------------------------------------------------------------------------------------------------
function Options.OverwriteCharData( global_data, char_data )

    -- windows
    for index, window_data in ipairs( global_data.window ) do
        local data = Options.GetWindowByID( window_data.id, char_data )

        -- new color fix delete later
        if window_data.color6 == nil then
            window_data.color6 = {R=0, G=0, B=0}
        end
        if window_data.color7 == nil then
            window_data.color7 = {R=1, G=0, B=0}
        end

        -- char data found
        if data ~= nil then
            window_data.enabled = data.enabled
            window_data.sortIndex = data.sortIndex

            -- use char position if saveGlobaly == false
            if window_data.saveGlobaly == false then
                window_data.left = data.left
                window_data.top = data.top

            end

        else
            -- no char data found
            window_data.enabled = false

        end
       
    end

    -- folder
    for index, folder_data in ipairs( global_data.folder ) do

        local data = Options.GetFolderByID( folder_data.id, char_data )

        if data ~= nil then

            folder_data.collapsed = data.collapsed
            folder_data.sortIndex = data.sortIndex
        
        else

            folder_data.collapsed = true

        end

    end

    -- the options
    global_data.moveMode                   = char_data.moveMode             
    global_data.autoReload                 = char_data.autoReload           
    global_data.options.shortcut.left      = char_data.options.shortcut.left
    global_data.options.shortcut.top       = char_data.options.shortcut.top 
    global_data.options.window.left        = char_data.options.window.left  
    global_data.options.window.top         = char_data.options.window.top   
    global_data.options.window.open        = char_data.options.window.open  

    return global_data

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- get window by id
---------------------------------------------------------------------------------------------------
function Options.FillPersistantCollection()

    for i, data in ipairs(Data.persistent_collection.effects) do
        local index = #Options.Collection.Effects + 1

        Options.Collection.Effects[index] = data
    end

    for i, data in ipairs(Data.persistent_collection.chat) do
        local index = #Options.Collection.Chat + 1

        Options.Collection.Chat[index] = data
    end

end

---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- get window by id
---------------------------------------------------------------------------------------------------
function Options.GetWindowByID( id, char_data )

    for index, data in ipairs( char_data.window ) do

        if data.id == id then
            return data
        end
        
    end

    return nil

end

---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- get window by id
---------------------------------------------------------------------------------------------------
function Options.GetFolderByID( id, char_data )

    for index, data in ipairs( char_data.folder ) do

        if data.id == id then
            return data
        end
        
    end

    return nil

end

---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- startup options if the were saved as open
---------------------------------------------------------------------------------------------------
function Options.StartUp()

    if Data.options.window.open == true then
        Options.OptionsWindow( Data.options.window.open )

    end

    if Data.moveMode == true then
        Options.MoveChanged( Data.moveMode )
        
    end

end

---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- fix for german/french client
---------------------------------------------------------------------------------------------------

function Options.ConvertFromEuro(dataRaw)
	local newData = {}
	for i, myData in pairs(dataRaw) do
		local tempIndex = tonumber(i);
		if (tempIndex == nil) then
			tempIndex = i;
		end
		local tempData = nil;

		if (type(myData) == "table") then
			tempData = Options.ConvertFromEuro(myData);
		else
			tempData = tonumber(myData);
			if (tempData == nil) then
				tempData = myData;
			end
		end
		newData[tempIndex] = tempData;
	end
	return newData;
	
end

---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- startup options if the were saved as open
---------------------------------------------------------------------------------------------------
function Options.LoadRunningTimer()

    local running_data = Turbine.PluginData.Load( Turbine.DataScope.Character, "gibberish_running_timer_" .. Language[ Language.Local ], nil)
    local gameTime = Turbine.Engine.GetGameTime()

    if running_data == nil then
        return

    end

    -- fake trigger data for add action
    local fake_trigger_data = {}
    fake_trigger_data.action = Action.Add

    for i, windowData in ipairs(Data.window) do

        -- check if window is ok for timer
        if windowData.enabled == true and
            Windows[ i ] ~= nil and
            running_data[ i ] ~= nil and
            #running_data[ i ] > 0 then

            -- add timer
            for j, data in ipairs(running_data[ i ]) do

                local timerData = windowData.timerList[ data.index ]

                -- check if timer should get started again
                if gameTime < data.startTime + data.duration or
                    timerData.loop == true then

                    -- fix loop start time
                    if timerData.loop == true then
                        local time_past = gameTime - data.startTime
                        local time_left = math.fmod(time_past, data.duration)
                        data.startTime = gameTime - time_left
                    end
                    
                    -- action call
                    Windows[ i ]:TimerAction(
                        fake_trigger_data,
                        timerData,
                        data.index,
                        data.startTime,
                        data.duration,
                        data.icon,
                        data.text,
                        nil,
                        data.key
                    )

                end

            end

        end
        
    end

end
---------------------------------------------------------------------------------------------------
