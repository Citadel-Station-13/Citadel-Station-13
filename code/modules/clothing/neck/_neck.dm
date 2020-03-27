/obj/item/clothing/neck
	name = "necklace"
	icon = 'icons/obj/clothing/neck.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_NECK
	strip_delay = 40
	equip_delay_other = 40

/obj/item/clothing/neck/worn_overlays(isinhands = FALSE, icon_flag, style_flags = NONE)
	. = list()
	if(!isinhands)
		if(body_parts_covered & HEAD)
			if(damaged_clothes)
				. += mutable_appearance('icons/effects/item_damage.dmi', "damagedmask")
			if(blood_DNA)
				. += mutable_appearance('icons/effects/blood.dmi', "maskblood", color = blood_DNA_to_color())

/obj/item/clothing/neck/tie
	name = "tie"
	desc = "A neosilk clip-on tie."
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "bluetie"
	item_state = ""	//no inhands
	item_color = "bluetie"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/neck/tie/blue
	name = "blue tie"
	icon_state = "bluetie"
	item_color = "bluetie"

/obj/item/clothing/neck/tie/red
	name = "red tie"
	icon_state = "redtie"
	item_color = "redtie"

/obj/item/clothing/neck/tie/black
	name = "black tie"
	icon_state = "blacktie"
	item_color = "blacktie"

/obj/item/clothing/neck/tie/horrible
	name = "horrible tie"
	desc = "A neosilk clip-on tie. This one is disgusting."
	icon_state = "horribletie"
	item_color = "horribletie"

/obj/item/clothing/neck/stethoscope
	name = "stethoscope"
	desc = "An outdated medical apparatus for listening to the sounds of the human body. It also makes you look like you know what you're doing."
	icon_state = "stethoscope"
	item_color = "stethoscope"

/obj/item/clothing/neck/stethoscope/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] puts \the [src] to [user.p_their()] chest! It looks like [user.p_they()] wont hear much!</span>")
	return OXYLOSS

/obj/item/clothing/neck/stethoscope/attack(mob/living/carbon/human/M, mob/living/user)
	if(ishuman(M) && isliving(user))
		if(user.a_intent == INTENT_HELP)
			var/body_part = parse_zone(user.zone_selected)

			var/heart_strength = "<span class='danger'>no</span>"
			var/lung_strength = "<span class='danger'>no</span>"

			var/obj/item/organ/heart/heart = M.getorganslot(ORGAN_SLOT_HEART)
			var/obj/item/organ/lungs/lungs = M.getorganslot(ORGAN_SLOT_LUNGS)

			if (!do_mob(user,M,60))	// Stethoscope should take a moment to listen
				return // FAIL
			if(!(M.stat == DEAD || (HAS_TRAIT(M, TRAIT_FAKEDEATH)) || (HAS_TRAIT(M, TRAIT_NOPULSE))))
				if(heart && istype(heart))
					heart_strength = "<span class='danger'>an unstable</span>"
					if(heart.beating)
						heart_strength = "a healthy"
				if(lungs && istype(lungs))
					lung_strength = "<span class='danger'>strained</span>"
					if(!(M.failed_last_breath || M.losebreath))
						lung_strength = "healthy"

			if(M.stat == DEAD && heart && world.time - M.timeofdeath < DEFIB_TIME_LIMIT * 10)
				heart_strength = "<span class='boldannounce'>a faint, fluttery</span>"

			var/diagnosis = (body_part == BODY_ZONE_CHEST ? "You hear [heart_strength] pulse and [lung_strength] respiration." : "You faintly hear [heart_strength] pulse.")
			user.visible_message("[user] places [src] against [M]'s [body_part] and listens attentively.", "<span class='notice'>You place [src] against [M]'s [body_part]. [diagnosis]</span>")
			return
	return ..(M,user)

///////////
//SCARVES//
///////////

/obj/item/clothing/neck/scarf //Default white color, same functionality as beanies.
	name = "white scarf"
	icon_state = "scarf"
	desc = "A stylish scarf. The perfect winter accessory for those with a keen fashion sense, and those who just can't handle a cold breeze on their necks."
	item_color = "scarf"
	dog_fashion = /datum/dog_fashion/head

