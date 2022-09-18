local drawableSprite = require("structs.drawable_sprite")

local fan = {}

fan.name = "FactoryHelper/FanVertical"
fan.minimumSize = {16, 24}
fan.canResize = {false, true}

fan.placements = {
    {
        name = "inactive",
        data = {
            width = 16,
            height = 24,
            startActive = false,
            activationId = ""
        }
    },
    {
        name = "active",
        data = {
            width = 16,
            height = 24,
            startActive = true,
            activationId = ""
        }
    }
}

local bodyTexture = "objects/FactoryHelper/fan/body0"
local activeFanTexture = "objects/FactoryHelper/fan/fan0"
local inactiveFanTexture = "objects/FactoryHelper/fan/fan3"

function fan.sprite(room, entity)
    local sprites = {}

    local height = entity.height or 16

    local texture = entity.startActive and activeFanTexture or inactiveFanTexture
    local fanSprite = drawableSprite.fromTexture(texture, entity)
    fanSprite:addPosition(8, math.floor(height / 2))
    fanSprite:setScale(height / 24, 1.0)
    fanSprite.rotation = math.pi / 2
    table.insert(sprites, fanSprite)

    local tileHeight = math.floor(height / 8)
    for i = 0, tileHeight - 1, 1 do
        local tx = i == 0 and 0 or i == tileHeight - 1 and 16 or 8

        local leftTile = drawableSprite.fromTexture(bodyTexture, entity)
        local rightTile = drawableSprite.fromTexture(bodyTexture, entity)

        leftTile:useRelativeQuad(tx, 0, 8, 8)
        rightTile:useRelativeQuad(tx, 8, 8, 8)

        leftTile:addPosition(0, height - i * 8)
        rightTile:addPosition(8, height - i * 8)

        leftTile.rotation = -math.pi / 2
        rightTile.rotation = -math.pi / 2

        table.insert(sprites, leftTile)
        table.insert(sprites, rightTile)
    end

    return sprites
end

return fan