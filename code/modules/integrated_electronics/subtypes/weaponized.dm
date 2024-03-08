/obj/item/integrated_circuit/weaponized
	category_text = "Weaponized"

/obj/item/integrated_circuit/weaponized/weapon_firing
	name = "weapon firing mechanism"
	desc = "This somewhat complicated system allows one to slot in a gun, direct it towards a position, and remotely fire it."
	extended_desc = "The firing mechanism can slot in any energy weapon. \
	The first and second inputs need to be numbers which correspond to coordinates for the gun to fire at relative to the machine itself. \
	The 'fire' activator will cause the mechanism to attempt to fire the weapon at the coordinates, if possible. Mode will switch between \
	lethal (TRUE) or stun (FALSE) modes. It uses the internal battery of the weapon itself, not the assembly. If you wish to fire the gun while the circuit is in \
	hand, you will need to use an assembly that is a gun."
	complexity = 20
	w_class = WEIGHT_CLASS_SMALL
	size = 3
	inputs = list(
		"target X rel" = IC_PINTYPE_NUMBER,
		"target Y rel" = IC_PINTYPE_NUMBER,
		"mode"         = IC_PINTYPE_BOOLEAN
		)
	outputs = list("reference to gun" = IC_PINTYPE_REF)
	activators = list(
		"fire" = IC_PINTYPE_PULSE_IN

	)
	var/obj/item/gun/energy/installed_gun = null
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_COMBAT
	power_draw_per_use = 0
	ext_cooldown = 1
	var/mode = FALSE

	var/stun_projectile = null		//stun mode projectile type
	var/stun_projectile_sound
	var/lethal_projectile = null	//lethal mode projectile type
	var/lethal_projectile_sound

	demands_object_input = TRUE		// You can put stuff in once the circuit is in assembly,passed down from additem and handled by attackby()



/obj/item/integrated_circuit/weaponized/weapon_firing/Destroy()
	qdel(installed_gun)
	return ..()

/obj/item/integrated_circuit/weaponized/weapon_firing/attackby(var/obj/O, var/mob/user)
	if(istype(O, /obj/item/gun/energy))
		var/obj/item/gun/gun = O
		if(!gun.can_circuit)
			to_chat(user, "<span class='warning'>[gun] does not fit into circuits.</span>")
			return
		if(installed_gun)
			to_chat(user, "<span class='warning'>There's already a weapon installed.</span>")
			return
		user.transferItemToLoc(gun,src)
		installed_gun = gun
		var/list/gun_properties = gun.get_turret_properties()
		to_chat(user, "<span class='notice'>You slide \the [gun] into the firing mechanism.</span>")
		playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
		stun_projectile = gun_properties["stun_projectile"]
		stun_projectile_sound = gun_properties["stun_projectile_sound"]
		lethal_projectile = gun_properties["lethal_projectile"]
		lethal_projectile_sound = gun_properties["lethal_projectile_sound"]
		if(gun_properties["shot_delay"])
			cooldown_per_use = gun_properties["shot_delay"]*10
		if(cooldown_per_use<30)
			cooldown_per_use = 30
		if(gun_properties["reqpower"])
			power_draw_per_use = gun_properties["reqpower"]
		set_pin_data(IC_OUTPUT, 1, WEAKREF(installed_gun))
		push_data()
	else
		..()

/obj/item/integrated_circuit/weaponized/weapon_firing/attack_self(var/mob/user)
	if(installed_gun)
		installed_gun.forceMove(drop_location())
		to_chat(user, "<span class='notice'>You slide \the [installed_gun] out of the firing mechanism.</span>")
		size = initial(size)
		playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
		installed_gun = null
		set_pin_data(IC_OUTPUT, 1, WEAKREF(null))
		push_data()
	else
		to_chat(user, "<span class='notice'>There's no weapon to remove from the mechanism.</span>")

