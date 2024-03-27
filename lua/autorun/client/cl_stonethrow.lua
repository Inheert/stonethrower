include("autorun/sh_stonethrow.lua")

hook.Add("PlayerBindPress", "PlayerBindPressExample", function( ply, bind, pressed )
    if (bind == "slot1") then
        return (0)
    end
end )

net.Receive("particleDisplay", function()
    local data = net.ReadTable()

    if (data.pos == nil || data.name == nil || data.angle == nil) then return end
    ParticleEffect(data.name, data.pos, data.angle)
end)
