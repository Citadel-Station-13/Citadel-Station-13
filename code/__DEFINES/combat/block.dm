/// Check whether or not we can block, without "triggering" a block. Basically run checks without effects like depleting shields.
/// Wrapper for do_run_block(). The arguments on that means the same as for this.
#define mob_check_block(object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, return_list)\
	do_run_block(FALSE, object, damage, attack_text, attack_type, armour_penetration, attacker, check_zone(def_zone), return_list)

/// Runs a block "sequence", effectively checking and then doing effects if necessary.
/// Wrapper for do_run_block(). The arguments on that means the same as for this.
#define mob_run_block(object, damage, attack_text, attack_type, armour_penetration, attacker, def_zone, return_list)\
	do_run_block(TRUE, object, damage, attack_text, attack_type, armour_penetration, attacker, check_zone(def_zone), return_list)

// Don't ask why there's block_parry.dm and this. This is for the run_block() system, which is the "parent" system of the directional block and parry systems.

/// Bitflags for check_block() and handle_block(). Meant to be combined. You can be hit and still reflect, for example, if you do not use BLOCK_SUCCESS.
/// Attack was not blocked
#define BLOCK_NONE						NONE
/// Attack was blocked, do not do damage. THIS FLAG MUST BE THERE FOR DAMAGE/EFFECT PREVENTION!
#define BLOCK_SUCCESS					(1<<1)

/// The below are for "metadata" on "how" the attack was blocked.

/// Attack was and should be redirected according to list argument REDIRECT_METHOD (NOTE: the SHOULD here is important, as it says "the thing blocking isn't handling the reflecting for you so do it yourself"!)
#define BLOCK_SHOULD_REDIRECT			(1<<2)
/// Attack was redirected (whether by us or by SHOULD_REDIRECT flagging for automatic handling)
#define BLOCK_REDIRECTED				(1<<3)
/// Attack was blocked by something like a shield.
#define BLOCK_PHYSICAL_EXTERNAL			(1<<4)
/// Attack was blocked by something worn on you.
#define BLOCK_PHYSICAL_INTERNAL			(1<<5)
/// Attack outright missed because the target dodged. Should usually be combined with redirection passthrough or something (see martial arts)
#define BLOCK_TARGET_DODGED				(1<<7)
/// Meta-flag for run_block/do_run_block : By default, BLOCK_SUCCESS tells do_run_block() to assume the attack is completely blocked and not continue the block chain. If this is present, it will continue to check other items in the chain rather than stopping.
#define BLOCK_CONTINUE_CHAIN			(1<<8)
/// Attack should change the amount of damage incurred. This means something calling run_block() has to handle it!
#define BLOCK_SHOULD_CHANGE_DAMAGE		(1<<9)
/// Attack should scale by this percent, 0 for no block and 100 for full blocked
#define BLOCK_SHOULD_PARTIAL_MITIGATE	(1<<10)

/// For keys in associative list/block_return as we don't want to saturate our (somewhat) limited flags.
#define BLOCK_RETURN_REDIRECT_METHOD			"REDIRECT_METHOD"
	/// Pass through victim
	#define REDIRECT_METHOD_PASSTHROUGH			"passthrough"
	/// Deflect at randomish angle
	#define REDIRECT_METHOD_DEFLECT				"deflect"
	/// reverse 180 angle, basically (as opposed to "realistic" wall reflections)
	#define REDIRECT_METHOD_REFLECT				"reflect"
	/// "do not taser the bad man with the desword" - actually aims at the firer/attacker rather than just reversing
	#define REDIRECT_METHOD_RETURN_TO_SENDER		"no_you"

/// These keys are generally only applied to the list if real_attack is FALSE. Used incase we want to make "smarter" mob AI in the future or something.
/// Tells the caller how likely from 0 (none) to 100 (always) we are to reflect energy projectiles
#define BLOCK_RETURN_REFLECT_PROJECTILE_CHANCE					"reflect_projectile_chance"
/// Tells the caller how likely we are to block attacks from 0 to 100 in general
#define BLOCK_RETURN_NORMAL_BLOCK_CHANCE						"normal_block_chance"
/// Tells the caller about how many hits we can soak on average before our blocking fails.
#define BLOCK_RETURN_BLOCK_CAPACITY								"block_capacity"
/// Tells the caller we got blocked by active directional block.
#define BLOCK_RETURN_ACTIVE_BLOCK								"active_block"
/// Tells the caller our damage mitigation for their attack.
#define BLOCK_RETURN_ACTIVE_BLOCK_DAMAGE_MITIGATED				"damage_mitigated"
/// For [BLOCK_CHANGE_DAMAGE]. Set damage to this.
#define BLOCK_RETURN_SET_DAMAGE_TO								"set_damage_to"
/// For [BLOCK_SHOULD_PARTIAL_MITIGATE]. Percentage mitigation.
#define BLOCK_RETURN_MITIGATION_PERCENT							"partial_mitigation"
/// Used internally by run_parry proc, use on an on_active_parry() proc to override parrying efficiency.
#define BLOCK_RETURN_OVERRIDE_PARRY_EFFICIENCY					"override_parry_efficiency"
/// Used internally by run_parry proc, use on an on_active_parry() proc to prevent counterattacks
#define BLOCK_RETURN_FORCE_NO_PARRY_COUNTERATTACK				"no_parry_counterattack"
/// Always set to 100 by run_block() if BLOCK_SUCCESS is in return value. Otherwise, defaults to mitigation percent if not set. Used by projectile/proc/on_hit().
#define BLOCK_RETURN_PROJECTILE_BLOCK_PERCENTAGE				"projectile_block_percentage"

/// Default if the above isn't set in the list.
#define DEFAULT_REDIRECT_METHOD_PROJECTILE REDIRECT_METHOD_DEFLECT

/// Block priorities. Higher means it's checked sooner.
// THESE MUST NEVER BE 0! Block code uses ! instead of isnull for the speed boost.
#define BLOCK_PRIORITY_ACTIVE_BLOCK				200
#define BLOCK_PRIORITY_HELD_ITEM				100
#define BLOCK_PRIORITY_CLOTHING					50
#define BLOCK_PRIORITY_WEAR_SUIT				75
#define BLOCK_PRIORITY_UNIFORM					25

#define BLOCK_PRIORITY_DEFAULT BLOCK_PRIORITY_HELD_ITEM
