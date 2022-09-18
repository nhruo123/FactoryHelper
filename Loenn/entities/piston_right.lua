local drawableSprite = require("structs.drawable_sprite")
local drawableLine = require("structs.drawable_line")
local utils = require("utils")
local drawing = require("utils.drawing")

local piston = {}

piston.name = "FactoryHelper/PistonRight"
piston.nodeLimits = {2, 2}
piston.nodeVisibility = "never"

piston.fieldInformation = {
    moveTime = {
        minimumValue = 0.0
    },
    pauseTime = {
        minimumValue = 0.0
    },
    initialDelay = {
        minimumValue = 0.0
    }
}

piston.placements = {
    {
        name = "normal",
        data = {
            moveTime = 0.4,
            pauseTime = 0.2,
            initialDelay = 0.0,
            startActive = true,
            heated = false,
            activationId = ""
        }
    },
    {
        name = "heated",
        data = {
            moveTime = 0.4,
            pauseTime = 0.2,
            initialDelay = 0.0,
            startActive = true,
            heated = true,
            activationId = ""
        }
    }
}

local baseTexture = "objects/FactoryHelper/piston/base00"
local headTexture = "objects/FactoryHelper/piston/head00"
local normalBodyTextureRaw = "objects/FactoryHelper/piston/body0"
local heatedBodyTextureRaw = "objects/FactoryHelper/piston/body_h0"
local fakeNodeColor = {1.0, 1.0, 1.0, 0.65}

function piston.sprite(room, entity)
    local sprites = {}

    local x, y = entity.x or 0, entity.y or 0

    local nodes = entity.nodes or {{x = 0, y = 0}, {x = 0, y = 0}}
    local na = nodes[1]
    local nb = nodes[2]

    local bodyTextureRaw = entity.heated and heatedBodyTextureRaw or normalBodyTextureRaw

    -- base to first node
    local startLength = na.x - x
    local startSign = startLength < 0 and -1 or 1
    local startTileLength = math.floor(math.abs(startLength) / 8)

    for i = 0, startTileLength, 1 do
        local bodySprite = drawableSprite.fromTexture(bodyTextureRaw .. i % 4, entity)
        bodySprite:setJustification(0.0, 0.5)
        bodySprite:addPosition(i * 8 * startSign + 4, 0)
        bodySprite.rotation = math.pi / 2
        table.insert(sprites, bodySprite)
    end

    -- first to second node
    local endLength = na.x - nb.x
    local endSign = endLength < 0 and -1 or 1
    local endTileLength = math.floor(math.abs(endLength) / 8)

    for i = 1, endTileLength, 1 do
        local bodySprite = drawableSprite.fromTexture(bodyTextureRaw .. i % 4, entity)
        bodySprite:setJustification(0.0, 0.5)
        bodySprite:setPosition(i * 8 * endSign + nb.x + 4, y)
        bodySprite.rotation = math.pi / 2
        bodySprite.color = {1.0, 1.0, 1.0, 0.3}
        table.insert(sprites, bodySprite)
    end

    -- dashed lines
    local segmentsA = drawing.getDashedLineSegments(na.x + 4, na.y + 8, na.x + 4, y + 8, 2, 4)
    for _, segment in ipairs(segmentsA) do
        table.insert(sprites, drawableLine.fromPoints(segment, {1.0, 0.0, 1.0, 0.25}))
    end

    local segmentsB = drawing.getDashedLineSegments(nb.x + 4, nb.y + 8, nb.x + 4, y + 8, 2, 4)
    for _, segment in ipairs(segmentsB) do
        table.insert(sprites, drawableLine.fromPoints(segment, {1.0, 1.0, 0.0, 0.25}))
    end

    --table.insert(sprites, drawableLine.fromPoints({x + 8, y + 4, na.x + 8, na.y + 4, nb.x + 8, nb.y + 4}, {1.0, 1.0, 1.0, 0.1}))

    -- sprites
    local baseSprite = drawableSprite.fromTexture(baseTexture, entity)
    local fakeStartSprite = drawableSprite.fromTexture(headTexture, na)
    local fakeEndSprite = drawableSprite.fromTexture(headTexture, nb)
    local startSprite = drawableSprite.fromTexture(headTexture, na)
    local endSprite = drawableSprite.fromTexture(headTexture, nb)

    baseSprite.rotation = math.pi / 2
    fakeStartSprite.rotation = math.pi / 2
    fakeEndSprite.rotation = math.pi / 2
    startSprite.rotation = math.pi / 2
    endSprite.rotation = math.pi / 2

    baseSprite:setJustification(0.0, 1.0)
    fakeStartSprite:setJustification(0.0, 1.0)
    fakeEndSprite:setJustification(0.0, 1.0)
    startSprite:setJustification(0.0, 1.0)
    endSprite:setJustification(0.0, 1.0)

    fakeStartSprite.color = fakeNodeColor
    fakeEndSprite.color = fakeNodeColor

    startSprite.y = y
    endSprite.y = y

    table.insert(sprites, fakeStartSprite)
    table.insert(sprites, fakeEndSprite)
    table.insert(sprites, startSprite)
    table.insert(sprites, endSprite)
    table.insert(sprites, baseSprite)

    return sprites
end

function piston.selection(room, entity)
    local nodes = entity.nodes or {{x = 0, y = 0}, {x = 0, y = 0}}
    return utils.rectangle(entity.x, entity.y, 8, 16), {
        utils.rectangle(nodes[1].x, nodes[1].y, 8, 16),
        utils.rectangle(nodes[2].x, nodes[2].y, 8, 16)
    }
end

return piston
