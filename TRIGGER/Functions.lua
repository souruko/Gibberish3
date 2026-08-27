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
-- replace placeholders in token
---------------------------------------------------------------------------------------------------
function Trigger.ReplacePlaceholder(token)

    -- capture placeholders: these are replaced with Lua patterns that capture text when regex is used
    -- See: https://www.lua.org/pil/20.2.html
    -- See: https://www.lua.org/pil/20.3.html

    -- replace &1, &2, etc. with (%w+) to capture one or more alphanumeric characters
    -- It is not guaranteed that &1, etc. in the placeholder table will match the &1, etc. in the token
    -- token can have custom capture strings, out of order placeholders ("&2 &1"), bad placeholders (&0, &11)
    token = string.gsub(token, "&%d", "([%%w%%s%%-]+)")

    ----------
    -- common placeholders: these are just replaced with text

    token = string.gsub(token, "&name", LpData.name)
    token = string.gsub(token, "&class", LpData.class)

    return token

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- cache of processed tokens
---------------------------------------------------------------------------------------------------
-- A token is immutable at runtime, so the pattern built from it is kept instead
-- of being rebuilt on every trigger check.
--
-- The cache lives here, keyed by the trigger table, and NOT on the trigger
-- itself: triggers are part of Data and Data is written to the save file, so a
-- pattern stored on the trigger was saved with &name already resolved. Since
-- the account scope is the base for every character, the next character loaded
-- that pattern, found it already there and never rebuilt it - &name kept
-- matching whichever character saved last.
local patternCache = setmetatable( {}, { __mode = "k" } )
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- returns the pattern of a trigger token
---------------------------------------------------------------------------------------------------
function Trigger.GetPattern( triggerData )

    local pattern = patternCache[ triggerData ]

    if pattern == nil then

        pattern = Trigger.ReplacePlaceholder( triggerData.token )
        patternCache[ triggerData ] = pattern

    end

    return pattern

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- drop the cached pattern of a trigger, call after its token changed
---------------------------------------------------------------------------------------------------
function Trigger.ClearPattern( triggerData )

    patternCache[ triggerData ] = nil

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- returns the placeholders every trigger type supports
---------------------------------------------------------------------------------------------------
function Trigger.CommonPlaceholder( triggerData, target )

    -- no target given: the one selected right now
    if target == nil then

        local entity = LocalPlayer:GetTarget()

        if entity ~= nil and entity.GetName ~= nil then
            target = entity:GetName()
        end

    end

    local placeholder = {}

    placeholder["&name"]   = LpData.name
    placeholder["&class"]  = LpData.class
    placeholder["&target"] = target or ""
    placeholder["&tag"]    = tostring((triggerData and triggerData.tag) or "")

    return placeholder

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- returns list of placeholders
---------------------------------------------------------------------------------------------------
function Trigger.GetPlaceholder(token, message, posAdjustment, target, triggerData)

    local placeholder = Trigger.CommonPlaceholder(triggerData, target)
    local captures = { string.find(message, Trigger.ReplacePlaceholder(token), posAdjustment) }

    -- Remove the first 2 values from captures array since string.find returns startindex and endindex before captures
    table.remove(captures, 1)
    table.remove(captures, 1)

    -- Create index, value pairs for each capture. Index has & added so &1, &2, etc can be used in custom text, duration, etc
    -- The index matches the order the captures were returned from string.find and may not match &1, &2, etc in the token
    for index, value in pairs(captures) do
        placeholder["&" .. index] = value
    end

    return placeholder

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- replace every placeholder in a text
---------------------------------------------------------------------------------------------------
function Trigger.ApplyPlaceholder(text, placeholder)

    text = tostring(text or "")

    for index, value in pairs(placeholder) do

        -- % introduces a capture reference in a gsub replacement, so a value
        -- carrying one ("50% of ...") has to be escaped before it is used.
        -- Kept in its own variable: gsub also returns a count, and passed on
        -- directly that count would land in the limit argument of the outer call
        local replacement = string.gsub(tostring(value), "%%", "%%%%")

        text = string.gsub(text, index, replacement)

    end

    return text

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- check if name is in list
---------------------------------------------------------------------------------------------------
function Trigger.CheckListForName(name, list)

    if #list == 0 then

        return true

    end

    for key, value in ipairs(list) do

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
Trigger.AddToEffectCollection = function( effect, originType )

    -- stop if not collecting
    if Options.CollectEffects == false then
        return
    end

    -- check for onlydebuffs
    if Options.OnlyDebuffs == true and
        effect:IsDebuff() == false then

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

    -- filter permanent effect timers
    if duration > 999999 then
        duration = nil
    end

    local index = #Options.Collection.Effects + 1

    Options.Collection.Effects[ index ] = {}
    Options.Collection.Effects[ index ].token      = name
    Options.Collection.Effects[ index ].source     = nil
    Options.Collection.Effects[ index ].originType = originType or nil
    Options.Collection.Effects[ index ].icon       = icon
    Options.Collection.Effects[ index ].timer      = duration
    Options.Collection.Effects[ index ].persistent = false

    Options.EffectCollectionChanged()

end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- returns name and tier from combat chat message
---------------------------------------------------------------------------------------------------
Trigger.CheckingNameForNumber = function(name)

    if name == nil then
        return
    end

    local start_tier, end_tier = string.find(name, "%d+")
    
    if start_tier ~= nil then
        return string.sub(name, start_tier, end_tier)
    else
        return ""
    end

end
---------------------------------------------------------------------------------------------------
