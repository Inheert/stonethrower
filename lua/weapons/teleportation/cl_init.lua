include("shared.lua")

function SWEP:Initialize()
    self.hooks = {
        {"HUDPaint", "TeleportationDrawMarker"}
    }
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Think()
    hook.Add("HUDPaint", "TeleportationDrawMarker", function()
        local ply = LocalPlayer()

        if (not IsValid(ply)) then return end

        local trace = ply:GetEyeTrace()
        local hitPos = trace.HitPos
        local distance = self:GetOwner():GetPos():Distance(hitPos)

        if (not trace.Hit || trace.HitNormal.z <= 0.7 || distance > 2000) then return end

        local scrPos = hitPos:ToScreen()

        surface.SetDrawColor(255, 255, 255, 255) -- White color
        surface.DrawLine(scrPos.x - 5, scrPos.y, scrPos.x + 5, scrPos.y)
        surface.DrawLine(scrPos.x, scrPos.y - 5, scrPos.x, scrPos.y + 5)
    end)
end