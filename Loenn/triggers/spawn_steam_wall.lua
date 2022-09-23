local spawnSteamWall = {}

spawnSteamWall.name = "FactoryHelper/SpawnSteamWallTrigger"
spawnSteamWall.fieldInformation = {
    speed = {
        minimumValue = 0.0
    },
    color = {
        fieldType = "color"
    }
}
spawnSteamWall.placements = {
    name = "spawn_steam_wall",
    data = {
        speed = 1.0,
        color = "ffffff"
    }
}

return spawnSteamWall
