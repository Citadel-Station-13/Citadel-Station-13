/datum/component/storage/concrete/pockets
	max_items = 2
	max_w_class = WEIGHT_CLASS_SMALL
	max_combined_w_class = 50
	rustle_sound = FALSE

/datum/component/storage/concrete/pockets/handle_item_insertion(obj/item/I, prevent_warning, mob/user)
	. = ..()
	if(. && silent && !prevent_warning)
		if(quickdraw)
			to_chat(user, "<span class='notice'>You discreetly slip [I] into [parent]. Alt-click [parent] to remove it.</span>")
		else
			to_chat(user, "<span class='notice'>You discreetly slip [I] into [parent].</span>")

/datum/component/storage/concrete/pockets
	max_w_class = WEIGHT_CLASS_NORMAL

/datum/component/storage/concrete/pockets/small
	max_items = 1
	attack_hand_interact = FALSE

/datum/component/storage/concrete/pockets/small/collar
	max_items = 1

/datum/component/storage/concrete/pockets/small/collar/Initialize()
	. = ..()
	can_hold = typecacheof(list(
	/obj/item/reagent_containers/food/snacks/cookie,
	/obj/item/reagent_containers/food/snacks/sugarcookie))

/datum/component/storage/concrete/pockets/small/collar/locked/Initialize()
	. = ..()
	can_hold = typecacheof(list(
	/obj/item/reagent_containers/food/snacks/cookie,
	/obj/item/reagent_containers/food/snacks/sugarcookie,
	/obj/item/key/collar))

/datum/component/storage/concrete/pockets/tiny
	max_items = 1
	max_w_class = WEIGHT_CLASS_TINY
	attack_hand_interact = FALSE

/datum/component/storage/concrete/pockets/small/detective
	attack_hand_interact = TRUE // so the detectives would discover pockets in their hats

/datum/component/storage/concrete/pockets/shoes
	attack_hand_interact = FALSE
	quickdraw = TRUE
	silent = TRUE

/datum/component/storage/concrete/pockets/shoes/Initialize()
	. = ..()
	cant_hold = typecacheof(list(/obj/item/screwdriver/power))
	can_hold = typecacheof(list(
		/obj/item/kitchen/knife, /obj/item/switchblade, /obj/item/pen, /obj/item/melee/cultblade/dagger,
		/obj/item/scalpel, /obj/item/reagent_containers/syringe, /obj/item/dnainjector,
		/obj/item/reagent_containers/hypospray/medipen, /obj/item/reagent_containers/dropper,
		/obj/item/implanter, /obj/item/screwdriver, /obj/item/weldingtool/mini,
		/obj/item/firing_pin, /obj/item/gun/ballistic/automatic/pistol, /obj/item/gun/ballistic/automatic/magrifle/pistol,
		/obj/item/toy/plush/snakeplushie, /obj/item/gun/energy/e_gun/mini, /obj/item/gun/ballistic/derringer
		))

/datum/component/storage/concrete/pockets/shoes/clown/Initialize()
	. = ..()
	cant_hold = typecacheof(list(/obj/item/screwdriver/power))
	can_hold = typecacheof(list(
		/obj/item/kitchen/knife, /obj/item/switchblade, /obj/item/pen, /obj/item/melee/cultblade/dagger,
		/obj/item/scalpel, /obj/item/reagent_containers/syringe, /obj/item/dnainjector,
		/obj/item/reagent_containers/hypospray/medipen, /obj/item/reagent_containers/dropper,
		/obj/item/implanter, /obj/item/screwdriver, /obj/item/weldingtool/mini,
		/obj/item/firing_pin, /obj/item/bikehorn, /obj/item/gun/ballistic/automatic/pistol, /obj/item/gun/energy/e_gun/mini))

/datum/component/storage/concrete/pockets/pocketprotector
	max_items = 3
	max_w_class = WEIGHT_CLASS_TINY
	var/atom/original_parent

/datum/component/storage/concrete/pockets/pocketprotector/Initialize()
	original_parent = parent
	. = ..()
	can_hold = typecacheof(list( //Same items as a PDA
		/obj/item/pen,
		/obj/item/toy/crayon,
		/obj/item/lipstick,
		/obj/item/flashlight/pen,
		/obj/item/clothing/mask/cigarette))

/datum/component/storage/concrete/pockets/pocketprotector/real_location()
	// if the component is reparented to a jumpsuit, the items still go in the protector
	return original_parent

/datum/component/storage/concrete/pockets/small/rushelmet
	max_items = 1
	quickdraw = TRUE

/datum/component/storage/concrete/pockets/small/rushelmet/Initialize()
	. = ..()
	can_hold = typecacheof(list(/obj/item/reagent_containers/glass/bottle,
								/obj/item/ammo_box/a762))

/datum/component/storage/concrete/pockets/void_cloak
	quickdraw = TRUE
	max_items = 3

/datum/component/storage/concrete/pockets/void_cloak/Initialize()
	. = ..()
	var/static/list/exception_cache = typecacheof(list(/obj/item/living_heart,/obj/item/forbidden_book))
