//Security modules for MODsuits

///Cloaking - Lowers the user's visibility, can be interrupted by being touched or attacked.
/obj/item/mod/module/stealth
	name = "MOD prototype cloaking module"
	desc = "A complete retrofitting of the suit, this is a form of visual concealment tech employing esoteric technology \
		to bend light around the user, as well as mimetic materials to make the surface of the suit match the \
		surroundings based off sensor data. For some reason, this tech is rarely seen."
	icon_state = "cloak"
	module_type = MODULE_TOGGLE
	complexity = 4
	active_power_cost = DEFAULT_CHARGE_DRAIN * 2
	use_power_cost = DEFAULT_CHARGE_DRAIN * 10
	incompatible_modules = list(/obj/item/mod/module/stealth)
	cooldown_time = 5 SECONDS
	/// Whether or not the cloak turns off on bumping.
	var/bumpoff = TRUE
	/// The alpha applied when the cloak is on.
	var/stealth_alpha = 50

/obj/item/mod/module/stealth/on_activation()
	. = ..()
	if(!.)
		return
	if(bumpoff)
		RegisterSignal(mod.wearer, COMSIG_LIVING_MOB_BUMP, .proc/unstealth)
	RegisterSignal(mod.wearer, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, .proc/on_unarmed_attack)
	RegisterSignal(mod.wearer, COMSIG_ATOM_BULLET_ACT, .proc/on_bullet_act)
	RegisterSignal(mod.wearer, list(COMSIG_MOB_ITEM_ATTACK, COMSIG_PARENT_ATTACKBY, COMSIG_ATOM_ATTACK_HAND, COMSIG_ATOM_HULK_ATTACK, COMSIG_ATOM_ATTACK_PAW), .proc/unstealth)
	animate(mod.wearer, alpha = stealth_alpha, time = 1.5 SECONDS)
	drain_power(use_power_cost)

/obj/item/mod/module/stealth/on_deactivation(display_message = TRUE, deleting = FALSE)
	. = ..()
	if(!.)
		return
	if(bumpoff)
		UnregisterSignal(mod.wearer, COMSIG_LIVING_MOB_BUMP)
	UnregisterSignal(mod.wearer, list(COMSIG_HUMAN_MELEE_UNARMED_ATTACK, COMSIG_MOB_ITEM_ATTACK, COMSIG_PARENT_ATTACKBY, COMSIG_ATOM_ATTACK_HAND, COMSIG_ATOM_BULLET_ACT, COMSIG_ATOM_HULK_ATTACK, COMSIG_ATOM_ATTACK_PAW))
	animate(mod.wearer, alpha = 255, time = 1.5 SECONDS)

/obj/item/mod/module/stealth/proc/unstealth(datum/source)
	SIGNAL_HANDLER

	to_chat(mod.wearer, span_warning("[src] gets discharged from contact!"))
	do_sparks(2, TRUE, src)
	drain_power(use_power_cost)
	on_deactivation(display_message = TRUE, deleting = FALSE)

/obj/item/mod/module/stealth/proc/on_unarmed_attack(datum/source, atom/target)
	SIGNAL_HANDLER

	if(!isliving(target))
		return
	unstealth(source)

/obj/item/mod/module/stealth/proc/on_bullet_act(datum/source, obj/item/projectile/projectile)
	SIGNAL_HANDLER

	if(projectile.nodamage)
		return
	unstealth(source)

///Magnetic Harness - Automatically puts guns in your suit storage when you drop them.
/obj/item/mod/module/magnetic_harness
	name = "MOD magnetic harness module"
	desc = "Based off old TerraGov harness kits, this magnetic harness automatically attaches dropped guns back to the wearer."
	icon_state = "mag_harness"
	complexity = 2
	use_power_cost = DEFAULT_CHARGE_DRAIN
	incompatible_modules = list(/obj/item/mod/module/magnetic_harness)
	/// Time before we activate the magnet.
	var/magnet_delay = 0.8 SECONDS
	/// The typecache of all guns we allow.
	var/static/list/guns_typecache
	/// The guns already allowed by the modsuit chestplate.
	var/list/already_allowed_guns = list()

/obj/item/mod/module/magnetic_harness/Initialize(mapload)
	. = ..()
	if(!guns_typecache)
		guns_typecache = typecacheof(list(/obj/item/gun/ballistic, /obj/item/gun/energy, /obj/item/gun/grenadelauncher, /obj/item/gun/chem, /obj/item/gun/syringe))

/obj/item/mod/module/magnetic_harness/on_install()
	already_allowed_guns = guns_typecache & mod.chestplate.allowed
	mod.chestplate.allowed |= guns_typecache

/obj/item/mod/module/magnetic_harness/on_uninstall(deleting = FALSE)
	if(deleting)
		return
	mod.chestplate.allowed -= (guns_typecache - already_allowed_guns)

