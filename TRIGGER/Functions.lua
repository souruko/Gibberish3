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
-- callbacks
---------------------------------------------------------------------------------------------------
-- these live on the Trigger table rather than being plain globals: a plain
-- global reaches only the file it is written in, so it cannot be called from
-- another one
function Trigger.AddCallback(object, event, callback)
    if (object[event] == nil) then
        object[event] = callback;
    else
        if (type(object[event]) == "table") then
            table.insert(object[event], callback);
        else
            object[event] = {object[event], callback};
        end
    end
    return callback;
end

function Trigger.RemoveCallback(object, event, callback)
    if (object[event] == callback) then
        object[event] = nil;
    else
        if (type(object[event]) == "table") then
            local size = table.getn(object[event]);
            for i = 1, size do
                if (object[event][i] == callback) then
                    table.remove(object[event], i);
                    break;
                end
            end
        end
    end
end
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- effect view
---------------------------------------------------------------------------------------------------
-- Every effect:Get*() is a call into the game and none of the values can change
-- while a single event is being processed. A view is built once per event and
-- reads each value at most once, no matter how many triggers ask for it.
function Trigger.NewEffectView( effect )

    return { effect = effect }

end

function Trigger.EffectName( view )

    local value = view.name

    if value == nil then
        value     = view.effect:GetName()
        view.name = value
    end

    return value

end

function Trigger.EffectIcon( view )

    local value = view.icon

    if value == nil then
        value     = view.effect:GetIcon()
        view.icon = value
    end

    return value

end

function Trigger.EffectIsDebuff( view )

    local value = view.isDebuff

    if value == nil then
        value         = view.effect:IsDebuff()
        view.isDebuff = value
    end

    return value

end

function Trigger.EffectIsCurable( view )

    local value = view.isCurable

    if value == nil then
        value          = view.effect:IsCurable()
        view.isCurable = value
    end

    return value

end

function Trigger.EffectCategory( view )

    local value = view.category

    if value == nil then
        value         = view.effect:GetCategory()
        view.category = value
    end

    return value

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
-- returns list of placeholders
---------------------------------------------------------------------------------------------------
function Trigger.GetPlaceholder(token, message, posAdjustment, target, triggerData)

    local placeholder = {}

    -- regex triggers have already had the token turned into a pattern
    local pattern = triggerData and triggerData._cachedPattern

    if pattern == nil then
        pattern = Trigger.ReplacePlaceholder(token)
    end

    local captures = { string.find(message, pattern, posAdjustment) }

    -- Remove the first 2 values from captures array since string.find returns startindex and endindex before captures
    table.remove(captures, 1)
    table.remove(captures, 1)

    -- Create index, value pairs for each capture. Index has & added so &1, &2, etc can be used in custom text, duration, etc
    -- The index matches the order the captures were returned from string.find and may not match &1, &2, etc in the token
    for index, value in pairs(captures) do
        placeholder["&" .. index] = value
    end

    -- Add index, value pairs for common placeholders
    placeholder["&name"] = LpData.name
    placeholder["&class"] = LpData.class
    placeholder["&target"] = target
    placeholder["&tag"] = tostring((triggerData and triggerData.tag) or "")

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
