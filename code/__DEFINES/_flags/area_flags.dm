// /area/area_flags
////////////////Area flags\\\\\\\\\\\\\\
/// If it's a valid territory for cult summoning or the CRAB-17 phone to spawn
#define VALID_TERRITORY (1<<0)
/// If blobs can spawn there and if it counts towards their score.
#define BLOBS_ALLOWED (1<<1)
/// If mining tunnel generation is allowed in this area
#define CAVES_ALLOWED (1<<2)
/// If flora are allowed to spawn in this area randomly through tunnel generation
#define FLORA_ALLOWED (1<<3)
/// If mobs can be spawned by natural random generation
#define MOB_SPAWN_ALLOWED (1<<4)
/// If megafauna can be spawned by natural random generation
#define MEGAFAUNA_SPAWN_ALLOWED (1<<5)
/// Are you forbidden from teleporting to the area? (centcom, mobs, wizard, hand teleporter)
#define NOTELEPORT (1<<6)
/// Hides area from player Teleport function.
#define HIDDEN_AREA (1<<7)
/// If false, loading multiple maps with this area type will create multiple instances.
#define UNIQUE_AREA (1<<8)
/// If people are allowed to suicide in it. Mostly for OOC stuff like minigames
#define BLOCK_SUICIDE (1<<9)
/// Can the Xenobio management console transverse this area by default?
#define XENOBIOLOGY_COMPATIBLE (1<<10)
/// If Abductors are unable to teleport in with their observation console
#define ABDUCTOR_PROOF (1<<11)
/// If an area should be hidden from power consoles, power/atmosphere alerts, etc.
#define NO_ALERTS (1<<12)
/// If blood cultists can draw runes or build structures on this AREA.
#define CULT_PERMITTED (1<<13)
