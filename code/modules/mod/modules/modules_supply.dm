//Supply modules for MODsuits

///Internal GPS - Extends a GPS you can use.
/obj/item/mod/module/gps
	name = "MOD internal GPS module"
	desc = "This module uses common Nanotrasen technology to calculate the user's position anywhere in space, \
		down to the exact coordinates. This information is fed to a central database viewable from the device itself, \
		though using it to help people is up to you."
	icon_state = "gps"
	module_type = MODULE_USABLE
	complexity = 1
	use_power_cost = DEFAULT_CHARGE_DRAIN * 0.2
	incompatible_modules = list(/obj/item/mod/module/gps)
	cooldown_time = 0.5 SECONDS
	allowed_inactive = TRUE

/obj/item/mod/module/gps/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/gps/item, "MOD0", state = GLOB.deep_inventory_state, overlay_state = FALSE)

/obj/item/mod/module/gps/on_use()
	. = ..()
	if(!.)
		return
	attack_self(mod.wearer)

///Hydraulic Clamp - Lets you pick up and drop crates.
/obj/item/mod/module/clamp
	name = "MOD hydraulic clamp module"
	desc = "A series of actuators installed into both arms of the suit, boasting a lifting capacity of almost a ton. \
		However, this design has been locked by Nanotrasen to be primarily utilized for lifting various crates. \
		A lot of people would say that loading cargo is a dull job, but you could not disagree more."
	icon_state = "clamp"
	module_type = MODULE_ACTIVE
	complexity = 3
	use_power_cost = DEFAULT_CHARGE_DRAIN
	incompatible_modules = list(/obj/item/mod/module/clamp)
	cooldown_time = 0.5 SECONDS
	overlay_state_inactive = "module_clamp"
	overlay_state_active = "module_clamp_on"
	/// Time it takes to load a crate.
	var/load_time = 3 SECONDS
	/// The max amount of crates you can carry.
	var/max_crates = 3
	/// The crates stored in the module.
	var/list/stored_crates = list()

/obj/item/mod/module/clamp/on_select_use(atom/target)
	. = ..()
	if(!.)
		return
	if(!mod.wearer.Adjacent(target))
		return
	if(istype(target, /obj/structure/closet) || istype(target, /obj/structure/bigDelivery))
		var/atom/movable/picked_crate = target
		if(!check_crate_pickup(picked_crate))
			return
		playsound(src, 'sound/mecha/hydraulic.ogg', 25, TRUE)
		if(!do_after(mod.wearer, load_time, target = target))
			balloon_alert(mod.wearer, "interrupted!")
			return
		if(!check_crate_pickup(picked_crate))
			return
		stored_crates += picked_crate
		picked_crate.forceMove(src)
		balloon_alert(mod.wearer, "picked up [picked_crate]")
		drain_power(use_power_cost)
	else if(length(stored_crates))
		var/turf/target_turf = get_turf(target)
		if(is_blocked_turf(target_turf))
			return
		playsound(src, 'sound/mecha/hydraulic.ogg', 25, TRUE)
		if(!do_after(mod.wearer, load_time, target = target))
			balloon_alert(mod.wearer, "interrupted!")
			return
		if(is_blocked_turf(target_turf))
			return
		var/atom/movable/dropped_crate = pop(stored_crates)
		dropped_crate.forceMove(target_turf)
		balloon_alert(mod.wearer, "dropped [dropped_crate]")
		drain_power(use_power_cost)
	else
		balloon_alert(mod.wearer, "invalid target!")

/obj/item/mod/module/clamp/on_suit_deactivation(deleting = FALSE)
	if(deleting)
		return
	for(var/atom/movable/crate as anything in stored_crates)
		crate.forceMove(drop_location())
		stored_crates -= crate

/obj/item/mod/module/clamp/proc/check_crate_pickup(atom/movable/target)
	if(length(stored_crates) >= max_crates)
		balloon_alert(mod.wearer, "too many crates!")
		return FALSE
	for(var/mob/living/mob in target.GetAllContents())
		if(mob.mob_size < MOB_SIZE_HUMAN)
			continue
		balloon_alert(mod.wearer, "crate too heavy!")
		return FALSE
	return TRUE

/obj/item/mod/module/clamp/loader
	name = "MOD loader hydraulic clamp module"
	icon_state = "clamp_loader"
	complexity = 0
	removable = FALSE
	overlay_state_inactive = null
	overlay_state_active = "module_clamp_loader"
	load_time = 1 SECONDS
	max_crates = 5
	use_mod_colors = TRUE

