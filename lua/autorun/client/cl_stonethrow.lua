include("autorun/sh_stonethrow.lua")

hook.Add( "PlayerBindPress", "PlayerBindPressExample", function( ply, bind, pressed )
    if (bind == "slot1") then
        return (0)
    end
end )