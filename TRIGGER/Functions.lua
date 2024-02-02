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

            placeholder[index] = string.match( message, "%w+", (pos1 + posAdjustment - 1))

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

---------------------------------------------------------------------------------------------------
-- add to collection
---------------------------------------------------------------------------------------------------
Trigger.AddToEffectCollection = function( effect )

    -- stop if not collecting
    if Options.CollectEffects == false then
        return
    end

    local name = effect:GetName()
    local icon = effect:GetIcon()
    local duration = effect:GetDuration()

    -- check for duplicates
    for index, value in ipairs(Options.Collection.Effects) do
        if value.token == name and
            value.icon == icon then

            return

        end
    end

    local index = #Options.Collection.Effects + 1

    Options.Collection.Effects[ index ] = {}
    Options.Collection.Effects[ index ].token  = name
    Options.Collection.Effects[ index ].source = nil
    Options.Collection.Effects[ index ].icon = icon
    Options.Collection.Effects[ index ].timer = duration
    Options.Collection.Effects[ index ].persistent = false

    Options.EffectCollectionChanged()

end
---------------------------------------------------------------------------------------------------
