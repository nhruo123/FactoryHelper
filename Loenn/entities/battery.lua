local utils = require("utils")

local battery = {}

battery.name = "FactoryHelper/Battery"
battery.placements = {
    name = "battery"
}

battery.texture = "objects/FactoryHelper/batteryBox/battery00"

function battery.selection(room, entity)
    return utils.rectangle(entity.x - 4, entity.y - 7, 8, 14)
end

return battery