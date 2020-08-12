// Attack types for check_block()/run_block(). Flags, combinable.
/// Attack was melee, whether or not armed.
#define ATTACK_TYPE_MELEE			(1<<0)
/// Attack was with a gun or something that should count as a gun (but not if a gun shouldn't count for a gun, crazy right?)
#define ATTACK_TYPE_PROJECTILE		(1<<1)
/// Attack was unarmed.. this usually means hand to hand combat.
#define ATTACK_TYPE_UNARMED			(1<<2)
/// Attack was a thrown atom hitting the victim.
#define ATTACK_TYPE_THROWN			(1<<3)
/// Attack was a bodyslam/leap/tackle. See: Xenomorph leap tackles.
#define ATTACK_TYPE_TACKLE			(1<<4)
/// Attack was from a parry counterattack. Do not attempt to parry-this!
#define ATTACK_TYPE_PARRY_COUNTERATTACK			(1<<5)

// Requires for datum definitions to not error with must be a constant statement when used in lists as text associative keys.
// KEEP IN SYNC WITH ABOVE!

#define TEXT_ATTACK_TYPE_MELEE					"1"
#define TEXT_ATTACK_TYPE_PROJECTILE				"2"
#define TEXT_ATTACK_TYPE_UNARMED				"4"
#define TEXT_ATTACK_TYPE_THROWN					"8"
#define TEXT_ATTACK_TYPE_TACKLE					"16"
#define TEXT_ATTACK_TYPE_PARRY_COUNTERATTACK	"32"

GLOBAL_LIST_INIT(attack_type_names, list(
	TEXT_ATTACK_TYPE_MELEE = "Melee",
	TEXT_ATTACK_TYPE_PROJECTILE = "Projectile",
	TEXT_ATTACK_TYPE_UNARMED = "Unarmed",
	TEXT_ATTACK_TYPE_THROWN = "Thrown",
	TEXT_ATTACK_TYPE_TACKLE = "Tackle",
	TEXT_ATTACK_TYPE_PARRY_COUNTERATTACK = "Parry Counterattack"
))
