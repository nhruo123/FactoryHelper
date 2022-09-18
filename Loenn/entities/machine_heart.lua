local utils = require("utils")

local machineHeart = {}

machineHeart.name = "FactoryHelper/MachineHeart"

machineHeart.placements = {
    name = "machine_heart"
}

machineHeart.texture = "objects/FactoryHelper/machineHeart/front0"

function machineHeart.selection(room, entity)
    return utils.rectangle(entity.x - 12, entity.y - 16, 24, 32)
end

return machineHeart
