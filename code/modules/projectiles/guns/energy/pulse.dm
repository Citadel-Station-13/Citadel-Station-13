/obj/item/weapon/gun/energy/pulse
	name = "pulse rifle"
	desc = "A heavy-duty, multifaceted energy rifle with three modes. Preferred by front-line combat personnel."
	icon_state = "pulse"
	item_state = null
	w_class = 4
	force = 10
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	ammo_type = list(/obj/item/ammo_casing/energy/laser/pulse, /obj/item/ammo_casing/energy/electrode, /obj/item/ammo_casing/energy/laser)
	cell_type = "/obj/item/weapon/stock_parts/cell/pulse"

/obj/item/weapon/gun/energy/pulse/emp_act(severity)
	return

/obj/item/weapon/gun/energy/pulse/prize
	pin = /obj/item/device/firing_pin

/obj/item/weapon/gun/energy/pulse/prize/New()
	. = ..()
	poi_list |= src
	var/msg = "A pulse rifle prize has been created at ([x],[y],[z] - (\
	<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>\
	JMP</a>)"

	message_admins(msg)
	log_game(msg)

	notify_ghosts("Someone won a pulse rifle as a prize!", source = src,
		action = NOTIFY_ORBIT)

/obj/item/weapon/gun/energy/pulse/prize/Destroy()
	poi_list -= src
	. = ..()

/obj/item/weapon/gun/energy/pulse/loyalpin
	pin = /obj/item/device/firing_pin/implant/mindshield

/obj/item/weapon/gun/energy/pulse/carbine
	name = "pulse carbine"
	desc = "A compact variant of the pulse rifle with less firepower but easier storage."
	w_class = 3
	slot_flags = SLOT_BELT
	icon_state = "pulse_carbine"
	item_state = "pulse"
	cell_type = "/obj/item/weapon/stock_parts/cell/pulse/carbine"
	can_flashlight = 1
	flight_x_offset = 18
	flight_y_offset = 12

/obj/item/weapon/gun/energy/pulse/carbine/loyalpin
	pin = /obj/item/device/firing_pin/implant/mindshield

/obj/item/weapon/gun/energy/pulse/pistol
	name = "pulse pistol"
	desc = "A pulse rifle in an easily concealed handgun package with low capacity."
	w_class = 2
	slot_flags = SLOT_BELT
	icon_state = "pulse_pistol"
	item_state = "gun"
	cell_type = "/obj/item/weapon/stock_parts/cell/pulse/pistol"
	can_charge = 0

/obj/item/weapon/gun/energy/pulse/pistol/loyalpin
	pin = /obj/item/device/firing_pin/implant/mindshield

/obj/item/weapon/gun/energy/pulse/destroyer
	name = "pulse destroyer"
	desc = "A heavy-duty energy rifle built for pure destruction."
	cell_type = "/obj/item/weapon/stock_parts/cell/infinite"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/pulse)

/obj/item/weapon/gun/energy/pulse/destroyer/attack_self(mob/living/user)
	user << "<span class='danger'>[src.name] has three settings, and they are all DESTROY.</span>"

/obj/item/weapon/gun/energy/pulse/pistol/m1911
	name = "\improper M1911-P"
	desc = "A compact pulse core in a classic handgun frame for Nanotrasen officers. It's not the size of the gun, it's the size of the hole it puts through people."
	icon_state = "m1911"
	item_state = "gun"
	cell_type = "/obj/item/weapon/stock_parts/cell/infinite"
