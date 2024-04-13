
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
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	movement_type = FLYING
	generic_canpass = FALSE
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
	var/p_x = 16
	var/p_y = 16			// the pixel location of the tile that the player clicked. Default is the center

	//Fired processing vars
	var/fired = FALSE	//Have we been fired yet
	var/paused = FALSE	//for suspending the projectile midair
	var/time_offset = 0
	var/datum/point/vector/trajectory
	var/trajectory_ignore_forcemove = FALSE	//instructs forceMove to NOT reset our trajectory to the new location!
	/// We already impacted these things, do not impact them again. Used to make sure we can pierce things we want to pierce. Lazylist, typecache style (object = TRUE) for performance.
	var/list/impacted
	/// If TRUE, we can hit our firer.
	var/ignore_source_check = FALSE
	/// We are flagged PHASING temporarily to not stop moving when we Bump something but want to keep going anyways.
	var/temporary_unstoppable_movement = FALSE

	/** PROJECTILE PIERCING
	  * WARNING:
	  * Projectile piercing MUST be done using these variables.
	  * Ordinary passflags will result in can_hit_target being false unless directly clicked on - similar to projectile_phasing but without even going to process_hit.
	  * The two flag variables below both use pass flags.
	  * In the context of LETPASStHROW, it means the projectile will ignore things that are currently "in the air" from a throw.
	  *
	  * Also, projectiles sense hits using Bump(), and then pierce them if necessary.
	  * They simply do not follow conventional movement rules.
	  * NEVER flag a projectile as PHASING movement type.
	  * If you so badly need to make one go through *everything*, override check_pierce() for your projectile to always return PROJECTILE_PIERCE_PHASE/HIT.
	  */
	/// The "usual" flags of pass_flags is used in that can_hit_target ignores these unless they're specifically targeted/clicked on. This behavior entirely bypasses process_hit if triggered, rather than phasing which uses prehit_pierce() to check.
	pass_flags = PASSTABLE
	/// If FALSE, allow us to hit something directly targeted/clicked/whatnot even if we're able to phase through it
	var/phasing_ignore_direct_target = FALSE
	/// Bitflag for things the projectile should just phase through entirely - No hitting unless direct target and [phasing_ignore_direct_target] is FALSE. Uses pass_flags flags.
	var/projectile_phasing = NONE
	/// Bitflag for things the projectile should hit, but pierce through without deleting itself. Defers to projectile_phasing. Uses pass_flags flags.
	var/projectile_piercing = NONE
	/// number of times we've pierced something. Incremented BEFORE bullet_act and on_hit proc!
	var/pierces = 0
	/// If objects are below this layer, we pass through them
	var/hit_threshhold = PROJECTILE_HIT_THRESHHOLD_LAYER
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

	var/damage = 10
	var/damage_type = BRUTE //BRUTE, BURN, TOX, OXY, CLONE are the only things that should be in here
	var/nodamage = 0 //Determines if the projectile will skip any damage inflictions
	var/flag = BULLET //Defines what armor to use when it hits things.  Must be set to bullet, laser, energy,or bomb
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

/obj/item/projectile/Initialize(mapload)
	. = ..()
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

/obj/item/projectile/proc/on_hit(atom/target, blocked = FALSE, pierce_hit)
	if(fired_from)
		SEND_SIGNAL(fired_from, COMSIG_PROJECTILE_ON_HIT, firer, target, Angle)

	// i know that this is probably more with wands and gun mods in mind, but it's a bit silly that the projectile on_hit signal doesn't ping the projectile itself.
	// maybe we care what the projectile thinks! See about combining these via args some time when it's not 5AM
	var/obj/item/bodypart/hit_limb
	if(isliving(target))
		var/mob/living/L = target
		hit_limb = L.check_limb_hit(def_zone)
	SEND_SIGNAL(src, COMSIG_PROJECTILE_SELF_ON_HIT, firer, target, Angle, hit_limb, blocked)
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
		if(isturf(target) && hitsound_wall)
			var/volume = clamp(vol_by_damage() + 20, 0, 100)
			if(suppressed)
				volume = 5
			playsound(loc, hitsound_wall, volume, TRUE, -1)
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
				playsound(src, hitsound, volume, 1, -1)
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
		return clamp((src.damage) * 0.67, 30, 100) // Multiply projectile damage by 0.67, then CLAMP the value between 30 and 100
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
	SEND_SIGNAL(src, COMSIG_MOVABLE_BUMP, A)
	if(!can_hit_target(A, A == original, TRUE, TRUE))
		return
	Impact(A)

