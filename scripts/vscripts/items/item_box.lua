function open_box(keys)
    local caster = keys.caster
    local box_number = tostring(keys.box_number)
    local table = _G.load_items[box_number]
    local count = table["count"]
    local number = RandomInt(1, count)
    local item_name = table[tostring(number)]
    local item = caster:AddItemByName(item_name)
    -- 有几率开出高级箱子
    if keys.box_number < 6 and RandomInt(1, 100) <=
        _G.load_kv["open_great_box_percent"] then
        local great_box = caster:AddItemByName(
                              "item_box_" .. tostring(keys.box_number + 1))
    end
end
