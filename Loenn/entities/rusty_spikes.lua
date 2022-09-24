local drawableSprite = require("structs.drawable_sprite")
local spikeHelper = require("helpers.spikes")

local spikeOffsets = {
    up = {x = 0, y = 1},
    down = {x = 0, y = -1},
    right = {x = -1, y = 0},
    left = {x = 1, y = -1}
}

local spikeJustifications = {
    up = {x = 0.0, y = 1.0},
    down = {x = 0.0, y = 0.0},
    right = {x = 0.0, y = 0.0},
    left = {x = 1.0, y = 0.0}
}

local function getJustification(direction)
    return spikeJustifications[direction] or {0, 0}
end

local function getOffset(direction)
    return spikeOffsets[direction] or {0, 0}
end

local function getSpikeSpritesFromTexture(entity, direction, texture)
    local horizontal = direction == "left" or direction == "right"
    local justification = getJustification(direction)
    local offset = getOffset(direction)
    local length = horizontal and (entity.height or 8) or (entity.width or 8)
    local positionOffsetKey = horizontal and "y" or "x"

    local position = {
        x = entity.x,
        y = entity.y
    }

    local sprites = {}

    for _ = 0, length - 1, 8 do
        local sprite = drawableSprite.fromTexture(texture, position)
        sprite.depth = -1
        sprite:setJustification(justification.x, justification.y)
        sprite:addPosition(offset.x, offset.y)

        table.insert(sprites, sprite)

        position[positionOffsetKey] = position[positionOffsetKey] + 8
    end

    return sprites
end

local function createHandler(name, direction)
    local handler = {}

    local horizontal = direction == "left" or direction == "right"
    local lengthKey = horizontal and "height" or "width"

    handler.name = name
    handler.canResize = spikeHelper.getCanResize(direction)

    handler.placements = {
        name = "rusty_spikes",
        data = {
            [lengthKey] = 8
        }
    }

    local texture = string.format("objects/FactoryHelper/rustySpike/rusty_%s00", direction)
    function handler.sprite(room, entity)
        return getSpikeSpritesFromTexture(entity, direction, texture)
    end

    return handler
end

local rustySpikeUp = createHandler("FactoryHelper/RustySpikeUp", "up")
local rustySpikeDown = createHandler("FactoryHelper/RustySpikeDown", "down")
local rustySpikeLeft = createHandler("FactoryHelper/RustySpikeLeft", "left")
local rustySpikeRight = createHandler("FactoryHelper/RustySpikeRight", "right")

return {
    rustySpikeUp,
    rustySpikeDown,
    rustySpikeLeft,
    rustySpikeRight
}
