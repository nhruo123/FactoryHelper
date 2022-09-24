local boomBox = {}

boomBox.name = "FactoryHelper/BoomBox"

boomBox.fieldInformation = {
    initialDelay = {
        minimumValue = 0.0
    }
}

boomBox.placements = {
    {
        name = "active",
        data = {
            activationId = "",
            initialDelay = 0.0,
            startActive = true
        }
    },
    {
        name = "inactive",
        data = {
            activationId = "",
            initialDelay = 0.0,
            startActive = false
        }
    }
}

local inactiveTexture = "objects/FactoryHelper/boomBox/idle00"
local activeTexture = "objects/FactoryHelper/boomBox/active00"

function boomBox.texture(room, entity)
    return entity.startActive and activeTexture or inactiveTexture
end

boomBox.justification = {0.0, 0.0}

return boomBox
