/// From base of /datum/action/cooldown/proc/PreActivate(), sent to the action owner: (datum/action/cooldown/activated)
#define COMSIG_MOB_ABILITY_STARTED "mob_ability_base_started"
	/// Return to block the ability from starting / activating
	#define COMPONENT_BLOCK_ABILITY_START (1<<0)
/// From base of /datum/action/cooldown/proc/PreActivate(), sent to the action owner: (datum/action/cooldown/finished)
#define COMSIG_MOB_ABILITY_FINISHED "mob_ability_base_finished"
