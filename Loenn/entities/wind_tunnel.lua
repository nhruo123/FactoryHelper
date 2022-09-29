local windTunnel = {}

local directions = {"Up", "Down", "Left", "Right"}
windTunnel.name = "FactoryHelper/WindTunnel"
windTunnel.minimumSize = {16, 16}

windTunnel.fieldInformation = {
    direction = {
        editable = false,
        options = directions
    }
}

windTunnel.placements = {}
for _, direction in ipairs(directions) do
    local activePlacement = {
        name = string.lower(direction),
        data = {
            width = 16,
            height = 16,
            direction = direction,
            activationId = "",
            strength = 100.0,
            startActive = true
        }
    }
    table.insert(windTunnel.placements, activePlacement)
end

windTunnel.fillColor = {0.7, 0.7, 0.7, 0.4}
windTunnel.borderColor = {0.7, 0.7, 0.7, 1.0}

return windTunnel