/obj/item/integrated_circuit/weaponized/weapon_firing/do_work()
	if(!assembly || !installed_gun || !installed_gun.can_shoot())
		return
	if(isliving(assembly.loc))
		var/mob/living/L = assembly.loc
		if(!assembly.can_fire_equipped || !L.is_holding(assembly) || !installed_gun.can_trigger_gun(L)) //includes pins, hulk and other chunky fingers checks.
			return
	else if(!isturf(assembly.loc) || !installed_gun.handle_pins())
		return
	set_pin_data(IC_OUTPUT, 1, WEAKREF(installed_gun))
	push_data()
	var/datum/integrated_io/xo = inputs[1]
	var/datum/integrated_io/yo = inputs[2]
	var/datum/integrated_io/mode1 = inputs[3]

	mode = mode1.data
	if(isnum(xo.data))
		xo.data = round(xo.data, 1)
	if(isnum(yo.data))
		yo.data = round(yo.data, 1)

	var/turf/T = get_turf(assembly)
	var/target_x = clamp(T.x + xo.data, 0, world.maxx)
	var/target_y = clamp(T.y + yo.data, 0, world.maxy)

	assembly.visible_message("<span class='danger'>[assembly] fires [installed_gun]!</span>")
	shootAt(locate(target_x, target_y, T.z))

/obj/item/integrated_circuit/weaponized/weapon_firing/proc/shootAt(turf/target)
	var/turf/T = get_turf(src)
	var/turf/U = target
	if(!istype(T) || !istype(U))
		return
	if(!installed_gun.cell)
		return
	if(!installed_gun.cell.charge)
		return
	var/obj/item/ammo_casing/energy/shot = installed_gun.ammo_type[mode?2:1]
	if(installed_gun.cell.charge < shot.e_cost)
		return
	if(!shot)
		return
	update_icon()
	var/obj/item/projectile/A
	if(!mode)
		A = new stun_projectile(T)
		playsound(loc, stun_projectile_sound, 75, 1)
	else
		A = new lethal_projectile(T)
		playsound(loc, lethal_projectile_sound, 75, 1)
	installed_gun.cell.use(shot.e_cost)
	//Shooting Code:
	A.preparePixelProjectile(target, src)
	A.fire()
	if(ismob(loc.loc))
		installed_gun.shoot_live_shot(loc.loc)
	else
		installed_gun.shoot_live_shot() //Shitcode, but we don't have much of a choice
	log_attack("[assembly] [REF(assembly)] has fired [installed_gun].")
	return A

