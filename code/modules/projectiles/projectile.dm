
#define MOVES_HITSCAN -1		//Not actually hitscan but close as we get without actual hitscan.
#define MUZZLE_EFFECT_PIXEL_INCREMENT 17	//How many pixels to move the muzzle flash up so your character doesn't look like they're shitting out lasers.
/// Minimum projectile pixels to move before it animate()S, below this it's a direct set.
#define MINIMUM_PIXELS_TO_ANIMATE 4
/// Pixels to instantly travel on firing.
#define PROJECTILE_FIRING_INSTANT_TRAVEL_AMOUNT 16

/obj/item/projectile
	name = "projectile"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bullet"
	density = FALSE
	anchored = TRUE
	item_flags = ABSTRACT
	pass_flags = PASSTABLE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	movement_type = FLYING
	animate_movement = NO_STEPS
	hitsound = 'sound/weapons/pierce.ogg'
	appearance_flags = PIXEL_SCALE
	var/hitsound_wall = ""

	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/def_zone = ""	//Aiming at
	var/atom/movable/firer = null//Who shot it
	var/atom/fired_from = null // the atom that the projectile was fired from (gun, turret)	var/suppressed = FALSE	//Attack message
	var/suppressed = FALSE	//Attack message
	var/candink = FALSE //Can this projectile play the dink sound when hitting the head?
	var/yo = null
	var/xo = null
	var/atom/original = null // the original target clicked
	var/turf/starting = null // the projectile's starting turf
	var/list/permutated = list() // we've passed through these atoms, don't try to hit them again
	var/p_x = 16
	var/p_y = 16			// the pixel location of the tile that the player clicked. Default is the center

	//Fired processing vars
	var/fired = FALSE	//Have we been fired yet
	var/paused = FALSE	//for suspending the projectile midair
	var/time_offset = 0
	var/datum/point/vector/trajectory
	var/trajectory_ignore_forcemove = FALSE	//instructs forceMove to NOT reset our trajectory to the new location!
	/// "leftover" pixels for Range() calculation as pixel_move() was moved to simulated semi-pixel movement and Range() is in tiles.
	var/pixels_range_leftover = 0
	/// "leftover" tick pixels and stuff yeah, so we don't round off things and introducing tracing inaccuracy.
	var/pixels_tick_leftover = 0
	/// Used to detect jumps in the middle of a pixel_move. Yes, this is ugly as sin code-wise but it works.
	var/pixel_move_interrupted = FALSE

	/// Pixels moved per second.
	var/pixels_per_second = TILES_TO_PIXELS(17.5)
	/// The number of pixels we increment by. THIS IS NOT SPEED, DO NOT TOUCH THIS UNLESS YOU KNOW WHAT YOU ARE DOING. In general, lower values means more linetrace accuracy up to a point at cost of performance.
	var/pixel_increment_amount

	var/Angle = 0
	var/original_angle = 0		//Angle at firing
	var/nondirectional_sprite = FALSE //Set TRUE to prevent projectiles from having their sprites rotated based on firing angle
	var/spread = 0			//amount (in degrees) of projectile spread
	animate_movement = 0	//Use SLIDE_STEPS in conjunction with legacy
	/// how many times we've ricochet'd so far (instance variable, not a stat)
	var/ricochets = 0
	/// how many times we can ricochet max
	var/ricochets_max = 0
	/// 0-100, the base chance of ricocheting, before being modified by the atom we shoot and our chance decay
	var/ricochet_chance = 0
	/// 0-1 (or more, I guess) multiplier, the ricochet_chance is modified by multiplying this after each ricochet
	var/ricochet_decay_chance = 0.7
	/// 0-1 (or more, I guess) multiplier, the projectile's damage is modified by multiplying this after each ricochet
	var/ricochet_decay_damage = 0.7
	/// On ricochet, if nonzero, we consider all mobs within this range of our projectile at the time of ricochet to home in on like Revolver Ocelot, as governed by ricochet_auto_aim_angle
	var/ricochet_auto_aim_range = 0
	/// On ricochet, if ricochet_auto_aim_range is nonzero, we'll consider any mobs within this range of the normal angle of incidence to home in on, higher = more auto aim
	var/ricochet_auto_aim_angle = 30
	/// the angle of impact must be within this many degrees of the struck surface, set to 0 to allow any angle
	var/ricochet_incidence_leeway = 40

	///If the object being hit can pass ths damage on to something else, it should not do it for this bullet
	var/force_hit = FALSE

	//Hitscan
	var/hitscan = FALSE		//Whether this is hitscan. If it is, speed is basically ignored.
	var/list/beam_segments	//assoc list of datum/point or datum/point/vector, start = end. Used for hitscan effect generation.
	var/datum/point/beam_index
	/// Used in generate_hitscan_tracers to determine which "cycle" we're on.
	var/hitscan_effect_generation = 0
	var/tracer_type
	var/muzzle_type
	var/impact_type

	var/turf/last_angle_set_hitscan_store		//last turf we stored a hitscan segment while changing angles. without this you'll have potentially hundreds of segments from a homing projectile or something.

	//Fancy hitscan lighting effects!
	var/hitscan_light_intensity = 1.5
	var/hitscan_light_range = 0.75
	var/hitscan_light_color_override
	var/muzzle_flash_intensity = 3
	var/muzzle_flash_range = 1.5
	var/muzzle_flash_color_override
	var/impact_light_intensity = 3
	var/impact_light_range = 2
	var/impact_light_color_override
	// Normal lighting effects
	var/fired_light_intensity = 1
	var/fired_light_range = 0
	var/fired_light_color = rgb(255, 255, 255)

	//Homing
	var/homing = FALSE
	var/atom/homing_target
	/// How fast the projectile turns towards its homing targets, in angle per second.
	var/homing_turn_speed = 100
	var/homing_inaccuracy_min = 0		//in pixels for these. offsets are set once when setting target.
	var/homing_inaccuracy_max = 0
	var/homing_offset_x = 0
	var/homing_offset_y = 0

	/// How many deciseconds are each hitscan movement considered. Used for homing and other things that use seconds for timing rather than ticks.
	var/hitscan_movement_decisecond_equivalency = 0.1

	var/ignore_source_check = FALSE

	var/damage = 10
	var/damage_type = BRUTE //BRUTE, BURN, TOX, OXY, CLONE are the only things that should be in here
	var/nodamage = 0 //Determines if the projectile will skip any damage inflictions
	var/flag = "bullet" //Defines what armor to use when it hits things.  Must be set to bullet, laser, energy,or bomb
	var/projectile_type = /obj/item/projectile
	/// Range of the projectile, de-incrementing every step. The projectile deletes itself at 0. This is in tiles.
	var/range = 50
	var/decayedRange			//stores original range
	var/reflect_range_decrease = 5			//amount of original range that falls off when reflecting, so it doesn't go forever
	var/is_reflectable = FALSE // Can it be reflected or not?

	/// factor to multiply by for zone accuracy percent.
	var/zone_accuracy_factor = 1

		//Effects
	var/stun = 0
	var/knockdown = 0
	var/knockdown_stamoverride
	var/knockdown_stam_max
	var/unconscious = 0
	var/irradiate = 0
	var/stutter = 0
	var/slur = 0
	var/eyeblur = 0
	var/drowsy = 0
	var/stamina = 0
	var/jitter = 0
	var/dismemberment = 0 //The higher the number, the greater the bonus to dismembering. 0 will not dismember at all.
	var/impact_effect_type //what type of impact effect to show when hitting something
	var/log_override = FALSE //is this type spammed enough to not log? (KAs)

	var/temporary_unstoppable_movement = FALSE

	///If defined, on hit we create an item of this type then call hitby() on the hit target with this, mainly used for embedding items (bullets) in targets
	var/shrapnel_type
	///If TRUE, hit mobs even if they're on the floor and not our target
	var/hit_stunned_targets = FALSE

	wound_bonus = CANT_WOUND
	///How much we want to drop both wound_bonus and bare_wound_bonus (to a minimum of 0 for the latter) per tile, for falloff purposes
	var/wound_falloff_tile
	///How much we want to drop the embed_chance value, if we can embed, per tile, for falloff purposes
	var/embed_falloff_tile
	/// For telling whether we want to roll for bone breaking or lacerations if we're bothering with wounds
	sharpness = SHARP_NONE

