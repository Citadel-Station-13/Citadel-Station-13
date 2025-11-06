// /obj/item signals
#define COMSIG_ITEM_ATTACK "item_attack"						//from base of obj/item/attack(): (/mob/living/target, /mob/living/user)
#define COMSIG_ITEM_ATTACK_SELF "item_attack_self"				//from base of obj/item/attack_self(): (/mob)
	#define COMPONENT_NO_INTERACT 1
#define COMSIG_ITEM_ATTACK_OBJ "item_attack_obj"				//from base of obj/item/attack_obj(): (/obj, /mob)
	#define COMPONENT_NO_ATTACK_OBJ 1
#define COMSIG_ITEM_PRE_ATTACK "item_pre_attack"				//from base of obj/item/pre_attack(): (atom/target, mob/user, params)
	#define COMPONENT_NO_ATTACK 1
#define COMSIG_ITEM_AFTERATTACK "item_afterattack"				//from base of obj/item/afterattack(): (atom/target, mob/user, params)
#define COMSIG_ITEM_ALT_AFTERATTACK "item_alt_afterattack"		//from base of obj/item/altafterattack(): (atom/target, mob/user, proximity, params)
#define COMSIG_ITEM_EQUIPPED "item_equip"						//from base of obj/item/equipped(): (/mob/equipper, slot)
/// A mob has just unequipped an item.
#define COMSIG_MOB_UNEQUIPPED_ITEM "mob_unequipped_item"
	// Do not grant actions on equip.
	#define COMPONENT_NO_GRANT_ACTIONS		1
#define COMSIG_ITEM_DROPPED "item_drop"							//from base of obj/item/dropped(): (mob/user)
	// relocated, tell inventory procs if those called this that the item isn't available anymore.
	#define COMPONENT_DROPPED_RELOCATION 1
#define COMSIG_ITEM_PICKUP "item_pickup"						//from base of obj/item/pickup(): (/mob/taker)

/// Sent from obj/item/item_action_slot_check(): (mob/user, datum/action, slot)
#define COMSIG_ITEM_UI_ACTION_SLOT_CHECKED "item_action_slot_checked"
	/// Return to prevent the default behavior (attack_selfing) from occurring.
	#define COMPONENT_ITEM_ACTION_SLOT_INVALID (1<<0)

#define COMSIG_ITEM_ATTACK_ZONE "item_attack_zone"				//from base of mob/living/carbon/attacked_by(): (mob/living/carbon/target, mob/living/user, hit_zone)
#define COMSIG_ITEM_IMBUE_SOUL "item_imbue_soul" 				//return a truthy value to prevent ensouling, checked in /obj/effect/proc_holder/spell/targeted/lichdom/cast(): (mob/user)
#define COMSIG_ITEM_HIT_REACT "item_hit_react"					//from base of obj/item/hit_reaction(): (list/args)
#define COMSIG_ITEM_WEARERCROSSED "wearer_crossed"				//called on item when crossed by something (): (/atom/movable)
#define COMSIG_ITEM_SHARPEN_ACT "sharpen_act"					//from base of item/sharpener/attackby(): (amount, max)
	#define COMPONENT_BLOCK_SHARPEN_APPLIED 1
	#define COMPONENT_BLOCK_SHARPEN_BLOCKED 2
	#define COMPONENT_BLOCK_SHARPEN_ALREADY 4
	#define COMPONENT_BLOCK_SHARPEN_MAXED 8
#define COMSIG_ITEM_MICROWAVE_ACT "microwave_act"               //called on item when microwaved (): (obj/machinery/microwave/M)

// /obj/item signals for economy
#define COMSIG_ITEM_SOLD "item_sold"							//called when an item is sold by the exports subsystem
#define COMSIG_STRUCTURE_UNWRAPPED "structure_unwrapped"		//called when a wrapped up structure is opened by hand
#define COMSIG_ITEM_UNWRAPPED "item_unwrapped"					//called when a wrapped up item is opened by hand
	#define COMSIG_ITEM_SPLIT_VALUE  1
#define COMSIG_ITEM_SPLIT_PROFIT "item_split_profits"			//Called when getting the item's exact ratio for cargo's profit.

