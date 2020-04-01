/obj/item/clothing/gloves/color/yellow
	desc = "These gloves will protect the wearer from electric shock."
	name = "insulated gloves"
	icon_state = "yellow"
	item_state = "ygloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	item_color="yellow"
	resistance_flags = NONE
	var/can_be_cut = 1

/obj/item/clothing/gloves/color/fyellow                             //Cheap Chinese Crap
	desc = "These gloves are cheap knockoffs of the coveted ones - no way this can end badly."
	name = "budget insulated gloves"
	icon_state = "yellow"
	item_state = "ygloves"
	siemens_coefficient = 1			//Set to a default of 1, gets overridden in New()
	permeability_coefficient = 0.05
	item_color="yellow"
	resistance_flags = NONE
	var/can_be_cut = 1

/obj/item/clothing/gloves/color/fyellow/New()
	..()
	siemens_coefficient = pick(0,0.5,0.5,0.5,0.5,0.75,1.5)

/obj/item/clothing/gloves/color/fyellow/old
	desc = "Old and worn out insulated gloves, hopefully they still work."
	name = "worn out insulated gloves"

/obj/item/clothing/gloves/color/fyellow/old/Initialize()
	. = ..()
	siemens_coefficient = pick(0,0,0,0.5,0.5,0.5,0.75)

/obj/item/clothing/gloves/cut
	desc = "These gloves would protect the wearer from electric shock.. if the fingers were covered."
	name = "fingerless insulated gloves"
	icon_state = "yellowcut"
	item_state = "yglovescut"
	siemens_coefficient = 1
	permeability_coefficient = 1
	resistance_flags = NONE
	transfer_prints = TRUE
	strip_mod = 0.8

/obj/item/clothing/gloves/cut/family
	desc = "The old gloves your great grandfather stole from Engineering, many moons ago. They've seen some tough times recently."
	name = "fingerless insulated gloves"

/obj/item/clothing/gloves/color/yellow/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/wirecutters))
		if(can_be_cut && icon_state == initial(icon_state))//only if not dyed
			to_chat(user, "<span class='notice'>You snip the fingertips off of [src].</span>")
			I.play_tool_sound(src)
			new /obj/item/clothing/gloves/cut(drop_location())
			qdel(src)
	..()

/obj/item/clothing/gloves/color/fyellow/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/wirecutters))
		if(can_be_cut && icon_state == initial(icon_state))//only if not dyed
			to_chat(user, "<span class='notice'>You snip the fingertips off of [src].</span>")
			I.play_tool_sound(src)
			new /obj/item/clothing/gloves/cut(drop_location())
			qdel(src)
	..()

/obj/item/clothing/gloves/color/black
	desc = "These gloves are fire-resistant."
	name = "black gloves"
	icon_state = "black"
	item_state = "blackgloves"
	item_color="black"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	var/can_be_cut = 1
	strip_mod = 1.2

/obj/item/clothing/gloves/color/black/hos
	item_color = "hosred"	//Exists for washing machines. Is not different from black gloves in any way.

/obj/item/clothing/gloves/color/black/ce
	item_color = "chief"		//Exists for washing machines. Is not different from black gloves in any way.

/obj/item/clothing/gloves/color/black/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/wirecutters))
		if(can_be_cut && icon_state == initial(icon_state))//only if not dyed
			to_chat(user, "<span class='notice'>You snip the fingertips off of [src].</span>")
			I.play_tool_sound(src)
			new /obj/item/clothing/gloves/fingerless(drop_location())
			qdel(src)
	..()

/obj/item/clothing/gloves/color/orange
	name = "orange gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "orange"
	item_state = "orangegloves"
	item_color="orange"

/obj/item/clothing/gloves/color/red
	name = "red gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "red"
	item_state = "redgloves"
	item_color = "red"


/obj/item/clothing/gloves/color/red/insulated
	name = "insulated gloves"
	desc = "These gloves will protect the wearer from electric shock."
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	resistance_flags = NONE

