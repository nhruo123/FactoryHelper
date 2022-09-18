local fakeTilesHelper = require("helpers.fake_tiles")

local factoryActivatorDashBlock = {}

factoryActivatorDashBlock.name = "FactoryHelper/FactoryActivatorDashBlock"
factoryActivatorDashBlock.depth = 0

factoryActivatorDashBlock.placements = {
    name = "factory_activator_dash_block",
    data = {
        width = 8,
        height = 8,
        tiletype = "3",
        blendin = true,
        canDash = true,
        permanent = true,
        activationIds = ""
    }
}

factoryActivatorDashBlock.sprite = fakeTilesHelper.getEntitySpriteFunction("tiletype", "blendin")
factoryActivatorDashBlock.fieldInformation = fakeTilesHelper.getFieldInformation("tiletype")

return factoryActivatorDashBlock
