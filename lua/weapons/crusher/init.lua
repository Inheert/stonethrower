AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP:Initialize()
    self.wallOffset = 100
    self.walls = {}
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + 1)

    self:StartCrusher()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
    for i = 1, #self.walls, 1 do
        if (IsValid(self.walls[i])) then
            self.walls[i]:Remove()
        end
    end
    for i = 1, #self.walls, 1 do
        table.remove(self.walls, i)
    end
end

function SWEP:Think()
end

function SWEP:StartCrusher()

    if (not (IsValid(self:GetOwner()))) then return end

    local wallsPos = self:GetOffset(self:GetOwner())

    local leftWall = self:CreateWall(wallsPos[1])
    local rightWall = self:CreateWall(wallsPos[2])

    if (not IsValid(leftWall) || not IsValid(rightWall)) then return end

    leftWall.linkedWall = rightWall
    rightWall.linkedWall = leftWall
    rightWall.direction = -1

    table.insert(self.walls, leftWall)
    table.insert(self.walls, rightWall)

    leftWall:Spawn()
    rightWall:Spawn()
end

function SWEP:GetOffset(ply)
    local pos = ply:GetPos()
    local forward = ply:GetForward()
    local right = ply:GetRight()

    local leftPos = pos - (right * 100)
    local rightPos = pos + (right * 100)

    return ({leftPos, rightPos})
end

function SWEP:CreateWall(pos)
    local ply = self:GetOwner()
    local ent = ents.Create("wallcrusher")

    if (not IsValid(ent) || not IsValid(ply)) then return end
    
    pos = pos + (ply:GetForward() * 100)
    pos.z = pos.z - 100

    ent:SetPos(pos)
    ent:SetAngles(ply:GetAngles())
    ent:SetOwner(self:GetOwner())
    return (ent)
end