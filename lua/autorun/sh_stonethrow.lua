include("config.lua")

hook.Add("PlayerSwitchWeapon", "DeleteSWEPHook", function(ply, oldWeapon, newWeapon)
    if (oldWeapon.hooks == nil) then return end

    for k, v in pairs(oldWeapon.hooks) do
        hook.Remove(v[1], v[2])
    end

    for k, v in pairs(oldWeapon.hooks) do
        table.remove(oldWeapon.hooks, k)
    end
end)