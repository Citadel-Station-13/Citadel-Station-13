
//////////////////////////////////////////////
//			Aquarium Supplies				//
//////////////////////////////////////////////

/obj/item/weapon/egg_scoop
	name = "fish egg scoop"
	desc = "A small scoop to collect fish eggs with."
	icon = 'modular_citadel/icons/obj/fish_items.dmi'
	icon_state = "egg_scoop"
	slot_flags = SLOT_BELT
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7

/obj/item/weapon/fish_net
	name = "fish net"
	desc = "A tiny net to capture fish with. It's a death sentence!"
	icon = 'modular_citadel/icons/obj/fish_items.dmi'
	icon_state = "net"
	slot_flags = SLOT_BELT
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7

/obj/item/weapon/fish_net/suicide_act(mob/user)			//"A tiny net is a death sentence: it's a net and it's tiny!" https://www.youtube.com/watch?v=FCI9Y4VGCVw
	to_chat(viewers(user), "<span class='warning'>[user] places the [src.name] on top of \his head, \his fingers tangled in the netting! It looks like \he's trying to commit suicide.</span>")
	return(OXYLOSS)

/obj/item/weapon/fishfood
	name = "fish food can"
	desc = "A small can of Carp's Choice brand fish flakes. The label shows a smiling Space Carp. Probably not made of carp meat."
	icon = 'modular_citadel/icons/obj/fish_items.dmi'
	icon_state = "fish_food"
	throwforce = 1
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7

/obj/item/weapon/tank_brush
	name = "aquarium brush"
	desc = "A brush for cleaning the inside of aquariums. Contains a built-in odor neutralizer."
	icon = 'modular_citadel/icons/obj/fish_items.dmi'
	icon_state = "brush"
	slot_flags = SLOT_BELT
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7
	attack_verb = list("scrubbed", "brushed", "scraped")

/obj/item/weapon/tank_brush/suicide_act(mob/user)
	to_chat(viewers(user), "<span class='warning'>[user] is vigorously scrubbing \himself raw with the [src.name]! It looks like \he's trying to commit suicide.</span>")
	return(BRUTELOSS|FIRELOSS)

//////////////////////////////////////////////
//				Fish Items					//
//////////////////////////////////////////////

/obj/item/fish
	name = "fish"
	desc = "A generic fish"
	icon = 'modular_citadel/icons/obj/fish_items.dmi'
	icon_state = "fish"
	throwforce = 1
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 7
	force = 1
	attack_verb = list("slapped", "humiliated", "hit", "rubbed")
	hitsound = 'sound/effects/snap.ogg'

/obj/item/fish/glofish
	name = "glofish"
	desc = "A small bio-luminescent fish. Not very bright, but at least it's pretty!"
	icon_state = "glofish"

/obj/item/fish/glofish/Initialize()
		. = ..()
		set_light(2,1,"#99FF66")

/obj/item/fish/electric_eel
	name = "electric eel"
	desc = "An eel capable of producing a mild electric shock. Luckily it's rather weak out of water."
	icon_state = "electric_eel"

/obj/item/fish/shark
	name = "shark"
	desc = "Warning: Keep away from tornadoes."
	icon_state = "shark"
	hitsound = 'sound/weapons/bite.ogg'
	force = 3

/obj/item/fish/shark/attackby(var/obj/item/O, var/mob/user as mob)
	if(istype(O, /obj/item/wirecutters))
		to_chat(user, "You rip out the teeth of \the [src.name]!")
		new /obj/item/fish/toothless_shark(get_turf(src))
		new /obj/item/shard/shark_teeth(get_turf(src))
		qdel(src)
		return
	. = ..()

/obj/item/fish/toothless_shark
	name = "toothless shark"
	desc = "Looks like someone ripped it's teeth out!"
	icon_state = "shark"
	hitsound = 'sound/effects/snap.ogg'

/obj/item/shard/shark_teeth
	name = "shark teeth"
	desc = "A number of teeth, supposedly from a shark."
	icon = 'modular_citadel/icons/obj/fish_items.dmi'
	icon_state = "teeth"
	force = 2.0
	throwforce = 5.0
	materials = list()

/obj/item/fish/catfish
	name = "catfish"
	desc = "Apparently, catfish don't purr like you might have expected them to. Such a confusing name!"
	icon_state = "catfish"

/obj/item/fish/catfish/attackby(var/obj/item/O, var/mob/user as mob)
	if(O.is_sharp())
		to_chat(user, "You carefully clean and gut \the [src.name].")
		new /obj/item/reagent_containers/food/snacks/fish/catfishmeat(get_turf(src))
		new /obj/item/reagent_containers/food/snacks/fish/catfishmeat(get_turf(src))
		qdel(src)
		return
	. = ..()

/obj/item/fish/goldfish
	name = "goldfish"
	desc = "A goldfish, just like the one you never won at the county fair."
	icon_state = "goldfish"

/obj/item/fish/salmon
	name = "salmon"
	desc = "The second-favorite food of Space Bears, right behind crew members."
	icon_state = "salmon"

/obj/item/fish/salmon/attackby(var/obj/item/O, var/mob/user as mob)
	if(O.is_sharp())
		to_chat(user, "You carefully clean and gut \the [src.name].")
		new /obj/item/reagent_containers/food/snacks/fish/salmonmeat(get_turf(src))
		new /obj/item/reagent_containers/food/snacks/fish/salmonmeat(get_turf(src))
		qdel(src)
		return
	. = ..()

/obj/item/weapon/fish/babycarp
	name = "baby space carp"
	desc = "Substantially smaller than the space carp lurking outside the hull, but still unsettling."
	icon_state = "babycarp"
	hitsound = 'sound/weapons/bite.ogg'
	force = 3

/obj/item/fish/babycarp/attackby(var/obj/item/O, var/mob/user as mob)
	if(O.is_sharp())
		to_chat(user, "You carefully clean and gut \the [src.name].")
		new /obj/item/reagent_containers/food/snacks/carpmeat(get_turf(src)) //just one fillet; this is a baby, afterall.
		qdel(src)
		return
	. = ..()


/obj/item/grown/bananapeel/clownfishpeel
	name = "clown fish"
	desc = "Even underwater, you cannot escape HONKing."
	icon = 'modular_citadel/icons/obj/fish_items.dmi'
	icon_state = "clownfish"
	throwforce = 1
	force = 1
	attack_verb = list("slapped", "humiliated", "hit", "rubbed", "honked")
