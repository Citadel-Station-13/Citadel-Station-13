/obj/item/chameleonpaste
	name = "chameleon nanopaste"
	desc = "Nanoparticles compressed into a tube. Tap it against something to scan it, then press the button on it to open the seal, spread it on something and voila!"
	var/mode = "pick"
	icon = 'icons/obj/device.dmi'
	item_state = "nanopaste"
	icon_state = "nanopaste"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	var/intube = TRUE
	var/obj/item/chameleon = null
	var/obj/item/scanned
	var/currenticon

/obj/item/chameleonpaste/examine(mob/user)
	..()
	to_chat(user, "The scanner light is [(mode == "scan") ? "on" : "off"].")
	if (chameleon)
		to_chat(user, "<span class='notice'>Alt-click to disable the nanites on the [initial(chameleon.name)].</span>")


/obj/item/chameleonpaste/proc/hideappearance()
	if (chameleon && scanned)
		chameleon.icon = scanned.icon
		chameleon.righthand_file = scanned.righthand_file
		chameleon.lefthand_file = scanned.lefthand_file
		chameleon.item_state = scanned.item_state
		currenticon = chameleon.icon_state
		chameleon.icon_state = scanned.icon_state
		chameleon.name = scanned.name
		chameleon.desc = scanned.desc
/obj/item/chameleonpaste/proc/revealappearance()
	if (chameleon)
		chameleon.icon = initial(chameleon.icon)
		chameleon.icon_state = currenticon
		chameleon.name = initial(chameleon.name)
		chameleon.desc = initial(chameleon.desc)
		chameleon.righthand_file = initial(chameleon.righthand_file)
		chameleon.lefthand_file = initial(chameleon.lefthand_file)
		chameleon.item_state = initial(chameleon.item_state)

/obj/item/chameleonpaste/AltClick(mob/user)
	if(!user.canUseTopic(src, BE_CLOSE))
		return
	if (chameleon)
		revealappearance()
		to_chat(user, "<span class='notice'>You disable the nanites on the [chameleon].</span>")

/obj/item/chameleonpaste/afterattack(atom/target, mob/user , proximity)
	if (mode == "scan")
		if (istype(target,/obj/item) && chameleon && intube == FALSE)
			scanned = target
			hideappearance()
			addtimer(CALLBACK(src, .proc/flickeroff), rand(400,2000))
			to_chat(user, "<span class='notice'>Scanned [target].</span>")
	if (mode == "pick")
		if (intube == TRUE)
			if (istype(target,/obj/item))
				chameleon = target
				intube = FALSE
				to_chat(user, "<span class='notice'>You squirt the nanopaste onto [target].</span>")
		else
			if (target == chameleon)
				revealappearance()
				scanned = null
				intube = TRUE
				to_chat(user, "<span class='notice'>The nanopaste filters back into the tube.</span>")
			else
				to_chat(user, "<span class='warning'>The nanopaste tube is empty!</span>")

/obj/item/chameleonpaste/attack_self(mob/user)
	if (mode == "scan")
		to_chat(user, "<span class='notice'>You switch the tube to gather and spread nanopaste.</span>")
		mode = "pick"
	else
		to_chat(user, "<span class='notice'>You switch the tube to scan items.</span>")
		mode = "scan"
	if (chameleon == null && intube == FALSE)
		to_chat(user, "<span class='notice'>The tube's light flashes red as it fabricates new nanites.</span>")
		intube = TRUE

/obj/item/chameleonpaste/proc/flickeroff()
	if (intube == FALSE && scanned)
		revealappearance()
		addtimer(CALLBACK(src, .proc/flickeron), 1)

/obj/item/chameleonpaste/proc/flickeron()
	if (intube == FALSE && scanned)
		hideappearance()
		addtimer(CALLBACK(src, .proc/flickeroff), rand(400,2000))
