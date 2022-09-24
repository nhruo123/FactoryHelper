local drawableSprite = require("structs.drawable_sprite")

local bodyTexture = "objects/FactoryHelper/fan/body0"
local activeFanTexture = "objects/FactoryHelper/fan/fan0"
local inactiveFanTexture = "objects/FactoryHelper/fan/fan3"

local function createHandler(name, horizontal)
    local handler = {}
    local minimumWidth, minimumHeight = horizontal and 24 or 16, horizontal and 16 or 24

    handler.name = name
    handler.minimumSize = {minimumWidth, minimumHeight}
    handler.canResize = {horizontal, not horizontal}

    handler.placements = {
        {
            name = "inactive",
            data = {
                width = minimumWidth,
                height = minimumHeight,
                startActive = false,
                activationId = ""
            }
        },
        {
            name = "active",
            data = {
                width = minimumWidth,
                height = minimumHeight,
                startActive = true,
                activationId = ""
            }
        }
    }

    function handler.sprite(room, entity)
        local sprites = {}

        local size = horizontal and entity.width or entity.height

        local texture = entity.startActive and activeFanTexture or inactiveFanTexture
        local fanSprite = drawableSprite.fromTexture(texture, entity)
        local fanScale = size / 24
        local halfSize = math.floor(size / 2)
        if horizontal then
            fanSprite:addPosition(halfSize, 8)
        else
            fanSprite:addPosition(8, halfSize)
            fanSprite.rotation = math.pi / 2
        end
        fanSprite:setScale(fanScale, 1.0)
        table.insert(sprites, fanSprite)

        local tileSize = math.floor(size / 8)
        for i = 0, tileSize - 1, 1 do
            local tx = i == 0 and 0 or i == tileSize - 1 and 16 or 8

            local topTile = drawableSprite.fromTexture(bodyTexture, entity)
            local bottomTile = drawableSprite.fromTexture(bodyTexture, entity)

            topTile:useRelativeQuad(tx, 0, 8, 8)
            bottomTile:useRelativeQuad(tx, 8, 8, 8)
            if horizontal then
                topTile:addPosition(i * 8, 0)
                bottomTile:addPosition(i * 8, 8)
            else
                topTile:addPosition(0, size - i * 8)
                bottomTile:addPosition(8, size - i * 8)
                topTile.rotation = -math.pi / 2
                bottomTile.rotation = -math.pi / 2
            end

            table.insert(sprites, topTile)
            table.insert(sprites, bottomTile)
        end

        return sprites
    end

    return handler
end

local fanHorizontal = createHandler("FactoryHelper/FanHorizontal", true)
local fanVertical = createHandler("FactoryHelper/FanVertical", false)

return {
    fanHorizontal,
    fanVertical
}
