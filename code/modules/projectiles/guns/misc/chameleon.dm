// this is all shitcode never ever add it to the game it's for debugging only.

/datum/action/item_action/chameleon/change/gun/update_look(mob/user, obj/item/picked_item)
	. = ..()
	var/obj/item/gun/energy/laser/chameleon/CG = target
	CG.get_chameleon_projectile(picked_item)

/obj/item/gun/energy/laser/chameleon
	name = "practice laser gun"
	desc = "A modified version of the basic laser gun, this one fires less concentrated energy bolts designed for target practice."
	ammo_type = list(/obj/item/ammo_casing/energy/chameleon)
	clumsy_check = 0
	item_flags = NONE
	pin = /obj/item/firing_pin
	cell_type = /obj/item/stock_parts/cell/bluespace

	var/datum/action/item_action/chameleon/change/gun/chameleon_action
	var/list/chameleon_projectile_vars
	var/list/chameleon_ammo_vars
	var/list/chameleon_gun_vars
	var/list/projectile_copy_vars
	var/list/ammo_copy_vars
	var/list/gun_copy_vars
	var/badmin_mode = FALSE
	var/can_hitscan = FALSE
	var/hitscan_mode = FALSE

/obj/item/gun/energy/laser/chameleon/Initialize()
	. = ..()
	chameleon_action = new(src)
	chameleon_action.chameleon_type = /obj/item/gun
	chameleon_action.chameleon_name = "Gun"
	chameleon_action.chameleon_blacklist = typecacheof(/obj/item/gun/magic, ignore_root_path = FALSE)
	chameleon_action.initialize_disguises()

	projectile_copy_vars = list("name", "icon", "icon_state", "item_state", "speed", "color", "hitsound", "forcedodge", "impact_effect_type", "range", "suppressed", "hitsound_wall", "impact_effect_type", "pass_flags", "tracer_type", "muzzle_type", "impact_type")
	chameleon_projectile_vars = list("name" = "practice laser", "icon" = 'icons/obj/projectiles.dmi', "icon_state" = "laser")
	gun_copy_vars = list("fire_sound", "burst_size", "fire_delay")
	chameleon_gun_vars = list()
	ammo_copy_vars = list("firing_effect_type")
	chameleon_ammo_vars = list()
	recharge_newshot()
	get_chameleon_projectile(/obj/item/gun/energy/laser)

/obj/item/gun/energy/laser/chameleon/emp_act(severity)
	return

/obj/item/gun/energy/laser/chameleon/proc/reset_chameleon_vars()
	chameleon_ammo_vars = list()
	chameleon_gun_vars = list()
	chameleon_projectile_vars = list()
	var/static/list/blacklisted_vars = list("locs", "loc", "contents", "x", "y", "z", "parent_type", "type", "vars")
	if(chambered)
		for(var/v in ammo_copy_vars)
			if(v in blacklisted_vars)	//Just in case admins go crazy.
				continue
			chambered.vv_edit_var(v, initial(chambered.vars[v]))
	for(var/v in gun_copy_vars)
		if(v in blacklisted_vars)
			continue
		vv_edit_var(v, initial(vars[v]))
		vars[v] = initial(vars[v])
	QDEL_NULL(chambered.BB)
	chambered.newshot()

/obj/item/gun/energy/laser/chameleon/proc/set_chameleon_ammo(obj/item/ammo_casing/AC, passthrough = TRUE, reset = FALSE)
	if(!istype(AC))
		CRASH("[AC] is not /obj/item/ammo_casing!")
	for(var/V in ammo_copy_vars)
		if(AC.vars.Find(V))
			chameleon_ammo_vars[V] = AC.vars[V]
			chambered?.vv_edit_var(V, AC.vars[V])
	if(passthrough)
		var/obj/item/projectile/P = AC.BB
		set_chameleon_projectile(P)

