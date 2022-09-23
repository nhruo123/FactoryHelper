local powerLine = {}

powerLine.name = "FactoryHelper/PowerLine"
powerLine.nodeLimits = {1, -1}
powerLine.nodeLineRenderType = "line"
powerLine.nodeVisibility = "always"

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

powerLine.texture = "objects/FactoryHelper/powerLine/powerLine_c"

function powerLine.color(room, entity)
    return entity.startActive and {0.2, 0.7, 0.2, 1.0} or {0.7, 0.7, 0.7, 1.0}
end

return powerLine