/obj/item/projectile/Initialize()
	. = ..()
	permutated = list()
	decayedRange = range
	if(embedding)
		updateEmbedding()

/**
  * Artificially modified to be called at around every world.icon_size pixels of movement.
  * WARNING: Range() can only be called once per pixel_increment_amount pixels.
  */
/obj/item/projectile/proc/Range()
	range--
	if(wound_bonus != CANT_WOUND)
		wound_bonus += wound_falloff_tile
		bare_wound_bonus = max(0, bare_wound_bonus + wound_falloff_tile)
	if(embedding)
		embedding["embed_chance"] += embed_falloff_tile
	if(range <= 0 && loc)
		on_range()

/obj/item/projectile/proc/on_range() //if we want there to be effects when they reach the end of their range
	SEND_SIGNAL(src, COMSIG_PROJECTILE_RANGE_OUT)
	qdel(src)

//to get the correct limb (if any) for the projectile hit message
/mob/living/proc/check_limb_hit(hit_zone)
	if(has_limbs)
		return hit_zone

/mob/living/carbon/check_limb_hit(hit_zone)
	if(get_bodypart(hit_zone))
		return hit_zone
	else //when a limb is missing the damage is actually passed to the chest
		return BODY_ZONE_CHEST

/obj/item/projectile/proc/prehit(atom/target)
	return TRUE

