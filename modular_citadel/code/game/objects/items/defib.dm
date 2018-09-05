/obj/item/defibrillator
	var/healdisk = FALSE // Will we shock people dragging the body?
	var/pullshocksafely = FALSE //Dose the unit have the healdisk upgrade?
	var/fastasfuck = 0 // is the defib faster
	var/snowflake = 10

/obj/item/twohanded/shockpaddles/shock_touching(dmg, mob/H)
	if(defib.pullshocksafely && isliving(H.pulledby))
		H.visible_message("<span class='danger'>The defibrillator safely discharges the excessive charge into the floor!</span>")
		return
	..()

/obj/item/defibrillator/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/disk/medical/defib_heal))
		if(healdisk)
			to_chat(user, "<span class='notice'>This unit is already upgraded with this disk!</span>")
			return TRUE
		to_chat(user, "<span class='notice'>You upgrade the unit with Heal upgrade disk!</span>")
		healdisk = TRUE
		return TRUE
	if(istype(I, /obj/item/disk/medical/defib_shock))
		if(pullshocksafely)
			to_chat(user, "<span class='notice'>This unit is already upgraded with this disk!</span>")
			return TRUE
		to_chat(user, "<span class='notice'>You upgrade the unit with Shock Safety upgrade disk!</span>")
		pullshocksafely = TRUE
		return TRUE
	if(istype(I, /obj/item/disk/medical/defib_speed))
		if(!fastasfuck == initial(fastasfuck))
			to_chat(user, "<span class='notice'>This unit is already upgraded with this disk!</span>")
			return TRUE
		to_chat(user, "<span class='notice'>You upgrade the unit with Speed upgrade disk!</span>")
		fastasfuck = 10
		return TRUE
	if(istype(I, /obj/item/disk/medical/defib_decay))
		if(!snowflake == initial(snowflake))
			to_chat(user, "<span class='notice'>This unit is already upgraded with this disk!</span>")
			return TRUE
		to_chat(user, "<span class='notice'>You upgrade the unit with Longer Decay upgrade disk!</span>")
		snowflake = 20
		return TRUE
	return ..()