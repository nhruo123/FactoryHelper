local drawableSprite = require("structs.drawable_sprite")
local utils = require("utils")

local conveyor = {}

conveyor.name = "FactoryHelper/Conveyor"
conveyor.canResize = {true, false}
conveyor.minimumSize = {32, 16}

conveyor.placements = {
    {
        name = "start_left",
        data = {
            width = 32,
            activationId = "",
            startLeft = true,
        }
    },
    {
        name = "start_right",
        data = {
            width = 32,
            activationId = "",
            startLeft = false,
        }
    }
}

local bodyLeftTexture = "objects/FactoryHelper/conveyor/belt_edge0"
local bodyMidTexture = "objects/FactoryHelper/conveyor/belt_mid0"
local bodyRightTexture = "objects/FactoryHelper/conveyor/belt_edge4"
local gearTexture = "objects/FactoryHelper/conveyor/gear0"

function conveyor.sprite(room, entity)
    local sprites = {}

    local width = entity.width or 32

    local leftEdge = drawableSprite.fromTexture(bodyLeftTexture, entity)
    leftEdge:setJustification(0.0, 0.0)
    table.insert(sprites, leftEdge)

    local rightEdge = drawableSprite.fromTexture(bodyRightTexture, entity)
    rightEdge:addPosition(width, 0)
    rightEdge:setJustification(0.0, 0.0)
    rightEdge:setScale(-1.0, 1.0)
    table.insert(sprites, rightEdge)

    local tileWidth = math.floor(width / 8)
    for i = 2, tileWidth - 3, 1 do
        local mid = drawableSprite.fromTexture(bodyMidTexture, entity)
        mid:addPosition(i * 8, 0)
        mid:setJustification(0.0, 0.0)
        table.insert(sprites, mid)
    end

    local leftGear = drawableSprite.fromTexture(gearTexture, entity)
    leftGear:addPosition(8, 8)
    table.insert(sprites, leftGear)

    local rightGear = drawableSprite.fromTexture(gearTexture, entity)
    rightGear:addPosition(width - 8, 8)
    table.insert(sprites, rightGear)

    return sprites
end

function conveyor.selection(room, entity)
    local x, y = entity.x or 0, entity.y or 0
    local w = entity.width or 32
    return utils.rectangle(x, y, w, 16)
end

return conveyor