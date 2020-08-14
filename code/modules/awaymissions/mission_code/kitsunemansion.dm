//areas
/area/awaymission/kitsune
	name = "A snowy Mansion"
	icon_state = "away"
	dynamic_lighting = DYNAMIC_LIGHTING_ENABLED
	has_gravity = STANDARD_GRAVITY


//turfs

/turf/open/floor/wood/kitsune
	initial_gas_mix = "o2=22;n2=82;TEMP=263"
	planetary_atmos = TRUE
/turf/open/floor/plating/asteroid/snow/kitsune
	initial_gas_mix = "o2=22;n2=82;TEMP=263"
	planetary_atmos = TRUE
/turf/closed/indestructible/wood/kitsune
	canSmoothWith = list(/obj/structure/falsewall/wood/kitsune, /turf/closed/indestructible/wood/kitsune)
/obj/structure/falsewall/wood/kitsune
	canSmoothWith = list(/turf/closed/indestructible/wood/kitsune, /obj/structure/falsewall/wood/kitsune)

//structure
/obj/structure/bloodsucker/candelabrum/fox
	light_power = 3
	light_range = 4
	anchored = TRUE
	lit = TRUE
	icon_state = "candelabrum_lit"


/obj/machinery/pool/controller/largescan
	scan_range = 15
	temperature = 4
	mist_state = 1
	shocked = 1

//mobs
/mob/living/simple_animal/hostile/fox
	name = "Fox"
	desc = "It's a fox. Seems extra angry."
	icon = 'icons/mob/pets.dmi'
	icon_state = "fox"
	icon_living = "fox"
	icon_dead = "fox_dead"
	maxHealth = 50
	health = 50
	speak = list("Ack-Ack","Ack-Ack-Ack-Ackawoooo","Geckers","Awoo","Tchoff")
	speak_emote = list("geckers", "barks")
	emote_hear = list("howls.","barks.")
	emote_see = list("shakes its head.", "shivers.")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/slab = 3)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	gold_core_spawnable = HOSTILE_SPAWN
	footstep_type = FOOTSTEP_MOB_CLAW
	atmos_requirements = list("min_oxy" = 2, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	unsuitable_atmos_damage = 5
	minbodytemp = 190
	maxbodytemp = 600
	harm_intent_damage = 5
	melee_damage_lower = 20
	melee_damage_upper = 40
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	emote_taunt = list("growls")
	taunt_chance = 20
	gold_core_spawnable = HOSTILE_SPAWN
/mob/living/simple_animal/hostile/fox/kitsune
	name = "Kitsune"
	desc = "It's a fox. Seems to have a magical aura"
	retreat_distance = 4
	minimum_distance = 4
	maxHealth = 200
	health = 200
	gold_core_spawnable = NO_SPAWN
	var/obj/effect/proc_holder/spell/aimed/fireball/fireball = null
	var/obj/effect/proc_holder/spell/targeted/projectile/magic_missile/mm = null
	var/next_cast = 0

/mob/living/simple_animal/hostile/fox/kitsune/Initialize()
	. = ..()
	fireball = new /obj/effect/proc_holder/spell/aimed/fireball
	fireball.clothes_req = NONE
	fireball.mobs_whitelist = null
	fireball.player_lock = FALSE
	AddSpell(fireball)
	var/obj/item/implant/exile/I = new
	I.implant(src, null, TRUE)

	mm = new /obj/effect/proc_holder/spell/targeted/projectile/magic_missile
	mm.clothes_req = NONE
	mm.mobs_whitelist = null
	mm.player_lock = FALSE
	AddSpell(mm)


/mob/living/simple_animal/hostile/fox/kitsune/handle_automated_action()
	. = ..()
	if(target && next_cast < world.time)
		if((get_dir(src,target) in list(SOUTH,EAST,WEST,NORTH)) && fireball.cast_check(0,src)) //Lined up for fireball
			src.setDir(get_dir(src,target))
			fireball.perform(list(target), user = src)
			next_cast = world.time + 50 //One spell per second
			return .
		if(mm.cast_check(0,src))
			mm.choose_targets(src)
			next_cast = world.time + 50
			return .