/obj/item/clothing/neck/scarf/black
	name = "black scarf"
	icon_state = "scarf"
	color = "#4A4A4B" //Grey but it looks black

/obj/item/clothing/neck/scarf/pink
	name = "pink scarf"
	icon_state = "scarf"
	color = "#F699CD" //Pink

/obj/item/clothing/neck/scarf/red
	name = "red scarf"
	icon_state = "scarf"
	color = "#D91414" //Red

/obj/item/clothing/neck/scarf/green
	name = "green scarf"
	icon_state = "scarf"
	color = "#5C9E54" //Green

/obj/item/clothing/neck/scarf/darkblue
	name = "dark blue scarf"
	icon_state = "scarf"
	color = "#1E85BC" //Blue

/obj/item/clothing/neck/scarf/purple
	name = "purple scarf"
	icon_state = "scarf"
	color = "#9557C5" //Purple

/obj/item/clothing/neck/scarf/yellow
	name = "yellow scarf"
	icon_state = "scarf"
	color = "#E0C14F" //Yellow

/obj/item/clothing/neck/scarf/orange
	name = "orange scarf"
	icon_state = "scarf"
	color = "#C67A4B" //Orange

/obj/item/clothing/neck/scarf/cyan
	name = "cyan scarf"
	icon_state = "scarf"
	color = "#54A3CE" //Cyan


//Striped scarves get their own icons

/obj/item/clothing/neck/scarf/zebra
	name = "zebra scarf"
	icon_state = "zebrascarf"
	item_color = "zebrascarf"

/obj/item/clothing/neck/scarf/christmas
	name = "christmas scarf"
	icon_state = "christmasscarf"
	item_color = "christmasscarf"

//The three following scarves don't have the scarf subtype
//This is because Ian can equip anything from that subtype
//However, these 3 don't have corgi versions of their sprites
/obj/item/clothing/neck/stripedredscarf
	name = "striped red scarf"
	icon_state = "stripedredscarf"
	item_color = "stripedredscarf"

/obj/item/clothing/neck/stripedgreenscarf
	name = "striped green scarf"
	icon_state = "stripedgreenscarf"
	item_color = "stripedgreenscarf"

/obj/item/clothing/neck/stripedbluescarf
	name = "striped blue scarf"
	icon_state = "stripedbluescarf"
	item_color = "stripedbluescarf"

///////////
//COLLARS//
///////////

/obj/item/clothing/neck/petcollar
	name = "pet collar"
	desc = "It's for pets. Though you probably could wear it yourself, you'd doubtless be the subject of ridicule. It seems to be made out of a polychromic material."
	icon_state = "petcollar"
	item_color = "petcollar"
	alternate_worn_icon = 'icons/mob/neck.dmi' //Because, as it appears, the item itself is normally not directly aware of its worn overlays, so this is about the easiest way, without adding a new var.
	hasprimary = TRUE
	primary_color = "#00BBBB"
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/small/collar
	var/tagname = null

/obj/item/clothing/neck/petcollar/attack_self(mob/user)
	tagname = stripped_input(user, "Would you like to change the name on the tag?", "Name your new pet", "Spot", MAX_NAME_LEN)
	name = "[initial(name)] - [tagname]"

/obj/item/clothing/neck/petcollar/worn_overlays(isinhands, icon_file, style_flags = NONE)
	. = ..()
	if(hasprimary | hassecondary | hastertiary)
		if(!isinhands)	//prevents the worn sprites from showing up if you're just holding them
			if(hasprimary)	//checks if overlays are enabled
				var/mutable_appearance/primary_worn = mutable_appearance(alternate_worn_icon, "[item_color]-primary")	//automagical sprite selection
				primary_worn.color = primary_color	//colors the overlay
				. += primary_worn	//adds the overlay onto the buffer list to draw on the mob sprite
			if(hassecondary)
				var/mutable_appearance/secondary_worn = mutable_appearance(alternate_worn_icon, "[item_color]-secondary")
				secondary_worn.color = secondary_color
				. += secondary_worn
			if(hastertiary)
				var/mutable_appearance/tertiary_worn = mutable_appearance(alternate_worn_icon, "[item_color]-tertiary")
				tertiary_worn.color = tertiary_color
				. += tertiary_worn

