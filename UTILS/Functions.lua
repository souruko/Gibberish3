--=================================================================================================
--= Utility Functions        
--= ===============================================================================================
--= global library for utility functions
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- screen ratio to pixel ( for loading position )
---------------------------------------------------------------------------------------------------
function ScreenRatioToPixel( left, top )

    return math.round( left * Options.ScreenWidth ), math.round( top * Options.ScreenHeight )

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- pixel to screen ratio ( for saving position )
---------------------------------------------------------------------------------------------------
function PixelToScreenRatio( left, top )

    return (left / Options.ScreenWidth), (top / Options.ScreenHeight)

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- fix get tourbine color from data
---------------------------------------------------------------------------------------------------
function ColorFix( color )

    if color == nil then
        return nil
    end

    return Turbine.UI.Color(color.R, color.G, color.B)

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- fix get tourbine color from data
---------------------------------------------------------------------------------------------------
local size_item = Turbine.UI.Control()
function GetImageSize( image )

    if image == nil then
        return 32, 32
    end

	size_item:SetBackground(image)
	size_item:SetStretchMode(2)

	return size_item:GetSize()
    
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- format timer 
---------------------------------------------------------------------------------------------------
function TimerFormat( seconds, format )

    -- plain seconds
    if format == NumberFormat.Seconds then

        return tostring( math.floor(seconds) )

    -- minutes and seconds
    elseif format == NumberFormat.Minutes then

        if seconds <= 0 then
            return "00:00";
        else

            local mins = string.format("%02.f", math.floor(seconds/60));
            local secs = string.format("%02.f", math.floor(seconds - mins *60));
            return mins..":"..secs
        end

    -- one decimal place
    elseif format == NumberFormat.OneDecimal then

        -- local value =  tostring( math.floor(seconds * 10) / 10)
        local value = string.format("%.1f", seconds)

        return value

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- get localized text
function GetText( control, description )

    local text 

    if control == nil or description == nil or Data.options.language == nil then
        text = ""
    else
        text = L[ Data.options.language ][ control ][ description ]

        if text == nil then
            text = ""
        end
    end

    return  text

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- 
function TextToColor( text )

    text = string.gsub(text, " ", "")

    local list = Split(text, ",")

    if #list ~= 3 then
        return nil

    end

    local r = tonumber( list[1] )
    local g = tonumber( list[2] )
    local b = tonumber( list[3] )

    -- fix values
    if r > 255 then
        r = 255
    end

    if r < 0 then
        r = 0
    end
    
    if g > 255 then
        g = 255
    end
  
    if g < 0 then
        g = 0
    end

    if b > 255 then
        b = 255
    end
  
    if b < 0 then
        b = 0
    end

    local color = {}
    color.R = r / 255
    color.G = g / 255
    color.B = b / 255

    return color

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- 
function ColorToText( color )

    local r, g, b

    r = tostring( math.floor( 255 * color.R ) )
    g = tostring( math.floor( 255 * color.G ) )
    b = tostring( math.floor( 255 * color.B ) )

    return r .. ", " .. g .. ", " .. b

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- split a string s at delimiter
function Split(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end
---------------------------------------------------------------------------------------------------