/obj/item/projectile/proc/on_hit(atom/target, blocked = FALSE)
	if(fired_from)
		SEND_SIGNAL(fired_from, COMSIG_PROJECTILE_ON_HIT, firer, target, Angle)

	// i know that this is probably more with wands and gun mods in mind, but it's a bit silly that the projectile on_hit signal doesn't ping the projectile itself.
	// maybe we care what the projectile thinks! See about combining these via args some time when it's not 5AM
	var/obj/item/bodypart/hit_limb
	if(isliving(target))
		var/mob/living/L = target
		hit_limb = L.check_limb_hit(def_zone)
	SEND_SIGNAL(src, COMSIG_PROJECTILE_SELF_ON_HIT, firer, target, Angle, hit_limb)
	var/turf/target_loca = get_turf(target)

	var/hitx
	var/hity
	if(target == original)
		hitx = target.pixel_x + p_x - 16
		hity = target.pixel_y + p_y - 16
	else
		hitx = target.pixel_x + rand(-8, 8)
		hity = target.pixel_y + rand(-8, 8)

	if(!nodamage && (damage_type == BRUTE || damage_type == BURN) && iswallturf(target_loca) && prob(75))
		var/turf/closed/wall/W = target_loca
		if(impact_effect_type && !hitscan)
			new impact_effect_type(target_loca, hitx, hity)

		W.add_dent(WALL_DENT_SHOT, hitx, hity)

		return BULLET_ACT_HIT

	if(!isliving(target))
		if(impact_effect_type && !hitscan)
			new impact_effect_type(target_loca, hitx, hity)
		return BULLET_ACT_HIT

	var/mob/living/L = target

	if(blocked != 100) // not completely blocked
		if(damage && L.blood_volume && damage_type == BRUTE)
			var/splatter_dir = dir
			if(starting)
				splatter_dir = get_dir(starting, target_loca)
			var/obj/item/bodypart/B = L.get_bodypart(def_zone)
			if(B && B.is_robotic_limb()) // So if you hit a robotic, it sparks instead of bloodspatters - Hybrid limbs don't bleed from this as of now too, subject to balance.. probably.
				do_sparks(2, FALSE, target.loc)
				if(prob(25))
					new /obj/effect/decal/cleanable/oil(target_loca)
			else if(isalien(L))
				new /obj/effect/temp_visual/dir_setting/bloodsplatter/xenosplatter(target_loca, splatter_dir)
			else
				if(ishuman(target))
					var/mob/living/carbon/human/H = target
					new /obj/effect/temp_visual/dir_setting/bloodsplatter(target_loca, splatter_dir, H.dna.species.exotic_blood_color)
				else
					new /obj/effect/temp_visual/dir_setting/bloodsplatter(target_loca, splatter_dir, bloodtype_to_color())

				L.add_splatter_floor(target_loca)
		else if(impact_effect_type && !hitscan)
			new impact_effect_type(target_loca, hitx, hity)

		var/organ_hit_text = ""
		var/limb_hit = hit_limb
		if(limb_hit)
			organ_hit_text = " in \the [parse_zone(limb_hit)]"

		if(suppressed==SUPPRESSED_VERY)
			playsound(loc, hitsound, 5, TRUE, -1)
		else if(suppressed)
			playsound(loc, hitsound, 5, 1, -1)
			to_chat(L, "<span class='userdanger'>You're shot by \a [src][organ_hit_text]!</span>")
		else
			if(hitsound)
				var/volume = vol_by_damage()
				playsound(loc, hitsound, volume, 1, -1)
			L.visible_message("<span class='danger'>[L] is hit by \a [src][organ_hit_text]!</span>", \
					"<span class='userdanger'>[L] is hit by \a [src][organ_hit_text]!</span>", null, COMBAT_MESSAGE_RANGE)
		if(candink && def_zone == BODY_ZONE_HEAD)
			playsound(src, 'sound/weapons/dink.ogg', 30, 1)
		L.on_hit(src)

	var/reagent_note
	if(reagents)
		reagent_note = reagents.log_list()

	if(ismob(firer))
		log_combat(firer, L, "shot", src, reagent_note)
	else
		L.log_message("has been shot by [firer] with [src]", LOG_ATTACK, color="orange")

	return L.apply_effects(stun, knockdown, unconscious, irradiate, slur, stutter, eyeblur, drowsy, blocked, stamina, jitter, knockdown_stamoverride, knockdown_stam_max)

/obj/item/projectile/proc/vol_by_damage()
	if(src.damage)
		return clamp((src.damage) * 0.67, 30, 100)// Multiply projectile damage by 0.67, then CLAMP the value between 30 and 100
	else
		return 50 //if the projectile doesn't do damage, play its hitsound at 50% volume

