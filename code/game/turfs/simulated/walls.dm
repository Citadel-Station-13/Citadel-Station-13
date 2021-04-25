#define MAX_DENT_DECALS 15

/turf/closed/wall
	name = "wall"
	desc = "A huge chunk of metal used to separate rooms."
	icon = 'icons/turf/walls/wall.dmi'
	icon_state = "wall"
	explosion_block = 1
	wave_explosion_block = EXPLOSION_BLOCK_WALL
	wave_explosion_multiply = EXPLOSION_DAMPEN_WALL
	flags_1 = DEFAULT_RICOCHET_1
	flags_ricochet = RICOCHET_HARD
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall
	attack_hand_speed = 8
	attack_hand_is_action = TRUE

	baseturfs = /turf/open/floor/plating

	explosion_flags = EXPLOSION_FLAG_HARD_OBSTACLE
	/// Explosion power to disintegrate the wall
	var/explosion_power_to_scrape = EXPLOSION_POWER_WALL_SCRAPE
	/// Explosion power to dismantle the wall
	var/explosion_power_to_dismantle = EXPLOSION_POWER_WALL_DISMANTLE
	/// Explosion power to potentially dismantle the wall
	var/explosion_power_minimum_chance_dismantle = EXPLOSION_POWER_WALL_MINIMUM_DISMANTLE

	var/hardness = 40 //lower numbers are harder. Used to determine the probability of a hulk smashing through.
	var/slicing_duration = 100  //default time taken to slice the wall
	var/sheet_type = /obj/item/stack/sheet/metal
	var/sheet_amount = 2
	var/girder_type = /obj/structure/girder

	canSmoothWith = list(
	/turf/closed/wall,
	/turf/closed/wall/r_wall,
	/obj/structure/falsewall,
	/obj/structure/falsewall/brass,
	/obj/structure/falsewall/reinforced,
	/turf/closed/wall/rust,
	/turf/closed/wall/r_wall/rust,
	/turf/closed/wall/clockwork)
	smooth = SMOOTH_TRUE

	var/list/dent_decals

/turf/closed/wall/examine(mob/user)
	. = ..()
	deconstruction_hints(user)

/turf/closed/wall/proc/deconstruction_hints(mob/user)
	return "<span class='notice'>The outer plating is <b>welded</b> firmly in place.</span>"

/turf/closed/wall/attack_tk()
	return

