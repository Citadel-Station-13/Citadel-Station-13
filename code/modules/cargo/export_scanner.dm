/obj/item/export_scanner
	name = "export scanner"
	desc = "A device used to check objects against Nanotrasen exports and bounty database. Sadly can not scan reagents vaule."
	icon = 'icons/obj/device.dmi'
	icon_state = "export_scanner"
	item_state = "radio"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	siemens_coefficient = 1
	var/obj/machinery/computer/cargo/cargo_console = null

/obj/item/export_scanner/examine(user)
	. = ..()
	if(!cargo_console)
		. += "<span class='notice'>[src] is not currently linked to a cargo console.</span>"

/obj/item/export_scanner/afterattack(obj/O, mob/user, proximity)
	. = ..()
	if(!istype(O) || !proximity)
		return

	if(istype(O, /obj/machinery/computer/cargo))
		var/obj/machinery/computer/cargo/C = O
		if(!C.requestonly)
			cargo_console = C
			to_chat(user, "<span class='notice'>Scanner linked to [C].</span>")
	else if(!istype(cargo_console))
		to_chat(user, "<span class='warning'>You must link [src] to a cargo console first!</span>")
	else
		// Before you fix it:
		// yes, checking manifests is a part of intended functionality.

		var/datum/export_report/ex = export_item_and_contents(O, cargo_console.get_export_categories(), dry_run=TRUE)
		var/price = 0
		for(var/x in ex.total_amount)
			price += ex.total_value[x]
		for(var/x in ex.reagents_value)
			price += ex.reagents_value[x]

		if(price)
			to_chat(user, "<span class='notice'>Scanned [O], value: <b>[price]</b> credits[O.contents.len ? " (contents included)" : ""].</span>")
		else
			to_chat(user, "<span class='warning'>Scanned [O], no export value.</span>")


		if(ishuman(user))
			var/mob/living/carbon/human/scan_human = user
			if(istype(O, /obj/item/bounty_cube))
				var/obj/item/bounty_cube/cube = O

				if(!istype(get_area(cube), /area/shuttle/supply))
					to_chat(user, "<span class='warning'>Shuttle placement not detected. Handling tip not registered.</span>")

				else if(cube.bounty_handler_account)
					to_chat(user, "<span class='warning'>Bank account for handling tip already registered!</span>")

				else if(scan_human.get_bank_account() && cube.GetComponent(/datum/component/pricetag))
					var/datum/component/pricetag/pricetag = cube.GetComponent(/datum/component/pricetag)
					cube.bounty_handler_account = scan_human.get_bank_account()
					pricetag.payees[cube.bounty_handler_account] += cube.handler_tip
					cube.bounty_handler_account.bank_card_talk("Bank account for [price ? "<b>[price * cube.handler_tip]</b> credit " : ""]handling tip successfully registered.")
					cube.bounty_holder_account.bank_card_talk("<b>[cube]</b> was scanned in \the <b>[get_area(cube)]</b> by <b>[scan_human] ([scan_human.job])</b>.")
				else
					to_chat(user, "<span class='warning'>Bank account not detected. Handling tip not registered.</span>")
