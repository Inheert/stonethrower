AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
    if (self:GetModel() == "models/error.mdl") then
        self:SetModel("models/fallenlogic_environment/rocks/cluster_05.mdl")
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
        phys:SetMass(1000)
        phys:EnableGravity(false)
        phys:EnableCollisions(true)
        phys:SetBuoyancyRatio(1)
        phys:EnableDrag(false)
    end

    self.actualZPos = self:GetPos().z
    self.finalZPos =  self.actualZPos + 1

end

function ENT:Think()
    local physObj = self:GetPhysicsObject()

    if (not IsValid(physObj)) then return end

    if (self.actualZPos < self.finalZPos) then
        physObj:SetVelocity(Vector(0, 0, 400))
        self.actualZPos = self:GetPos().z
    else
        physObj:SetVelocity(Vector(0, 0, 0))
        self:SetMoveType(MOVETYPE_NONE)
        self:SetOwner(nil)
    end

    self:NextThink(CurTime() + 0.2)
    return (true)
end

function ENT:PhysicsCollide(data, physObj)
end

function ENT:StartTouch(ent)
end

function ENT:Touch(ent)
end

function ENT:EndTouch(ent)
end

function ENT:ToSpawn()
    local pos = self:GetPos()
    pos.z = pos.z + DOTON.waller.zStart

    self:SetPos(pos)
    self:Spawn()
end