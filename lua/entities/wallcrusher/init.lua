AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_wasteland/rockcliff01f.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetCustomCollisionCheck(true)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:SetMass(1000000)
        phys:EnableGravity(false)
        phys:EnableCollisions(true)
        phys:SetBuoyancyRatio(1)
        phys:EnableDrag(false)
        phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
    end

    timer.Simple(10, function()
        if (not IsValid(self)) then return end
        self:Remove() 
    end)

    self.path = {
        Vector(0, 0, 800),
    }

    self.actualPath = 1
    self.direction = 1
    self.touchCount = 0

    self.alreadyImpact = false
end

function ENT:StartTouch(ent)
end

function ENT:Touch(ent)

end

function ENT:EndTouch(ent)
end

function ENT:Think()
    if (not IsValid(self.linkedWall)) then return end

    local trace = util.TraceLine({
        start = self:GetPos(),
        endPos = self:GetPos(),
        filter = self
    })

    if (trace.Hit && trace.Entity:GetClass() == self:GetClass() && trace.Entity:GetOwner() == self:GetOwner()) then
        self:StartRemove()
    end

    local phys = self:GetPhysicsObject()
    
    if (not IsValid(phys)) then return end

    phys:SetAngleVelocity(Vector(0, 0, 0))
    if (self.actualPath == 1) then
        phys:SetVelocity(self.path[1])
    elseif (self.actualPath == 2) then
        local pos = self:GetPos()
        local linkedPos = self.linkedWall:GetPos()
        local direction = (pos - linkedPos):GetNormalized()
        local velocity = direction * (-500)
    
        phys:SetVelocity(velocity)
        phys:SetAngleVelocity(Vector(0, 0, 0))
    else
        phys:SetVelocity(Vector(0, 0, 0))
    end

    self.actualPath = self.actualPath + 1
end

function ENT:StartRemove()
    timer.Simple(0.2, function()
        if (not IsValid(self)) then return end
        self:Remove()
        if (IsValid(self.linkedWall)) then
            self.linkedWall:Remove()
        end
    end)
end