local drawableSprite = require("structs.drawable_sprite")
local utils = require("utils")

local rustBerry = {}

rustBerry.name = "FactoryHelper/RustBerry"

rustBerry.placements = {
    name = "rust_berry"
}

function rustBerry.sprite(room, entity)
    local button = drawableSprite.fromTexture("objects/FactoryHelper/rustBerry/berry_01", entity)
    local case = drawableSprite.fromTexture("objects/FactoryHelper/rustBerry/gear_01", entity)

    return {
        case,
        button
    }
end

function rustBerry.selection(room, entity)
    return utils.rectangle(entity.x - 8, entity.y - 7, 16, 14)
end

return rustBerry
