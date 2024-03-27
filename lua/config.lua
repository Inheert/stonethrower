game.AddParticles("particles/dark_souls/abyss_watcher.pcf")
game.AddParticles("particles/half-life_alyx/antlionfx.pcf")

DOTON = DOTON or {}

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

    //  $$$$$$$\   $$$$$$\   $$$$$$\  $$\   $$\       $$$$$$$$\ $$\   $$\ $$$$$$$\   $$$$$$\  $$\      $$\ $$$$$$$$\ $$$$$$$\  
    //  $$  __$$\ $$  __$$\ $$  __$$\ $$ | $$  |      \__$$  __|$$ |  $$ |$$  __$$\ $$  __$$\ $$ | $\  $$ |$$  _____|$$  __$$\ 
    //  $$ |  $$ |$$ /  $$ |$$ /  \__|$$ |$$  /          $$ |   $$ |  $$ |$$ |  $$ |$$ /  $$ |$$ |$$$\ $$ |$$ |      $$ |  $$ |
    //  $$$$$$$  |$$ |  $$ |$$ |      $$$$$  /           $$ |   $$$$$$$$ |$$$$$$$  |$$ |  $$ |$$ $$ $$\$$ |$$$$$\    $$$$$$$  |
    //  $$  __$$< $$ |  $$ |$$ |      $$  $$<            $$ |   $$  __$$ |$$  __$$< $$ |  $$ |$$$$  _$$$$ |$$  __|   $$  __$$< 
    //  $$ |  $$ |$$ |  $$ |$$ |  $$\ $$ |\$$\           $$ |   $$ |  $$ |$$ |  $$ |$$ |  $$ |$$$  / \$$$ |$$ |      $$ |  $$ |
    //  $$ |  $$ | $$$$$$  |\$$$$$$  |$$ | \$$\          $$ |   $$ |  $$ |$$ |  $$ | $$$$$$  |$$  /   \$$ |$$$$$$$$\ $$ |  $$ |
    //  \__|  \__| \______/  \______/ \__|  \__|         \__|   \__|  \__|\__|  \__| \______/ \__/     \__|\________|\__|  \__|

    // Init the SWEP/Entity table configuration
    DOTON.rockThrower = DOTON.rockThrower or {}

    // number of rocks to spawn.
    DOTON.rockThrower.rockCount = 15
    // Power applied to rock when it is thrown.
    DOTON.rockThrower.throwingPower = 1000
    // Damage applied for rock, each rock generate a random damage between this range.
    DOTON.rockThrower.rockDamage = {10, 30}
    // Delay before the rock begins to fall and is no longer throwable.
    DOTON.rockThrower.delayBeforeDisappearingStart = 10
    // Delay before the rock totally disappear (auto remove).
    DOTON.rockThrower.delayBeforeDisappearing = 5
    // Used to make the rock turns on itself (gravity effect).
    DOTON.rockThrower.stoneAngleVelocity = {-90, 90}
    // Base velocity applied to the rock when it spawn (range is used to avoid all rocks to have the same zPos).
    DOTON.rockThrower.zVelocity = {100, 300}
    // Base velocity decay applied to the zVelocity.
    // Work like this in the code: zVelocity * zVelocityDecay
    DOTON.rockThrower.zVelocityDecay = 0.6
    // Add custom throwing sound.
    DOTON.rockThrower.throwingSounds = {
        "throwing/throwing1.wav",
        "throwing/throwing2.wav",
        "throwing/throwing3.wav",
        "throwing/throwing4.wav"
    }
    // Add custom impact sound.
    DOTON.rockThrower.impactSounds = {
        "impact/impact1.wav",
        "impact/impact2.wav",
        "impact/impact3.wav",
        "impact/impact4.wav"
    }
    // Add custom activate sound (when rocks are activated).
    DOTON.rockThrower.activateSounds = {
        "activate/activate1.wav",
        "activate/activate2.wav",
        "activate/activate3.wav",
        "activate/activate4.wav"
    }
    // Add custom rock model
    DOTON.rockThrower.rockModels = {
        "models/props_wasteland/rockgranite03b.mdl",
        "models/props_wasteland/rockgranite02c.mdl",
        "models/props_wasteland/rockgranite03b.mdl",
        "models/props_wasteland/rockgranite02a.mdl"
    }

    // Don't touch this pls, this is used to avoid table len calculation every time we need it.
    DOTON.rockThrower.throwingSoundsCount = #DOTON.rockThrower.throwingSounds
    DOTON.rockThrower.impactSoundsCount = #DOTON.rockThrower.impactSounds
    DOTON.rockThrower.activateSoundsCount = #DOTON.rockThrower.activateSounds
    DOTON.rockThrower.rockModelsCount = #DOTON.rockThrower.rockModels

    //  $$$$$$\  $$$$$$$\  $$\   $$\  $$$$$$\  $$\   $$\ $$$$$$$$\ $$$$$$$\  
    //  $$  __$$\ $$  __$$\ $$ |  $$ |$$  __$$\ $$ |  $$ |$$  _____|$$  __$$\ 
    //  $$ /  \__|$$ |  $$ |$$ |  $$ |$$ /  \__|$$ |  $$ |$$ |      $$ |  $$ |
    //  $$ |      $$$$$$$  |$$ |  $$ |\$$$$$$\  $$$$$$$$ |$$$$$\    $$$$$$$  |
    //  $$ |      $$  __$$< $$ |  $$ | \____$$\ $$  __$$ |$$  __|   $$  __$$< 
    //  $$ |  $$\ $$ |  $$ |$$ |  $$ |$$\   $$ |$$ |  $$ |$$ |      $$ |  $$ |
    //  \$$$$$$  |$$ |  $$ |\$$$$$$  |\$$$$$$  |$$ |  $$ |$$$$$$$$\ $$ |  $$ |
    //   \______/ \__|  \__| \______/  \______/ \__|  \__|\________|\__|  \__|

    // Init the SWEP/Entity table configuration
    DOTON.crusher = DOTON.crusher or {}

    // Used to define all wall pairs (2 values means 2 pairs of wall)
    DOTON.crusher.ForwardOffsets = {200, 400, 600, 800}
    // Range of damage applied by each wall.
    DOTON.crusher.damage = {10, 500}
    // Base velocity applied to the entity when it spawn (used to make the entity go upper).
    DOTON.crusher.zVelocity = 500
    // Force multiplier applied to the zVelocity.
    DOTON.crusher.forceMultiplier = 3.2
    // Friction applied to the zVelocity (act like a negative force).
    DOTON.crusher.friction = DOTON.crusher.forceMultiplier / 1.5
    // Start pos i z axis, used to make the effect of the rock appears from the floor.
    DOTON.crusher.zStart = -140
    // Set the delay before Think function (Modify this can modify the behavior of the script).
    DOTON.crusher.nextThink = 0.5

    // Don't touch this pls, this is used to avoid table len calculation every time we need it.
    DOTON.crusher.ForwardOffsetsCount = #DOTON.crusher.ForwardOffsets

    //  $$\      $$\  $$$$$$\  $$\       $$\       $$$$$$$$\ $$$$$$$\  
    //  $$ | $\  $$ |$$  __$$\ $$ |      $$ |      $$  _____|$$  __$$\ 
    //  $$ |$$$\ $$ |$$ /  $$ |$$ |      $$ |      $$ |      $$ |  $$ |
    //  $$ $$ $$\$$ |$$$$$$$$ |$$ |      $$ |      $$$$$\    $$$$$$$  |
    //  $$$$  _$$$$ |$$  __$$ |$$ |      $$ |      $$  __|   $$  __$$< 
    //  $$$  / \$$$ |$$ |  $$ |$$ |      $$ |      $$ |      $$ |  $$ |
    //  $$  /   \$$ |$$ |  $$ |$$$$$$$$\ $$$$$$$$\ $$$$$$$$\ $$ |  $$ |
    //  \__/     \__|\__|  \__|\________|\________|\________|\__|  \__|

    // Init the SWEP/Entity table configuration
    DOTON.waller = DOTON.waller or {}

    // Used to configure entities (walls), this give you a modulable SWEP
    // Example: 
    // DOTON.waller.wallsOffset = {
    //  {[100] = {25}},
    // }
    // This example mean that at 100 units forward the player, 2 walls will appear, 
    // one 25 units to the right, the other one 25 units to the left.
    DOTON.waller.wallsOffset = {
        {[100] = {25}},
        {[70] = {75}},
        {[30] = {125}}
    }
    // Start pos i z axis, used to make the effect of the rock appears from the floor.
    DOTON.waller.zStart = -150
    // Used to define a random angle when entity is created to avoid resemblance. 
    DOTON.waller.angles = {0, 90, 180, 360}
    // Delay before each element of DOTON.waller.wallsOffset are created.
    DOTON.waller.delayBetweenWalls = 0.1

    // Don't touch this pls, this is used to avoid table len calculation every time we need it.
    DOTON.waller.anglesCount = #DOTON.waller.angles
    DOTON.waller.wallsOffsetCount = #DOTON.waller.wallsOffset

    // PARTICLES INIT AND PRECACHE

    DOTON.particles = DOTON.particles or {}

    // here are defined every particles we used in the addon, they are all precached, feel free to add your own.
    DOTON.particles.stoneThrowerInit = {name = "tm_ground_inf", angle = Angle(0, 0, 0)}
    DOTON.particles.wallerInit = {name = "tm_ground_pillar", angle = Angle(0, 0, 0)}
    DOTON.particles.RockTeleport = {name = "AntlionFX_Burrow_dust_v2_b2", angle = Angle(0, 0, 0)}

    for k, v in pairs(DOTON.particles) do
        if (v.name != nil) then
            PrecacheParticleSystem(v.name)
        end
    end

    // COLLISIONS SETTINGS
    // Some entities need custom collision especially the one who have to no collide with the world or with itself.
    DOTON.collisionsGroup = DOTON.collisionsGroup or {}

    DOTON.collisionsGroup.NO_WORLD_COLLISION = 100
    DOTON.collisionsGroup.NO_WORLD_AND_SELF_COLLISION = 101
end