/obj/item/gun/energy/laser/chameleon/proc/set_chameleon_projectile(obj/item/projectile/P)
	if(!istype(P))
		CRASH("[P] is not /obj/item/projectile!")
	chameleon_projectile_vars = list("name" = "practice laser", "icon" = 'icons/obj/projectiles.dmi', "icon_state" = "laser", "nodamage" = TRUE)
	for(var/V in projectile_copy_vars)
		if(P.vars.Find(V))
			chameleon_projectile_vars[V] = P.vars[V]
	if(istype(chambered, /obj/item/ammo_casing/energy/chameleon))
		var/obj/item/ammo_casing/energy/chameleon/AC = chambered
		AC.projectile_vars = chameleon_projectile_vars.Copy()
	if(!P.tracer_type)
		can_hitscan = FALSE
		set_hitscan(FALSE)
	else
		can_hitscan = TRUE
	if(badmin_mode)
		qdel(chambered.BB)
		chambered.projectile_type = P.type
		chambered.newshot()

/obj/item/gun/energy/laser/chameleon/proc/set_chameleon_gun(obj/item/gun/G , passthrough = TRUE)
	if(!istype(G))
		CRASH("[G] is not /obj/item/gun!")
	for(var/V in gun_copy_vars)
		if(vars.Find(V) && G.vars.Find(V))
			chameleon_gun_vars[V] = G.vars[V]
			vv_edit_var(V, G.vars[V])
	if(passthrough)
		if(istype(G, /obj/item/gun/ballistic))
			var/obj/item/gun/ballistic/BG = G
			var/obj/item/ammo_box/AB = new BG.mag_type(G)
			qdel(BG)
			if(!istype(AB)||!AB.ammo_type)
				qdel(AB)
				return FALSE
			var/obj/item/ammo_casing/AC = new AB.ammo_type(G)
			set_chameleon_ammo(AC)
		else if(istype(G, /obj/item/gun/magic))
			var/obj/item/gun/magic/MG = G
			var/obj/item/ammo_casing/AC = new MG.ammo_type(G)
			set_chameleon_ammo(AC)
		else if(istype(G, /obj/item/gun/energy))
			var/obj/item/gun/energy/EG = G
			if(islist(EG.ammo_type) && EG.ammo_type.len)
				var/obj/item/ammo_casing/AC = EG.ammo_type[1]
				set_chameleon_ammo(AC)
		else if(istype(G, /obj/item/gun/syringe))
			var/obj/item/ammo_casing/AC = new /obj/item/ammo_casing/syringegun(src)
			set_chameleon_ammo(AC)

/obj/item/gun/energy/laser/chameleon/attack_self(mob/user)
	. = ..()
	if(!can_hitscan)
		to_chat(user, "<span class='warning'>[src]'s current disguised gun does not allow it to enable high velocity mode!</span>")
		return
	if(!chambered)
		to_chat(user, "<span class='warning'>Unknown error in energy lens: Please reset chameleon disguise and try again.</span>")
		return
	set_hitscan(!hitscan_mode)
	to_chat(user, "<span class='notice'>You toggle [src]'s high velocity beam mode to [hitscan_mode? "on" : "off"].</span>")

/obj/item/gun/energy/laser/chameleon/proc/set_hitscan(hitscan)
	var/obj/item/ammo_casing/energy/chameleon/AC = chambered
	AC.hitscan_mode = hitscan
	hitscan_mode = hitscan

/obj/item/gun/energy/laser/chameleon/proc/get_chameleon_projectile(guntype)
	reset_chameleon_vars()
	var/obj/item/gun/G = new guntype(src)
	set_chameleon_gun(G)
	qdel(G)

/obj/item/ammo_casing/energy/chameleon
	projectile_type = /obj/item/projectile/energy/chameleon
	e_cost = 0
	var/hitscan_mode = FALSE
	var/list/projectile_vars = list()

/obj/item/ammo_casing/energy/chameleon/ready_proj(atom/target, mob/living/user, quiet, zone_override = "")
	. = ..()
	if(!BB)
		newshot()
	for(var/V in projectile_vars)
		if(BB.vars.Find(V))
			BB.vv_edit_var(V, projectile_vars[V])
	if(hitscan_mode)
		BB.hitscan = TRUE

/obj/item/projectile/energy/chameleon
	nodamage = TRUE
