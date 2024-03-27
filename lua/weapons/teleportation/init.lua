AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP:Initialize()
    self.hooks = {
        {"FinishMove", "FixTeleportSWEP"}
    }

    self.TELEPORT_QUEUE = {}
end

function SWEP:PrimaryAttack()
    if (self:GetOwner():OnGround() == false) then return end

    self:SetNextPrimaryFire(CurTime() + 0.5)

    self:PrepareTeleportation()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Think()
    //self:GetOwner():Freeze(false)
    hook.Add("FinishMove", "FixTeleportSWEP", function(ply, mv)
        if (self.TELEPORT_QUEUE == nil) then return end
        local tpData = self.TELEPORT_QUEUE[ply]
        if tpData ~= nil then
            ply:SetPos(tpData.Pos)
            ply:SetAngles(tpData.Angles)
            self.TELEPORT_QUEUE[ply] = nil
            return true
        end 
    end)
end

function SWEP:PrepareTeleportation()
    local ply = self:GetOwner()

    local trace = ply:GetEyeTrace()
    local hitPos = trace.HitPos
    local distance = self:GetOwner():GetPos():Distance(hitPos)

    if (not trace.Hit || trace.HitNormal.z <= 0.7 || distance > 2000) then return end

    self:GetOwner():Freeze(true)
    timer.Simple(0.1, function()
        self:StartPos()
    end)

    timer.Simple(0.2, function()
        self:EndPos(hitPos)
    end)
end

function SWEP:StartPos()
    local ent = ents.Create("teleportation_entity")

    if (not IsValid(ent)) then return end

    local ply = self:GetOwner()
    local pos = ply:GetPos()
    local angle = Angle(0, math.random(0, 180), 0)

    self:PrepareParticles(pos, DOTON.particles.RockTeleport)

    ent:SetPos(pos)
    ent:SetAngles(angle)
    ent:SetOwner(ply)
    ent:ToSpawn()
end

function SWEP:EndPos(hitPos)
    local ent = ents.Create("teleportation_entity")

    if (not IsValid(ent)) then return end

    self:PrepareParticles(hitPos, DOTON.particles.RockTeleport)

    local ply = self:GetOwner()
    local angle = Angle(0, math.random(0, 180), 0)

    ent:SetPos(hitPos)
    ent:SetAngles(angle)
    ent:SetOwner(self:GetOwner())
    ent:ToSpawn()

    timer.Simple(0.5, function()
        if (not IsValid(ply)) then return end

        self:TeleportPlayer(ply, hitPos, ply:GetAngles(), Vector(0, 0, 0))
        ply:Freeze(false)
    end)
end

function SWEP:PrepareParticles(pos, particleInfo)
    local data = {
        pos = pos,
        name = particleInfo.name,
        angle = particleInfo.angle
    }
    ParticleEffect(data.name, data.pos, data.angle)
end

function SWEP:TeleportPlayer(ent, pos, ang, vel)
	local data = {}
	data.Pos = pos
	data.Angles = ang
	data.Velocity = vel
	data.Ent = ent
	self.TELEPORT_QUEUE[ent] = data
end