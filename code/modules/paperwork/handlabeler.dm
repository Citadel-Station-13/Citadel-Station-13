/obj/item/weapon/hand_labeler
	name = "hand labeler"
	desc = "A combined label printer and applicator in a portable device, designed to be easy to operate and use."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler0"
	item_state = "flight"
	var/label = null
	var/labels_left = 30
	var/mode = 0

/obj/item/weapon/hand_labeler/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is pointing \the [src] \
		at \himself. They're going to label themselves as a suicide!</span>")
	labels_left = max(labels_left - 1, 0)

	var/old_real_name = user.real_name
	user.real_name += " (suicide)"
	// no conflicts with their identification card
	for(var/atom/A in user.GetAllContents())
		if(istype(A, /obj/item/weapon/card/id))
			var/obj/item/weapon/card/id/their_card = A

			// only renames their card, as opposed to tagging everyone's
			if(their_card.registered_name != old_real_name)
				continue

			their_card.registered_name = user.real_name
			their_card.update_label()

	// NOT EVEN DEATH WILL TAKE AWAY THE STAIN
	user.mind.name += " (suicide)"

	mode = 1
	icon_state = "labeler[mode]"
	label = "suicide"

	return OXYLOSS

/obj/item/weapon/hand_labeler/afterattack(atom/A, mob/user,proximity)
	if(!proximity) return
	if(!mode)	//if it's off, give up.
		return

	if(!labels_left)
		user << "<span class='warning'>No labels left!</span>"
		return
	if(!label || !length(label))
		user << "<span class='warning'>No text set!</span>"
		return
	if(length(A.name) + length(label) > 64)
		user << "<span class='warning'>Label too big!</span>"
		return
	if(ishuman(A))
		user << "<span class='warning'>You can't label humans!</span>"
		return
	if(issilicon(A))
		user << "<span class='warning'>You can't label cyborgs!</span>"
		return

	user.visible_message("[user] labels [A] as [label].", \
						 "<span class='notice'>You label [A] as [label].</span>")
	A.name = "[A.name] ([label])"
	labels_left--


/obj/item/weapon/hand_labeler/attack_self(mob/user)
	if(!user.IsAdvancedToolUser())
		user << "<span class='warning'>You don't have the dexterity to use [src]!</span>"
		return
	mode = !mode
	icon_state = "labeler[mode]"
	if(mode)
		user << "<span class='notice'>You turn on [src].</span>"
		//Now let them chose the text.
		var/str = copytext(reject_bad_text(input(user,"Label text?","Set label","")),1,MAX_NAME_LEN)
		if(!str || !length(str))
			user << "<span class='warning'>Invalid text!</span>"
			return
		label = str
		user << "<span class='notice'>You set the text to '[str]'.</span>"
	else
		user << "<span class='notice'>You turn off [src].</span>"

/obj/item/weapon/hand_labeler/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/hand_labeler_refill))
		if(!user.unEquip(I))
			return
		user << "<span class='notice'>You insert [I] into [src].</span>"
		qdel(I)
		labels_left = initial(labels_left)
		return

/obj/item/weapon/hand_labeler/borg
	name = "cyborg-hand labeler"

/obj/item/weapon/hand_labeler/borg/afterattack(atom/A, mob/user, proximity)
	..(A, user, proximity)
	if(!isrobot(user))
		return

	var/mob/living/silicon/robot/borgy = user

	var/starting_labels = initial(labels_left)
	var/diff = starting_labels - labels_left
	if(diff)
		labels_left = starting_labels
		// 50 per label. Magical cyborg paper doesn't come cheap.
		var/cost = diff * 50

		// If the cyborg manages to use a module without a cell, they get the paper
		// for free.
		if(borgy.cell)
			borgy.cell.use(cost)

/obj/item/hand_labeler_refill
	name = "hand labeler paper roll"
	icon = 'icons/obj/bureaucracy.dmi'
	desc = "A roll of paper. Use it on a hand labeler to refill it."
	icon_state = "labeler_refill"
	item_state = "electropack"
	w_class = 1
