local drawableSprite = require("structs.drawable_sprite")
local drawableLine = require("structs.drawable_line")
local utils = require("utils")
local drawing = require("utils.drawing")

local baseTexture = "objects/FactoryHelper/piston/base00"
local headTexture = "objects/FactoryHelper/piston/head00"
local fakeNodeColor = {1.0, 1.0, 1.0, 0.65}
local dottedLineColor = {1.0, 0.0, 1.0, 0.25}

local rotations = {
    up = 0,
    down = math.pi,
    left = -math.pi / 2,
    right = math.pi / 2
}

local offsets = {
    up = {x = 0, y = 0},
    down = {x = 16, y = 8},
    left = {x = 0, y = 16},
    right = {x = 8, y = 0}
}

local offsetFactors = {
    up = {x = 1, y = 1},
    down = {x = -1, y = -1},
    left = {x = 1, y = -1},
    right = {x = -1, y = 1}
}

local units = {
    up = {x = 0, y = -1},
    down = {x = 0, y = 1},
    left = {x = -1, y = 0},
    right = {x = 1, y = 0}
}

local function addDottedLineSprites(sprites, ax, ay, bx, by, line, gap, color)
    local fromSegments = drawing.getDashedLineSegments(ax, ay, bx, by, line, gap)
    for _, segment in ipairs(fromSegments) do
        table.insert(sprites, drawableLine.fromPoints(segment, color))
    end
end

local function createHandler(name, direction)
    local handler = {}

    handler.name = name
    handler.nodeLimits = {2, 2}
    handler.nodeVisibility = "never"

    handler.fieldInformation = {
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

    handler.placements = {
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


    local horizontal = direction == "up" or direction == "down"
    local w, h = horizontal and 16 or 8, horizontal and 8 or 16
    local rotation = rotations[direction]
    local offset = offsets[direction]
    local alignAxis, moveAxis = horizontal and "x" or "y", horizontal and "y" or "x"
    local of = offsetFactors[direction]

    function handler.sprite(room, entity)
        local sprites = {}

        local nodes = entity.nodes or {{x = 0, y = 0}, {x = 0, y = 0}}
        local from, to = nodes[1], nodes[2]

        local baseSprite = drawableSprite.fromTexture(baseTexture, entity)
        local fromNodeSprite = drawableSprite.fromTexture(baseTexture, from)
        local toNodeSprite = drawableSprite.fromTexture(headTexture, to)
        local fakeFromNodeSprite = drawableSprite.fromTexture(baseTexture, from)
        local fakeToNodeSprite = drawableSprite.fromTexture(headTexture, to)

        baseSprite:setJustification(0.0, 0.0)
        fromNodeSprite:setJustification(0.0, 0.0)
        toNodeSprite:setJustification(0.0, 0.0)
        fakeFromNodeSprite:setJustification(0.0, 0.0)
        fakeToNodeSprite:setJustification(0.0, 0.0)

        baseSprite:addPosition(offset.x, offset.y)
        fromNodeSprite:addPosition(offset.x, offset.y)
        toNodeSprite:addPosition(offset.x, offset.y)
        fakeFromNodeSprite:addPosition(offset.x, offset.y)
        fakeToNodeSprite:addPosition(offset.x, offset.y)

        fakeFromNodeSprite[alignAxis] = baseSprite[alignAxis]
        fakeToNodeSprite[alignAxis] = baseSprite[alignAxis]

        fromNodeSprite.color = fakeNodeColor
        toNodeSprite.color = fakeNodeColor

        baseSprite.rotation = rotation
        fromNodeSprite.rotation = rotation
        toNodeSprite.rotation = rotation
        fakeFromNodeSprite.rotation = rotation
        fakeToNodeSprite.rotation = rotation

        table.insert(sprites, baseSprite)
        table.insert(sprites, fromNodeSprite)
        table.insert(sprites, toNodeSprite)
        table.insert(sprites, fakeFromNodeSprite)
        table.insert(sprites, fakeToNodeSprite)

        addDottedLineSprites(sprites, fromNodeSprite.x + of.x * w / 2, fromNodeSprite.y + of.y * h / 2, fakeFromNodeSprite.x + of.x * w / 2, fakeFromNodeSprite.y + of.y * h / 2, 2, 4, dottedLineColor)
        addDottedLineSprites(sprites, toNodeSprite.x + of.x * w / 2, toNodeSprite.y + of.y * h / 2, fakeToNodeSprite.x + of.x * w / 2, fakeToNodeSprite.y + of.y * h / 2, 2, 4, dottedLineColor)

        return sprites
    end

    function handler.selection(room, entity)
        local nodes = entity.nodes or {{x = 0, y = 0}, {x = 0, y = 0}}
        local from, to = nodes[1], nodes[2]
        return utils.rectangle(entity.x, entity.y, w, h), {
            utils.rectangle(from.x, from.y, w, h),
            utils.rectangle(to.x, to.y, w, h)
        }
    end

    return handler
end

return {
    createHandler("FactoryHelper/PistonUp", "up"),
    createHandler("FactoryHelper/PistonDown", "down"),
    createHandler("FactoryHelper/PistonLeft", "left"),
    createHandler("FactoryHelper/PistonRight", "right")
}
