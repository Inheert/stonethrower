AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP:Initialize()
    self.walls = {}
end

function SWEP:PrimaryAttack()
    if (self:GetOwner():OnGround() == false) then return end

    self:SetNextPrimaryFire(CurTime() + 0.5)

    self:SpawnWall()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
    self:RemoveAll()
end

function SWEP:Think()
end

function SWEP:SpawnWall()
    local ply = self:GetOwner()
    local pos = ply:GetPos()
    local forward = ply:GetForward()
    local right = ply:GetRight()

    // Used to avoid the ent pos to be influenced by the angle of view.
    forward.z = 0
    forward:Normalize()

    local delay = 0
    for k, v in ipairs(DOTON.waller.wallsOffset) do
        for i, j in pairs(v) do
            for m, n in ipairs(j) do
                timer.Simple(delay, function()
                    for h = 1, 2, 1 do
                        local ent = ents.Create("wall")
                
                        if (not IsValid(ply) || not IsValid(ent)) then return end
                    
                        local yaw = DOTON.waller.angles[math.random(1, DOTON.waller.anglesCount)]
                        local entPos = Vector(0, 0, 0)
                        local entAngle = ent:GetAngles()
                        ent.finalZPos = pos.z

                        if (h % 2 == 0) then
                            entPos = pos + (forward * i) + (right * n)
                        else
                            entPos = pos + (forward * i) + (right * (-n))
                        end

                        ent:SetPos(entPos)
                        ent:SetAngles(Angle(0, yaw + entAngle.y, 0))
                        ent:SetOwner(self:GetOwner())
                        ent:ToSpawn()
                        
                        self:PrepareParticles(entPos, DOTON.particles.wallerInit)

                        table.insert(self.walls, #self.walls + 1, ent)
                    end
                end)
            end
            delay = delay + DOTON.waller.delayBetweenWalls
        end
    end
end

function SWEP:PrepareParticles(pos, particleInfo)
    local data = {
        pos = pos,
        name = particleInfo.name,
        angle = particleInfo.angle
    }
    ParticleEffect(data.name, data.pos, data.angle)
end

function SWEP:RemoveAll()
    for i = 1, #self.walls, 1 do
        if (IsValid(self.walls[i])) then 
            self.walls[i]:Remove()
        end
    end

    for i = 1, #self.walls, 1 do
        if (not IsValid(self.walls[i])) then
            table.remove(self.walls, i)
        end
    end
end