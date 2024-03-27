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
        phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
    end

    self.isActive = false
    self.alreadyImpact = false
    self.onRemove = false

    self.angleVelocity = Vector(math.random(DOTON.rockThrower.stoneAngleVelocity[1], DOTON.rockThrower.stoneAngleVelocity[2]),
                                math.random(DOTON.rockThrower.stoneAngleVelocity[1], DOTON.rockThrower.stoneAngleVelocity[2]),
                                math.random(DOTON.rockThrower.stoneAngleVelocity[1], DOTON.rockThrower.stoneAngleVelocity[2]))
    self.zVelocity = math.random(DOTON.rockThrower.zVelocity[1], DOTON.rockThrower.zVelocity[2])

    timer.Simple(DOTON.rockThrower.delayBeforeDisappearingStart, function()
        if (not IsValid(self)) then return end
        self:StartRemove()
    end)
end

function ENT:PhysicsCollide(data, physObj)
    if (self.alreadyImpact == true) then return end

    if (data.HitEntity:GetClass() == self:GetClass() && data.HitEntity:GetOwner() == self:GetOwner()) then return end

    self.alreadyImpact = true
    self:ManageImpact()

    if (not data.HitEntity:IsPlayer() && not data.HitEntity:IsNPC()) then return end

    self:DamageTarget(data.HitEntity)
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
    local physObj = self:GetPhysicsObject()

    if (not physObj:IsValid()) then return end

    local angleVel = self.angleVelocity

    if (not IsValid(physObj) || angleVel == nil || (self.zVelocity == 0 && physObj:GetVelocity() == Vector(0, 0, 0))) then return end

    local naturalAngleVec = Vector(angleVel.x, angleVel.y, angleVel.z)

    physObj:SetAngleVelocity(naturalAngleVec)
    physObj:SetVelocity(Vector(0, 0, self.zVelocity))
    self:CollisionRulesChanged()

    self.zVelocity = math.Clamp(self.zVelocity * DOTON.rockThrower.zVelocityDecay, 0, self.zVelocity)
    if (self.zVelocity <= DOTON.rockThrower.zVelocity[1] / 10) then
        self.zVelocity = 0
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
        self:CollisionRulesChanged()
    end

    self:RemoveOnParentSWEP()

    timer.Simple(DOTON.rockThrower.delayBeforeDisappearing, function()
        if (not IsValid(self)) then return end
        self:Remove()
    end)
end

function ENT:RemoveOnParentSWEP()
    if (self.parentSWEP == nil || not IsValid(self) || not IsValid(self.parentSWEP)) then return end

    self.parentSWEP:RemoveRock(self)
end

function ENT:ManageImpact()
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

function ENT:DamageTarget(target)
    local dmgInfo = DamageInfo()

    dmgInfo:SetAttacker(self:GetOwner())
    dmgInfo:SetInflictor(self)
    dmgInfo:SetDamage(math.random(DOTON.rockThrower.rockDamage[1], DOTON.rockThrower.rockDamage[2]))
    dmgInfo:SetDamageType(DMG_GENERIC)
    
    target:TakeDamageInfo(dmgInfo)
end

function ENT:PlayImpactSound()
    if (not IsValid(self)) then return end

    if (DOTON.rockThrower.impactSoundsCount < 1) then return end

    local impactSound = math.random(1, DOTON.rockThrower.impactSoundsCount)
    impactSound = DOTON.rockThrower.impactSounds[impactSound]

    util.PrecacheSound(impactSound)

    self:EmitSound(impactSound)
end