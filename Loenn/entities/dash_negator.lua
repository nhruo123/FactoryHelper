local drawableSprite = require("structs.drawable_sprite")
local drawableRectangle = require("structs.drawable_rectangle")

local dashNegator = {}

dashNegator.name = "FactoryHelper/DashNegator"
dashNegator.minimumSize = {16, 32}

dashNegator.placements = {
    name = "active",
    data = {
        width = 16,
        height = 32,
        activationId = "",
        startActive = true
    }
}

local areaColor = {0.7, 0.1, 0.1, 0.2}
local areaBorder = {0.7, 0.1, 0.1, 0.5}

local activeTurretTexture = "danger/FactoryHelper/dashNegator/turret05"
local inactiveTurretTexture = "danger/FactoryHelper/dashNegator/turret00"

function dashNegator.sprite(room, entity)
    local sprites = {}

    local x, y = entity.x or 0, entity.y or 0
    local width, height = entity.width or 16, entity.height or 32

    local w = math.floor(width / 16)

    local rect = drawableRectangle.fromRectangle("bordered", x, y, w * 16, height, areaColor, areaBorder)
    table.insert(sprites, rect)

    local texture = entity.startActive and activeTurretTexture or inactiveTurretTexture
    for i = 0, w - 1, 1 do
        local turret = drawableSprite.fromTexture(texture, entity)
        turret:setJustification(0.0, 0.0)
        turret:addPosition(i * 16 - 2, 0)
        table.insert(sprites, turret)
    end

    return sprites
end

return dashNegator