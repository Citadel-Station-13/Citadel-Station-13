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

// /mob/living/combat_flags
#define CAN_TOGGLE_COMBAT_MODE(mob)			FORCE_BOOLEAN((mob.stat == CONSCIOUS) && !(mob.combat_flags & COMBAT_FLAG_HARD_STAMCRIT))

/// Default combat flags for those affected by ((stamina combat))
#define COMBAT_FLAGS_DEFAULT					NONE
/// Default combat flags for everyone else (so literally everyone but humans)
#define COMBAT_FLAGS_STAMSYSTEM_EXEMPT			(COMBAT_FLAG_SPRINT_ACTIVE | COMBAT_FLAG_COMBAT_ACTIVE | COMBAT_FLAG_SPRINT_TOGGLED | COMBAT_FLAG_COMBAT_TOGGLED)
/// Default combat flags for those only affected by sprint (so just silicons)
#define COMBAT_FLAGS_STAMEXEMPT_YESSPRINT		(COMBAT_FLAG_COMBAT_ACTIVE | COMBAT_FLAG_COMBAT_TOGGLED)

/// The user wants combat mode on
#define COMBAT_FLAG_COMBAT_TOGGLED			(1<<0)
/// The user wants sprint mode on
#define COMBAT_FLAG_SPRINT_TOGGLED			(1<<1)
/// Combat mode is currently active
#define COMBAT_FLAG_COMBAT_ACTIVE			(1<<2)
/// Sprint is currently active
#define COMBAT_FLAG_SPRINT_ACTIVE			(1<<3)
/// Currently attempting to crawl under someone
#define COMBAT_FLAG_ATTEMPTING_CRAWL		(1<<4)
/// Currently stamcritted
#define COMBAT_FLAG_HARD_STAMCRIT			(1<<5)
/// Currently attempting to resist up from the ground
#define COMBAT_FLAG_RESISTING_REST			(1<<6)
/// Intentionally resting
#define COMBAT_FLAG_INTENTIONALLY_RESTING	(1<<7)
/// Currently stamcritted but not as violently
#define COMBAT_FLAG_SOFT_STAMCRIT			(1<<8)

// Helpers for getting someone's stamcrit state. Cast to living.
#define NOT_STAMCRIT 0
#define SOFT_STAMCRIT 1
#define HARD_STAMCRIT 2

// Stamcrit check helpers
#define IS_STAMCRIT(mob)					(CHECK_STAMCRIT(mob) != NOT_STAMCRIT)
#define CHECK_STAMCRIT(mob)					((mob.combat_flags & COMBAT_FLAG_HARD_STAMCRIT)? HARD_STAMCRIT : ((mob.combat_flags & COMBAT_FLAG_SOFT_STAMCRIT)? SOFT_STAMCRIT : NOT_STAMCRIT))

//stamina stuff
#define STAMINA_SOFTCRIT					100 //softcrit for stamina damage. prevents standing up, prevents performing actions that cost stamina, etc, but doesn't force a rest or stop movement
#define STAMINA_CRIT						140 //crit for stamina damage. forces a rest, and stops movement until stamina goes back to stamina softcrit
#define STAMINA_SOFTCRIT_TRADITIONAL		0	//same as STAMINA_SOFTCRIT except for the more traditional health calculations
#define STAMINA_CRIT_TRADITIONAL			-40 //ditto, but for STAMINA_CRIT

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
#define CLICK_CD_BREAKOUT 100
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

//slowdown when in softcrit
#define SOFTCRIT_ADD_SLOWDOWN 6

//Attack types for checking shields/hit reactions
#define MELEE_ATTACK 1
#define UNARMED_ATTACK 2
#define PROJECTILE_ATTACK 3
#define THROWN_PROJECTILE_ATTACK 4
#define LEAP_ATTACK 5

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
//for the shove slowdown, see __DEFINES/movespeed_modification.dm
#define SHOVE_SLOWDOWN_LENGTH 30
#define SHOVE_SLOWDOWN_STRENGTH 0.85 //multiplier
//Shove disarming item list
GLOBAL_LIST_INIT(shove_disarming_types, typecacheof(list(
	/obj/item/gun)))


//Combat object defines

//Embedded objects
#define EMBEDDED_PAIN_CHANCE 					15	//Chance for embedded objects to cause pain (damage user)
#define EMBEDDED_ITEM_FALLOUT 					5	//Chance for embedded object to fall out (causing pain but removing the object)
#define EMBED_CHANCE							45	//Chance for an object to embed into somebody when thrown (if it's sharp)
#define EMBEDDED_PAIN_MULTIPLIER				2	//Coefficient of multiplication for the damage the item does while embedded (this*item.w_class)
#define EMBEDDED_FALL_PAIN_MULTIPLIER			5	//Coefficient of multiplication for the damage the item does when it falls out (this*item.w_class)
#define EMBEDDED_IMPACT_PAIN_MULTIPLIER			4	//Coefficient of multiplication for the damage the item does when it first embeds (this*item.w_class)
#define EMBED_THROWSPEED_THRESHOLD				4	//The minimum value of an item's throw_speed for it to embed (Unless it has embedded_ignore_throwspeed_threshold set to 1)
#define EMBEDDED_UNSAFE_REMOVAL_PAIN_MULTIPLIER 8	//Coefficient of multiplication for the damage the item does when removed without a surgery (this*item.w_class)
#define EMBEDDED_UNSAFE_REMOVAL_TIME			150	//A Time in ticks, total removal time = (this/item.w_class)

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

//Object/Item sharpness
#define IS_BLUNT			0
#define IS_SHARP			1
#define IS_SHARP_ACCURATE	2

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

#define EMP_HEAVY 1
#define EMP_LIGHT 2

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

//items total mass, used to calculate their attacks' stamina costs. If not defined, the cost will be (w_class * 1.25)
#define TOTAL_MASS_TINY_ITEM		1.25
#define TOTAL_MASS_SMALL_ITEM		2.5
#define TOTAL_MASS_NORMAL_ITEM		3.75
#define TOTAL_MASS_BULKY_ITEM		5
#define TOTAL_MASS_HUGE_ITEM		6.25
#define TOTAL_MASS_GIGANTIC_ITEM	7.5

#define TOTAL_MASS_HAND_REPLACEMENT	5 //standard punching stamina cost. most hand replacements are huge items anyway.
#define TOTAL_MASS_MEDIEVAL_WEAPON	3.6 //very, very generic average sword/warpick/etc. weight in pounds.
#define TOTAL_MASS_TOY_SWORD 1.5

//bullet_act() return values
#define BULLET_ACT_HIT				"HIT"		//It's a successful hit, whatever that means in the context of the thing it's hitting.
#define BULLET_ACT_BLOCK			"BLOCK"		//It's a blocked hit, whatever that means in the context of the thing it's hitting.
#define BULLET_ACT_FORCE_PIERCE		"PIERCE"	//It pierces through the object regardless of the bullet being piercing by default.
#define BULLET_ACT_TURF				"TURF"		//It hit us but it should hit something on the same turf too. Usually used for turfs.


