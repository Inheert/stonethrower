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

    // number of rocks to spawn.
    STONETHROW.rockCount = 15
    // Power applied to rock when it is thrown.
    STONETHROW.throwingPower = 10000
    // Damage applied for rock, each rock generate a random damage between this range.
    STONETHROW.rockDamage = {40, 800}

    // Delay before the rock begins to fall and is no longer throwable.
    STONETHROW.delayBeforeDisappearingStart = 10
    // Delay before the rock totally disappear (auto remove).
    STONETHROW.delayBeforeDisappearing = 5

    // Used to make the rock turns on itself.
    STONETHROW.stoneAngleVelocity = {-90, 90}
    // Base velocity applied to the rock when it spawn.
    STONETHROW.zVelocity = {200, 300}
    // Base velocity decay applied to the zVelocity.
    STONETHROW.zVelocityDecay = {100, 200}

    // Don't touch this pls.
    STONETHROW.throwingSoundsCount = #STONETHROW.throwingSounds
    STONETHROW.impactSoundsCount = #STONETHROW.impactSounds
    STONETHROW.activateSoundsCount = #STONETHROW.activateSounds
end