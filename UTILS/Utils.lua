--===================================================================================
--             Name:    Utils
-------------------------------------------------------------------------------------
--      Description:    
--===================================================================================





-------------------------------------------------------------------------------------
--      Description:    convert screen ratio to pixel
-------------------------------------------------------------------------------------
--        Parameter:    left    as % of screen
--                      top     as % of screen
-------------------------------------------------------------------------------------
--           Return:    left    in pixel
--                      top     in pixel
-------------------------------------------------------------------------------------
function Utils.ScreenRatioToPixel( left, top )
    return math.round( left * ScreenWidth ), math.round( top * ScreenHeight )
end



-------------------------------------------------------------------------------------
--      Description:    convert pixel to screen ratio
-------------------------------------------------------------------------------------
--        Parameter:    left    in pixel
--                      top     in pixel
-------------------------------------------------------------------------------------
--           Return:    left    as % of screen
--                      top     as % of screen
-------------------------------------------------------------------------------------
function Utils.PixelToScreenRatio( left, top )

    return (left / ScreenWidth), (top / ScreenHeight)

end



-------------------------------------------------------------------------------------
--      Description:    fix color from savedata
-------------------------------------------------------------------------------------
--        Parameter:    color
-------------------------------------------------------------------------------------
--           Return:    color R / G / B
-------------------------------------------------------------------------------------
function Utils.ColorFix( color )

    return Turbine.UI.Color(color.R, color.G, color.B)

end




local size_item = Turbine.UI.Control()
-------------------------------------------------------------------------------------
--      Description:    get image size
-------------------------------------------------------------------------------------
--        Parameter:    image
-------------------------------------------------------------------------------------
--           Return:    width / height
-------------------------------------------------------------------------------------
function Utils.GetImageSize(image)

	size_item:SetBackground(image)
	size_item:SetStretchMode(2)

	return size_item:GetSize()
    
end



-------------------------------------------------------------------------------------
--      Description:    format time
-------------------------------------------------------------------------------------
--        Parameter:    seconds
--                      format
-------------------------------------------------------------------------------------
--           Return:    formated string
-------------------------------------------------------------------------------------
function Utils.SecondsToClock(seconds, format)

    if format == NumberFormat.Seconds then

        return tostring( math.floor(seconds) )

    elseif format == NumberFormat.Minutes then

        local seconds = tonumber(seconds)

        if seconds <= 0 then
            return "00:00";
        else

            local mins = string.format("%02.f", math.floor(seconds/60));
            local secs = string.format("%02.f", math.floor(seconds - mins *60));
            return mins..":"..secs
        end

    
    elseif format == NumberFormat.One then

        local value =  tostring( math.floor(seconds * 10) / 10)

        return value

    end

end




-------------------------------------------------------------------------------------
--      Description:    check if targetname is in targetlist
-------------------------------------------------------------------------------------
--        Parameter:    name
--                      list
-------------------------------------------------------------------------------------
--           Return:    found / not found
-------------------------------------------------------------------------------------
function Utils.CheckListForName(name, list)

    if #list == 0 then

        return true

    end

    for key, value in pairs(list) do

        if value == name then

            return true

        end

    end

    return false

end





-------------------------------------------------------------------------------------
--      Description:    check combat message for name   
-------------------------------------------------------------------------------------
--        Parameter:    message
--                      chatType
-------------------------------------------------------------------------------------
--           Return:    text        - number or empty
--                      target      - name of target
-------------------------------------------------------------------------------------
function Utils.GetTargetNameFromCombatChat(message, chatType)

    local updateType,initiatorName,targetName,skillName,var1,var2,var3,var4 =  Utils.ParseCombatChat(string.gsub(string.gsub(message,"<rgb=#......>(.*)</rgb>","%1"),"^%s*(.-)%s*$", "%1"))
   
    local text = Utils.CheckingNameForNumber(skillName)
  
    local target = nil

    if chatType == Turbine.ChatType.PlayerCombat then

        target = targetName

    elseif chatType == Turbine.ChatType.EnemyCombat then

        target = initiatorName
    end

    return text, target

end




-------------------------------------------------------------------------------------
--      Description:    check for numbers in skillname
-------------------------------------------------------------------------------------
--        Parameter:    name
-------------------------------------------------------------------------------------
--           Return:    number / ""
-------------------------------------------------------------------------------------
function Utils.CheckingNameForNumber(name)

    local start_tier, end_tier = string.find(name, "%d+")
    
    if start_tier ~= nil then
        return string.sub(name, start_tier, end_tier)
    else
        return ""
    end

end




-------------------------------------------------------------------------------------
--      Description:   replace placeholder if necessary
-------------------------------------------------------------------------------------
--        Parameter:   token
-------------------------------------------------------------------------------------
--           Return:   token (all placeholder replaced with %w+)
-------------------------------------------------------------------------------------
function Utils.ReplacePlaceholder(token)

    return string.gsub(token, "&%d", "%%w+")

end




-------------------------------------------------------------------------------------
--      Description:   find all placeholders and return them as table
-------------------------------------------------------------------------------------
--        Parameter:   token            - pattern
--                     message          - string
--                     posAdjustment    - position adjustment between token and message
-------------------------------------------------------------------------------------
--           Return:   list of placeholders
-------------------------------------------------------------------------------------
function Utils.GetPlaceholder(token, message, posAdjustment)

    
    local placeholder = {}
    local pos1 = 1

    while pos1 ~= nil do    -- as long as a placeholder is found

        pos1 = string.find(token, "&%d", pos1)

        if pos1 ~= nil then     -- extrect the placeholder at the same position

            local index = string.match(token, "&%d", pos1)
        
            placeholder[index] = string.match( message, "%w+", (pos1 + posAdjustment))

            posAdjustment = posAdjustment - 2 + string.len(placeholder[index])
            pos1 = pos1+2
        end

    end

    return placeholder

end



-------------------------------------------------------------------------------------
--      Description:   parse text for target format
-------------------------------------------------------------------------------------
--        Parameter:   effect name
--                     target name
-------------------------------------------------------------------------------------
--           Return:   text
-------------------------------------------------------------------------------------
function Utils.TextTargetParse(name, target)

    local text = Utils.CheckingNameForNumber(name)

    if text ~= "" then

        text = text .. " - "
        
    end

    text = text .. target

    return text

end
