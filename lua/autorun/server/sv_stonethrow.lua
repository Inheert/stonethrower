AddCSLuaFile("autorun/client/cl_stonethrow.lua")
AddCSLuaFile("autorun/sh_stonethrow.lua")

include("autorun/sh_stonethrow.lua")

hook.Add("ShouldCollide", "customCollision", function(ent1, ent2)
    if (ent1:GetClass() == "wallcrusher" && ent2:GetClass() == "worldspawn") then return false end

    if (ent1:GetClass() == "wallcrusher" && ent2:GetClass() == "wallcrusher") then return false end
end)