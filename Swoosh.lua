-- Swoosh addon for Turtle WoW (1.12 client)
-- Usage: /swoosh to execute combo point logic

-- Configurable combo point thresholds
local SINISTER_STRIKE_CP = 0    -- Always use at 0-1 CP
local SLICE_DICE_CP = 1        -- Use at 2+ CP when buff isn't active
local EVISCERATE_CP = 1        -- Use at 2+ CP when Slice and Dice is active

local function HasBuff(unit, texturePattern)
    for i=1,16 do
        local buffTexture = UnitBuff(unit, i)
        if buffTexture and strfind(buffTexture, texturePattern) then
            return true
        end
    end
    return false
end

local function GetSpellIndex(spellName)
    for i = 1, 200 do  -- Scan through spellbook slots
        local name, rank = GetSpellName(i, BOOKTYPE_SPELL)
        if name and name == spellName then
            return i
        end
    end
    return nil
end

local function IsSpellReady(spellName)
    local spellIndex = GetSpellIndex(spellName)
    if not spellIndex then return false end
    
    local start, duration = GetSpellCooldown(spellIndex, BOOKTYPE_SPELL)
    return start == 0 and duration == 0
end

local function Swoosh_Command(msg)
    local comboPoints = GetComboPoints()
    local hasSliceAndDice = HasBuff("player", "Ability_Rogue_SliceDice")
    if not IsCurrentAction(60) then
        AttackTarget()
    end
    -- First try to use Ghostly Strike if it's available
    if IsSpellReady("Ghostly Strike") then
        CastSpellByName("Ghostly Strike")
        return
    end
    
    -- If Ghostly Strike is on cooldown, proceed with normal rotation
    if comboPoints >= SLICE_DICE_CP and not hasSliceAndDice then
        CastSpellByName("Slice and Dice")
    elseif comboPoints >= EVISCERATE_CP and hasSliceAndDice then
        CastSpellByName("Eviscerate")
    else
        CastSpellByName("Sinister Strike")
    end
end

SLASH_SWOOSH1 = "/swoosh"
SlashCmdList["SWOOSH"] = Swoosh_Command