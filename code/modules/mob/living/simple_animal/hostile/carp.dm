#define REGENERATION_DELAY 60  // After taking damage, how long it takes for automatic regeneration to begin for megacarps (ty robustin!)

/mob/living/simple_animal/hostile/carp
	name = "space carp"
	desc = "A ferocious, fang-bearing creature that resembles a fish."
	icon_state = "carp"
	icon_living = "carp"
	icon_dead = "carp_dead"
	icon_gib = "carp_gib"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_chance = 0
	turns_per_move = 5
	butcher_results = list(/obj/item/reagent_containers/food/snacks/carpmeat = 2)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	emote_taunt = list("gnashes")
	taunt_chance = 30
	speed = 0
	maxHealth = 35
	health = 35
	spacewalk = TRUE
	harm_intent_damage = 8
	obj_damage = 50
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	speak_emote = list("gnashes")
	//Space carp aren't affected by cold.
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	faction = list("carp")
	movement_type = FLYING
	pressure_resistance = 200
	gold_core_spawnable = HOSTILE_SPAWN
	//some carps heal over time
	var/regen_cooldown = 0 //Used for how long it takes before a healing will take place default in 60 seconds
	var/regen_amount = 0 //How much is healed pre regen cooldown

/mob/living/simple_animal/hostile/carp/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(regen_amount)
		regen_cooldown = world.time + REGENERATION_DELAY

/mob/living/simple_animal/hostile/carp/BiologicalLife(delta_time, times_fired)
	if(!(. = ..()))
		return
	if(regen_amount && regen_cooldown < world.time)
		heal_overall_damage(regen_amount)

/mob/living/simple_animal/hostile/carp/AttackingTarget()
	. = ..()
	if(. && ishuman(target))
		var/mob/living/carbon/human/H = target
		H.adjustStaminaLoss(8)

/mob/living/simple_animal/hostile/carp/holocarp
	icon_state = "holocarp"
	icon_living = "holocarp"
	maxbodytemp = INFINITY
	gold_core_spawnable = NO_SPAWN
	del_on_death = 1

/mob/living/simple_animal/hostile/carp/megacarp
	icon = 'icons/mob/broadMobs.dmi'
	name = "Mega Space Carp"
	desc = "A ferocious, fang bearing creature that resembles a shark. This one seems especially ticked off."
	icon_state = "megacarp"
	icon_living = "megacarp"
	icon_dead = "megacarp_dead"
	icon_gib = "megacarp_gib"
	health_doll_icon = "megacarp"
	regen_amount = 6

	maxHealth = 30
	health = 30
	pixel_x = -16
	mob_size = MOB_SIZE_LARGE

	obj_damage = 80
	melee_damage_lower = 20
	melee_damage_upper = 20

/mob/living/simple_animal/hostile/carp/megacarp/Initialize(mapload)
	. = ..()
	name = "[pick(GLOB.megacarp_first_names)] [pick(GLOB.megacarp_last_names)]"
	melee_damage_lower += rand(4, 10)
	melee_damage_upper += rand(10,20)
	maxHealth += rand(40,60)
	move_to_delay = rand(3,7)

/mob/living/simple_animal/hostile/carp/cayenne
	name = "Cayenne"
	real_name = "Cayenne"
	desc = "A failed Syndicate experiment in weaponized space carp technology, it now serves as a lovable mascot."
	gender = FEMALE
	speak_emote = list("squeaks")
	AIStatus = AI_OFF
	gold_core_spawnable = NO_SPAWN
	faction = list(ROLE_SYNDICATE)
	/// Keeping track of the nuke disk for the functionality of storing it.
	var/obj/item/disk/nuclear/disky
	/// Location of the file storing disk overlays
	// var/icon/disk_overlay_file = 'icons/mob/carp.dmi'
	/// Colored disk mouth appearance for adding it as a mouth overlay
	var/mutable_appearance/colored_disk_mouth

/mob/living/simple_animal/hostile/carp/cayenne/Initialize(mapload)
	. = ..()
	// AddElement(/datum/element/pet_bonus, "bloops happily!")
	// colored_disk_mouth = mutable_appearance(SSgreyscale.GetColoredIconByType(/datum/greyscale_config/carp/disk_mouth, greyscale_colors), "disk_mouth")
	ADD_TRAIT(src, TRAIT_DISK_VERIFIER, INNATE_TRAIT) //carp can verify disky

/mob/living/simple_animal/hostile/carp/cayenne/IsAdvancedToolUser()
	return TRUE //carp SMART

/mob/living/simple_animal/hostile/carp/cayenne/death(gibbed)
	if(disky)
		disky.forceMove(drop_location())
		disky = null
	return ..()

/mob/living/simple_animal/hostile/carp/cayenne/Destroy(force)
	QDEL_NULL(disky)
	return ..()

/mob/living/simple_animal/hostile/carp/cayenne/examine(mob/user)
	. = ..()
	if(disky)
		. += span_notice("Wait... is that [disky] in [p_their()] mouth?")

/mob/living/simple_animal/hostile/carp/cayenne/AttackingTarget(atom/attacked_target)
	if(istype(attacked_target, /obj/item/disk/nuclear))
		var/obj/item/disk/nuclear/potential_disky = attacked_target
		if(potential_disky.anchored)
			return
		potential_disky.forceMove(src)
		disky = potential_disky
		to_chat(src, span_nicegreen("YES!! You manage to pick up [disky]. (Click anywhere to place it back down.)"))
		update_icon()
		if(!disky.fake)
			client.give_award(/datum/award/achievement/misc/cayenne_disk, src)
		return
	if(disky)
		if(isopenturf(attacked_target))
			to_chat(src, span_notice("You place [disky] on [attacked_target]"))
			disky.forceMove(attacked_target.drop_location())
			disky = null
			update_icon()
		else
			disky.melee_attack_chain(src, attacked_target)
		return
	return ..()

/mob/living/simple_animal/hostile/carp/cayenne/Exited(atom/movable/gone, direction)
	. = ..()
	if(disky == gone)
		disky = null
		update_icon()

/mob/living/simple_animal/hostile/carp/cayenne/update_overlays()
	. = ..()
	if(!disky || stat == DEAD)
		return
	// . += colored_disk_mouth
	// . += mutable_appearance(disk_overlay_file, "disk_overlay")

#undef REGENERATION_DELAY
