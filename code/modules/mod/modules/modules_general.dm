//General modules for MODsuits

///Storage - Adds a storage component to the suit.
/obj/item/mod/module/storage
	name = "MOD storage containment module"
	desc = "What amounts to a series of integrated storage compartments and specialized pockets installed across \
		the surface of the suit, useful for storing various bits, and or bobs."
	icon_state = "storage"
	complexity = 3
	incompatible_modules = list(/obj/item/mod/module/storage)
	module_type = MODULE_USABLE
	cooldown_time = 0.5 SECONDS
	allowed_inactive = TRUE
	/// Bag we have stored.
	var/obj/item/storage/backpack/stored

/obj/item/mod/module/storage/attackby(obj/item/I, mob/user, params)
	if(!istype(I, /obj/item/storage/backpack))
		return ..()
	var/obj/item/storage/backpack/B = I
	if(stored)
		balloon_alert(user, "backpack already installed!")
		return
	if(!user.transferItemToLoc(B, src))
		return
	stored = B
	balloon_alert(user, "backpack installed")
	playsound(src, 'sound/machines/click.ogg', 30, TRUE)

/obj/item/mod/module/storage/screwdriver_act(mob/living/user, obj/item/tool)
	. = ..()
	if(!stored)
		balloon_alert(user, "no backpack!")
		return
	balloon_alert(user, "removing backpack...")
	if(!do_after(user, 3 SECONDS, target = src))
		balloon_alert(user, "interrupted!")
		return
	balloon_alert(user, "backpack removed")
	stored.forceMove(drop_location())
	if(Adjacent(user) && !issilicon(user))
		user.put_in_hands(stored)
	stored = null

/obj/item/mod/module/storage/on_use()
	. = ..()
	if(!.)
		return
	if(!stored)
		var/obj/item/storage/backpack/holding = mod.wearer.get_active_held_item()
		if(!holding)
			balloon_alert(mod.wearer, "no backpack installed!")
			return
		if(!istype(holding))
			balloon_alert(mod.wearer, "it doesn't fit!")
			return
		if(mod.wearer.transferItemToLoc(holding, src, force = FALSE, silent = TRUE))
			stored = holding
			balloon_alert(mod.wearer, "backpack stored")
			playsound(src, 'sound/weapons/revolverempty.ogg', 100, TRUE)
	else if(mod.wearer.put_in_active_hand(stored, forced = FALSE, ignore_animation = TRUE))
		balloon_alert(mod.wearer, "backpack retrieved")
		playsound(src, 'sound/weapons/revolverempty.ogg', 100, TRUE)
	else
		balloon_alert(mod.wearer, "backpack storage full!")

/obj/item/mod/module/storage/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == stored)
		stored = null

/obj/item/mod/module/storage/Destroy()
	QDEL_NULL(stored)
	return ..()

///Ion Jetpack - Lets the user fly freely through space using battery charge.
/obj/item/mod/module/jetpack
	name = "MOD ion jetpack module"
	desc = "A series of electric thrusters installed across the suit, this is a module highly anticipated by trainee Engineers. \
		Rather than using gasses for combustion thrust, these jets are capable of accelerating ions using \
		charge from the suit's charge. Some say this isn't Nakamura Engineering's first foray into jet-enabled suits."
	icon_state = "jetpack"
	module_type = MODULE_TOGGLE
	complexity = 3
	active_power_cost = DEFAULT_CHARGE_DRAIN * 0.5
	use_power_cost = DEFAULT_CHARGE_DRAIN
	incompatible_modules = list(/obj/item/mod/module/jetpack)
	cooldown_time = 0.5 SECONDS
	overlay_state_inactive = "module_jetpack"
	overlay_state_active = "module_jetpack_on"
	/// Do we stop the wearer from gliding in space.
	var/stabilizers = FALSE
	/// Do we give the wearer a speed buff.
	var/full_speed = FALSE
	var/datum/effect_system/trail_follow/ion/ion_trail

/obj/item/mod/module/jetpack/Initialize(mapload)
	. = ..()
	ion_trail = new
	ion_trail.set_up(src)

/obj/item/mod/module/jetpack/Destroy()
	QDEL_NULL(ion_trail)
	return ..()

