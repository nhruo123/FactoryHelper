local utils = require("utils")

local doorRusty = {}

doorRusty.name = "FactoryHelper/DoorRusty"
doorRusty.depth = 8998

doorRusty.placements = {
    name = "door_rusty"
}

doorRusty.texture = "objects/FactoryHelper/doorRusty/metaldoor00"
doorRusty.justification = {0.5, 1.0}

function doorRusty.selection(room, entity)
    return utils.rectangle(entity.x - 2, entity.y - 24, 4, 24)
end

return doorRusty