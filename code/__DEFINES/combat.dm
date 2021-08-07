/*ALL DEFINES RELATED TO COMBAT GO HERE*/

//Damage and status effect defines

//Damage defines //TODO: merge these down to reduce on defines
#define BRUTE		"brute"
#define BURN		"fire"
#define TOX			"tox"
#define OXY			"oxy"
#define CLONE		"clone"
#define STAMINA 	"stamina"
#define BRAIN		"brain"

//Toxins damage 'typeflag' - is this normal toxins damage or does it have to do with systems corruption (ROBOTIC_ORGANISM species trait)

#define TOX_DEFAULT 1 //For normal toxins damage / healing (toxins, etc), adjustToxLoss() defaults to this
#define TOX_SYSCORRUPT 2 //For toxins damage causing adverse effects to robotic organisms, up to and including fatal corruption, or healing that damage
#define TOX_OMNI 3 //For tox damage / healing that affects both organics and robotic organisms. Used by very few things, e.g. aheals / by default setToxLoss()

//bitflag damage defines used for suicide_act
#define BRUTELOSS 		(1<<0)
#define FIRELOSS 		(1<<1)
#define TOXLOSS 		(1<<2)
#define OXYLOSS 		(1<<3)
#define SHAME 			(1<<4)
#define MANUAL_SUICIDE	(1<<5)	//suicide_act will do the actual killing.

#define EFFECT_STUN		"stun"
#define EFFECT_KNOCKDOWN		"knockdown"
#define EFFECT_UNCONSCIOUS	"unconscious"
#define EFFECT_IRRADIATE	"irradiate"
#define EFFECT_STUTTER		"stutter"
#define EFFECT_SLUR 		"slur"
#define EFFECT_EYE_BLUR	"eye_blur"
#define EFFECT_DROWSY		"drowsy"
#define EFFECT_JITTER		"jitter"

// mob/living/var/combat_flags variable.
/// Default combat flags for those affected by sprinting (combat mode has been made into its own component)
#define COMBAT_FLAGS_DEFAULT				(COMBAT_FLAG_PARRY_CAPABLE | COMBAT_FLAG_BLOCK_CAPABLE)
/// Default combat flags for everyone else (so literally everyone but humans).
#define COMBAT_FLAGS_SPRINT_EXEMPT			(COMBAT_FLAG_SPRINT_ACTIVE | COMBAT_FLAG_SPRINT_TOGGLED | COMBAT_FLAG_SPRINT_FORCED | COMBAT_FLAG_PARRY_CAPABLE | COMBAT_FLAG_BLOCK_CAPABLE)
/// Default combat flags for those in stamina combat system
#define COMBAT_FLAGS_STAMINA_COMBAT			(COMBAT_FLAG_PARRY_CAPABLE | COMBAT_FLAG_BLOCK_CAPABLE | COMBAT_FLAG_STAMINA_BUFFER)

/// The user wants sprint mode on
#define COMBAT_FLAG_SPRINT_TOGGLED			(1<<0)
/// Sprint is currently active
#define COMBAT_FLAG_SPRINT_ACTIVE			(1<<1)
/// Currently attempting to crawl under someone
#define COMBAT_FLAG_ATTEMPTING_CRAWL		(1<<2)
/// Currently stamcritted
#define COMBAT_FLAG_HARD_STAMCRIT			(1<<3)
/// Currently attempting to resist up from the ground
#define COMBAT_FLAG_RESISTING_REST			(1<<4)
/// Intentionally resting
#define COMBAT_FLAG_INTENTIONALLY_RESTING	(1<<5)
/// This mob requires stamina buffer to do things that require stamina buffer. Not having this exempts the mob from stamina combat.
#define COMBAT_FLAG_STAMINA_BUFFER			(1<<6)
/// Force sprint mode on at all times, overrides everything including sprint disable traits.
#define COMBAT_FLAG_SPRINT_FORCED			(1<<7)
/// This mob is capable of using the active parrying system.
#define COMBAT_FLAG_PARRY_CAPABLE			(1<<8)
/// This mob is capable of using the active blocking system.
#define COMBAT_FLAG_BLOCK_CAPABLE			(1<<9)
/// This mob is capable of unarmed parrying
#define COMBAT_FLAG_UNARMED_PARRY			(1<<10)
/// This mob is currently actively blocking
#define COMBAT_FLAG_ACTIVE_BLOCKING			(1<<11)
/// This mob is currently starting an active block
#define COMBAT_FLAG_ACTIVE_BLOCK_STARTING	(1<<12)

// Helpers for getting someone's stamcrit state. Cast to living.
#define NOT_STAMCRIT 0
#define HARD_STAMCRIT 1

// Stamcrit check helpers
#define IS_STAMCRIT(mob)					(CHECK_STAMCRIT(mob) != NOT_STAMCRIT)
#define CHECK_STAMCRIT(mob)					(mob.combat_flags & COMBAT_FLAG_HARD_STAMCRIT)

