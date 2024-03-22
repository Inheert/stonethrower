AddCSLuaFile("autorun/client/cl_stonethrow.lua")
AddCSLuaFile("autorun/sh_stonethrow.lua")

include("autorun/sh_stonethrow.lua")

hook.Add("ShouldCollide", "customCollision", function(ent1, ent2)
    if (ent1:GetCollisionGroup() == 100 && ent2:GetCollisionGroup() == 0) then return false end
end)