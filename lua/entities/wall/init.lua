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

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:SetMass(1)
        phys:EnableGravity(true)
        phys:EnableCollisions(true)
        phys:SetBuoyancyRatio(1)
        phys:EnableDrag(false)
    end
end

function ENT:Think()
end

function ENT:PhysicsCollide(data, physObj)
end

function ENT:StartTouch(ent)
end

function ENT:Touch(ent)
end

function ENT:EndTouch(ent)
end