/obj/item/mod/module/jetpack/on_activation()
	. = ..()
	if(!.)
		return
	ion_trail.start()
	RegisterSignal(mod.wearer, COMSIG_MOVABLE_MOVED, PROC_REF(move_react))
	if(full_speed)
		mod.wearer.add_movespeed_modifier(/datum/movespeed_modifier/jetpack/fullspeed)
	else
		mod.wearer.add_movespeed_modifier(/datum/movespeed_modifier/jetpack)

/obj/item/mod/module/jetpack/on_deactivation(display_message = TRUE, deleting = FALSE)
	. = ..()
	stabilizers = FALSE
	ion_trail.stop()
	UnregisterSignal(mod.wearer, COMSIG_MOVABLE_MOVED)
	mod.wearer.remove_movespeed_modifier(/datum/movespeed_modifier/jetpack/fullspeed)
	mod.wearer.remove_movespeed_modifier(/datum/movespeed_modifier/jetpack)

/obj/item/mod/module/jetpack/get_configuration()
	. = ..()
	.["stabilizers"] = add_ui_configuration("Stabilizers", "bool", stabilizers)

/obj/item/mod/module/jetpack/configure_edit(key, value)
	switch(key)
		if("stabilizers")
			stabilizers = text2num(value)

/obj/item/mod/module/jetpack/proc/move_react(mob/user)
	allow_thrust()

/obj/item/mod/module/jetpack/proc/allow_thrust(use_fuel = TRUE)
	if(!active)
		return FALSE
	if(!use_fuel)
		return check_power(use_power_cost)
	if(!drain_power(use_power_cost))
		return FALSE
	return TRUE

/obj/item/mod/module/jetpack/advanced
	name = "MOD advanced ion jetpack module"
	desc = "An improvement on the previous model of electric thrusters. This one achieves higher speeds through \
		mounting of more jets and a red paint applied on it."
	icon_state = "jetpack_advanced"
	overlay_state_inactive = "module_jetpackadv"
	overlay_state_active = "module_jetpackadv_on"
	full_speed = TRUE

///Eating Apparatus - Lets the user eat/drink with the suit on.
/obj/item/mod/module/mouthhole
	name = "MOD eating apparatus module"
	desc = "A favorite by Miners, this modification to the helmet utilizes a nanotechnology barrier infront of the mouth \
		to allow eating and drinking while retaining protection and atmosphere. However, it won't free you from masks, \
		lets pepper spray pass through and it will do nothing to improve the taste of a goliath steak."
	icon_state = "apparatus"
	complexity = 1
	incompatible_modules = list(/obj/item/mod/module/mouthhole)
	overlay_state_inactive = "module_apparatus"
	/// Former flags of the helmet.
	var/former_flags = NONE
	/// Former visor flags of the helmet.
	var/former_visor_flags = NONE

/obj/item/mod/module/mouthhole/on_install()
	former_flags = mod.helmet.flags_cover
	former_visor_flags = mod.helmet.visor_flags_cover
	mod.helmet.flags_cover &= ~HEADCOVERSMOUTH
	mod.helmet.visor_flags_cover &= ~HEADCOVERSMOUTH

/obj/item/mod/module/mouthhole/on_uninstall(deleting = FALSE)
	if(deleting)
		return
	mod.helmet.flags_cover |= former_flags
	mod.helmet.visor_flags_cover |= former_visor_flags

///EMP Shield - Protects the suit from EMPs.
/obj/item/mod/module/emp_shield
	name = "MOD EMP shield module"
	desc = "A field inhibitor installed into the suit, protecting it against feedback such as \
		electromagnetic pulses that would otherwise damage the electronic systems of the suit or it's modules. \
		However, it will take from the suit's power to do so."
	icon_state = "empshield"
	complexity = 1
	idle_power_cost = DEFAULT_CHARGE_DRAIN * 0.3
	incompatible_modules = list(/obj/item/mod/module/emp_shield)

/obj/item/mod/module/emp_shield/on_install()
	mod.AddElement(/datum/element/empprotection, EMP_PROTECT_SELF|EMP_PROTECT_WIRES|EMP_PROTECT_CONTENTS)

/obj/item/mod/module/emp_shield/on_uninstall(deleting = FALSE)
	mod.RemoveElement(/datum/element/empprotection, EMP_PROTECT_SELF|EMP_PROTECT_WIRES|EMP_PROTECT_CONTENTS)

