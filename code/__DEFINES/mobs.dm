/*ALL MOB-RELATED DEFINES THAT DON'T BELONG IN ANOTHER FILE GO HERE*/

//Misc mob defines

//Ready states at roundstart for mob/dead/new_player
#define PLAYER_NOT_READY 0
#define PLAYER_READY_TO_PLAY 1
#define PLAYER_READY_TO_OBSERVE 2

//movement intent defines for the m_intent var
#define MOVE_INTENT_WALK "walk"
#define MOVE_INTENT_RUN  "run"

//Blood levels
#define BLOOD_VOLUME_MAXIMUM		2000
#define BLOOD_VOLUME_SLIME_SPLIT	1120
#define BLOOD_VOLUME_NORMAL			560
#define BLOOD_VOLUME_SAFE			475
#define BLOOD_VOLUME_OKAY			336
#define BLOOD_VOLUME_BAD			224
#define BLOOD_VOLUME_SURVIVE		122

//Sizes of mobs, used by mob/living/var/mob_size
#define MOB_SIZE_TINY 0
#define MOB_SIZE_SMALL 1
#define MOB_SIZE_HUMAN 2
#define MOB_SIZE_LARGE 3

//Ventcrawling defines
#define VENTCRAWLER_NONE   0
#define VENTCRAWLER_NUDE   1
#define VENTCRAWLER_ALWAYS 2

//Bloodcrawling defines
#define BLOODCRAWL 1
#define BLOODCRAWL_EAT 2

//Organ defines for carbon mobs
#define ORGAN_ORGANIC   1
#define ORGAN_ROBOTIC   2

#define BODYPART_ORGANIC   1
#define BODYPART_ROBOTIC   2

#define DEFAULT_BODYPART_ICON_ORGANIC 'icons/mob/human_parts_greyscale.dmi'
#define DEFAULT_BODYPART_ICON_ROBOTIC 'icons/mob/augmentation/augments.dmi'

#define MONKEY_BODYPART "monkey"
#define ALIEN_BODYPART "alien"
#define LARVA_BODYPART "larva"
#define DEVIL_BODYPART "devil"
/*see __DEFINES/inventory.dm for bodypart bitflag defines*/

//Brain Damage defines
#define BRAIN_DAMAGE_MILD 20
#define BRAIN_DAMAGE_SEVERE 100
#define BRAIN_DAMAGE_DEATH 200

#define BRAIN_TRAUMA_MILD /datum/brain_trauma/mild
#define BRAIN_TRAUMA_SEVERE /datum/brain_trauma/severe
#define BRAIN_TRAUMA_SPECIAL /datum/brain_trauma/special

#define BRAIN_DAMAGE_INTEGRITY_MULTIPLIER 0.5

//Health hud screws for carbon mobs
#define SCREWYHUD_NONE 0
#define SCREWYHUD_CRIT 1
#define SCREWYHUD_DEAD 2
#define SCREWYHUD_HEALTHY 3

//Nutrition levels for humans
#define NUTRITION_LEVEL_FAT 600
#define NUTRITION_LEVEL_FULL 550
#define NUTRITION_LEVEL_WELL_FED 450
#define NUTRITION_LEVEL_FED 350
#define NUTRITION_LEVEL_HUNGRY 250
#define NUTRITION_LEVEL_STARVING 150

//Disgust levels for humans
#define DISGUST_LEVEL_MAXEDOUT 150
#define DISGUST_LEVEL_DISGUSTED 75
#define DISGUST_LEVEL_VERYGROSS 50
#define DISGUST_LEVEL_GROSS 25

//Slime evolution threshold. Controls how fast slimes can split/grow
#define SLIME_EVOLUTION_THRESHOLD 10