/**
 * Called when the projectile hits something
 * This can either be from it bumping something,
 * or it passing over a turf/being crossed and scanning that there is infact
 * a valid target it needs to hit.
 * This target isn't however necessarily WHAT it hits
 * that is determined by process_hit and select_target.
 *
 * Furthermore, this proc shouldn't check can_hit_target - this should only be called if can hit target is already checked.
 * Also, we select_target to find what to process_hit first.
 */
/obj/item/projectile/proc/Impact(atom/A)
	if(!trajectory)
		qdel(src)
		return FALSE
	if(impacted[A]) // NEVER doublehit - Silly-Cons
		return FALSE
	var/datum/point/pcache = trajectory.copy_to()
	var/turf/T = get_turf(A)
	if(check_ricochet_flag(A) && check_ricochet(A)) //if you can ricochet, attempt to ricochet off the object
		ricochets++
		if(A.handle_ricochet(src))
			on_ricochet(A) //if allowed, use autoaim to ricochet into someone, otherwise default to ricocheting off the object from above
			impacted = list() // Shoot a x-ray laser at a pair of mirrors I dare you
			ignore_source_check = TRUE // Firer is no longer immune
			decayedRange = max(0, decayedRange - reflect_range_decrease)
			ricochet_chance *= ricochet_decay_chance
			damage *= ricochet_decay_damage
			range = decayedRange
			if(hitscan)
				store_hitscan_collision(pcache)
			return TRUE

	var/distance = get_dist(T, starting) // Get the distance between the turf shot from and the mob we hit and use that for the calculations.
	if(def_zone && check_zone(def_zone) != BODY_ZONE_CHEST)
		def_zone = ran_zone(def_zone, max(100-(7*distance), 5) * zone_accuracy_factor) //Lower accurancy/longer range tradeoff. 7 is a balanced number to use.

	return process_hit(T, select_target(T, A, A), A)		// SELECT TARGET FIRST!

/**
 * The primary workhorse proc of projectile impacts.
 * This is a RECURSIVE call - process_hit is called on the first selected target, and then repeatedly called if the projectile still hasn't been deleted.
 *
 * Order of operations:
 * 1. Checks if we are deleted, or if we're somehow trying to hit a null, in which case, bail out
 * 2. Adds the thing we're hitting to impacted so we can make sure we don't doublehit
 * 3. Checks piercing - stores this.
 * Afterwards:
 * Hit and delete, hit without deleting and pass through, pass through without hitting, or delete without hitting depending on result
 * If we're going through without hitting, find something else to hit if possible and recurse, set unstoppable movement to true
 * If we're deleting without hitting, delete and return
 * Otherwise, send signal of COMSIG_PROJECTILE_PREHIT to target
 * Then, hit, deleting ourselves if necessary.
 * @params
 * T - Turf we're on/supposedly hitting
 * target - target we're hitting
 * bumped - target we originally bumped. it's here to ensure that if something blocks our projectile by means of Cross() failure, we hit it
 * even if it is not dense.
 * hit_something - only should be set by recursive calling by this proc - tracks if we hit something already
 *
 * Returns if we hit something.
 * - Silly-Cons
 */
/obj/item/projectile/proc/process_hit(turf/T, atom/target, atom/bumped, hit_something = FALSE)
	// 1.
	if(QDELETED(src) || !T || !target)
		return
	// 2.
	impacted[target] = TRUE		//hash lookup > in for performance in hit-checking
	// 3.
	var/mode = prehit_pierce(target)
	if(mode == PROJECTILE_DELETE_WITHOUT_HITTING)
		qdel(src)
		return hit_something
	else if(mode == PROJECTILE_PIERCE_PHASE)
		if(!(movement_type & PHASING))
			temporary_unstoppable_movement = TRUE
			movement_type |= PHASING
		return process_hit(T, select_target(T, target, bumped), bumped, hit_something)	// try to hit something else
	// at this point we are going to hit the thing
	// in which case send signal to it
	SEND_SIGNAL(target, COMSIG_PROJECTILE_PREHIT, args)
	if(mode == PROJECTILE_PIERCE_HIT)
		++pierces
	hit_something = TRUE
	var/result = target.bullet_act(src, def_zone, mode == PROJECTILE_PIERCE_HIT)
	if((result == BULLET_ACT_FORCE_PIERCE) || (mode == PROJECTILE_PIERCE_HIT))
		if(!(movement_type & PHASING))
			temporary_unstoppable_movement = TRUE
			movement_type |= PHASING
		return process_hit(T, select_target(T, target, bumped), bumped, TRUE)
	qdel(src)
	return hit_something