/obj/item/mod/module/emp_shield/advanced
	name = "MOD advanced EMP shield module"
	desc = "An advanced field inhibitor installed into the suit, protecting it against feedback such as \
		electromagnetic pulses that would otherwise damage the electronic systems of the suit or electronic devices on the wearer, \
		including augmentations. However, it will take from the suit's power to do so."
	complexity = 2

/obj/item/mod/module/emp_shield/advanced/on_suit_activation()
	mod.wearer.AddElement(/datum/element/empprotection, EMP_PROTECT_SELF|EMP_PROTECT_CONTENTS)

/obj/item/mod/module/emp_shield/advanced/on_suit_deactivation(deleting)
	mod.wearer.RemoveElement(/datum/element/empprotection, EMP_PROTECT_SELF|EMP_PROTECT_CONTENTS)

///Flashlight - Gives the suit a customizable flashlight.
/obj/item/mod/module/flashlight
	name = "MOD flashlight module"
	desc = "A simple pair of configurable flashlights installed on the left and right sides of the helmet, \
		useful for providing light in a variety of ranges and colors. \
		Some survivalists prefer the color green for their illumination, for reasons unknown."
	icon_state = "flashlight"
	module_type = MODULE_TOGGLE
	complexity = 1
	active_power_cost = DEFAULT_CHARGE_DRAIN * 0.3
	incompatible_modules = list(/obj/item/mod/module/flashlight)
	cooldown_time = 0.5 SECONDS
	overlay_state_inactive = "module_light"
	light_color = COLOR_WHITE
	light_range = 4
	light_power = 1
	/// Charge drain per range amount.
	var/base_power = DEFAULT_CHARGE_DRAIN * 0.1
	/// Minimum range we can set.
	var/min_range = 2
	/// Maximum range we can set.
	var/max_range = 5

/obj/item/mod/module/flashlight/on_activation()
	. = ..()
	if(!.)
		return
	mod.set_light(light_range, light_power, light_color)
	active_power_cost = base_power * light_range

/obj/item/mod/module/flashlight/on_deactivation(display_message = TRUE, deleting = FALSE)
	. = ..()
	if(!.)
		return
	mod.set_light(0, 0)

/obj/item/mod/module/flashlight/on_process(delta_time)
	active_power_cost = base_power * light_range
	return ..()

/obj/item/mod/module/flashlight/generate_worn_overlay()
	. = ..()
	if(!active)
		return
	var/mutable_appearance/light_icon = mutable_appearance(overlay_icon_file, "module_light_on")
	light_icon.appearance_flags = RESET_COLOR
	light_icon.color = light_color
	. += light_icon

/obj/item/mod/module/flashlight/get_configuration()
	. = ..()
	.["light_color"] = add_ui_configuration("Light Color", "color", light_color)
	.["light_range"] = add_ui_configuration("Light Range", "number", light_range)

/obj/item/mod/module/flashlight/configure_edit(key, value)
	switch(key)
		if("light_color")
			value = input(usr, "Pick new light color", "Flashlight Color") as color|null
			if(!value)
				return
			var/list/hsl = rgb2hsl(hex2num(copytext(value,2,4)),hex2num(copytext(value,4,6)),hex2num(copytext(value,6,8)))
			if(hsl[3] < 0.5)
				balloon_alert(mod.wearer, "too dark!")
				return
			mod.set_light_color(value)
			mod.wearer.regenerate_icons()
			light_color = value
		if("light_range")
			mod.set_light_range(clamp(value, min_range, max_range))
			light_range = clamp(value, min_range, max_range)

///Dispenser - Dispenses an item after a time passes.
/obj/item/mod/module/dispenser
	name = "MOD burger dispenser module"
	desc = "A rare piece of technology reverse-engineered from a prototype found in a Donk Corporation vessel. \
		This can draw incredible amounts of power from the suit's charge to create edible organic matter in the \
		palm of the wearer's glove; however, research seemed to have entirely stopped at burgers. \
		Notably, all attempts to get it to dispense Earl Grey tea have failed."
	icon_state = "dispenser"
	module_type = MODULE_USABLE
	complexity = 3
	use_power_cost = DEFAULT_CHARGE_DRAIN * 2
	incompatible_modules = list(/obj/item/mod/module/dispenser)
	cooldown_time = 5 SECONDS
	/// Path we dispense.
	var/dispense_type = /obj/item/reagent_containers/food/snacks/burger/plain
	/// Time it takes for us to dispense.
	var/dispense_time = 0 SECONDS