/obj/item/projectile/proc/on_ricochet(atom/A)
	if(!ricochet_auto_aim_angle || !ricochet_auto_aim_range)
		return

	var/mob/living/unlucky_sob
	var/best_angle = ricochet_auto_aim_angle
	if(firer && HAS_TRAIT(firer, TRAIT_NICE_SHOT))
		best_angle += NICE_SHOT_RICOCHET_BONUS
	for(var/mob/living/L in range(ricochet_auto_aim_range, src.loc))
		if(L.stat == DEAD || !isInSight(src, L))
			continue
		var/our_angle = abs(closer_angle_difference(Angle, get_projectile_angle(src.loc, L.loc)))
		if(our_angle < best_angle)
			best_angle = our_angle
			unlucky_sob = L

	if(unlucky_sob)
		setAngle(get_projectile_angle(src, unlucky_sob.loc))

/obj/item/projectile/proc/store_hitscan_collision(datum/point/pcache)
	beam_segments[beam_index] = pcache
	beam_index = pcache
	beam_segments[beam_index] = null

/obj/item/projectile/Bump(atom/A)
	if(!trajectory)
		return
	var/turf/T = get_turf(A)
	if(check_ricochet_flag(A) && check_ricochet(A)) //if you can ricochet, attempt to ricochet off the object
		ricochets++
		if(A.handle_ricochet(src))
			on_ricochet(A) //if allowed, use autoaim to ricochet into someone, otherwise default to ricocheting off the object from above
			var/datum/point/pcache = trajectory.copy_to()
			if(hitscan)
				store_hitscan_collision(pcache)
			decayedRange = max(0, decayedRange - reflect_range_decrease)
			ricochet_chance *= ricochet_decay_chance
			damage *= ricochet_decay_damage
			range = decayedRange
			return TRUE

	var/distance = get_dist(T, starting) // Get the distance between the turf shot from and the mob we hit and use that for the calculations.
	if(def_zone && check_zone(def_zone) != BODY_ZONE_CHEST)
		def_zone = ran_zone(def_zone, max(100-(7*distance), 5) * zone_accuracy_factor) //Lower accurancy/longer range tradeoff. 7 is a balanced number to use.

	if(isturf(A) && hitsound_wall)
		var/volume = clamp(vol_by_damage() + 20, 0, 100)
		if(suppressed)
			volume = 5
		playsound(loc, hitsound_wall, volume, 1, -1)

	return process_hit(T, select_target(T, A))

#define QDEL_SELF 1			//Delete if we're not UNSTOPPABLE flagged non-temporarily
#define DO_NOT_QDEL 2		//Pass through.
#define FORCE_QDEL 3		//Force deletion.

/obj/item/projectile/proc/process_hit(turf/T, atom/target, qdel_self, hit_something = FALSE)		//probably needs to be reworked entirely when pixel movement is done.
	if(QDELETED(src) || !T || !target)		//We're done, nothing's left.
		if((qdel_self == FORCE_QDEL) || ((qdel_self == QDEL_SELF) && !temporary_unstoppable_movement && !CHECK_BITFIELD(movement_type, UNSTOPPABLE)))
			qdel(src)
		return hit_something
	permutated |= target		//Make sure we're never hitting it again. If we ever run into weirdness with piercing projectiles needing to hit something multiple times.. well.. that's a to-do.
	if(!prehit(target))
		return process_hit(T, select_target(T), qdel_self, hit_something)		//Hit whatever else we can since that didn't work.
	var/result = target.bullet_act(src, def_zone)
	if(result == BULLET_ACT_FORCE_PIERCE)
		if(!CHECK_BITFIELD(movement_type, UNSTOPPABLE))
			temporary_unstoppable_movement = TRUE
			ENABLE_BITFIELD(movement_type, UNSTOPPABLE)
		return process_hit(T, select_target(T), qdel_self, TRUE)		//Hit whatever else we can since we're piercing through but we're still on the same tile.
	else if(result == BULLET_ACT_TURF)									//We hit the turf but instead we're going to also hit something else on it.
		return process_hit(T, select_target(T), QDEL_SELF, TRUE)
	else		//Whether it hit or blocked, we're done!
		qdel_self = QDEL_SELF
		hit_something = TRUE
	if((qdel_self == FORCE_QDEL) || ((qdel_self == QDEL_SELF) && !temporary_unstoppable_movement && !CHECK_BITFIELD(movement_type, UNSTOPPABLE)))
		qdel(src)
	return hit_something

#undef QDEL_SELF
#undef DO_NOT_QDEL
#undef FORCE_QDEL

/obj/item/projectile/proc/select_target(turf/T, atom/target)			//Select a target from a turf.
	if((original in T) && can_hit_target(original, permutated, TRUE, TRUE))
		return original
	if(target && can_hit_target(target, permutated, target == original, TRUE))
		return target
	var/list/mob/living/possible_mobs = typecache_filter_list(T, GLOB.typecache_mob)
	var/list/mob/mobs = list()
	for(var/mob/living/M in possible_mobs)
		if(!can_hit_target(M, permutated, M == original, TRUE))
			continue
		mobs += M
	var/mob/M = safepick(mobs)
	if(M)
		return M.lowest_buckled_mob()
	var/list/obj/possible_objs = typecache_filter_list(T, GLOB.typecache_machine_or_structure)
	var/list/obj/objs = list()
	for(var/obj/O in possible_objs)
		if(!can_hit_target(O, permutated, O == original, TRUE))
			continue
		objs += O
	var/obj/O = safepick(objs)
	if(O)
		if(length(O.buckled_mobs))
			return pick(O.buckled_mobs)
		return O
	//Nothing else is here that we can hit, hit the turf if we haven't.
	if(!(T in permutated) && can_hit_target(T, permutated, T == original, TRUE))
		return T
	//Returns null if nothing at all was found.

