/*
Treacherous extracts:
	Have a unique effect when you stab someone with it, 8% chance of it stabbing you instead.
*/
/obj/item/slimecross/treacherous
	name = "treacherous extract"
	desc = "Looking at it makes you want to stab your friends."
	effect = "treacherous"
	icon_state = "treacherous"
	hitsound = 'sound/weapons/bladeslice.ogg'
	var/uses = 1

/obj/item/slimecross/treacherous/afterattack(atom/target,mob/user,proximity)
	. = ..()
	if (!proximity)
		return
	if (isliving(target))
		var/mob/living/H = target
		var/mob/living/G = user
		if (rand(1,25) < 23)
			H.apply_damage(5,BRUTE,check_zone(G.zone_selected))
			H.visible_message("<span class='warning'>[user] stabs [target] with [src]!</span>","<span class='userdanger'>[user] shanks you with the [src]!</span>")
			var/delete = do_effect(G, H)
			if (!delete)
				delete = TRUE
			if (uses - 1 == 0 && delete == TRUE)
				qdel(src)
				return
			if (delete == TRUE)
				uses--
		else
			G.apply_damage(5,BRUTE,check_zone(H.zone_selected))
			G.visible_message("<span class='warning'>[user] tries to stab [target] with [src], but stabs [user.p_them()]self instead!</span>","<span class='userdanger'>A hidden blade slides out of the [src] and stabs you!</span>")
			var/delete = do_effect(H, G)
			if (!delete)
				delete = TRUE
			if (uses - 1 == 0 && delete == TRUE)
				qdel(src)
				return
			if (delete == TRUE)
				uses--

/obj/item/slimecross/treacherous/proc/do_effect(mob/user,mob/living/target)
	return TRUE

/obj/item/slimecross/treacherous/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] stabs [user.p_them()]self in the head with [src]! But the hardened slime blade retracted, it betrayed [user.p_their()] intentions!</span>")
	return MANUAL_SUICIDE

/obj/item/slimecross/treacherous/grey
	colour = "grey"
	uses = 2

/obj/item/slimecross/treacherous/grey/do_effect(mob/user,mob/living/target)
	target.adjustCloneLoss(rand(30,40))
	..()

/obj/item/slimecross/treacherous/orange
	colour = "orange"
	uses = 3

/obj/item/slimecross/treacherous/orange/do_effect(mob/user,mob/living/target)
	target.fire_stacks = 5
	target.adjust_bodytemperature(40)
	target.IgniteMob()
	..()

/obj/item/slimecross/treacherous/purple
	colour = "purple"
	uses = 1

/obj/item/slimecross/treacherous/purple/do_effect(mob/user,mob/living/target)
	target.revive(full_heal = 1)
	target.adjustToxLoss(rand(50,60))
	target.visible_message("<span class='warning'>[src] dissolves in [target], leaving no wound.</span>")
	..()

/obj/item/slimecross/treacherous/blue
	colour = "blue"
	uses = 10

/obj/item/slimecross/treacherous/blue/do_effect(mob/user,mob/living/target)
	target.slip(100,target.loc,GALOSHES_DONT_HELP,0,TRUE)
	..()

/obj/item/slimecross/treacherous/metal
	colour = "metal"
	uses = 1

/obj/item/slimecross/treacherous/metal/do_effect(mob/user,mob/living/target)
	var/r = rand(1,10)
	for (var/turf/H in orange(target,1))
		if (get_dist(get_turf(target),H) > 0)
			if (r < 9)
				new /turf/closed/wall(H)
			else
				new /turf/closed/wall/r_wall(H)
	..()

/obj/item/slimecross/treacherous/yellow
	colour = "yellow"
	uses = 2

/obj/item/slimecross/treacherous/yellow/do_effect(mob/user,mob/living/target)
	playsound(get_turf(src), 'sound/weapons/zapbang.ogg', 50, 1)
	target.electrocute_act(rand(30,60),src,1,1)
	..()

/obj/item/slimecross/treacherous/darkpurple
	colour = "dark purple"
	uses = 1

