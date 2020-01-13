function open_box(keys)
    local caster = keys.caster
    local box_number = tostring(keys.box_number)
    local table = _G.load_items[box_number]
    local count = table["count"]
    local number = RandomInt(1, count)
    local item_name = table[tostring(number)]
    local item = caster:AddItemByName(item_name)
end
