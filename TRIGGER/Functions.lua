--===================================================================================
--             Name:    TRIGGER Functions
-------------------------------------------------------------------------------------
--      Description:    collection of trigger related functions
--===================================================================================





-------------------------------------------------------------------------------------
--      Description:   replace placeholder if necessary
-------------------------------------------------------------------------------------
--        Parameter:   token
-------------------------------------------------------------------------------------
--           Return:   token (all placeholder replaced with %w+)
-------------------------------------------------------------------------------------
function Trigger.ReplacePlaceholder(token)

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
function Trigger.GetPlaceholder(token, message, posAdjustment)

    
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