/mob/living/simple_animal/hostile/megafauna/dragon/sand
    name = "Sand"
    desc = "The ultimate form of lord Sand, if he is in this form, he is either saving someone from something, or killing some honkers"
    maxHealth = 200000000000
    health = 200000000000
    faction = list("boss","friendly","deity")
    obj_damage = 3000
    melee_damage_upper = 3000
    melee_damage_lower = 3000
    mouse_opacity = MOUSE_OPACITY_ICON
    damage_coeff = list(BRUTE = 0, BURN = 0, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
    loot = list()
    crusher_loot = list()
    butcher_results = list()
    icon = 'sandcode/icons/mob/lavaland/64x64sand.dmi'
    icon_state = "dragon"
    icon_living = "dragon"
    icon_dead = "dragon_dead"
    friendly = "stares down"
    var/allowed_projectile_types = list(/obj/item/projectile/magic/aoe/fireball)
