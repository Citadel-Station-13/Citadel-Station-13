//component id defines
#define BELLIGERENT_EYE "belligerent_eye"
#define VANGUARD_COGWHEEL "vanguard_cogwheel"
#define GEIS_CAPACITOR "geis_capacitor"
#define REPLICANT_ALLOY "replicant_alloy"
#define HIEROPHANT_ANSIBLE "hierophant_ansible"

var/global/clockwork_construction_value = 0 //The total value of all structures built by the clockwork cult
var/global/clockwork_caches = 0 //How many clockwork caches exist in the world (not each individual)
var/global/clockwork_daemons = 0 //How many daemons exist in the world
var/global/list/clockwork_generals_invoked = list("nezbere" = FALSE, "sevtug" = FALSE, "nzcrentr" = FALSE, "inath-neq" = FALSE) //How many generals have been recently invoked
var/global/list/all_clockwork_objects = list() //All clockwork items, structures, and effects in existence
var/global/list/all_clockwork_mobs = list() //All clockwork SERVANTS (not creatures) in existence
var/global/list/clockwork_component_cache = list(BELLIGERENT_EYE = 0, VANGUARD_COGWHEEL = 0, GEIS_CAPACITOR = 0, REPLICANT_ALLOY = 0, HIEROPHANT_ANSIBLE = 0) //The pool of components that caches draw from
var/global/ratvar_awakens = 0 //If Ratvar has been summoned; not a boolean, for proper handling of multiple ratvars
var/global/clockwork_gateway_activated = FALSE //if a gateway to the celestial derelict has ever been successfully activated
var/global/list/all_scripture = list() //a list containing scripture instances; not used to track existing scripture

//Scripture tiers and requirements; peripherals should never be used
#define SCRIPTURE_PERIPHERAL "Peripheral"
#define SCRIPTURE_DRIVER "Driver"
#define SCRIPTURE_SCRIPT "Script"
#define SCRIPT_SERVANT_REQ 5
#define SCRIPT_CACHE_REQ 1
#define SCRIPTURE_APPLICATION "Application"
#define APPLICATION_SERVANT_REQ 8
#define APPLICATION_CACHE_REQ 3
#define APPLICATION_CV_REQ 100
#define SCRIPTURE_REVENANT "Revenant"
#define REVENANT_SERVANT_REQ 10
#define REVENANT_CACHE_REQ 4
#define REVENANT_CV_REQ 200
#define SCRIPTURE_JUDGEMENT "Judgement"
#define JUDGEMENT_SERVANT_REQ 12
#define JUDGEMENT_CACHE_REQ 5
#define JUDGEMENT_CV_REQ 300

//general component/cooldown things
#define SLAB_PRODUCTION_TIME 900 //how long(deciseconds) slabs require to produce a single component; defaults to 1 minute 30 seconds

#define SLAB_SERVANT_SLOWDOWN 300 //how much each servant above 5 slows down slab-based generation; defaults to 30 seconds per sevant

#define SLAB_SLOWDOWN_MAXIMUM 2700 //maximum slowdown from additional servants; defaults to 4 minutes 30 seconds

#define CACHE_PRODUCTION_TIME 900 //how long(deciseconds) caches require to produce a component; defaults to 1 minute 30 seconds

#define LOWER_PROB_PER_COMPONENT 10 //how much each component in the cache reduces the weight of getting another of that component type

#define MAX_COMPONENTS_BEFORE_RAND 10*LOWER_PROB_PER_COMPONENT //the number of each component, times LOWER_PROB_PER_COMPONENT, you need to have before component generation will become random

#define CLOCKWORK_GENERAL_COOLDOWN 3000 //how long clockwork generals go on cooldown after use, defaults to 5 minutes

//proselytizer defines
#define REPLICANT_ALLOY_UNIT 100 //how much each piece of replicant alloy gives in a clockwork proselytizer

#define REPLICANT_STANDARD REPLICANT_ALLOY_UNIT*0.2 //how much alloy is in anything else; doesn't matter as much as the following

#define REPLICANT_FLOOR REPLICANT_ALLOY_UNIT*0.1 //how much alloy is in a clockwork floor, determines the cost of clockwork floor production

#define REPLICANT_WALL_MINUS_FLOOR REPLICANT_ALLOY_UNIT*0.4 //amount of alloy in a clockwork wall, determines the cost of clockwork wall production

#define REPLICANT_GEAR REPLICANT_ALLOY_UNIT*0.3 //amount of alloy in a wall gear, minus the brass from the wall

#define REPLICANT_WALL_TOTAL REPLICANT_WALL_MINUS_FLOOR+REPLICANT_FLOOR //how much alloy is in a clockwork wall and the floor under it

#define REPLICANT_ROD REPLICANT_ALLOY_UNIT*0.01 //amount of replicant alloy in one rod

#define REPLICANT_METAL REPLICANT_ALLOY_UNIT*0.02 //amount of replicant alloy in one sheet of metal

#define REPLICANT_PLASTEEL REPLICANT_ALLOY_UNIT*0.05 //amount of replicant alloy in one sheet of plasteel

#define RATVAR_ALLOY_CHECK "ratvar?" //when passed into can_use_alloy(), converts it into a check for if ratvar has woken/the proselytizer is debug

//clockcult power defines
#define MIN_CLOCKCULT_POWER 50 //the minimum amount of power clockcult machines will handle gracefully

#define CLOCKCULT_POWER_TO_ALLOY_MULTIPLIER 0.04 //conversion rate for power -> alloy

#define CLOCKCULT_ALLOY_TO_POWER_MULTIPLIER 25 //conversion rate for alloy -> power

#define REPLICANT_ALLOY_POWER REPLICANT_ALLOY_UNIT*CLOCKCULT_ALLOY_TO_POWER_MULTIPLIER //the amount of power you get from a single piece of replicant alloy

//Ark defines
#define GATEWAY_SUMMON_RATE 1 //the time amount the Gateway to the Celestial Derelict gets each process tick; defaults to 1 per tick

#define GATEWAY_REEBE_FOUND 119 //when progress is at or above this, the gateway finds reebe and begins drawing power

#define GATEWAY_RATVAR_COMING 239 //when progress is at or above this, ratvar has entered and is coming through the gateway

#define GATEWAY_RATVAR_ARRIVAL 300 //when progress is at or above this, game over ratvar's here everybody go home

//Objective defines

#define CLOCKCULT_GATEWAY "gateway"

#define CLOCKCULT_ESCAPE "escape"

#define CLOCKCULT_SILICONS "silicons"
