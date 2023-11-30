//Medical modules for MODsuits

#define HEALTH_SCAN "Health"
#define WOUND_SCAN "Wound"
#define CHEM_SCAN "Chemical"

///Health Analyzer - Gives the user a ranged health analyzer and their health status in the panel.
/obj/item/mod/module/health_analyzer
	name = "MOD health analyzer module"
	desc = "A module installed into the glove of the suit. This is a high-tech biological scanning suite, \
		allowing the user indepth information on the vitals and injuries of others even at a distance, \
		all with the flick of the wrist. Data is displayed in a convenient package on HUD in the helmet, \
		but it's up to you to do something with it."
	icon_state = "health"
	module_type = MODULE_ACTIVE
	complexity = 2
	use_power_cost = DEFAULT_CHARGE_DRAIN
	incompatible_modules = list(/obj/item/mod/module/health_analyzer)
	cooldown_time = 0.5 SECONDS
	tgui_id = "health_analyzer"
	/// Scanning mode, changes how we scan something.
	var/mode = HEALTH_SCAN
	/// List of all scanning modes.
	var/static/list/modes = list(HEALTH_SCAN, WOUND_SCAN, CHEM_SCAN)

/obj/item/mod/module/health_analyzer/add_ui_data()
	. = ..()
	.["userhealth"] = mod.wearer?.health || 0
	.["usermaxhealth"] = mod.wearer?.getMaxHealth() || 0
	.["userbrute"] = mod.wearer?.getBruteLoss() || 0
	.["userburn"] = mod.wearer?.getFireLoss() || 0
	.["usertoxin"] = mod.wearer?.getToxLoss() || 0
	.["useroxy"] = mod.wearer?.getOxyLoss() || 0

/obj/item/mod/module/health_analyzer/on_select_use(atom/target)
	. = ..()
	if(!.)
		return
	if(!isliving(target) || !mod.wearer.can_read(src))
		return
	switch(mode)
		if(HEALTH_SCAN)
			healthscan(mod.wearer, target)
		if(WOUND_SCAN)
			woundscan(mod.wearer, target)
		if(CHEM_SCAN)
			chemscan(mod.wearer, target)
	drain_power(use_power_cost)

/obj/item/mod/module/health_analyzer/get_configuration()
	. = ..()
	.["mode"] = add_ui_configuration("Scan Mode", "list", mode, modes)

/obj/item/mod/module/health_analyzer/configure_edit(key, value)
	switch(key)
		if("mode")
			mode = value

#undef HEALTH_SCAN
#undef WOUND_SCAN
#undef CHEM_SCAN

///Quick Carry - Lets the user carry bodies quicker.
/obj/item/mod/module/quick_carry
	name = "MOD quick carry module"
	desc = "A suite of advanced servos, redirecting power from the suit's arms to help carry the wounded; \
		or simply for fun. However, Nanotrasen has locked the module's ability to assist in hand-to-hand combat."
	icon_state = "carry"
	complexity = 1
	idle_power_cost = DEFAULT_CHARGE_DRAIN * 0.3
	incompatible_modules = list(/obj/item/mod/module/quick_carry, /obj/item/mod/module/constructor)

/obj/item/mod/module/quick_carry/on_suit_activation()
	ADD_TRAIT(mod.wearer, TRAIT_QUICKER_CARRY, MOD_TRAIT)

/obj/item/mod/module/quick_carry/on_suit_deactivation(deleting = FALSE)
	REMOVE_TRAIT(mod.wearer, TRAIT_QUICKER_CARRY, MOD_TRAIT)

/obj/item/mod/module/quick_carry/advanced
	name = "MOD advanced quick carry module"
	removable = FALSE
	complexity = 0

///Injector - No piercing syringes, replace another time

///Organ Thrower

///Patrient Transport

///Defibrillator - Gives the suit an extendable pair of shock paddles.
/obj/item/mod/module/defibrillator
	name = "MOD defibrillator module"
	desc = "A module built into the gauntlets of the suit; commonly known as the 'Healing Hands' by medical professionals. \
		The user places their palms above the patient. Onboard computers in the suit calculate the necessary voltage, \
		and a modded targeting computer determines the best position for the user to push. \
		Twenty five pounds of force are applied to the patient's skin. Shocks travel from the suit's gloves \
		and counter-shock the heart, and the wearer returns to Medical a hero. Don't you even think about using it as a weapon; \
		regulations on manufacture and software locks expressly forbid it."
	icon_state = "defibrillator"
	module_type = MODULE_ACTIVE
	complexity = 2
	use_power_cost = DEFAULT_CHARGE_DRAIN * 25
	device = /obj/item/shockpaddles/mod
	overlay_state_inactive = "module_defibrillator"
	overlay_state_active = "module_defibrillator_active"
	incompatible_modules = list(/obj/item/mod/module/defibrillator)
	cooldown_time = 0.5 SECONDS
	var/defib_cooldown = 5 SECONDS

