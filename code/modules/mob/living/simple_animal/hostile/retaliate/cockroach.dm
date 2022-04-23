/mob/living/simple_animal/hostile/retaliate/cockroach
	name = "cockroach"
	desc = "This station is just crawling with bugs."
	icon_state = "cockroach"
	icon_dead = "cockroach"
	blood_volume = 50
	health = 1
	maxHealth = 1
	turns_per_move = 5
	loot = list(/obj/effect/decal/cleanable/insectguts)
	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 270
	maxbodytemp = INFINITY
	pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
	mob_size = MOB_SIZE_TINY
	mob_biotypes = MOB_ORGANIC|MOB_BUG
	response_help_continuous = "pokes"
	response_help_simple = "poke"
	response_disarm_continuous = "shoos"
	response_disarm_simple = "shoo"
	response_harm_continuous = "splats"
	response_harm_simple = "splat"
	speak_emote = list("chitters")
	density = FALSE
	mob_size = MOB_SIZE_TINY
	gold_core_spawnable = FRIENDLY_SPAWN
	verb_say = "chitters"
	verb_ask = "chitters inquisitively"
	verb_exclaim = "chitters loudly"
	verb_yell = "chitters loudly"
	obj_damage = 5
	environment_smash = null
	dodge_prob = 75
	var/squish_chance = 50
	del_on_death = 1
	var/cockroach_cell_line = CELL_LINE_TABLE_COCKROACH

/mob/living/simple_animal/hostile/retaliate/cockroach/Initialize()
	. = ..()
	AddElement(/datum/element/ventcrawling, given_tier = VENTCRAWLER_ALWAYS)
	add_cell_sample()

/mob/living/simple_animal/hostile/retaliate/cockroach/add_cell_sample()
	AddElement(/datum/element/swabable, cockroach_cell_line, CELL_VIRUS_TABLE_GENERIC_MOB, 1, 7)

/mob/living/simple_animal/hostile/retaliate/cockroach/death(gibbed)
	if(SSticker.mode && SSticker.mode.station_was_nuked) //If the nuke is going off, then cockroaches are invincible. Keeps the nuke from killing them, cause cockroaches are immune to nukes.
		return
	..()

/mob/living/simple_animal/hostile/retaliate/cockroach/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM))
		var/mob/living/A = AM
		if(A.mob_size > MOB_SIZE_SMALL && !(A.movement_type & FLYING))
			if(HAS_TRAIT(A, TRAIT_PACIFISM))
				A.visible_message("<span class='notice'>[A] carefully steps over [src].</span>", "<span class='notice'>You carefully step over [src] to avoid hurting it.</span>")
				return
			if(prob(squish_chance))
				A.visible_message("<span class='notice'>[A] squashed [src].</span>", "<span class='notice'>You squashed [src].</span>")
				adjustBruteLoss(1) //kills a normal cockroach
			else
				visible_message("<span class='notice'>[src] avoids getting crushed.</span>")
	else if(isstructure(AM))
		if(prob(squish_chance))
			AM.visible_message("<span class='notice'>[src] is crushed under [AM].</span>")
			adjustBruteLoss(1)
		else
			visible_message("<span class='notice'>[src] avoids getting crushed.</span>")

/mob/living/simple_animal/hostile/retaliate/cockroach/ex_act(severity, target, origin) //Explosions are a terrible way to handle a cockroach.
	return

/obj/item/projectile/glockroachbullet
	damage = 10 //same damage as a hivebot
	damage_type = BRUTE

/obj/item/ammo_casing/glockroach
	name = "0.9mm bullet casing"
	desc = "A... 0.9mm bullet casing? What?"
	projectile_type = /obj/item/projectile/glockroachbullet


/mob/living/simple_animal/hostile/retaliate/cockroach/glockroach
	name = "glockroach"
	desc = "HOLY SHIT, THAT COCKROACH HAS A GUN!"
	icon_state = "glockroach"
	melee_damage_lower = 2.5
	melee_damage_upper = 10
	obj_damage = 10
	gold_core_spawnable = HOSTILE_SPAWN
	faction = list("hostile")
	cockroach_cell_line = CELL_LINE_TABLE_GLOCKROACH
	ranged = 1
	retreat_distance = 5
	minimum_distance = 5
	casingtype = /obj/item/ammo_casing/glockroach

/mob/living/simple_animal/hostile/retaliate/cockroach/hauberoach
	name = "hauberoach"
	desc = "Is that cockroach wearing a tiny yet immaculate replica 19th century Prussian spiked helmet? ...Is that a bad thing?"
	icon_state = "hauberoach"
	attack_verb_continuous = "rams its spike into"
	attack_verb_simple = "ram your spike into"
	melee_damage_lower = 2.5
	melee_damage_upper = 10
	obj_damage = 10
	gold_core_spawnable = HOSTILE_SPAWN
	faction = list("hostile")
	sharpness = SHARP_POINTY
	cockroach_cell_line = CELL_LINE_TABLE_HAUBEROACH

/mob/living/basic/cockroach/hauberoach/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/caltrop, min_damage = 10, max_damage = 15, flags = (CALTROP_BYPASS_SHOES | CALTROP_IGNORE_WALKERS))

///Proc used to override the squashing behavior of the normal cockroach.
/mob/living/simple_animal/hostile/retaliate/cockroach/hauberoach/proc/on_squish(mob/living/cockroach, mob/living/living_target)
	if(!istype(living_target))
		return FALSE //We failed to run the invoke. Might be because we're a structure. Let the squashable element handle it then!
	if(!HAS_TRAIT(living_target, TRAIT_PIERCEIMMUNE))
		living_target.visible_message(span_danger("[living_target] steps onto [cockroach]'s spike!"), span_userdanger("You step onto [cockroach]'s spike!"))
		return TRUE
	living_target.visible_message(span_notice("[living_target] squashes [cockroach], not even noticing its spike."), span_notice("You squashed [cockroach], not even noticing its spike."))
	return FALSE
