// Overhauled vore system
#define DM_HOLD 		"Hold"
#define DM_DIGEST 		"Digest"
#define DM_HEAL 		"Heal"
#define DM_NOISY 		"Noisy"
#define DM_DRAGON 		"Dragon"
#define DM_ABSORB 		"Absorb"
#define DM_UNABSORB 	"Un-absorb"
#define DM_DRAIN		"Drain"
#define DM_SHRINK		"Shrink"
#define DM_GROW			"Grow"
#define DM_SIZE_STEAL	"Size Steal"
#define DM_EGG 			"Encase In Egg"

//Belly Reagents mode flags
#define DM_FLAG_REAGENTSNUTRI	(1<<0)
#define DM_FLAG_REAGENTSDIGEST	(1<<1)
#define DM_FLAG_REAGENTSABSORB	(1<<2)
#define DM_FLAG_REAGENTSDRAIN	(1<<3)

//Addon mode flags
#define DM_FLAG_NUMBING			(1<<0)
#define DM_FLAG_STRIPPING		(1<<1)
#define DM_FLAG_LEAVEREMAINS	(1<<2)
#define DM_FLAG_THICKBELLY		(1<<3)
#define DM_FLAG_AFFECTWORN		(1<<4)
#define DM_FLAG_JAMSENSORS		(1<<5)

//Item related modes
#define IM_HOLD									"Hold"
#define IM_DIGEST_FOOD							"Digest (Food Only)"
#define IM_DIGEST								"Digest"
#define IM_DIGEST_PARALLEL						"Digest (Dispersed Damage)" //CHOMPedit

/// Can be digested?
#define DIGESTABLE 		(1<<0)
/// Can be devoured?
#define DEVOURABLE		(1<<1)
/// Can be fed to someone / Can have someone fed to?
#define FEEDING			(1<<2)
/// Cannot do vore at all
#define NO_VORE			(1<<3)
/// Was absorbed by someone
#define ABSORBED		(1<<4)
/// Vore initializing
#define VORE_INIT		(1<<5)
/// Initializing vore prefs
#define VOREPREF_INIT	(1<<6)
/// Can be licked?
#define LICKABLE		(1<<7)
/// Can be smelled?
#define SMELLABLE		(1<<8)
/// Can get absorbed?
#define ABSORBABLE		(1<<9)
/// Can get simplemob vored?
#define MOBVORE			(1<<10)
/// Show fullscreen effect
#define SHOW_VORE_FX	(1<<11)
/// Leave remains after death?
#define LEAVE_REMAINS	(1<<12)
/// Am i a valid spot for late-spawning?
#define VORE_SPAWN		(1<<13)

/*
 * # Used for sanitizing saves
 *
 * - Add the new flag to the end of the list when adding a new flag
 */
#define ALL_VORE_FLAGS	DIGESTABLE | DEVOURABLE | FEEDING | NO_VORE | ABSORBED | VORE_INIT | VOREPREF_INIT | LICKABLE | SMELLABLE | ABSORBABLE | MOBVORE | SHOW_VORE_FX | LEAVE_REMAINS | VORE_SPAWN

#define isbelly(A) istype(A, /obj/belly)

#define QDEL_NULL_LIST(x) if(x) { for(var/y in x) { qdel(y) } ; x = null }
#define VORE_STRUGGLE_EMOTE_CHANCE 40

// Stance for hostile mobs to be in while devouring someone.
#define HOSTILE_STANCE_EATING	99

/* // removing sizeplay again
GLOBAL_LIST_INIT(player_sizes_list, list("Macro" = SIZESCALE_HUGE, "Big" = SIZESCALE_BIG, "Normal" = SIZESCALE_NORMAL, "Small" = SIZESCALE_SMALL, "Tiny" = SIZESCALE_TINY))
// Edited to make the new travis check go away
*/

