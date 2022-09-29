local utils = require("utils")

local dashFuseBox = {}

dashFuseBox.name = "FactoryHelper/DashFuseBox"

dashFuseBox.fieldInformation = {
    direction = {
        editable = false,
        options = {
            "Left",
            "Right"
        }
    }
}

dashFuseBox.placements = {
    {
        name = "left",
        data = {
            activationIds = "",
            persistent = false,
            direction = "Left"
        }
    },
    {
        name = "right",
        data = {
            activationIds = "",
            persistent = false,
            direction = "Right"
        }
    }
}

dashFuseBox.texture = "objects/FactoryHelper/dashFuseBox/idle00"
dashFuseBox.justification = {0.0, 0.0}

function dashFuseBox.scale(room, entity)
    local sx = entity.direction == "Right" and 1 or -1
    return sx, 1.0
end

function dashFuseBox.selection(room, entity)
    local x, y = entity.x or 0, entity.y or 0
    return entity.direction == "Right" and utils.rectangle(x, y, 6, 16) or utils.rectangle(x - 6, y, 6, 16)
end

return dashFuseBox
