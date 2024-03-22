STONETHROW = STONETHROW or {}

if (SERVER) then
    // Add all necessary resources (like sounds)
    resource.AddFile("sound/throwing/throwing1.wav")
    resource.AddFile("sound/throwing/throwing2.wav")
    resource.AddFile("sound/throwing/throwing3.wav")
    resource.AddFile("sound/throwing/throwing4.wav")
    resource.AddFile("sound/impact/impact1.wav")
    resource.AddFile("sound/impact/impact2.wav")
    resource.AddFile("sound/impact/impact3.wav")
    resource.AddFile("sound/impact/impact4.wav")
    resource.AddFile("sound/activate/activate1.wav")
    resource.AddFile("sound/activate/activate2.wav")
    resource.AddFile("sound/activate/activate3.wav")
    resource.AddFile("sound/activate/activate4.wav")

    // Add custom throwing sound.
    STONETHROW.throwingSounds = {
        "throwing/throwing1.wav",
        "throwing/throwing2.wav",
        "throwing/throwing3.wav",
        "throwing/throwing4.wav"
    }

    // Add custom impact sound.
    STONETHROW.impactSounds = {
        "impact/impact1.wav",
        "impact/impact2.wav",
        "impact/impact3.wav",
        "impact/impact4.wav"
    }

    // Add custom activate sound (when rocks are activated).
    STONETHROW.activateSounds = {
        "activate/activate1.wav",
        "activate/activate2.wav",
        "activate/activate3.wav",
        "activate/activate4.wav"
    }

    STONETHROW.rockModels = {
        "models/props_wasteland/rockgranite03b.mdl",
        "models/props_wasteland/rockgranite02c.mdl",
        "models/props_wasteland/rockgranite03b.mdl",
        "models/props_wasteland/rockgranite02a.mdl"
    }

    // number of rocks to spawn.
    STONETHROW.rockCount = 15
    // Power applied to rock when it is thrown.
    STONETHROW.throwingPower = 1000
    // Damage applied for rock, each rock generate a random damage between this range.
    STONETHROW.rockDamage = {10, 30}

    // Delay before the rock begins to fall and is no longer throwable.
    STONETHROW.delayBeforeDisappearingStart = 10
    // Delay before the rock totally disappear (auto remove).
    STONETHROW.delayBeforeDisappearing = 5

    // Used to make the rock turns on itself.
    STONETHROW.stoneAngleVelocity = {-90, 90}
    // Base velocity applied to the rock when it spawn.
    STONETHROW.zVelocity = {200, 300}
    // Base velocity decay applied to the zVelocity.
    // Work like this in the code: zVelocity * zVelocityDecay
    STONETHROW.zVelocityDecay = 0.6

    // Don't touch this pls.
    STONETHROW.throwingSoundsCount = #STONETHROW.throwingSounds
    STONETHROW.impactSoundsCount = #STONETHROW.impactSounds
    STONETHROW.activateSoundsCount = #STONETHROW.activateSounds
    STONETHROW.rockModelsCount = #STONETHROW.rockModels

    // CRUSHER CONFIG
    STONETHROW.crusher = STONETHROW.crusher or {}

    STONETHROW.crusher.nextThink = 0.5

    STONETHROW.crusher.damage = {10, 500}
    STONETHROW.crusher.wallOffset = 200
    STONETHROW.crusher.zStart = -140
    STONETHROW.crusher.zVelocity = 500
    STONETHROW.crusher.forceMultiplier = 3.2
    STONETHROW.crusher.friction = STONETHROW.crusher.forceMultiplier / 1.5
    STONETHROW.crusher.ForwardOffsets = {200, 400, 600, 800}

    STONETHROW.crusher.ForwardOffsetsCount = #STONETHROW.crusher.ForwardOffsets

    // COLLISIONS SETTINGS
    STONETHROW.collisionsGroup = STONETHROW.collisionsGroup or {}

    STONETHROW.collisionsGroup.NO_WORLD_COLLISION = 100
end