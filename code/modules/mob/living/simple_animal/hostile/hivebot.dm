/obj/item/projectile/hivebotbullet
	damage = 10
	damage_type = BRUTE

/mob/living/simple_animal/hostile/hivebot
	name = "hivebot"
	desc = "A strange robot that does not seem pleased to meet you."
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "basic"
	icon_living = "basic"
	icon_dead = "basic"
	gender = NEUTER
	mob_biotypes = list(MOB_ROBOTIC)
	health = 40
	maxHealth = 40
	healable = 0
	melee_damage_lower = 8
	melee_damage_upper = 8
	attacktext = "saw"
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

	do_footstep = TRUE

/mob/living/simple_animal/hostile/hivebot/Initialize()
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
	health = 60
	maxHealth = 60

/mob/living/simple_animal/hostile/hivebot/strong
	name = "elite hivebot"
	icon_state = "strong"
	icon_living = "strong"
	icon_dead = "strong"
	desc = "A heavily armed and armored robot that does not seem pleased to meet you."
	health = 95
	maxHealth = 95
	ranged = 1

/mob/living/simple_animal/hostile/hivebot/death(gibbed)
	do_sparks(3, TRUE, src)
	..(1)
