/obj/item/projectile/hivebotbullet
	damage = 15
	damage_type = BRUTE

/mob/living/simple_animal/hostile/hivebot
	name = "hivebot"
	desc = "A strange robot that does not seem pleased to meet you."
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "basic"
	icon_living = "basic"
	icon_dead = "basic"
	gender = NEUTER
	mob_biotypes = MOB_ROBOTIC
	health = 50
	maxHealth = 50
	healable = 0
	melee_damage_lower = 10
	melee_damage_upper = 10
	attack_verb_continuous = "saw"
	attack_verb_simple = "saw"
	attack_sound = 'sound/weapons/bladeslice.ogg'
	projectilesound = 'sound/weapons/gunshot.ogg'
	projectiletype = /obj/item/projectile/hivebotbullet
	faction = list("hivebot")
	check_friendly_fire = 1
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	speak_emote = list("states")
	gold_core_spawnable = HOSTILE_SPAWN
	del_on_death = 1
	loot = list(/obj/effect/decal/cleanable/robot_debris)
	blood_volume = 0

	footstep_type = FOOTSTEP_MOB_CLAW

/mob/living/simple_animal/hostile/hivebot/Initialize(mapload)
	. = ..()
	deathmessage = "[src] blows apart!"

/mob/living/simple_animal/hostile/hivebot/range
	name = "combat hivebot"
	desc = "An armed robot that does not seem pleased to meet you."
	icon_state = "ranged"
	icon_living = "ranged"
	icon_dead = "ranged"
	ranged = 1
	retreat_distance = 5
	minimum_distance = 5

/mob/living/simple_animal/hostile/hivebot/rapid
	name = "gunner hivebot"
	icon_state = "ranged"
	icon_living = "ranged"
	icon_dead = "ranged"
	ranged = 1
	rapid = 3
	retreat_distance = 5
	minimum_distance = 5

/mob/living/simple_animal/hostile/hivebot/engineering
	name = "engineering hivebot"
	icon_state = "EngBot"
	icon_living = "EngBot"
	icon_dead = "EngBot"
	desc = "A strange engineering robot that does not seem pleased to meet you."
	health = 75
	maxHealth = 75

/mob/living/simple_animal/hostile/hivebot/strong
	name = "elite hivebot"
	icon_state = "strong"
	icon_living = "strong"
	icon_dead = "strong"
	desc = "A heavily armed and armored robot that does not seem pleased to meet you."
	health = 100
	maxHealth = 100
	ranged = 1

/mob/living/simple_animal/hostile/hivebot/death(gibbed)
	do_sparks(3, TRUE, src)
	..(1)