/obj/item/mod/module/magnetic_harness/on_suit_activation()
	RegisterSignal(mod.wearer, COMSIG_MOB_UNEQUIPPED_ITEM, .proc/check_dropped_item)

/obj/item/mod/module/magnetic_harness/on_suit_deactivation(deleting = FALSE)
	UnregisterSignal(mod.wearer, COMSIG_MOB_UNEQUIPPED_ITEM)

/obj/item/mod/module/magnetic_harness/proc/check_dropped_item(datum/source, obj/item/dropped_item, force, new_location)
	SIGNAL_HANDLER

	if(!is_type_in_typecache(dropped_item, guns_typecache))
		return
	if(new_location != get_turf(src))
		return
	addtimer(CALLBACK(src, .proc/pick_up_item, dropped_item), magnet_delay)

/obj/item/mod/module/magnetic_harness/proc/pick_up_item(obj/item/item)
	if(!isturf(item.loc) || !item.Adjacent(mod.wearer))
		return
	if(!mod.wearer.equip_to_slot_if_possible(item, ITEM_SLOT_SUITSTORE, qdel_on_fail = FALSE, disable_warning = TRUE))
		return
	playsound(src, 'sound/items/modsuit/magnetic_harness.ogg', 50, TRUE)
	balloon_alert(mod.wearer, "[item] reattached")
	drain_power(use_power_cost)

///Pepper Shoulders

///Holster - Instantly holsters any not huge gun.
/obj/item/mod/module/holster
	name = "MOD holster module"
	desc = "Based off typical storage compartments, this system allows the suit to holster a \
		standard firearm across its surface and allow for extremely quick retrieval. \
		While some users prefer the chest, others the forearm for quick deployment, \
		some law enforcement prefer the holster to extend from the thigh."
	icon_state = "holster"
	module_type = MODULE_USABLE
	complexity = 2
	incompatible_modules = list(/obj/item/mod/module/holster)
	cooldown_time = 0.5 SECONDS
	allowed_inactive = TRUE
	/// Gun we have holstered.
	var/obj/item/gun/holstered

/obj/item/mod/module/holster/on_use()
	. = ..()
	if(!.)
		return
	if(!holstered)
		var/obj/item/gun/holding = mod.wearer.get_active_held_item()
		if(!holding)
			balloon_alert(mod.wearer, "nothing to holster!")
			return
		if(!istype(holding) || holding.w_class > WEIGHT_CLASS_BULKY)
			balloon_alert(mod.wearer, "it doesn't fit!")
			return
		if(mod.wearer.transferItemToLoc(holding, src, force = FALSE, silent = TRUE))
			holstered = holding
			balloon_alert(mod.wearer, "weapon holstered")
			playsound(src, 'sound/weapons/revolverempty.ogg', 100, TRUE)
	else if(mod.wearer.put_in_active_hand(holstered, forced = FALSE, ignore_animation = TRUE))
		balloon_alert(mod.wearer, "weapon drawn")
		playsound(src, 'sound/weapons/revolverempty.ogg', 100, TRUE)
	else
		balloon_alert(mod.wearer, "holster full!")

/obj/item/mod/module/holster/on_uninstall(deleting = FALSE)
	if(holstered)
		holstered.forceMove(drop_location())

/obj/item/mod/module/holster/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == holstered)
		holstered = null

/obj/item/mod/module/holster/Destroy()
	QDEL_NULL(holstered)
	return ..()

///Megaphone - Lets you speak loud.
/obj/item/mod/module/megaphone
	name = "MOD megaphone module"
	desc = "A microchip megaphone linked to a MODsuit, for very important purposes, like: loudness."
	icon_state = "megaphone"
	module_type = MODULE_TOGGLE
	complexity = 1
	use_power_cost = DEFAULT_CHARGE_DRAIN * 0.5
	incompatible_modules = list(/obj/item/mod/module/megaphone)
	cooldown_time = 0.5 SECONDS
	/// List of spans we add to the speaker.
	var/list/voicespan = list(SPAN_COMMAND)

/obj/item/mod/module/megaphone/on_activation()
	. = ..()
	if(!.)
		return
	RegisterSignal(mod.wearer, COMSIG_MOB_SAY, .proc/handle_speech)

/obj/item/mod/module/megaphone/on_deactivation(display_message = TRUE, deleting = FALSE)
	. = ..()
	if(!.)
		return
	UnregisterSignal(mod.wearer, COMSIG_MOB_SAY)

/obj/item/mod/module/megaphone/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	speech_args[SPEECH_SPANS] |= voicespan
	drain_power(use_power_cost)

///Criminal Capture

///Mirage grenade dispenser

///Projectile Dampener

///Active Sonar
