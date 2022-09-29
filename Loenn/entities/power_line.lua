local drawableSprite = require("structs.drawable_sprite")
local utils = require("utils")

local powerLine = {}

powerLine.name = "FactoryHelper/PowerLine"
powerLine.nodeLimits = {1, -1}
powerLine.nodeLineRenderType = "line"
powerLine.nodeVisibility = "never"

powerLine.fieldInformation = {
    colorCode = {
        fieldType = "color"
    },
    initialDelay = {
        minimumValue = 0.0
    }
}

powerLine.placements = {
    name = "power_line",
    placementType = "line",
    data = {
        activationId = "",
        colorCode = "00dd00",
        startActive = false,
        initialDelay = 0.0
    }
}

local function copy(obj)
    if type(obj) ~= "table" then
        return obj
    end

    local new = {}
    for key, value in pairs(obj) do
        new[key] = copy(value)
    end

    return new
end

local function getNodeSprite(node)
    local sprite = drawableSprite.fromTexture("objects/FactoryHelper/powerLine/powerLine_c", node)
    sprite:setJustification(0.0, 0.0)
    return sprite
end

local function addPathTile(sprites, color, id, from, offsetx, offsety)
    local light = drawableSprite.fromTexture("objects/FactoryHelper/powerLine/powerLineLight_" .. id, from)
    local path = drawableSprite.fromTexture("objects/FactoryHelper/powerLine/powerLine_" .. id, from)

    light:setJustification(0.0, 0.0)
    path:setJustification(0.0, 0.0)

    light:addPosition(offsetx or 0, offsety or 0)
    path:addPosition(offsetx or 0, offsety or 0)

    light.color = color

    table.insert(sprites, path)
    table.insert(sprites, light)
end

function powerLine.sprite(room, entity)
    local sprites = {}

    local start = {x = entity.x or 0, y = entity.y or 0}
    local origNodes = entity.nodes or {{x = 0, y = 0}}
    local nodes = copy(origNodes)

    local colorFactor = entity.startActive and 0.75 or 0.5
    local _, r, g, b = utils.parseHexColor(entity.colorCode)
    local color = {r * colorFactor, g * colorFactor, b * colorFactor, colorFactor}

    for i, node in ipairs(nodes) do
        local prev = i == 1 and start or nodes[i - 1]

        if node.x ~= prev.x and node.y ~= prev.y then
            if math.abs(node.x - prev.x) < math.abs(node.y - prev.y) then
                node.x = prev.x
            else
                node.y = prev.y
            end
        end

        -- store for later
        local movex = node.x == prev.x and 0 or node.x > prev.x and 8 or -8
        local movey = node.y == prev.y and 0 or node.y > prev.y and 8 or -8
        prev.movex, prev.movey = movex, movey

        local id = node.x == prev.x and "v" or "h"

        local count = math.floor(math.max(math.abs(prev.y - node.y), math.abs(prev.x - node.x)) / 8) - 1
        for j = 1, count do
            addPathTile(sprites, color, id, prev, movex * j, movey * j)
        end
    end

    for i = 0, #nodes do
        local node = i == 0 and start or nodes[i]

        local id
        if i == 0 then
            id = node.x == nodes[1].x and "v" or "h"
        elseif i == #nodes then
            id = node.x == (nodes[i - 1] or start).x and "v" or "h"
        else
            local prev = i == 1 and start or nodes[i - 1]
            if node.movey > 0 then
                id = prev.movex > 0 and "ld" or prev.movex < 0 and "rd" or "v"
            elseif node.movey < 0 then
                id = prev.movex > 0 and "lu" or prev.movex < 0 and "ru" or "v"
            elseif node.movex > 0 then
                id = prev.movey > 0 and "ru" or prev.movey < 0 and "rd" or "h"
            elseif node.movex < 0 then
                id = prev.movey > 0 and "lu" or prev.movey < 0 and "ld" or "h"
            end
        end

        if id then
            addPathTile(sprites, color, id, node)
        end
    end

    table.insert(sprites, getNodeSprite(start))
    for _, node in ipairs(origNodes) do
        table.insert(sprites, getNodeSprite(node))
    end

    return sprites
end

function powerLine.color(room, entity)
    return entity.startActive and {0.2, 0.7, 0.2, 1.0} or {0.7, 0.7, 0.7, 1.0}
end

function powerLine.selection(room, entity)
    local nodes = entity.nodes or {{x = 0, y = 0}}
    local rects = {}
    for i, node in ipairs(nodes) do
        rects[i] = utils.rectangle(node.x, node.y, 8, 8)
    end
    return utils.rectangle(entity.x, entity.y, 8, 8), rects
end

return powerLine
