/* Tables and Racks
 * Contains:
 *		Tables
 *		Glass Tables
 *		Wooden Tables
 *		Reinforced Tables
 *		Racks
 *		Rack Parts
 */

/*
 * Tables
 */

/obj/structure/table
	name = "table"
	desc = "A square piece of metal standing on four metal legs. It can not move."
	icon = 'icons/obj/smooth_structures/table.dmi'
	icon_state = "table"
	density = 1
	anchored = 1
	layer = TABLE_LAYER
	climbable = TRUE
	pass_flags = LETPASSTHROW //You can throw objects over this, despite it's density.")
	var/frame = /obj/structure/table_frame
	var/framestack = /obj/item/stack/rods
	var/buildstack = /obj/item/stack/sheet/metal
	var/busy = 0
	var/buildstackamount = 1
	var/framestackamount = 2
	var/deconstruction_ready = 1
	var/health = 100
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/obj/structure/table, /obj/structure/table/reinforced)

/obj/structure/table/New()
	..()
	for(var/obj/structure/table/T in src.loc)
		if(T != src)
			qdel(T)

/obj/structure/table/update_icon()
	if(smooth)
		queue_smooth(src)
		queue_smooth_neighbors(src)

/obj/structure/table/ex_act(severity, target)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			take_damage(rand(80,120), BRUTE, 0)
		if(3)
			take_damage(rand(40,80), BRUTE, 0)

/obj/structure/table/blob_act(obj/effect/blob/B)
	if(prob(75))
		qdel(src)

/obj/structure/table/narsie_act()
	if(prob(20))
		new /obj/structure/table/wood(src.loc)

/obj/structure/table/ratvar_act()
	if(prob(20))
		new /obj/structure/table/reinforced/brass(src.loc)

/obj/structure/table/mech_melee_attack(obj/mecha/M)
	playsound(src.loc, 'sound/weapons/punch4.ogg', 50, 1)
	visible_message("<span class='danger'>[M.name] smashes [src]!</span>")
	take_damage(200, M.damtype, 0)

/obj/structure/table/attack_alien(mob/living/user)
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src)
	playsound(src.loc, 'sound/weapons/bladeslice.ogg', 50, 1)
	visible_message("<span class='danger'>[user] slices [src]!</span>")
	take_damage(100, BRUTE, 0)


/obj/structure/table/attack_animal(mob/living/simple_animal/user)
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src)
	if(user.melee_damage_upper)
		var/dmg_dealt = user.melee_damage_upper
		if(user.environment_smash)
			dmg_dealt = 100
		visible_message("<span class='warning'>[user] smashes [src]!</span>")
		playsound(src.loc, 'sound/weapons/Genhit.ogg', 50, 1)
		take_damage(dmg_dealt, user.melee_damage_type, 0)


/obj/structure/table/attack_paw(mob/user)
	attack_hand(user)

/obj/structure/table/attack_hulk(mob/living/carbon/human/user)
	..(user, 1)
	playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
	visible_message("<span class='danger'>[user] smashes [src]!</span>")
	user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
	take_damage(rand(180,280), BRUTE, 0)
	return 1

/obj/structure/table/attack_hand(mob/living/user)
	if(user.a_intent == "grab" && user.pulling && isliving(user.pulling))
		var/mob/living/pushed_mob = user.pulling
		if(pushed_mob.buckled)
			user << "<span class='warning'>[pushed_mob] is buckled to [pushed_mob.buckled]!</span>"
			return
		if(user.grab_state < GRAB_AGGRESSIVE)
			user << "<span class='warning'>You need a better grip to do that!</span>"
			return
		tablepush(user, pushed_mob)
		user.stop_pulling()
	else
		..()

/obj/structure/table/attack_tk() // no telehulk sorry
	return

/obj/structure/table/bullet_act(obj/item/projectile/P)
	. = ..()
	take_damage(P.damage, P.damage_type, 0)

/obj/structure/table/CanPass(atom/movable/mover, turf/target, height=0)
	if(height==0)
		return 1
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	if(mover.throwing)
		return 1
	if(locate(/obj/structure/table) in get_turf(mover))
		return 1
	else
		return !density

