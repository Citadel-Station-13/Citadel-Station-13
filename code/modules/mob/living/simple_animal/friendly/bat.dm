/mob/living/simple_animal/bat
    name = "Bat"
    desc = "A fruit bat which is known to roost in spaceships occastionally."
    icon_state = "bat"
    icon_living = "bat"
    icon_dead = "bat_dead"
    icon_gib = "bat_dead"
    turns_per_move = 1
    response_help = "brushes aside"
    response_disarm = "flails at"
    response_harm = "hits"
    mob_biotypes = list(MOB_ORGANIC, MOB_BEAST)
    speak_chance = 0
    maxHealth = 15
    health = 15
    spacewalk = TRUE
    see_in_dark = 10
    harm_intent_damage = 6
    melee_damage_lower = 6
    melee_damage_upper = 5
    attacktext = "bites"
    butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 1)
    pass_flags = PASSTABLE
    gold_core_spawnable = FRIENDLY_SPAWN
    attack_sound = 'sound/weapons/bite.ogg'
    obj_damage = 0
    environment_smash = ENVIRONMENT_SMASH_NONE
    ventcrawler = VENTCRAWLER_ALWAYS
    mob_size = MOB_SIZE_TINY
    movement_type = FLYING
    speak_emote = list("squeaks")
    emote_see = list("squeaks eagerly.", "flaps about.")

/mob/living/simple_animal/bat/secbat
    name = "Security Bat"
    icon_state = "secbat"
    icon_living = "secbat"
    icon_dead = "secbat_dead"
    icon_gib = "secbat_dead"
    desc = "A fruit bat with a tiny little security hat who is ready to inject cuteness into any security operation."
    emote_see = list("is ready to law down the law.", "flaps about with an air of authority.")
    response_help = "respects the authority of"
