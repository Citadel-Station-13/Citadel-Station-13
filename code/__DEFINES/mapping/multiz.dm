// fall_flags
/// Falling should ignore anchored status
#define FALL_IGNORE_ANCHORED		(1<<0)
/// this fall shouldn't incur any sort of self-damage for hitting the ground
#define FALL_CUSHIONED_FALLER		(1<<1)
/// this fall shouldn't damage anything we're falling on
#define FALL_CUSHIONED_IMPACTED		(1<<2)
/// fall got interrupted by something blocking
#define FALL_BLOCKED				(1<<3)
/// fall got interrupted by the atom regaining its footing/gravity overcame
#define FALL_RECOVERED				(1<<4)
/// kill fall entirely, no handling for impacts/recovery
#define FALL_TERMINATED				(1<<5)
/// don't make fall feedback
#define FALL_SILENT					(1<<6)
