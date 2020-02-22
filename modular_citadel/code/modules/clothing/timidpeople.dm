//Going to just shove all the clothing items into one .dm file.

/obj/item/clothing/suit/hooded/timid
	name = "timid woman hoodie"
	desc = "A fairly snug, warm outfit with belts wrapped around it. Looks like it is made of polychromic materials."
	icon_state = "timidwoman"
	item_color = "timidwoman"
	item_state = "timidwoman"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	armor = list("melee" = 0, "bullet" = 0, "laser" = 0,"energy" = 0, "bomb" = 0, "bio" = 10, "rad" = 0, "fire" = 0, "acid" = 0)
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter)
	hoodtype = /obj/item/clothing/head/hooded/timid
	hasprimary = TRUE
	hassecondary = TRUE
	hastertiary = TRUE
	primary_color = "#C600FF" //haha its totally original
	secondary_color = "#5E2400"
	tertiary_color = "#CEA100"
	mutantrace_variation = STYLE_DIGITIGRADE

/obj/item/clothing/suit/hooded/timid/man
	name = "timid man hoodie"
	desc = "A fairly snug, warm outfit with a belt wrapped around it. Looks like it is made of polychromic materials."
	icon_state = "timidman"
	item_color = "timidman"
	item_state = "timidman"
	hoodtype = /obj/item/clothing/head/hooded/timid/man

/obj/item/clothing/head/hooded/timid
	name = "timid woman hood"
	desc = "A hood attached to the hoodie."
	icon_state = "timidwoman"
	item_color = "timidwoman"
	item_state = "timidwoman"
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	flags_inv = HIDEHAIR|HIDEEARS

/obj/item/clothing/head/hooded/timid/man
	name = "timid man hood"
	icon_state = "timidman"
	item_color = "timidman"
	item_state = "timidman"

/obj/item/clothing/head/hooded/timid/worn_overlays(isinhands, icon_file, style_flags = NONE)	//this is where the main magic happens.
	. = ..()
	if(suit.hasprimary | suit.hassecondary)
		if(!isinhands)	//prevents the worn sprites from showing up if you're just holding them
			if(suit.hasprimary)	//checks if overlays are enabled
				var/mutable_appearance/primary_worn = mutable_appearance(icon_file, "[item_color]-primary")	//automagical sprite selection
				primary_worn.color = suit.primary_color	//colors the overlay
				. += primary_worn	//adds the overlay onto the buffer list to draw on the mob sprite.
			if(suit.hassecondary)
				var/mutable_appearance/secondary_worn = mutable_appearance(icon_file, "[item_color]-secondary")
				secondary_worn.color = suit.secondary_color
				. += secondary_worn

/obj/item/clothing/suit/hooded/timid/worn_overlays(isinhands, icon_file, style_flags = NONE)	//this is where the main magic happens.
	. = ..()
	if(hasprimary | hassecondary | hastertiary)
		if(!isinhands)	//prevents the worn sprites from showing up if you're just holding them
			if(hasprimary)	//checks if overlays are enabled
				var/mutable_appearance/primary_worn = mutable_appearance(icon_file, "[item_color]-primary[suittoggled ? "_t" : ""]")	//automagical sprite selection
				primary_worn.color = primary_color	//colors the overlay
				. += primary_worn	//adds the overlay onto the buffer list to draw on the mob sprite.
			if(hassecondary)
				var/mutable_appearance/secondary_worn = mutable_appearance(icon_file, "[item_color]-secondary[suittoggled ? "_t" : ""]")
				secondary_worn.color = secondary_color
				. += secondary_worn
			if(hastertiary)
				var/mutable_appearance/tertiary_worn = mutable_appearance(icon_file, "[item_color]-tertiary[suittoggled ? "_t" : ""]")
				tertiary_worn.color = tertiary_color
				. += tertiary_worn

/obj/item/clothing/suit/hooded/timid/AltClick(mob/user)
	. = ..()
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	if(hasprimary | hassecondary | hastertiary)
		var/choice = input(user,"polychromic thread options", "Clothing Recolor") as null|anything in list("[hasprimary ? "Primary Color" : ""]", "[hassecondary ? "Secondary Color" : ""]", "[hastertiary ? "Tertiary Color" : ""]")	//generates a list depending on the enabled overlays
		switch(choice)	//Lets the list's options actually lead to something
			if("Primary Color")
				var/primary_color_input = input(usr,"","Choose Primary Color",primary_color) as color|null	//color input menu, the "|null" adds a cancel button to it.
				if(primary_color_input)	//Checks if the color selected is NULL, rejects it if it is NULL.
					primary_color = sanitize_hexcolor(primary_color_input, desired_format=6, include_crunch=1)	//formats the selected color properly
				update_icon()	//updates the item icon
				user.regenerate_icons()	//updates the worn icon. Probably a bad idea, but it works.
			if("Secondary Color")
				var/secondary_color_input = input(usr,"","Choose Secondary Color",secondary_color) as color|null
				if(secondary_color_input)
					secondary_color = sanitize_hexcolor(secondary_color_input, desired_format=6, include_crunch=1)
				update_icon()
				user.regenerate_icons()
			if("Tertiary Color")
				var/tertiary_color_input = input(usr,"","Choose Tertiary Color",tertiary_color) as color|null
				if(tertiary_color_input)
					tertiary_color = sanitize_hexcolor(tertiary_color_input, desired_format=6, include_crunch=1)
				update_icon()
				user.regenerate_icons()
	return TRUE

