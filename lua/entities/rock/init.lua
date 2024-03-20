AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
    if (self:GetModel() == "models/error.mdl") then
        self:SetModel("models/props_wasteland/rockgranite03b.mdl")
    end
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:SetMass(1)
        phys:EnableGravity(false)
        phys:EnableCollisions(false)
        phys:SetBuoyancyRatio(1)
        phys:EnableDrag(false)
    end

    self.isActive = false
    self.alreadyImpact = false
    self.onRemove = false

    self.angleVelocity = Vector(math.random(STONETHROW.stoneAngleVelocity[1], STONETHROW.stoneAngleVelocity[2]),
                                math.random(STONETHROW.stoneAngleVelocity[1], STONETHROW.stoneAngleVelocity[2]),
                                math.random(STONETHROW.stoneAngleVelocity[1], STONETHROW.stoneAngleVelocity[2]))
    self.zVelocity = math.random(STONETHROW.zVelocity[1], STONETHROW.zVelocity[2])

    timer.Simple(STONETHROW.delayBeforeDisappearingStart, function()
        if (not IsValid(self)) then return end
        self:StartRemove()
    end)
end

function ENT:PhysicsCollide(data, physObj)
    if (self.alreadyImpact == true) then return end

    self.alreadyImpact = true

    self:StartSoundAndEffect()

    if (not data.HitEntity:IsPlayer() && not data.HitEntity:IsNPC()) then return end

    self:DamageTarget(data.HitEntity)
end

function ENT:DamageTarget(target)
    local dmgInfo = DamageInfo()

    dmgInfo:SetAttacker(self:GetOwner())
    dmgInfo:SetInflictor(self)
    dmgInfo:SetDamage(math.random(STONETHROW.rockDamage[1], STONETHROW.rockDamage[2]))
    dmgInfo:SetDamageType(DMG_GENERIC)
    
    target:TakeDamageInfo(dmgInfo)
end

function ENT:Think()
    if (self.onRemove == true) then return end
    self:ManageRockSpawn()
    self:ManageRockPos()

    self:NextThink(CurTime() + 1)
    return (true)
end

function ENT:StartTouch(ent)
end

function ENT:Touch(ent)
end

function ENT:EndTouch(ent)
end

function ENT:ManageRockSpawn()
    if (not self:GetPhysicsObject():IsValid()) then return end

    local physObj = self:GetPhysicsObject()
    local angleVel = self.angleVelocity
    if (not IsValid(physObj) || angleVel == nil) then return end

    local naturalAngleVec = Vector(angleVel.x, angleVel.y, angleVel.z)

    physObj:SetAngleVelocity(naturalAngleVec)
    physObj:SetVelocity(Vector(0, 0, self.zVelocity))

    if (self.zVelocity != 0) then
        self.zVelocity = math.Clamp(self.zVelocity * STONETHROW.zVelocityDecay, 0, self.zVelocity)
        if (self.zVelocity <= STONETHROW.zVelocity[1] / 10) then
            self.zVelocity = 0
        end
    end
    self.isActive = true
end

function ENT:ManageRockPos()
    local trace = util.TraceLine({
        start = self:GetPos(),
        endpos = self:GetPos(),
        filter = self
    })

    if (trace.Hit && trace.HitWorld) then
        self:RemoveOnParentSWEP()

        if (not IsValid(self)) then return end
        print(self, "Blocked in map! ent removed.")
        self:Remove()
    end
end

function ENT:StartRemove()
    local phys = self:GetPhysicsObject()
    self.onRemove = true

    if (IsValid(phys)) then
        phys:EnableGravity(true)
        phys:EnableCollisions(true)
    end

    self:RemoveOnParentSWEP()

    timer.Simple(STONETHROW.delayBeforeDisappearing, function()
        if (not IsValid(self)) then return end
        self:Remove()
    end)
end

function ENT:RemoveOnParentSWEP()
    if (self.parentSWEP == nil || not IsValid(self)) then return end

    self.parentSWEP:RemoveRock(self)
end

function ENT:StartSoundAndEffect()
    timer.Simple(0, function()
        local explodeEffect = ents.Create("pfx1_07")

        if (not IsValid(explodeEffect)) then return end
    
        self:PlayImpactSound()

        explodeEffect:SetMoveType(MOVETYPE_NONE)
        explodeEffect:SetPos(self:GetPos())
        explodeEffect:SetParent(self)
        explodeEffect:Spawn()
    
        local phys = explodeEffect:GetPhysicsObject()

        if (not IsValid(phys)) then return end
        
        phys:EnableCollisions(false)

        timer.Simple(0.2, function()
            if (not IsValid(self)) then return end
            self:RemoveOnParentSWEP()
            self:Remove()
        end)
    
        timer.Simple(0.5, function()
            if (not IsValid(explodeEffect)) then return end
            explodeEffect:Remove()
        end)
    end)
end

function ENT:PlayImpactSound()
    if (not IsValid(self)) then return end

    if (STONETHROW.impactSoundsCount < 1) then return end

    local impactSound = math.random(1, STONETHROW.impactSoundsCount)
    impactSound = STONETHROW.impactSounds[impactSound]

    util.PrecacheSound(impactSound)

    self:EmitSound(impactSound)
end