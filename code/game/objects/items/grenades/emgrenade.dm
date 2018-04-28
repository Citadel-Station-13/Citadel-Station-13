<<<<<<< HEAD
/obj/item/grenade/empgrenade
	name = "classic EMP grenade"
	desc = "It is designed to wreak havoc on electronic systems."
	icon_state = "emp"
	item_state = "emp"

/obj/item/grenade/empgrenade/prime()
	update_mob()
	empulse(src, 4, 10)
	qdel(src)
=======
/obj/item/grenade/empgrenade
	name = "classic EMP grenade"
	desc = "It is designed to wreak havoc on electronic systems."
	icon_state = "emp"
	item_state = "emp"

/obj/item/grenade/empgrenade/prime()
	update_mob()
	empulse(src, 4, 10)
	qdel(src)
>>>>>>> d30da79... Merge remote-tracking branch 'upstream/master' into pets
