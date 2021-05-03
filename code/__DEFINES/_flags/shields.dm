/// Transparent, let beams pass
#define SHIELD_TRANSPARENT				(1<<0)

/// Flammable, takes more damage from fire
#define SHIELD_ENERGY_WEAK				(1<<1)
/// Fragile, takes more damage from brute
#define SHIELD_KINETIC_WEAK				(1<<2)
/// Strong against kinetic, weak against energy
#define SHIELD_KINETIC_STRONG			(1<<3)
/// Strong against energy, weak against kinetic
#define SHIELD_ENERGY_STRONG			(1<<4)
/// Disabler and other stamina based energy weapons boost the damage done to the sheld
#define SHIELD_DISABLER_DISRUPTED		(1<<5)

/// Doesn't block ranged attacks whatsoever
#define SHIELD_NO_RANGED				(1<<6)
/// Doesn't block melee attacks whatsoever
#define SHIELD_NO_MELEE					(1<<7)

/// Can shield bash
#define SHIELD_CAN_BASH					(1<<8)
/// Shield bash knockdown on wall hit
#define SHIELD_BASH_WALL_KNOCKDOWN		(1<<9)
/// Shield bash always knockdown
#define SHIELD_BASH_ALWAYS_KNOCKDOWN	(1<<10)
/// Shield bash disarm on wall hit
#define SHIELD_BASH_WALL_DISARM			(1<<11)
/// Shield bash always disarm
#define SHIELD_BASH_ALWAYS_DISARM		(1<<12)
/// You can shieldbash target someone on the ground for ground slam
#define SHIELD_BASH_GROUND_SLAM			(1<<13)
/// Shield bashing someone on the ground will disarm
#define SHIELD_BASH_GROUND_SLAM_DISARM	(1<<14)

#define SHIELD_FLAGS_DEFAULT (SHIELD_CAN_BASH | SHIELD_BASH_WALL_KNOCKDOWN | SHIELD_BASH_WALL_DISARM | SHIELD_BASH_GROUND_SLAM)