/**
 * Selects a target to hit from a turf
 *
 * @params
 * T - The turf
 * target - The "preferred" atom to hit, usually what we Bumped() first.
 * bumped - used to track if something is the reason we impacted in the first place.
 * If set, this atom is always treated as dense by can_hit_target.

 * Priority:
 * 0. Anything that is already in impacted is ignored no matter what. Furthermore, in any bracket, if the target atom parameter is in it, that's hit first.
 * 	Furthermore, can_hit_target is always checked. This (entire proc) is PERFORMANCE OVERHEAD!! But, it shouldn't be ""too"" bad and I frankly don't have a better *generic non snowflakey* way that I can think of right now at 3 AM.
 *		FURTHERMORE, mobs/objs have a density check from can_hit_target - to hit non dense objects over a turf, you must click on them, same for mobs that usually wouldn't get hit.
 * 1. The thing originally aimed at/clicked on
 * 2. Mobs - picks lowest buckled mob to prevent scarp piggybacking memes
 * 3. Objs
 * 4. Turf
 * 5. Nothing
 */
/obj/item/projectile/proc/select_target(turf/T, atom/target, atom/bumped)
	// 1. original
	if(can_hit_target(original, TRUE, FALSE, original == bumped))
		return original
	var/list/atom/possible = list()		// let's define these ONCE
	var/list/atom/considering = list()
	// 2. mobs
	possible = typecache_filter_list(T, GLOB.typecache_living)	// living only
	for(var/i in possible)
		if(!can_hit_target(i, i == original, TRUE, i == bumped))
			continue
		considering += i
	if(considering.len)
		var/mob/living/M = pick(considering)
		return M.lowest_buckled_mob()
	considering.len = 0
	// 3. objs and other dense things
	for(var/i in T.contents)
		if(!can_hit_target(i, i == original, TRUE, i == bumped))
			continue
		considering += i
	if(considering.len)
		return pick(considering)
	// 4. turf
	if(can_hit_target(T, T == original, TRUE, T == bumped))
		return T
	// 5. nothing
		// (returns null)

//Returns true if the target atom is on our current turf and above the right layer
//If direct target is true it's the originally clicked target.
/obj/item/projectile/proc/can_hit_target(atom/target, direct_target = FALSE, ignore_loc = FALSE,cross_failed = FALSE)
	if(QDELETED(target) || impacted[target])
		return FALSE
	if(!ignore_loc && (loc != target.loc))
		return FALSE
	// if pass_flags match, pass through entirely - unless direct target is set.
	if((target.pass_flags_self & pass_flags) && !direct_target)
		return FALSE
	if(!ignore_source_check && firer)
		var/mob/M = firer
		if((target == firer) || ((target == firer.loc) && ismecha(firer.loc)) || (target in firer.buckled_mobs) || (istype(M) && (M.buckled == target)))
			return FALSE
	if(target.density || cross_failed)		//This thing blocks projectiles, hit it regardless of layer/mob stuns/etc.
		return TRUE
	if(!isliving(target))
		if(isturf(target))		// non dense turfs
			return FALSE
		if(target.layer < hit_threshhold)
			return FALSE
		else if(!direct_target)		// non dense objects do not get hit unless specifically clicked
			return FALSE
	else
		var/mob/living/L = target
		if(direct_target)
			return TRUE
		// If target not able to use items, move and stand - or if they're just dead, pass over.
		if(L.stat == DEAD)
			return FALSE
		if(!L.density)
			return FALSE
		if(L.resting)
			return TRUE
		var/stunned = HAS_TRAIT(L, TRAIT_MOBILITY_NOMOVE) && HAS_TRAIT(L, TRAIT_MOBILITY_NOREST) && HAS_TRAIT(L, TRAIT_MOBILITY_NOPICKUP)
		return !stunned || hit_stunned_targets
	return TRUE

/**
 * Scan if we should hit something and hit it if we need to
 * The difference between this and handling in Impact is
 * In this we strictly check if we need to Impact() something in specific
 * If we do, we do
 * We don't even check if it got hit already - Impact() does that
 * In impact there's more code for selecting WHAT to hit
 * So this proc is more of checking if we should hit something at all BY having an atom cross us.
 */
/obj/item/projectile/proc/scan_crossed_hit(atom/movable/A)
	if(can_hit_target(A, direct_target = (A == original)))
		Impact(A)

/**
 * Scans if we should hit something on the turf we just moved to if we haven't already
 *
 * This proc is a little high in overhead but allows us to not snowflake CanPass in living and other things.
 */
