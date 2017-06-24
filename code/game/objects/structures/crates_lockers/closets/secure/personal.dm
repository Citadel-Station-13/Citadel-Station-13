/obj/structure/closet/secure_closet/personal
	desc = "It's a secure locker for personnel. The first card swiped gains control."
	name = "personal closet"
	req_access = list(GLOB.access_all_personal_lockers)
	var/registered_name = null

/obj/structure/closet/secure_closet/personal/PopulateContents()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/duffelbag(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack(src)
	else
		new /obj/item/weapon/storage/backpack/satchel(src)
	new /obj/item/device/radio/headset( src )

/obj/structure/closet/secure_closet/personal/patient
	name = "patient's closet"

/obj/structure/closet/secure_closet/personal/patient/PopulateContents()
	new /obj/item/clothing/under/color/white( src )
	new /obj/item/clothing/shoes/sneakers/white( src )

/obj/structure/closet/secure_closet/personal/cabinet
	icon_state = "cabinet"
	resistance_flags = FLAMMABLE
	obj_integrity = 70
	max_integrity = 70

/obj/structure/closet/secure_closet/personal/cabinet/PopulateContents()
	new /obj/item/weapon/storage/backpack/satchel/leather/withwallet( src )
	new /obj/item/device/radio/headset( src )

/obj/structure/closet/secure_closet/personal/attackby(obj/item/W, mob/user, params)
	var/obj/item/weapon/card/id/I = W.GetID()
	if(istype(I))
		if(broken)
			to_chat(user, "<span class='danger'>It appears to be broken.</span>")
			return
		if(!I || !I.registered_name)
			return
		if(allowed(user) || !registered_name || (istype(I) && (registered_name == I.registered_name)))
			//they can open all lockers, or nobody owns this, or they own this locker
			locked = !locked
			update_icon()

			if(!registered_name)
				registered_name = I.registered_name
				desc = "Owned by [I.registered_name]."
		else
			to_chat(user, "<span class='danger'>Access Denied.</span>")
	else
		return ..()

/obj/structure/closet/secure_closet/personal/proc/reset_lock(usr)
	if (opened && !broken)
		registered_name = null
		desc = initial(desc)
		to_chat(usr,"<span class='danger'>The lock has been reset.")
	else if(!opened)
		to_chat(usr,"<span class='danger'>The locker must be open!")
	else if(broken)
		to_chat(usr,"<span class='danger'>The lock is broken!")

/obj/structure/closet/secure_closet/personal/verb/verb_resetlock()
	set src in oview(1)
	set category = "Object"
	set name = "Reset Lock"

	if(!usr.canmove || usr.stat || usr.restrained())
		return

	if(iscarbon(usr) || issilicon(usr) || isdrone(usr))
		reset_lock(usr)
	else
		to_chat(usr, "<span class='warning'>This mob type can't use this verb.</span>")

