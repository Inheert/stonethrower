include("autorun/sh_stonethrow.lua")

hook.Add( "PlayerBindPress", "PlayerBindPressExample", function( ply, bind, pressed )
    if (bind == "slot1") then
        return (0)
    end
end )

hook.Add("Think", "test", function()
    local ply = LocalPlayer()
    local pos = ply:GetPos()

    trace = util.TraceLine({
        start = pos,
        endpos = pos + Vector(0, 0, 1000),
        filter = ply
    })
    PrintTable(trace)
end)