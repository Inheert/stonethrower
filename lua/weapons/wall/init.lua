AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP:Initialize()
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + 0.5)
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Think()
end