/obj/item/projectile/proc/check_ricochet(atom/A)
	if(ricochets > ricochets_max)		//safety thing, we don't care about what the other thing says about this.
		return FALSE
	var/them = A.check_projectile_ricochet(src)
	switch(them)
		if(PROJECTILE_RICOCHET_PREVENT)
			return FALSE
		if(PROJECTILE_RICOCHET_FORCE)
			return TRUE
		if(PROJECTILE_RICOCHET_NO)
			return FALSE
		if(PROJECTILE_RICOCHET_YES)
			var/chance = ricochet_chance * A.ricochet_chance_mod
			if(firer && HAS_TRAIT(firer, TRAIT_NICE_SHOT))
				chance += NICE_SHOT_RICOCHET_BONUS
			if(prob(chance))
				return TRUE
		else
			CRASH("Invalid return value for projectile ricochet check from [A].")

/obj/item/projectile/proc/check_ricochet_flag(atom/A)
	if((flag in list("energy", "laser")) && (A.flags_ricochet & RICOCHET_SHINY))
		return TRUE
	if((flag in list("bomb", "bullet")) && (A.flags_ricochet & RICOCHET_HARD))
		return TRUE
	return FALSE

/// one move is a tile.
/obj/item/projectile/proc/return_predicted_turf_after_moves(moves, forced_angle)		//I say predicted because there's no telling that the projectile won't change direction/location in flight.
	if(!trajectory && isnull(forced_angle) && isnull(Angle))
		return FALSE
	var/datum/point/vector/current = trajectory
	if(!current)
		var/turf/T = get_turf(src)
		current = new(T.x, T.y, T.z, pixel_x, pixel_y, isnull(forced_angle)? Angle : forced_angle, pixel_increment_amount || SSprojectiles.global_pixel_increment_amount)
	var/datum/point/vector/v = current.return_vector_after_increments(TILES_TO_PIXELS(moves) / (pixel_increment_amount || SSprojectiles.global_pixel_increment_amount))
	return v.return_turf()

/obj/item/projectile/proc/return_pathing_turfs_in_moves(moves, forced_angle)
	var/turf/current = get_turf(src)
	var/turf/ending = return_predicted_turf_after_moves(moves, forced_angle)
	return getline(current, ending)

/obj/item/projectile/Process_Spacemove(movement_dir = 0)
	return TRUE	//Bullets don't drift in space

/obj/item/projectile/process(wait)
	set waitfor = FALSE
	if(!loc || !fired || !trajectory)
		fired = FALSE
		return PROCESS_KILL
	if(paused || !isturf(loc))
		return

	var/required_pixels = (pixels_per_second * wait) + pixels_tick_leftover
	if(required_pixels >= pixel_increment_amount)
		pixels_tick_leftover = MODULUS(required_pixels, pixel_increment_amount)
		pixel_move(FLOOR(required_pixels / pixel_increment_amount, 1), FALSE, wait, SSprojectiles.global_projectile_speed_multiplier)
	else
		pixels_tick_leftover = required_pixels

/obj/item/projectile/proc/fire(angle, atom/direct_target)
	if(fired_from)
		SEND_SIGNAL(fired_from, COMSIG_PROJECTILE_BEFORE_FIRE, src, original)	//If no angle needs to resolve it from xo/yo!
	if(shrapnel_type)
		AddElement(/datum/element/embed, projectile_payload = shrapnel_type)
	if(!log_override && firer && original)
		log_combat(firer, original, "fired at", src, "from [get_area_name(src, TRUE)]")
	if(direct_target)
		if(prehit(direct_target))
			direct_target.bullet_act(src, def_zone)
			qdel(src)
			return
	if(isnum(angle))
		setAngle(angle)
	if(spread)
		setAngle(Angle + ((rand() - 0.5) * spread))
	var/turf/starting = get_turf(src)
	if(isnull(Angle))	//Try to resolve through offsets if there's no angle set.
		if(isnull(xo) || isnull(yo))
			stack_trace("WARNING: Projectile [type] deleted due to being unable to resolve a target after angle was null!")
			qdel(src)
			return
		var/turf/target = locate(clamp(starting + xo, 1, world.maxx), clamp(starting + yo, 1, world.maxy), starting.z)
		setAngle(get_projectile_angle(src, target))
	original_angle = Angle
	if(!nondirectional_sprite)
		var/matrix/M = new
		M.Turn(Angle)
		transform = M
	trajectory_ignore_forcemove = TRUE
	forceMove(starting)
	set_light(fired_light_range, fired_light_intensity, fired_light_color)
	trajectory_ignore_forcemove = FALSE
	if(isnull(pixel_increment_amount))
		pixel_increment_amount = SSprojectiles.global_pixel_increment_amount
	trajectory = new(starting.x, starting.y, starting.z, pixel_x, pixel_y, Angle, pixel_increment_amount)
	fired = TRUE
	if(hitscan)
		INVOKE_ASYNC(src, .proc/process_hitscan)
		return
	if(!(datum_flags & DF_ISPROCESSING))
		START_PROCESSING(SSprojectiles, src)
	pixel_move(round(PROJECTILE_FIRING_INSTANT_TRAVEL_AMOUNT / pixel_increment_amount), FALSE, allow_animation = FALSE)	//move it now!