/obj/item/mod/module/dispenser/on_use()
	. = ..()
	if(!.)
		return
	if(dispense_time && !do_after(mod.wearer, dispense_time, target = mod))
		balloon_alert(mod.wearer, "interrupted!")
		return FALSE
	var/obj/item/dispensed = new dispense_type(mod.wearer.loc)
	mod.wearer.put_in_hands(dispensed)
	balloon_alert(mod.wearer, "[dispensed] dispensed")
	playsound(src, 'sound/machines/click.ogg', 100, TRUE)
	drain_power(use_power_cost)
	return dispensed

///Longfall

///Thermal Regulator - Naw.

///DNA Lock - Prevents people without the set DNA from activating the suit.
/obj/item/mod/module/dna_lock
	name = "MOD DNA lock module"
	desc = "A module which engages with the various locks and seals tied to the suit's systems, \
		enabling it to only be worn by someone corresponding with the user's exact DNA profile; \
		however, this incredibly sensitive module is shorted out by EMPs. Luckily, cloning has been outlawed."
	icon_state = "dnalock"
	module_type = MODULE_USABLE
	complexity = 2
	use_power_cost = DEFAULT_CHARGE_DRAIN * 3
	incompatible_modules = list(/obj/item/mod/module/dna_lock)
	cooldown_time = 0.5 SECONDS
	/// The DNA we lock with.
	var/dna = null

/obj/item/mod/module/dna_lock/on_install()
	RegisterSignal(mod, COMSIG_MOD_ACTIVATE, PROC_REF(on_mod_activation))
	RegisterSignal(mod, COMSIG_MOD_MODULE_REMOVAL, PROC_REF(on_mod_removal))
	RegisterSignal(mod, COMSIG_ATOM_EMP_ACT, PROC_REF(on_emp))
	RegisterSignal(mod, COMSIG_ATOM_EMAG_ACT, PROC_REF(on_emag))

/obj/item/mod/module/dna_lock/on_uninstall(deleting = FALSE)
	UnregisterSignal(mod, COMSIG_MOD_ACTIVATE)
	UnregisterSignal(mod, COMSIG_MOD_MODULE_REMOVAL)
	UnregisterSignal(mod, COMSIG_ATOM_EMP_ACT)
	UnregisterSignal(mod, COMSIG_ATOM_EMAG_ACT)

/obj/item/mod/module/dna_lock/on_use()
	. = ..()
	if(!.)
		return
	dna = mod.wearer.dna.unique_enzymes
	balloon_alert(mod.wearer, "dna updated")
	drain_power(use_power_cost)

/obj/item/mod/module/dna_lock/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	on_emp(src, severity)

/obj/item/mod/module/dna_lock/emag_act(mob/user, obj/item/card/emag/emag_card)
	. = ..()
	on_emag(src, user, emag_card)

/obj/item/mod/module/dna_lock/proc/dna_check(mob/user)
	if(!iscarbon(user))
		return FALSE
	var/mob/living/carbon/carbon_user = user
	if(!dna  || (carbon_user.has_dna() && carbon_user.dna.unique_enzymes == dna))
		return TRUE
	balloon_alert(user, "dna locked!")
	return FALSE

/obj/item/mod/module/dna_lock/proc/on_emp(datum/source, severity)
	SIGNAL_HANDLER

	dna = null

/obj/item/mod/module/dna_lock/proc/on_emag(datum/source, mob/user, obj/item/card/emag/emag_card)
	SIGNAL_HANDLER

	dna = null

/obj/item/mod/module/dna_lock/proc/on_mod_activation(datum/source, mob/user)
	SIGNAL_HANDLER

	if(!dna_check(user))
		return MOD_CANCEL_ACTIVATE

/obj/item/mod/module/dna_lock/proc/on_mod_removal(datum/source, mob/user)
	SIGNAL_HANDLER

	if(!dna_check(user))
		return MOD_CANCEL_REMOVAL

///Sign Language Translator - I want, but no
