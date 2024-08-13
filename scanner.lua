local component = require('component')
local sides = require('sides')
local config = require('config')
local geolyzer = component.geolyzer

local function scan()
    local rawResult = geolyzer.analyze(sides.down)

    -- AIR
    if
        rawResult.name == 'minecraft:air' or
            rawResult.name == 'GalacticraftCore:tile.brightAir'
     then
        return {isCrop = true, name = 'air'}
    elseif rawResult.name == 'IC2:blockCrop' then
        -- RANDOM BLOCK
        -- EMPTY CROP STICK
        if rawResult['crop:name'] == nil then
            -- FILLED CROP STICK
            return {isCrop = true, name = 'emptyCrop'}
        else
            return {
                isCrop = true,
                name = rawResult['crop:name'],
                gr = rawResult['crop:growth'],
                ga = rawResult['crop:gain'],
                re = rawResult['crop:resistance'],
                tier = rawResult['crop:tier']
            }
        end
    else
        return {isCrop = false, name = 'block'}
    end
end

local function isWeed(crop, farm)
    if farm == 'working' then
        return crop.name == 'weed' or crop.name == 'Grass' or
            crop.gr > config.workingMaxGrowth or
            crop.re > config.workingMaxResistance or
            (crop.name == 'venomilia' and crop.gr > 7)
    elseif farm == 'storage' then
        return crop.name == 'weed' or crop.name == 'Grass' or
            crop.gr > config.storageMaxGrowth or
            crop.re > config.storageMaxResistance or
            (crop.name == 'venomilia' and crop.gr > 7)
    end
end

return {
    scan = scan,
    isWeed = isWeed
}
