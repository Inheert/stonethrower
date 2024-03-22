AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP:Initialize()
    self.walls = {}
end

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire(CurTime() + 0.5)

    self:StartCrusher()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
    self:RemoveAll()
end

function SWEP:Think()
end

function SWEP:StartCrusher()

    if (not (IsValid(self:GetOwner()))) then return end

    local ply = self:GetOwner()
    local pos = ply:GetPos()
    local forward = ply:GetForward()
    local right = ply:GetRight()
    local plyData = {pos = pos, forward = forward, right = right}
    local delay = 0
    for i = 1, STONETHROW.crusher.ForwardOffsetsCount, 1 do
        timer.Simple(delay, function()
            local wallsPos = self:GetOffset(plyData, STONETHROW.crusher.ForwardOffsets[i])

            local leftWall = self:CreateWall(wallsPos[1], 1)
            local rightWall = self:CreateWall(wallsPos[2], -1)
        
            if (not IsValid(leftWall) || not IsValid(rightWall)) then return end
        
            leftWall.linkedWall = rightWall
            rightWall.linkedWall = leftWall
            rightWall.direction = -1
        
            table.insert(self.walls, leftWall)
            table.insert(self.walls, rightWall)
        


            leftWall:Spawn()
            rightWall:Spawn() 
        end)
        
        delay = 0
    end
end

function SWEP:GetOffset(plyData, offset)
    local pos = plyData.pos
    local forward = plyData.forward
    local right = plyData.right

    forward.z = 0
    local leftPos = pos + (forward * offset) - (right * offset)
    local rightPos = pos + (forward * offset) + (right * offset)

    return ({leftPos, rightPos})
end

function SWEP:CreateWall(pos)
    local ply = self:GetOwner()
    local ent = ents.Create("wallcrusher")

    if (not IsValid(ent) || not IsValid(ply)) then return end

    pos.z = self:SetWallZPos(pos)

    ent:SetPos(pos)
    ent:SetAngles(Angle(0, ply:GetAngles().y, 0))
    ent:SetOwner(self:GetOwner())
    return (ent)
end

function SWEP:SetWallZPos(pos)
    trace = util.TraceLine({
        start = pos,
        endpos = pos + Vector(0, 0, 500),
        mask = MASK_SOLID_BRUSHONLY
    })

    local distance = trace.HitPos:Distance(pos) 
    local offsetAbs = math.abs(STONETHROW.crusher.zStart)

    if (trace.HitWorld == true && distance > offsetAbs && distance < 500) then
        print("have to spawn higher!", trace.HitPos:Distance(pos))
        return (pos.z - STONETHROW.crusher.zStart)
    end
    print(distance)

    trace = util.TraceLine({
        start = pos,
        endpos = pos + Vector(0, 0, -500),
        mask = MASK_SOLID_BRUSHONLY
    })

    local distance = trace.HitPos:Distance(pos)
    print(distance)

    if (trace.HitWorld == true && distance > offsetAbs && distance < 500) then
        print("have to spawn lower!", trace.HitPos:Distance(pos))
        return (trace.HitPos.z + STONETHROW.crusher.zStart)
    end

    return(pos.z + STONETHROW.crusher.zStart)
end

function SWEP:RemoveAll()
    for i = 1, #self.walls, 1 do
        if (IsValid(self.walls[i])) then
            self.walls[i]:Remove()
        end
    end
    for i = 1, #self.walls, 1 do
        table.remove(self.walls, i)
    end
end