/obj/structure/table/CanAStarPass(ID, dir, caller)
	. = !density
	if(ismovableatom(caller))
		var/atom/movable/mover = caller
		. = . || mover.checkpass(PASSTABLE)

/obj/structure/table/proc/tablepush(mob/living/user, mob/living/pushed_mob)
	pushed_mob.forceMove(src.loc)
	pushed_mob.Weaken(2)
	pushed_mob.visible_message("<span class='danger'>[user] pushes [pushed_mob] onto [src].</span>", \
								"<span class='userdanger'>[user] pushes [pushed_mob] onto [src].</span>")
	add_logs(user, pushed_mob, "pushed")


/obj/structure/table/attackby(obj/item/I, mob/user, params)
	if(!(flags & NODECONSTRUCT))
		if(istype(I, /obj/item/weapon/screwdriver) && deconstruction_ready)
			table_deconstruct(user, 1)
			return

		if(istype(I, /obj/item/weapon/wrench) && deconstruction_ready)
			table_deconstruct(user, 0)
			return

	if(istype(I, /obj/item/weapon/storage/bag/tray))
		var/obj/item/weapon/storage/bag/tray/T = I
		if(T.contents.len > 0) // If the tray isn't empty
			var/list/obj/item/oldContents = T.contents.Copy()
			T.quick_empty()

			for(var/obj/item/C in oldContents)
				C.loc = src.loc

			user.visible_message("[user] empties [I] on [src].")
			return
		// If the tray IS empty, continue on (tray will be placed on the table like other items)

	if(user.a_intent != "harm" && !(I.flags & ABSTRACT))
		if(user.drop_item())
			I.Move(loc)
			var/list/click_params = params2list(params)
			//Center the icon where the user clicked.
			if(!click_params || !click_params["icon-x"] || !click_params["icon-y"])
				return
			//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
			I.pixel_x = Clamp(text2num(click_params["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)
			I.pixel_y = Clamp(text2num(click_params["icon-y"]) - 16, -(world.icon_size/2), world.icon_size/2)
			return 1
	else
		return ..()

/obj/structure/table/attacked_by(obj/item/I, mob/living/user)
	..()
	take_damage(I.force, I.damtype)

/obj/structure/table/proc/take_damage(damage, damage_type = BRUTE, sound_effect = 1)
	switch(damage_type)
		if(BRUTE)
			if(sound_effect)
				if(damage)
					playsound(loc, 'sound/weapons/smash.ogg', 50, 1)
				else
					playsound(loc, 'sound/weapons/tap.ogg', 50, 1)
		if(BURN)
			if(sound_effect)
				playsound(loc, 'sound/items/Welder.ogg', 40, 1)
		else
			return
	health -= damage
	if(health <= 0)
		table_destroy()

/*
 * TABLE DESTRUCTION/DECONSTRUCTION
 */



/obj/structure/table/proc/table_destroy()
	if(!(flags & NODECONSTRUCT))
		var/turf/T = get_turf(src)
		for(var/i = 1, i <= framestackamount, i++)
			new framestack(T)
		for(var/i = 1, i <= buildstackamount, i++)
			new buildstack(T)
	qdel(src)


/obj/structure/table/proc/table_deconstruct(mob/user, disassembling = 0)
	if(flags & NODECONSTRUCT)
		return
	if(disassembling)
		user << "<span class='notice'>You start disassembling [src]...</span>"
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 20, target = src))
			new frame(src.loc)
			for(var/i = 1, i <= buildstackamount, i++)
				new buildstack(get_turf(src))
			qdel(src)
	else
		user << "<span class='notice'>You start deconstructing [src]...</span>"
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 40, target = src))
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			table_destroy()


/*
 * Glass tables
 */
/obj/structure/table/glass
	name = "glass table"
	desc = "What did I say about leaning on the glass tables? Now you need surgery."
	icon = 'icons/obj/smooth_structures/glass_table.dmi'
	icon_state = "glass_table"
	buildstack = /obj/item/stack/sheet/glass
	canSmoothWith = null
	health = 50
	var/list/debris = list()

/obj/structure/table/glass/New()
	. = ..()
	debris += new frame
	debris += new /obj/item/weapon/shard

/obj/structure/table/glass/Destroy()
	for(var/i in debris)
		qdel(i)
	. = ..()