//stamina stuff
/// crit for stamina damage. forces a rest, and stops movement until stamina goes back to stamina softcrit
#define STAMINA_CRIT						140
/// Threshold for leaving stamina critical
#define STAMINA_CRIT_REMOVAL_THRESHOLD		100
/// Threshold under for which you are unable to draw from stamina health to replace stamina buffer
#define STAMINA_NO_OVERDRAW_THRESHOLD		100

#define CRAWLUNDER_DELAY							30 //Delay for crawling under a standing mob

//Bitflags defining which status effects could be or are inflicted on a mob
// This is a bit out of date/inaccurate in light of all the new status effects and is probably pending rework.
#define CANSTUN			(1<<0)
#define CANKNOCKDOWN	(1<<1)
#define CANUNCONSCIOUS	(1<<2)
#define CANPUSH			(1<<3)
#define GODMODE			(1<<4)
#define CANSTAGGER		(1<<5)

//Health Defines
#define HEALTH_THRESHOLD_CRIT 0
#define HEALTH_THRESHOLD_FULLCRIT -30
#define HEALTH_THRESHOLD_DEAD -100

//Actual combat defines

//click cooldowns, in tenths of a second, used for various combat actions
#define CLICK_CD_MELEE 8
#define CLICK_CD_RANGE 4
#define CLICK_CD_RAPID 2
#define CLICK_CD_CLICK_ABILITY 6
#define CLICK_CD_HANDCUFFED 10
#define CLICK_CD_RESIST 20
#define CLICK_CD_GRABBING 10

//Cuff resist speeds
#define FAST_CUFFBREAK 1
#define INSTANT_CUFFBREAK 2

//Grab levels
#define GRAB_PASSIVE				0
#define GRAB_AGGRESSIVE				1
#define GRAB_NECK					2
#define GRAB_KILL					3

//attack visual effects
#define ATTACK_EFFECT_PUNCH		"punch"
#define ATTACK_EFFECT_KICK		"kick"
#define ATTACK_EFFECT_SMASH		"smash"
#define ATTACK_EFFECT_CLAW		"claw"
#define ATTACK_EFFECT_DISARM	"disarm"
#define ATTACK_EFFECT_ASS_SLAP  "ass_slap"
#define ATTACK_EFFECT_FACE_SLAP "face_slap"
#define ATTACK_EFFECT_BITE		"bite"
#define ATTACK_EFFECT_MECHFIRE	"mech_fire"
#define ATTACK_EFFECT_MECHTOXIN	"mech_toxin"
#define ATTACK_EFFECT_BOOP		"boop" //Honk

//intent defines
#define INTENT_HELP   "help"
#define INTENT_GRAB   "grab"
#define INTENT_DISARM "disarm"
#define INTENT_HARM   "harm"
//NOTE: INTENT_HOTKEY_* defines are not actual intents!
//they are here to support hotkeys
#define INTENT_HOTKEY_LEFT  "left"
#define INTENT_HOTKEY_RIGHT "right"

//the define for visible message range in combat
#define COMBAT_MESSAGE_RANGE 3
#define DEFAULT_MESSAGE_RANGE 7

//Shove knockdown lengths (deciseconds)
#define SHOVE_KNOCKDOWN_SOLID 30
#define SHOVE_KNOCKDOWN_HUMAN 30
#define SHOVE_KNOCKDOWN_TABLE 30
#define SHOVE_KNOCKDOWN_COLLATERAL 10
/// how long they're staggered for
#define SHOVE_STAGGER_DURATION 35
/// how long they're off balance for
#define SHOVE_OFFBALANCE_DURATION 3 SECONDS


//Embedded objects

#define EMBEDDED_PAIN_CHANCE 					15	//Chance for embedded objects to cause pain (damage user)
#define EMBEDDED_ITEM_FALLOUT 					5	//Chance for embedded object to fall out (causing pain but removing the object)
#define EMBED_CHANCE							45	//Chance for an object to embed into somebody when thrown (if it's sharp)
#define EMBEDDED_PAIN_MULTIPLIER				2	//Coefficient of multiplication for the damage the item does while embedded (this*item.w_class)
#define EMBEDDED_FALL_PAIN_MULTIPLIER			5	//Coefficient of multiplication for the damage the item does when it falls out (this*item.w_class)
#define EMBEDDED_IMPACT_PAIN_MULTIPLIER			4	//Coefficient of multiplication for the damage the item does when it first embeds (this*item.w_class)
#define EMBED_THROWSPEED_THRESHOLD				4	//The minimum value of an item's throw_speed for it to embed (Unless it has embedded_ignore_throwspeed_threshold set to 1)
#define EMBEDDED_UNSAFE_REMOVAL_PAIN_MULTIPLIER 8	//Coefficient of multiplication for the damage the item does when removed without a surgery (this*item.w_class)
#define EMBEDDED_UNSAFE_REMOVAL_TIME			30	//A Time in ticks, total removal time = (this*item.w_class)
#define EMBEDDED_JOSTLE_CHANCE					5	//Chance for embedded objects to cause pain every time they move (jostle)
#define EMBEDDED_JOSTLE_PAIN_MULTIPLIER			1	//Coefficient of multiplication for the damage the item does while
#define EMBEDDED_PAIN_STAM_PCT					0.0	//This percentage of all pain will be dealt as stam damage rather than brute (0-1)
#define EMBED_CHANCE_TURF_MOD					-15	//You are this many percentage points less likely to embed into a turf (good for things glass shards and spears vs walls)