/obj/item/projectile/proc/setAngle(new_angle, hitscan_store_segment = TRUE)	//wrapper for overrides.
	Angle = new_angle
	pixel_move_interrupted = TRUE
	if(!nondirectional_sprite)
		var/matrix/M = new
		M.Turn(Angle)
		transform = M
	if(fired && hitscan && trajectory && isloc(loc) && (loc != last_angle_set_hitscan_store))
		last_angle_set_hitscan_store = loc
		var/datum/point/pcache = trajectory.copy_to()
		store_hitscan_collision(pcache)
	if(trajectory)
		trajectory.set_angle(new_angle)
	return TRUE

/obj/item/projectile/forceMove(atom/target)
	if(!isloc(target) || !isloc(loc) || !z)
		return ..()
	var/zc = target.z != z
	var/old = loc
	if(zc)
		before_z_change(old, target)
	. = ..()
	if(trajectory && !trajectory_ignore_forcemove && isturf(target))
		if(hitscan)
			finalize_hitscan_and_generate_tracers(FALSE)
		trajectory.initialize_location(target.x, target.y, target.z, 0, 0)
		if(hitscan)
			record_hitscan_start(RETURN_PRECISE_POINT(src))
	pixel_move_interrupted = TRUE
	if(zc)
		after_z_change(old, target)

/obj/item/projectile/proc/after_z_change(atom/olcloc, atom/newloc)

/obj/item/projectile/proc/before_z_change(atom/oldloc, atom/newloc)

/obj/item/projectile/vv_edit_var(var_name, var_value)
	switch(var_name)
		if(NAMEOF(src, Angle))
			setAngle(var_value)
			return TRUE
		else
			return ..()

/obj/item/projectile/proc/set_pixel_increment_amount(new_speed)
	pixel_increment_amount = new_speed
	if(trajectory)
		trajectory.set_speed(new_speed)
		return TRUE
	return FALSE

/obj/item/projectile/proc/record_hitscan_start(datum/point/pcache)
	if(pcache)
		beam_segments = list()
		beam_index = pcache
		beam_segments[beam_index] = null	//record start.

/obj/item/projectile/proc/process_hitscan()
	var/ttm = round(world.icon_size / pixel_increment_amount, 1)
	var/safety = range * 10
	record_hitscan_start(RETURN_POINT_VECTOR_INCREMENT(src, Angle, MUZZLE_EFFECT_PIXEL_INCREMENT, 1))
	while(loc && !QDELETED(src))
		if(paused)
			stoplag(1)
			continue
		if(safety-- <= 0)
			if(loc)
				Bump(loc)
			if(!QDELETED(src))
				qdel(src)
			return	//Kill!
		pixel_move(ttm, TRUE, hitscan_movement_decisecond_equivalency)

/**
  * The proc to make the projectile go, using a simulated pixel movement line trace.
  * Note: deciseconds_equivalent is currently only used for homing, times is the number of times to move pixel_increment_amount.
  * Trajectory multiplier directly modifies the factor of pixel_increment_amount to go per time.
  * It's complicated, so probably just don't mess with this unless you know what you're doing.
  */
