-- Swoosh addon for Turtle WoW (1.12 client)
-- Usage: /swoosh to execute combo point logic

local function Swoosh_Command(msg)
    local comboPoints = GetComboPoints()
    
    if comboPoints >= 2 then
        -- Cast Eviscerate if we have 2+ combo points
        CastSpellByName("Eviscerate")
        --DEFAULT_CHAT_FRAME:AddMessage("Swoosh: Executing Eviscerate!", 1.0, 1.0, 0.0)
    else
        -- Cast Sinister Strike to build combo points
        CastSpellByName("Sinister Strike")
        --DEFAULT_CHAT_FRAME:AddMessage("Swoosh: Building points with Sinister Strike!", 0.5, 1.0, 0.5)
    end
end

SLASH_SWOOSH1 = "/swoosh"
SlashCmdList["SWOOSH"] = Swoosh_Command

DEFAULT_CHAT_FRAME:AddMessage("Swoosh addon loaded. Type /swoosh to execute.", 1.0, 1.0, 1.0)