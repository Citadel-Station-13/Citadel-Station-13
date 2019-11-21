/*
Treacherous extracts:
	Have a unique effect when you stab someone with it,
	8% chance of it stabbing you instead.
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
			H.apply_damage(rand(5,7),BRUTE,check_zone(G.zone_selected))
			H.visible_message("<span class='warning'>[user] stabs [target] with [src]!</span>","<span class='userdanger'>[user] shanks you with the [src]!</span>")
			var/delete = do_effect(G, H)
			if (delete != FALSE)
				uses--
			if (uses == 0)
				qdel(src)
				return
		else
			G.apply_damage(rand(5,7),BRUTE,check_zone(H.zone_selected))
			G.visible_message("<span class='warning'>[user] tries to stab [target] with [src], but stabs [user.p_them()]self instead!</span>","<span class='userdanger'>A hidden blade slides out of the [src] and stabs you!</span>")
			var/delete = do_effect(H, G)
			if (delete != FALSE)
				uses--
			if (uses == 0)
				qdel(src)
				return

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
	target.electrocute_act(rand(30,49),src,1,1)
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
	uses = 3

/obj/item/slimecross/treacherous/silver/do_effect(mob/user,mob/living/target)
	target.nutrition += 450
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
	var/mob/living/victim
	var/stabsleft = 0
	var/zonestabbed = BODY_ZONE_CHEST
	uses = -1

/obj/item/slimecross/treacherous/cerulean/do_effect(mob/user,mob/living/target)
	victim = target
	stabsleft = 7
	zonestabbed = check_zone(user.zone_selected)
	addtimer(CALLBACK(src, .proc/stab), rand(50,300))
	return FALSE

/obj/item/slimecross/treacherous/cerulean/proc/stab()
	if (stabsleft >= 0 && victim)
		victim.visible_message("<span class='warning'>A knife appears out of thin air and stabs [victim]!</span>","<span class='userdanger'>A knife appears out of nowhere and stabs you!</span>")
		playsound(get_turf(victim), 'sound/weapons/bladeslice.ogg', 50, 1)
		victim.apply_damage(rand(5,10),BRUTE,zonestabbed)
		stabsleft -= 1
		if (stabsleft >= 0)
			addtimer(CALLBACK(src, .proc/stab), rand(50,300))

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
			addtimer(CALLBACK(src, .proc/remove_cult_overlay), rand(2000,3000))
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
	uses = -1

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
	uses = 3

/obj/item/slimecross/treacherous/pink/do_effect(mob/user,mob/living/target)
	SEND_SIGNAL(target, COMSIG_ADD_MOOD_EVENT, "super_depressed", /datum/mood_event/super_depressed)
	..()

/obj/item/slimecross/treacherous/gold
	colour = "gold"
	//spawn a shitty AI controlled simplemob with appearance of the player

/obj/item/slimecross/treacherous/gold/do_effect(mob/user,mob/living/target)
	var/mob/living/simple_animal/hostile/illusion/E = new(target.loc)
	E.Copy_Parent(target, 300, 100, 5, 3)
	E.GiveTarget(target)
	E.Goto(target, target.movement_delay(), E.minimum_distance)
	..()

/obj/item/slimecross/treacherous/oil
	colour = "oil"
	//change this one?

/obj/item/slimecross/treacherous/oil/do_effect(mob/user,mob/living/target)
	target.transferItemToLoc(src, target, TRUE) //not embedded, can't pull it out
	target.visible_message("<span class='danger'>The [src] lodges in [target] before dissolving and spreading over their body, pulsing ominously!</span>","<span class='userdanger'>The [src] lodges in you and starts pulsating ominously!</span>")
	addtimer(CALLBACK(src, .proc/boom), rand(100,300))
	return FALSE

/obj/item/slimecross/treacherous/oil/proc/boom()
	explosion(get_turf(src),0,0,3)

/obj/item/slimecross/treacherous/black
	colour = "black"
	uses = 13

/obj/item/slimecross/treacherous/black/do_effect(mob/living/user,mob/living/target)
	var/healiesyay = rand(10,15)
	target.adjustBruteLoss(healiesyay)
	user.adjustBruteLoss(-(healiesyay))
	..()

/obj/item/slimecross/treacherous/lightpink
	colour = "light pink"
	uses = 4

/obj/item/slimecross/treacherous/lightpink/do_effect(mob/user,mob/living/target)
	target.reagents.add_reagent("pax",10)
	..()

/obj/item/slimecross/treacherous/adamantine
	colour = "adamantine"
	uses = 2
	var/armorset = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 0, "acid" = 0)

/obj/item/slimecross/treacherous/adamantine/proc/no_armor(obj/item/J)
	var/list/armor = J.armor
	if (armor["melee"] == 0 && armor["bullet"] == 0 && armor["laser"] == 0 && armor["energy"] == 0 && armor["bomb"] == 0 && armor["bio"] == 0 && armor["rad"] == 0 && armor["fire"] == 0)
		return TRUE
	return FALSE

/obj/item/slimecross/treacherous/adamantine/do_effect(mob/user,mob/living/target)
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		if (!no_armor(H.head))
			H.head.armor = armorset
			to_chat(H,"<span class='warning'>[H.head.name] suddenly decays!</span>")
			H.head.name = "decayed [H.head.name]"
		if (!no_armor(H.wear_suit))
			H.wear_suit.armor = armorset
			to_chat(H,"<span class='warning'>[H.wear_suit.name] suddenly decays!</span>")
			H.wear_suit.name = "decayed [H.wear_suit.name]"
		if (!no_armor(H.w_uniform))
			H.w_uniform.armor = armorset
			to_chat(H,"<span class='warning'>[H.w_uniform.name] suddenly decays!</span>")
			H.w_uniform.name = "decayed [H.w_uniform.name]"
	..()

/obj/item/slimecross/treacherous/rainbow
	colour = "rainbow"
	uses = 1
	var/rtype = "damage"
	var/rtypes = list("treacherous" = 1,"damage" = 10, "mulligan" = 1)

/obj/item/slimecross/treacherous/rainbow/Initialize()
	..()
	rtype = pick(rtypes)
	uses = rtypes[rtype]
	switch(rtype)
		if ("damage")
			desc = "[desc]\nIt looks <b>spiky</b>."
		if ("mulligan")
			desc = "[desc]\nIt keeps changing color."
		if ("treacherous")
			desc = "[desc]\nIt's pulsating wildly."


/obj/item/slimecross/treacherous/rainbow/do_effect(mob/user,mob/living/target)
	switch(rtype)
		if ("treacherous")
			var/slimetype = pick(subtypesof(/obj/item/slimecross/treacherous))
			var/obj/item/slimecross/treacherous/M = new slimetype
			M.do_effect(user,target)
			qdel(M)
		if ("damage")
			var/damagetype = pick("brute","burn","toxin","clone","brain","rad")
			switch(damagetype)
				if ("clone")
					target.adjustCloneLoss(rand(5,10))
				if ("rad")
					target.rad_act(rand(200,500))
				if ("toxin")
					target.adjustToxLoss(rand(5,10))
				if ("burn")
					target.apply_damage(rand(5,10),BURN,check_zone(user.zone_selected))
				if ("brute")
					target.apply_damage(rand(5,10),BRUTE,check_zone(user.zone_selected))
				if ("brain")
					target.adjustOrganLoss(ORGAN_SLOT_BRAIN, rand(10,20))
		if ("mulligan")
			randomize_human(target)
			to_chat(target,"<span class='warning'>You feel different...</span>")
	..()
