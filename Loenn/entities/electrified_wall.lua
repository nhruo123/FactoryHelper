local utils = require("utils")

local fillColor = {0.55, 0.97, 0.96, 0.4}
local borderColor = {0.99, 0.96, 0.47, 1.0}
local fillColorInactive = {0.55, 0.97, 0.96, 0.1}
local borderColorInactive = {0.99, 0.96, 0.47, 0.25}

local function createHandler(name, dir)
    local horizontal = dir == "up" or dir == "down"

    local handler = {}

    handler.name = name
    handler.depth = -1
    handler.canResize = {horizontal, not horizontal}

    local minWidth, minHeight = horizontal and 16 or 8, horizontal and 8 or 16

    handler.minimumSize = {minWidth, minHeight}

    handler.placements = {
        {
            name = "active",
            data = {
                width = minWidth,
                height = minHeight,
                activationId = "",
                startActive = true
            }
        },
        {
            name = "inactive",
            data = {
                width = minWidth,
                height = minHeight,
                activationId = "",
                startActive = false
            }
        }
    }

    function handler.rectangle(room, entity, _)
        return handler.selection(room, entity)
    end
    function handler.fillColor(room, entity)
        return entity.startActive and fillColor or fillColorInactive
    end
    function handler.borderColor(room, entity)
        return entity.startActive and borderColor or borderColorInactive
    end

    return handler
end

local electrifiedWallUp = createHandler("FactoryHelper/ElectrifiedWallUp", "up")
local electrifiedWallDown = createHandler("FactoryHelper/ElectrifiedWallDown", "down")
local electrifiedWallLeft = createHandler("FactoryHelper/ElectrifiedWallLeft", "left")
local electrifiedWallRight = createHandler("FactoryHelper/ElectrifiedWallRight", "right")

function electrifiedWallUp.selection(room, entity)
    return utils.rectangle(entity.x, entity.y - 6, entity.width, 6)
end
function electrifiedWallDown.selection(room, entity)
    return utils.rectangle(entity.x, entity.y, entity.width, 6)
end
function electrifiedWallLeft.selection(room, entity)
    return utils.rectangle(entity.x - 6, entity.y, 6, entity.height)
end
function electrifiedWallRight.selection(room, entity)
    return utils.rectangle(entity.x, entity.y, 6, entity.height)
end

return {
    electrifiedWallUp,
    electrifiedWallDown,
    electrifiedWallLeft,
    electrifiedWallRight
}