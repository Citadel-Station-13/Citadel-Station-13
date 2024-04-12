
//These are all the different status effects. Use the paths for each effect in the defines.

#define STATUS_EFFECT_MULTIPLE 0 //if it allows multiple instances of the effect

#define STATUS_EFFECT_UNIQUE 1 //if it allows only one, preventing new instances

#define STATUS_EFFECT_REPLACE 2 //if it allows only one, but new instances replace

#define STATUS_EFFECT_REFRESH 3 // if it only allows one, and new instances just instead refresh the timer

///////////
// BUFFS //
///////////

#define STATUS_EFFECT_SHADOW_MEND /datum/status_effect/shadow_mend //Quick, powerful heal that deals damage afterwards. Heals 15 brute/burn every second for 3 seconds.
#define STATUS_EFFECT_VOID_PRICE /datum/status_effect/void_price //The price of healing yourself with void energy. Deals 3 brute damage every 3 seconds for 30 seconds.

#define STATUS_EFFECT_VANGUARD /datum/status_effect/vanguard_shield //Grants temporary stun absorption, but will stun the user based on how many stuns they absorbed.
#define STATUS_EFFECT_INATHNEQS_ENDOWMENT /datum/status_effect/inathneqs_endowment //A 15-second invulnerability and stun absorption, granted by Inath-neq.
#define STATUS_EFFECT_WRAITHSPECS /datum/status_effect/wraith_spectacles

#define STATUS_EFFECT_POWERREGEN /datum/status_effect/cyborg_power_regen //Regenerates power on a given cyborg over time

#define STATUS_EFFECT_HISGRACE /datum/status_effect/his_grace //His Grace.

#define STATUS_EFFECT_WISH_GRANTERS_GIFT /datum/status_effect/wish_granters_gift //If you're currently resurrecting with the Wish Granter

#define STATUS_EFFECT_BLOODDRUNK /datum/status_effect/blooddrunk //Stun immunity and greatly reduced damage taken

#define STATUS_EFFECT_FLESHMEND /datum/status_effect/fleshmend //Very fast healing; suppressed by fire, and heals less fire damage

#define STATUS_EFFECT_PANACEA /datum/status_effect/panacea //Anatomic panacea that directly heals, rather than injecting a small chemical cocktail

#define STATUS_EFFECT_EXERCISED /datum/status_effect/exercised //Prevents heart disease

#define STATUS_EFFECT_HIPPOCRATIC_OATH /datum/status_effect/hippocraticOath //Gives you an aura of healing as well as regrowing the Rod of Asclepius if lost

#define STATUS_EFFECT_REGENERATIVE_CORE /datum/status_effect/regenerative_core	//removes damage slowdown while giving a slow regenerating effect

#define STATUS_EFFECT_DETERMINED /datum/status_effect/determined //currently in a combat high from being seriously wounded

#define STATUS_EFFECT_MANTRA /datum/status_effect/mantra // a toggled self buff that makes you stronger and more resilient, but drains stamina over time
#define STATUS_EFFECT_ASURA /datum/status_effect/asura // like a weaker version of mantra, drains HP instead of stamina and has no armor

/////////////
// DEBUFFS //
/////////////
/// The affected is unable to move, or to use, hold, or pickup items.
#define STATUS_EFFECT_STUN /datum/status_effect/incapacitating/stun

#define STATUS_EFFECT_KNOCKDOWN /datum/status_effect/incapacitating/knockdown //the affected is unable to stand up

#define STATUS_EFFECT_IMMOBILIZED /datum/status_effect/incapacitating/immobilized //the affected is unable to move

#define STATUS_EFFECT_PARALYZED /datum/status_effect/incapacitating/paralyzed //the affected is unable to move, use items, or stand up.

/// The affected is unable to use or pickup items
#define STATUS_EFFECT_DAZED /datum/status_effect/incapacitating/dazed

#define STATUS_EFFECT_UNCONSCIOUS /datum/status_effect/incapacitating/unconscious //the affected is unconscious

#define STATUS_EFFECT_SLEEPING /datum/status_effect/incapacitating/sleeping //the affected is asleep

/// Blocks sprint
#define STATUS_EFFECT_STAGGERED /datum/status_effect/staggered

#define STATUS_EFFECT_TASED_WEAK_NODMG /datum/status_effect/electrode/no_damage     // no damage

#define STATUS_EFFECT_TASED_WEAK /datum/status_effect/electrode				//not as crippling, just slows down

#define STATUS_EFFECT_TASED /datum/status_effect/electrode/no_combat_mode //the affected has been tased, preventing fine muscle control

#define STATUS_EFFECT_PACIFY /datum/status_effect/pacify //the affected is pacified, preventing direct hostile actions

#define STATUS_EFFECT_BELLIGERENT /datum/status_effect/belligerent //forces the affected to walk, doing damage if they try to run

#define STATUS_EFFECT_GEISTRACKER /datum/status_effect/geis_tracker //if you're using geis, this tracks that and keeps you from using scripture

