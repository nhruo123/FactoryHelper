local utils = require("utils")

local rustyLamp = {}

rustyLamp.name = "FactoryHelper/RustyLamp"

rustyLamp.fieldInformation = {
    strobePattern = {
        editable = false,
        options = {
            ["None"] = "None",
            ["Flicker On"] = "FlickerOn",
            ["Light Flicker"] = "LightFlicker",
            ["Turn Off, Flicker On"] = "TurnOffFlickerOn"
        }
    },
    initialDelay = {
        minimumValue = 0.0
    }
}

rustyLamp.placements = {
    {
        name = "active",
        data = {
            activationId = "",
            strobePattern = "None",
            initialDelay = 0.0,
            startActive = true
        }
    },
    {
        name = "inactive",
        data = {
            activationId = "",
            strobePattern = "None",
            initialDelay = 0.0,
            startActive = false
        }
    }
}

function rustyLamp.texture(room, entity)
    return entity.startActive and "objects/FactoryHelper/rustyLamp/rustyLamp01" or "objects/FactoryHelper/rustyLamp/rustyLamp00"
end

rustyLamp.justification = {0.0, 0.0}

function rustyLamp.selection(room, entity)
    return utils.rectangle(entity.x + 4, entity.y + 2, 8, 14)
end

return rustyLamp
