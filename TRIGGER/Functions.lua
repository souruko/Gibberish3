--=================================================================================================
--= Trigger Functions        
--= ===============================================================================================
--= general trigger functions
--=================================================================================================



---------------------------------------------------------------------------------------------------
-- init all triggers
---------------------------------------------------------------------------------------------------
function Trigger.InitAll()

    for index, trigger in ipairs(Trigger) do

        if trigger.Init ~= nil then
            trigger.Init()
        end

    end

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- replace placeholders with %w+
---------------------------------------------------------------------------------------------------
function Trigger.ReplacePlaceholder(token)

    return string.gsub(token, "&%d", "%%w+")

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- returns list of placeholders
---------------------------------------------------------------------------------------------------
function Trigger.GetPlaceholder(token, message, posAdjustment)

    local placeholder = {}
    local pos1 = 1

    -- as long as a placeholder is found
    while pos1 ~= nil do    

        pos1 = string.find(token, "&%d", pos1)

        -- extrect the placeholder at the same position
        if pos1 ~= nil then

            local index = string.match(token, "&%d", pos1)
        
            placeholder[index] = string.match( message, "%w+", (pos1 + posAdjustment))

            posAdjustment = posAdjustment - 2 + string.len(placeholder[index])
            pos1 = pos1+2
        end

    end

    return placeholder

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check if name is in list
---------------------------------------------------------------------------------------------------
function Trigger.CheckListForName(name, list)

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
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- parse text for target format
---------------------------------------------------------------------------------------------------
function Trigger.TextTargetParse(name, target)

    local text = Trigger.CheckingNameForNumber(name)

    if text ~= "" then

        text = text .. " - "
        
    end

    text = text .. target

    return text

end
---------------------------------------------------------------------------------------------------