GLOBAL_LIST_INIT(pred_vore_sounds, list(
		"Gulp" = 'sound/vore/pred/swallow_01.ogg',
		"Swallow" = 'sound/vore/pred/swallow_02.ogg',
		"Insertion1" = 'sound/vore/pred/insertion_01.ogg',
		"Insertion2" = 'sound/vore/pred/insertion_02.ogg',
		"Tauric Swallow" = 'sound/vore/pred/taurswallow.ogg',
		"Stomach Move"		= 'sound/vore/pred/stomachmove.ogg',
		"Schlorp" = 'sound/vore/pred/schlorp.ogg',
		"Squish1" = 'sound/vore/pred/squish_01.ogg',
		"Squish2" = 'sound/vore/pred/squish_02.ogg',
		"Squish3" = 'sound/vore/pred/squish_03.ogg',
		"Squish4" = 'sound/vore/pred/squish_04.ogg',
		"Rustle (cloth)" = 'sound/effects/rustle5.ogg',
		"Rustle 2 (cloth)"	= 'sound/effects/rustle2.ogg',
		"Rustle 3 (cloth)"	= 'sound/effects/rustle3.ogg',
		"Rustle 4 (cloth)"	= 'sound/effects/rustle4.ogg',
		"Rustle 5 (cloth)"	= 'sound/effects/rustle5.ogg',
		"None" = null
		))

GLOBAL_LIST_INIT(prey_vore_sounds, list(
		"Gulp" = 'sound/vore/prey/swallow_01.ogg',
		"Swallow" = 'sound/vore/prey/swallow_02.ogg',
		"Insertion1" = 'sound/vore/prey/insertion_01.ogg',
		"Insertion2" = 'sound/vore/prey/insertion_02.ogg',
		"Tauric Swallow" = 'sound/vore/prey/taurswallow.ogg',
		"Stomach Move"		= 'sound/vore/prey/stomachmove.ogg',
		"Schlorp" = 'sound/vore/prey/schlorp.ogg',
		"Squish1" = 'sound/vore/prey/squish_01.ogg',
		"Squish2" = 'sound/vore/prey/squish_02.ogg',
		"Squish3" = 'sound/vore/prey/squish_03.ogg',
		"Squish4" = 'sound/vore/prey/squish_04.ogg',
		"Rustle (cloth)" = 'sound/effects/rustle5.ogg',
		"Rustle 2 (cloth)"	= 'sound/effects/rustle2.ogg',
		"Rustle 3 (cloth)"	= 'sound/effects/rustle3.ogg',
		"Rustle 4 (cloth)"	= 'sound/effects/rustle4.ogg',
		"Rustle 5 (cloth)"	= 'sound/effects/rustle5.ogg',
		"None" = null
		))

GLOBAL_LIST_INIT(pred_release_sounds, list(
		"Rustle (cloth)" = 'sound/effects/rustle1.ogg',
		"Rustle 2 (cloth)" = 'sound/effects/rustle2.ogg',
		"Rustle 3 (cloth)" = 'sound/effects/rustle3.ogg',
		"Rustle 4 (cloth)" = 'sound/effects/rustle4.ogg',
		"Rustle 5 (cloth)" = 'sound/effects/rustle5.ogg',
		"Stomach Move" = 'sound/vore/pred/stomachmove.ogg',
		"Pred Escape" = 'sound/vore/pred/escape.ogg',
		"Splatter" = 'sound/effects/splat.ogg',
		"None" = null
		))

GLOBAL_LIST_INIT(prey_release_sounds, list(
		"Rustle (cloth)" = 'sound/effects/rustle1.ogg',
		"Rustle 2 (cloth)" = 'sound/effects/rustle2.ogg',
		"Rustle 3 (cloth)" = 'sound/effects/rustle3.ogg',
		"Rustle 4 (cloth)" = 'sound/effects/rustle4.ogg',
		"Rustle 5 (cloth)" = 'sound/effects/rustle5.ogg',
		"Stomach Move" = 'sound/vore/prey/stomachmove.ogg',
		"Pred Escape" = 'sound/vore/prey/escape.ogg',
		"Splatter" = 'sound/effects/splat.ogg',
		"None" = null
		))

/proc/init_digest_modes()
	for(var/datum/digest_mode/iteration as anything in typesof(/datum/digest_mode))
		var/datum/digest_mode/DM = new iteration()
		GLOB.digest_modes[DM.id] = DM

/proc/init_skull_types()
	for(var/obj/item/digestion_remains/skull/skull as anything in typesof(/obj/item/digestion_remains/skull))
		GLOB.skull_types[initial(skull.name)] = skull