/obj/item/projectile/proc/scan_moved_turf()
	// Optimally, we scan: mobs --> objs --> turf for impact
	// but, overhead is a thing and 2 for loops every time it moves is a no-go.
	// realistically, since we already do select_target in impact, we can not do that
	// and hope projectiles get refactored again in the future to have a less stupid impact detection system
	// that hopefully won't also involve a ton of overhead
	if(can_hit_target(original, TRUE, FALSE))
		Impact(original)		// try to hit thing clicked on
	// else, try to hit mobs
	else		// because if we impacted original and pierced we'll already have select target'd and hit everything else we should be hitting
		for(var/mob/M in loc)		// so I guess we're STILL doing a for loop of mobs because living movement would otherwise have snowflake code for projectile CanPass
			// so the snowflake vs performance is pretty arguable here
			if(can_hit_target(M, M == original, TRUE))
				Impact(M)
				break

/**
 * Projectile crossed: When something enters a projectile's tile, make sure the projectile hits it if it should be hitting it.
 */
/obj/item/projectile/Crossed(atom/movable/AM)
	. = ..()
	scan_crossed_hit(AM)

/**
 * Projectile can pass through
 * Used to not even attempt to Bump() or fail to Cross() anything we already hit.
 */
/obj/item/projectile/CanPassThrough(atom/blocker, turf/target, blocker_opinion)
	return impacted[blocker]? TRUE : ..()

/**
 * Projectile moved:
 *
 * If not fired yet, do not do anything. Else,
 *
 * If temporary unstoppable movement used for piercing through things we already hit (impacted list) is set, unset it.
 * Scan turf we're now in for anything we can/should hit. This is useful for hitting non dense objects the user
 * directly clicks on, as well as for PHASING projectiles to be able to hit things at all as they don't ever Bump().
 */
/obj/item/projectile/Moved(atom/OldLoc, Dir)
	. = ..()
	if(!fired)
		return
	if(temporary_unstoppable_movement)
		temporary_unstoppable_movement = FALSE
		movement_type &= ~PHASING
	scan_moved_turf()		//mostly used for making sure we can hit a non-dense object the user directly clicked on, and for penetrating projectiles that don't bump

/**
 * Checks if we should pierce something.
 *
 * NOT meant to be a pure proc, since this replaces prehit() which was used to do things.
 * Return PROJECTILE_DELETE_WITHOUT_HITTING to delete projectile without hitting at all!
 */

/obj/item/projectile/proc/prehit_pierce(atom/A)
	if((projectile_phasing & A.pass_flags_self) && (phasing_ignore_direct_target || original != A))
		return PROJECTILE_PIERCE_PHASE
	if(projectile_piercing & A.pass_flags_self)
		return PROJECTILE_PIERCE_HIT
	if(ismovable(A))
		var/atom/movable/AM = A
		if(AM.throwing)
			return (projectile_phasing & LETPASSTHROW)? PROJECTILE_PIERCE_PHASE : ((projectile_piercing & LETPASSTHROW)? PROJECTILE_PIERCE_HIT : PROJECTILE_PIERCE_NONE)
	return PROJECTILE_PIERCE_NONE

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
	if((flag in list(ENERGY, LASER)) && (A.flags_ricochet & RICOCHET_SHINY))
		return TRUE
	if((flag in list(BOMB, BULLET)) && (A.flags_ricochet & RICOCHET_HARD))
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
	LAZYINITLIST(impacted)
	if(fired_from)
		SEND_SIGNAL(fired_from, COMSIG_PROJECTILE_BEFORE_FIRE, src, original)	//If no angle needs to resolve it from xo/yo!
	if(shrapnel_type)
		AddElement(/datum/element/embed, projectile_payload = shrapnel_type)
	if(!log_override && firer && original)
		log_combat(firer, original, "fired at", src, "from [get_area_name(src, TRUE)]")
	if(direct_target && (get_dist(direct_target, get_turf(src)) <= 1))		// point blank shots
		process_hit(get_turf(direct_target), direct_target)
		if(QDELETED(src))
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
		INVOKE_ASYNC(src, PROC_REF(process_hitscan))
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
	if(QDELETED(src))		// we coulda bumped something
		return
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
		var/list/screenview = view_to_pixels(user.client.view)

		var/ox = round(screenview[1] / 2) - user.client.pixel_x //"origin" x
		var/oy = round(screenview[2] / 2) - user.client.pixel_y //"origin" y
		angle = arctan(y - oy, x - ox)
	return list(angle, p_x, p_y)

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