/obj/item/slimecross/treacherous/darkpurple/do_effect(mob/user,mob/living/target)
	user.visible_message("<span class='danger'>[src] dissolves into plasma before lighting on fire!</span>")
	var/turf/T = get_turf(target)
	T.atmos_spawn_air("plasma=57,TEMP=295")
	T.hotspot_expose(700,10,1)
	..()

/obj/item/slimecross/treacherous/darkblue
	colour = "dark blue"
	uses = 2

/obj/item/slimecross/treacherous/darkblue/do_effect(mob/user,mob/living/target)
	target.bodytemperature = 0
	target.apply_status_effect(/datum/status_effect/freon)
	..()

/obj/item/slimecross/treacherous/silver
	colour = "silver"
	uses = 5

/obj/item/slimecross/treacherous/silver/do_effect(mob/user,mob/living/target)

	..()

/obj/item/slimecross/treacherous/bluespace
	colour = "bluespace"
	uses = 1
	var/list/useful_organs = list(ORGAN_SLOT_BRAIN,ORGAN_SLOT_STOMACH,ORGAN_SLOT_LUNGS,ORGAN_SLOT_HEART,ORGAN_SLOT_LIVER)

/obj/item/slimecross/treacherous/bluespace/do_effect(mob/user,mob/living/targ)
	if (istype(targ,/mob/living/carbon))
		var/mob/living/carbon/target = targ
		var/list/organs = list_organs_in_zone(target, zone = user.zone_selected)
		if (organs.len > 0)
			var/obj/item/organ_to_tele = organs[rand(1,organs.len)]
			if (istype(organ_to_tele,/obj/item/bodypart))
				var/obj/item/bodypart/part = organ_to_tele
				part.drop_limb()
				do_teleport(part, find_safe_turf(target.loc.z,extended_safety_checks = TRUE))
			else
				var/obj/item/organ/organ = organ_to_tele
				teleport_organ(target,organ,(organ.slot in useful_organs) ? TRUE : FALSE)
		to_chat(target,"<span class='warning'>You feel as if a part of you is missing!</span>")
	..()

/obj/item/slimecross/treacherous/bluespace/proc/list_organs_in_zone(mob/living/carbon/target,zone = BODY_ZONE_CHEST)
	var/list/listorgans = list()
	if (zone == BODY_ZONE_CHEST || zone == BODY_ZONE_PRECISE_EYES || zone == BODY_ZONE_PRECISE_MOUTH || zone == BODY_ZONE_PRECISE_GROIN || zone == BODY_ZONE_HEAD)
		for (var/obj/item/organ/organ in target.internal_organs)
			if (organ.zone == zone)
				listorgans |= organ
	else
		listorgans |= target.get_bodypart(check_zone(zone))
	return listorgans

/obj/item/slimecross/treacherous/bluespace/proc/teleport_organ(mob/living/carbon/target,obj/item/organ/organ,duplication)
	if (organ)
		if (duplication == FALSE)
			organ.Remove(target)
			do_teleport(organ, find_safe_turf(target.loc.z,extended_safety_checks = TRUE))
		else
			var/damagedone = rand(50,60)
			var/path = organ.type
			var/obj/item/organ/X = new path(find_safe_turf(target.loc.z,extended_safety_checks = TRUE))
			organ.applyOrganDamage(damagedone,organ.maxHealth)
			organ.onDamage(damagedone,X.maxHealth)
			X.applyOrganDamage(damagedone,X.maxHealth)

/obj/item/slimecross/treacherous/sepia
	colour = "sepia"
	uses = 3
	var/turf/position
	var/mob/living/victim
	var/victdir

/obj/item/slimecross/treacherous/sepia/do_effect(mob/user,mob/living/target)
	victim = target
	position = get_turf(target)
	dir = target.dir
	addtimer(CALLBACK(src, .proc/revert_pos), 120)
	return FALSE

