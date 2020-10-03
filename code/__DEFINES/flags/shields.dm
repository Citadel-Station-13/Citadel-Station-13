/// Transparent, let beams pass
#define SHIELD_TRANSPARENT				(1<<0)
/// Can shield bash
#define SHIELD_CAN_BASH					(1<<1)
/// Shield bash knockdown on wall hit
#define SHIELD_BASH_WALL_KNOCKDOWN		(1<<2)
/// Shield bash always knockdown
#define SHIELD_BASH_ALWAYS_KNOCKDOWN	(1<<3)
/// Shield bash disarm on wall hit
#define SHIELD_BASH_WALL_DISARM			(1<<4)
/// Shield bash always disarm
#define SHIELD_BASH_ALWAYS_DISARM		(1<<5)
/// You can shieldbash target someone on the ground for ground slam
#define SHIELD_BASH_GROUND_SLAM			(1<<6)
/// Shield bashing someone on the ground will disarm
#define SHIELD_BASH_GROUND_SLAM_DISARM	(1<<7)

#define SHIELD_FLAGS_DEFAULT (SHIELD_CAN_BASH | SHIELD_BASH_WALL_KNOCKDOWN | SHIELD_BASH_WALL_DISARM | SHIELD_BASH_GROUND_SLAM)
