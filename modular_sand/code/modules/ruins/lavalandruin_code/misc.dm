/obj/item/katana/goldbrand
	icon = 'modular_sand/icons/obj/items_and_weapons.dmi'
	icon_state = "goldbrand"
	item_state = "goldbrand"
	lefthand_file = 'modular_sand/icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'modular_sand/icons/mob/inhands/weapons/swords_righthand.dmi'
	name = "Goldbrand"
	desc = "Granted only to those who prove themselves in battle, this sword cuts and burns flesh."
	force = 18
	armour_penetration = 15
	block_chance = 35 //not too bad really
	var/burn_force = 5
	var/firestacking = 10
	light_color = "#FFFF99"
	light_range = 2
	light_power = 1
	var/list/ourmegafauna = list()
	var/upgradedname = "Eltonbrand"
	var/upgradeddesc = "Go to Hell, Carolina!"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/katana/goldbrand/Initialize()
	. = ..()
	START_PROCESSING(SSobj,src)

/obj/item/katana/goldbrand/Destroy()
	STOP_PROCESSING(SSobj,src)
	. = ..()

/obj/item/katana/goldbrand/process()
	ourmegafauna = list()
	for(var/mob/living/simple_animal/hostile/megafauna/M in GLOB.mob_living_list)
		if(M.stat != DEAD)
			ourmegafauna |= M
	if(!length(ourmegafauna))
		visible_message("<span class='warning'>[src] shines brightly, turning into [upgradedname]!</span>")
		name = upgradedname
		desc = upgradeddesc
		block_chance = 66
		armour_penetration = 35
		force = 20
		burn_force = 20
		firestacking = 20
		light_range = 3
		light_power = 2
		w_class = WEIGHT_CLASS_NORMAL
		STOP_PROCESSING(SSobj,src)

/obj/item/katana/goldbrand/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. =..()
	if(proximity_flag)
		if(iscarbon(target))
			var/mob/living/carbon/L = target
			var/mob/living/carbon/ourman = user
			L.apply_damage(damage = burn_force,damagetype = BURN, def_zone = L.get_bodypart(check_zone(ourman.zone_selected)), blocked = FALSE, forced = FALSE)
			L.adjust_fire_stacks(firestacking)
			L.IgniteMob()
		else if(isliving(target))
			var/mob/living/thetarget = target
			thetarget.adjustBruteLoss(burn_force)

/obj/effect/wrath
	name = "Wrath's Wall"
	desc = "Only those who truly revel in destruction can pass."
	anchored = TRUE
	density = TRUE
	icon_state = "shield-cult"
	icon = 'icons/effects/cult_effects.dmi'
	color = "#FF0000"
	var/list/megalist = list()
	var/list/cmegalist = list()

/obj/effect/wrath/Initialize()
	..()
	megalist = list("Cockblock", "Cockblock", "Cockblock") //cockblock just to be sure that no one goes through the wrath wall in the 10 minute grace period
	addtimer(CALLBACK(src, .proc/updatemegalist), 6000) //10 minutes delay so that all megafauna can spawn and etc.

/obj/effect/wrath/proc/updatemegalist()
	megalist = list()
	for(var/mob/living/simple_animal/hostile/megafauna/M in GLOB.mob_living_list)
		megalist += M.name

/obj/effect/wrath/CanPass(atom/movable/mover, turf/target)
	cmegalist = list() //clears the list to not cause problems.
	for(var/mob/living/simple_animal/hostile/megafauna/M in GLOB.mob_living_list)
		cmegalist += M
	if(ishuman(mover))
		var/mob/living/carbon/human/H = mover
		if(cmegalist.len <= megalist.len - 2)
			H.visible_message("<span class='warning'>[H] pushes through [src]!</span>", "<span class='notice'>You deserve your reward. Reap your hunt.</span>")
			return TRUE
		else
			to_chat(H, "<span class='warning'>Just touching the door burns your hand... You're not ready.</span>")
			H.apply_damage(damage = 5,damagetype = BURN, def_zone = H.get_bodypart(BODY_ZONE_R_ARM), blocked = FALSE, forced = FALSE)

/area/ruin/powered/wrath
	icon_state = "dk_yellow"