/obj/item/clothing/mask/gas/timid
	name = "timid woman mask"
	desc = "Most people who wear these are not really that timid."
	clothing_flags = ALLOWINTERNALS
	icon_state = "timidwoman"
	item_state = "timidwoman"
	flags_cover = MASKCOVERSEYES
	resistance_flags = FLAMMABLE

/obj/item/clothing/mask/gas/timid/man
	name = "timid man mask"
	icon_state = "timidman"
	item_state = "timidman"

/obj/item/clothing/shoes/timid
	name = "timid woman boots"
	desc = "Ready to rock your hips back and forth? These boots have a polychromic finish."
	icon_state = "timidwoman"
	item_color = "timidwoman"
	item_state = "timidwoman"
	hasprimary = TRUE
	hassecondary = FALSE
	hastertiary = FALSE
	primary_color = "#D500FF"
	cold_protection = FEET
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT

/obj/item/clothing/shoes/timid/man
	name = "timid man shoes"
	desc = "Ready to go kart racing? These shoes have a polychromic finish."
	icon_state = "timidman"
	item_color = "timidman"
	item_state = "timidman"


/obj/item/clothing/shoes/timid/worn_overlays(isinhands, icon_file, style_flags = NONE)	//this is where the main magic happens.
	. = ..()
	if(hasprimary | hassecondary | hastertiary)
		if(!isinhands)	//prevents the worn sprites from showing up if you're just holding them
			if(hasprimary)	//checks if overlays are enabled
				var/mutable_appearance/primary_worn = mutable_appearance(icon_file, "[item_color]-primary")	//automagical sprite selection
				primary_worn.color = primary_color	//colors the overlay
				. += primary_worn	//adds the overlay onto the buffer list to draw on the mob sprite.
			if(hassecondary)
				var/mutable_appearance/secondary_worn = mutable_appearance(icon_file, "[item_color]-secondary")
				secondary_worn.color = secondary_color
				. += secondary_worn
			if(hastertiary)
				var/mutable_appearance/tertiary_worn = mutable_appearance(icon_file, "[item_color]-tertiary")
				tertiary_worn.color = tertiary_color
				. += tertiary_worn

/obj/item/clothing/shoes/timid/AltClick(mob/user)
	. = ..()
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	if(hasprimary | hassecondary | hastertiary)
		var/choice = input(user,"polychromic thread options", "Clothing Recolor") as null|anything in list("[hasprimary ? "Primary Color" : ""]", "[hassecondary ? "Secondary Color" : ""]", "[hastertiary ? "Tertiary Color" : ""]")	//generates a list depending on the enabled overlays
		switch(choice)	//Lets the list's options actually lead to something
			if("Primary Color")
				var/primary_color_input = input(usr,"","Choose Primary Color",primary_color) as color|null	//color input menu, the "|null" adds a cancel button to it.
				if(primary_color_input)	//Checks if the color selected is NULL, rejects it if it is NULL.
					primary_color = sanitize_hexcolor(primary_color_input, desired_format=6, include_crunch=1)	//formats the selected color properly
				update_icon()	//updates the item icon
				user.regenerate_icons()	//updates the worn icon. Probably a bad idea, but it works.
			if("Secondary Color")
				var/secondary_color_input = input(usr,"","Choose Secondary Color",secondary_color) as color|null
				if(secondary_color_input)
					secondary_color = sanitize_hexcolor(secondary_color_input, desired_format=6, include_crunch=1)
				update_icon()
				user.regenerate_icons()
			if("Tertiary Color")
				var/tertiary_color_input = input(usr,"","Choose Tertiary Color",tertiary_color) as color|null
				if(tertiary_color_input)
					tertiary_color = sanitize_hexcolor(tertiary_color_input, desired_format=6, include_crunch=1)
				update_icon()
				user.regenerate_icons()
	return TRUE