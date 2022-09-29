local steamWallColor = {}

steamWallColor.name = "FactoryHelper/SteamWallColorTrigger"
steamWallColor.fieldInformation = {
    color = {
        fieldType = "color"
    },
    duration = {
        minimumValue = 0.0
    }
}
steamWallColor.placements = {
    name = "steam_wall_color",
    data = {
        color = "ffffff",
        duration = 1.0
    }
}

return steamWallColor
