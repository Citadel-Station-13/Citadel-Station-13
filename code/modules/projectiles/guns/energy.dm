/obj/item/weapon/gun/energy
	icon_state = "energy"
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon = 'icons/obj/guns/energy.dmi'

	var/obj/item/weapon/stock_parts/cell/power_supply //What type of power cell this uses
	var/cell_type = /obj/item/weapon/stock_parts/cell
	var/modifystate = 0
	var/list/ammo_type = list(/obj/item/ammo_casing/energy)
	var/select = 1 //The state of the select fire switch. Determines from the ammo_type list what kind of shot is fired next.
	var/can_charge = 1 //Can it be charged in a recharger?
	var/charge_sections = 4
	ammo_x_offset = 2
	var/shaded_charge = 0 //if this gun uses a stateful charge bar for more detail
	var/selfcharge = 0
	var/charge_tick = 0
	var/charge_delay = 4

/obj/item/weapon/gun/energy/emp_act(severity)
	power_supply.use(round(power_supply.charge / severity))
	update_icon()


/obj/item/weapon/gun/energy/New()
	..()
	if(cell_type)
		power_supply = new cell_type(src)
	else
		power_supply = new(src)
	power_supply.give(power_supply.maxcharge)
	var/obj/item/ammo_casing/energy/shot
	for (var/i = 1, i <= ammo_type.len, i++)
		var/shottype = ammo_type[i]
		shot = new shottype(src)
		ammo_type[i] = shot
	shot = ammo_type[select]
	fire_sound = shot.fire_sound
	fire_delay = shot.delay
	if(selfcharge)
		START_PROCESSING(SSobj, src)
	update_icon()
	return

/obj/item/weapon/gun/energy/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/weapon/gun/energy/process()
	if(selfcharge)
		charge_tick++
		if(charge_tick < charge_delay)
			return
		charge_tick = 0
		if(!power_supply)
			return
		power_supply.give(100)
		update_icon()

/obj/item/weapon/gun/energy/attack_self(mob/living/user as mob)
	if(ammo_type.len > 1)
		select_fire(user)
		update_icon()

/obj/item/weapon/gun/energy/afterattack(atom/target as mob|obj|turf, mob/living/user as mob|obj, params)
	newshot() //prepare a new shot
	..()

/obj/item/weapon/gun/energy/can_shoot()
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	return power_supply.charge >= shot.e_cost

/obj/item/weapon/gun/energy/newshot()
	if (!ammo_type || !power_supply)
		return
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	if(power_supply.charge >= shot.e_cost) //if there's enough power in the power_supply cell...
		chambered = shot //...prepare a new shot based on the current ammo type selected
		chambered.newshot()
	return

/obj/item/weapon/gun/energy/process_chamber()
	if(chambered && !chambered.BB) //if BB is null, i.e the shot has been fired...
		var/obj/item/ammo_casing/energy/shot = chambered
		power_supply.use(shot.e_cost)//... drain the power_supply cell
	chambered = null //either way, released the prepared shot
	return

/obj/item/weapon/gun/energy/proc/select_fire(mob/living/user)
	select++
	if (select > ammo_type.len)
		select = 1
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	fire_sound = shot.fire_sound
	fire_delay = shot.delay
	if (shot.select_name)
		user << "<span class='notice'>[src] is now set to [shot.select_name].</span>"
	update_icon()
	return

/obj/item/weapon/gun/energy/update_icon()
	cut_overlays()
	var/ratio = Ceiling((power_supply.charge / power_supply.maxcharge) * charge_sections)
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	var/iconState = "[icon_state]_charge"
	var/itemState = null
	if(!initial(item_state))
		itemState = icon_state
	if (modifystate)
		add_overlay("[icon_state]_[shot.select_name]")
		iconState += "_[shot.select_name]"
		if(itemState)
			itemState += "[shot.select_name]"
	if(power_supply.charge < shot.e_cost)
		add_overlay("[icon_state]_empty")
	else
		if(!shaded_charge)
			for(var/i = ratio, i >= 1, i--)
				add_overlay(image(icon = icon, icon_state = iconState, pixel_x = ammo_x_offset * (i -1)))
		else
			add_overlay(image(icon = icon, icon_state = "[icon_state]_charge[ratio]"))
	if(F && can_flashlight)
		var/iconF = "flight"
		if(F.on)
			iconF = "flight_on"
		add_overlay(image(icon = icon, icon_state = iconF, pixel_x = flight_x_offset, pixel_y = flight_y_offset))
	if(itemState)
		itemState += "[ratio]"
		item_state = itemState

/obj/item/weapon/gun/energy/ui_action_click()
	toggle_gunlight()

/obj/item/weapon/gun/energy/suicide_act(mob/user)
	if (src.can_shoot())
		user.visible_message("<span class='suicide'>[user] is putting the barrel of the [src.name] in \his mouth.  It looks like \he's trying to commit suicide.</span>")
		sleep(25)
		if(user.l_hand == src || user.r_hand == src)
			user.visible_message("<span class='suicide'>[user] melts \his face off with the [src.name]!</span>")
			playsound(loc, fire_sound, 50, 1, -1)
			var/obj/item/ammo_casing/energy/shot = ammo_type[select]
			power_supply.use(shot.e_cost)
			update_icon()
			return(FIRELOSS)
		else
			user.visible_message("<span class='suicide'>[user] panics and starts choking to death!</span>")
			return(OXYLOSS)
	else
		user.visible_message("<span class='suicide'>[user] is pretending to blow \his brains out with the [src.name]! It looks like \he's trying to commit suicide!</b></span>")
		playsound(loc, 'sound/weapons/empty.ogg', 50, 1, -1)
		return (OXYLOSS)

/obj/item/weapon/gun/energy/proc/robocharge()
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		if(R && R.cell)
			var/obj/item/ammo_casing/energy/shot = ammo_type[select] //Necessary to find cost of shot
			if(R.cell.use(shot.e_cost)) 		//Take power from the borg...
				power_supply.give(shot.e_cost)	//... to recharge the shot

/obj/item/weapon/gun/energy/on_varedit(modified_var)
	if(modified_var == "selfcharge")
		if(selfcharge)
			START_PROCESSING(SSobj, src)
		else
			STOP_PROCESSING(SSobj, src)
	..()

/obj/item/weapon/gun/energy/burn()
	if(power_supply)
		qdel(power_supply)
	.=..()