#define STATUS_EFFECT_MANIAMOTOR /datum/status_effect/maniamotor //disrupts, damages, and confuses the affected as long as they're in range of the motor
#define MAX_MANIA_SEVERITY 100 //how high the mania severity can go
#define MANIA_DAMAGE_TO_CONVERT 90 //how much damage is required before it'll convert affected targets

#define STATUS_EFFECT_CHOKINGSTRAND /datum/status_effect/strandling //Choking Strand

#define STATUS_EFFECT_HISWRATH /datum/status_effect/his_wrath //His Wrath.

#define STATUS_EFFECT_SUMMONEDGHOST /datum/status_effect/cultghost //is a cult ghost and can't use manifest runes

#define STATUS_EFFECT_CRUSHERMARK /datum/status_effect/crusher_mark //if struck with a proto-kinetic crusher, takes a ton of damage

#define STATUS_EFFECT_SAWBLEED /datum/status_effect/stacking/saw_bleed //if the bleed builds up enough, takes a ton of damage

#define STATUS_EFFECT_NECKSLICE /datum/status_effect/neck_slice //Creates the flavor messages for the neck-slice

#define STATUS_EFFECT_NECROPOLIS_CURSE /datum/status_effect/necropolis_curse
#define CURSE_BLINDING	1 //makes the edges of the target's screen obscured
#define CURSE_SPAWNING	2 //spawns creatures that attack the target only
#define CURSE_WASTING	4 //causes gradual damage
#define CURSE_GRASPING	8 //hands reach out from the sides of the screen, doing damage and stunning if they hit the target

#define STATUS_EFFECT_KINDLE /datum/status_effect/kindle //A knockdown reduced by 1 second for every 3 points of damage the target takes.

#define STATUS_EFFECT_ICHORIAL_STAIN /datum/status_effect/ichorial_stain //Prevents a servant from being revived by vitality matrices for one minute.

#define STATUS_EFFECT_SPASMS /datum/status_effect/spasms //causes random muscle spasms

#define STATUS_EFFECT_FAKE_VIRUS /datum/status_effect/fake_virus //gives you fluff messages for cough, sneeze, headache, etc but without an actual virus

#define STATUS_EFFECT_STASIS /datum/status_effect/grouped/stasis //Halts biological functions like bleeding, chemical processing, blood regeneration, walking, etc

#define STATUS_EFFECT_MESMERIZE /datum/status_effect/mesmerize //Just reskinned no_combat_mode

#define STATUS_EFFECT_ELECTROSTAFF /datum/status_effect/electrostaff		//slows down victim

#define STATUS_EFFECT_LIMP /datum/status_effect/limp //For when you have a busted leg (or two!) and want additional slowdown when walking on that leg

#define STATUS_EFFECT_AMOK /datum/status_effect/amok //Makes the target automatically strike out at adjecent non-heretics.

#define STATUS_EFFECT_CLOUDSTRUCK /datum/status_effect/cloudstruck //blinds and applies an overlay.

#define STATUS_EFFECT_GAUNTLET_CONC /datum/status_effect/cgau_conc // it's a slowdown that really should only be applying to large simplemobs

/// shoves inflict this to indicate the next shove while this is in effect should disarm guns
#define STATUS_EFFECT_OFF_BALANCE /datum/status_effect/off_balance

/////////////
// NEUTRAL //
/////////////

#define STATUS_EFFECT_SIGILMARK /datum/status_effect/sigil_mark

#define STATUS_EFFECT_CRUSHERDAMAGETRACKING /datum/status_effect/crusher_damage //tracks total kinetic crusher damage on a target

#define STATUS_EFFECT_SYPHONMARK /datum/status_effect/syphon_mark //tracks kills for the KA death syphon module

#define STATUS_EFFECT_INLOVE /datum/status_effect/in_love //Displays you as being in love with someone else, and makes hearts appear around them.

#define STATUS_EFFECT_OFFERING /datum/status_effect/offering // you are offering up an item to people

#define STATUS_EFFECT_HANDSHAKE /datum/status_effect/offering/secret_handshake // you are attempting to perform a secret Family handshake

/////////////
//  SLIME  //
/////////////

#define STATUS_EFFECT_RAINBOWPROTECTION /datum/status_effect/rainbow_protection //Invulnerable and pacifistic
#define STATUS_EFFECT_SLIMESKIN /datum/status_effect/slimeskin //Increased armor
#define STATUS_EFFECT_DNA_MELT /datum/status_effect/dna_melt //usually does something horrible to you when you hit 100 genetic instability

/////////////
// GROUPED //
/////////////

#define STASIS_MACHINE_EFFECT "stasis_machine"

#define STASIS_ASCENSION_EFFECT "heretic_ascension"

/// If the incapacitated status effect will ignore a mob in stasis (stasis beds)
#define IGNORE_STASIS (1<<1)