//Slime commands defines
#define SLIME_FRIENDSHIP_FOLLOW 			3 //Min friendship to order it to follow
#define SLIME_FRIENDSHIP_STOPEAT 			5 //Min friendship to order it to stop eating someone
#define SLIME_FRIENDSHIP_STOPEAT_NOANGRY	7 //Min friendship to order it to stop eating someone without it losing friendship
#define SLIME_FRIENDSHIP_STOPCHASE			4 //Min friendship to order it to stop chasing someone (their target)
#define SLIME_FRIENDSHIP_STOPCHASE_NOANGRY	6 //Min friendship to order it to stop chasing someone (their target) without it losing friendship
#define SLIME_FRIENDSHIP_STAY				3 //Min friendship to order it to stay
#define SLIME_FRIENDSHIP_ATTACK				8 //Min friendship to order it to attack

//Sentience types, to prevent things like sentience potions from giving bosses sentience
#define SENTIENCE_ORGANIC 1
#define SENTIENCE_ARTIFICIAL 2
#define SENTIENCE_OTHER 3
#define SENTIENCE_MINEBOT 4
#define SENTIENCE_BOSS 5

//Mob AI Status

//Hostile simple animals
//If you add a new status, be sure to add a list for it to the simple_animals global in _globalvars/lists/mobs.dm
#define AI_ON		1
#define AI_IDLE		2
#define AI_OFF		3
#define AI_Z_OFF	4

//determines if a mob can smash through it
#define ENVIRONMENT_SMASH_NONE 0
#define ENVIRONMENT_SMASH_STRUCTURES 1 //crates, lockers, ect
#define ENVIRONMENT_SMASH_WALLS 2   //walls
#define ENVIRONMENT_SMASH_RWALLS 4  //rwalls


//SNPCs
//AI defines
#define INTERACTING 2
#define TRAVEL 4
#define FIGHTING 8
//Trait defines
#define TRAIT_ROBUST 2
#define TRAIT_UNROBUST 4
#define TRAIT_SMART 8
#define TRAIT_DUMB 16
#define TRAIT_MEAN 32
#define TRAIT_FRIENDLY 64
#define TRAIT_THIEVING 128
//Range/chance defines
#define MAX_RANGE_FIND 32
#define MIN_RANGE_FIND 16
#define FUZZY_CHANCE_HIGH 85
#define FUZZY_CHANCE_LOW 50
#define CHANCE_TALK 1
//Traitor type defines
#define SNPC_BRUTE 1
#define SNPC_STEALTH 2
#define SNPC_MARTYR 3
#define SNPC_PSYCHO 4

#define TK_MAXRANGE 15

#define NO_SLIP_WHEN_WALKING 1
#define SLIDE 2
#define GALOSHES_DONT_HELP 4
#define SLIDE_ICE 8

#define MAX_CHICKENS 50

#define UNHEALING_EAR_DAMAGE 100


#define INCORPOREAL_MOVE_BASIC 1
#define INCORPOREAL_MOVE_SHADOW 2 // leaves a trail of shadows
#define INCORPOREAL_MOVE_JAUNT 3 // is blocked by holy water/salt

//Secbot and ED209 judgement criteria bitflag values
#define JUDGE_EMAGGED 1
#define JUDGE_IDCHECK 2
#define JUDGE_WEAPONCHECK 4
#define JUDGE_RECORDCHECK 8
//ED209's ignore monkeys
#define JUDGE_IGNOREMONKEYS 16

#define MEGAFAUNA_DEFAULT_RECOVERY_TIME 5

#define SHADOW_SPECIES_LIGHT_THRESHOLD 0.2

// Offsets defines

#define OFFSET_UNIFORM "uniform"
#define OFFSET_ID "id"
#define OFFSET_GLOVES "gloves"
#define OFFSET_GLASSES "glasses"
#define OFFSET_EARS "ears"
#define OFFSET_SHOES "shoes"
#define OFFSET_S_STORE "s_store"
#define OFFSET_FACEMASK "mask"
#define OFFSET_HEAD "head"
#define OFFSET_FACE "face"
#define OFFSET_BELT "belt"
#define OFFSET_BACK "back"
#define OFFSET_SUIT "suit"
#define OFFSET_NECK "neck"