/turf/closed/wall/proc/dismantle_wall(devastated=0, explode=0)
	if(devastated)
		devastate_wall()
	else
		playsound(src, 'sound/items/welder.ogg', 100, 1)
		var/newgirder = break_wall()
		if(newgirder) //maybe we don't /want/ a girder!
			transfer_fingerprints_to(newgirder)

	for(var/obj/O in src.contents) //Eject contents!
		if(istype(O, /obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.roll_and_drop(src)

	ScrapeAway()

/turf/closed/wall/proc/break_wall()
	new sheet_type(src, sheet_amount)
	if(girder_type)
		return new girder_type(src)

/turf/closed/wall/proc/devastate_wall()
	new sheet_type(src, sheet_amount)
	if(girder_type)
		new /obj/item/stack/sheet/metal(src)

/turf/closed/wall/ex_act(severity, target)
	if(target == src)
		dismantle_wall(1,1)
		return
	switch(severity)
		if(1)
			//SN src = null
			var/turf/NT = ScrapeAway()
			NT.contents_explosion(severity, target)
			return
		if(2)
			if (prob(50))
				dismantle_wall(0,1)
			else
				dismantle_wall(1,1)
		if(3)
			if (prob(hardness))
				dismantle_wall(0,1)
	if(!density)
		..()

/turf/closed/wall/wave_ex_act(power, datum/wave_explosion/explosion, dir)
	. = ..()
	var/resultant_power = power * explosion.wall_destroy_mod
	if(resultant_power >= explosion_power_to_scrape)
		ScrapeAway()
	else if((resultant_power >= explosion_power_to_dismantle) || ((resultant_power >= explosion_power_minimum_chance_dismantle) && prob(((resultant_power - explosion_power_minimum_chance_dismantle) / (explosion_power_to_dismantle - explosion_power_minimum_chance_dismantle)) * 100)))
		dismantle_wall(prob((resultant_power - explosion_power_to_dismantle)/(explosion_power_to_scrape - explosion_power_to_dismantle)), TRUE)

/turf/closed/wall/blob_act(obj/structure/blob/B)
	if(prob(50))
		dismantle_wall()
	else
		add_dent(WALL_DENT_HIT)

/turf/closed/wall/mech_melee_attack(obj/mecha/M)
	M.do_attack_animation(src)
	switch(M.damtype)
		if(BRUTE)
			playsound(src, 'sound/weapons/punch4.ogg', 50, 1)
			visible_message("<span class='danger'>[M.name] has hit [src]!</span>", null, null, COMBAT_MESSAGE_RANGE)
			if(prob(hardness + M.force) && M.force > 20)
				dismantle_wall(1)
				playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
			else
				add_dent(WALL_DENT_HIT)
		if(BURN)
			playsound(src, 'sound/items/welder.ogg', 100, 1)
		if(TOX)
			playsound(src, 'sound/effects/spray2.ogg', 100, 1)
			return FALSE

/turf/closed/wall/attack_paw(mob/living/user)
	return attack_hand(user)

/turf/closed/wall/attack_animal(mob/living/simple_animal/M)
	if(!M.CheckActionCooldown(CLICK_CD_MELEE))
		return
	M.DelayNextAction()
	M.do_attack_animation(src)
	if((M.environment_smash & ENVIRONMENT_SMASH_WALLS) || (M.environment_smash & ENVIRONMENT_SMASH_RWALLS))
		playsound(src, 'sound/effects/meteorimpact.ogg', 100, 1)
		dismantle_wall(1)
		return

/turf/closed/wall/attack_hulk(mob/living/carbon/user)
	..()
	var/obj/item/bodypart/arm = user.hand_bodyparts[user.active_hand_index]
	if(!arm)
		return
	if(arm.disabled)
		return
	if(prob(hardness))
		playsound(src, 'sound/effects/meteorimpact.ogg', 100, TRUE)
		user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ), forced = "hulk")
		//hulk_recoil(arm, user)		// citadel edit - no, hulks are already subject to stamina combat
		dismantle_wall(1)

	else
		playsound(src, 'sound/effects/bang.ogg', 50, TRUE)
		add_dent(WALL_DENT_HIT)
		user.visible_message("<span class='danger'>[user] smashes \the [src]!</span>", \
					"<span class='danger'>You smash \the [src]!</span>", \
					"<span class='hear'>You hear a booming smash!</span>")
	return TRUE

/**
  *Deals damage back to the hulk's arm.
  *
  *When a hulk manages to break a wall using their hulk smash, this deals back damage to the arm used.
  *This is in its own proc just to be easily overridden by other wall types. Default allows for three
  *smashed walls per arm. Also, we use CANT_WOUND here because wounds are random. Wounds are applied
  *by hulk code based on arm damage and checked when we call break_an_arm().
  *Arguments:
  **arg1 is the arm to deal damage to.
  **arg2 is the hulk
 */
/turf/closed/wall/proc/hulk_recoil(obj/item/bodypart/arm, mob/living/carbon/human/hulkman, var/damage = 20)
	arm.receive_damage(brute = damage, blocked = 0, wound_bonus = CANT_WOUND)
	var/datum/mutation/human/hulk/smasher = locate(/datum/mutation/human/hulk) in hulkman.dna.mutations
	if(!smasher || !damage) //sanity check but also snow and wood walls deal no recoil damage, so no arm breaky
		return
	smasher.break_an_arm(arm)

/turf/closed/wall/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	to_chat(user, "<span class='notice'>You push the wall but nothing happens!</span>")
	playsound(src, 'sound/weapons/genhit.ogg', 25, 1)
	add_fingerprint(user)

