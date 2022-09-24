local windTunnel = {}

local directions = {"Up", "Down", "Left", "Right"}
windTunnel.name = "FactoryHelper/WindTunnel"
windTunnel.minimumSize = {16, 16}

windTunnel.fieldInformation = {
    direction = {
        editable = false,
        options = directions
    },
    strength = {
        fieldType = "number",
        options = {
            ["Weak (400)"] = 400,
            ["Strong (800)"] = 800,
            ["Crazy (1200)"] = 1200,
            ["Summit Updraft (300)"] = 300,
            ["Summit Downdraft (400)"] = 400
        }
    }
}

windTunnel.placements = {}
for _, direction in ipairs(directions) do
    print(string.lower(direction) .. "_active")
    print(string.lower(direction) .. "_inactive")
    local activePlacement = {
        name = string.lower(direction) .. "_active",
        data = {
            width = 16,
            height = 16,
            direction = direction,
            activationId = "",
            strength = 100.0,
            startActive = true
        }
    }
    local inactivePlacement = {
        name = string.lower(direction) .. "_inactive",
        data = {
            width = 16,
            height = 16,
            direction = direction,
            activationId = "",
            strength = 100.0,
            startActive = false
        }
    }
    table.insert(windTunnel.placements, activePlacement)
    table.insert(windTunnel.placements, inactivePlacement)
end

windTunnel.fillColor = {0.7, 0.7, 0.7, 0.4}
windTunnel.borderColor = {0.7, 0.7, 0.7, 1.0}

return windTunnel