///Drill - Lets you dig through rock and basalt.
/obj/item/mod/module/drill // TODO: Would be cooler with a built-in drill, but meh
	name = "MOD pickaxe/drill storage module"
	desc = "Provides a convenient storage compartment for pickaxes and drills."
	icon_state = "drill"
	complexity = 2
	incompatible_modules = list(/obj/item/mod/module/drill)
	cooldown_time = 0.5 SECONDS
	allowed_inactive = TRUE
	module_type = MODULE_USABLE
	/// Pickaxe we have stored.
	var/obj/item/pickaxe/stored

/obj/item/mod/module/drill/on_use()
	. = ..()
	if(!.)
		return
	if(!stored)
		var/obj/item/pickaxe/holding = mod.wearer.get_active_held_item()
		if(!holding)
			balloon_alert(mod.wearer, "nothing to store!")
			return
		if(!istype(holding))
			balloon_alert(mod.wearer, "it doesn't fit!")
			return
		if(mod.wearer.transferItemToLoc(holding, src, force = FALSE, silent = TRUE))
			stored = holding
			balloon_alert(mod.wearer, "mining instrument stored")
			playsound(src, 'sound/weapons/revolverempty.ogg', 100, TRUE)
	else if(mod.wearer.put_in_active_hand(stored, forced = FALSE, ignore_animation = TRUE))
		balloon_alert(mod.wearer, "mining instrument retrieved")
		playsound(src, 'sound/weapons/revolverempty.ogg', 100, TRUE)
	else
		balloon_alert(mod.wearer, "mining instrument storage full!")

/obj/item/mod/module/drill/on_uninstall(deleting = FALSE)
	if(stored)
		stored.forceMove(drop_location())

/obj/item/mod/module/drill/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == stored)
		stored = null

/obj/item/mod/module/drill/Destroy()
	QDEL_NULL(stored)
	return ..()

/obj/item/mod/module/orebag // TODO
	name = "MOD mining satchel storage module"
	desc = "Provides a convenient storage department for a mining satchel."
	icon_state = "ore"
	module_type = MODULE_USABLE
	complexity = 1
	use_power_cost = DEFAULT_CHARGE_DRAIN * 0.2
	incompatible_modules = list(/obj/item/mod/module/orebag)
	cooldown_time = 0.5 SECONDS
	allowed_inactive = TRUE
	/// Pickaxe we have stored.
	var/obj/item/storage/bag/ore/stored

/obj/item/mod/module/orebag/on_use()
	. = ..()
	if(!.)
		return
	if(!stored)
		var/obj/item/storage/bag/ore/holding = mod.wearer.get_active_held_item()
		if(!holding)
			balloon_alert(mod.wearer, "nothing to store!")
			return
		if(!istype(holding))
			balloon_alert(mod.wearer, "it doesn't fit!")
			return
		if(mod.wearer.transferItemToLoc(holding, src, force = FALSE, silent = TRUE))
			stored = holding
			balloon_alert(mod.wearer, "mining satchel stored")
			playsound(src, 'sound/weapons/revolverempty.ogg', 100, TRUE)
			RegisterSignal(mod.wearer, COMSIG_MOVABLE_MOVED, .proc/Pickup_ores)
	else if(mod.wearer.put_in_active_hand(stored, forced = FALSE, ignore_animation = TRUE))
		UnregisterSignal(mod.wearer, COMSIG_MOVABLE_MOVED)
		balloon_alert(mod.wearer, "mining satchel retrieved")
		playsound(src, 'sound/weapons/revolverempty.ogg', 100, TRUE)
	else
		balloon_alert(mod.wearer, "mining satchel storage full!")

/obj/item/mod/module/orebag/on_uninstall(deleting = FALSE)
	if(stored)
		UnregisterSignal(mod.wearer, COMSIG_MOVABLE_MOVED)
		stored.forceMove(drop_location())

/obj/item/mod/module/orebag/on_equip()
	if(stored)
		RegisterSignal(mod.wearer, COMSIG_MOVABLE_MOVED, .proc/Pickup_ores)

/obj/item/mod/module/orebag/on_unequip()
	if(stored)
		UnregisterSignal(mod.wearer, COMSIG_MOVABLE_MOVED)

/obj/item/mod/module/orebag/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == stored)
		UnregisterSignal(mod.wearer, COMSIG_MOVABLE_MOVED)
		stored = null

/obj/item/mod/module/orebag/Destroy()
	if(stored)
		UnregisterSignal(mod.wearer, COMSIG_MOVABLE_MOVED)
	QDEL_NULL(stored)
	return ..()

/obj/item/mod/module/orebag/proc/Pickup_ores()
	if(stored)
		stored.Pickup_ores(mod.wearer)

// Ash accretion looks cool, but can't be arsed to implement
// Same with sphere transformation
