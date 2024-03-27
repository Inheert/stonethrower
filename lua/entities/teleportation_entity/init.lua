AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
    if (self:GetModel() == "models/error.mdl") then
        self:SetModel("models/props_wasteland/rockcliff01j.mdl")
    end
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetCustomCollisionCheck(true)
    self:SetCollisionGroup(DOTON.collisionsGroup.NO_WORLD_AND_SELF_COLLISION)
    self:CollisionRulesChanged()

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:SetMass(10)
        phys:EnableGravity(false)
        phys:EnableCollisions(true)
        phys:SetBuoyancyRatio(1)
        phys:EnableDrag(true)
    end

    self.actualZPos = self:GetPos().z
    self.finalZPos = self.actualZPos + 1

    timer.Simple(2, function()
        self:Remove()
    end)
end

function ENT:Think()
    local physObj = self:GetPhysicsObject()

    if (not IsValid(physObj)) then return end

    if (self.actualZPos < self.finalZPos) then
        physObj:SetVelocity(Vector(0, 0, 800))
        self.actualZPos = self:GetPos().z
    else
        physObj:SetVelocity(Vector(0, 0, 0))
        self:SetMoveType(MOVETYPE_NONE)
    end

    self:NextThink(CurTime() + 0.2)
    return (true)
end

function ENT:ToSpawn()
    local pos = self:GetPos()
    pos.z = pos.z + (-140)

    self:SetPos(pos)
    self:Spawn()
end