/obj/item/projectile/proc/pixel_move(times, hitscanning = FALSE, seconds_equivalent = world.tick_lag * 0.1, trajectory_multiplier = 1, allow_animation = TRUE)
	if(!loc || !trajectory)
		return
	if(!nondirectional_sprite && !hitscanning)
		var/matrix/M = new
		M.Turn(Angle)
		transform = M
	var/forcemoved = FALSE
	pixel_move_interrupted = FALSE		// reset that
	var/turf/oldloc = loc
	var/old_px = pixel_x
	var/old_py = pixel_y
	for(var/i in 1 to times)
		// HOMING START - Too expensive to proccall at this point.
		if(homing_target)
			// No datum/points, too expensive.
			var/angle = closer_angle_difference(Angle, get_projectile_angle(src, homing_target))
			var/max_turn = homing_turn_speed * seconds_equivalent
			setAngle(Angle + clamp(angle, -max_turn, max_turn))
		// HOMING END
		trajectory.increment(trajectory_multiplier)
		var/turf/T = trajectory.return_turf()
		if(!istype(T))
			qdel(src)
			return
		if(T.z != loc.z)
			var/old = loc
			before_z_change(loc, T)
			trajectory_ignore_forcemove = TRUE
			forceMove(T)
			trajectory_ignore_forcemove = FALSE
			after_z_change(old, loc)
			forcemoved = TRUE
			if(QDELETED(src))
				return
			if(!hitscanning)
				pixel_x = trajectory.return_px()
				pixel_y = trajectory.return_py()
		else if(T != loc)
			var/safety = CEILING(pixel_increment_amount / world.icon_size, 1) * 5 + 1
			while(T != loc)
				if(!--safety)
					CRASH("[type] took too long (allowed: [CEILING(pixel_increment_amount/world.icon_size,1)*2] moves) to get to its location.")
				step_towards(src, T)
				if(QDELETED(src) || pixel_move_interrupted)		// this doesn't take into account with pixel_move_interrupted the portion of the move cut off by any forcemoves, but we're opting to ignore that for now
				// the reason is the entire point of moving to pixel speed rather than tile speed is smoothness, which will be crucial when pixel movement is done in the future
				// reverting back to tile is more or less the only way of fixing this issue.
					return
		pixels_range_leftover += pixel_increment_amount
		if(pixels_range_leftover > world.icon_size)
			Range()
			if(QDELETED(src))
				return
			pixels_range_leftover -= world.icon_size
	if(!hitscanning && !forcemoved)
		var/traj_px = round(trajectory.return_px(), 1)
		var/traj_py = round(trajectory.return_py(), 1)
		if(allow_animation && (pixel_increment_amount * times > MINIMUM_PIXELS_TO_ANIMATE))
			pixel_x = ((oldloc.x - x) * world.icon_size) + old_px
			pixel_y = ((oldloc.y - y) * world.icon_size) + old_py
			animate(src, pixel_x = traj_px, pixel_y = traj_py, time = 1, flags = ANIMATION_END_NOW)
		else
			pixel_x = traj_px
			pixel_y = traj_py

/obj/item/projectile/proc/set_homing_target(atom/A)
	if(!A || (!isturf(A) && !isturf(A.loc)))
		return FALSE
	homing = TRUE
	homing_target = A
	homing_offset_x = rand(homing_inaccuracy_min, homing_inaccuracy_max)
	homing_offset_y = rand(homing_inaccuracy_min, homing_inaccuracy_max)
	if(prob(50))
		homing_offset_x = -homing_offset_x
	if(prob(50))
		homing_offset_y = -homing_offset_y

//Returns true if the target atom is on our current turf and above the right layer
//If direct target is true it's the originally clicked target.
/obj/item/projectile/proc/can_hit_target(atom/target, list/passthrough, direct_target = FALSE, ignore_loc = FALSE)
	if(QDELETED(target))
		return FALSE
	if(!ignore_source_check && firer)
		var/mob/M = firer
		if((target == firer) || ((target == firer.loc) && ismecha(firer.loc)) || (target in firer.buckled_mobs) || (istype(M) && (M.buckled == target)))
			if(!ricochets) //if it has ricocheted, it can hit the firer.
				return FALSE
	if(!ignore_loc && (loc != target.loc))
		return FALSE
	if(target in passthrough)
		return FALSE
	if(target.density)		//This thing blocks projectiles, hit it regardless of layer/mob stuns/etc.
		return TRUE
	if(!isliving(target))
		if(target.layer < PROJECTILE_HIT_THRESHHOLD_LAYER)
			return FALSE
	else
		var/mob/living/L = target
		if(!direct_target && !L.density)
			return FALSE
	return TRUE

//Spread is FORCED!
/obj/item/projectile/proc/preparePixelProjectile(atom/target, atom/source, params, spread = 0)
	var/turf/curloc = get_turf(source)
	var/turf/targloc = get_turf(target)
	trajectory_ignore_forcemove = TRUE
	forceMove(get_turf(source))
	trajectory_ignore_forcemove = FALSE
	starting = get_turf(source)
	original = target
	if(targloc || !params)
		yo = targloc.y - curloc.y
		xo = targloc.x - curloc.x
		setAngle(get_projectile_angle(src, targloc) + spread)

	if(isliving(source) && params)
		var/list/calculated = calculate_projectile_angle_and_pixel_offsets(source, params)
		p_x = calculated[2]
		p_y = calculated[3]

		setAngle(calculated[1] + spread)
	else if(targloc)
		yo = targloc.y - curloc.y
		xo = targloc.x - curloc.x
		setAngle(get_projectile_angle(src, targloc) + spread)
	else
		stack_trace("WARNING: Projectile [type] fired without either mouse parameters, or a target atom to aim at!")
		qdel(src)

