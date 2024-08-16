local drawableSprite = require("structs.drawable_sprite")
local drawableRectangle = require("structs.drawable_rectangle")

local dashNegator = {}

local activationConditionEnum = { OnDash = 0, IsDashing = 1, IsNotDashing = 2 }
local directionEnum = { Down = 0, Left = 1, Right = 2 }
local directionRotationLookup = { directionEnum.Down, directionEnum.Right, directionEnum.Left }

dashNegator.name = "FactoryHelper/DashNegator"
dashNegator.minimumSize = function (_, entity)
    if entity.direction == directionEnum.Down then
        return {16, 32}
    else
        return {32, 16}
    end
end


dashNegator.placements = {
    name = "active",
    data = {
        width = 16,
        height = 32,
        activationId = "",
        startActive = true,
        activationCondition= 0,
        direction = 1,
        enableCollision = true
    }
}

dashNegator.fieldInformation = {
    activationCondition = {
        options = activationConditionEnum,
        editable = false,
        default = 0,
    },
    direction = {
        options = directionEnum,
        editable = false,
        default = 0,
    }
}

local areaColor = {0.7, 0.1, 0.1, 0.2}
local areaBorder = {0.7, 0.1, 0.1, 0.5}

local activeTurretTexture = "danger/FactoryHelper/dashNegator/turret05"
local inactiveTurretTexture = "danger/FactoryHelper/dashNegator/turret00"

function dashNegator.onRotate(room, entity, direction)
    entity.direction = math.fmod((direction + entity.direction), #directionRotationLookup)
end

function dashNegator.sprite(room, entity)
    local sprites = {}

    local x, y = entity.x or 0, entity.y or 0
    local width, height = entity.width or 16, entity.height or 32

    local torrent_count
    local rect
    if entity.direction == directionEnum.Down then
        torrent_count = math.floor(width / 16)
        rect = drawableRectangle.fromRectangle("bordered", x, y, torrent_count * 16, height, areaColor, areaBorder)
    else
        torrent_count = math.floor(height / 16)
        rect = drawableRectangle.fromRectangle("bordered", x, y, width, torrent_count * 16, areaColor, areaBorder)
    end

    table.insert(sprites, rect)

    local texture = entity.startActive and activeTurretTexture or inactiveTurretTexture
    for i = 0, torrent_count - 1, 1 do
        local turret = drawableSprite.fromTexture(texture, entity)
        turret:setJustification(0.0, 0.0)
        if entity.direction == directionEnum.Down then
            turret:addPosition(i * 16, 0)
        elseif entity.direction == directionEnum.Right then
            turret:addPosition(0, (i + 1) * 16)
            turret.rotation = -1.57079637
        else
            turret:addPosition(width, i * 16)
            turret.rotation = 1.57079637
        end
        table.insert(sprites, turret)
    end

    return sprites
end

return dashNegator