/turf/closed/wall/attackby(obj/item/W, mob/user, params)
	if(!user.CheckActionCooldown(CLICK_CD_MELEE))
		return
	if (!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return

	//get the user's location
	if(!isturf(user.loc))
		return	//can't do this stuff whilst inside objects and such

	user.DelayNextAction()
	add_fingerprint(user)

	var/turf/T = user.loc	//get user's location for delay checks

	//the istype cascade has been spread among various procs for easy overriding
	var/srctype = type
	if(try_clean(W, user, T) || try_wallmount(W, user, T) || try_decon(W, user, T) || (type == srctype && try_destroy(W, user, T)))
		return

	return ..()

/turf/closed/wall/proc/try_clean(obj/item/W, mob/user, turf/T)
	if((user.a_intent != INTENT_HELP) || !LAZYLEN(dent_decals))
		return FALSE

	if(W.tool_behaviour == TOOL_WELDER)
		if(!W.tool_start_check(user, amount=0))
			return FALSE

		to_chat(user, "<span class='notice'>You begin fixing dents on the wall...</span>")
		if(W.use_tool(src, user, 0, volume=100))
			if(iswallturf(src) && LAZYLEN(dent_decals))
				to_chat(user, "<span class='notice'>You fix some dents on the wall.</span>")
				cut_overlay(dent_decals)
				dent_decals.Cut()
			return TRUE

	return FALSE

/turf/closed/wall/proc/try_wallmount(obj/item/W, mob/user, turf/T)
	//check for wall mounted frames
	if(istype(W, /obj/item/wallframe))
		var/obj/item/wallframe/F = W
		if(F.try_build(src, user))
			F.attach(src, user)
		return TRUE
	//Poster stuff
	else if(istype(W, /obj/item/poster))
		place_poster(W,user)
		return TRUE
	//wall mounted IC assembly stuff
	else if(istype(W, /obj/item/electronic_assembly/wallmount))
		var/obj/item/electronic_assembly/wallmount/A = W
		A.mount_assembly(src, user)
		return TRUE

	return FALSE

/turf/closed/wall/proc/try_decon(obj/item/I, mob/user, turf/T)
	if(I.tool_behaviour == TOOL_WELDER || istype(I, /obj/item/gun/energy/plasmacutter))
		if(!I.tool_start_check(user, amount=0))
			return FALSE

		to_chat(user, "<span class='notice'>You begin slicing through the outer plating...</span>")
		if(I.use_tool(src, user, slicing_duration, volume=100))
			if(iswallturf(src))
				to_chat(user, "<span class='notice'>You remove the outer plating.</span>")
				dismantle_wall()
			return TRUE

	return FALSE


/turf/closed/wall/proc/try_destroy(obj/item/I, mob/user, turf/T)
	if(istype(I, /obj/item/pickaxe/drill/jackhammer))
		if(!iswallturf(src))
			return TRUE
		if(user.loc == T)
			I.play_tool_sound(src)
			dismantle_wall()
			visible_message("<span class='warning'>[user] smashes through [src] with [I]!</span>", "<span class='italics'>You hear the grinding of metal.</span>")
			return TRUE
	return FALSE

/turf/closed/wall/singularity_pull(S, current_size)
	..()
	if(current_size >= STAGE_FIVE)
		if(prob(50))
			dismantle_wall()
		return
	if(current_size == STAGE_FOUR)
		if(prob(30))
			dismantle_wall()

/turf/closed/wall/narsie_act(force, ignore_mobs, probability = 20)
	. = ..()
	if(.)
		ChangeTurf(/turf/closed/wall/mineral/cult)

/turf/closed/wall/ratvar_act(force, ignore_mobs)
	. = ..()
	if(.)
		ChangeTurf(/turf/closed/wall/clockwork)

/turf/closed/wall/get_dumping_location(obj/item/storage/source, mob/user)
	return null

/turf/closed/wall/acid_act(acidpwr, acid_volume)
	if(explosion_block >= 2)
		acidpwr = min(acidpwr, 50) //we reduce the power so strong walls never get melted.
	. = ..()

/turf/closed/wall/acid_melt()
	dismantle_wall(1)

/turf/closed/wall/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	switch(the_rcd.mode)
		if(RCD_DECONSTRUCT)
			return list("mode" = RCD_DECONSTRUCT, "delay" = 40, "cost" = 26)
	return FALSE

/turf/closed/wall/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, "<span class='notice'>You deconstruct the wall.</span>")
			ScrapeAway()
			return TRUE
	return FALSE

/turf/closed/wall/proc/add_dent(denttype, x=rand(-8, 8), y=rand(-8, 8))
	if(LAZYLEN(dent_decals) >= MAX_DENT_DECALS)
		return

	var/mutable_appearance/decal = mutable_appearance('icons/effects/effects.dmi', "", BULLET_HOLE_LAYER, ABOVE_WALL_PLANE)
	switch(denttype)
		if(WALL_DENT_SHOT)
			decal.icon_state = "bullet_hole"
		if(WALL_DENT_HIT)
			decal.icon_state = "impact[rand(1, 3)]"

	decal.pixel_x = x
	decal.pixel_y = y

	if(LAZYLEN(dent_decals))
		cut_overlay(dent_decals)
		dent_decals += decal
	else
		dent_decals = list(decal)

	add_overlay(dent_decals)

/turf/closed/wall/rust_heretic_act()
	if(prob(70))
		new /obj/effect/temp_visual/glowing_rune(src)
	ChangeTurf(/turf/closed/wall/rust)

#undef MAX_DENT_DECALS