/obj/structure/table/glass/Crossed(atom/movable/AM)
	. = ..()
	if(flags & NODECONSTRUCT)
		return
	if(!isliving(AM))
		return
	// Don't break if they're just flying past
	if(AM.throwing)
		spawn(5)
			// Check again in a bit though
			if(AM.loc == get_turf(src))
				check_break(AM)
	else
		check_break(AM)

/obj/structure/table/glass/proc/check_break(mob/living/M)
	if(has_gravity(M) && M.mob_size > MOB_SIZE_SMALL)
		table_shatter(M)

/obj/structure/table/glass/proc/table_shatter(mob/M)
	visible_message("<span class='warning'>[src] breaks!</span>",
		"<span class='danger'>You hear breaking glass.</span>")
	var/turf/T = get_turf(src)
	playsound(T, "shatter", 50, 1)
	for(var/I in debris)
		var/atom/movable/AM = I
		AM.forceMove(T)
		debris -= AM
		if(istype(AM, /obj/item/weapon/shard))
			AM.throw_impact(M)
	M.Weaken(5)
	qdel(src)

/obj/structure/table/glass/narsie_act()
	color = NARSIE_WINDOW_COLOUR
	for(var/obj/item/weapon/shard/S in debris)
		S.color = NARSIE_WINDOW_COLOUR

/*
/obj/structure/table/glass/attack_hand(mob/living/carbon/human/M, mob/living/user)
	var/mob/living/carbon/human/H = M
	if (ishuman(M) && (M.a_intent == "harm"))
//		if(!H.gloves && !(PIERCEIMMUNE in H.dna.species.specflags))
		//if (istype(H.w_uniform, /obj/item/clothing/under/misc/lawyer))
		src.visible_message("<span style=\"color:red\"><b>[H] slams their palms against [src]!</b></span>")
		visible_message("<span class='warning'>[src] breaks!</span>")
		playsound(src.loc, "shatter", 50, 1)
		new frame(src.loc)
		new /obj/item/weapon/shard(src.loc)
		qdel(src)
		H << "<span class='warning'>[src] cuts into your hand!</span>"
		var/organ = (H.hand ? "l_" : "r_") + "arm"
		var/obj/item/bodypart/affecting = H.get_bodypart(organ)
		if(affecting && affecting.take_damage(force / 2))
			H.update_damage_overlays(0)
	else if(ismonkey(user))
		M << "<span class='warning'>[src] cuts into your hand!</span>"
		M.adjustBruteLoss(force / 2) */

/*
 * Wooden tables
 */

/obj/structure/table/wood
	name = "wooden table"
	desc = "Do not apply fire to this. Rumour says it burns easily."
	icon = 'icons/obj/smooth_structures/wood_table.dmi'
	icon_state = "wood_table"
	frame = /obj/structure/table_frame/wood
	framestack = /obj/item/stack/sheet/mineral/wood
	buildstack = /obj/item/stack/sheet/mineral/wood
	burn_state = FLAMMABLE
	burntime = 20
	canSmoothWith = list(/obj/structure/table/wood,
		/obj/structure/table/wood/poker,
		/obj/structure/table/wood/bar)

/obj/structure/table/wood/narsie_act()
	return

/obj/structure/table/wood/poker //No specialties, Just a mapping object.
	name = "gambling table"
	desc = "A seedy table for seedy dealings in seedy places."
	icon = 'icons/obj/smooth_structures/poker_table.dmi'
	icon_state = "poker_table"
	buildstack = /obj/item/stack/tile/carpet

/obj/structure/table/wood/poker/narsie_act()
	new /obj/structure/table/wood(src.loc)

/*
/obj/structure/table/attack_hand(mob/living/carbon/human/M, mob/living/user)
	if (ishuman(M) && (M.a_intent == "harm"))
		var/mob/living/carbon/human/H = M
		//if (istype(H.w_uniform, /obj/item/clothing/under/misc/lawyer))
		src.visible_message("<span style=\"color:red\"><b>[H] slams their palms against [src]!</b></span>")
		playsound(src.loc, 'sound/effects/meteorimpact.ogg', 50, 1)*/
			//for (var/mob/M in AIviewers(usr, null))
			//	if (M.client)
			//		shake_camera(M, 4, 1, 0.5)
	return