#define COMSIG_ITEM_WORN_OVERLAYS "item_worn_overlays"			//from base of obj/item/worn_overlays(): (isinhands, icon_file, used_state, style_flags, list/overlays)
#define COMSIG_ARMOR_PLATED "armor_plated"						//called when an armor plate is successfully applied to an object
// THE FOLLOWING TWO BLOCKS SHOULD RETURN BLOCK FLAGS AS DEFINED IN __DEFINES/combat.dm!
#define COMSIG_ITEM_CHECK_BLOCK "check_block"					//from base of obj/item/check_block(): (mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
#define COMSIG_ITEM_RUN_BLOCK "run_block"						//from base of obj/item/run_block(): (mob/living/owner, atom/object, damage, attack_text, attack_type, armour_penetration, mob/attacker, def_zone, final_block_chance, list/block_return)
// Item mouse siganls
#define COMSIG_ITEM_MOUSE_EXIT "item_mouse_exit"				//from base of obj/item/MouseExited(): (location, control, params)
#define COMSIG_ITEM_MOUSE_ENTER "item_mouse_enter"				//from base of obj/item/MouseEntered(): (location, control, params)
#define COMSIG_ITEM_DECONSTRUCTOR_DEEPSCAN "deconstructor_deepscan"			//Called by deconstructive analyzers deepscanning an item: (obj/machinery/rnd/destructive_analyzer/analyzer_machine, mob/user, list/information_list)
#define COMSIG_ITEM_DISABLE_EMBED "item_disable_embed"			///from [/obj/item/proc/disableEmbedding]:
#define COMSIG_MINE_TRIGGERED "minegoboom"						///from [/obj/effect/mine/proc/triggermine]:
	// Uncovered information
	#define COMPONENT_DEEPSCAN_UNCOVERED_INFORMATION		1
///Called when an item is being offered, from [/obj/item/proc/on_offered(mob/living/carbon/offerer)]
#define COMSIG_ITEM_OFFERING "item_offering"
	///Interrupts the offer proc
	#define COMPONENT_OFFER_INTERRUPT (1<<0)
///Called when an someone tries accepting an offered item, from [/obj/item/proc/on_offer_taken(mob/living/carbon/offer, mob/living/carbon/taker)]
#define COMSIG_ITEM_OFFER_TAKEN "item_offer_taken"
	///Interrupts the offer acceptance
	#define COMPONENT_OFFER_TAKE_INTERRUPT (1<<0)
///from [/obj/structure/closet/supplypod/proc/endlaunch]:
#define COMSIG_SUPPLYPOD_LANDED "supplypodgoboom"

// /obj/item/grenade signals
#define COMSIG_GRENADE_PRIME "grenade_prime"					//called in /obj/item/gun/process_fire (user, target, params, zone_override)
#define COMSIG_GRENADE_ARMED "grenade_armed"					//called in /obj/item/gun/process_fire (user, target, params, zone_override)

// /obj/item/clothing signals
#define COMSIG_SHOES_STEP_ACTION "shoes_step_action"			//from base of obj/item/clothing/shoes/proc/step_action(): ()
#define COMSIG_SUIT_MADE_HELMET "suit_made_helmet"				//from base of obj/item/clothing/suit/MakeHelmet(): (helmet)

// /obj/item/implant signals
#define COMSIG_IMPLANT_ACTIVATED "implant_activated"			//from base of /obj/item/implant/proc/activate(): ()
#define COMSIG_IMPLANT_IMPLANTING "implant_implanting"			//from base of /obj/item/implant/proc/implant(): (list/args)
	#define COMPONENT_STOP_IMPLANTING 1
#define COMSIG_IMPLANT_OTHER "implant_other"					//called on already installed implants when a new one is being added in /obj/item/implant/proc/implant(): (list/args, obj/item/implant/new_implant)
	//#define COMPONENT_STOP_IMPLANTING 1 //The name makes sense for both
	#define COMPONENT_DELETE_NEW_IMPLANT 2
	#define COMPONENT_DELETE_OLD_IMPLANT 4
#define COMSIG_IMPLANT_EXISTING_UPLINK "implant_uplink_exists"	//called on implants being implanted into someone with an uplink implant: (datum/component/uplink)
	//This uses all return values of COMSIG_IMPLANT_OTHER
#define COMSIG_IMPLANT_REMOVING "implant_removing"				//from base of /obj/item/implant/proc/removed() (list/args)

// /obj/item/pda signals
#define COMSIG_PDA_CHANGE_RINGTONE "pda_change_ringtone"		//called on pda when the user changes the ringtone: (mob/living/user, new_ringtone)
	#define COMPONENT_STOP_RINGTONE_CHANGE 1

// /obj/item/radio signals
#define COMSIG_RADIO_NEW_FREQUENCY "radio_new_frequency"		//called from base of /obj/item/radio/proc/set_frequency(): (list/args)

// /obj/item/pen signals
#define COMSIG_PEN_ROTATED "pen_rotated"						//called after rotation in /obj/item/pen/attack_self(): (rotation, mob/living/carbon/user)
