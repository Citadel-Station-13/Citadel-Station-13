/obj/item/gun/magic/wand/book
	name = "blank spellbook"
	desc = "It's not just a book, it's a SPELL book!"
	ammo_type = /obj/item/ammo_casing/magic
	icon = 'icons/obj/library.dmi'
	icon_state = "book"
	w_class = WEIGHT_CLASS_NORMAL
	charges = 10 //We start with max pages
	max_charges = 10
	variable_charges = FALSE

/obj/item/gun/magic/wand/book/zap_self(mob/living/user)
	to_chat(user, "The book has [charges] page\s remaining.</span>")

/obj/item/gun/magic/wand/book/attackby(obj/item/S, mob/living/user, params)
	if(!istype(S, /obj/item/paper))
		return ..()
	if(charges < max_charges)
		charges++
		recharge_newshot()
		to_chat(user, "You add a new page to [src].</span>")
		qdel(S)
		update_icon()
		process()
	else
		to_chat(user, "The [src] has no more room for pages!</span>")

//////////////////////
//Spell Book - SPARK//
//////////////////////

/obj/item/gun/magic/wand/book/spark
	name = "Spell Book of Spark"
	desc = "A spell book that fires burn pages to set the target ablaze!"
	ammo_type = /obj/item/ammo_casing/magic/book/spark
	icon_state = "spellbook_spark"

//////////////////////
//Spell Book - PAGE///
//////////////////////

/obj/item/gun/magic/wand/book/page
	name = "Spell Book of Throw"
	desc = "A spell book that throws pages at its target!"
	ammo_type = /obj/item/ammo_casing/magic/book
	icon_state = "spellbook_page"

//////////////////////
//Spell Book - SHOCK//
//////////////////////

/obj/item/gun/magic/wand/book/shock
	name = "Spell Book of Shock"
	desc = "A spell book that uses its pages to capture energy in the air and send it in a bolt at its target!"
	ammo_type = /obj/item/ammo_casing/magic/book/shock
	icon_state = "spellbook_shock"

////////////////////////
//Spell Book - HEALING//
////////////////////////

/obj/item/gun/magic/wand/book/healing
	name = "Spell Book of Mending"
	desc = "A spell book that uses its pages to heal and repair the target! The back of the book lists what it works on, and it seems to only be of flesh and of metal beings..."
	ammo_type = /obj/item/ammo_casing/magic/book/heal
	icon_state = "spellbook_healing"