/*
 * Reinforced tables
 */
/obj/structure/table/reinforced
	name = "reinforced table"
	desc = "A reinforced version of the four legged table, much harder to simply deconstruct."
	icon = 'icons/obj/smooth_structures/reinforced_table.dmi'
	icon_state = "r_table"
	deconstruction_ready = 0
	buildstack = /obj/item/stack/sheet/plasteel
	canSmoothWith = list(/obj/structure/table/reinforced, /obj/structure/table)
	health = 200

/obj/structure/table/reinforced/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			playsound(src.loc, W.usesound, 50, 1)
			if(deconstruction_ready)
				user << "<span class='notice'>You start strengthening the reinforced table...</span>"
				if (do_after(user, 50/W.toolspeed, target = src))
					if(!src || !WT.isOn()) return
					user << "<span class='notice'>You strengthen the table.</span>"
					deconstruction_ready = 0
			else
				user << "<span class='notice'>You start weakening the reinforced table...</span>"
				if (do_after(user, 50/W.toolspeed, target = src))
					if(!src || !WT.isOn()) return
					user << "<span class='notice'>You weaken the table.</span>"
					deconstruction_ready = 1
	else
		return ..()

/obj/structure/table/reinforced/brass
	name = "brass table"
	desc = "A solid, slightly beveled brass table."
	icon = 'icons/obj/smooth_structures/brass_table.dmi'
	icon_state = "brass_table"
	frame = /obj/structure/table_frame/brass
	framestackamount = 0
	buildstackamount = 0
	canSmoothWith = list(/obj/structure/table/reinforced/brass)

/obj/structure/table/reinforced/brass/table_destroy()
	new frame(src.loc)
	qdel(src)

/obj/structure/table/reinforced/brass/narsie_act()
	take_damage(rand(15, 45), BRUTE)
	if(src) //do we still exist?
		var/previouscolor = color
		color = "#960000"
		animate(src, color = previouscolor, time = 8)

/obj/structure/table/reinforced/brass/ratvar_act()
	health = initial(health)

/*
 * Surgery Tables
 */

/obj/structure/table/optable
	name = "operating table"
	desc = "Used for advanced medical procedures."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "optable"
	buildstack = /obj/item/stack/sheet/mineral/silver
	smooth = SMOOTH_FALSE
	can_buckle = 1
	buckle_lying = 1
	buckle_requires_restraints = 1
	var/mob/living/carbon/human/patient = null
	var/obj/machinery/computer/operating/computer = null

/obj/structure/table/optable/New()
	..()
	for(var/dir in cardinal)
		computer = locate(/obj/machinery/computer/operating, get_step(src, dir))
		if(computer)
			computer.table = src
			break

/obj/structure/table/optable/tablepush(mob/living/user, mob/living/pushed_mob)
	pushed_mob.forceMove(src.loc)
	pushed_mob.resting = 1
	pushed_mob.update_canmove()
	visible_message("<span class='notice'>[user] has laid [pushed_mob] on [src].</span>")
	check_patient()

/obj/structure/table/optable/proc/check_patient()
	var/mob/M = locate(/mob/living/carbon/human, loc)
	if(M)
		if(M.resting)
			patient = M
			return 1
	else
		patient = null
		return 0



/*
 * Racks
 */
/obj/structure/rack
	name = "rack"
	desc = "Different from the Middle Ages version."
	icon = 'icons/obj/objects.dmi'
	icon_state = "rack"
	density = 1
	anchored = 1
	pass_flags = LETPASSTHROW //You can throw objects over this, despite it's density.
	var/health = 20

/obj/structure/rack/ex_act(severity, target)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if(prob(50))
				rack_destroy()
			else
				qdel(src)
		if(3)
			take_damage(rand(5,25), BRUTE, 0)

/obj/structure/rack/blob_act(obj/effect/blob/B)
	if(prob(75))
		qdel(src)
	else
		rack_destroy()


/obj/structure/rack/mech_melee_attack(obj/mecha/M)
	if(..())
		take_damage(M.force*2)

/obj/structure/rack/CanPass(atom/movable/mover, turf/target, height=0)
	if(height==0) return 1
	if(src.density == 0) //Because broken racks -Agouri |TODO: SPRITE!|
		return 1
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return 0