/obj/item/mod/module/defibrillator/Initialize(mapload)
	. = ..()
	RegisterSignal(device, COMSIG_DEFIBRILLATOR_SUCCESS, PROC_REF(on_defib_success))

/obj/item/mod/module/defibrillator/Destroy()
	UnregisterSignal(device, COMSIG_DEFIBRILLATOR_SUCCESS)
	. = ..()

/obj/item/mod/module/defibrillator/proc/on_defib_success(obj/item/shockpaddles/source)
	drain_power(use_power_cost)
	source.recharge(defib_cooldown)
	return COMPONENT_DEFIB_STOP

/obj/item/shockpaddles/mod
	name = "MOD defibrillator gauntlets"
	req_defib = FALSE
	icon_state = "defibgauntlets0"
	item_state = "defibgauntlets0"
	base_icon_state = "defibgauntlets"

/obj/item/mod/module/defibrillator/combat
	name = "MOD combat defibrillator module"
	desc = "A module built into the gauntlets of the suit; commonly known as the 'Healing Hands' by medical professionals. \
		The user places their palms above the patient. Onboard computers in the suit calculate the necessary voltage, \
		and a modded targeting computer determines the best position for the user to push. \
		Twenty five pounds of force are applied to the patient's skin. Shocks travel from the suit's gloves \
		and counter-shock the heart, and the wearer returns to Medical a hero. \
		Interdyne Pharmaceutics marketed the domestic version of the Healing Hands as foolproof and unusable as a weapon. \
		But when it came time to provide their operatives with usable medical equipment, they didn't hesitate to remove \
		those in-built safeties. Operatives in the field can benefit from what they dub as 'Stun Gloves', able to apply shocks \
		straight to a victims heart to disable them, or maybe even outright stop their heart with enough power."
	complexity = 1
	module_type = MODULE_ACTIVE
	overlay_state_inactive = "module_defibrillator_combat"
	overlay_state_active = "module_defibrillator_combat_active"
	device = /obj/item/shockpaddles/syndicate/mod
	defib_cooldown = 2.5 SECONDS

/obj/item/shockpaddles/syndicate/mod
	name = "MOD combat defibrillator gauntlets"
	req_defib = FALSE
	icon_state = "syndiegauntlets0"
	item_state = "syndiegauntlets0"
	base_icon_state = "syndiegauntlets"

///Thread Ripper

///Surgical Processor - Lets you do advanced surgeries portably.
/obj/item/mod/module/surgical_processor
	name = "MOD surgical processor module"
	desc = "A module using an onboard surgical computer which can be connected to other computers to download and \
		perform advanced surgeries on the go."
	icon_state = "surgical_processor"
	module_type = MODULE_ACTIVE
	complexity = 2
	active_power_cost = DEFAULT_CHARGE_DRAIN
	device = /obj/item/surgical_processor/mod
	incompatible_modules = list(/obj/item/mod/module/surgical_processor)
	cooldown_time = 0.5 SECONDS

/obj/item/surgical_processor/mod
	name = "MOD surgical processor"

/obj/item/mod/module/surgical_processor/preloaded
	desc = "A module using an onboard surgical computer which can be connected to other computers to download and \
		perform advanced surgeries on the go. This one came pre-loaded with some advanced surgeries."
	device = /obj/item/surgical_processor/mod/preloaded

/obj/item/surgical_processor/mod/preloaded
	advanced_surgeries = list(
		/datum/surgery/advanced/pacify,
		/datum/surgery/healing/combo/upgraded/femto,
		/datum/surgery/advanced/brainwashing,
		/datum/surgery/advanced/bioware/nerve_splicing,
		/datum/surgery/advanced/bioware/nerve_grounding,
		/datum/surgery/advanced/bioware/vein_threading,
		/datum/surgery/advanced/bioware/muscled_veins,
		/datum/surgery/advanced/bioware/ligament_hook,
		/datum/surgery/advanced/bioware/ligament_reinforcement
	)
