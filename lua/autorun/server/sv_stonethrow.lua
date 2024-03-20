AddCSLuaFile("autorun/client/cl_stonethrow.lua")
AddCSLuaFile("autorun/sh_stonethrow.lua")

include("autorun/sh_stonethrow.lua")

util.AddNetworkString("EnableRock")

net.Receive("EnableRock", function(len, ply)

end)

hook.Add( "ShouldCollide", "Custom", function(ent1, ent2)
    print(ent1, ent2)
end)