/obj/item/clothing/gloves/color/rainbow
	name = "rainbow gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "rainbow"
	item_state = "rainbowgloves"
	item_color = "rainbow"

/obj/item/clothing/gloves/color/rainbow/clown
	item_color = "clown"

/obj/item/clothing/gloves/color/blue
	name = "blue gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "blue"
	item_state = "bluegloves"
	item_color="blue"

/obj/item/clothing/gloves/color/purple
	name = "purple gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "purple"
	item_state = "purplegloves"
	item_color="purple"

/obj/item/clothing/gloves/color/green
	name = "green gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "green"
	item_state = "greengloves"
	item_color="green"

/obj/item/clothing/gloves/color/grey
	name = "grey gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "gray"
	item_state = "graygloves"
	item_color="grey"

/obj/item/clothing/gloves/color/grey/rd
	item_color = "director"			//Exists for washing machines. Is not different from gray gloves in any way.

/obj/item/clothing/gloves/color/grey/hop
	item_color = "hop"				//Exists for washing machines. Is not different from gray gloves in any way.

/obj/item/clothing/gloves/color/light_brown
	name = "light brown gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "lightbrown"
	item_state = "lightbrowngloves"
	item_color="light brown"

/obj/item/clothing/gloves/color/brown
	name = "brown gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "brown"
	item_state = "browngloves"
	item_color="brown"

/obj/item/clothing/gloves/color/brown/cargo
	item_color = "cargo"					//Exists for washing machines. Is not different from brown gloves in any way.

/obj/item/clothing/gloves/color/captain
	desc = "Regal blue gloves, with a nice gold trim, a diamond anti-shock coating, and an integrated thermal barrier. Swanky."
	name = "captain's gloves"
	icon_state = "captain"
	item_state = "egloves"
	item_color = "captain"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	strip_delay = 60
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0, "energy" = 0, "bomb" = 0, "bio" = 0, "rad" = 0, "fire" = 70, "acid" = 50)

/obj/item/clothing/gloves/color/latex
	name = "latex gloves"
	desc = "Cheap sterile gloves made from latex. Transfers basic paramedical knowledge to the wearer via the use of nanochips."
	icon_state = "latex"
	item_state = "lgloves"
	siemens_coefficient = 0.3
	permeability_coefficient = 0.01
	item_color="mime"
	transfer_prints = TRUE
	resistance_flags = NONE
	var/carrytrait = TRAIT_QUICK_CARRY

/obj/item/clothing/gloves/color/latex/equipped(mob/user, slot)
	..()
	if(slot == SLOT_GLOVES)
		ADD_TRAIT(user, carrytrait, CLOTHING_TRAIT)

/obj/item/clothing/gloves/color/latex/dropped(mob/user)
	..()
	REMOVE_TRAIT(user, carrytrait, CLOTHING_TRAIT)

/obj/item/clothing/gloves/color/latex/nitrile
	name = "nitrile gloves"
	desc = "Pricy sterile gloves that are stronger than latex. Transfers advanced paramedical knowledge to the wearer via the use of nanochips."
	icon_state = "nitrile"
	item_state = "nitrilegloves"
	item_color = "cmo"
	transfer_prints = FALSE
	carrytrait = TRAIT_QUICKER_CARRY

/obj/item/clothing/gloves/color/latex/nitrile/infiltrator
	name = "insidious combat gloves"
	desc = "Specialized combat gloves for carrying people around. Transfers tactical kidnapping knowledge to the user via the use of nanochips."
	icon_state = "infiltrator"
	item_state = "infiltrator"
	siemens_coefficient = 0
	permeability_coefficient = 0.3
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/gloves/color/white
	name = "white gloves"
	desc = "These look pretty fancy."
	icon_state = "white"
	item_state = "wgloves"
	item_color="white"

/obj/item/clothing/gloves/color/white/redcoat
	item_color = "redcoat"		//Exists for washing machines. Is not different from white gloves in any way.