/obj/item/clothing/neck/petcollar/leather
	name = "leather pet collar"
	icon_state = "leathercollar"
	item_color = "leathercollar"

	hasprimary = TRUE
	hassecondary = TRUE
	primary_color = "#222222"
	secondary_color = "#888888"

/obj/item/clothing/neck/petcollar/choker
	desc = "Quite fashionable... if you're somebody who's just read their first BDSM-themed erotica novel."
	name = "choker"
	icon_state = "choker"
	item_color = "choker"

	hasprimary = TRUE
	primary_color = "#222222"

/obj/item/clothing/neck/petcollar/locked
	name = "locked collar"
	desc = "A collar that has a small lock on it to keep it from being removed."
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/small/collar/locked
	var/lock = FALSE

/obj/item/clothing/neck/petcollar/locked/attackby(obj/item/K, mob/user, params)
	if(istype(K, /obj/item/key/collar))
		if(lock != FALSE)
			to_chat(user, "<span class='warning'>With a click the collar unlocks!</span>")
			lock = FALSE
		else
			to_chat(user, "<span class='warning'>With a click the collar locks!</span>")
			lock = TRUE
	return

/obj/item/clothing/neck/petcollar/locked/attack_hand(mob/user)
	if(loc == user && user.get_item_by_slot(SLOT_NECK) && lock != FALSE)
		to_chat(user, "<span class='warning'>The collar is locked! You'll need unlock the collar before you can take it off!</span>")
		return
	..()

/obj/item/clothing/neck/petcollar/locked/leather
	name = "leather pet collar"
	icon_state = "leathercollar"
	item_color = "leathercollar"

	hasprimary = TRUE
	hassecondary = TRUE
	primary_color = "#222222"
	secondary_color = "#888888"

/obj/item/clothing/neck/petcollar/locked/choker
	name = "choker"
	desc = "Quite fashionable... if you're somebody who's just read their first BDSM-themed erotica novel."
	icon_state = "choker"
	item_color = "choker"

	hasprimary = TRUE
	primary_color = "#222222"

/obj/item/key/collar
	name = "Collar Key"
	desc = "A key for a tiny lock on a collar or bag."

/obj/item/clothing/neck/petcollar/Initialize()
	. = ..()
	new /obj/item/reagent_containers/food/snacks/cookie(src)

/obj/item/clothing/neck/petcollar/locked/Initialize()
	. = ..()
	new /obj/item/key/collar(src)

//////////////
//DOPE BLING//
//////////////

/obj/item/clothing/neck/necklace/dope
	name = "gold necklace"
	desc = "Damn, it feels good to be a gangster."
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "bling"
	item_color = "bling"

//////////////////////////////////
//VERY SUPER BADASS NECKERCHIEFS//
//////////////////////////////////

obj/item/clothing/neck/neckerchief
	icon = 'icons/obj/clothing/masks.dmi' //In order to reuse the bandana sprite
	w_class = WEIGHT_CLASS_TINY
	var/sourceBandanaType

/obj/item/clothing/neck/neckerchief/worn_overlays(isinhands)
	. = ..()
	if(!isinhands)
		var/mutable_appearance/realOverlay = mutable_appearance('icons/mob/mask.dmi', icon_state)
		realOverlay.pixel_y = -3
		. += realOverlay

/obj/item/clothing/neck/neckerchief/AltClick(mob/user)
	. = ..()
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(C.get_item_by_slot(SLOT_NECK) == src)
			to_chat(user, "<span class='warning'>You can't untie [src] while wearing it!</span>")
			return
		if(user.is_holding(src))
			var/obj/item/clothing/mask/bandana/newBand = new sourceBandanaType(user)
			var/currentHandIndex = user.get_held_index_of_item(src)
			var/oldName = src.name
			qdel(src)
			user.put_in_hand(newBand, currentHandIndex)
			user.visible_message("You untie [oldName] back into a [newBand.name]", "[user] unties [oldName] back into a [newBand.name]")
		else
			to_chat(user, "<span class='warning'>You must be holding [src] in order to untie it!")
