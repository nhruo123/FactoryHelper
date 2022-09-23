local drawableSprite = require("structs.drawable_sprite")
local utils = require("utils")

local jumpthruRusty = {}

jumpthruRusty.name = "FactoryHelper/RustyJumpthruPlatform"
jumpthruRusty.depth = -9000
jumpthruRusty.canResize = {true, false}

jumpthruRusty.placements = {
    name = "jump_thru_rusty",
    data = {
        width = 8
    }
}

local texture = "objects/FactoryHelper/jumpThru/rustyMetal"

function jumpthruRusty.sprite(room, entity)
    local x, y = entity.x or 0, entity.y or 0
    local width = entity.width or 8

    local startX, startY = math.floor(x / 8) + 1, math.floor(y / 8) + 1
    local stopX = startX + math.floor(width / 8) - 1
    local len = stopX - startX

    local sprites = {}

    for i = 0, len do
        local quadX = 8
        local quadY = 8

        if i == 0 then
            quadX = 0
            quadY = room.tilesFg.matrix:get(startX - 1, startY, "0") ~= "0" and 0 or 8
        elseif i == len then
            quadY = room.tilesFg.matrix:get(stopX + 1, startY, "0") ~= "0" and 0 or 8
            quadX = 16
        end

        local sprite = drawableSprite.fromTexture(texture, entity)

        sprite:setJustification(0, 0)
        sprite:addPosition(i * 8, 0)
        sprite:useRelativeQuad(quadX, quadY, 8, 8)

        table.insert(sprites, sprite)
    end

    return sprites
end

function jumpthruRusty.selection(room, entity)
    return utils.rectangle(entity.x, entity.y, entity.width, 8)
end

return jumpthruRusty