#define EMBED_HARMLESS list("pain_mult" = 0, "jostle_pain_mult" = 0, "ignore_throwspeed_threshold" = TRUE)
#define EMBED_HARMLESS_SUPERIOR list("pain_mult" = 0, "jostle_pain_mult" = 0, "ignore_throwspeed_threshold" = TRUE, "embed_chance" = 100, "fall_chance" = 0.1)
#define EMBED_POINTY list("ignore_throwspeed_threshold" = TRUE)
#define EMBED_POINTY_SUPERIOR list("embed_chance" = 100, "ignore_throwspeed_threshold" = TRUE)

//Gun weapon weight
#define WEAPON_LIGHT 1
#define WEAPON_MEDIUM 2
#define WEAPON_HEAVY 3
//Gun trigger guards
#define TRIGGER_GUARD_ALLOW_ALL -1
#define TRIGGER_GUARD_NONE 0
#define TRIGGER_GUARD_NORMAL 1
//E-gun self-recharge values
#define EGUN_NO_SELFCHARGE 0
#define EGUN_SELFCHARGE 1
#define EGUN_SELFCHARGE_BORG 2

//Gun suppression
#define SUPPRESSED_NONE 0
#define SUPPRESSED_QUIET 1 ///standard suppressed
#define SUPPRESSED_VERY 2 /// no message

//Nice shot bonus
#define NICE_SHOT_RICOCHET_BONUS	10	//if the shooter has the NICE_SHOT trait and they fire a ricocheting projectile, add this to the ricochet chance and auto aim angle

///Time to spend without clicking on other things required for your shots to become accurate.
#define GUN_AIMING_TIME (2 SECONDS)

//Object/Item sharpness
#define SHARP_NONE			0
#define SHARP_EDGED			1
#define SHARP_POINTY		2

//His Grace.
#define HIS_GRACE_SATIATED 0 //He hungers not. If bloodthirst is set to this, His Grace is asleep.
#define HIS_GRACE_PECKISH 20 //Slightly hungry.
#define HIS_GRACE_HUNGRY 60 //Getting closer. Increases damage up to a minimum of 20.
#define HIS_GRACE_FAMISHED 100 //Dangerous. Increases damage up to a minimum of 25 and cannot be dropped.
#define HIS_GRACE_STARVING 120 //Incredibly close to breaking loose. Increases damage up to a minimum of 30.
#define HIS_GRACE_CONSUME_OWNER 140 //His Grace consumes His owner at this point and becomes aggressive.
#define HIS_GRACE_FALL_ASLEEP 160 //If it reaches this point, He falls asleep and resets.

#define HIS_GRACE_FORCE_BONUS 4 //How much force is gained per kill.

#define EXPLODE_NONE 0				//Don't even ask me why we need this.
#define EXPLODE_DEVASTATE 1
#define EXPLODE_HEAVY 2
#define EXPLODE_LIGHT 3
#define EXPLODE_GIB_THRESHOLD 50

#define GRENADE_CLUMSY_FUMBLE 1
#define GRENADE_NONCLUMSY_FUMBLE 2
#define GRENADE_NO_FUMBLE 3

#define BODY_ZONE_HEAD		"head"
#define BODY_ZONE_CHEST		"chest"
#define BODY_ZONE_L_ARM		"l_arm"
#define BODY_ZONE_R_ARM		"r_arm"
#define BODY_ZONE_L_LEG		"l_leg"
#define BODY_ZONE_R_LEG		"r_leg"

#define BODY_ZONE_PRECISE_EYES		"eyes"
#define BODY_ZONE_PRECISE_MOUTH		"mouth"
#define BODY_ZONE_PRECISE_GROIN		"groin"
#define BODY_ZONE_PRECISE_L_HAND	"l_hand"
#define BODY_ZONE_PRECISE_R_HAND	"r_hand"
#define BODY_ZONE_PRECISE_L_FOOT	"l_foot"
#define BODY_ZONE_PRECISE_R_FOOT	"r_foot"

//We will round to this value in damage calculations.
#define DAMAGE_PRECISION 0.01

//stamina recovery defines. Blocked if combat mode is on.
#define STAM_RECOVERY_STAM_CRIT		-7.5
#define STAM_RECOVERY_RESTING		-6
#define STAM_RECOVERY_NORMAL		-3
#define STAM_RECOVERY_LIMB			4 //limbs recover stamina separately from handle_status_effects(), and aren't blocked by combat mode.

/**
  * should the current-attack-damage be lower than the item force multiplied by this value,
  * a "inefficiently" prefix will be added to the message.
  */
#define FEEBLE_ATTACK_MSG_THRESHOLD 0.5