/obj/structure/rack/CanAStarPass(ID, dir, caller)
	. = !density
	if(ismovableatom(caller))
		var/atom/movable/mover = caller
		. = . || mover.checkpass(PASSTABLE)

/obj/structure/rack/MouseDrop_T(obj/O, mob/user)
	if ((!( istype(O, /obj/item/weapon) ) || user.get_active_hand() != O))
		return
	if(!user.drop_item())
		return
	if(O.loc != src.loc)
		step(O, get_dir(O, src))


/obj/structure/rack/attackby(obj/item/weapon/W, mob/user, params)
	if (istype(W, /obj/item/weapon/wrench) && !(flags&NODECONSTRUCT))
		playsound(src.loc, W.usesound, 50, 1)
		rack_destroy()
		return
	if(user.a_intent == "harm")
		return ..()
	if(user.drop_item())
		W.Move(loc)
		return 1

/obj/structure/rack/attacked_by(obj/item/I, mob/living/user)
	..()
	take_damage(I.force, I.damtype)

/obj/structure/rack/attack_paw(mob/living/user)
	attack_hand(user)

/obj/structure/rack/attack_hulk(mob/living/carbon/human/user)
	..(user, 1)
	rack_destroy()
	return 1

/obj/structure/rack/attack_hand(mob/living/user)
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src)
	user.visible_message("<span class='warning'>[user] kicks [src].</span>", \
						 "<span class='danger'>You kick [src].</span>")
	take_damage(rand(4,8), BRUTE)

/obj/structure/rack/attack_alien(mob/living/user)
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src)
	playsound(src.loc, 'sound/weapons/bladeslice.ogg', 50, 1)
	visible_message("<span class='warning'>[user] slices [src] apart.</span>")
	rack_destroy()


/obj/structure/rack/attack_animal(mob/living/simple_animal/user)
	user.changeNext_move(CLICK_CD_MELEE)
	user.do_attack_animation(src)
	if(user.melee_damage_upper)
		if(user.environment_smash)
			playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
			visible_message("<span class='warning'>[user] smashes [src] apart.</span>")
			rack_destroy()
		else
			take_damage(user.melee_damage_upper, user.melee_damage_type)


/obj/structure/rack/attack_tk() // no telehulk sorry
	return

/obj/structure/rack/bullet_act(obj/item/projectile/P)
	. = ..()
	take_damage(P.damage, P.damage_type, 0)

/obj/structure/rack/proc/take_damage(damage, damage_type = BRUTE, sound_effect = 1)
	switch(damage_type)
		if(BRUTE)
			if(sound_effect)
				if(damage)
					playsound(loc, 'sound/items/dodgeball.ogg', 80, 1)
				else
					playsound(loc, 'sound/weapons/tap.ogg', 50, 1)
		if(BURN)
			if(sound_effect)
				playsound(loc, 'sound/items/Welder.ogg', 40, 1)
		else
			return
	health -= damage
	if(health <= 0)
		rack_destroy()


/*
 * Rack destruction
 */

/obj/structure/rack/proc/rack_destroy()
	if(!(flags&NODECONSTRUCT))
		density = 0
		var/obj/item/weapon/rack_parts/newparts = new(loc)
		transfer_fingerprints_to(newparts)
	qdel(src)


/*
 * Rack Parts
 */

/obj/item/weapon/rack_parts
	name = "rack parts"
	desc = "Parts of a rack."
	icon = 'icons/obj/items.dmi'
	icon_state = "rack_parts"
	flags = CONDUCT
	materials = list(MAT_METAL=2000)

/obj/item/weapon/rack_parts/attackby(obj/item/weapon/W, mob/user, params)
	if (istype(W, /obj/item/weapon/wrench))
		new /obj/item/stack/sheet/metal( user.loc )
		qdel(src)
		return
	else
		return ..()

/obj/item/weapon/rack_parts/attack_self(mob/user)
	user << "<span class='notice'>You start constructing rack...</span>"
	if (do_after(user, 50, target = src))
		if(!user.drop_item())
			return
		var/obj/structure/rack/R = new /obj/structure/rack( user.loc )
		R.add_fingerprint(user)
		qdel(src)
		return
