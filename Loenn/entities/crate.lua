local crate = {}

crate.name = "FactoryHelper/ThrowBox"

crate.placements = {
    {
        name = "wood",
        data = {
            isMetal = false,
            tutorial = false,
            isSpecial = false,
            isCrucial = false
        }
    },
    {
        name = "metal",
        data = {
            isMetal = true,
            tutorial = false,
            isSpecial = false,
            isCrucial = false
        }
    }
}

function crate.texture(sprite, entity)
    return entity.isMetal and "objects/FactoryHelper/crate/crate_metal0" or "objects/FactoryHelper/crate/crate0"
end

crate.justification = {0.0, 0.0}

return crate
