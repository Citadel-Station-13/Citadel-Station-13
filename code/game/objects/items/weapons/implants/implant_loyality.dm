/obj/item/weapon/implant/mindshield
	name = "mindshield implant"
	desc = "Protects against brainwashing."
	origin_tech = "materials=2;biotech=4;programming=4"
	activated = 0

/obj/item/weapon/implant/mindshield/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Nanotrasen Employee Management Implant<BR>
				<b>Life:</b> Ten years.<BR>
				<b>Important Notes:</b> Personnel injected with this device are much more resistant to brainwashing.<BR>
				<HR>
				<b>Implant Details:</b><BR>
				<b>Function:</b> Contains a small pod of nanobots that protects the host's mental functions from manipulation.<BR>
				<b>Special Features:</b> Will prevent and cure most forms of brainwashing.<BR>
				<b>Integrity:</b> Implant will last so long as the nanobots are inside the bloodstream."}
	return dat


/obj/item/weapon/implant/mindshield/implant(mob/living/target, mob/user, silent = 0)
	if(..())
		if((target.mind in (ticker.mode.head_revolutionaries | ticker.mode.get_gang_bosses())))
			if(!silent)
				target.visible_message("<span class='warning'>[target] seems to resist the implant!</span>", "<span class='warning'>You feel something interfering with your mental conditioning, but you resist it!</span>")
			removed(target, 1)
			qdel(src)
			return 0
		if(target.mind in ticker.mode.get_gangsters())
			ticker.mode.remove_gangster(target.mind)
			if(!silent)
				target.visible_message("<span class='warning'>[src] was destroyed in the process!</span>", "<span class='notice'>You feel a sense of peace and security. You are now protected from brainwashing.</span>")
			removed(target, 1)
			qdel(src)
			return 0
		if(target.mind in ticker.mode.revolutionaries)
			ticker.mode.remove_revolutionary(target.mind)
		if(!silent)
			if(target.mind in ticker.mode.cult)
				target << "<span class='warning'>You feel something interfering with your mental conditioning, but you resist it!</span>"
			else
				target << "<span class='notice'>You feel a sense of peace and security. You are now protected from brainwashing.</span>"
		return 1
	return 0

/obj/item/weapon/implant/mindshield/removed(mob/target, silent = 0, special = 0)
	if(..())
		if(target.stat != DEAD && !silent)
			target << "<span class='boldnotice'>Your mind suddenly feels terribly vulnerable. You are no longer safe from brainwashing.</span>"
		return 1
	return 0

/obj/item/weapon/implanter/mindshield
	name = "implanter (mindshield)"

/obj/item/weapon/implanter/mindshield/New()
	imp = new /obj/item/weapon/implant/mindshield(src)
	..()
	update_icon()


/obj/item/weapon/implantcase/mindshield
	name = "implant case - 'Mindshield'"
	desc = "A glass case containing a mindshield implant."

/obj/item/weapon/implantcase/mindshield/New()
	imp = new /obj/item/weapon/implant/mindshield(src)
	..()
