// melee_attack_chain() attackchain_flags
/// The attack is from a parry counterattack.
#define ATTACKCHAIN_PARRY_COUNTERATTACK			(1<<0)

// melee_attack_chain(), attackby(), pre_attack(), afterattack(), and tool_act() return values.
/// Stop the attack chain if still in melee_attack_chain()
#define STOP_ATTACK_PROC_CHAIN					(1<<0)
/// This attack should discard last_action instead of flushing (storing) it). You should probably know what you're doing if you use this considering this is how clickdelay is enforced.
#define DISCARD_LAST_ACTION						(1<<1)
/// Override automatic last_action set. There's usually a safety net in that attempting to attack a mob will set last_action even if the item itself doesn't specifically set it. If this is present, that doesn't happen.
#define MANUALLY_HANDLE_LAST_ACTION				(1<<2)

// UnarmedAttack() flags
/// Attack is from a parry counterattack
#define UNARMED_ATTACK_PARRY					(1<<0)

// obj/item/dropped()
/// dropped() relocated this item, return FALSE for doUnEquip.
#define ITEM_RELOCATED_BY_DROPPED			"relocated_by_dropped"
