local steamWallSpeed = {}

steamWallSpeed.name = "FactoryHelper/SteamWallSpeedTrigger"
steamWallSpeed.fieldInformation = {
    speed = {
        minimumValue = 0.0
    }
}
steamWallSpeed.placements = {
    name = "steam_wall_speed",
    data = {
        speed = 1.0
    }
}

return steamWallSpeed
