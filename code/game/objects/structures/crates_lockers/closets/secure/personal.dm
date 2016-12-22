/obj/structure/closet/secure_closet/personal
	desc = "It's a secure locker for personnel. The first card swiped gains control."
	name = "personal closet"
	req_access = list(access_all_personal_lockers)
	var/registered_name = null

/obj/structure/closet/secure_closet/personal/New()
	..()
	if(prob(50))
		new /obj/item/weapon/storage/backpack/dufflebag(src)
	if(prob(50))
		new /obj/item/weapon/storage/backpack(src)
	else
		new /obj/item/weapon/storage/backpack/satchel_norm(src)
	new /obj/item/device/radio/headset( src )

/obj/structure/closet/secure_closet/personal/patient
	name = "patient's closet"

/obj/structure/closet/secure_closet/personal/patient/New()
	..()
	contents.Cut()
	new /obj/item/clothing/under/color/white( src )
	new /obj/item/clothing/shoes/sneakers/white( src )

/obj/structure/closet/secure_closet/personal/cabinet
	icon_state = "cabinet"
	burn_state = FLAMMABLE
	burntime = 20

/obj/structure/closet/secure_closet/personal/cabinet/New()
	..()
	contents = list()
	new /obj/item/weapon/storage/backpack/satchel/withwallet( src )
	new /obj/item/device/radio/headset( src )

/obj/structure/closet/secure_closet/personal/attackby(obj/item/W, mob/user, params)
	var/obj/item/weapon/card/id/I = W.GetID()
	if(istype(I))
		if(broken)
			user << "<span class='danger'>It appears to be broken.</span>"
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
			user << "<span class='danger'>Access Denied.</span>"
	else
		return ..()

/obj/structure/closet/secure_closet/personal/verb/verb_resetlock()//personal locker ownership reset.
	set src in oview(1)
	set category = "Object"
	set name = "Reset Lock"

	if(opened)
		if(broken)
			usr << "<span class='danger'>The lock appears to be broken.</span>"
			return
		else
			registered_name = null
			usr << "<span class='danger'>You successfully reset the lock.</span>"
			desc = initial(desc)
			add_fingerprint(usr)
	else
		usr << "<span class='danger'>\the [src.name] must be open!</span>"
