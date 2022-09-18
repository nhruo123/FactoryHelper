local debris = {}

local debrisColors = {
    "Bronze",
    "Silver"
}

debris.name = "FactoryHelper/KillerDebris"

debris.fieldInformation = {
    color = {
        editable = false,
        options = debrisColors
    }
}

debris.placements = {}
for _, color in ipairs(debrisColors) do
    table.insert(debris.placements, {
        name = string.lower(color),
        data = {
            color = color,
            attachToSolid = false,
        }
    })
    table.insert(debris.placements, {
        name = string.lower(color) .. "_attached",
        data = {
            color = color,
            attachToSolid = true,
        }
    })
end

function debris.texture(room, entity)
    local color = entity.color or "Bronze"
    return string.format("danger/FactoryHelper/debris/fg_%s1", color)
end

return debris