/obj/item/integrated_circuit/weaponized/grenade
	name = "grenade primer"
	desc = "This circuit comes with the ability to attach most types of grenades and prime them at will."
	extended_desc = "The time between priming and detonation is limited to between 1 to 12 seconds, but is optional. \
					If the input is not set, not a number, or a number less than 1, the grenade's built-in timing will be used. \
					Beware: Once primed, there is no aborting the process!"
	icon_state = "grenade"
	complexity = 30
	cooldown_per_use = 10
	inputs = list("detonation time" = IC_PINTYPE_NUMBER)
	outputs = list()
	activators = list("prime grenade" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_COMBAT
	var/obj/item/grenade/attached_grenade
	var/pre_attached_grenade_type
	demands_object_input = TRUE	// You can put stuff in once the circuit is in assembly,passed down from additem and handled by attackby()

/obj/item/integrated_circuit/weaponized/grenade/Initialize(mapload)
	. = ..()
	if(pre_attached_grenade_type)
		var/grenade = new pre_attached_grenade_type(src)
		attach_grenade(grenade)

/obj/item/integrated_circuit/weaponized/grenade/Destroy()
	if(attached_grenade && !attached_grenade.active)
		attached_grenade.forceMove(loc)
	detach_grenade()
	return ..()

/obj/item/integrated_circuit/weaponized/grenade/attackby(var/obj/item/grenade/G, var/mob/user)
	if(istype(G))
		if(attached_grenade)
			to_chat(user, "<span class='warning'>There is already a grenade attached!</span>")
		else if(user.transferItemToLoc(G,src))
			user.visible_message("<span class='warning'>\The [user] attaches \a [G] to \the [src]!</span>", "<span class='notice'>You attach \the [G] to \the [src].</span>")
			attach_grenade(G)
			G.forceMove(src)
	else
		return ..()

/obj/item/integrated_circuit/weaponized/grenade/attack_self(var/mob/user)
	if(attached_grenade)
		user.visible_message("<span class='warning'>\The [user] removes \an [attached_grenade] from \the [src]!</span>", "<span class='notice'>You remove \the [attached_grenade] from \the [src].</span>")
		user.put_in_hands(attached_grenade)
		detach_grenade()
	else
		return ..()

/obj/item/integrated_circuit/weaponized/grenade/do_work()
	if(attached_grenade && !attached_grenade.active)
		var/datum/integrated_io/detonation_time = inputs[1]
		var/dt
		if(isnum(detonation_time.data) && detonation_time.data > 0)
			dt = clamp(detonation_time.data, 1, 12)*10
		else
			dt = 15
		addtimer(CALLBACK(attached_grenade, /obj/item/grenade.proc/prime), dt)
		var/atom/holder = loc
		message_admins("activated a grenade assembly. Last touches: Assembly: [holder.fingerprintslast] Circuit: [fingerprintslast] Grenade: [attached_grenade.fingerprintslast]")

// These procs do not relocate the grenade, that's the callers responsibility
/obj/item/integrated_circuit/weaponized/grenade/proc/attach_grenade(var/obj/item/grenade/G)
	attached_grenade = G
	G.forceMove(src)
	desc += " \An [attached_grenade] is attached to it!"

/obj/item/integrated_circuit/weaponized/grenade/proc/detach_grenade()
	if(!attached_grenade)
		return
	attached_grenade.forceMove(drop_location())
	attached_grenade = null
	desc = initial(desc)

/obj/item/integrated_circuit/weaponized/air_cannon
	name = "pneumatic cannon"
	desc = "A compact pneumatic cannon to throw things from inside or nearby tiles at a high enough velocity to cause damage. Requires air from a canister to fire."
	extended_desc = "The first and second inputs need to be numbers which correspond to the coordinates to throw objects at relative to the machine itself. \
	The 'fire' activator will cause the mechanism to attempt to launch objects at the coordinates, if possible. Note that the \
	projectile needs to be inside the machine, or on an adjacent tile, and must be medium sized or smaller. The assembly \
	must also be a gun if you wish to launch something while the assembly is in hand."
	complexity = 50
	w_class = WEIGHT_CLASS_SMALL
	size = 4
	cooldown_per_use = 30
	ext_cooldown = 15
	inputs = list(
		"target X rel" = IC_PINTYPE_NUMBER,
		"target Y rel" = IC_PINTYPE_NUMBER,
		"projectile" = IC_PINTYPE_REF,
		"canister" = IC_PINTYPE_REF
		)
	outputs = list()
	activators = list(
		"fire" = IC_PINTYPE_PULSE_IN
	)
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_COMBAT
	power_draw_per_use = 50
	var/gas_per_throw = 6

/obj/item/integrated_circuit/weaponized/air_cannon/do_work()

	var/max_w_class = assembly.w_class
	var/target_x_rel = round(get_pin_data(IC_INPUT, 1))
	var/target_y_rel = round(get_pin_data(IC_INPUT, 2))
	var/obj/item/A = get_pin_data_as_type(IC_INPUT, 3, /obj/item)
	var/obj/item/integrated_circuit/atmospherics/AT = get_pin_data_as_type(IC_INPUT, 4, /obj/item/integrated_circuit/atmospherics)

	if(!A || A.anchored || A.throwing || A == assembly || istype(A, /obj/item/transfer_valve) || A.GetComponent(/datum/component/two_handed))
		return

	var/obj/item/I = get_object()
	var/turf/T = get_turf(I)
	if(!T)
		return
	if(isliving(I.loc))
		var/mob/living/L = I.loc
		if(!I.can_trigger_gun(L)) //includes hulk and other chunky fingers checks.
			return
		if(HAS_TRAIT(L, TRAIT_PACIFISM) && A.throwforce)
			to_chat(L, "<span class='notice'> [I] is lethally chambered! You don't want to risk harming anyone...</span>")
			return
	else if(T != I.loc)
		return

	if(!AT || !AT.air_contents)
		return

	if(max_w_class && (A.w_class > max_w_class))
		return

	// Is the target inside the assembly or close to it?
	if(!check_target(A, exclude_components = TRUE))
		return

	// If the item is in mob's inventory, try to remove it from there.
	if(ismob(A.loc))
		var/mob/living/M = A.loc
		if(!M.temporarilyRemoveItemFromInventory(A))
			return

	var/datum/gas_mixture/source_air = AT.return_air()
	var/datum/gas_mixture/target_air = T.return_air()

	if(!source_air || !target_air)
		return

	source_air.transfer_to(target_air, gas_per_throw)

	// If the item is in a grabber circuit we'll update the grabber's outputs after we've thrown it.
	var/obj/item/integrated_circuit/manipulation/grabber/G = A.loc

	var/x_abs = clamp(T.x + target_x_rel, 0, world.maxx)
	var/y_abs = clamp(T.y + target_y_rel, 0, world.maxy)
	var/range = round(clamp(sqrt(target_x_rel*target_x_rel+target_y_rel*target_y_rel),0,8),1)
	playsound(src, 'sound/weapons/sonic_jackhammer.ogg', 50, 1)
	assembly.visible_message("<span class='danger'>\The [assembly] has thrown [A]!</span>")
	log_attack("[assembly] [REF(assembly)] has thrown [A] with lethal force.")
	A.forceMove(drop_location())
	A.throw_at(locate(x_abs, y_abs, T.z), range, 3)

	air_update_turf()

	// If the item came from a grabber now we can update the outputs since we've thrown it.
	if(istype(G))
		G.update_outputs()


/obj/item/integrated_circuit/weaponized/stun
	name = "electronic stun module"
	desc = "Used to stun a target holding the device via electricity."
	icon_state = "power_relay"
	extended_desc = "Attempts to stun the holder of this device, with the strength input being the strength of the stun, from 1 to 70."
	complexity = 30
	size = 4
	inputs = list("strength" = IC_PINTYPE_NUMBER)
	activators = list("stun" = IC_PINTYPE_PULSE_IN, "on success" = IC_PINTYPE_PULSE_OUT, "on fail" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 2000
	cooldown_per_use = 50
	ext_cooldown = 25


/obj/item/integrated_circuit/weaponized/stun/do_work()
	var/stunforce = clamp(get_pin_data(IC_INPUT, 1),1,70)
	var/mob/living/L = assembly.loc
	if(attempt_stun(L,stunforce))
		activate_pin(2)
	else
		activate_pin(3)

/obj/item/integrated_circuit/weaponized/proc/attempt_stun(var/mob/living/L,var/stunforce = 70) //Copied from stunbaton code.

	if(!L || !isliving(L))
		return FALSE

	L.DefaultCombatKnockdown(stunforce)
	SEND_SIGNAL(L, COMSIG_LIVING_MINOR_SHOCK)

	message_admins("stunned someone with an assembly. Last touches: Assembly: [assembly.fingerprintslast] Circuit: [fingerprintslast]")

	L.visible_message("<span class='danger'>\The [assembly] has stunned \the [L] with \the [src]!</span>", "<span class='userdanger'>\The [assembly] has stunned you with \the [src]!</span>")
	playsound(loc, 'sound/weapons/egloves.ogg', 50, 1, -1)
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.forcesay(GLOB.hit_appends)

	return TRUE