/proc/calculate_projectile_angle_and_pixel_offsets(mob/user, params)
	var/list/mouse_control = params2list(params)
	var/p_x = 0
	var/p_y = 0
	var/angle = 0
	if(mouse_control["icon-x"])
		p_x = text2num(mouse_control["icon-x"])
	if(mouse_control["icon-y"])
		p_y = text2num(mouse_control["icon-y"])
	if(mouse_control["screen-loc"])
		//Split screen-loc up into X+Pixel_X and Y+Pixel_Y
		var/list/screen_loc_params = splittext(mouse_control["screen-loc"], ",")

		//Split X+Pixel_X up into list(X, Pixel_X)
		var/list/screen_loc_X = splittext(screen_loc_params[1],":")

		//Split Y+Pixel_Y up into list(Y, Pixel_Y)
		var/list/screen_loc_Y = splittext(screen_loc_params[2],":")
		var/x = text2num(screen_loc_X[1]) * 32 + text2num(screen_loc_X[2]) - 32
		var/y = text2num(screen_loc_Y[1]) * 32 + text2num(screen_loc_Y[2]) - 32

		//Calculate the "resolution" of screen based on client's view and world's icon size. This will work if the user can view more tiles than average.
		var/list/screenview = getviewsize(user.client.view)
		var/screenviewX = screenview[1] * world.icon_size
		var/screenviewY = screenview[2] * world.icon_size

		var/ox = round(screenviewX/2) - user.client.pixel_x //"origin" x
		var/oy = round(screenviewY/2) - user.client.pixel_y //"origin" y
		angle = arctan(y - oy, x - ox)
	return list(angle, p_x, p_y)

/obj/item/projectile/Crossed(atom/movable/AM) //A mob moving on a tile with a projectile is hit by it.
	. = ..()
	if(isliving(AM) && !(pass_flags & PASSMOB))
		var/mob/living/L = AM
		if(can_hit_target(L, permutated, (AM == original)))
			Bump(AM)

/obj/item/projectile/Move(atom/newloc, dir = NONE)
	. = ..()
	if(.)
		if(temporary_unstoppable_movement)
			temporary_unstoppable_movement = FALSE
			DISABLE_BITFIELD(movement_type, UNSTOPPABLE)
		if(fired && can_hit_target(original, permutated, TRUE))
			Bump(original)

/obj/item/projectile/Destroy()
	STOP_PROCESSING(SSprojectiles, src)
	if(hitscan)
		finalize_hitscan_and_generate_tracers()
	cleanup_beam_segments()
	QDEL_NULL(trajectory)
	return ..()

/obj/item/projectile/proc/cleanup_beam_segments()
	QDEL_LIST_ASSOC(beam_segments)
	beam_segments = list()
	QDEL_NULL(beam_index)

/obj/item/projectile/proc/finalize_hitscan_and_generate_tracers(impacting = TRUE)
	if(trajectory && beam_index)
		var/datum/point/pcache = trajectory.copy_to()
		beam_segments[beam_index] = pcache
	generate_hitscan_tracers(null, null, impacting, hitscan_effect_generation++)

/obj/item/projectile/proc/generate_hitscan_tracers(cleanup = TRUE, duration = 3, impacting = TRUE, generation)
	if(!length(beam_segments))
		return
	. = list()
	if(tracer_type)
		var/list/turfs = list()
		for(var/datum/point/p in beam_segments)
			. += generate_tracer_between_points(p, beam_segments[p], tracer_type, color, duration, hitscan_light_range, hitscan_light_color_override, hitscan_light_intensity, turfs)
	if(muzzle_type && duration > 0)
		var/datum/point/p = beam_segments[1]
		var/atom/movable/thing = new muzzle_type
		. += thing
		p.move_atom_to_src(thing)
		var/matrix/M = new
		M.Turn(original_angle)
		thing.transform = M
		thing.color = color
		thing.set_light(muzzle_flash_range, muzzle_flash_intensity, muzzle_flash_color_override? muzzle_flash_color_override : color)
		QDEL_IN(thing, duration)
	if(impacting && impact_type && duration > 0)
		var/datum/point/p = beam_segments[beam_segments[beam_segments.len]]
		var/atom/movable/thing = new impact_type
		. += thing
		p.move_atom_to_src(thing)
		var/matrix/M = new
		M.Turn(Angle)
		thing.transform = M
		thing.color = color
		thing.set_light(impact_light_range, impact_light_intensity, impact_light_color_override? impact_light_color_override : color)
		QDEL_IN(thing, duration)
	if(cleanup)
		cleanup_beam_segments()

/obj/item/projectile/experience_pressure_difference()
	return

/////// MISC HELPERS ////////
/// Is this atom reflectable with ""standardized"" reflection methods like you know eshields and deswords and similar
/proc/is_energy_reflectable_projectile(atom/A)
	var/obj/item/projectile/P = A
	return istype(P) && P.is_reflectable

#undef MOVES_HITSCAN
#undef MINIMUM_PIXELS_TO_ANIMATE
#undef MUZZLE_EFFECT_PIXEL_INCREMENT
