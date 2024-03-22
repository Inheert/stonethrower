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
        phys:SetMass(1)
        phys:EnableGravity(true)
        phys:EnableCollisions(false)
        phys:SetBuoyancyRatio(1)
        phys:EnableDrag(false)
        phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
    end

    timer.Simple(10, function()
        if (not IsValid(self)) then return end
        self:Remove() 
    end)

    self.zVelocity = STONETHROW.crusher.zVelocity

    self.initializeTime = CurTime()
    self.isForceAlreadyApplied = false
    self.isPhysicsCollideManaged = false
    self.isCrushing = false
    self.forceMultiplier = 3
end

function ENT:StartTouch(ent)
    self.isCrushing = true
    local physObj = self:GetPhysicsObject()

    if (not physObj:IsValid()) then return end

    physObj:SetAngleVelocity(Vector(0, 0, 0))        
    self:SetMoveType(MOVETYPE_NONE)

    if (ent:IsPlayer() || ent:IsNPC()) then
        self:DamageTarget(ent)
    end

    timer.Simple(0.1, function()
        if (not IsValid(self)) then return end
        self:Remove()
    end)
end

function ENT:Touch(ent)
end

function ENT:EndTouch(ent)
end

function ENT:PhysicsCollide(data, physObj)
    local pos = Vector(0, 0, 0)
    timer.Simple(0, function()
        if (not IsValid(self) || self.isPhysicsCollideManaged == true) then return end

        if (data.HitEntity:GetClass() == "worldspawn") then
            local physObj = self:GetPhysicsObject()

            if (not physObj:IsValid()) then return end

            self:SetMoveType(MOVETYPE_NONE)
            physObj:SetAngleVelocity(Vector(0, 0, 0))
            pos = self:GetPos()
            self.isPhysicsCollideManaged = true
        end
    end)
end

function ENT:Think()
    if (not IsValid(self.linkedWall) || not IsValid(self)) then return end

    self:ManageWallSpawn()

    if (self.isPhysicsCollideManaged == true && self.linkedWall.isPhysicsCollideManaged == true && self.isCrushing == false) then
        self:Crushing()
    end

    self:NextThink(CurTime() + STONETHROW.crusher.nextThink)
    return (true)
end

function ENT:ManageWallSpawn()
    local physObj = self:GetPhysicsObject()

    if (not physObj:IsValid()) then return end

    local angleVel = self.angleVelocity

    if (not IsValid(physObj) || (self.zVelocity == 0)) then return end

    local trace = util.TraceEntity({
        start = self:GetPos(),
        endpos = self:GetPos() - Vector(0, 0, 100),
        mask = MASK_SOLID_BRUSHONLY
    }, self)
    
    timer.Simple(0.5, function()
        if (not IsValid(self)) then return end

        physObj:EnableCollisions(true)
    end)

    if (self.isForceAlreadyApplied == false) then
        physObj:ApplyForceCenter(Vector(0, 0, self.zVelocity * STONETHROW.crusher.forceMultiplier))
        
        timer.Simple(0.1, function()
            if (not IsValid(self)) then return end
    
            physObj:ApplyForceCenter(Vector(0, 0, -self.zVelocity * STONETHROW.crusher.friction))
            self.zVelocity = 0
        end)
    end

    self.isForceAlreadyApplied = true
end

function ENT:Crushing()
    local physObj = self:GetPhysicsObject()

    if (not IsValid(self) || not IsValid(self.linkedWall) || not IsValid(physObj)) then return end

    local pos = self:GetPos()
    local targetPos = self.linkedWall:GetPos()
    local forceVec = (targetPos - pos):GetNormalized()

    self:SetMoveType(MOVETYPE_VPHYSICS)
    physObj:ApplyForceCenter(forceVec * 100000)
end

function ENT:DamageTarget(target)
    if (not IsValid(self) || not IsValid(self:GetOwner())) then return end

    local dmgInfo = DamageInfo()

    dmgInfo:SetAttacker(self:GetOwner())
    dmgInfo:SetInflictor(self)
    dmgInfo:SetDamage(math.random(STONETHROW.crusher.damage[1], STONETHROW.crusher.damage[2]))
    dmgInfo:SetDamageType(DMG_GENERIC)
    
    target:TakeDamageInfo(dmgInfo)
end

function ENT:ModifyCollisionGroup(collision)
    self:SetCollisionGroup(collision)
    self:CollisionRulesChanged()
end