/obj/item/slimecross/treacherous/sepia/proc/revert_pos()
	if (victim && position)
		victim.visible_message("<span class='warning'>[victim] disappears!</span>","<span class='userdanger'>You feel youself snap back in time!</span>")
		victim.forceMove(position)
		victim.dir = victdir
		uses--
		if (uses <= 0)
			qdel(src)

/obj/item/slimecross/treacherous/cerulean
	colour = "cerulean"

/obj/item/slimecross/treacherous/cerulean/do_effect(mob/user,mob/living/target)

	..()

/obj/item/slimecross/treacherous/pyrite
	uses = 5
	colour = "pyrite"
	var/mob/living/carbon/human/victim

/obj/item/slimecross/treacherous/pyrite/do_effect(mob/user,mob/living/target)
	if (ishuman(target))
		if (uses != 0)
			if (victim && victim != target)
				remove_cult_overlay()
			victim = target
			var/istate = pick("halo1","halo2","halo3","halo4","halo5","halo6")
			var/mutable_appearance/halo = mutable_appearance('icons/effects/32x64.dmi',istate, -BODY_FRONT_LAYER)
			victim.add_overlay(halo)
			victim.eye_color = "f00"
			victim.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
			ADD_TRAIT(victim,TRAIT_CULT_EYES,"valid_cultist")
			victim.update_body()
			addtimer(CALLBACK(src, .proc/remove_cult_overlay), 3000)
			uses--
		else
			to_chat(user,"<span class='warning'>[src] has no more uses!</span>")
	return FALSE

/obj/item/slimecross/treacherous/pyrite/attack_self(mob/user)
	if (victim)
		remove_cult_overlay()
		if (uses == 0)
			qdel(src)

/obj/item/slimecross/treacherous/pyrite/proc/remove_cult_overlay()
	victim.eye_color = initial(victim.eye_color)
	victim.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
	REMOVE_TRAIT(victim, TRAIT_CULT_EYES, "valid_cultist")
	victim.cut_overlays()
	victim.regenerate_icons()

/obj/item/slimecross/treacherous/red
	colour = "red"

/obj/item/slimecross/treacherous/red/do_effect(mob/user,mob/living/target)
	if (isliving(user))
		var/mob/living/L = user
		L.changeNext_move(CLICK_CD_RAPID)
		L.adjustStaminaLoss(-2)
	return FALSE

/obj/item/slimecross/treacherous/green
	colour = "green"

/obj/item/slimecross/treacherous/green/do_effect(mob/user,mob/living/target)

	..()

/obj/item/slimecross/treacherous/pink
	colour = "pink"
	uses = 4

/obj/item/slimecross/treacherous/pink/do_effect(mob/user,mob/living/target)
	target.reagents.add_reagent("pax",10)
	..()

/obj/item/slimecross/treacherous/gold
	colour = "gold"

/obj/item/slimecross/treacherous/gold/do_effect(mob/user,mob/living/target)

	..()

/obj/item/slimecross/treacherous/oil
	colour = "oil"

/obj/item/slimecross/treacherous/oil/do_effect(mob/user,mob/living/target)
	user.visible_message("<span class='danger'>[src] begins to shake with rapidly increasing force!</span>")
	addtimer(CALLBACK(src, .proc/boom), 50)

/obj/item/slimecross/treacherous/oil/proc/boom()
	explosion(get_turf(src), 2, 4, 4) //Same area as normal oils, but increased high-impact values by one each, then decreased light by 2.
	qdel(src)

/obj/item/slimecross/treacherous/black
	colour = "black"

/obj/item/slimecross/treacherous/black/do_effect(mob/user,mob/living/target)

	..()

/obj/item/slimecross/treacherous/lightpink
	colour = "light pink"

/obj/item/slimecross/treacherous/lightpink/do_effect(mob/user,mob/living/target)

	..()

/obj/item/slimecross/treacherous/adamantine
	colour = "adamantine"

/obj/item/slimecross/treacherous/adamantine/do_effect(mob/user,mob/living/target)

	..()

/obj/item/slimecross/treacherous/rainbow
	colour = "rainbow"

/obj/item/slimecross/treacherous/rainbow/do_effect(mob/user,mob/living/target)

	..()
