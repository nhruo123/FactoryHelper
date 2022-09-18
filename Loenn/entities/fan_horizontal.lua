local drawableSprite = require("structs.drawable_sprite")

local fan = {}

fan.name = "FactoryHelper/FanHorizontal"
fan.minimumSize = {24, 16}
fan.canResize = {true, false}

fan.placements = {
    {
        name = "inactive",
        data = {
            width = 24,
            height = 16,
            startActive = false,
            activationId = ""
        }
    },
    {
        name = "active",
        data = {
            width = 24,
            height = 16,
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

    local width = entity.width or 24

    local texture = entity.startActive and activeFanTexture or inactiveFanTexture
    local fanSprite = drawableSprite.fromTexture(texture, entity)
    fanSprite:addPosition(math.floor(width / 2), 8)
    fanSprite:setScale(width / 24, 1.0)
    table.insert(sprites, fanSprite)

    local tileWidth = math.floor(width / 8)
    for i = 0, tileWidth - 1, 1 do
        local tx = i == 0 and 0 or i == tileWidth - 1 and 16 or 8

        local topTile = drawableSprite.fromTexture(bodyTexture, entity)
        local bottomTile = drawableSprite.fromTexture(bodyTexture, entity)

        topTile:useRelativeQuad(tx, 0, 8, 8)
        bottomTile:useRelativeQuad(tx, 8, 8, 8)

        topTile:addPosition(i * 8, 0)
        bottomTile:addPosition(i * 8, 8)

        table.insert(sprites, topTile)
        table.insert(sprites, bottomTile)
    end

    return sprites
end

return fan
