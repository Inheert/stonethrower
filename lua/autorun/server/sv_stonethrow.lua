AddCSLuaFile("config.lua")
AddCSLuaFile("autorun/client/cl_stonethrow.lua")
AddCSLuaFile("autorun/sh_stonethrow.lua")

include("autorun/sh_stonethrow.lua")

util.AddNetworkString("particleDisplay")

hook.Add("ShouldCollide", "customCollision", function(ent1, ent2)
    if (ent1:GetCollisionGroup() == 100 && ent2:GetCollisionGroup() == 0) then return false end

    if (ent1:GetCollisionGroup() == 101 && ent2:GetCollisionGroup() == 0 
        || ent1:GetCollisionGroup() == ent2:GetCollisionGroup()) then return false end
end)
