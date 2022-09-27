local utils = require("utils")
local drawableRectangle = require("structs.drawable_rectangle")
local drawableSprite = require("structs.drawable_sprite")

local fillColor = {0.55, 0.97, 0.96, 0.4}
local borderColor = {0.99, 0.96, 0.47, 1.0}
local fillColorInactive = {0.55, 0.97, 0.96, 0.1}
local borderColorInactive = {0.99, 0.96, 0.47, 0.25}

local function createHandler(name, dir)
    local horizontal = dir == "up" or dir == "down"

    local handler = {}

    handler.name = name
    handler.depth = -1
    handler.canResize = {horizontal, not horizontal}

    local minWidth, minHeight = horizontal and 16 or 8, horizontal and 8 or 16

    handler.minimumSize = {minWidth, minHeight}

    handler.placements = {
        {
            name = "active",
            data = {
                width = minWidth,
                height = minHeight,
                activationId = "",
                startActive = true
            }
        }
    }
    
    function handler.sprite(room, entity)
        local sprites = {}
                
        local texture = "objects/FactoryHelper/electrifiedWall/knob_" .. dir .. "00"
        local horizontal = dir == "up" or dir == "down"
        local baseOffsetX = dir == "left" and -3 or 5
        local baseOffsetY = dir == "up" and -3 or 5
        
        local baseColor = entity.startActive and fillColor or fillColorInactive
        local fill = drawableRectangle.fromRectangle("fill", handler.selection(room, entity), baseColor)
        table.insert(sprites, fill)
                
        for i = 0,1 do
            local spikeSprite = drawableSprite.fromTexture(texture, entity)
            spikeSprite.x += baseOffsetX + (horizontal and i * (entity.width - 10) or 0)
            spikeSprite.y += baseOffsetY + (horizontal and 0 or i * (entity.height - 10))
            table.insert(sprites, spikeSprite)
        end
        
        local edgeColor = entity.startActive and borderColor or borderColorInactive
        local line = drawableRectangle.fromRectangle("line", handler.selection(room, entity), edgeColor)
        table.insert(sprites, line)
                       
        return sprites
    end
    
    function handler.selection(room, entity)
        if dir == "up" then
            return utils.rectangle(entity.x, entity.y - 6, entity.width, 8)
        elseif dir == "down" then
            return utils.rectangle(entity.x, entity.y, entity.width, 8)
        elseif dir == "left" then
            return utils.rectangle(entity.x - 6, entity.y, 8, entity.height)
        elseif dir == "right" then
            return utils.rectangle(entity.x, entity.y, 8, entity.height)
        end
    end

    return handler
end

local electrifiedWallUp = createHandler("FactoryHelper/ElectrifiedWallUp", "up")
local electrifiedWallDown = createHandler("FactoryHelper/ElectrifiedWallDown", "down")
local electrifiedWallLeft = createHandler("FactoryHelper/ElectrifiedWallLeft", "left")
local electrifiedWallRight = createHandler("FactoryHelper/ElectrifiedWallRight", "right")

return {
    electrifiedWallUp,
    electrifiedWallDown,
    electrifiedWallLeft,
    electrifiedWallRight
}