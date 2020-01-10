/obj/item/ammo_box/magazine/recharge
	name = "power pack"
	desc = "A rechargeable, detachable battery that serves as a magazine for laser rifles. This one fires lethal laser based shots."
	icon_state = "oldrifle-20"
	ammo_type = /obj/item/ammo_casing/caseless/laser
	caliber = "laser"
	max_ammo = 20

/obj/item/ammo_box/magazine/recharge/heavy
	name = "heavy power pack"
	desc = "A rechargeable, detachable battery that serves as a magazine for laser rifles. This one fires heavy shots, very lethal."
	icon_state = "oldrifle-20"
	ammo_type = /obj/item/ammo_casing/caseless/laser/heavy

/obj/item/ammo_box/magazine/recharge/weak
	name = "weak power pack"
	desc = "A rechargeable, detachable battery that serves as a magazine for laser rifles. This one fires weaker shots, but still is lethal."
	icon_state = "oldrifle-20"
	ammo_type = /obj/item/ammo_casing/caseless/laser/weak

/obj/item/ammo_box/magazine/recharge/weak/ap
	name = "weak penetrator power pack"
	desc = "A rechargeable, detachable battery that serves as a magazine for laser rifles. This one fires weaker penetrator shots, but still is lethal."
	icon_state = "oldrifle-20"
	ammo_type = /obj/item/ammo_casing/caseless/laser/weak/ap

/obj/item/ammo_box/magazine/recharge/disabler
	name = "disabler power pack"
	desc = "A rechargeable, detachable battery that serves as a magazine for laser rifles. This one fires disabling bolts"
	icon_state = "oldrifle-20"
	ammo_type = /obj/item/ammo_casing/caseless/laser/disabler

/obj/item/ammo_box/magazine/recharge/disabler/weak
	name = "weak disabler power pack"
	desc = "A rechargeable, detachable battery that serves as a magazine for laser rifles. This one fires weak disabling bolts"
	icon_state = "oldrifle-20"
	ammo_type = /obj/item/ammo_casing/caseless/laser/disabler/weak

/obj/item/ammo_box/magazine/recharge/pulse
	name = "pulse power pack"
	desc = "A rechargeable, detachable battery that serves as a magazine for laser rifles. This one one fires pulse based laser shots."
	icon_state = "oldrifle-20"
	ammo_type = /obj/item/ammo_casing/caseless/laser/pulse

/obj/item/ammo_box/magazine/recharge/xray
	name = "xray power pack"
	desc = "A rechargeable, detachable battery that serves as a magazine for laser rifles. This one one fires xray based laser shots."
	icon_state = "oldrifle-20"
	ammo_type = /obj/item/ammo_casing/caseless/laser/xray

/obj/item/ammo_box/magazine/recharge/update_icon()
	desc = "[initial(desc)] It has [stored_ammo.len] shot\s left."
	icon_state = "oldrifle-[round(ammo_count(),4)]"

/obj/item/ammo_box/magazine/recharge/attack_self() //No popping out the "bullets"
	return

/obj/item/ammo_box/magazine/recharge/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	else
		max_ammo = 0
		stored_ammo = 0
		update_icon()
		name = "fried power pack"
		desc = "A once rechargeable, detachable cell, now fryed and useless. It has 0 shots left."
		return