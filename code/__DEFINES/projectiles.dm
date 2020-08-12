/// This atom should be ricocheted off of from its inherent properties using standard % chance handling.
#define PROJECTILE_RICOCHET_YES 1
/// This atom should not be ricocheted off of from its inherent properties.
#define PROJECTILE_RICOCHET_NO 2
/// This atom should prevent any kind of projectile ricochet from its inherent properties.
#define PROJECTILE_RICOCHET_PREVENT 3
/// This atom should force a projectile ricochet from its inherent properties.
#define PROJECTILE_RICOCHET_FORCE 4

//bullet_act() return values
#define BULLET_ACT_HIT				"HIT"		//It's a successful hit, whatever that means in the context of the thing it's hitting.
#define BULLET_ACT_BLOCK			"BLOCK"		//It's a blocked hit, whatever that means in the context of the thing it's hitting.
#define BULLET_ACT_FORCE_PIERCE		"PIERCE"	//It pierces through the object regardless of the bullet being piercing by default.
#define BULLET_ACT_TURF				"TURF"		//It hit us but it should hit something on the same turf too. Usually used for turfs.
