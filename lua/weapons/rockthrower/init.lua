AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP:Initialize()
    self.isActive = false
    self.rocks = {}
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + 1)

    if (!self.isActive) then
        self:StartFloating()
    end
end

function SWEP:SecondaryAttack()
    if (#self.rocks < 1) then return end

    local rock = self.rocks[1]

    if (IsValid(rock) && rock.isActive == true && rock.onRemove == false) then
        self:ThrowRock(rock)
    end
end

function SWEP:Reload()
    for i = 1, #self.rocks, 1 do
        if (IsValid(self.rocks[i])) then
            self.rocks[i]:StartRemove()
        end
    end
end

function SWEP:Think()
    for i = 1, #self.rocks do
        if (not IsValid(self.rocks[i])) then
            table.remove(self.rocks, i)
        end
    end
end

function SWEP:StartFloating()
    self:PlayActivateSound()

    for i = 1, STONETHROW.rockCount, 1 do
        local ent = ents.Create("rock")

        if (not IsValid(ent)) then return end

        ent.parentSWEP = self
        ent:SetOwner(self:GetOwner())
        ent:SetModel(self:GetRockModel())
        ent:SetPos(self:GetOwner():GetPos() + Vector(math.random(-150, 150), math.random(-150, 150), 0))
        ent:Spawn()
        table.insert(self.rocks, #self.rocks + 1, ent)
    end
end

function SWEP:ThrowRock(rock)
    local owner = self:GetOwner()
    if (not IsValid(owner) || not owner:IsPlayer()) then return end

    local startPos = owner:EyePos()
    local endPos = startPos + owner:GetAimVector() * 1000
    local trace = util.TraceLine({
        start = startPos,
        endpos = endPos,
        filter = owner
    })

    local pos = rock:GetPos()
    local direction = (trace.HitPos - pos):GetNormalized()
    local distance = trace.HitPos:Distance(pos)
    local ang = owner:EyeAngles()
    local forceVec = direction * STONETHROW.throwingPower

    local physObj = rock:GetPhysicsObject()

    if (not IsValid(physObj)) then return end

    physObj:ApplyForceCenter(forceVec)
    rock:StartRemove()

    self:PlayThrowingSound(rock)
end

function SWEP:RemoveRock(rock)
    for i = 1, #self.rocks, 1 do
        if (self.rocks[i] == rock) then
            table.remove(self.rocks, i)
        end
    end
end

function SWEP:GetRockModel()
    if (STONETHROW.rockModelsCount < 1) then return end

    local model = math.random(1, STONETHROW.rockModelsCount)
    model = STONETHROW.rockModels[model]

    return (model)
end

function SWEP:PlayThrowingSound(rock)
    if (not IsValid(rock)) then return end
    
    if (STONETHROW.throwingSoundsCount < 1) then return end

    local throwingSound = math.random(1, STONETHROW.throwingSoundsCount)
    throwingSound = STONETHROW.throwingSounds[throwingSound]

    util.PrecacheSound(throwingSound)

    rock:EmitSound(throwingSound)
end

function SWEP:PlayActivateSound()
    if (not IsValid(self)) then return end
    
    if (STONETHROW.activateSoundsCount < 1) then return end

    local activateSound = math.random(1, STONETHROW.activateSoundsCount)
    activateSound = STONETHROW.activateSounds[activateSound]

    util.PrecacheSound(activateSound)

    self:GetOwner():EmitSound(activateSound)
end