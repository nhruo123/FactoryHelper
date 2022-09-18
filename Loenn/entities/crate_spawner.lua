local drawableRectangle = require("structs.drawable_rectangle")
local drawableSprite = require("structs.drawable_sprite")

local crateSpawner = {}

crateSpawner.name = "FactoryHelper/ThrowBoxSpawner"

crateSpawner.fieldInformation = {
    delay = {
        minimumValue = 0.0
    },
    maximum = {
        fieldType = "integer",
        minimumValue = 0
    }
}

crateSpawner.placements = {
    {
        name = "crate_spawner",
        data = {
            delay = 1.0,
            maximum = 0,
            activationId = "",
            isMetal = false,
            isRandom = false,
            fromTop = true,
            tutorial = false,
            startActive = true
        }
    }
}

local normalColor = {1.0, 1.0, 1.0, 0.2}
local randomColor = {1.0, 0.5, 1.0, 0.2}

function crateSpawner.sprite(room, entity)
    local sprites = {}

    local texture = entity.isMetal and "objects/FactoryHelper/crate/crate_metal0" or "objects/FactoryHelper/crate/crate0"
    local crateSprite = drawableSprite.fromTexture(texture, entity)
    crateSprite.color = {1.0, 1.0, 1.0, 0.5}

    local x, y = entity.x or 0, entity.y or 0

    local baseColor = entity.isRandom and randomColor or normalColor
    local edgeColor = {baseColor[1], baseColor[2], baseColor[3], 0.5}
    local rect = drawableRectangle.fromRectangle("bordered", x - 8, y - 8, 16, 16, baseColor, edgeColor)

    table.insert(sprites, crateSprite)
    table.insert(sprites, rect)

    return sprites
end

return crateSpawner
